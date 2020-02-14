/*
BEGIN NOTES FOR EDITS MADE 2/14/2020
Due to changes in the way homozygous references are reported with BCFTools 0 -> 0/0 . Changing the addFile Function to expect the new string "0/0" 
END NOTES FOR EDITS MADE 2/14/2020

Decompiled by Procyon v0.5.34
*/

import java.io.IOException;
import java.io.PrintWriter;
//import java.util.Arrays;
import java.util.Scanner;
import java.io.FileReader;

public class AddFile
{
    
    /*
  Method fileAdd
  @String paramString1 is some file name of a file that gets read in and parsed
  @String paramString2 is some file name of a file that gets output after parsing
  */
     
    void fileAdd(final String s, final String s2) throws IOException 
    {
         //here we get the size required for the array
         CountLines poot = new CountLines();
         poot.readInAndCount(s2);
         final int ARRAYSIZE = poot.showCount();
         
         //here the sample name is extracted from the file name
         final Scanner scanner = new Scanner(new FileReader(s)); 
         final String s3 = s.split("/")[s.split("/").length - 1].split(".vcf")[0];//splits regular expression "/" - removes the "/", with a threshold of however many subdirectories/  - assigns to arrayOfString1
         System.out.println("Sample name is: " + s3);

        //here the 2d array is created by splitting up the tab delimited file
        final String s4 = "\t", s5 = ":";
        final String[][] array = new String[ARRAYSIZE][5];
        int n = 0, length = 0;
        boolean b = false;
        
        /*optional troubleshooting code
        System.out.println("The ARRAYSIZE varriable is" + ARRAYSIZE);
        System.out.println();
        System.out.println("The array (just generated) reads: " + Arrays.deepToString(array));
        end optional troubleshooting code */
        
        try {
               while (scanner.hasNextLine()) {
               final String[] split = scanner.nextLine().split(s4);
               //System.out.println(split); //optional t/s code
              // System.out.println("The array prior to matching reads: " + Arrays.deepToString(split));//optional t/s code
               if (split[0].equals("1")) {
                   b = true;
                  // System.out.println("split[0] is 1"); //optional t/s code

               }
               if (b) {
                   Float.valueOf(split[5]);
               }
               if (b && Float.valueOf(split[5]) > 50.0f) {
                   final String[] split2 = split[9].split(s5);
                   array[n][0] = split[0].concat(":").concat(split[1]);
                   array[n][1] = split[3];
                   array[n][2] = split[4];
                   array[n][3] = split[5];
                   array[n][4] = split2[0];
                   ++n;
               }
               //System.out.println("The array for matching reads: " + Arrays.deepToString(split2));//optional t/s code
            }
        }
        finally {
            scanner.close();
        }
        final Scanner scanner2 = new Scanner(new FileReader(s2));
        for (int i = 0; i < 1; ++i) {
            length = scanner2.nextLine().split(s4).length;
        }
        //here a bunch of NN values are stored in the array
        final String[][] array2 = new String[ARRAYSIZE][length + 1];
        for (int j = 0; j < ARRAYSIZE; ++j) {
            array2[j][length] = "NN";
        }
        array2[0][length] = s3;
        int n2 = 0;
        final Scanner scanner3 = new Scanner(new FileReader(s2));
        while (scanner3.hasNextLine()) {
            final String[] split3 = scanner3.nextLine().split(s4);
            for (int k = 0; k < split3.length; ++k) {
                array2[n2][k] = split3[k];
            }
            ++n2;
        }
        scanner2.close();
        scanner3.close();
        for (int l = 0; l < ARRAYSIZE; ++l) {
            for (int n3 = 0; n3 < ARRAYSIZE; ++n3) {
                if (array2[l][0].equals(array[n3][0]) && array[n3][4].equals("0/1")) { 
                    array2[l][length] = array[n3][1].concat(array[n3][2]);
                }
                if (array2[l][0].equals(array[n3][0]) && array[n3][4].equals("1/1")) {
                    array2[l][length] = array[n3][2].concat(array[n3][2]);
                }
                //v7 2/2020 not expects a 0/0 format for 
                if (array2[l][0].equals(array[n3][0]) && array[n3][4].equals("0/0")) {
                    array2[l][length] = array[n3][1].concat(array[n3][1]);
                }
            }
        }
        final PrintWriter printWriter = new PrintWriter(s2);
        for (int n4 = 0; n4 < ARRAYSIZE; ++n4) {
            for (int n5 = 0; n5 < length + 1; ++n5) {
                printWriter.print(array2[n4][n5] + "\t");
            }
            printWriter.print("\n");
        }
        printWriter.close();
        System.out.println("Sample successfully added to " + s2);
    }
}
