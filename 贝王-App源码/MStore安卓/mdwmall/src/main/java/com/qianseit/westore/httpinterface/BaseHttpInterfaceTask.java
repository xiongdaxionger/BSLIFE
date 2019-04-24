package com.qianseit.westore.httpinterface;

import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;

import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.util.Map;
import java.util.Map.Entry;

public abstract class BaseHttpInterfaceTask implements JsonTaskHandler, InterfaceHandler {
	protected JSONObject mErrorJsonObject;

	protected QianseitActivityInterface mBaseActivity;
	boolean mAutoStartLoadingDialog = true;

	JsonTask mJsonTask;

	public BaseHttpInterfaceTask(QianseitActivityInterface activityInterface) {
		mBaseActivity = activityInterface;
	}

	@Override
	public JsonRequestBean task_request() {
		if (mAutoStartLoadingDialog) {
			mBaseActivity.showCancelableLoadingDialog();
		}

		JsonRequestBean nBean = new JsonRequestBean(Run.API_URL, InterfaceName());

		ContentValues nContentValues = BuildParams();
		if (nContentValues != null) {
			nBean.addAllParams(nContentValues);
		}
		Map<String, File> nMap = BuildFiles();
		if (nMap != null) {
			for (Entry<String, File> entry : nMap.entrySet()) {
				nBean.files.put(entry.getKey(), entry.getValue());
			}
		}
		return nBean;
	}

	@Override
	public void task_response(String json_str) {
		mBaseActivity.hideLoadingDialog_mt();
		try {
			if (!TextUtils.isEmpty(json_str) && TextUtils.isDigitsOnly(json_str)){
				Run.alert(mBaseActivity.getContext(), json_str);
				return;
			}

			JSONObject all = new JSONObject(json_str);
			if (checkRequestJson(mBaseActivity.getContext(), all)) {
				JSONObject nJsonObject = all.optJSONObject("data");
				SuccCallBack(nJsonObject == null ? all : nJsonObject);
			} else {
				mErrorJsonObject = all;
				FailRequest();
			}
		}catch (JSONException jsonE){
			Run.alert(mBaseActivity.getContext(), jsonE.getMessage());
		}catch (Exception e) {
			FailRequest();
		}
	}

	public void RunRequest() {
		mErrorJsonObject = null;
		Run.excuteJsonTask(mJsonTask = new JsonTask(), this);
	}

	public void AutoStartLoadingDialog(boolean autoStartLoadingDialog){
		mAutoStartLoadingDialog = autoStartLoadingDialog;
	}
	
	@Override
	public Map<String, File> BuildFiles() {
		// TODO Auto-generated method stub
		return null;
	}

	public void FailRequest() {

	}

	public boolean isExcuting() {
		return mJsonTask == null ? false : mJsonTask.isExcuting;
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		return null;
	}

	public static boolean checkRequestJson(Context ctx, JSONObject all) {
		return checkRequestJson(ctx, all, true);
	}

	/**
	 * 检测请求的状态
	 * 
	 * @param ctx
	 * @param all
	 * @return
	 */
	public static boolean checkRequestJson(Context ctx, JSONObject all, boolean alert) {
		if (all == null)
			return false;

		String nCode = all.optString("code");
		if (TextUtils.isEmpty(nCode))
			return true;

		if (TextUtils.equals(nCode, "need_login")) {
			ctx.startActivity(AgentActivity.intentForFragment(ctx, AgentActivity.FRAGMENT_COMM_LOGIN).setFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
			AgentApplication.getLoginedUser(ctx).setIsLogined(false);
			return false;
		}
		
		if (TextUtils.equals(nCode, "cart_empty")) {
			return false;
		}

		if (alert) {
			Run.alert(ctx, all.optString("msg"));
		}
		return false;
	}
}
