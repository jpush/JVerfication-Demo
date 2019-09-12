package cn.jiguang.auth.activity;

import android.app.Activity;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

import cn.jiguang.auth.R;
import cn.jiguang.auth.common.Constants;
import cn.jiguang.auth.utils.ScreenUtils;

public class NativeVerifyActivity extends Activity implements View.OnClickListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_native_verify);

        findViewById(R.id.tv_go_login).setOnClickListener(this);
        findViewById(R.id.iv_back).setOnClickListener(this);
        findViewById(R.id.btn_login).setOnClickListener(this);

        ScreenUtils.tryFullScreenWhenLandscape(this);
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.btn_login:
                toSuccessActivity(Constants.ACTION_NATIVE_VERIFY_SUCCESS,"");
                finish();
                break;
            case R.id.iv_back:
            case R.id.tv_go_login:
                finish();
                break;
        }
    }

    private void toSuccessActivity(int action,String token) {
        Intent intent = new Intent(this, LoginResultActivity.class);
        intent.putExtra(Constants.KEY_ACTION, action);
        intent.putExtra(Constants.KEY_TOKEN,token);
        startActivity(intent);
    }
}
