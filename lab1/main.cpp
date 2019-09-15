#include <iostream>
#include <fstream>
#include <map>
#include "vigenere.h"
#include "kasiski.h"

std::map <char ,int> enLettersFreq = {
        {'A', 0.08167},
        {'B', 0.01492},
        {'C', 0.02782},
        {'D', 0.04253},
        {'E', 0.12702},
        {'F', 0.0228},
        {'G', 0.02015},
        {'H', 0.06094},
        {'I', 0.06966},
        {'J', 0.00153},
        {'K', 0.00772},
        {'L', 0.04025},
        {'M', 0.02406},
        {'N', 0.06749},
        {'O', 0.07507},
        {'P', 0.01929},
        {'Q', 0.00095},
        {'R', 0.05987},
        {'S', 0.06327},
        {'T', 0.09056},
        {'U', 0.02758},
        {'V', 0.00978},
        {'W', 0.0236},
        {'X', 0.0015},
        {'Y', 0.01974},
        {'Z', 0.00074}
};

int main() {
    std::ifstream fin("in.txt");
    std::ofstream fout("out.txt");
    std::string keyword;
    std::cin >> keyword;
    std::string text((std::istreambuf_iterator<char>(fin)),
                    std::istreambuf_iterator<char>());

    auto key = generateValidKey(keyword);
    auto encryptedText = vigenere(text, key, true);
    fout << text;
    fout << encryptedText;

    auto keyLength = getKeyLength(encryptedText);
    auto keyq = getKey(keyLength, encryptedText, enLettersFreq);
    fout << vigenere(encryptedText, keyq, false);

    fin.close();
    fout.close();
    return 0;
}