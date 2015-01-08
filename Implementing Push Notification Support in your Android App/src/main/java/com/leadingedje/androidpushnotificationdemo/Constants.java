package com.leadingedje.androidpushnotificationdemo;

/**
 * Shared constants
 */
public class Constants {
    /**
     * Prevent construction of this class
     */
    private Constants() {
    }

    /**
     * Substitute you own sender ID here. This is the project number you got from the Google API Console
     */
    public static final String SENDER_ID = "378047010653";
    
    /**
     * Shared preferences name
     */
    public static final String SHARED_PREF_NAME = "androidpushnotificationdemo";
    
    /**
     * GCM registration ID key in shared preferences 
     */
    public static final String PROPERTY_REG_ID = "registration_id";
    
    /**
     * App version key in shared preferences
     */
    public static final String PROPERTY_APP_VERSION = "appVersion";
    
    /**
     * Intent extra keys
     */
    public static final String BIGTEXT_INTENT_EXTRA_KEY = "BigText";
    public static final String CONTENT_INTENT_EXTRA_KEY = "Content";
    public static final String TICKER_INTENT_EXTRA_KEY  = "Ticker";
    public static final String TITLE_INTENT_EXTRA_KEY   = "Title";
}
