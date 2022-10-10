package com.example.englishdictionary;

import android.content.Intent;
import android.database.Cursor;
import android.os.Bundle;
import android.speech.tts.TextToSpeech;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageButton;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;
import androidx.viewpager.widget.ViewPager;

import com.example.englishdictionary.fragments.FragmentAntonyms;
import com.example.englishdictionary.fragments.FragmentDefinition;
import com.example.englishdictionary.fragments.FragmentExample;
import com.example.englishdictionary.fragments.FragmentSynonyms;
import com.google.android.material.tabs.TabLayout;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class WordMeaningActivity extends AppCompatActivity {

    private ViewPager viewPager;

    String enWord;
    DatabaseHelper myDbHelper;
    Cursor c = null;

    public String enDefinition;
    public String example;
    public String synonyms;
    public String antonyms;

    TextToSpeech tts;

    boolean startedFromShare = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_word_meaning);

        // Received values
        Bundle bundle = getIntent().getExtras();
        enWord = bundle.getString("en_word");

        Intent intent = getIntent();
        String action = intent.getAction();
        String type = intent.getType();

        if (Intent.ACTION_SEND.equals(action) && type != null) {
            if ("text/plain".equals(type)) {
                String shareText = intent.getStringExtra(Intent.EXTRA_TEXT);
                startedFromShare = true;

                if (shareText != null) {
                    Pattern p = Pattern.compile("[A-Za-z] \\-.]{1,25}");
                    Matcher m = p.matcher(shareText);

                    if (m.matches()) {
                        enWord = shareText;
                    }else {
                        enWord = "Not Available";
                    }
                }
            }
        }

        myDbHelper = new DatabaseHelper(this);
        myDbHelper.openDataBase();// put in try and catch --> throw sqle(SQLException sqle);

        c = myDbHelper.getMeaning(enWord);

        if (c.moveToFirst()) {

            enDefinition = c.getString(c.getColumnIndexOrThrow("en_definition"));
            example = c.getString(c.getColumnIndexOrThrow("example"));
            synonyms = c.getString(c.getColumnIndexOrThrow("synonyms"));
            antonyms = c.getString(c.getColumnIndexOrThrow("antonyms"));

            myDbHelper.insertHistory(enWord);

        }else {
            enWord = "Not Available";
        }

        ImageButton btnSpeak = findViewById(R.id.btnSpeak);

        btnSpeak.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                tts = new TextToSpeech(WordMeaningActivity.this, new TextToSpeech.OnInitListener() {
                    @Override
                    public void onInit(int status) {
                        //TODO Auto-generated method stub
                        if (status == TextToSpeech.SUCCESS) {
                            int result = tts.setLanguage(Locale.getDefault());
                            if (result == TextToSpeech.LANG_MISSING_DATA || result == TextToSpeech.LANG_NOT_SUPPORTED) {
                                Log.e("error", "This language is not supported");
                            }else {
                                tts.speak(enWord, TextToSpeech.QUEUE_FLUSH, null);
                            }
                        }else {
                            Log.e("error", "Initialization Failed!");
                        }
                    }
                });
            }
        });

        Toolbar toolbar = findViewById(R.id.mToolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setTitle(enWord);

        toolbar.setNavigationIcon(R.drawable.ic_arrow_back);

        viewPager = findViewById(R.id.tab_viewpager);
        if (viewPager != null) {
            setupViewPager(viewPager);
        }

        /**
         * tabLayout
         */
        TabLayout tabLayout = findViewById(R.id.tabLayout);
        tabLayout.setupWithViewPager(viewPager);

        tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                viewPager.setCurrentItem(tab.getPosition());
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });
    }

    private class ViewPagerAdapter extends FragmentPagerAdapter {
        private final List<Fragment> mFragmentList = new ArrayList<>();
        private final List<String> mFragmentTitleList = new ArrayList<>();

        ViewPagerAdapter(FragmentManager manager) {
            super(manager);
        }

        @NonNull
        @Override
        public Fragment getItem(int position) {
            return mFragmentList.get(position);
        }

        void addFrag(Fragment fragment, String title) {
            mFragmentList.add(fragment);
            mFragmentTitleList.add(title);
        }

        @Override
        public int getCount() {
            return mFragmentList.size();
        }

        @Override
        public CharSequence getPageTitle(int position) {
            return mFragmentTitleList.get(position);
        }
    }

    private void setupViewPager(ViewPager viewPager) {
        ViewPagerAdapter adapter = new ViewPagerAdapter(getSupportFragmentManager());
        adapter.addFrag(new FragmentDefinition(), "NOUN");
        adapter.addFrag(new FragmentExample(), "VERB");
        adapter.addFrag(new FragmentAntonyms(), "ADJE");
        adapter.addFrag(new FragmentSynonyms(), "SYNO");
        viewPager.setAdapter(adapter);
    }

    /**
     *Press Back Icon
     */
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if(item.getItemId() == android.R.id.home) {
            if (startedFromShare) {
                Intent intent = new Intent(this, MainActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                startActivity(intent);
            }else {
                onBackPressed();
            }
        }
        return super.onOptionsItemSelected(item);
    }

}
