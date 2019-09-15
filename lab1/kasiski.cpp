//
// Created by Ilya Sysoi on 9/15/19.
//

#include <map>
#include <unordered_map>
#include "kasiski.h"

std::string filterText(std::string text) {
    std::string filteredText;
    for (char c : text) {
        char newC = toupper(c);
        if (isalpha(newC)) {
            filteredText.push_back(newC);
        }
    }
    return filteredText;
}

int gcd(int a, int b) {
    if (a == 0)
        return b;
    return gcd(b % a, a);
}


int findGCD(std::vector<int> vector) {
    int result = vector.front();
    for(auto it = vector.begin() + 1; it != vector.end(); ++it) {
       result = gcd(*it, result);
    }
    return result;
}

int getKeyLength(std::string text) {
    std::unordered_map<std::string, std::vector<int>> map;

    std::string filteredText = filterText(text);
    for(int i = 0; i < filteredText.length(); ++i) {
        auto currentGramm = std::string(&filteredText[i], &filteredText[i] + 3);
        for(int j = i + 3; j < filteredText.length() - 3; ++j) {
            auto tmpGramm = std::string(&filteredText[j], &filteredText[j] + 3);
            if (currentGramm == tmpGramm) {
                if (map.find(currentGramm) == map.end()) {
                    map.insert(make_pair(currentGramm, std::vector<int>()));
                }
                map.at(currentGramm).push_back(j - i - 3);
            }
        }
    }
    std::vector<int> maxVector;
    for(auto & it : map) {
        if (maxVector.size() <= it.second.size()) {
            maxVector = it.second;
        }
    }
    return findGCD(maxVector);
}