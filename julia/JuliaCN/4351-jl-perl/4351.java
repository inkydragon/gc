package com.company;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class Main {
    static long[] freqs = new long[128];
    static long G = 0;
    static long C = 0;
    static double total = 0.0;

    public static void countLettersIf(String filename) throws IOException{
        try(BufferedReader in = new BufferedReader(new FileReader(filename))){
            String line;
            while((line = in.readLine()) != null){
                for(char ch:line.toCharArray()){
                    if (ch=='>') {
                        break;
                    } else if(ch=='G' || ch=='g') {
                        G++;
                    } else if(ch=='C' || ch=='c'){
                        C++;
                    }
                    if (ch!='N' && ch!='n') {
                        total++;
                    }
                }
            }
        }
    }

    public static long[] countLettersArray(String filename) throws IOException{
        try(BufferedReader in = new BufferedReader(new FileReader(filename))){
            String line;
            while((line = in.readLine()) != null){
                for(char ch:line.toCharArray()){
                    if (ch=='>') {
                        break;
                    }
                    freqs[ch]++;
                }
            }
        }
        return freqs;
    }

    public static void printRes() {
        System.out.println("G=" + G + "; C=" + C + "; GC=" + (G+C));
        System.out.println("total=" + (long) total);
        System.out.println("frac=" + ((G+C) / total));
    }

    public static void main(String[] args) throws IOException{
        long starTime = System.currentTimeMillis();
        countLettersIf("H:\\hg38.fa");
        long endTime = System.currentTimeMillis();
        long Time = endTime - starTime;
        System.out.println("if-else style Time=" + Time/1000.0 + "s");
        printRes();

        System.out.println("----------------");

        starTime = System.currentTimeMillis();
        countLettersArray("H:\\hg38.fa");
        endTime = System.currentTimeMillis();
        Time = endTime - starTime;
        System.out.println("array style Time=" + Time/1000.0 + "s");
        G = freqs['G'] + freqs['g'];
        C = freqs['C'] + freqs['c'];
        total = G+C+freqs['A'] + freqs['a']+freqs['T'] + freqs['t'];
        printRes();
    }
}

// if-else style Time=42.075s
// G=626335137; C=623727342; GC=1250062479
// total=3049315783
// frac=0.409948515653618
// ----------------
// array style Time=17.056s
// G=626335137; C=623727342; GC=1250062479
// total=3049315783
// frac=0.409948515653618
