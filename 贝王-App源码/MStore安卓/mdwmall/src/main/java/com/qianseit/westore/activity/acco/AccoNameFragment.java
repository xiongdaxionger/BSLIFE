package com.qianseit.westore.activity.acco;

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

public class AccoNameFragment extends BaseSettingItemFragment {

	ItemSettingItemView mInputView;
	String nValue;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		nValue = getExtraStringFromBundle(Run.EXTRA_DATA);
	}
	
	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.passport.save_local_uname";
	}

	@Override
	protected ContentValues getSaveDatas() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("local_name", mInputView.getSettingValue());
		return nContentValues;
	}

	@Override
	protected void initActionBar() {
		// TODO Auto-generated method stub
		mActionBar.setTitle("用户名");
	}

	@Override
	protected boolean verifyInputValue() {
		// TODO Auto-generated method stub
		if (TextUtils.isEmpty(mInputView.getSettingValue())) {
			Run.alert(mActivity, "请输入用户名");
			return false;
		}
		return true;
	}

	@Override
	protected void initInputView(LinearLayout parentView) {
		// TODO Auto-generated method stub
		int nInputType = InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_NORMAL;
		
		String nTip = "<font color='#ff0000'>*</font>用户名设置之后不可修改";
		mInputView = new ItemSettingItemView(mActivity, nInputType, 50,  nValue, nTip, "用户名");
		parentView.addView(mInputView);
	}

	@Override
	protected void afterRequstScuu(JSONObject responeData) {
		// TODO Auto-generated method stub
		Run.alert(mActivity, "保存成功");
		Intent nIntent = new Intent();
		nIntent.putExtra(Run.EXTRA_VALUE, mInputView.getSettingValue());
		mActivity.setResult(Activity.RESULT_OK, nIntent);
		mActivity.finish();
	}

}
