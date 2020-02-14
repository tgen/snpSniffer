import java.io.IOException;

// Decompiled by Procyon v0.5.34

public class Genotype
{
    void Run(final String s, final String s2) throws IOException, InterruptedException {
        try {
            final String s3 = s2.split("/")[s2.split("/").length - 1];
            s3.split(".bam");
            s2.split(s3);
            Runtime.getRuntime().exec("geno " + s + " " + s2).waitFor();
        }
        catch (IOException ex) {
            System.out.println(ex.getMessage());
        }
    }
}
