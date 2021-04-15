/**
 * Purpose: Count the lines in a file. Can return count.
*/

import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.BufferedReader;

public class CountLines
{
   private int lineCounter = 0;
   private String fileName = null;
   
   /**
    * Method: readInAndCount - reads in and counts the lines in a file.
    * @param someFile
    */
   public void readInAndCount(String someFile)
   {
      fileName = someFile;
      try 
      {
         BufferedReader in = new BufferedReader(new FileReader(fileName)); 
         while (in.readLine() != null) //this block increases the line counts until EOF is reached
         {
            lineCounter++;
         }
         in.close();
      }
      catch (FileNotFoundException exception)
      {
         System.out.println("CountLines.java method error: The specified file was not found");
      }
      catch (IOException exception)
      {
         System.out.println("CountLines.java method error: Problem reading in the file");
      }
           
   }
   /**
    * Method: showCount - returns the line count
    * @return
    */
   public int showCount()
   {
      int theCount = lineCounter;
     // System.out.println(theCount + " lines detected in reference file.");
      return theCount;
   }
   
}
      