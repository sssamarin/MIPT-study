#!/usr/bin/bc -q
define fibo(n) {
    if (x <= 2) return n;
    a = 0;
    b = 1;
    for (i = 1; i < n; i++) {
        c = a+b; a = b; b = c;
    }
    return c}
fibo(1000)
quit
