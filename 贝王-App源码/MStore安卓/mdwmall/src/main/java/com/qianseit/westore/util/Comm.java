package com.qianseit.westore.util;

import java.io.File;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Build;
import android.os.Environment;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.Toast;

import com.beiwangfx.BuildConfig;

public class Comm {
	public static final String TAG = "mwdmall";
	public static final String SDCardPath = android.os.Environment
			.getExternalStorageDirectory().getAbsolutePath();
	public static final String doFolder = buildString(SDCardPath,
			File.separator, TAG, File.separator);
	public static final String doCacheFolder = buildString(doFolder, ".cache",
			File.separator);
	public static final String doImageCacheFolder = buildString(doFolder, "ImageCache",
			File.separator);

//	public static final int SDK = Build.VERSION.SDK_INT;// 系统版本号
	public static final String MODEL = Build.MODEL;// 手机型号

	/**
	 * SDCard是否已经挂载
	 * 
	 * @return
	 */
	public static boolean isExternalStorageAvailable() {
		String state = Environment.getExternalStorageState();
		return Environment.MEDIA_MOUNTED.equals(state);
	}

	/**
	 * 保存App版本号
	 * 
	 * @param context
	 * @param version
	 */
	public static void saveFlag(Context context, int version) {
		Editor prefs = context.getSharedPreferences(TAG, 0).edit();
		prefs.putInt("version", version);
		prefs.commit();
	}

	public static int loadFlag(Context context) {
		SharedPreferences prefs = context.getSharedPreferences(TAG, 0);
		return prefs.getInt("version", 0);
	}

	/**
	 * 创建字符串方法，当需要组装2个以上的字符串时请使用这个方法
	 * 
	 * @param element
	 * @return
	 */
	public static String buildString(Object... element) {
		StringBuffer sb = new StringBuffer();
		for (Object str : element) {
			sb.append(str);
		}
		return sb.toString();
	}

	/**
	 * 文字提醒
	 * 
	 * @param context
	 * @param id
	 */
	public static final void alert(Context context, int id) {
		Toast.makeText(context, id, Toast.LENGTH_SHORT).show();
	}

	public static final void alertL(Context context, int id) {
		Toast.makeText(context, id, Toast.LENGTH_LONG).show();
	}

	public static final void alert(Context context, String str) {
		Toast.makeText(context, str, Toast.LENGTH_SHORT).show();
	}

	public static final void alertL(Context context, String str) {
		Toast.makeText(context, str, Toast.LENGTH_LONG).show();
	}

	/**
	 * log输出方法
	 * 
	 * @param msg
	 */
	public static void log(Object msg) {
		// if (BuildConfig.DEBUG && msg != null) {
		android.util.Log.i(TAG, msg.toString());
		// }
	}

	public static void log(Object... msg) {
		// if (BuildConfig.DEBUG && msg != null) {
		android.util.Log.i(TAG, buildString(msg));
		// }
	}

	/**
	 * log输出方法
	 * 
	 * @param msg
	 */
	public static final void log(Activity a, Object msg) {
		if (BuildConfig.DEBUG && msg != null) {
			String tag = a.getApplication().getApplicationInfo().name;
			android.util.Log.i(tag, msg.toString());
		}
	}

	public static final void log(Activity a, Object... msg) {
		if (BuildConfig.DEBUG && msg != null) {
			String tag = a.getApplication().getApplicationInfo().name;
			android.util.Log.i(tag, buildString(msg));
		}
	}
	public static void setListViewHeightBasedOnChildren(ListView listView) {
		// 获取ListView对应的Adapter
		ListAdapter listAdapter = listView.getAdapter();
		if (listAdapter == null) {
			return;
		}
		int totalHeight = 0;
		for (int i = 0; i < listAdapter.getCount(); i++) { // listAdapter.getCount()返回数据项的数目
			View listItem = listAdapter.getView(i, null, listView);
			listItem.measure(0, 0); // 计算子项View 的宽高
			totalHeight += listItem.getMeasuredHeight(); // 统计所有子项的总高度
		}
		ViewGroup.LayoutParams params = listView.getLayoutParams();
		params.height = totalHeight
				+ (listView.getDividerHeight() * (listAdapter.getCount() - 1));
		params.height =params.height +50;
		// listView.getDividerHeight()获取子项间分隔符占用的高度
		// params.height最后得到整个ListView完整显示需要的高度
		listView.setLayoutParams(params);
	}

}
