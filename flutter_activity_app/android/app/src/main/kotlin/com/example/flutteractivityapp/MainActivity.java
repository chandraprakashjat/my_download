package com.example.flutteractivityapp;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;


import androidx.annotation.NonNull;

import io.flutter.app.FlutterActivity;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.embedding.engine.FlutterEngine;
public class MainActivity extends FlutterActivity {
    private static final String INTENT_ACTION =
            "going.native.for.userdata";

    private static MethodChannel.Result result;

    private MethodChannel.MethodCallHandler callHandler = new
            MethodChannel.MethodCallHandler() {

                @Override
                public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                    MainActivity.result = result;
                    launchApp2();
                    Log.e("Result","Result");
                }


            };

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        Log.e("onMethodCall0","OnMethodCall0");

        new MethodChannel(
                getFlutterView(),
                "going.native.for.userdata")
                .setMethodCallHandler(callHandler);

    }


    @SuppressLint("NewApi")
    private void launchApp2() {

        Log.e("onMethodCall2","OnMethodCall2");
        Intent sendIntent = new Intent();
        sendIntent.setAction(INTENT_ACTION);
        Bundle bundle = new Bundle();
        bundle.putString("user_id","1111");
        sendIntent.putExtra("data",bundle);
        if (sendIntent.resolveActivity(getPackageManager())!=null)
        {
            Log.e("onMethodCall4","OnMethodCall4");
            startActivityForResult(sendIntent,11);
        }
        Log.e("onMethodCall3","OnMethodCall3");
    }

    @Override
    protected void onActivityResult(int req, int res, Intent data)
    {
        if (req == 11)
        {
            if (res == Activity.RESULT_OK) {
                Bundle bundle = data.getBundleExtra("data");
                String username = bundle.getString("username");
                result.success(username);
            }
        }
        else {
            super.onActivityResult(req, res, data);
        }
    }
}
