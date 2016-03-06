package cillian.behappy;

import android.content.Intent;
import android.os.StrictMode;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;

import java.util.ArrayList;

public class PictureActivity extends AppCompatActivity {

    ImageView global;
    ArrayList<String> imageLinks;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_picture);

        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();

        StrictMode.setThreadPolicy(policy);

        ImageView image = (ImageView) findViewById(R.id.imageView);
        global = image;
        imageLinks = new ArrayList<>();
        String searchFor = "http://photopin.com/free-photos/dog?license=noncommercial&sort=recent";
        PetPics pic = new PetPics(image,searchFor,imageLinks);
        initialImage(pic);
    }

    public void initialImage(PetPics pic)
    {
        pic.get();
        pic.url ="http://photopin.com/free-photos/cat?license=noncommercial&sort=recent";
        pic.get();
        String imageLink = imageLinks.get((int)(Math.random() * imageLinks.size()));
        new DownloadImage((ImageView) findViewById(R.id.imageView)).execute(imageLink);
    }

    public void refresh(View view) {
        global.setImageResource(R.drawable.loading);
        String newLink = imageLinks.get((int)(Math.random() * imageLinks.size()));
        new DownloadImage((ImageView) findViewById(R.id.imageView)).execute(newLink);
    }

    @Override
    public void onBackPressed() {
        Intent intent = new Intent(this,MainActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.pull_in_left, R.anim.push_out_right);
    }



}
