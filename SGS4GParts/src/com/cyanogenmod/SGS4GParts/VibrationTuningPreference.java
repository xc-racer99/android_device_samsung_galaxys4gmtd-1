package com.cyanogenmod.SGS4GParts;

import android.provider.Settings.System;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.preference.DialogPreference;
import android.preference.PreferenceManager;
import android.util.AttributeSet;
import android.view.View;
import android.widget.SeekBar;
//import android.widget.TextView;

/**
 * Special preference type that allows configuration of both vibration intensity
 */
public class VibrationTuningPreference extends DialogPreference {

    private static final int SEEKBAR_ID = R.id.vibe_intensity_seekbar;

    //private static final int VALUE_DISPLAY_ID = R.id.vibe_intensity_value;

    private static final String FILE = "/sys/devices/virtual/timed_output/vibrator/enable";

    private VibeSeekBar mSeekBar;

    private static final int MAX_VALUE = 5;
    
    private static final int[] mVibeLevels = {
    	0, 1000, 3500, 6000, 8000, 9700
    };

    /**
     * Track instances to know when to restore original intensity
     * (when the orientation changes, a new dialog is created before the old one 
     * is destroyed)
     */
    private static int sInstances = 0;

    public VibrationTuningPreference(Context context, AttributeSet attrs) {
        super(context, attrs);

        setDialogLayoutResource(R.layout.preference_dialog_vibration_intensity);
    }

    @Override
    protected void onBindDialogView(View view) {
        super.onBindDialogView(view);

        sInstances++;

        SeekBar seekBar = (SeekBar) view.findViewById(SEEKBAR_ID);
        //TextView valueDisplay = (TextView) view.findViewById(VALUE_DISPLAY_ID);
        mSeekBar = new VibeSeekBar(seekBar, FILE, getContext());
    }

    @Override
    protected void onDialogClosed(boolean positiveResult) {
        super.onDialogClosed(positiveResult);

        sInstances--;

        if (positiveResult) {
            mSeekBar.save();
        } else if (sInstances == 0) {
            mSeekBar.reset();
        }
    }

    /**
     * Restore vibration intensity from SharedPreferences. (Write to kernel.)
     * @param context       The context to read the SharedPreferences from
     */
    public static void restore(Context context) {
        if (!isSupported()) {
            return;
        }
        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(context);
        int value = sharedPrefs.getInt(FILE, MAX_VALUE);
        Utils.writeVibeIntensity(FILE, mVibeLevels[value]);
    }

    /**
     * Check whether the running kernel supports vibration tuning or not.
     * @return              Whether vibration tuning is supported or not
     */
    public static boolean isSupported() {
        return Utils.fileExists(FILE);
    }

    class VibeSeekBar implements SeekBar.OnSeekBarChangeListener {

        private String mFilePath;
        private int mOriginal;
        private SeekBar mSeekBar;
        private Context mContext;
        //private TextView mValueDisplay;

        public VibeSeekBar(SeekBar seekBar, String filePath, Context context) {
            mSeekBar = seekBar;
            mContext = context;
            //mValueDisplay = valueDisplay;
            mFilePath = filePath;

            // Read original value
            SharedPreferences sharedPreferences = getSharedPreferences();
            mOriginal = sharedPreferences.getInt(mFilePath, MAX_VALUE);

            seekBar.setMax(MAX_VALUE);
            reset();
            seekBar.setOnSeekBarChangeListener(this);
        }

        public void reset() {
            mSeekBar.setProgress(mOriginal);
            updateValue(mOriginal);
        }

        public void save() {
            Editor editor = getEditor();
            editor.putInt(mFilePath, mSeekBar.getProgress());
            editor.commit();
        }

        @Override
        public void onProgressChanged(SeekBar seekBar, int progress,
                boolean fromUser) {
            Utils.writeVibeIntensity(mFilePath, mVibeLevels[progress]);
            //android.provider.Settings.System.putInt(mContext.getContentResolver(), "VIB_FEEDBACK_MAGNITUDE", mVibeLevels[progress]);
            updateValue(progress);
        }

        @Override
        public void onStartTrackingTouch(SeekBar seekBar) {
            // Do nothing
        }

        @Override
        public void onStopTrackingTouch(SeekBar seekBar) {
            // Do nothing
        }

        private void updateValue(int progress) {
            //mValueDisplay.setText(String.format("%.3f", (double) progress / MAX_VALUE));
        }

    }

}
