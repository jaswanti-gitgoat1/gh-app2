require 'open3'
require 'digest'
require 'yaml'
require 'net/http'
require 'sqlite3'
require 'json'

# Hardcoded credentials (CWE-798)
DB_PASSWORD = "ruby_hardcoded_pass_123"
AWS_KEY = "AKIAIOSFODNN7RBEXAMPLE"
STRIPE_SECRET = "sk_live_hardcoded_stripe_key_1234567890"

# SQL Injection (CWE-89)
def get_user(username)
  db = SQLite3::Database.new("users.db")
  db.execute("SELECT * FROM users WHERE username = '#{username}'")
end

def get_order(id)
  db = SQLite3::Database.new("orders.db")
  db.execute("SELECT * FROM orders WHERE id = " + id)
end

def delete_record(table, id)
  db = SQLite3::Database.new("app.db")
  db.execute("DELETE FROM #{table} WHERE id = #{id}")
end

# Command Injection (CWE-78)
def ping_host(host)
  system("ping -c 1 #{host}")
end

def run_command(cmd)
  `#{cmd}`
end

def list_files(dir)
  Open3.capture2("ls #{dir}")
end

# Path Traversal (CWE-22)
def read_file(filename)
  File.read("/var/app/#{filename}")
end

def write_file(path, content)
  File.write("/uploads/#{path}", content)
end

# Weak cryptography (CWE-326)
def hash_password(password)
  Digest::MD5.hexdigest(password)
end

def weak_hash(data)
  Digest::SHA1.hexdigest(data)
end

# Insecure deserialization (CWE-502)
def load_object(data)
  Marshal.load(data)
end

def load_yaml_config(data)
  YAML.load(data)  # unsafe, allows object instantiation
end

# Insecure random (CWE-330)
def generate_token
  rand(999999).to_s
end

def generate_otp
  rand(9000) + 1000
end

# SSRF (CWE-918)
def fetch_url(url)
  Net::HTTP.get(URI(url))
end

# XSS (CWE-79)
def greet_user(name)
  "<h1>Hello #{name}</h1>"
end

# Open redirect (CWE-601)
def redirect_to(url)
  "Location: #{url}"
end

# Code injection via eval (CWE-95)
def calculate(expression)
  eval(expression)
end

def run_code(code)
  eval(code)
end

# Sensitive data in logs (CWE-532)
def login(user, password)
  puts "Login attempt: user=#{user} password=#{password}"
  password == DB_PASSWORD
end

# RegEx DoS (CWE-1333)
def validate_email(email)
  email.match(/^([a-zA-Z0-9])+([a-zA-Z0-9\._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9\._-]+)+$/)
end

# Mass assignment vulnerability
def update_user(params)
  User.update(params)  # All params passed directly
end

get_user("admin' OR '1'='1'--")
ping_host("google.com; cat /etc/passwd")
read_file("../../etc/shadow")
puts hash_password("password")
puts calculate("system('id')")
