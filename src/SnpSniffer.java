/**
 * snpSniffer V7 
 */

//Decompiled by Procyon v0.5.34

import java.io.IOException;
 
public class SnpSniffer
{
    
	public static void main(final String[] array) throws IOException, InterruptedException {
		try 
		{
			if (array[0].equals("-add")) {
	            new AddFile().fileAdd(array[1], array[2]);
	        }
	        else if (array[0].equals("-check") && array[1].equals("Samples")) {
	            new Check().help(array[2]);
	        }
	        else if (array[0].equals("-check")) {
	            new Check().read(array[1], array[2]);
	        }
	        else if (array[0].equals("-genotype")) {
	            new Genotype().Run(array[1], array[2]);
	        }
	        else if (array[0].equals("-expected")) {
	            new Expected().Run(array[1], array[2], array[3]);
	        }
	        else if (array[0].equals("-notExpected")) {
	            new NotExpected().Run(array[1], array[2], array[3]);
	        }
	        else if (array[0].equals("-het")) {
	            new Het().find(array[1]);
	        }
	        else if (array[0].equals("-version")) {
	        	System.out.println("snpSniffer version 7.0 from the Translational Genomics Research Institute (TGen)");
	        	System.out.println("Get the source code or see the license at - https://github.com/tgen/snpSniffer/");
	        	System.out.println("Support this project and many other by visiting - https://www.tgen.org");
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
	            System.out.println("-version:           prints the version number and source");
	        }
	    }
		catch(ArrayIndexOutOfBoundsException e) 
	    {
	    	System.out.println("The arguments were improperly formatted or missing. Please try the -help option for more information.");
	    	e.printStackTrace();
	    }
	}
}