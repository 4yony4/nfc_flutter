package com.example.nfc_flutter
import android.util.Log
import android.content.Intent
import android.content.Context
import android.nfc.NfcAdapter
import android.nfc.NdefMessage
import io.flutter.embedding.android.FlutterActivity

class NFCActivity: FlutterActivity() {

    override fun getInitialRoute(): String? {


        Log.d("NFCActivity", "message--->!!!!!!!! "+intent.action)
        if (intent != null) {
            processIntent(intent)
        }
        //val action: String? = getIntent().getAction()
        //Log.d("MainActivity", "message---> "+action)
        //print("NFC DETECTED -------->>>>>>>>>>>>>> "+action)

        return "/Product"
    }

    private fun processIntent(checkIntent: Intent) {
        // Check if intent has the action of a discovered NFC tag
        // with NDEF formatted contents
        Log.d("MainActivity", "message--->22222!!!!!!!!!!!!! "+checkIntent.action)
        if (checkIntent.action == NfcAdapter.ACTION_NDEF_DISCOVERED) {
            if ((NfcAdapter.ACTION_NDEF_DISCOVERED == intent.action)||(NfcAdapter.ACTION_TAG_DISCOVERED == intent.action)||(NfcAdapter.ACTION_TECH_DISCOVERED == intent.action)) {
                intent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES)?.also { rawMessages ->
                    val messages: List<NdefMessage> = rawMessages.map { it as NdefMessage }
                    if(messages.first() != null && messages.first().records != null){
                        val uriRecord = String(messages.first().records.first().payload);
                        //MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).invokeMethod("nfc_native",uriRecord);
                        /*this.code=uriRecord;*/
                        var preferences = applicationContext.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                        preferences.edit().putString("flutter.nfcMessage",uriRecord).apply();
                        Log.d("MainActivityD", "message3333---> "+uriRecord)
                    }

                }
            }


            //SE TIENE QUE CAMBIAR ESTA OPCION Y LLAMAR


            //DataHolder.getInstance().scannedNFCTag(checkIntent)

            // Retrieve the raw NDEF message from the tag
            //val rawMessages = checkIntent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES)

            //Log.v("MainActivity","------>>>>>>>>>   MSG "+DataHolder.nfcUtil!!.retrieveNFCMessage(checkIntent))
            // ...

        }
    }

}