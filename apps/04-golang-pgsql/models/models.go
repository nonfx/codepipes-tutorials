package models

import "gorm.io/gorm"

type Account struct {
	gorm.Model

	Name    string `json:"name"`
	Balance int    `json:"balance"`
}

type MessageContainer struct {
	ErrorMessage string
	Amount       int
	AccountName  string
	Balance      int
	BuildDate    string
	BuildVersion string
}

type DepositRequest struct {
	AccountID uint
	Amount    int
}

type WithdraRequest struct {
	AccountID uint
	Amount    int
}
