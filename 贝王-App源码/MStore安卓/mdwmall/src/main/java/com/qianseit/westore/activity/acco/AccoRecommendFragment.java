package com.qianseit.westore.activity.acco;

import android.content.ContentValues;
import android.text.TextUtils;
import android.widget.LinearLayout;

import com.qianseit.westore.Run;
import com.qianseit.westore.activity.passport.ItemSettingItemView;
import com.qianseit.westore.base.BaseSettingItemFragment;

import org.json.JSONObject;

public class AccoRecommendFragment extends BaseSettingItemFragment {

	ItemSettingItemView mInputView;

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.member.save_setting";
	}

	@Override
	protected ContentValues getSaveDatas() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("parent_account", mInputView.getSettingValue());
		return nContentValues;
	}

	@Override
	protected void initActionBar() {
		// TODO Auto-generated method stub
		mActionBar.setTitle("绑定推荐人");
	}

	@Override
	protected boolean verifyInputValue() {
		// TODO Auto-generated method stub
		if (TextUtils.isEmpty(mInputView.getSettingValue())) {
			Run.alert(mActivity, "请输入推荐人");
			return false;
		}
		return true;
	}

	@Override
	protected void initInputView(LinearLayout parentView) {
		// TODO Auto-generated method stub
//		mInputView = new ItemSettingItemView(mActivity, InputType.TYPE_CLASS_TEXT, 20, mLoginedUser.getPerson(mActivity), R.string.acco_setting_person_hint, R.string.acco_setting_recom_hint);
		parentView.addView(mInputView);
	}

	@Override
	protected void afterRequstScuu(JSONObject responeData) {
		// TODO Auto-generated method stub
//		mLoginedUser.setPerson(mInputView.getSettingValue());
	}

}
