package com.example.englishdictionary;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

public class SplashActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash_actvity);

        Thread background = new Thread() {
            public void run() {
                try {
                    // Thread will sleep for 5 seconds
                    sleep(1500);

                    // After 5 seconds redirect to another intent
                    Intent i=new Intent(getBaseContext(), MainActivity.class);
                    startActivity(i);

                    //End Splash activity
                    finish();
                } catch (Exception e) {
                    Toast.makeText(SplashActivity.this, "Failed!!!", Toast.LENGTH_SHORT).show();
                }
            }
        };

        // start thread
        background.start();
    }
}
