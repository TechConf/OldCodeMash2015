package com.leadingedje.androidpushnotificationdemo;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.support.v4.content.WakefulBroadcastReceiver;
import android.util.Log;

/**
 * This {@code WakefulBroadcastReceiver} takes care of creating and managing a
 * partial wake lock for your app. It passes off the work of processing the GCM
 * message to an {@code IntentService}, while ensuring that the device does not
 * go back to sleep in the transition. The {@code IntentService} calls
 * {@code GCMBroadcastReceiver.completeWakefulIntent()} when it is ready to
 * release the wake lock.
 */
public class GCMBroadcastReceiver extends WakefulBroadcastReceiver {
    private static final String TAG = GCMBroadcastReceiver.class.getSimpleName();

    /**
     * This method is called when a notification from GCM arrives
     * @see android.content.BroadcastReceiver#onReceive(android.content.Context, android.content.Intent)
     * @param context
     * @param intent
     */
    @Override
    public void onReceive( Context context, Intent intent ) {
        Log.d( TAG, "onReceive(): Started" );

        // Explicitly specify that our GCMIntentService class will handle the intent.
        ComponentName comp = new ComponentName( context.getPackageName(), GCMIntentService.class.getName() );

        // Start the service, keeping the device awake while it is launching.
        startWakefulService( context, ( intent.setComponent( comp ) ) );
        setResultCode( Activity.RESULT_OK );
    }
}
