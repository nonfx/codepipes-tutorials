package service

import (
	"errors"
	"go-sql-demo/database"
	"go-sql-demo/models"
	"log"
	"time"
)

const (
	DepositLimit int = 5000
)

type Service interface {
	Deposit(req *models.DepositRequest) (*models.MessageContainer, error)
	WithDraw(req *models.WithdrawRequest) (*models.MessageContainer, error)
	CreateAccount(req *models.Account) (*models.Account, error)
	GetAccount(req *models.Account) (*models.Account, error)
	ListAccounts() ([]models.Account, error)
	GetAccountByID(ID uint) (*models.Account, error)
	DeleteAccount(ID uint) error
	GetMonthlyAverages(req *models.Account) (*models.MessageContainer, error)
}

type ServiceImpl struct{}

func (s *ServiceImpl) Deposit(req *models.DepositRequest) (*models.MessageContainer, error) {
	log.Printf("deposit requested %v", req.Amount)
	if req.Amount > DepositLimit {
		err := errors.New("requested deposit is greater than limit")
		log.Println(err.Error())
		return &models.MessageContainer{
			ErrorMessage: err.Error(),
			Amount:       req.Amount,
		}, err
	}

	account, err := s.GetAccountByID(req.AccountID)
	if err != nil {
		log.Println("Failed to get account: ", err.Error())
		return &models.MessageContainer{
			ErrorMessage: err.Error(),
			Amount:       req.Amount,
			AccountName:  account.Name,
			Balance:      account.Balance,
		}, err
	}
	account.Balance = account.Balance + req.Amount

	return s.updateBalance(req.Amount, account, "deposit")
}

func (s *ServiceImpl) addTransaction(req *models.Transaction) error {
	return database.DB.Db.Model(req).Save(req).Error
}

func (s *ServiceImpl) WithDraw(req *models.WithdrawRequest) (*models.MessageContainer, error) {
	log.Printf("withdrawal requested %v", req.Amount)
	account, err := s.GetAccountByID(req.AccountID)
	if err != nil {
		log.Println("Failed to get account: ", err.Error())
		return &models.MessageContainer{ErrorMessage: err.Error()}, err
	}

	if req.Amount > account.Balance {
		err = errors.New("requested withdrawal is greater than balance")
		log.Println(err.Error())
		return &models.MessageContainer{
			ErrorMessage: err.Error(),
			Amount:       req.Amount,
			AccountName:  account.Name,
			Balance:      account.Balance,
		}, err
	}

	account.Balance = account.Balance - req.Amount

	return s.updateBalance(req.Amount, account, "withdraw")
}

func (s *ServiceImpl) updateBalance(amount int, account *models.Account, transactionType string) (*models.MessageContainer, error) {
	err := database.DB.Db.Model(account).Save(account).Error
	if err != nil {
		log.Println("Failed to update: ", err.Error())
		return &models.MessageContainer{
			ErrorMessage: err.Error(),
			Amount:       amount,
			AccountName:  account.Name,
			Balance:      account.Balance,
		}, err
	}

	s.addTransaction(&models.Transaction{
		AccountID:       account.ID,
		TransactionType: transactionType,
		Amount:          amount,
	})

	return &models.MessageContainer{
		Amount:      amount,
		AccountName: account.Name,
		Balance:     account.Balance,
	}, nil
}

func (s *ServiceImpl) CreateAccount(req *models.Account) (*models.Account, error) {
	err := database.DB.Db.Create(req).Error
	if err != nil {
		return nil, err
	}
	return req, nil
}

func (s *ServiceImpl) GetAccount(req *models.Account) (*models.Account, error) {
	account := &models.Account{}
	err := database.DB.Db.Find(account, req).Error
	if err != nil {
		return nil, err
	}
	return req, nil
}

func (s *ServiceImpl) ListAccounts() ([]models.Account, error) {
	accounts := []models.Account{}
	err := database.DB.Db.Find(&accounts).Error
	if err != nil {
		return nil, err
	}
	return accounts, nil
}

func (s *ServiceImpl) GetAccountByID(ID uint) (*models.Account, error) {
	account := &models.Account{}
	account.ID = ID
	err := database.DB.Db.Find(&account, account).Error
	if err != nil {
		return nil, err
	}
	return account, nil
}

func (s *ServiceImpl) DeleteAccount(ID uint) error {
	account := &models.Account{}
	account.ID = ID
	return database.DB.Db.Delete(&models.Account{}, account).Error
}

func (s *ServiceImpl) GetMonthlyAverages(req *models.Account) (*models.MessageContainer, error) {
	thirtyDaysAgo := time.Now().AddDate(0, 0, -30)
	transactions := []models.Transaction{}
	err := database.DB.Db.Where(&models.Transaction{AccountID: req.ID}).Where("created_at >= ?", thirtyDaysAgo).Find(&transactions).Error
	if err != nil {
		return nil, err
	}
	var deposit, send int
	for _, tr := range transactions {
		if tr.TransactionType == "deposit" {
			deposit = deposit + tr.Amount
		} else {
			send = send + tr.Amount
		}
	}

	return &models.MessageContainer{
		AvgWithdraw: send / 30,
		AvgDeposit:  deposit / 30,
	}, nil
}
