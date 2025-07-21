# services/webserver-service/main.go
package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "StyleStack Webserver Service")
	})
	http.ListenAndServe(":8080", nil)
}