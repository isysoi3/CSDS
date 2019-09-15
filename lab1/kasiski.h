//
// Created by Ilya Sysoi on 9/14/19.
//

#ifndef LAB1_KASISKI_H
#define LAB1_KASISKI_H
#include <string>
#include <vector>

int getKeyLength(std::string text);

std::string getKey(int keyLength, std::string text, const std::map <char ,int>& lettersFreq);

#endif //LAB1_KASISKI_H
