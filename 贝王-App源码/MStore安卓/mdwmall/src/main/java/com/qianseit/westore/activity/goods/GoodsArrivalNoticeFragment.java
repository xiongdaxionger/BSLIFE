package com.qianseit.westore.activity.goods;

import android.content.ContentValues;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseSettingItemFragment;

import org.json.JSONObject;

public class GoodsArrivalNoticeFragment extends BaseSettingItemFragment {

	EditText mPhoneEditText, mEmailEditText;
	String mGoodsId, mProductId;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mGoodsId = getExtraStringFromBundle(Run.EXTRA_GOODS_ID);
		mProductId = getExtraStringFromBundle(Run.EXTRA_PRODUCT_ID);
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.product.toNotify";
	}

	@Override
	protected ContentValues getSaveDatas() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("goods_id", mGoodsId);
		nContentValues.put("product_id", mProductId);
		if (mPhoneEditText.getText().length() > 0) {
			nContentValues.put("cellphone", mPhoneEditText.getText().toString());
		}
		if (mEmailEditText.getText().length() > 0) {
			nContentValues.put("email", mEmailEditText.getText().toString());
		}
		return nContentValues;
	}

	@Override
	protected void afterRequstScuu(JSONObject responeData) {
		// TODO Auto-generated method stub

	}

	@Override
	protected void initActionBar() {
		// TODO Auto-generated method stub
		mActionBar.setTitle("到货通知");
	}

	@Override
	protected boolean verifyInputValue() {
		// TODO Auto-generated method stub
		if (mPhoneEditText.getText().length() <= 0 && mEmailEditText.getText().length() <= 0) {
			Run.alert(mActivity, "请填写手机或邮箱，到货时我们会将通过手机短信或邮箱提醒您");
			return false;
		}

		if (mPhoneEditText.getText().length() > 0 && !Run.isPhoneNumber(mPhoneEditText.getText().toString())) {
			Run.alert(mActivity, "请填写正确的手机号");
			mPhoneEditText.requestFocus();
			return false;
		}

		if (mEmailEditText.getText().length() > 0 && !Run.isEmailAddr(mEmailEditText.getText().toString())) {
			Run.alert(mActivity, "请填写正确的邮箱地址");
			mEmailEditText.requestFocus();
			return false;
		}

		return true;
	}

	@Override
	protected void initInputView(LinearLayout parentView) {
		// TODO Auto-generated method stub
		View nView = View.inflate(mActivity, R.layout.item_goods_arrival_notice, null);
		parentView.addView(nView);

		mPhoneEditText = (EditText) nView.findViewById(R.id.phone);
		mEmailEditText = (EditText) nView.findViewById(R.id.email);
	}
}
