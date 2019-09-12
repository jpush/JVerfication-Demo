package cn.jiguang.auth;

import android.app.Application;
import android.content.Context;
import android.os.Bundle;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import cn.jiguang.api.JCoreInterface;
import cn.jiguang.auth.common.Constants;
import cn.jiguang.verifysdk.api.JVerificationInterface;

public class App extends Application {

    private static App SApp;

    public static App getApp() {
        return SApp;
    }

    @Override
    public void onCreate() {
        super.onCreate();

        SApp = this;

        JVerificationInterface.setDebugMode(true);
        JVerificationInterface.init(this);
    }
}
