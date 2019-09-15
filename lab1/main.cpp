#include <iostream>
#include <fstream>
#include "vigenere.h"
#include "kasiski.h"

int main() {
    std::ifstream fin("in.txt");
    std::ofstream fout("out.txt");
    std::string keyword;
    //std::cin >> keyword;
    std::string text((std::istreambuf_iterator<char>(fin)),
                    std::istreambuf_iterator<char>());

//    std::string key = generateValidKey(keyword);
//    fout << vigenere(text, key, true);
    auto f = getKeyLength(text);
    return 0;
}