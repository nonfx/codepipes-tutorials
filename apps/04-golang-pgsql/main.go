package main

import (
	"go-sql-demo/database"
	"go-sql-demo/handlers"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

func main() {

	database.ConnectDb()

	// initialize router
	r := setupRoutes()
	handlers.SetupDemoAccount()
	log.Println("Server listening on port 3000...!!")
	log.Fatal(http.ListenAndServe(":3000", r))
}

func setupRoutes() *mux.Router {
	r := mux.NewRouter()
	r.HandleFunc("/", handlers.HomeHandler)
	r.HandleFunc("/withdraw", handlers.WithdrawHandler).Methods(http.MethodGet)
	r.HandleFunc("/deposit", handlers.DepositHandler).Methods(http.MethodGet)
	r.HandleFunc("/withdraw-event", handlers.WithdrawEventHandler).Methods(http.MethodPost)
	r.HandleFunc("/deposit-event", handlers.DepositEventHandler).Methods(http.MethodPost)
	r.HandleFunc("/accounts", handlers.CreateAccountHandler).Methods(http.MethodPost)
	r.HandleFunc("/accounts", handlers.ListAccountsHandler).Methods(http.MethodGet)
	r.HandleFunc("/accounts/{id}", handlers.GetAccountHandler).Methods(http.MethodGet)
	r.HandleFunc("/accounts/{id}", handlers.DeleteAccountHandler).Methods(http.MethodDelete)
	http.Handle("/", r)
	return r
}
