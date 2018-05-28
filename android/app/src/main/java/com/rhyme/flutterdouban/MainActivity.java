package com.rhyme.flutterdouban;

import android.content.Intent;
import android.os.Bundle;

import java.util.ArrayList;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL_SHARE="samples.flutter.io/share";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(),CHANNEL_SHARE).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                    if (methodCall.method.equals("ShareToThis")){
                        ArrayList info=methodCall.arguments();
                        boolean isSuccess=shareText(info.get(0),info.get(0),info.get(0)+"\n介绍:\n"+info.get(2)+"\n详情请看:\n"+info.get(1)+"\n来自flutter_douban应用");
                        result.success(isSuccess);
                    }
                }
            }
    );

  }

  private boolean shareText(Object title, Object theme, String content){
    if (content==null||"".equals(content)){
      return false;
    }
    Intent intent=new Intent(Intent.ACTION_SEND);
    intent.setType("text/plain");
    if (theme==null||"".equals(theme)){
     intent.putExtra(Intent.EXTRA_SUBJECT,String.valueOf(theme));
    }
    intent.putExtra(Intent.EXTRA_TEXT,content);
    if (title==null||"".equals(title)){
      startActivity(Intent.createChooser(intent,String.valueOf(title)));
    }else {
      startActivity(intent);
    }
    return true;
  }
}
