import java.io.IOException;

// 
// Decompiled by Procyon v0.5.34
// 

public class snpSnifferV6
{
    public static void main(final String[] array) throws IOException, InterruptedException {
        if (array[0].equals("-add")) {
            new addFileV6().fileAdd(array[1], array[2]);
        }
        else if (array[0].equals("-check") && array[1].equals("Samples")) {
            new CheckV6().help(array[2]);
        }
        else if (array[0].equals("-check")) {
            new CheckV6().read(array[1], array[2]);
        }
        else if (array[0].equals("-genotype")) {
            new GenotypeV6().Run(array[1], array[2]);
        }
        else if (array[0].equals("-expected")) {
            new ExpectedV6().Run(array[1], array[2], array[3]);
        }
        else if (array[0].equals("-notExpected")) {
            new notExpectedV6().Run(array[1], array[2], array[3]);
        }
        else if (array[0].equals("-het")) {
            new HetV6().find(array[1]);
        }
        else {
            System.out.println("Usage options are");
            System.out.println("-genotype:          generate genotypes from a bam: java -jar snpSniffer.jar -genotype <fullFilePath/reference.fa> <fullFilePath/sample.bam>");
            System.out.println("-add:               add genotypes from a vcf: java -jar snpSniffer.jar -add <fullFilePath/sample.vcf> <fullFilePath/database.ini>");
            System.out.println("-check Samples:     view all samples: java -jar snpSniffer.jar -check Samples <fullFilePath/database.ini>");
            System.out.println("-check:             check concordance of genotypes for a sample: java -jar snpSniffer.jar -check <sampleName> <fullFilePath/database.ini>");
            System.out.println("-expected:          identify expected matches: java -jar snpSniffer.jar -expected <delimiter> <# of delimited fields that define sample name> <fullFilePath/database.ini>");
            System.out.println("-notExpected:       identify not-expected matches check: java -jar snpSniffer.jar -notExpected <delimiter> <# of delimited fields that define sample name> <fullFilePath/database.ini>");
            System.out.println("-het:               calculate heterozygosity rate for all samples: java -jar snpSniffer.jar -het <fullFilePath/database.ini>");
        }
    }
}
