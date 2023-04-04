package handlers

import (
	"encoding/json"
	"go-sql-demo/models"
	"io/ioutil"
	"log"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

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

	res, err := bankService.CreateAccount(account)
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

	res, err := bankService.ListAccounts()
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

	res, err := bankService.GetAccountByID(uint(id))
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

	err = bankService.DeleteAccount(uint(id))
	if err != nil {
		log.Printf("failed to create account: %v", err)
		http.Error(w, "failed to create account", http.StatusInternalServerError)
		return
	}
	w.WriteHeader(200)
}
