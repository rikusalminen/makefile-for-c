#include <stdio.h>
#include <bar/bar.h>
#include <foo.h>

int main(int argc, char *argv[]) { (void)argc; (void)argv; return foo(bar(0)); }
