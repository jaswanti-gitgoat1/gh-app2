#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// Hardcoded credentials (CWE-798)
#define DB_PASSWORD "c_hardcoded_pass_123"
#define SECRET_KEY  "c_secret_key_abcdef"

// Buffer Overflow (CWE-121, CWE-122)
void copy_input(char *input) {
    char buf[64];
    strcpy(buf, input);  // No bounds checking
    printf("Input: %s\n", buf);
}

void read_username(char *output) {
    gets(output);  // Dangerous: no bounds checking
}

void process_data(char *data, int len) {
    char buffer[128];
    memcpy(buffer, data, len);  // len not validated
}

// Format String Vulnerability (CWE-134)
void log_message(char *message) {
    printf(message);  // User-controlled format string
}

void print_input(char *input) {
    fprintf(stdout, input);  // Format string injection
}

// Integer Overflow (CWE-190)
int allocate_buffer(int size) {
    int total = size * sizeof(int);  // Can overflow
    return total;
}

unsigned int calc_size(unsigned short a, unsigned short b) {
    return a * b;  // Integer overflow possible
}

// Use After Free (CWE-416)
void use_after_free() {
    char *ptr = (char *)malloc(64);
    free(ptr);
    strcpy(ptr, "use after free");  // Undefined behavior
}

// Double Free (CWE-415)
void double_free() {
    char *buf = (char *)malloc(128);
    free(buf);
    free(buf);  // Double free
}

// Null Pointer Dereference (CWE-476)
void null_deref(char *ptr) {
    printf("%s\n", ptr);  // No null check
    strcpy(ptr, "data");
}

// Command Injection (CWE-78)
void ping_host(char *host) {
    char cmd[256];
    sprintf(cmd, "ping -c 1 %s", host);
    system(cmd);  // Command injection
}

void run_command(char *input) {
    char buf[512];
    snprintf(buf, sizeof(buf), "ls %s", input);
    system(buf);
}

// Path Traversal (CWE-22)
void read_file(char *filename) {
    char path[256];
    sprintf(path, "/var/app/%s", filename);
    FILE *f = fopen(path, "r");
    if (f) {
        char buf[1024];
        fread(buf, 1, sizeof(buf), f);
        fclose(f);
    }
}

// Off-by-one error (CWE-193)
void off_by_one(char *input) {
    char buf[10];
    for (int i = 0; i <= 10; i++) {  // Should be i < 10
        buf[i] = input[i];
    }
}

// Stack-based buffer overflow
void vulnerable_function(char *str) {
    char buffer[100];
    sprintf(buffer, str);  // Unsafe sprintf
}

// Uninitialized variable (CWE-457)
void uninitialized() {
    int x;
    printf("%d\n", x);  // Uninitialized read
}

int main(int argc, char *argv[]) {
    if (argc > 1) {
        copy_input(argv[1]);
        ping_host(argv[1]);
        read_file(argv[1]);
        log_message(argv[1]);
    }
    return 0;
}
