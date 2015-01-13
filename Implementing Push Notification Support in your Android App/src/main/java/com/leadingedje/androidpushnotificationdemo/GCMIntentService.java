package com.leadingedje.androidpushnotificationdemo;

import android.app.IntentService;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import com.google.android.gms.gcm.GoogleCloudMessaging;

/**
 * This {@code IntentService} does the actual handling of the GCM message.
 * {@code GCMBroadcastReceiver} (a {@code WakefulBroadcastReceiver}) holds a
 * partial wake lock for this service while the service does its work. When the
 * service is finished, it calls {@code completeWakefulIntent()} to release the
 * wake lock.
 */
public class GCMIntentService extends IntentService {
    private static final String TAG = GCMIntentService.class.getSimpleName();

    public static final int DEMO_NOTIFICATION_ID = 1;

    public GCMIntentService() {
        super( "GCMIntentService" );
        Log.d( TAG, "GCMIntentService(): Started" );
    }

    /**
     * This handler is triggered when a push notification arrives
     * @param intent Intent containing notification information
     */
    @Override
    protected void onHandleIntent( Intent intent ) {
        Log.d( TAG, "onHandleIntent(): Started" );
        Bundle extras = intent.getExtras();
        GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance( this );

        // The getMessageType() intent parameter must be the intent you received
        // in your BroadcastReceiver 
        String messageType = gcm.getMessageType( intent );

        if ( !extras.isEmpty() ) { 
            /*
             * Filter messages based on message type. Since it is likely that
             * GCM will be extended in the future with new message types, just
             * ignore any message types you're not interested in, or that you
             * don't recognize.
             */
            if ( GoogleCloudMessaging.MESSAGE_TYPE_MESSAGE.equals( messageType ) ) {
                // Send notification of received message.
                Log.d( TAG, "onHandleIntent(): Received GCM message: " + extras.toString() );
                sendNotification( intent );
            }
        }

        // Release the wake lock provided by the WakefulBroadcastReceiver.
        GCMBroadcastReceiver.completeWakefulIntent( intent );
    }

    /**
     * Display a notification using the received message. The message contains a
     * JSON object with the notification data.
     * @param intent - Intent containing the push notification data
     */
    private void sendNotification( Intent intent ) {
        Log.d( TAG, "sendNotification(): Started" );
        NotificationManager notificationManager =
            (NotificationManager) this.getSystemService( Context.NOTIFICATION_SERVICE );
        
        // Bundle will contain contents of data section inside 
        // notification JSON data
        Bundle bundle = intent.getExtras();
        
        // Get notification content, use default values if keys don't exist
        String title = bundle.getString( "Title", "Default Title" );
        String bigText = bundle.getString( "BigText", "Default Big Text" );
        String contentText = bundle.getString( "ContentText", "Default Content Text" );
        String tickerText = bundle.getString( "TickerText", "Default Ticker Text" );

        // Build the notification.
        // See http://developer.android.com/reference/android/app/Notification.Builder.html
        Notification.Builder notificationBuilder = new Notification.Builder( this );
        notificationBuilder.setSmallIcon( R.drawable.lelogo )
                           .setContentTitle( title )
                           .setStyle( new Notification.BigTextStyle().bigText( bigText ) )
                           .setContentText( contentText )
                           .setLights( android.R.color.holo_green_light, 300, 1000 )
                           .setDefaults( Notification.DEFAULT_ALL )
                           .setTicker( tickerText );

        // Create the intent to go to when the notification is tapped.
        Intent resultIntent = new Intent( this, MainActivity.class );
        
        // Put the notification data into the intent as extras
        resultIntent.putExtra( Constants.BIGTEXT_INTENT_EXTRA_KEY, bigText );
        resultIntent.putExtra( Constants.CONTENT_INTENT_EXTRA_KEY, contentText );
        resultIntent.putExtra( Constants.TICKER_INTENT_EXTRA_KEY, tickerText );
        resultIntent.putExtra( Constants.TITLE_INTENT_EXTRA_KEY, title );
        
        // This activity will become the start of a new task on this history stack
        resultIntent.addFlags( Intent.FLAG_ACTIVITY_NEW_TASK );
        
        // Setting SINGLE_TOP flag will cause onNewIntent to be called when a notification is tapped 
        resultIntent.addFlags( Intent.FLAG_ACTIVITY_SINGLE_TOP );

        // Set the notification content into the notification builder using the
        // result intent set up above
        notificationBuilder.setContentIntent( PendingIntent.getActivity( this, 0,
                                              resultIntent, PendingIntent.FLAG_ONE_SHOT ) );

        // Send the notification to display it on the device
        Log.d( TAG, "sendNotification(): Calling notify() to send the notification" );
        notificationManager.notify( DEMO_NOTIFICATION_ID, notificationBuilder.build() );
    }
}
