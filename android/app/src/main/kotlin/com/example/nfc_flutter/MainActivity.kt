package com.example.nfc_flutter
import android.util.Log
import android.content.Intent
import android.nfc.NfcAdapter
import android.nfc.NdefMessage
import android.content.Context
import android.app.PendingIntent

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {


    override fun onResume() {
        super.onResume()
        //Log.d("MainActivityD", "ACTION!---> " + intent.action + "     " + intent.toString())
    }
}
