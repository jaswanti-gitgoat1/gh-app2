import os
import subprocess
import sqlite3
import pickle
import hashlib
import yaml
import xml.etree.ElementTree as ET
import random
import tempfile

# Hardcoded credentials (CWE-798)
DB_PASSWORD = "supersecret123"
AWS_ACCESS_KEY = "AKIAIOSFODNN7EXAMPLE"
AWS_SECRET_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
SECRET_TOKEN = "ghp_hardcodedGitHubToken1234567890abcdef"

# SQL Injection (CWE-89)
def get_user(username):
    conn = sqlite3.connect("users.db")
    cursor = conn.cursor()
    query = "SELECT * FROM users WHERE username = '" + username + "'"
    cursor.execute(query)
    return cursor.fetchall()

def get_order(order_id):
    conn = sqlite3.connect("orders.db")
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM orders WHERE id = %s" % order_id)
    return cursor.fetchall()

# Command Injection (CWE-78)
def ping_host(host):
    os.system("ping -c 1 " + host)

def run_command(cmd):
    subprocess.call(cmd, shell=True)

def list_files(directory):
    return os.popen("ls " + directory).read()

# Path Traversal (CWE-22)
def read_file(filename):
    with open("/var/app/" + filename, "r") as f:
        return f.read()

def download_file(path):
    base = "/uploads/"
    return open(base + path).read()

# Insecure Deserialization (CWE-502)
def load_data(data):
    return pickle.loads(data)

def load_user_object(serialized):
    return pickle.loads(serialized)

# XSS - reflected (CWE-79)
def render_page(user_input):
    return "<html><body>" + user_input + "</body></html>"

def greet_user(name):
    return f"<h1>Hello {name}</h1>"

# Weak cryptography (CWE-326, CWE-327)
def hash_password(password):
    return hashlib.md5(password.encode()).hexdigest()

def encrypt_data(data):
    return hashlib.sha1(data.encode()).hexdigest()

# XML External Entity (XXE) (CWE-611)
def parse_xml(xml_string):
    return ET.fromstring(xml_string)

def load_config(xml_file):
    tree = ET.parse(xml_file)
    return tree.getroot()

# Insecure random for security use (CWE-330)
def generate_session_token():
    return str(random.randint(0, 999999))

def generate_reset_token():
    return hex(random.getrandbits(64))

# YAML deserialization (CWE-502)
def load_yaml_config(data):
    return yaml.load(data)  # unsafe load

# Insecure temp file (CWE-377)
def create_temp():
    return tempfile.mktemp()

# Open redirect (CWE-601)
def redirect_user(url):
    return f"Location: {url}"

# Sensitive data in logs (CWE-532)
def login(user, password):
    print(f"Login attempt: user={user} password={password}")
    return password == DB_PASSWORD

# SSRF (CWE-918)
def fetch_url(url):
    import urllib.request
    return urllib.request.urlopen(url).read()

# Eval injection (CWE-95)
def calculate(expression):
    return eval(expression)

def run_code(code):
    exec(code)

# Integer overflow-like logic
def allocate_buffer(size):
    return bytearray(size * 1024 * 1024 * 1024)

if __name__ == "__main__":
    get_user("admin' OR '1'='1")
    ping_host("google.com; rm -rf /")
    read_file("../../etc/passwd")
    print(hash_password("password"))
    print(generate_session_token())
    calculate("__import__('os').system('id')")
