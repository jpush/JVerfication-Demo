package cn.jiguang.auth.common;


import cn.jiguang.auth.BuildConfig;

public class Constants {

    public static final Boolean DEBUG_ENABLE = BuildConfig.DEBUG_ENABLE;

    public static final String KEY_ACTION = "action";

    public static final String KEY_NUM = "num";

    public static final String KEY_TOKEN = "token";

    public static final int ACTION_LOGIN = 0;

    public static final int ACTION_REGISTER = 1;

    public static final int ACTION_PAY_SUCCESS = 2;

    public static final int ACTION_VERIFY_SUCCESS = 3;


    public static final int ACTION_REGISTER_SUCCESS = 4;

    public static final int ACTION_LOGIN_SUCCESS = 5;

    public static final int ACTION_LOGIN_FAILED = 6;

    public static final int ACTION_NATIVE_VERIFY_SUCCESS = 7;

    public static final int ACTION_VERIFY_FAILED = 8;


    public static final int ACTION_THIRD_AUTHORIZED_SUCCESS = 9;

    public static final int ACTION_THIRD_AUTHORIZED_FAILED = 10;
	
    public static String verifyUrl = "此处填写您自己服务端实现的获取手机号码API接口地址";

    public static String consistUrl = "此处填写您自己服务端实现的手机号验证API接口地址";

    //-----------------------------------------认证sdk错误码-----------------------------------------

    public static final int VERIFY_CONSISTENT = 9000;//手机号验证一致
    public static final int FETCH_TOKEN_SUCCESS = 2000;//获取token成功
    public static final int CODE_LOGIN_SUCCESS = 6000;
    public static final int CODE_LOGIN_FAILED = 6001;
    public static final int CODE_LOGIN_CANCELD = 6002;

    public static final String KEY_ERORRO_MSG = "error_msg";
    public static final String KEY_ERROR_CODE = "error_code";


    //-----------
    public static final int HTTP_TIME_OUT=15*1000;

    //前后两次的间隔,默认30秒
    public static  long INTERVAL_TIME = 1000*30;

    //以下是本地错误码
    public static final int NET_ERROR_CODE=2998;//网络错误
    public static final int NET_TIMEOUT_CODE=3001;//网络超时
    public static final int NET_UNKNOW_HOST = 3003;//域名无效
    public static final int NET_MALTFORMED_ERROR = 3004;//Malformed异常
}
