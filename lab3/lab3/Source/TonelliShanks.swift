////
////  TonelliShanks.swift
////  lab3
////
////  Created by Ilya Sysoi on 11/8/19.
////  Copyright © 2019 Ilya Sysoi. All rights reserved.
////
//
//import Foundation
//
//class TonelliShanks {
//
//    static func ShanksSqrt(a: Int, p: Int) -> Int {
//        if a == 0 {
//            return 0;
//        }
//
//        if (BigInteger.ModPow(a, (p - 1) / 2, p) == (p - 1))
//        {
//            return -1;
//        }
//
//        if (p % 4 == 3)
//        {
//            return BigInteger.ModPow(a, (p + 1) / 4, p);
//        }
//
//        BigInteger s, e;
//        s = FindS(p);
//        e = FindE(p);
//
//        BigInteger n, m, x, b, g, r;
//        n = 2;
//
//        while (BigInteger.ModPow(n, (p - 1) / 2, p) == 1)
//        {
//            n++;
//        }
//
//        x = BigInteger.ModPow(a, (s + 1) / 2, p);
//        b = BigInteger.ModPow(a, s, p);
//        g = BigInteger.ModPow(a, s, p);
//        r = e;
//        m = Ord(b, p);
//        if (m == 0)
//        {
//            return x;
//        }
//
//        while (m < 0)
//        {
//            x = (x * BigInteger.ModPow(g, TwoExp(r - m - 1), p)) % p;
//            b = (b * BigInteger.ModPow(g, TwoExp(r - m), p)) % p;
//            g = BigInteger.ModPow(g, TwoExp(r - m), p);
//            r = m;
//            m = Ord(b, p);
//        }
//
//        return x;
//    }
//}
