package com.example.englishdictionary;

import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class DatabaseHelper extends SQLiteOpenHelper {

    private String DB_PATH = null;
    private static String DB_NAME = "englozi.db";
    private SQLiteDatabase myDatabase;
    private final Context myContext;

    public DatabaseHelper(Context context) {
        super(context, DB_NAME, null, 1);
        this.myContext = context;
        this.DB_PATH = "/data/data/" + context.getPackageName() + "/databases/";

    }

    public void createDataBase() throws IOException {
        boolean dbExist = checkDataBase();
        if(!dbExist) {
            this.getReadableDatabase();
            copyDataBase();
        }
    }

    public boolean checkDataBase() {
        SQLiteDatabase checkDB = null;
        String myPath = DB_PATH + DB_NAME;
        // You are using SQLiteDatabase.openDatabase on a file path that may not exist...
        File file = new File(myPath);
        if (file.exists() && !file.isDirectory()) {
            checkDB = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READONLY);
        }
        //...

        if(checkDB != null) {
            checkDB.close();
        }

        return checkDB != null ? true : false;
    }

    private void copyDataBase() throws IOException {
        InputStream myInput = myContext.getAssets().open(DB_NAME);
        String outFileName = DB_PATH + DB_NAME;
        OutputStream myOutput = new FileOutputStream(outFileName);
        byte[] buffer = new byte[1024];
        int length;
        while((length = myInput.read(buffer)) > 0) {
            myOutput.write(buffer, 0, length);
        }
        myOutput.flush();
        myOutput.close();
        myInput.close();
    }

    public void openDataBase() throws SQLException {
        String myPath = DB_PATH + DB_NAME;
        myDatabase = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READWRITE);

    }

    @Override
    public synchronized void close() {
        if(myDatabase != null)
            myDatabase.close();
        super.close();
    }

    @Override
    public void onCreate(SQLiteDatabase db) {

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        this.getReadableDatabase();
        myContext.deleteDatabase(DB_NAME);
        try {
            copyDataBase();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    public Cursor getMeaning(String text) {
        Cursor c = myDatabase.rawQuery("SELECT en_definition, example, antonyms, synonyms FROM words WHERE en_word == LOWER ('" + text + "')", null);
        return c;
    }

    public Cursor getSuggestions(String text) {
        Cursor c = myDatabase.rawQuery("SELECT en_word, _id FROM words WHERE en_word LIKE'" + text + "%' LIMIT 40", null);
        return c;
    }

    public void insertHistory (String text) {
        myDatabase.execSQL("INSERT INTO history(word) VALUES(UPPER('"+ text + "'))");
    }

    public Cursor getHistory() {
        Cursor c = myDatabase.rawQuery("SELECT DISTINCT word, en_definition FROM history h JOIN words w ON h.word==w.en_word ORDER BY h._id DESC", null);
        return c;
    }

    public void deleteHistory() {
        myDatabase.execSQL("DELETE FROM history");
    }

}