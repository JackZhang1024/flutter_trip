package com.example.asr_plugin;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class AsrPlugin implements MethodChannel.MethodCallHandler {

    private static final String TAG = "AsrPlugin";
    private final Activity activity;
    private ResultStateful resultStateful;
    private AsrManager asrManager;

    public static void registerWith(PluginRegistry.Registrar registrar) {
        Log.e(TAG, "registerWith: start");
        MethodChannel channel = new MethodChannel(registrar.messenger(), "asr_plugin");
        AsrPlugin instance = new AsrPlugin(registrar);
        channel.setMethodCallHandler(instance);
        Log.e(TAG, "registerWith: end ");
    }

    private AsrPlugin(PluginRegistry.Registrar registrar) {
        this.activity = registrar.activity();
        initPermission();
    }


    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "start":
                resultStateful = ResultStateful.of(result);
                start(methodCall, resultStateful);
                break;
            case "stop":
                stop(methodCall, result);
                break;
            case "cancel":
                cancel(methodCall, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void start(MethodCall methodCall, ResultStateful result) {
        if (activity == null) {
            Log.e(TAG, "start: ");
            result.error("Ignore start, current activity is null", null, null);
            return;
        }
        if (getAsrManager() != null) {
            getAsrManager().start(methodCall.arguments instanceof Map ? (Map) methodCall.arguments : null);
        } else {
            result.error("Ignore start, current getAsrManager is null", null, null);
        }
    }

    private void stop(MethodCall methodCall, MethodChannel.Result result) {
        if (getAsrManager() != null) {
            getAsrManager().stop();
        } else {
            result.error("Ignore start, current getAsrManager is null", null, null);
        }
    }

    private void cancel(MethodCall methodCall, MethodChannel.Result result) {
        if (getAsrManager() != null) {
            getAsrManager().cancel();
        } else {
            result.error("Ignore start, current getAsrManager is null", null, null);
        }
    }


    @Nullable
    private AsrManager getAsrManager() {
        if (asrManager == null) {
            if (activity != null && !activity.isFinishing()) {
                asrManager = AsrManager.getInstance(activity, onAsrListener);
            }
        }
        return asrManager;
    }

    private OnAsrListener onAsrListener = new OnAsrListener() {
        @Override
        public void onAsrReady() {

        }

        @Override
        public void onAsrBegin() {

        }

        @Override
        public void onAsrEnd() {

        }

        @Override
        public void onAsrPartialResult(String[] results, RecogResult recogResult) {

        }

        @Override
        public void onAsrOnlineNluResult(String nluResult) {

        }

        @Override
        public void onAsrFinalResult(String[] results, RecogResult recogResult) {
             if (resultStateful!=null){
                 resultStateful.success(results[0]);
             }
        }

        @Override
        public void onAsrFinish(RecogResult recogResult) {

        }

        @Override
        public void onAsrFinishError(int errorCode, int subErrorCode, String descMessage, RecogResult recogResult) {
            if (resultStateful!=null){
                resultStateful.error(descMessage, null, null);
            }
        }

        @Override
        public void onAsrLongFinish() {

        }

        @Override
        public void onAsrVolume(int volumePercent, int volume) {

        }

        @Override
        public void onAsrAudio(byte[] data, int offset, int length) {

        }

        @Override
        public void onAsrExit() {

        }

        @Override
        public void onOfflineLoaded() {

        }

        @Override
        public void onOfflineUnLoaded() {

        }
    };

    // 动态权限申请
    private void initPermission() {
        String permissions[] = {Manifest.permission.RECORD_AUDIO,
                Manifest.permission.ACCESS_NETWORK_STATE,
                Manifest.permission.INTERNET,
                Manifest.permission.READ_PHONE_STATE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE
        };

        ArrayList<String> toApplyList = new ArrayList<String>();

        for (String perm : permissions) {
            if (PackageManager.PERMISSION_GRANTED != ContextCompat.checkSelfPermission(activity, perm)) {
                toApplyList.add(perm);
                //进入到这里代表没有权限.
            }
        }
        String tmpList[] = new String[toApplyList.size()];
        if (!toApplyList.isEmpty()) {
            ActivityCompat.requestPermissions(activity, toApplyList.toArray(tmpList), 123);
        }
    }



}
