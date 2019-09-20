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

std::string readFromFileAndDoSomeWork(std::string fileName, std::string key) {
    std::ifstream fin(fileName);
    std::string text((std::istreambuf_iterator<char>(fin)),
                     std::istreambuf_iterator<char>());

    auto encryptedText = vigenere(text, key, true);
    auto keyLength = getKeyLength(encryptedText);
    auto keyq = getKey(keyLength, encryptedText, enLettersFreq);

    fin.close();
    return keyq;
}

//in{i}.txt and key{i}.txt
void runTest(std::string inDir, std::ofstream& fout) {
    fout << "CURRENT FOLDER IS " << inDir << std::endl;
    int p = 0;
    for(int i = 0; i < 10; ++i) {
        std::ifstream fin(inDir + "key" + std::to_string(i) + ".txt");
        std::string keyword;
        std::getline(fin, keyword);
        fin.close();

        //auto key = generateValidKey(keyword);
        auto pKey = readFromFileAndDoSomeWork(inDir + "in" + std::to_string(i) + ".txt", keyword);

        if (pKey == keyword) {
            p++;
            fout << "SUCCESS ";
        } else {
            fout << "FAILED ";
        }
        fout << pKey << " and " << keyword << std::endl;


    }
    fout << "SUCCESSFULLY PASSED " << p << " FROM 10" << std::endl;
    fout << "PROBABILITY IS " << p * 1.0/10;
    fout << std::endl << std::endl;
}

void runKeyTests() {
    std::ofstream fout("../tests/out_key_tests.txt");
    runTest("../tests/key_test1/", fout);
    runTest("../tests/key_test2/", fout);
    runTest("../tests/key_test3/", fout);
    runTest("../tests/key_test4/", fout);
    runTest("../tests/key_test5/", fout);
    fout.close();
}

void runTextTests() {
    std::ofstream fout("../tests/out_text_tests.txt");
    runTest("../tests/text_test1/", fout);
    runTest("../tests/text_test2/", fout);
    runTest("../tests/text_test3/", fout);
    runTest("../tests/text_test4/", fout);
    runTest("../tests/text_test5/", fout);
    fout.close();
}

int main() {
    runKeyTests();
    runTextTests();
    return 0;
}