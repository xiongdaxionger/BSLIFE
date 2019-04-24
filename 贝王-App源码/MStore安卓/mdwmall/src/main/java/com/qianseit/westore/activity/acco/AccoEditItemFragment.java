package com.qianseit.westore.activity.acco;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.os.Bundle;
import android.text.InputType;
import android.text.TextUtils;
import android.widget.LinearLayout;

import com.qianseit.westore.Run;
import com.qianseit.westore.activity.passport.ItemSettingItemView;
import com.qianseit.westore.base.BaseSettingItemFragment;

public class AccoEditItemFragment extends BaseSettingItemFragment {

	ItemSettingItemView mInputView;
	JSONObject mItemJsonObject;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		try {
			mItemJsonObject = new JSONObject(getExtraStringFromBundle(Run.EXTRA_DATA));
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			Run.alert(mActivity, e.getMessage());
			mActivity.finish();
		}
	}
	
	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.save_setting";
	}

	@Override
	protected ContentValues getSaveDatas() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put(mItemJsonObject.optString("attr_column"), mInputView.getSettingValue());
		return nContentValues;
	}

	@Override
	protected void initActionBar() {
		// TODO Auto-generated method stub
		mActionBar.setTitle(mItemJsonObject.optString("attr_name"));
	}

	@Override
	protected boolean verifyInputValue() {
		// TODO Auto-generated method stub
		if (TextUtils.isEmpty(mInputView.getSettingValue())) {
			Run.alert(mActivity, "请输入" + mItemJsonObject.optString("attr_name"));
			return false;
		}
		return true;
	}

	@Override
	protected void initInputView(LinearLayout parentView) {
		// TODO Auto-generated method stub
		int nInputType = InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_NORMAL;
		String nValtype = mItemJsonObject.optString("attr_valtype");
		if (nValtype.equalsIgnoreCase("number")) {
			nInputType = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_VARIATION_NORMAL;
		}
		
		String nTip = "";
		int nLen = 255;
//		if (mItemJsonObject.optString("attr_column").equals("contact[name]")) {
//			nLen = 20;
//			nTip = "姓名不能超过20个字，支持中文、数字和下划线";
//		}
		mInputView = new ItemSettingItemView(mActivity, nInputType, nLen,  mItemJsonObject.optString("attr_value"), nTip, mItemJsonObject.optString("attr_name"));
		if (nValtype.equalsIgnoreCase("alpha")) {
			mInputView.setInputAlpha();
		} else if (nValtype.equalsIgnoreCase("alphaint")) {
			mInputView.setInputAlphaNumber();
		}
		parentView.addView(mInputView);
	}

	@Override
	protected void afterRequstScuu(JSONObject responeData) {
		// TODO Auto-generated method stub
		Run.alert(mActivity, "保存成功");
		Intent nIntent = new Intent();

		///保存昵称
		String column = mItemJsonObject.optString("attr_column");
		if(column != null && column.equals("contact[name]")){
			mLoginedUser.getMember().setName(mInputView.getSettingValue());
		}

		nIntent.putExtra(Run.EXTRA_VALUE, mInputView.getSettingValue());
		mActivity.setResult(Activity.RESULT_OK, nIntent);
		mActivity.finish();
	}

}
