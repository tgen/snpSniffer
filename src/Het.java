import java.io.IOException;
import java.util.Scanner;
import java.io.FileReader;

// Decompiled by Procyon v0.5.34

public class Het
{
    private int i;
    private int j;
    private int l;
    private int x;
    private double ratio;
    private double het;
    private double hom;
    private double total;
    String line1;
    String[] line1Tokens;
    String delim;
    String[] tokens;
    
    public Het() {
        this.j = 0;
        this.l = 0;
        this.x = 0;
        this.ratio = 0.0;
        this.het = 0.0;
        this.hom = 0.0;
        this.total = 0.0;
        this.delim = "\t";
    }
    
    void find(final String s) throws IOException {
        final Scanner scanner = new Scanner(new FileReader(s));
        this.i = 0;
        while (this.i < 1) {
            this.line1 = scanner.nextLine();
            this.line1Tokens = this.line1.split(this.delim);
            this.l = this.line1.split(this.delim).length;
            ++this.i;
        }
        //here we get the size required for the array
         CountLines poot = new CountLines();
         poot.readInAndCount(s);
         final int ARRAYSIZE = poot.showCount();

        
        final String[][] array = new String[ARRAYSIZE][this.l];
        final Scanner scanner2 = new Scanner(new FileReader(s));
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
        System.out.println("Sample\tHomozygous\tHeterozygous\tTotal\thetRatio");
        this.j = 1;
        while (this.j < this.l) {
            this.i = 1;
            while (this.i < ARRAYSIZE) {
                if (array[this.i][this.j].equals("AA") || array[this.i][this.j].equals("TT") || array[this.i][this.j].equals("CC") || array[this.i][this.j].equals("GG")) {
                    ++this.hom;
                }
                else if (array[this.i][this.j].equals("AT") || array[this.i][this.j].equals("AC") || array[this.i][this.j].equals("AG")) {
                    ++this.het;
                }
                else if (array[this.i][this.j].equals("TA") || array[this.i][this.j].equals("TC") || array[this.i][this.j].equals("TG")) {
                    ++this.het;
                }
                else if (array[this.i][this.j].equals("CA") || array[this.i][this.j].equals("CT") || array[this.i][this.j].equals("CG")) {
                    ++this.het;
                }
                else if (array[this.i][this.j].equals("GT") || array[this.i][this.j].equals("GC") || array[this.i][this.j].equals("GA")) {
                    ++this.het;
                }
                ++this.i;
            }
            this.total = this.hom + this.het;
            this.ratio = this.het / this.total;
            if (!array[0][this.j].equals("Sample")) {
                System.out.println(array[0][this.j] + "\t" + this.hom + "\t" + this.het + "\t" + this.total + "\t" + this.ratio);
            }
            final double n = 0.0;
            this.het = n;
            this.hom = n;
            ++this.j;
        }
    }
}
