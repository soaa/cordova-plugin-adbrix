package com.github.soaa.adbrix;

import android.util.Log;

import com.igaworks.IgawCommon;
import com.igaworks.IgawDefaultDeeplinkActivity;
import com.igaworks.adbrix.IgawAdbrix;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class AdbrixPlugin extends CordovaPlugin {
    final String TAG = "Adbrix";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        Log.d(TAG, action + " called");

        if ("firstTimeExperience".equals(action)) {
            firstTimeExperience(args, callbackContext);
        } else if("retention".equals(action)) {
            retention(args, callbackContext);
        } else if("setAge".equals(action)) {
            setAge(args, callbackContext);
        } else if("setGender".equals(action)) {
            setGender(args, callbackContext);
        } else if("deeplinkOpen".equals(action)) {
            deeplinkOpen(args, callbackContext);
        } else {
            return false;
        }

        return true;
    }

    private void firstTimeExperience(final JSONArray args, final CallbackContext callbackContext) {
        try {
            if (args.length() > 0) {
                JSONObject options = args.getJSONObject(0);
                IgawAdbrix.firstTimeExperience(options.getString("activity"), options.optString("param"));
            }
        } catch(Exception ex) {
            Log.e(TAG, ex.getMessage(), ex);
        }

        callbackContext.success();
    }

    private void retention(final JSONArray args, final CallbackContext callbackContext) {
        try {
            if (args.length() > 0) {
                JSONObject options = args.getJSONObject(0);
                IgawAdbrix.retention(options.getString("activity"), options.optString("param"));
            }
        } catch(Exception ex) {
            Log.e(TAG, ex.getMessage(), ex);
        }

        callbackContext.success();
    }

    private void setAge(final JSONArray args, final CallbackContext callbackContext) {
        try {
            if (args.length() > 0) {
                int age = args.getInt(0);
                IgawCommon.setAge(age);
            }
        } catch(Exception ex) {
            Log.e(TAG, ex.getMessage(), ex);
        }

        callbackContext.success();
    }

    private void setGender(final JSONArray args, final CallbackContext callbackContext) {
        try {
            if (args.length() > 0) {
                String gender = args.getString(0);

                if (gender.equalsIgnoreCase("M"))
                    IgawCommon.setGender(IgawCommon.Gender.MALE);
                else if(gender.equalsIgnoreCase("F"))
                    IgawCommon.setGender(IgawCommon.Gender.FEMALE);
            }
        } catch(Exception ex) {
            Log.e(TAG, ex.getMessage(), ex);
        }

        callbackContext.success();
    }

    private void deeplinkOpen(final JSONArray args, final CallbackContext callbackContext) {
        try {
            if (args.length() > 0) {
                String url = args.getString(0);

                IgawAdbrix.Commerce.deeplinkOpen(cordova.getActivity().getApplicationContext(), url);
            }
        } catch(Exception ex) {
            Log.e(TAG, ex.getMessage(), ex);
        }

        callbackContext.success();
    }
}
