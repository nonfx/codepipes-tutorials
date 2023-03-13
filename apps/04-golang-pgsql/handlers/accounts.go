package handlers

import (
	"bytes"
	_ "embed"
	"encoding/json"
	"fmt"
	"go-sql-demo/models"
	"go-sql-demo/service"
	"io/ioutil"
	"log"
	"net/http"
	"strconv"
	"text/template"

	"github.com/gorilla/mux"
)

var (
	demoAccount *models.Account

	viewContext map[string]*template.Template

	//go:embed views/index.html
	indexFormat string

	//go:embed views/deposit.html
	depositFormat string

	//go:embed views/deposit_failure.html
	depositFailureFormat string

	//go:embed views/withdraw_failure.html
	withdrawFailureFormat string

	//go:embed views/withdraw.html
	withdrawFormat string
)

func init() {
	indexTmpl, err := template.New("index").Parse(indexFormat)
	if err != nil {
		panic(fmt.Sprintf("error parsing index template: %v", err))
	}

	depositTmpl, err := template.New("depositSuccess").Parse(depositFormat)
	if err != nil {
		panic(fmt.Sprintf("error parsing deposit success template: %v", err))
	}

	depositFailureTmpl, err := template.New("depositFailure").Parse(depositFailureFormat)
	if err != nil {
		panic(fmt.Sprintf("error parsing deposit failure template: %v", err))
	}

	withdrawFailureTmpl, err := template.New("withdrawFailure").Parse(withdrawFailureFormat)
	if err != nil {
		panic(fmt.Sprintf("error parsing withdraw failure template: %v", err))
	}

	withdrawTmpl, err := template.New("withdrawSuccess").Parse(withdrawFormat)
	if err != nil {
		panic(fmt.Sprintf("error parsing withdraw success template: %v", err))
	}

	// initialize view templates
	viewContext = map[string]*template.Template{
		"index":            indexTmpl,
		"deposit":          depositTmpl,
		"deposit_failure":  depositFailureTmpl,
		"withdraw_failure": withdrawFailureTmpl,
		"withdraw":         withdrawTmpl,
	}
}

func SetupDemoAccount() {
	res, err := service.CreateAccount(&models.Account{Name: "cpi-demo-customer", Balance: 500})
	if err != nil {
		log.Fatalf("Failed to create demo account %v", err)
	}
	demoAccount = res
}

func HomeHandler(w http.ResponseWriter, r *http.Request) {

	account, err := service.GetAccountByID(demoAccount.ID)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
	}

	writer := bytes.NewBufferString("")
	err = viewContext["index"].Execute(writer, &models.MessageContainer{AccountName: account.Name, Balance: account.Balance})
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
	}
	w.Write(writer.Bytes())
	w.WriteHeader(http.StatusOK)
}

func WithdrawHandler(w http.ResponseWriter, r *http.Request) {
	writer := bytes.NewBufferString("")
	err := viewContext["withdraw"].Execute(writer, nil)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.Write(writer.Bytes())
	w.WriteHeader(http.StatusOK)
}

func DepositHandler(w http.ResponseWriter, r *http.Request) {
	writer := bytes.NewBufferString("")
	err := viewContext["deposit"].Execute(writer, nil)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.Write(writer.Bytes())
	w.WriteHeader(http.StatusOK)
}

func WithdrawEventHandler(w http.ResponseWriter, r *http.Request) {

	amount, err := strconv.Atoi(r.FormValue("amount"))
	if err != nil {
		http.Error(w, fmt.Sprintf("invalid amount %v", r.FormValue("amount")), http.StatusBadRequest)
		return
	}

	writer := bytes.NewBufferString("")
	res, err := service.WithDraw(&models.WithdraRequest{
		AccountID: demoAccount.ID,
		Amount:    amount,
	})
	if err != nil {
		err := viewContext["withdraw_failure"].Execute(writer, res)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	} else {
		err := viewContext["index"].Execute(writer, res)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}
	w.Write(writer.Bytes())
	w.WriteHeader(http.StatusOK)
}

func DepositEventHandler(w http.ResponseWriter, r *http.Request) {

	amount, err := strconv.Atoi(r.FormValue("amount"))
	if err != nil {
		http.Error(w, fmt.Sprintf("invalid amount %v", r.FormValue("amount")), http.StatusBadRequest)
		return
	}

	writer := bytes.NewBufferString("")
	res, err := service.Deposit(&models.DepositRequest{
		AccountID: demoAccount.ID,
		Amount:    amount,
	})
	if err != nil {
		err := viewContext["deposit_failure"].Execute(writer, res)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	} else {
		err := viewContext["index"].Execute(writer, res)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}
	w.Write(writer.Bytes())
	w.WriteHeader(http.StatusOK)
}

func CreateAccountHandler(w http.ResponseWriter, r *http.Request) {
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Printf("Error reading body: %v", err)
		http.Error(w, "can't read body", http.StatusBadRequest)
		return
	}

	account := &models.Account{}
	json.Unmarshal(body, account)
	if err != nil {
		log.Printf("Error unmarshaling: %v", err)
		http.Error(w, "can't unmarshal", http.StatusBadRequest)
		return
	}

	res, err := service.CreateAccount(account)
	if err != nil {
		log.Printf("failed to create account: %v", err)
		http.Error(w, "failed to create account", http.StatusInternalServerError)
		return
	}

	b, _ := json.Marshal(res)

	w.WriteHeader(200)
	w.Write(b)
}

func ListAccountsHandler(w http.ResponseWriter, r *http.Request) {

	res, err := service.ListAccounts()
	if err != nil {
		log.Printf("failed to create account: %v", err)
		http.Error(w, "failed to create account", http.StatusInternalServerError)
		return
	}

	b, _ := json.Marshal(res)

	w.WriteHeader(200)
	w.Write(b)
}

func GetAccountHandler(w http.ResponseWriter, r *http.Request) {

	v := mux.Vars(r)["id"]
	id, err := strconv.Atoi(v)
	if err != nil {
		http.Error(w, "failed to parse account ID", http.StatusBadRequest)
		return
	}

	res, err := service.GetAccountByID(uint(id))
	if err != nil {
		log.Printf("failed to create account: %v", err)
		http.Error(w, "failed to create account", http.StatusInternalServerError)
		return
	}

	b, _ := json.Marshal(res)
	w.WriteHeader(200)
	w.Write(b)
}

func DeleteAccountHandler(w http.ResponseWriter, r *http.Request) {
	v := mux.Vars(r)["id"]
	id, err := strconv.Atoi(v)
	if err != nil {
		http.Error(w, "failed to parse account ID", http.StatusBadRequest)
		return
	}

	err = service.DeleteAccount(uint(id))
	if err != nil {
		log.Printf("failed to create account: %v", err)
		http.Error(w, "failed to create account", http.StatusInternalServerError)
		return
	}
	w.WriteHeader(200)
}
