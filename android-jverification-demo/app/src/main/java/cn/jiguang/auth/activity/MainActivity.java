package cn.jiguang.auth.activity;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Color;
import android.graphics.Point;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.os.Build;
import android.support.annotation.Nullable;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowInsets;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import cn.jiguang.auth.App;
import cn.jiguang.auth.R;
import cn.jiguang.auth.common.Constants;
import cn.jiguang.auth.common.PermissionConstants;
import cn.jiguang.auth.common.TextViewVertical;
import cn.jiguang.auth.utils.PermissionUtils;
import cn.jiguang.auth.utils.ScreenUtils;
import cn.jiguang.auth.utils.ToastUtil;
import cn.jiguang.verifysdk.api.JVerificationInterface;
import cn.jiguang.verifysdk.api.JVerifyUIClickCallback;
import cn.jiguang.verifysdk.api.JVerifyUIConfig;
import cn.jiguang.verifysdk.api.VerifyListener;
import pl.droidsonroids.gif.GifImageView;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    private static final String TAG = "MainActivity";

    private String mNumStr;
    private boolean mHasPermission;
    private Button btnLogin;
    private LinearLayout mProgressbar;
    private Button btnLoginDialog;
    private boolean dialogFlag;
    private int winHeight;
    private int winWidth;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        Display defaultDisplay = getWindowManager().getDefaultDisplay();
        Point point = new Point();
        defaultDisplay.getSize(point);
        Log.d(TAG,"winHeight px="+point.y);
        if (point.x>point.y){
            winHeight = point.x;
            winWidth =   point.y;
        }else {
            winHeight =   point.y;
            winWidth = point.x;
        }

//        Log.d(TAG,"winHeight="+winHeight);

        setContentView(R.layout.activity_main);

        ScreenUtils.tryFullScreenWhenLandscape(this);

        initView();
        initPermission();



        getApplication().registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(Activity activity, Bundle bundle) {
            }

            @Override
            public void onActivityStarted(Activity activity) {
                if (activity.getLocalClassName().equals("com.cmic.sso.sdk.activity.LoginAuthActivity")||activity.getLocalClassName().equals("cn.jiguang.verifysdk.CtLoginActivity")){
                    mProgressbar.setVisibility(View.GONE);
                }
            }

            @Override
            public void onActivityResumed(Activity activity) {

            }

            @Override
            public void onActivityPaused(Activity activity) {

            }

            @Override
            public void onActivityStopped(Activity activity) {

            }

            @Override
            public void onActivitySaveInstanceState(Activity activity, Bundle bundle) {

            }

            @Override
            public void onActivityDestroyed(Activity activity) {

            }
        });
    }


    private boolean portrait;



    @SuppressLint("WrongConstant")
    private void initPermission() {
        PermissionUtils.permission(PermissionConstants.STORAGE,PermissionConstants.PHONE)
        .callback(new PermissionUtils.SimpleCallback() {
            @Override
            public void onGranted() {
                mHasPermission = true;
            }

            @Override
            public void onDenied() {
                mHasPermission = false;
            }
        }).request();
    }

    private void initView() {
        btnLogin = (Button) findViewById(R.id.btn_login);
        btnLoginDialog = (Button) findViewById(R.id.btn_login_dialog);
        Button btnRegister = (Button) findViewById(R.id.btn_register);
        mProgressbar = (LinearLayout) findViewById(R.id.progressbar);

        btnLogin.setOnClickListener(this);
        btnLoginDialog.setOnClickListener(this);
        btnRegister.setOnClickListener(this);

    }


    @Override
    public void onClick(View v) {
        if(!mHasPermission){
            ToastUtil.showShortToast(App.getApp(),"请先授予权限");
            initPermission();
            return;
        }
        JVerifyUIConfig.Builder uiConfigBuilder= null;
        switch (v.getId()) {
            case R.id.btn_login:
                btnLoginDialog.setEnabled(false);
                btnLogin.setEnabled(false);
                dialogFlag =false;
                mProgressbar.setVisibility(View.VISIBLE);

                JVerificationInterface.setCustomUIWithConfig(getFullScreenPortraitConfig(),getFullScreenLandscapeConfig());
                JVerificationInterface.loginAuth(this, new VerifyListener() {
                    @Override
                    public void onResult(final int code, final String token, String operator) {
                        Log.e(TAG, "onResult: code=" + code + ",token=" + token + ",operator=" + operator);
                        final String errorMsg = "operator=" + operator + ",code=" + code + "\ncontent=" + token;
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                mProgressbar.setVisibility(View.GONE);
                                btnLoginDialog.setEnabled(true);
                                btnLogin.setEnabled(true);
                                if (code == Constants.CODE_LOGIN_SUCCESS) {
                                    toSuccessActivity(Constants.ACTION_LOGIN_SUCCESS,token);
                                    Log.e(TAG, "onResult: loginSuccess");
                                } else if(code != Constants.CODE_LOGIN_CANCELD){
                                    Log.e(TAG, "onResult: loginError");
                                    toFailedActivigy(code,token);
                                }
                            }
                        });
                    }
                });
                break;
            case R.id.btn_login_dialog:
                btnLoginDialog.setEnabled(false);
                btnLogin.setEnabled(false);
                dialogFlag =true;
                mProgressbar.setVisibility(View.VISIBLE);

                JVerificationInterface.setCustomUIWithConfig(getDialogPortraitConfig(),getDialogLandscapeConfig());
                JVerificationInterface.loginAuth(this, new VerifyListener() {
                    @Override
                    public void onResult(final int code, final String token, String operator) {
                        Log.e(TAG, "onResult: code=" + code + ",token=" + token + ",operator=" + operator);
                        final String errorMsg = "operator=" + operator + ",code=" + code + "\ncontent=" + token;
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                mProgressbar.setVisibility(View.GONE);
                                btnLoginDialog.setEnabled(true);
                                btnLogin.setEnabled(true);
                                if (code == Constants.CODE_LOGIN_SUCCESS) {
                                    toSuccessActivity(Constants.ACTION_LOGIN_SUCCESS,token);
                                    Log.e(TAG, "onResult: loginSuccess");
                                } else if(code != Constants.CODE_LOGIN_CANCELD){
                                    Log.e(TAG, "onResult: loginError");
                                    toFailedActivigy(code,token);
                                }
                            }
                        });
                    }
                });
                break;
            case R.id.btn_register:
                Intent intent = new Intent(MainActivity.this, VerifyActivity.class);
                startActivityForResult(intent,0);
                break;
        }
    }


    private JVerifyUIConfig getFullScreenPortraitConfig(){
        JVerifyUIConfig.Builder uiConfigBuilder = new JVerifyUIConfig.Builder();
        uiConfigBuilder.setSloganTextColor(0xFFD0D0D9);
        uiConfigBuilder.setLogoOffsetY(103);
        uiConfigBuilder.setNumFieldOffsetY(190);
        uiConfigBuilder.setPrivacyState(true);
        uiConfigBuilder.setLogoImgPath("ic_icon");
        uiConfigBuilder.setNavTransparent(true);
        uiConfigBuilder.setNavReturnImgPath("btn_back");
        uiConfigBuilder.setCheckedImgPath(null);
        uiConfigBuilder.setNumberColor(0xFF222328);
        uiConfigBuilder.setLogBtnImgPath("selector_btn_normal");
        uiConfigBuilder.setLogBtnTextColor(0xFFFFFFFF);
        uiConfigBuilder.setLogBtnText("一键登录");
        uiConfigBuilder.setLogBtnOffsetY(255);
        uiConfigBuilder.setLogBtnWidth(300);
        uiConfigBuilder.setLogBtnHeight(45);
        uiConfigBuilder.setAppPrivacyColor(0xFFBBBCC5,0xFF8998FF);
//        uiConfigBuilder.setPrivacyTopOffsetY(310);
        uiConfigBuilder.setPrivacyText("登录即同意《","","","》并授权极光认证Demo获取本机号码");
        uiConfigBuilder.setPrivacyCheckboxHidden(true);
        uiConfigBuilder.setPrivacyTextCenterGravity(true);
        uiConfigBuilder.setPrivacyTextSize(12);
//        uiConfigBuilder.setPrivacyOffsetX(52-15);

        // 手机登录按钮
        RelativeLayout.LayoutParams layoutParamPhoneLogin = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,ViewGroup.LayoutParams.WRAP_CONTENT);
        layoutParamPhoneLogin.setMargins(0, dp2Pix(this,360.0f),0,0);
        layoutParamPhoneLogin.addRule(RelativeLayout.ALIGN_PARENT_TOP,RelativeLayout.TRUE);
        layoutParamPhoneLogin.addRule(RelativeLayout.CENTER_HORIZONTAL,RelativeLayout.TRUE);
        TextView tvPhoneLogin = new TextView(this);
        tvPhoneLogin.setText("手机号码登录");
        tvPhoneLogin.setLayoutParams(layoutParamPhoneLogin);
        uiConfigBuilder.addCustomView(tvPhoneLogin, false, new JVerifyUIClickCallback() {
            @Override
            public void onClicked(Context context, View view) {
                toNativeVerifyActivity();
            }
        });

        // 微信qq新浪登录

        LinearLayout layoutLoginGroup = new LinearLayout(this);
        RelativeLayout.LayoutParams layoutLoginGroupParam = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,ViewGroup.LayoutParams.WRAP_CONTENT);
        layoutLoginGroupParam.setMargins(0, 0,0,dp2Pix(this,180.0f));
        layoutLoginGroupParam.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM,RelativeLayout.TRUE);
        layoutLoginGroupParam.addRule(RelativeLayout.CENTER_HORIZONTAL,RelativeLayout.TRUE);
        layoutLoginGroupParam.setLayoutDirection(LinearLayout.HORIZONTAL);
        layoutLoginGroup.setLayoutParams(layoutLoginGroupParam);

        ImageView btnWechat = new ImageView(this);
        ImageView btnQQ = new ImageView(this);
        ImageView btnXinlang = new ImageView(this);
        btnWechat.setImageResource(R.drawable.o_wechat);
        btnQQ.setImageResource(R.drawable.o_qqx);
        btnXinlang.setImageResource(R.drawable.o_weibo);

        LinearLayout.LayoutParams btnParam = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        btnParam.setMargins(25,0,25,0);

        layoutLoginGroup.addView(btnWechat,btnParam);
        layoutLoginGroup.addView(btnQQ,btnParam);
        layoutLoginGroup.addView(btnXinlang,btnParam);
        uiConfigBuilder.addCustomView(layoutLoginGroup, false, new JVerifyUIClickCallback() {
            @Override
            public void onClicked(Context context, View view) {
                ToastUtil.showToast(MainActivity.this,"功能未实现",1000);
            }
        });

        return uiConfigBuilder.build();
    }

    private JVerifyUIConfig getFullScreenLandscapeConfig(){
        JVerifyUIConfig.Builder uiConfigBuilder = new JVerifyUIConfig.Builder();
        uiConfigBuilder.setStatusBarHidden(true);
        uiConfigBuilder.setSloganTextColor(0xFFD0D0D9);
        uiConfigBuilder.setSloganOffsetY(145);
        uiConfigBuilder.setLogoOffsetY(20);
        uiConfigBuilder.setNumFieldOffsetY(110);
        uiConfigBuilder.setPrivacyState(true);
        uiConfigBuilder.setLogoImgPath("ic_icon");
        uiConfigBuilder.setNavTransparent(true);
        uiConfigBuilder.setNavReturnImgPath("btn_back");
        uiConfigBuilder.setCheckedImgPath("cb_chosen");
        uiConfigBuilder.setUncheckedImgPath("cb_unchosen");
        uiConfigBuilder.setNumberColor(0xFF222328);
        uiConfigBuilder.setLogBtnImgPath("selector_btn_normal");
        uiConfigBuilder.setLogBtnTextColor(0xFFFFFFFF);
        uiConfigBuilder.setLogBtnText("一键登录");
        uiConfigBuilder.setLogBtnOffsetY(175);
        uiConfigBuilder.setLogBtnWidth(300);
        uiConfigBuilder.setLogBtnHeight(45);
        uiConfigBuilder.setAppPrivacyColor(0xFFBBBCC5,0xFF8998FF);
        uiConfigBuilder.setPrivacyText("登录即同意《","","","》并授权极光认证Demo获取本机号码");
        uiConfigBuilder.setPrivacyCheckboxHidden(true);
        uiConfigBuilder.setPrivacyTextCenterGravity(true);
        uiConfigBuilder.setPrivacyTextSize(12);
//        uiConfigBuilder.setPrivacyOffsetX(52-15);
        uiConfigBuilder.setPrivacyOffsetY(18);

        // 手机登录按钮
        RelativeLayout.LayoutParams layoutParamPhoneLogin = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,ViewGroup.LayoutParams.WRAP_CONTENT);
        layoutParamPhoneLogin.setMargins(0,  dp2Pix(this,15.0f),dp2Pix(this,15.0f),0);
        layoutParamPhoneLogin.addRule(RelativeLayout.ALIGN_PARENT_RIGHT,RelativeLayout.TRUE);
        layoutParamPhoneLogin.addRule(RelativeLayout.ALIGN_PARENT_TOP,RelativeLayout.TRUE);
        TextView tvPhoneLogin = new TextView(this);
        tvPhoneLogin.setText("手机号码登录");
        tvPhoneLogin.setLayoutParams(layoutParamPhoneLogin);
        uiConfigBuilder.addNavControlView(tvPhoneLogin, new JVerifyUIClickCallback() {
            @Override
            public void onClicked(Context context, View view) {
                toNativeVerifyActivity();
            }
        });

        // 微信qq新浪登录

        LinearLayout layoutLoginGroup = new LinearLayout(this);
        RelativeLayout.LayoutParams layoutLoginGroupParam = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,ViewGroup.LayoutParams.WRAP_CONTENT);
        layoutLoginGroupParam.setMargins(0,dp2Pix(this,235), 0,0);
        layoutLoginGroupParam.addRule(RelativeLayout.ALIGN_PARENT_TOP,RelativeLayout.TRUE);
        layoutLoginGroupParam.addRule(RelativeLayout.CENTER_HORIZONTAL,RelativeLayout.TRUE);
        layoutLoginGroupParam.setLayoutDirection(LinearLayout.HORIZONTAL);
        layoutLoginGroup.setLayoutParams(layoutLoginGroupParam);

        ImageView btnWechat = new ImageView(this);
        ImageView btnQQ = new ImageView(this);
        ImageView btnXinlang = new ImageView(this);
        btnWechat.setImageResource(R.drawable.o_wechat);
        btnQQ.setImageResource(R.drawable.o_qqx);
        btnXinlang.setImageResource(R.drawable.o_weibo);

        LinearLayout.LayoutParams btnParam = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        btnParam.setMargins(25,0,25,0);

        layoutLoginGroup.addView(btnWechat,btnParam);
        layoutLoginGroup.addView(btnQQ,btnParam);
        layoutLoginGroup.addView(btnXinlang,btnParam);
        uiConfigBuilder.addCustomView(layoutLoginGroup, false, new JVerifyUIClickCallback() {
            @Override
            public void onClicked(Context context, View view) {
                ToastUtil.showToast(MainActivity.this,"功能未实现",1000);
            }
        });

        return uiConfigBuilder.build();
    }


    private JVerifyUIConfig getDialogPortraitConfig(){
        int widthDp = px2dip(this, winWidth);
        JVerifyUIConfig.Builder uiConfigBuilder = new JVerifyUIConfig.Builder().setDialogTheme(widthDp-60, 300, 0, 0, false);
//        uiConfigBuilder.setLogoHeight(30);
//        uiConfigBuilder.setLogoWidth(30);
//        uiConfigBuilder.setLogoOffsetY(-15);
//        uiConfigBuilder.setLogoOffsetX((widthDp-40)/2-15-20);
//        uiConfigBuilder.setLogoImgPath("logo_login_land");
        uiConfigBuilder.setLogoHidden(true);

        uiConfigBuilder.setNumFieldOffsetY(104).setNumberColor(Color.BLACK);
        uiConfigBuilder.setSloganOffsetY(135);
        uiConfigBuilder.setSloganTextColor(0xFFD0D0D9);
        uiConfigBuilder.setLogBtnOffsetY(161);

        uiConfigBuilder.setPrivacyOffsetY(15);
        uiConfigBuilder.setCheckedImgPath("cb_chosen");
        uiConfigBuilder.setUncheckedImgPath("cb_unchosen");
        uiConfigBuilder.setNumberColor(0xFF222328);
        uiConfigBuilder.setLogBtnImgPath("selector_btn_normal");
        uiConfigBuilder.setPrivacyState(true);
        uiConfigBuilder.setLogBtnText("一键登录");
        uiConfigBuilder.setLogBtnHeight(44);
        uiConfigBuilder.setLogBtnWidth(250);
        uiConfigBuilder.setAppPrivacyColor(0xFFBBBCC5,0xFF8998FF);
        uiConfigBuilder.setPrivacyText("登录即同意《","","","》并授权极光认证Demo获取本机号码");
        uiConfigBuilder.setPrivacyCheckboxHidden(true);
        uiConfigBuilder.setPrivacyTextCenterGravity(true);
//        uiConfigBuilder.setPrivacyOffsetX(52-15);
        uiConfigBuilder.setPrivacyTextSize(10);



        // 图标和标题
        LinearLayout layoutTitle = new LinearLayout(this);
        RelativeLayout.LayoutParams layoutTitleParam = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,ViewGroup.LayoutParams.WRAP_CONTENT);
        layoutTitleParam.setMargins(0,dp2Pix(this,50), 0,0);
        layoutTitleParam.addRule(RelativeLayout.ALIGN_PARENT_TOP,RelativeLayout.TRUE);
        layoutTitleParam.addRule(RelativeLayout.CENTER_HORIZONTAL,RelativeLayout.TRUE);
        layoutTitleParam.setLayoutDirection(LinearLayout.HORIZONTAL);
        layoutTitle.setLayoutParams(layoutTitleParam);

        ImageView img = new ImageView(this);
        img.setImageResource(R.drawable.logo_login_land);
        TextView tvTitle = new TextView(this);
        tvTitle.setText("极光认证");
        tvTitle.setTextSize(19);
        tvTitle.setTextColor(Color.BLACK);
        tvTitle.setTypeface(Typeface.defaultFromStyle(Typeface.BOLD));

        LinearLayout.LayoutParams imgParam = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        imgParam.setMargins(0,0,dp2Pix(this,6),0);
        LinearLayout.LayoutParams titleParam = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        imgParam.setMargins(0,0,dp2Pix(this,4),0);
        layoutTitle.addView(img,imgParam);
        layoutTitle.addView(tvTitle,titleParam);
        uiConfigBuilder.addCustomView(layoutTitle,false,null);

        // 关闭按钮
        ImageView closeButton = new ImageView(this);

        RelativeLayout.LayoutParams mLayoutParams1 = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        mLayoutParams1.setMargins(0, dp2Pix(this,10.0f),dp2Pix(this,10),0);
        mLayoutParams1.addRule(RelativeLayout.ALIGN_PARENT_RIGHT,RelativeLayout.TRUE);
        mLayoutParams1.addRule(RelativeLayout.ALIGN_PARENT_TOP,RelativeLayout.TRUE);
        closeButton.setLayoutParams(mLayoutParams1);
        closeButton.setImageResource(R.drawable.btn_close);
        uiConfigBuilder.addCustomView(closeButton, true, null);

        return uiConfigBuilder.build();
    }

    private JVerifyUIConfig getDialogLandscapeConfig(){
        int widthDp = px2dip(this, winWidth);
        JVerifyUIConfig.Builder uiConfigBuilder = new JVerifyUIConfig.Builder().setDialogTheme(480, widthDp-100, 0, 0, false);
//        uiConfigBuilder.setLogoHeight(40);
//        uiConfigBuilder.setLogoWidth(40);
//        uiConfigBuilder.setLogoOffsetY(-15);
//        uiConfigBuilder.setLogoImgPath("logo_login_land");
        uiConfigBuilder.setLogoHidden(true);

        uiConfigBuilder.setNumFieldOffsetY(104).setNumberColor(Color.BLACK);
        uiConfigBuilder.setNumberSize(22);
        uiConfigBuilder.setSloganOffsetY(135);
        uiConfigBuilder.setSloganTextColor(0xFFD0D0D9);
        uiConfigBuilder.setLogBtnOffsetY(161);

        uiConfigBuilder.setPrivacyOffsetY(15);
        uiConfigBuilder.setCheckedImgPath("cb_chosen");
        uiConfigBuilder.setUncheckedImgPath("cb_unchosen");
        uiConfigBuilder.setNumberColor(0xFF222328);
        uiConfigBuilder.setLogBtnImgPath("selector_btn_normal");
        uiConfigBuilder.setPrivacyState(true);
        uiConfigBuilder.setLogBtnText("一键登录");
        uiConfigBuilder.setLogBtnHeight(44);
        uiConfigBuilder.setLogBtnWidth(250);
        uiConfigBuilder.setAppPrivacyColor(0xFFBBBCC5,0xFF8998FF);
        uiConfigBuilder.setPrivacyText("登录即同意《","","","》并授权极光认证Demo获取本机号码");
        uiConfigBuilder.setPrivacyCheckboxHidden(true);
        uiConfigBuilder.setPrivacyTextCenterGravity(true);
//        uiConfigBuilder.setPrivacyOffsetX(52-15);
        uiConfigBuilder.setPrivacyTextSize(10);

        // 图标和标题
        LinearLayout layoutTitle = new LinearLayout(this);
        RelativeLayout.LayoutParams layoutTitleParam = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,ViewGroup.LayoutParams.WRAP_CONTENT);
        layoutTitleParam.setMargins(dp2Pix(this,20),dp2Pix(this,15), 0,0);
        layoutTitleParam.addRule(RelativeLayout.ALIGN_PARENT_TOP,RelativeLayout.TRUE);
        layoutTitleParam.setLayoutDirection(LinearLayout.HORIZONTAL);
        layoutTitle.setLayoutParams(layoutTitleParam);

        ImageView img = new ImageView(this);
        img.setImageResource(R.drawable.logo_login_land);
        TextView tvTitle = new TextView(this);
        tvTitle.setText("极光认证");
        tvTitle.setTextSize(19);
        tvTitle.setTextColor(Color.BLACK);
        tvTitle.setTypeface(Typeface.defaultFromStyle(Typeface.BOLD));

        LinearLayout.LayoutParams imgParam = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        imgParam.setMargins(0,0,dp2Pix(this,6),0);
        LinearLayout.LayoutParams titleParam = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        imgParam.setMargins(0,0,dp2Pix(this,4),0);
        layoutTitle.addView(img,imgParam);
        layoutTitle.addView(tvTitle,titleParam);
        uiConfigBuilder.addCustomView(layoutTitle,false,null);


        // 关闭按钮
        ImageView closeButton = new ImageView(this);

        RelativeLayout.LayoutParams mLayoutParams1 = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        mLayoutParams1.setMargins(0, dp2Pix(this,10.0f),dp2Pix(this,10),0);
        mLayoutParams1.addRule(RelativeLayout.ALIGN_PARENT_RIGHT,RelativeLayout.TRUE);
        mLayoutParams1.addRule(RelativeLayout.ALIGN_PARENT_TOP,RelativeLayout.TRUE);
        closeButton.setLayoutParams(mLayoutParams1);
        closeButton.setImageResource(R.drawable.btn_close);
        uiConfigBuilder.addCustomView(closeButton, true, null);

        return uiConfigBuilder.build();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        if(resultCode!=0||intent==null){
            return;
        }
        mNumStr = intent.getStringExtra(Constants.KEY_NUM);
    }


    private void toSuccessActivity(int action,String token) {
        Intent intent = new Intent(this, LoginResultActivity.class);
        intent.putExtra(Constants.KEY_ACTION, action);
        intent.putExtra(Constants.KEY_TOKEN,token);
        startActivity(intent);
    }

    private void toFailedActivigy(int code,String errorMsg){
        String msg = errorMsg;
        if (code == 2003){
            msg = "网络连接不通";
        }else if (code == 2005){
            msg = "请求超时";
        }else if (code == 2016){
            msg = "当前网络环境不支持认证";
        }else if (code == 2010){
            msg = "未开启读取手机状态权限";
        }else if (code == 6001){
            msg = "获取loginToken失败";
        }else if (code == 6006){
            msg = "预取号结果超时，需要重新预取号";
        }
        Intent intent = new Intent(this, LoginResultActivity.class);
        intent.putExtra(Constants.KEY_ACTION,Constants.ACTION_LOGIN_FAILED);
        intent.putExtra(Constants.KEY_ERORRO_MSG,msg);
        intent.putExtra(Constants.KEY_ERROR_CODE,code);
        startActivity(intent);
    }

    private void toNativeVerifyActivity() {
        Intent intent = new Intent(this, NativeVerifyActivity.class);
        startActivity(intent);
    }

    private int dp2Pix(Context context, float dp) {
        try {
            float density = context.getResources().getDisplayMetrics().density;
            return (int) (dp * density + 0.5F);
        } catch (Exception e) {
            return (int) dp;
        }
    }

    private int px2dip(Context context, int pxValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }

}
