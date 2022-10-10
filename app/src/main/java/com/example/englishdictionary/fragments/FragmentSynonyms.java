package com.example.englishdictionary.fragments;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.fragment.app.Fragment;

import com.example.englishdictionary.R;
import com.example.englishdictionary.WordMeaningActivity;

public class FragmentSynonyms extends Fragment {
    public FragmentSynonyms() {

    }

    /**
     * Inflate the layout for this fragment
     */
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_definition, container, false);

        Context context = getActivity();
        TextView text = view.findViewById(R.id.textView);

        String synonyms = ((WordMeaningActivity)context).synonyms;

        if (synonyms != null) {
            synonyms = synonyms.replaceAll(",", ",\n");
            text.setText(synonyms);
        }

        text.setText(synonyms);
        if (synonyms == null) {
            text.setText("No Synonyms found");
        }

        return view;
    }
}
