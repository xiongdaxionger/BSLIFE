package com.qianseit.westore.activity.goods;

import android.app.Activity;
import android.app.Dialog;
import android.content.ContentValues;
import android.content.Intent;
import android.graphics.Paint;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.goods.GoodsReplyInterface;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONException;
import org.json.JSONObject;

public class GoodsConsultReplyFragment extends BaseDoFragment {
	Dialog mDialog;

	EditText mContentEditText, mVCodeEditText;
	ImageView mVCodeImageView;
	TextView mConsultTipTextView, mServicePhoneTextView;

	boolean mVCodeOn = false;
	JSONObject mSettingJsonObject;
	JSONObject mConsultJsonObject;

	GoodsReplyInterface mConsultReplyInterface = new GoodsReplyInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			Run.alert(mActivity, "回复成功");
			mActivity.setResult(Activity.RESULT_OK);
			mActivity.finish();
		}

		@Override
		public ContentValues BuildParams() {
			ContentValues nContentValues = new ContentValues();
			nContentValues.put("comment", mContentEditText.getText().toString());
			if (mVCodeOn) {
				nContentValues.put("replyverifyCode", mVCodeEditText.getText().toString());
			}
			nContentValues.put("id", mConsultJsonObject.optString("comment_id"));
			return nContentValues;
		}
		
		@Override
		public void FailRequest() {
			reloadImageVCode();
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("购买咨询");

		try {
			mSettingJsonObject = new JSONObject(getExtraStringFromBundle(Run.EXTRA_DATA));
			mConsultJsonObject = new JSONObject(getExtraStringFromBundle(Run.EXTRA_VALUE));
			mVCodeOn = !TextUtils.isEmpty(mSettingJsonObject.optString("verifyCode"));
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			mSettingJsonObject = new JSONObject();
		}
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		rootView = inflater.inflate(R.layout.fragment_goods_consult_reply, null);
		mContentEditText = (EditText) findViewById(R.id.content);
		mVCodeEditText = (EditText) findViewById(R.id.vcode);
		mVCodeImageView = (ImageView) findViewById(R.id.vcode_ib);
		mConsultTipTextView = (TextView) findViewById(R.id.consult_tip);
		mServicePhoneTextView = (TextView) findViewById(R.id.service_phone);

		mContentEditText.setHint("请输入回复类容最多100字");
		mVCodeEditText.setHint("请输入图形验证码");

		mConsultTipTextView.setText(mSettingJsonObject.optString("submit_comment_notice"));
		mServicePhoneTextView.setText(mSettingJsonObject.optString("submit_comment_notice_tel"));
		mServicePhoneTextView.getPaint().setFlags(Paint.UNDERLINE_TEXT_FLAG);
		mServicePhoneTextView.setOnClickListener(this);

		((TextView) findViewById(R.id.nickname)).setText(mConsultJsonObject.optString("author"));
		((TextView) findViewById(R.id.time)).setText(StringUtils.LongTimeToString("yyyy-MM-dd HH:mm:ss", mConsultJsonObject.optLong("time")));
		((TextView) findViewById(R.id.comment)).setText(mConsultJsonObject.optString("comment"));
		
		if (mVCodeOn) {
			reloadImageVCode();
			mVCodeImageView.setOnClickListener(this);
		} else {
			findViewById(R.id.vcode_tr).setVisibility(View.GONE);
			findViewById(R.id.divider).setVisibility(View.GONE);
			((LinearLayout.LayoutParams) mContentEditText.getLayoutParams()).bottomMargin = Run.dip2px(mActivity, 5);
		}

		findViewById(R.id.submit_btn).setOnClickListener(this);
	}
	
	void reloadImageVCode(){
		displayRectangleImage(mVCodeImageView, String.format("%s?%s", mSettingJsonObject.optString("verifyCode"), System.currentTimeMillis()));
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.service_phone:
			mDialog = CommonLoginFragment.showAlertDialog(mActivity, String.format("确定要拨打客户热线%s吗?", mSettingJsonObject.optString("submit_comment_notice_tel")), "取消", "确定", null,
					new OnClickListener() {

						@Override
						public void onClick(View v) {
							String nPhone = mSettingJsonObject.optString("submit_comment_notice_tel");
							if (nPhone.contains("-")) {
								nPhone = nPhone.replaceAll("-", "");
							}
							Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:" + nPhone));
							intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
							startActivity(intent);
							mDialog.hide();
						}
					}, false, null);
			break;

		case R.id.submit_btn:
			if (mContentEditText.getText().length() <= 0) {
				Run.alert(mActivity, "请输入回复内容");
				mContentEditText.requestFocus();
				return;
			}

			if (mVCodeOn && mVCodeEditText.getText().length() <= 0) {
				Run.alert(mActivity, "请输入验证码");
				mVCodeEditText.requestFocus();
				return;
			}

			mConsultReplyInterface.RunRequest();
			break;

		case R.id.vcode_ib:
			reloadImageVCode();
			break;
		default:
			break;
		}
		super.onClick(v);
	}

}
