package cn.jiguang.auth.utils;

import android.content.Context;
import android.widget.Toast;

import java.util.Timer;
import java.util.TimerTask;

public class ToastUtil {


    public static void showToast(Context context,String content,int duration){
        final Toast toast=Toast.makeText(context,content, Toast.LENGTH_LONG);
        final Timer timer =new Timer();
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                toast.show();
            }
        },0,3000);
        new Timer().schedule(new TimerTask() {
            @Override
            public void run() {
                toast.cancel();
                timer.cancel();
            }
        }, duration );
    }

    public static void showShortToast(Context context,String content){
        Toast.makeText(context,content,Toast.LENGTH_SHORT).show();
    }

    public static void showLongToast(Context context,String content){
        Toast.makeText(context,content,Toast.LENGTH_LONG).show();
    }


}
