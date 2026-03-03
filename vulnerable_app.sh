#!/bin/bash

# Hardcoded credentials (CWE-798)
DB_PASSWORD="bash_hardcoded_pass_123"
API_KEY="bash_api_key_hardcoded_abcdef"
AWS_ACCESS_KEY_ID="AKIAIOSFODNN7SHEXAMPLE"
AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYSHEXAMPLE"
PRIVATE_TOKEN="glpat-hardcoded-gitlab-token-1234"

# Command Injection via eval (CWE-78)
function run_user_input() {
    eval "$1"                               # Arbitrary code execution
}

function process_filename() {
    local file=$1
    ls -la $file                            # Unquoted variable
}

# Insecure use of curl with user input (CWE-918 / SSRF)
function fetch_url() {
    curl -s "$1"                            # User-controlled URL
}

function download_file() {
    wget -O /tmp/output "$1"               # Unvalidated URL
}

# Path Traversal (CWE-22)
function read_config() {
    cat "/app/configs/$1"                  # No path sanitization
}

function write_log() {
    echo "$2" >> "/var/log/$1"             # Path traversal in log path
}

# Insecure temp files (CWE-377)
function create_temp() {
    TMPFILE="/tmp/app_$RANDOM"             # Predictable temp filename
    touch $TMPFILE
    echo $TMPFILE
}

# Sensitive data exposure (CWE-532)
function login() {
    echo "Logging in as $1 with password $2"  # Credentials logged
    if [ "$2" == "$DB_PASSWORD" ]; then
        echo "Login successful"
    fi
}

# Insecure permissions (CWE-732)
function setup_files() {
    chmod 777 /app/uploads               # World-writable
    chmod 777 /etc/app.conf
    umask 000                             # No file creation mask
}

# Unvalidated redirect / open redirect
function redirect() {
    echo "Location: $1"                   # Unvalidated URL
}

# Weak SSL/TLS via curl (CWE-295)
function insecure_request() {
    curl -k "https://$1"                  # Skip certificate validation
}

# World-readable sensitive file creation
function save_credentials() {
    echo "password=$DB_PASSWORD" > /etc/app_creds.txt
    echo "api_key=$API_KEY" >> /etc/app_creds.txt
    chmod 644 /etc/app_creds.txt          # World-readable credentials
}

# Hardcoded IPs and ports in script
DB_HOST="192.168.1.100"
ADMIN_PORT="22"
INTERNAL_API="http://10.0.0.5:8080/internal/admin"

# Dangerous use of $IFS manipulation
function parse_input() {
    IFS=',' read -ra PARTS <<< "$1"
    for part in "${PARTS[@]}"; do
        eval "result_$part=1"             # Eval with user data
    done
}

# Unquoted variables leading to word splitting
function process_files() {
    for f in $1; do                       # Unquoted glob
        rm -f $f                          # Unquoted rm
    done
}

# Running as root check bypassed
if [ "$EUID" -ne 0 ]; then
    sudo bash "$0" "$@"                   # Re-run as root blindly
fi

# Main
login "admin" "$DB_PASSWORD"
fetch_url "http://internal-service/admin"
run_user_input "$1"
