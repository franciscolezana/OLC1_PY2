package main

import (
	"fmt"
	"html/template"
	"io/ioutil"
	"net/http"
)

func index(w http.ResponseWriter, r *http.Request) {
	t := template.Must(template.ParseFiles("index.html"))
	t.Execute(w, "")

	data, err := ioutil.ReadFile("primero.java")
	if err != nil {
		fmt.Println("File reading error", err)
		return
	}
	fmt.Println("Contents of file:", string(data))
}

func uploadFile(w http.ResponseWriter, r *http.Request) {
	data, err := ioutil.ReadFile("/home/naveen/Documents/filehandling/test.txt")
	if err != nil {
		fmt.Println("File reading error", err)
		return
	}
	fmt.Println("Contents of file:", string(data))
}

func main() {

	/*file := "test.txt"
	content, err := ioutil.ReadFile(file)

	if err != nil {
		log.Fatalf("file not found")
	}*/

	http.Handle("/css/", http.StripPrefix("/css/", http.FileServer(http.Dir("css/"))))
	http.Handle("/fonts/", http.StripPrefix("/fonts/", http.FileServer(http.Dir("fonts/"))))
	http.Handle("/js/", http.StripPrefix("/js/", http.FileServer(http.Dir("js/"))))

	http.HandleFunc("/upload", uploadFile)
	http.HandleFunc("/", index)

	fmt.Printf("Servidor escuchando en: http://localhost:8000/")
	http.ListenAndServe(":8000", nil)
}
