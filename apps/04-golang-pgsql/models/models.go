package models

import "gorm.io/gorm"

type Account struct {
	gorm.Model

	Name    string `json:"name"`
	Balance int    `json:"balance"`
}

type Transaction struct {
	gorm.Model
	AccountID       uint
	Account         Account `gorm:"foreignKey:AccountID"`
	TransactionType string
	Amount          int
}

type MessageContainer struct {
	ErrorMessage  string
	Amount        int
	AccountName   string
	Balance       int
	AccountID     uint
	BuildDate     string
	BuildVersion  string
	AvgDeposit    int
	AvgWithdraw   int
	MonthlyAvgIn  string
	MonthlyAvgOut string
	DepositLimit  int
}

type DepositRequest struct {
	AccountID uint
	Amount    int
}

type WithdrawRequest struct {
	AccountID uint
	Amount    int
}

type ManageAccountRequest struct {
	TransactionType string `json:"transaction"`
	Amount          int    `json:"amount"`
}
