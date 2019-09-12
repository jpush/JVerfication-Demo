package cn.jiguang.auth.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import cn.jiguang.auth.R;
import cn.jiguang.auth.common.Constants;
import cn.jiguang.verifysdk.api.JVerificationInterface;
import cn.jiguang.verifysdk.api.VerifyListener;

public class TwiceVertificationActivity extends AppCompatActivity implements View.OnClickListener, VerifyListener {

    private ProgressBar mProgressbar;
    private View mViewMsgWarning;
    private View mViewVerificationCode;
    private TextView mTvConfirmWarning;
    private LinearLayout mLlConfirmPay;
    private Button mBtnVerificationCode;
    private Button btnCofirmPay;
    private TextView mTvNum;
    private TextView tvErrorMsg;

    private Intent mIntent;
    private String mNunStr;//页面展示的号码
    private String mNum;//真实号码

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_twice_vertification);
        initData();
        initView();
    }

    private void initData() {
        Intent intent = getIntent();
        mNunStr = intent.getStringExtra(Constants.KEY_NUM);
        if (TextUtils.isEmpty(mNunStr)) {
            mNunStr = "18888888888";
        }
        mNum = mNunStr;
        mNunStr = mNunStr.substring(0, 3) + "****" + mNunStr.substring(7, mNunStr.length());
    }

    private void initView() {
        mProgressbar = (ProgressBar) findViewById(R.id.progressbar);

        ImageView ivBack = (ImageView) findViewById(R.id.iv_back);
        mTvNum = (TextView) findViewById(R.id.tv_num);
        btnCofirmPay = (Button) findViewById(R.id.btn_confirm_pay);

        mViewVerificationCode = findViewById(R.id.view_verification_code);
        mViewMsgWarning = findViewById(R.id.view_msg_warning);
        tvErrorMsg = (TextView) findViewById(R.id.tv_errormsg);
        mTvConfirmWarning = (TextView) findViewById(R.id.tv_confirm_warning);
        mLlConfirmPay = (LinearLayout) findViewById(R.id.ll_confirm_pay);
        mBtnVerificationCode = (Button) findViewById(R.id.btn_verification_code);

        mTvNum.setText(mNunStr);
        ivBack.setOnClickListener(this);
        btnCofirmPay.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_back:
                finish();
                break;
            case R.id.btn_confirm_pay:
                confirmPay();
                break;
        }
    }

    private void confirmPay() {
        mProgressbar.setVisibility(View.VISIBLE);
        btnCofirmPay.setEnabled(false);
        if(mIntent==null){
            mIntent = new Intent();
        }
        mIntent.putExtra(Constants.KEY_NUM, "18888888888");
        setResult(0, mIntent);

//        JVerificationInterface.verifyNumber(this, null, mNum, this);
    }

    @Override
    public void onResult(final int code, String token, String operator) {
        final String errorMsg = "operator="+operator+",code="+code+"\ncontent="+token;
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mProgressbar.setVisibility(View.GONE);
                btnCofirmPay.setEnabled(true);
                if (code == Constants.VERIFY_CONSISTENT) {//认证一致
                    toSuccessActivity(Constants.ACTION_PAY_SUCCESS);
                } else {//失败
                    if (Constants.DEBUG_ENABLE) {
                        tvErrorMsg.setText(errorMsg);
                    } else {
                        tvErrorMsg.setVisibility(View.GONE);
                    }
                    mTvConfirmWarning.setVisibility(View.GONE);
                    mLlConfirmPay.setVisibility(View.GONE);
                    mViewVerificationCode.setVisibility(View.VISIBLE);
                    mViewMsgWarning.setVisibility(View.VISIBLE);
                    mBtnVerificationCode.setText("确认支付");
                }
            }
        });
    }


    private void toSuccessActivity(int action) {
        Intent intent = new Intent(this, LoginResultActivity.class);
        intent.putExtra(Constants.KEY_ACTION,action);
        startActivity(intent);
        finish();
    }
}
