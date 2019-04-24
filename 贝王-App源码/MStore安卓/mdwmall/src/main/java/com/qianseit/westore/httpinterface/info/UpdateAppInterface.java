package com.qianseit.westore.httpinterface.info;


import org.json.JSONObject;

import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;
import com.qianseit.westore.util.MyAutoUpdate;
import com.qianseit.westore.util.MyAutoUpdate.UpdateClick;
import com.beiwangfx.R;

public abstract class UpdateAppInterface extends BaseHttpInterfaceTask implements UpdateClick {

	public UpdateAppInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "mobile.index.getAppVer";
	}

	@Override
	public void SuccCallBack(JSONObject responseJson) {
		// TODO Auto-generated method stub
		if (responseJson == null || TextUtils.isEmpty(responseJson.optString("version")) || TextUtils.isEmpty(responseJson.optString("down")) || "null".equals(responseJson.optString("version"))
				|| "null".equals(responseJson.optString("down"))) {
			noNewVersion();
			return;
		}

		if (!TextUtils.equals(responseJson.optString("version"), mBaseActivity.getContext().getString(R.string.app_version_name))) {
			MyAutoUpdate autoUpdate = new MyAutoUpdate(mBaseActivity.getContext(), this);
			autoUpdate.checkUpdateInfo(responseJson.optString("down"), responseJson.optBoolean("is_must") ? 1 : 0, responseJson.optString("explian"));
		} else {
			noNewVersion();
		}
	}

	@Override
	public void FailRequest() {
		// TODO Auto-generated method stub
		noNewVersion();
	}

	@Override
	public void UpdateDismiss(boolean isClose) {
		// TODO Auto-generated method stub
		if (!isClose) {
			cancelUpdate();
		}
	}

	public abstract void noNewVersion();

	public abstract void cancelUpdate();
}
