package main

import (
	"crypto/md5"
	"database/sql"
	"fmt"
	"io/ioutil"
	"math/rand"
	"net/http"
	"os"
	"os/exec"
)

// Hardcoded credentials (CWE-798)
const DBPassword = "go_hardcoded_pass_123"
const AWSKey = "AKIAIOSFODNN7GOEXAMPLE"
const AWSSecret = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYGOEXAMPLE"

// SQL Injection (CWE-89)
func getUser(db *sql.DB, username string) {
	query := "SELECT * FROM users WHERE username = '" + username + "'"
	db.Query(query)
}

func getOrder(db *sql.DB, orderID string) {
	db.Query(fmt.Sprintf("SELECT * FROM orders WHERE id = %s", orderID))
}

// Command Injection (CWE-78)
func pingHost(host string) {
	exec.Command("sh", "-c", "ping -c 1 "+host).Run()
}

func runScript(script string) {
	cmd := exec.Command("/bin/bash", "-c", script)
	cmd.Run()
}

// Path Traversal (CWE-22)
func readFile(filename string) ([]byte, error) {
	return ioutil.ReadFile("/var/app/" + filename)
}

func serveFile(w http.ResponseWriter, r *http.Request) {
	path := r.URL.Query().Get("file")
	data, _ := os.ReadFile("/uploads/" + path)
	w.Write(data)
}

// Weak cryptography (CWE-326)
func hashPassword(password string) string {
	h := md5.New()
	h.Write([]byte(password))
	return fmt.Sprintf("%x", h.Sum(nil))
}

// Insecure random (CWE-330)
func generateToken() int {
	return rand.Intn(999999)
}

func generateOTP() string {
	return fmt.Sprintf("%04d", rand.Intn(10000))
}

// SSRF (CWE-918)
func fetchURL(w http.ResponseWriter, r *http.Request) {
	url := r.URL.Query().Get("url")
	resp, _ := http.Get(url)
	body, _ := ioutil.ReadAll(resp.Body)
	w.Write(body)
}

// XSS (CWE-79)
func greetUser(w http.ResponseWriter, r *http.Request) {
	name := r.URL.Query().Get("name")
	fmt.Fprintf(w, "<h1>Hello %s</h1>", name)
}

// Sensitive data in logs (CWE-532)
func login(user, password string) bool {
	fmt.Printf("Login attempt: user=%s password=%s\n", user, password)
	return password == DBPassword
}

// Open redirect (CWE-601)
func redirectHandler(w http.ResponseWriter, r *http.Request) {
	url := r.URL.Query().Get("url")
	http.Redirect(w, r, url, http.StatusFound)
}

// Nil pointer dereference (CWE-476)
func getLength(s *string) int {
	return len(*s)
}

func main() {
	http.HandleFunc("/fetch", fetchURL)
	http.HandleFunc("/greet", greetUser)
	http.HandleFunc("/redirect", redirectHandler)
	http.HandleFunc("/file", serveFile)
	http.ListenAndServe(":8080", nil)
}
