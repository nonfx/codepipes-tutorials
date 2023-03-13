package service

import (
	"errors"
	"go-sql-demo/database"
	"go-sql-demo/models"
	"log"
)

const (
	depositLimit int = 5000
)

func Deposit(req *models.DepositRequest) (*models.MessageContainer, error) {

	if req.Amount > depositLimit {
		err := errors.New("requested deposit is greater than limit")
		log.Println(err.Error())
		return &models.MessageContainer{
			ErrorMessage: err.Error(),
			Amount:       req.Amount,
		}, err
	}

	account, err := GetAccountByID(req.AccountID)
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

	err = database.DB.Db.Model(account).Save(account).Error
	if err != nil {
		log.Println("Failed to update: ", err.Error())
		return &models.MessageContainer{
			ErrorMessage: err.Error(),
			Amount:       req.Amount,
			AccountName:  account.Name,
			Balance:      account.Balance,
		}, err
	}

	return &models.MessageContainer{
		Amount:      req.Amount,
		AccountName: account.Name,
		Balance:     account.Balance,
	}, nil
}

func WithDraw(req *models.WithdraRequest) (*models.MessageContainer, error) {
	account, err := GetAccountByID(req.AccountID)
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

	err = database.DB.Db.Model(account).Save(account).Error
	if err != nil {
		log.Println("Failed to update: ", err.Error())
		return &models.MessageContainer{
			ErrorMessage: err.Error(),
			Amount:       req.Amount,
			AccountName:  account.Name,
			Balance:      account.Balance,
		}, err
	}

	return &models.MessageContainer{
		Amount:      req.Amount,
		AccountName: account.Name,
		Balance:     account.Balance,
	}, nil
}

func CreateAccount(req *models.Account) (*models.Account, error) {
	err := database.DB.Db.Create(req).Error
	if err != nil {
		return nil, err
	}
	return req, nil
}

func GetAccount(req *models.Account) (*models.Account, error) {
	account := &models.Account{}
	err := database.DB.Db.Find(account, req).Error
	if err != nil {
		return nil, err
	}
	return req, nil
}

func ListAccounts() ([]models.Account, error) {
	accounts := []models.Account{}
	err := database.DB.Db.Find(&accounts).Error
	if err != nil {
		return nil, err
	}
	return accounts, nil
}

func GetAccountByID(ID uint) (*models.Account, error) {
	account := &models.Account{}
	account.ID = ID
	err := database.DB.Db.Find(&account, account).Error
	if err != nil {
		return nil, err
	}
	return account, nil
}

func DeleteAccount(ID uint) error {
	account := &models.Account{}
	account.ID = ID
	return database.DB.Db.Delete(&models.Account{}, account).Error
}
