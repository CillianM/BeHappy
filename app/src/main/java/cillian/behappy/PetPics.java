package cillian.behappy;

import android.widget.ImageView;

import java.io.BufferedReader;
import java.io.InputStreamReader;
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
    ArrayList<String> picLinks;

    PetPics(ImageView image,String searchUrl, ArrayList<String> linksList)
    {
        try
        {
            imageView = image;
            url =searchUrl;
            picLinks = linksList;
        }

        //catch any exceptions thrown
        catch (Exception ex) {
            System.out.println("The following error occurred: \n" + ex);
        }
    }

    public void get()
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
                if(strTemp.contains("<section class=\"regular-items\">"))
                {
                    record = true;
                }
                if(record && strTemp.contains(("</section>")))
                {
                    record = false;
                    break;
                }

                if(record && strTemp.contains("<a class=\"preview-photo preview-img\""))
                {
                    strTemp = strTemp.substring(87,149);
                    picLinks.add(strTemp);
                }
            }
            br.close();

        }

        catch (Exception ex)
        {
            System.out.println("Looks like there was a problem! Check the query you entered and try again \n For the more tech savvy here is the error: \n" + ex);
        }
    }

}
