package cillian.behappy;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.StrictMode;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;

import java.nio.charset.Charset;

public class PictureActivity extends AppCompatActivity {

    ImageView global;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_picture);

        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();

        StrictMode.setThreadPolicy(policy);

        ImageView image = (ImageView) findViewById(R.id.imageView);
        global = image;
        String animal;

        if((int)(Math.random() * 10) > 5)
            animal = "cat";
        else
            animal = "dog";

        String searchFor = "http://www.memecenter.com/search/"+animal;
        PetPics pic = new PetPics(image,searchFor);
        String imageLink = pic.get();
        new DownloadImage((ImageView) findViewById(R.id.imageView)).execute(imageLink);
    }

    public void refresh(View view) {
        String animal;

        if((int)(Math.random() * 10) > 5)
            animal = "cat";
        else
            animal = "dog";

        String searchFor = "http://www.memecenter.com/search/"+animal;
        PetPics pic = new PetPics(global,searchFor);
        String imageLink = pic.get();
        new DownloadImage((ImageView) findViewById(R.id.imageView)).execute(imageLink);
    }

}
