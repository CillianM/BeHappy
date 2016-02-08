package cillian.behappy;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.ImageView;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.util.ArrayList;

/**
 * Created by Cillian on 08/02/2016.
 */
public class PetPics {

    ImageView imageView;
    String url;
    ArrayList <String> picLinks = new ArrayList<>();

    PetPics(ImageView image,String searchUrl)
    {
        try
        {
            imageView = image;
            url =searchUrl;
        }

        //catch any exceptions thrown
        catch (Exception ex) {
            System.out.println("The following error occurred: \n" + ex);
        }
    }

    public String get()
    {
        try
        {
            URLConnection connection = new URL(url).openConnection();
            connection.setRequestProperty("http.agent", "");
            connection.connect();

            BufferedReader br  = new BufferedReader(new InputStreamReader(connection.getInputStream(), Charset.forName("UTF-8")));
            String strTemp;
            boolean record = false;
            while(null != (strTemp = br.readLine()))
            {
                if(strTemp.contains("<div class=\"m-l-c\" id=\"fdc_contcontainer\">"))
                {
                    record = true;
                }
                if(strTemp.contains(("<div class=\"content-show-more\">")))
                {
                    record = false;
                    break;
                }

                if(record && strTemp.contains("<img class=")) {

                    String dump = strTemp + "\n" + br.readLine() + br.readLine() + br.readLine() + br.readLine() + br.readLine();
                    String link = br.readLine();
                    link = link.trim();
                    int end = link.length() - 7;
                    picLinks.add(link.substring(5,end));
                }
            }
            br.close();

            int random = (int)(Math.random() * picLinks.size());

            return picLinks.get(random);
        }

        catch (Exception ex)
        {
            System.out.println("Looks like there was a problem! Check the query you entered and try again \n For the more tech savvy here is the error: \n" + ex);
        }
        return null;
    }

    public void getPics(String potLink, int position)
    {
        int start;
        int end;
        for(int i = 0; i < potLink.length(); i++)
        {
            //pointless after this point
            if(potLink.length() - i < 10)
                break;
            //check if has similarities to start of <a href="...
            if(potLink.charAt(i) == '<' && potLink.charAt(i+1) == 'a')
            {
                for(int j = i; j < potLink.length(); j++)
                {
                    //get the point right after the = in the link
                    if(potLink.charAt(j) == '=' && potLink.charAt(j-1) == 'f')
                    {
                        start = j+2;
                        for(int k = start; k < potLink.length(); k++)
                        {
                            if(potLink.charAt(k)  == '"')
                            {
                                end = k;
                                potLink = potLink.substring(start,end);
                                //add it to our arraylist of links if it looks like an address of somekind
                                if(potLink.contains("/wiki"))
                                    picLinks.set(position, potLink);
                                break;
                            }
                        }
                    }
                    //try and get the point where the quotes end in the link
                }
            }
        }
    }

}
