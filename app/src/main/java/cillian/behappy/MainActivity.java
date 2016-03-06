package cillian.behappy;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ImageView imageView = (ImageView) findViewById(R.id.imageView);
        imageView.setImageResource(R.drawable.icon);
    }

    public void getPic(View view) {
        ImageView imageView = (ImageView) findViewById(R.id.imageView);
        imageView.setImageResource(R.drawable.loading);
        Intent intent = new Intent(this, PictureActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.pull_in_right, R.anim.push_out_left);
    }
}
