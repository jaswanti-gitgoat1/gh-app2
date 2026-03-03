#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI;

# Hardcoded credentials (CWE-798)
my $DB_PASS   = "perl_hardcoded_pass_123";
my $API_KEY   = "perl_api_key_hardcoded_abcdef";
my $SECRET    = "perl_secret_key_never_rotate";

my $cgi = CGI->new;

# SQL Injection (CWE-89)
sub get_user {
    my ($username) = @_;
    my $dbh = DBI->connect("dbi:mysql:mydb", "root", $DB_PASS);
    my $query = "SELECT * FROM users WHERE username = '$username'";
    return $dbh->selectall_arrayref($query);
}

sub search_records {
    my ($term) = @_;
    my $dbh = DBI->connect("dbi:mysql:mydb", "root", $DB_PASS);
    $dbh->do("SELECT * FROM records WHERE name LIKE '%$term%'");
}

# Command Injection (CWE-78)
sub ping_host {
    my ($host) = @_;
    system("ping -c 1 $host");              # Unsanitized
}

sub run_command {
    my ($cmd) = @_;
    return `$cmd`;                          # Backtick execution
}

sub list_files {
    my ($dir) = @_;
    return qx{ls $dir};                    # Shell injection
}

# Path Traversal (CWE-22)
sub read_file {
    my ($filename) = @_;
    open(my $fh, "<", "/var/app/$filename") or die;
    return do { local $/; <$fh> };
}

# XSS (CWE-79)
sub greet_user {
    my ($name) = $cgi->param("name");
    print "<h1>Hello $name</h1>";           # No encoding
}

sub show_results {
    my $q = $cgi->param("q");
    print "<p>Results for: $q</p>";
}

# Insecure eval (CWE-95)
sub calculate {
    my ($expr) = @_;
    return eval($expr);                     # Arbitrary code execution
}

# Weak cryptography - use of crypt() with DES (CWE-326)
sub hash_password {
    my ($password) = @_;
    return crypt($password, "salt");        # DES-based, weak
}

# Sensitive data in logs (CWE-532)
sub login {
    my ($user, $pass) = @_;
    warn "Login: user=$user pass=$pass\n";  # Credentials in logs
    return $pass eq $DB_PASS;
}

# Open redirect (CWE-601)
sub redirect_user {
    my $url = $cgi->param("url");
    print $cgi->redirect($url);             # Unvalidated redirect
}

# Insecure temp file (CWE-377)
sub create_temp {
    my $tmpfile = "/tmp/app_$$";            # Predictable temp file
    open(my $fh, ">", $tmpfile);
    return $fh;
}

# File inclusion (CWE-98)
sub include_module {
    my ($module) = $cgi->param("module");
    require $module;                        # Remote file inclusion risk
}

# LDAP Injection (CWE-90)
sub ldap_search {
    my ($username) = @_;
    my $filter = "uid=$username";           # Unsanitized LDAP filter
    # $ldap->search(filter => $filter);
    return $filter;
}

# Main execution
my $username = $cgi->param("username") || "admin' OR '1'='1";
get_user($username);
ping_host($cgi->param("host") || "localhost");
calculate($cgi->param("expr") || "1+1");
