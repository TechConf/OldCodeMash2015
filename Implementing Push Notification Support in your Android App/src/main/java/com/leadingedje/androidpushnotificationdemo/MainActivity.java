package com.leadingedje.androidpushnotificationdemo;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;

public class MainActivity extends Activity {
    
    private static final String TAG = MainActivity.class.getSimpleName();

    @Override
    protected void onCreate( Bundle savedInstanceState ) {
        super.onCreate( savedInstanceState );
        setContentView( R.layout.activity_main );
        //---------------------------------------------------------------------
        // Are Google Play Services available?
        if ( PushNotificationRegistration.isGooglePlayServicesAvailable( this ) ) {
            // If Google Play Services are available, attempt to register
            // for push notifications
            Log.d( TAG, "onCreate(): Google Play Services are available" );
            PushNotificationRegistration.register( getApplicationContext(), this );
        } else {
            Log.e( TAG, "onCreate(): Google Play Services not available" );
        }
        //---------------------------------------------------------------------
        getAndDisplayNotificationContent( getIntent() );
    }
    
    @Override
    protected void onResume() {
        super.onResume();
        //---------------------------------------------------------------------
        // Are Google Play Services available?
        if ( PushNotificationRegistration.isGooglePlayServicesAvailable( this ) ) {
            Log.d( TAG, "onResume(): Google Play Services are available" );
        } else {
            Log.e( TAG, "onResume(): Google Play Services not available" );
        }
        //---------------------------------------------------------------------
    }
    
    /**
     * Overriding this allows the mobile app to start a fragment
     * when a multiple alarm or message notificaiton is tapped
     * @param intent Intent with action set to the fragment to load
     */
    @Override
    protected void onNewIntent( Intent intent ) {
        getAndDisplayNotificationContent( intent );
    }
    
    /**
     * Get the notification content and display it inside the main activity
     */
    private void getAndDisplayNotificationContent( Intent intent ) {
        Bundle extras = intent.getExtras();
        if ( extras != null && !extras.isEmpty() ) {
            TextView tv = (TextView)findViewById(R.id.titleTextView);
            tv.setText( extras.getString( Constants.TITLE_INTENT_EXTRA_KEY ) );
            tv = (TextView)findViewById(R.id.tickerTextView);
            tv.setText( extras.getString( Constants.TICKER_INTENT_EXTRA_KEY ) );
            tv = (TextView)findViewById(R.id.bigtextTextView);
            tv.setText( extras.getString( Constants.BIGTEXT_INTENT_EXTRA_KEY ) );
            tv = (TextView)findViewById(R.id.contentTextView);
            tv.setText( extras.getString( Constants.CONTENT_INTENT_EXTRA_KEY ) );
        }
    }

    @Override
    public void onDestroy() {
        Log.d( TAG, "onDestroy(): Started" );
        super.onDestroy();
    }

    // Boilerplate code for the settings menu
    @Override
    public boolean onCreateOptionsMenu( Menu menu ) {

        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate( R.menu.main, menu );
        return true;
    }

    @Override
    public boolean onOptionsItemSelected( MenuItem item ) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if ( id == R.id.action_settings ) {
            return true;
        }
        return super.onOptionsItemSelected( item );
    }
}
