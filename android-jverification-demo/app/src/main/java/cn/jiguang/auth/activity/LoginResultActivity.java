package cn.jiguang.auth.activity;

import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.PersistableBundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import org.json.JSONObject;
import org.w3c.dom.Text;

import cn.jiguang.auth.R;
import cn.jiguang.auth.common.Constants;
import cn.jiguang.auth.utils.ScreenUtils;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class LoginResultActivity extends AppCompatActivity implements View.OnClickListener {

    private static final String TAG = "LoginResultActivity";
    private int mAction;
    private String token;
    private TextView tvPhone;
    private TextView tvSuccess;
    private String errorMsg;
    private int errorCode;
    private boolean isFirstInit = true;
    private String phoneNum;
    private View warningMsgView;
    private TextView tvErrorMsg;
    private ImageView imgIcon;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login_result);
        if (savedInstanceState!=null){
            isFirstInit  = false;
        }

        initData();
        initView();
        ScreenUtils.tryFullScreenWhenLandscape(this);

        Log.d(TAG,"onCreate  token="+token);
    }

    private void initData() {
        Intent intent = getIntent();
        mAction = intent.getIntExtra(Constants.KEY_ACTION, Constants.ACTION_VERIFY_SUCCESS);
        token = intent.getStringExtra(Constants.KEY_TOKEN);
        errorMsg = intent.getStringExtra(Constants.KEY_ERORRO_MSG);
        errorCode = intent.getIntExtra(Constants.KEY_ERROR_CODE,0);
    }

    private void initView() {
        tvSuccess = (TextView) findViewById(R.id.tv_success);
        View btn_back2main = findViewById(R.id.btn_back2main);
        if (btn_back2main!= null){
            btn_back2main.setOnClickListener(this);
        }
        findViewById(R.id.iv_back).setOnClickListener(this);
        warningMsgView = findViewById(R.id.view_msg_warning);
        tvErrorMsg = (TextView) findViewById(R.id.tv_errormsg);
        imgIcon = (ImageView) findViewById(R.id.icon);
        tvPhone = (TextView) findViewById(R.id.tv_phone);
        switch (mAction) {
            case Constants.ACTION_VERIFY_SUCCESS:
                tvSuccess.setText("认证成功!");
                break;
            case Constants.ACTION_NATIVE_VERIFY_SUCCESS:
                tvSuccess.setText("登录成功!");
                break;
            case Constants.ACTION_LOGIN_SUCCESS:
                // 获取手机号
                if (isFirstInit){
                    tvSuccess.setText("登录中...");
                    getPhoneNum(token);
                }
                break;
            case Constants.ACTION_LOGIN_FAILED:
            case Constants.ACTION_VERIFY_FAILED:
                showError(mAction);
                break;
        }
    }

    private void showError(int action){
        warningMsgView.setVisibility(View.VISIBLE);
        imgIcon.setImageResource(R.drawable.img_faild);
        if (action == Constants.ACTION_LOGIN_FAILED){
            tvSuccess.setText("登录失败！");
        }else {
            tvSuccess.setText("认证失败!");
        }
        tvPhone.setVisibility(View.VISIBLE);
        tvPhone.setText("可用短信验证码补充");
        tvErrorMsg.setText("[" + errorCode + "]，message=" + errorMsg);
    }



    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        if (phoneNum != null){
            outState.putString("phoneNum",phoneNum);
        }
        outState.putBoolean("isFirstInit",false);
        Log.d(TAG,"onSaveInstanceState");
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);
        String phoneNum = savedInstanceState.getString("phoneNum", "");
        if (!phoneNum.equals("")){
            this.phoneNum = phoneNum;
            tvPhone.setText(phoneNum);
            tvPhone.setVisibility(View.VISIBLE);
            tvSuccess.setText("登录成功!");
        }else {

        }
        Log.d(TAG,"onRestoreInstanceState");

    }

    @Override
    public void onClick(View v) {
//        finish();
        Intent intent = new Intent(this, MainActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(intent);
    }

    public static final MediaType JSON = MediaType.parse("application/json; charset=utf-8");

    private void getPhoneNum(final String token){
        new Thread(){
            @Override
            public void run() {
                super.run();
                try {
                    OkHttpClient client = new OkHttpClient();
                    JSONObject bodyJson = new JSONObject();
                    bodyJson.put("token",token);
                    String body = bodyJson.toString();
                    RequestBody requestBody = RequestBody.create(JSON,body);
                    Log.d(TAG,"request url:"+Constants.verifyUrl);
                    Request request = new Request.Builder().url(Constants.verifyUrl).post(requestBody).build();
                    Response response = client.newCall(request).execute();
                    String responseData = response.body().string();
                    Log.d(TAG,"response :"+responseData);
                    JSONObject responseJson = new JSONObject(responseData);
                    String phone = responseJson.optString("phone");
                    Message message = handler.obtainMessage();
                    message.what = 0;
                    message.obj = phone;
                    phoneNum = phone;
                    handler.sendMessage(message);
                } catch (Throwable e) {
                    Message message = handler.obtainMessage();
                    message.what = 1;
                    handler.sendMessage(message);
                }
            }
        }.start();

    }

    private Handler handler = new Handler(Looper.getMainLooper()){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
//            if (msg.what == 0){
//                tvSuccess.setText("登录成功!");
//                tvPhone.setVisibility(View.VISIBLE);
//                tvPhone.setText("手机号码："+(String)msg.obj);
//            }else {
//                tvSuccess.setText("登录失败!");
//                Intent intent = new Intent(LoginResultActivity.this, VerifyActivity.class);
//                intent.putExtra(Constants.KEY_ACTION,Constants.ACTION_LOGIN_FAILED);
//                intent.putExtra(Constants.KEY_ERORRO_MSG,"获取从后台手机号失败");
//                intent.putExtra(Constants.KEY_ERROR_CODE,Constants.CODE_LOGIN_FAILED);
//                startActivity(intent);
//                LoginResultActivity.this.finish();
//            }
            tvSuccess.setText("登录成功!");
            tvPhone.setVisibility(View.VISIBLE);
            tvPhone.setText("手机号码：xxxxxxxxx");
        }
    };
}
