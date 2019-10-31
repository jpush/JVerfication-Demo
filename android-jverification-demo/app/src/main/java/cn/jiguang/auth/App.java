package cn.jiguang.auth;

import android.app.Application;
import android.content.Context;
import android.os.Bundle;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import cn.jiguang.api.JCoreInterface;
import cn.jiguang.auth.common.Constants;
import cn.jiguang.share.android.api.JShareInterface;
import cn.jiguang.share.android.api.PlatformConfig;
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


        JShareInterface.setDebugMode(true);
        PlatformConfig platformConfig = new PlatformConfig()
                .setWechat("wx4a58c62d258121ac", "6f43e3fca5b2c3996c20faf5c2a08729")
                .setQQ("101789350", "8bd761ec8be03a0c75477ad1d4eb2a03")
                .setSinaWeibo("2906641376", "b495eedd2ac836895eb06c971e521073", "https://www.jiguang.cn");
        JShareInterface.init(this, platformConfig);
    }
}
