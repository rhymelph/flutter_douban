package com.rhyme.flutterdouban;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;

import java.net.URISyntaxException;
import java.util.ArrayList;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL_SHARE="samples.flutter.io/utils";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(),CHANNEL_SHARE).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                    if (methodCall.method.equals("DonateToMe")){
                        ArrayList info=methodCall.arguments();
                        boolean isSuccess= PayAlipay(MainActivity.this,INTENT_URL_FORMAT.replace("{payCode}",String.valueOf(info.get(0))));
                        result.success(isSuccess);
                    }else if (methodCall.method.equals("QQCallMe")){
                        ArrayList info=methodCall.arguments();
                        boolean isSuccess= QQTalk(String.valueOf(info.get(0)));
                        result.success(isSuccess);
                    }
                }
            });
  }
//  private boolean shareText(Object title, Object theme, String content){
//    if (content==null||"".equals(content)){
//      return false;
//    }
//    Intent intent=new Intent(Intent.ACTION_SEND);
//    intent.setType("text/plain");
//    if (theme==null||"".equals(theme)){
//     intent.putExtra(Intent.EXTRA_SUBJECT,String.valueOf(theme));
//    }
//    intent.putExtra(Intent.EXTRA_TEXT,content);
//    if (title==null||"".equals(title)){
//      startActivity(Intent.createChooser(intent,String.valueOf(title)));
//    }else {
//      startActivity(intent);
//    }
//    return true;
//  }
    private static final String INTENT_URL_FORMAT = "intent://platformapi/startapp?saId=10000007&" +
            "clientVersion=3.7.0.0718&qrcode=https%3A%2F%2Fqr.alipay.com%2F{payCode}%3F_s" +
            "%3Dweb-other&_t=1472443966571#Intent;" +
            "scheme=alipayqr;package=com.eg.android.AlipayGphone;end";
    @TargetApi(Build.VERSION_CODES.DONUT)
    public static boolean PayAlipay(Activity activity, String intentFullUrl) {
        try {
            Intent intent = Intent.parseUri(intentFullUrl, Intent.URI_INTENT_SCHEME);
            activity.startActivity(intent);
            return true;
        } catch (URISyntaxException e) {
            e.printStackTrace();
            return false;
        } catch (ActivityNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean QQTalk(String QQ) {
        Intent intent = new Intent();
        intent.setData(Uri.parse("mqqwpa://im/chat?chat_type=wpa&uin=" + QQ));
        try {
            startActivity(intent);
            return true;
        } catch (Exception e) {
            // 未安装手Q或安装的版本不支持
            return false;
        }
    }

}
