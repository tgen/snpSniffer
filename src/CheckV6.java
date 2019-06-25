/*
This build requires the CountLines.class/.java for proper function

Added some notes for readability. Added the CountLines class to extend functionality.

Decompiled by Procyon v0.5.34

End comments 4/24/2019 Salvatore Facista

*/

//import java.io.Writer;
import java.io.PrintWriter;
import java.io.FileWriter;
import java.io.File;
import java.io.IOException;
import java.util.Scanner;
import java.io.FileReader;

public class CheckV6
{
    private int i;
    private int j;
    private int l;
    private int x;
    private int sample;
    private double match;
    private double count;
    private double ratio;
    String line1;
    String[] line1Tokens;
    String delim;
    String[] tokens;
    
    public CheckV6() {
        this.j = 0;
        this.l = 0;
        this.x = 0;
        this.sample = 0;
        this.match = 0.0;
        this.count = 0.0;
        this.delim = "\t";
    }
    
    void read(final String s, final String s2) throws IOException {
        final Scanner scanner = new Scanner(new FileReader(s2));
        
        //here we get the size required for the array
        CountLines poot = new CountLines();
        poot.readInAndCount(s2);
        final int ARRAYSIZE = poot.showCount();
        
        this.i = 0;
        while (this.i < 1) {
            this.line1 = scanner.nextLine();
            this.line1Tokens = this.line1.split(this.delim);
            this.l = this.line1.split(this.delim).length;
            ++this.i;
        }
        this.i = 0;
        while (this.i < this.l) {
            if (this.line1Tokens[this.i].equals(s)) {
                this.sample = this.i;
            }
            ++this.i;
        }
        final String[][] array = new String[ARRAYSIZE][this.l];
        final Scanner scanner2 = new Scanner(new FileReader(s2));
        while (scanner2.hasNextLine()) {
            final String[] split = scanner2.nextLine().split(this.delim);
            this.i = 0;
            while (this.i < split.length) {
                array[this.x][this.i] = split[this.i];//there is an issue with this line
                ++this.i;
            }
            ++this.x;
        }
        scanner.close();
        scanner2.close();
        this.j = 1;
        while (this.j < this.l) {
            this.i = 1;
            while (this.i < ARRAYSIZE) {
                if (!array[this.i][this.j].equals("NN") && !array[this.i][this.sample].equals("NN")) {
                    ++this.count;
                    if (array[this.i][this.j].equals(array[this.i][this.sample])) {
                        ++this.match;
                    }
                }
                ++this.i;
            }
            this.ratio = this.match / this.count;
            if (!array[0][this.j].equals(array[0][this.sample]) && !array[0][this.sample].equals("Sample") && !array[0][this.j].equals("Sample")) {
                System.out.println(array[0][this.sample] + " & " + array[0][this.j] + " count=" + this.count + " match=" + this.match + " ratio=" + this.ratio);
            }
            final double n = 0.0;
            this.count = n;
            this.match = n;
            ++this.j;
        }
    }
    
    void output(final String s, final String s2) throws IOException {
        final Scanner scanner = new Scanner(new FileReader(s2));
        final File file = new File("snpSniffer_output.txt");
        this.i = 0;
        while (this.i < 1) {
            this.line1 = scanner.nextLine();
            this.line1Tokens = this.line1.split(this.delim);
            this.l = this.line1.split(this.delim).length;
            ++this.i;
        }
        this.i = 0;
        while (this.i < this.l) {
            if (this.line1Tokens[this.i].equals(s)) {
                this.sample = this.i;
            }
            ++this.i;
        }
         //here we get the size required for the array
        CountLines poot = new CountLines();
        poot.readInAndCount(s);
        final int ARRAYSIZE = poot.showCount();

        final String[][] array = new String[ARRAYSIZE][this.l];
        final Scanner scanner2 = new Scanner(new FileReader(s2));
        while (scanner2.hasNextLine()) {
            final String[] split = scanner2.nextLine().split(this.delim);
            this.i = 0;
            while (this.i < split.length) {
                array[this.x][this.i] = split[this.i];
                ++this.i;
            }
            ++this.x;
        }
        scanner.close();
        scanner2.close();
        final PrintWriter printWriter = new PrintWriter(new FileWriter(file, true));
        this.j = 1;
        while (this.j < this.l) {
            this.i = 1;
            while (this.i < ARRAYSIZE) {
                if (!array[this.i][this.j].equals("NN") && !array[this.i][this.sample].equals("NN")) {
                    ++this.count;
                    if (array[this.i][this.j].equals(array[this.i][this.sample])) {
                        ++this.match;
                    }
                }
                ++this.i;
            }
            this.ratio = this.match / this.count;
            if (!array[0][this.j].equals(array[0][this.sample]) && !array[0][this.sample].equals("Sample") && !array[0][this.j].equals("Sample")) {
                printWriter.println(array[0][this.sample] + " & " + array[0][this.j] + " count=" + this.count + " match=" + this.match + " ratio=" + this.ratio);
            }
            final double n = 0.0;
            this.count = n;
            this.match = n;
            ++this.j;
        }
        printWriter.close();
    }
    
    void help(final String s) throws IOException {
        final Scanner scanner = new Scanner(new FileReader(s));
        this.i = 0;
        while (this.i < 1) {
            this.tokens = scanner.nextLine().split("\t");
            ++this.i;
        }
        this.i = 0;
        while (this.i < this.tokens.length) {
            System.out.println(this.tokens[this.i]);
            ++this.i;
        }
        scanner.close();
    }
}
