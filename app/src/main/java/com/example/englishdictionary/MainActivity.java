package com.example.englishdictionary;

import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.database.SQLException;
import android.os.Bundle;
import android.os.Handler;

import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.CursorAdapter;
import android.widget.RelativeLayout;
import android.widget.SearchView;
import android.widget.SimpleCursorAdapter;
import android.widget.Toast;

import androidx.appcompat.widget.Toolbar;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MainActivity extends AppCompatActivity {

    private SearchView search;

    static DatabaseHelper myDbHelper;
    static boolean databaseOpened = false;

    SimpleCursorAdapter suggestionAdapter;

    ArrayList<History> historyList;
    RecyclerView recyclerView;
    RecyclerView.LayoutManager layoutManager;
    RecyclerView.Adapter historyAdapter;

    RelativeLayout emptyHistory;
    Cursor cursorHistory;

    DrawerLayout drawer;

    boolean doubleBackToExitPressedOnce = false;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setTitle("English to Lozi");

        drawer = findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(this, drawer, toolbar,
                R.string.navigation_drawer_open, R.string.navigation_drawer_closed);
        drawer.addDrawerListener(toggle);
        toggle.syncState();

        search = findViewById(R.id.search_view);
        /**
         * make search view clickable anywhere within itself
         */
        search.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                search.setIconified(false);
            }
        });

        myDbHelper = new DatabaseHelper(this);

        if(myDbHelper.checkDataBase()) {
            openDatabase();
        } else {
            LoadDatabaseAsync task = new LoadDatabaseAsync(MainActivity.this);
            task.execute();
        }

        // setup SimpleCursorAdapter
        final String[] from = new String[] {"en_word"};
        final int[] to = new int[] {R.id.suggestion_text};

        suggestionAdapter = new SimpleCursorAdapter(MainActivity.this,
                R.layout.suggestion_row, null, from, to, 0) {
            @Override
            public void changeCursor(Cursor cursor) {
                super.swapCursor(cursor);
            }

        };

        search.setSuggestionsAdapter(suggestionAdapter);
        search.setOnSuggestionListener(new SearchView.OnSuggestionListener() {
            @Override
            public boolean onSuggestionClick(int position) {
                //Add clicked text to search box
                CursorAdapter ca = search.getSuggestionsAdapter();
                Cursor cursor = ca.getCursor();
                cursor.moveToPosition(position);
                String clicked_word = cursor.getString(cursor.getColumnIndexOrThrow("en_word"));
                search.setQuery(clicked_word, false);

                //search.setQuery("", false);
                search.clearFocus();
                search.setFocusable(false);

                Intent intent = new Intent(MainActivity.this, WordMeaningActivity.class);
                Bundle bundle = new Bundle();
                bundle.putString("en_word", clicked_word);
                intent.putExtras(bundle);
                startActivity(intent);

                return true;
            }

            @Override
            public boolean onSuggestionSelect(int position) {

                return true;
            }
        });

        search.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
                String text = search.getQuery().toString();

                Pattern p = Pattern.compile("[[A-Za-z] \\-.]{1,25}");
                Matcher m = p.matcher(text);

                if (m.matches()) {

                    Cursor c = myDbHelper.getMeaning(text);

                    if(c.getCount() == 0) {
                        showAlertDialog();
                    }else {
                        //search.setQuery("", false);
                        search.clearFocus();
                        search.setFocusable(false);

                        Intent intent = new Intent(MainActivity.this, WordMeaningActivity.class);
                        Bundle bundle = new Bundle();
                        bundle.putString("en_word", text);
                        intent.putExtras(bundle);
                        startActivity(intent);
                    }

                }else {
                    showAlertDialog();
                }


                return false;
            }

            @Override
            public boolean onQueryTextChange(final String s) {

                search.setIconifiedByDefault(false); //Give suggestion list margins

                Pattern p = Pattern.compile("[[A-Za-z]\\-.]{1,25}");
                Matcher m = p.matcher(s);

                if (m.matches()) {
                    Cursor cursorSuggestion = myDbHelper.getSuggestions(s);
                    suggestionAdapter.changeCursor(cursorSuggestion);
                }

                return false;
            }
        });

        emptyHistory = (RelativeLayout) findViewById(R.id.empty_history);

        //Recycler View
        recyclerView = (RecyclerView) findViewById(R.id.recycler_view_history);
        layoutManager = new LinearLayoutManager(MainActivity.this);

        recyclerView.setLayoutManager(layoutManager);

        fetch_history();

    }

    protected static void openDatabase() {

        try {
            myDbHelper.openDataBase();
            databaseOpened = true;
        }catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void fetch_history() {

        historyList = new ArrayList<>();
        historyAdapter = new RecyclerViewAdapterHistory(this, historyList);
        recyclerView.setAdapter(historyAdapter);

        History h;

        if (databaseOpened) {

            cursorHistory = myDbHelper.getHistory();
            if (cursorHistory.moveToFirst()) {
                do {
                    h = new History(cursorHistory.getString(cursorHistory.getColumnIndexOrThrow("word")), cursorHistory.getString(cursorHistory.getColumnIndexOrThrow("en_definition")));
                    historyList.add(h);
                }while(cursorHistory.moveToNext());
            }

            historyAdapter.notifyDataSetChanged();

            if (historyAdapter.getItemCount() == 0) {
                emptyHistory.setVisibility(View.VISIBLE);
            }else {
                emptyHistory.setVisibility(View.GONE);
            }
        }
    }

    private void showAlertDialog () {

        search.setQuery("", false);

        AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this, R.style.MyDialogTheme);
        builder.setTitle("Word Not Found");
        builder.setMessage("Please search again");

        String positiveText = getString(android.R.string.ok);
        builder.setPositiveButton(positiveText,
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {

                    }
                });

        String negativeText = getString(android.R.string.cancel);
        builder.setNegativeButton(negativeText,
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        search.clearFocus();
                    }
                });
        AlertDialog dialog = builder.create();
        //display dialog
        dialog.show();

    }

//    /**
//     *Inflate the menu_main; this adds items to the action bar if it is present.
//     */
//    @Override
//    public boolean onCreateOptionsMenu(Menu menu) {
//        getMenuInflater().inflate(R.menu.menu_main, menu);
//        return true;
//    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        if(id == R.id.action_settings) {
            Intent intent = new Intent(MainActivity.this, SettingsActivity.class);
            startActivity(intent);
            return true;
        }
        if(id == R.id.action_exit) {
            System.exit(0);
            return true;
        }

        return super.onOptionsItemSelected(item);

    }

    @Override
    protected void onResume() {
        super.onResume();
        fetch_history();
    }

    @Override
    public void onBackPressed() {
        if (doubleBackToExitPressedOnce) {
            super.onBackPressed();
        }
        
        this.doubleBackToExitPressedOnce = true;
        Toast.makeText(this, "Press Back again to Exit", Toast.LENGTH_SHORT).show();

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                doubleBackToExitPressedOnce = false;
            }
        }, 2000);
    }
    
}