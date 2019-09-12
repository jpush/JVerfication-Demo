package cn.jiguang.auth.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import org.json.JSONObject;


import cn.jiguang.api.JCoreInterface;
import cn.jiguang.auth.App;
import cn.jiguang.auth.R;
import cn.jiguang.auth.common.Constants;
import cn.jiguang.auth.utils.ScreenUtils;
import cn.jiguang.auth.utils.ToastUtil;
import cn.jiguang.verifysdk.api.JVerificationInterface;
import cn.jiguang.verifysdk.api.VerifyListener;
import cn.jiguang.verifysdk.api.VerifySDK;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

import static cn.jiguang.verifysdk.api.VerifySDK.CODE_VERIFY_EXCEPTION;


public class VerifyActivity extends AppCompatActivity implements View.OnClickListener, VerifyListener {
    private static final String TAG = "VerifyActivity";
    private LinearLayout mProgressbar;
    private View mView;
    private View mViewVerificationCode;
    private EditText mTilNum;
    private RelativeLayout mRlLogin;
    private Button mBtnVerificationCode;
    private Button mBtnLogin;
    private LinearLayout mLayoutBack;
    private String telRegex = "^((13[0-9])|(15[0-9])|(18[0-9])|(17[0-9])|(19[0-9])|(147,145))\\d{8}$";
    private TextView tvTip;
    private LinearLayout mViewMsgWarning;
    private TextView tvErrorMsg;
    private TextView mTvNetWarning;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_verify);
        initView();
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);

        Intent intent = getIntent();
        if (intent!=null){
            int action = intent.getIntExtra(Constants.KEY_ACTION,-1);
            String errorMsg = intent.getStringExtra(Constants.KEY_ERORRO_MSG);
            int errorCode = intent.getIntExtra(Constants.KEY_ERROR_CODE,-1);
            if (action == Constants.ACTION_LOGIN_FAILED){
                if (errorCode== Constants.CODE_LOGIN_CANCELD){
                    tvErrorMsg.setText("一键登录取消，可用短信验证码补充");
                }else{
                    tvErrorMsg.setText("一键登录失败，可用短信验证码补充");
                }
                showErrorTheme();
                showErrorMsg(errorMsg);
            }
        }

        ScreenUtils.tryFullScreenWhenLandscape(this);

    }

    private void initView() {
        mLayoutBack = (LinearLayout) findViewById(R.id.layout_back);
        Log.d(TAG,"layout back:"+mLayoutBack);
        mLayoutBack.setOnClickListener(this);
        mProgressbar = (LinearLayout) findViewById(R.id.progressbar);
        tvTip = (TextView)findViewById(R.id.tvtip);

        mTilNum = (EditText) findViewById(R.id.til_num);
        mBtnLogin = (Button) findViewById(R.id.btn_login);

        mRlLogin = (RelativeLayout) findViewById(R.id.rl_login);
        mViewVerificationCode = findViewById(R.id.view_verification_code);
        mBtnVerificationCode = (Button) findViewById(R.id.btn_verification_code);


        mViewMsgWarning = (LinearLayout)findViewById(R.id.view_msg_warning);
        tvErrorMsg = (TextView) findViewById(R.id.tv_errormsg);
        mTvNetWarning = (TextView) findViewById(R.id.tv_net_warning);


        mBtnLogin.setOnClickListener(this);
        setButtonEnable(true);
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.layout_back){
            this.finish();
        }else if (v.getId() == R.id.btn_login){
            login();
        }
    }

    private boolean checkNum() {
        String numStr = mTilNum.getText().toString();
        if (TextUtils.isEmpty(numStr)) {
            ToastUtil.showShortToast(App.getApp(), "输入号码不能为空");
            return false;
        }
        return  !TextUtils.isEmpty(numStr) && numStr.matches(telRegex);
    }
    
    private void login() {
        if (!checkNum()) {//号码格式错误不进行下一步
            tvTip.setVisibility(View.VISIBLE);
            return;
        }
        tvTip.setVisibility(View.INVISIBLE);
        mProgressbar.setVisibility(View.VISIBLE);
        mBtnLogin.setEnabled(false);
        Log.e(TAG, "phone=" + mTilNum.getText().toString());
//        JVerificationInterface.verifyNumber(this, null, mTilNum.getText().toString(), this);
        JVerificationInterface.getToken(this, new VerifyListener() {
            @Override
            public void onResult(int code, final String content, final String operator) {
                if (code == 2000){
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            realVerifyNumber(content,mTilNum.getText().toString(),operator,VerifyActivity.this);
                        }
                    }).start();

                }else {
                    VerifyActivity.this.onResult(code,content,operator);
                }
            }
        });
    }

    public void showErrorTheme(){
        mViewVerificationCode.setVisibility(View.VISIBLE);
        mRlLogin.setVisibility(View.GONE);
        mBtnVerificationCode.setText("确认");
    }

    public void setButtonEnable(boolean isEnable){
        mBtnLogin.setEnabled(isEnable);
        mBtnVerificationCode.setEnabled(isEnable);
    }

    @Override
    public void onResult(final int code, final String token, final String operator) {
        Log.e(TAG, "onResult: code=" + code + ",token=" + token + ",operator=" + operator);
        final String errorMsg = "operator=" + operator + ",code=" + code + "\ncontent=" + token;
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mProgressbar.setVisibility(View.GONE);
                mBtnLogin.setEnabled(true);
                if (code == Constants.VERIFY_CONSISTENT) {
                    toSuccessActivity(Constants.ACTION_VERIFY_SUCCESS);
                    Log.e(TAG, "onResult: loginSuccess");
                } else {
                    Log.e(TAG, "onResult: loginError");
                    toFailedActivigy(code,token);
                }
            }
        });
    }


    private void toSuccessActivity(int action) {
        Intent intent = new Intent(this, LoginResultActivity.class);
        intent.putExtra(Constants.KEY_ACTION, action);
        startActivity(intent);
        finish();
    }

    private void toFailedActivigy(int code,String errorMsg){
        String msg = errorMsg;
        if (code == 9001){
            msg = "手机号验证不一致";
        }else if (code == 2003){
            msg = "网络连接不通";
        }else if (code == 2005){
            msg = "请求超时";
        }else if (code == 2016){
            msg = "当前网络环境不支持认证";
        }else if (code == 2010){
            msg = "未开启读取手机状态权限";
        }
        Intent intent = new Intent(this, LoginResultActivity.class);
        intent.putExtra(Constants.KEY_ACTION,Constants.ACTION_VERIFY_FAILED);
        intent.putExtra(Constants.KEY_ERORRO_MSG,msg);
        intent.putExtra(Constants.KEY_ERROR_CODE,code);
        startActivity(intent);
        finish();
    }


    private void showErrorMsg(String errorMsg) {
        if (Constants.DEBUG_ENABLE) {
            tvErrorMsg.setText(errorMsg);
        } else {
            tvErrorMsg.setVisibility(View.GONE);
        }
        mViewMsgWarning.setVisibility(View.VISIBLE);
        mTvNetWarning.setVisibility(View.GONE);
    }


    public static final MediaType JSON = MediaType.parse("application/json; charset=utf-8");

    private void realVerifyNumber(String token, String phone, String operator, VerifyListener listener){
        int code;
        String responseData;
        String content = null;
        try {
            OkHttpClient client = new OkHttpClient();
            JSONObject postJson = new JSONObject();
            postJson.put("phone", phone);
            postJson.put("token", token);
            String body = postJson.toString();
            RequestBody requestBody = RequestBody.create(JSON,body);
            Log.d(TAG,"request url:"+Constants.consistUrl);
            Request request = new Request.Builder().url(Constants.consistUrl).post(requestBody).build();
            Response response = client.newCall(request).execute();
            responseData = response.body().string();
            code = response.code();

            Log.d(TAG,"response code = "+code+  " ，msg = "+responseData);
            if (code != 200){
                code = VerifySDK.CODE_NET_EXCEPTION;
                content = "net error";
            }else  if (responseData != null){
                Log.d(TAG, "verify number, code=" + code + " content=" +responseData);
                JSONObject resultJson = new JSONObject(responseData);
                code = resultJson.optInt("consistencyCode");
                if (code == 9000){
                    content = "verify consistent";
                }else if (code == 9001){
                    content = "verify not consistent";
                }else if (code == 9002){
                    content = "unknown result";
                }else if (code == 9003){
                    content = "token expired or not exist";
                }else if (code == 9004){
                    content = "config not found";
                }else if (code == 9005){
                    content = "verify interval is less than the minimum limit";
                }else if (code == 9006){
                    content = "frequency of verifying single number is beyond the maximum limit";
                }else if (code == 9007){
                    content = "beyond daily frequency limit";
                }else if (code == 9010){
                    content = "miss auth";
                }else if (code == 9011){
                    content = "auth failed";
                }else if (code == 9012){
                    content = "parameter invalid";
                }else if (code == 9013){
                    content = "request method not supported";
                }else if (code == 9015){
                    content = "http media type not supported";
                }else if (code == 9018){
                    content = "appKey no money";
                }else if (code == 9031){
                    content = "not validate user";
                }else if (code == 9099){
                    content = "bad server";
                }
            } else {
                code = CODE_VERIFY_EXCEPTION;
                content = "http error, can't get response";
            }

        } catch (Throwable e){
            Log.w(TAG, "phone validate e:" + e);
            code = CODE_VERIFY_EXCEPTION;
            content = e.toString();
        }

        listener.onResult(code,content,operator);
    }

}
