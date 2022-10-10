package com.example.englishdictionary;

import android.content.DialogInterface;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

public class SettingsActivity extends AppCompatActivity {

    DatabaseHelper myDbHelper;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);

        Toolbar toolbar = findViewById(R.id.toolbar_settings);
        setSupportActionBar(toolbar);
        getSupportActionBar().setTitle("Settings");

        toolbar.setNavigationIcon(R.drawable.ic_arrow_back);

        TextView clearHistory = (TextView) findViewById(R.id.clear_history);

        clearHistory.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View viewIn) {
                myDbHelper = new DatabaseHelper(SettingsActivity.this);
                myDbHelper.openDataBase(); // put in try and catch

                showAlertDialog();
            }
        });


    }

    private void showAlertDialog() {

        AlertDialog.Builder builder = new AlertDialog.Builder(SettingsActivity.this, R.style.MyDialogTheme);
        builder.setTitle("Are you sure?");
        builder.setMessage("All the history will be deleted");

        String positiveText = "Yes";
        builder.setPositiveButton(positiveText,
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        myDbHelper.deleteHistory();
                    }
                });

        String negativeText = "No";
        builder.setNegativeButton(negativeText,
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {

                    }
                });

        AlertDialog dialog = builder.create();
        //display dialog
        dialog.show();

    }

    /**
     *Press Back Icon
     */
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if(item.getItemId() == android.R.id.home) {
            onBackPressed();
        }
        return super.onOptionsItemSelected(item);
    }

}
