package com.example.mydownload

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.BinaryMessenger
import androidx.core.content.ContextCompat.getSystemService
import io.flutter.embedding.android.FlutterActivity


class MainActivity: FlutterActivity()
{
    private var result: MethodChannel.Result? = null
    private val INTENT_ACTION = "com.example.biometricscanner.SCANNER"
    private val SCANNER_REQ_CODE = 11


    private val callHandler = MethodChannel.MethodCallHandler { call, result ->
        this.result = result
        launchApp2()

    }



    override fun onCreate(savedInstanceState: Bundle?)
    {
        super.onCreate(savedInstanceState)

        MethodChannel(
                getBinaryMessenger(),
                "get.data/Scanner")
                .setMethodCallHandler(callHandler)
    }

    fun getBinaryMessenger(): BinaryMessenger {
        return flutterEngine!!.getDartExecutor().getBinaryMessenger()
    }
    override fun onResume()
    {
        super.onResume()
    }
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?)
    {
        if (requestCode == SCANNER_REQ_CODE)
        {
            if (resultCode == Activity.RESULT_OK)
            {
                val bundle = data?.getBundleExtra("data")
                val value = bundle?.getString("value")
                result?.success(value)
            }
        } else {
            super.onActivityResult(requestCode, resultCode, data)
        }
    }

    @SuppressLint("NewApi")
    private fun launchApp2() {
        val sendIntent = Intent()
        sendIntent.action = INTENT_ACTION
        if (sendIntent.resolveActivity(packageManager) != null) {
            startActivityForResult(sendIntent, SCANNER_REQ_CODE)
        }

    }


}
