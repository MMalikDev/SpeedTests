#include <stdexcept>
#include <iostream>
#include <cstdlib>
#include <chrono>

unsigned int get_value(char* key) {
    const char* value = std::getenv(key);
    try {
        return std::stoul(value);
    }
    catch (const std::exception& e) {
        return 1;
    }
}

double leibniz(size_t n) {
    double pi = 1.0;
    for (unsigned int i=2u ; i < n ; ++i) {
        double x = -1.0 + 2.0 * (i & 0x1);
        pi += (x / (2u * i - 1u));
    }
    return pi * 4;
}

int main() {
    unsigned int runs = get_value("RUNS");
    unsigned int limit = get_value("LIMIT");
    double pi = 3.1415926535897932;

    clock_t start = clock();
    for (unsigned int i=0 ; i < runs ; ++i) {
        pi = leibniz(limit);
    };
    clock_t end = clock() - start;

    double elapsed = ((double)end) / CLOCKS_PER_SEC / ((double)runs); 
    printf("Elapsed: %.2fms\t| π: %.16f\n", elapsed * 1000, pi);    
    return 0;
}
