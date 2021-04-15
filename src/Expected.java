import java.io.IOException;
import java.util.Scanner;
import java.io.FileReader;
import java.io.File;

// Decompiled by Procyon v0.5.34

public class Expected
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
    String s1;
    String s2;
    String[] line1Tokens;
    String delim;
    String[] tokens;
    
    public Expected() {
        this.j = 0;
        this.l = 0;
        this.x = 0;
        this.sample = 0;
        this.match = 0.0;
        this.count = 0.0;
        this.delim = "\t";
    }
    
    void Run(final String s, final String s2, final String s3) throws IOException {
    	
    	
       
    	final File file = new File("snpSniffer_output.txt");
        if (file.exists() && !file.isDirectory()) {
            file.delete();
        }
        final Scanner scanner = new Scanner(new FileReader(s3));
        this.i = 0;
        while (this.i < 1) {
            this.line1 = scanner.nextLine();
            this.line1Tokens = this.line1.split(this.delim);
            this.l = this.line1.split(this.delim).length;
            ++this.i;
        }
        scanner.close();
       
        this.i = 0;
        while (this.i < this.l) {
            if (!this.line1Tokens[this.i].equals("Sample")) {
                new Check().output(this.line1Tokens[this.i], s3);
            }
            ++this.i;
        }
         //here we get the size required for the array
        CountLines poot = new CountLines();
        poot.readInAndCount(s3);
        final int ARRAYSIZE = poot.showCount(); 
        final String[][] array = new String[ARRAYSIZE][this.l];
        final Scanner scanner2 = new Scanner(new FileReader("snpSniffer_output.txt"));
        while (scanner2.hasNextLine()) {
            final String nextLine = scanner2.nextLine();
            final String[] split = nextLine.split(" ");
            final String[] split2 = split[0].split(s);
            final String[] split3 = split[2].split(s);
            if (s2.equals("1")) {
                this.s1 = split2[0];
                this.s2 = split3[0];
            }
            else if (s2.equals("2")) {
                this.s1 = split2[0].concat(split2[1]);
                this.s2 = split3[0].concat(split3[1]);
            }
            else if (s2.equals("3")) {
                this.s1 = split2[0].concat(split2[1]).concat(split2[2]);
                this.s2 = split3[0].concat(split3[1]).concat(split3[2]);
            }
            this.ratio = Double.parseDouble(split[5].split("=")[1]);
            if (this.s1.equals(this.s2) && this.ratio > 0.8) {
                System.out.println(nextLine);
            }
        }
        scanner2.close();
    }
}
