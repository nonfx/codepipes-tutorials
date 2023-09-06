package handlers

import (
	"bytes"
	_ "embed"
	"encoding/json"
	"fmt"
	"go-sql-demo/build"
	"go-sql-demo/models"
	"go-sql-demo/service"
	"io/ioutil"
	"log"
	"net/http"
	"text/template"
)

var (
	bankService service.Service

	demoAccount *models.Account

	viewContext map[string]*template.Template

	//go:embed views/index.html
	indexFormat string
)

func SetBankService(s service.Service) {
	bankService = s
}

func SetDemoAccount(acc *models.Account) {
	demoAccount = acc
}

func init() {
	indexTmpl, err := template.New("index").Parse(indexFormat)
	if err != nil {
		panic(fmt.Sprintf("error parsing index template: %v", err))
	}

	// initialize view templates
	viewContext = map[string]*template.Template{
		"index": indexTmpl,
	}
	bankService = &service.ServiceImpl{}
}

func SetupDemoAccount() {
	res, err := bankService.CreateAccount(&models.Account{Name: "cpi-demo-customer", Balance: 500})
	if err != nil {
		log.Fatalf("Failed to create demo account %v", err)
	}
	demoAccount = res
}

func HomeHandler(w http.ResponseWriter, r *http.Request) {

	account, err := bankService.GetAccountByID(demoAccount.ID)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	res := &models.MessageContainer{
		AccountName:  account.Name,
		Balance:      account.Balance,
		BuildDate:    build.Date,
		BuildVersion: build.Version,
		AccountID:    account.ID,
		DepositLimit: service.DepositLimit,
	}

	addMonthlyAverages(res, account)
	if res.AvgDeposit == 0 {
		res.MonthlyAvgIn = "NA"
	} else {
		res.MonthlyAvgIn = fmt.Sprintf("$ %v", res.AvgDeposit)
	}
	if res.AvgWithdraw == 0 {
		res.MonthlyAvgOut = "NA"
	} else {
		res.MonthlyAvgOut = fmt.Sprintf("$ %v", res.AvgWithdraw)
	}

	writer := bytes.NewBufferString("")
	err = viewContext["index"].Execute(writer, res)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
	}
	w.Write(writer.Bytes())
	w.WriteHeader(http.StatusOK)
}

func FundHandler(w http.ResponseWriter, r *http.Request) {

	var amount int
	var res *models.MessageContainer
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Printf("Error reading body: %v", err)
		http.Error(w, "can't read body", http.StatusBadRequest)
		return
	}
	m := &models.ManageAccountRequest{}
	err = json.Unmarshal(body, m)
	if err != nil {
		log.Printf("Error unmarshaling body: %v", err)
		http.Error(w, "can't unmarshal body", http.StatusBadRequest)
		return
	}
	amount = m.Amount

	if m.TransactionType == "deposit" {
		res, err = bankService.Deposit(&models.DepositRequest{
			AccountID: demoAccount.ID,
			Amount:    amount,
		})
	} else {
		res, err = bankService.WithDraw(&models.WithdrawRequest{
			AccountID: demoAccount.ID,
			Amount:    amount,
		})
	}
	if err != nil {
		log.Printf("failed to %s : %v", m.TransactionType, err)
		http.Error(w, fmt.Sprintf("failed to %s : %v", m.TransactionType, err), http.StatusInternalServerError)
		return
	}

	account, err := bankService.GetAccountByID(demoAccount.ID)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	res.AccountName = account.Name
	res.Balance = account.Balance
	res.BuildDate = build.Date
	res.BuildVersion = build.Version
	res.AccountID = account.ID

	// res = addMonthlyAverages(res, account)

	b, _ := json.Marshal(res)
	w.Header().Add("Content-Type", "application/json")
	w.Write(b)
	w.WriteHeader(http.StatusOK)
}

func addMonthlyAverages(res *models.MessageContainer, account *models.Account) *models.MessageContainer {
	response, err := bankService.GetMonthlyAverages(account)
	if err != nil {
		return res
	}
	res.AvgDeposit = response.AvgDeposit
	res.AvgWithdraw = response.AvgWithdraw
	return res
}
