package com.qianseit.westore.receiver;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.xg.NotificationService;
import com.qianseit.westore.xg.XGNotification;
import com.tencent.android.tpush.XGPushBaseReceiver;
import com.tencent.android.tpush.XGPushClickedResult;
import com.tencent.android.tpush.XGPushRegisterResult;
import com.tencent.android.tpush.XGPushShowedResult;
import com.tencent.android.tpush.XGPushTextMessage;

@SuppressLint("NewApi")
public class MessageReceiver extends XGPushBaseReceiver {
	private Intent intent = new Intent("com.qq.xgdemo.activity.UPDATE_LISTVIEW");
	public static final String LogTag = "TPushReceiver";

	private void show(Context context, String text) {
//		Toast.makeText(context, text, Toast.LENGTH_SHORT).show();
	}
	
	public static int ID = 0;

	// 通知展示
	@Override
	public void onNotifactionShowedResult(Context context,
			XGPushShowedResult notifiShowedRlt) {
		if (context == null || notifiShowedRlt == null) {
			return;
		}
		XGNotification notific = new XGNotification();
		notific.setMsg_id(notifiShowedRlt.getMsgId());
		notific.setTitle(notifiShowedRlt.getTitle());
		notific.setContent(notifiShowedRlt.getContent());
		// notificationActionType==1为Activity，2为url，3为intent
		notific.setNotificationActionType(notifiShowedRlt
				.getNotificationActionType());
		// Activity,url,intent都可以通过getActivity()获得
		notific.setActivity(notifiShowedRlt.getActivity());
		notific.setUpdate_time(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
				.format(Calendar.getInstance().getTime()));
		NotificationService.getInstance(context).save(notific);
		context.sendBroadcast(intent);
		show(context, "您有1条新消息, " + "通知被展示 ， " + notifiShowedRlt.toString());
	}

	@Override
	public void onUnregisterResult(Context context, int errorCode) {
		if (context == null) {
			return;
		}
		String text = "";
		if (errorCode == XGPushBaseReceiver.SUCCESS) {
			text = "反注册成功";
		} else {
			text = "反注册失败" + errorCode;
		}
		Log.d(LogTag, text);

	}

	@Override
	public void onSetTagResult(Context context, int errorCode, String tagName) {
		if (context == null) {
			return;
		}
		String text = "";
		if (errorCode == XGPushBaseReceiver.SUCCESS) {
			text = "\"" + tagName + "\"设置成功";
		} else {
			text = "\"" + tagName + "\"设置失败,错误码：" + errorCode;
		}
		Log.d(LogTag, text);
		show(context, text);

	}

	@Override
	public void onDeleteTagResult(Context context, int errorCode, String tagName) {
		if (context == null) {
			return;
		}
		String text = "";
		if (errorCode == XGPushBaseReceiver.SUCCESS) {
			text = "\"" + tagName + "\"删除成功";
		} else {
			text = "\"" + tagName + "\"删除失败,错误码：" + errorCode;
		}
		Log.d(LogTag, text);
		show(context, text);

	}

	// 通知点击回调 actionType=1为该消息被清除，actionType=0为该消息被点击
	@Override
	public void onNotifactionClickedResult(Context context,
			XGPushClickedResult message) {
		if (context == null || message == null) {
			return;
		}
		String text = "";
		if (message.getActionType() == XGPushClickedResult.NOTIFACTION_CLICKED_TYPE) {
			// 通知在通知栏被点击啦。。。。。
			// APP自己处理点击的相关动作
			// 这个动作可以在activity的onResume也能监听，请看第3点相关内容
			text = "通知被打开 :" + message;
		} else if (message.getActionType() == XGPushClickedResult.NOTIFACTION_DELETED_TYPE) {
			// 通知被清除啦。。。。
			// APP自己处理通知被清除后的相关动作
			text = "通知被清除 :" + message;
		}
//		Toast.makeText(context, "广播接收到通知被点击:" + message.toString(),
//				Toast.LENGTH_SHORT).show();
		// 获取自定义key-value
		String customContent = message.getCustomContent();
		if (customContent != null && customContent.length() != 0) {
			try {
				JSONObject obj = new JSONObject(customContent);
				// key1为前台配置的key
				if (!obj.isNull("key")) {
					String value = obj.getString("key");
					Log.d(LogTag, "get custom value:" + value);
				}
				// ...
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		// APP自主处理的过程。。。
		Log.d(LogTag, text);
		show(context, text);
	}

	@Override
	public void onRegisterResult(Context context, int errorCode,
			XGPushRegisterResult message) {
		// TODO Auto-generated method stub
		if (context == null || message == null) {
			return;
		}
		String text = "";
		if (errorCode == XGPushBaseReceiver.SUCCESS) {
			text = message + "注册成功";
			// 在这里拿token
			String token = message.getToken();
			AgentApplication.XGToken = token;
		} else {
			text = message + "注册失败，错误码：" + errorCode;
		}
		Log.d(LogTag, text);
	}

	// 消息透传
	@SuppressWarnings("deprecation")
	@Override
	public void onTextMessage(Context context, XGPushTextMessage message) {
		// TODO Auto-generated method stub
		String text = "收到消息:" + message.toString();
		// 获取自定义key-value
		String nType = "", nValue = "";
		try {
			JSONObject nJsonObject = new JSONObject(message.getCustomContent());
			nType = nJsonObject.optString("type");
			nValue = nJsonObject.optString("link");
			if (TextUtils.isEmpty(nType)) {
				return;
			}
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			return;
		}
		
		createNotification(context, message.getTitle(), message.getContent(), nType, nValue);
		
		Log.d(LogTag, text);
		show(context, text);
	}
	
	/**
	 * @param context
	 * @param title
	 * @param content
	 * @param type ('starbuy'=>'促销','product'=>'产品','cat'=>'分类','brand'=>'品牌','article'=>'文章','coupons'=>'优惠券','custom'=>'自定义')
	 * @param value
	 */
	public void createNotification(Context context, String title, String content, String type, String value){
		Intent nIntent = getNewsDestIntent(context, type, value, title);
		if (nIntent == null) {
			return;
		}
		// APP自主处理消息的过程...
		PendingIntent contentIntent = null;
		
		NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
		Notification.Builder mBuilder;  
	    Notification mNotification; 
	    mBuilder = new Notification.Builder(context);
	    
		contentIntent = PendingIntent.getActivity(context, ID, nIntent, PendingIntent.FLAG_UPDATE_CURRENT);
	    mBuilder.setSmallIcon(R.drawable.comm_icon_launcher);
	    mBuilder.setContentTitle(title); 
	    mBuilder.setContentText(content); 
	    mBuilder.setContentIntent(contentIntent); 
	    mBuilder.setWhen(System.currentTimeMillis());
	    mBuilder.setDefaults(Notification.DEFAULT_SOUND);
	    mBuilder.setAutoCancel(true);
	    mNotification = mBuilder.build();  
        notificationManager.notify(ID++, mNotification);
	}
	
	/**
	 * @param type ('starbuy'=>'促销','product'=>'产品','cat'=>'分类','brand'=>'品牌','article'=>'文章','coupons'=>'优惠券','custom'=>'自定义')
	 * @param value
	 * @param title
	 * @return
	 */
	Intent getNewsDestIntent(Context context, String type, String value, String title){
		Intent nIntent = null;
		if ("product".equals(type)) {
			nIntent = AgentActivity.intentForFragment(context, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, value).putExtra("tag_notification", "product");
		} else if ("article".equals(type)) {
			nIntent = AgentActivity.intentForFragment(context, AgentActivity.FRAGMENT_OTHER_ARTICLE_READER).putExtra(Run.EXTRA_ARTICLE_ID, value).putExtra("tag_notification", "article");
		} else if ("cat".equals(type)) {
			Bundle nBundle = new Bundle();
			nBundle.putString(Run.EXTRA_CLASS_ID, value);
			nBundle.putString(Run.EXTRA_TITLE, title);
			nIntent = AgentActivity.intentForFragment(context, AgentActivity.FRAGMENT_SHOPP_GOODS_LIST).putExtras(nBundle).putExtra("tag_notification", "cat");
		} else if ("brand".equals(type)) {
			Bundle nBundle = new Bundle();
			nBundle.putString(Run.EXTRA_BRAND_ID, value);
			nBundle.putString(Run.EXTRA_TITLE, title);
			nIntent = AgentActivity.intentForFragment(context, AgentActivity.FRAGMENT_SHOPP_GOODS_LIST).putExtras(nBundle).putExtra("tag_notification", "brand");
		} else if ("coupons".equals(type)) {
			nIntent = AgentActivity.intentForFragment(context, AgentActivity.FRAGMENT_MARKETING_COUPON_CENTER).putExtra("tag_notification", "coupons");
		}  else if ("starbuy".equals(type)) {
			nIntent = AgentActivity.intentForFragment(context, AgentActivity.FRAGMENT_SHOPP_SECKILL).putExtra("tag_notification", "starbuy");
		}  else if ("custom".equals(type)) {
			nIntent = AgentActivity.intentForFragment(context, AgentActivity.FRAGMENT_OTHER_ARTICLE_READER).putExtra("com.qianseit.westore.EXTRA_URL", value).putExtra(Run.EXTRA_TITLE, title);
		}
		
		return nIntent;
	}
}
