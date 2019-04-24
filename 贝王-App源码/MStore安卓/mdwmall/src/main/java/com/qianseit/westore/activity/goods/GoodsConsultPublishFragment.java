package com.qianseit.westore.activity.goods;

import android.app.Activity;
import android.app.Dialog;
import android.content.ContentValues;
import android.content.Intent;
import android.content.res.ColorStateList;
import android.graphics.Paint;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.goods.GoodsConsultPublishInterface;
import com.qianseit.westore.ui.FlowLayout;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class GoodsConsultPublishFragment extends BaseDoFragment {
	Dialog mDialog;

	EditText mContentEditText, mVCodeEditText;
	ImageView mVCodeImageView;
	FlowLayout mTypeFlowLayout;
	CheckBox mAnonymousConsultBox;
	TextView mConsultTipTextView, mServicePhoneTextView;

	boolean mVCodeOn = false;
	String mGoodsId;
	JSONObject mSettingJsonObject;
	
	List<JSONObject> mTypeJsonObjects = new ArrayList<JSONObject>();
	ConsultTypeView mConsultTypeView;

	GoodsConsultPublishInterface mConsultPublishInterface = new GoodsConsultPublishInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			Run.alert(mActivity, "发表咨询成功");
			mActivity.setResult(Activity.RESULT_OK);
			mActivity.finish();
		}

		@Override
		public ContentValues BuildParams() {
			ContentValues nContentValues = new ContentValues();
			nContentValues.put("gask_type", mConsultTypeView.getSelectedItem().optString("type_id"));
			nContentValues.put("comment", mContentEditText.getText().toString());
			nContentValues.put("hidden_name", mAnonymousConsultBox.isChecked() ? "YES" : "NO");
			if (mVCodeOn) {
				nContentValues.put("askverifyCode", mVCodeEditText.getText().toString());
			}
			nContentValues.put("goods_id", mGoodsId);
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
		mActionBar.setTitle("发表咨询");

		try {
			mSettingJsonObject = new JSONObject(getExtraStringFromBundle(Run.EXTRA_DATA));
			JSONArray nTypeArray = new JSONArray(getExtraStringFromBundle(Run.EXTRA_DETAIL_TYPE));

			for (int j = 0; j < nTypeArray.length(); j++) {
				JSONObject nJsonObject = nTypeArray.optJSONObject(j);
				if (nJsonObject.optInt("type_id") == 0) {//过滤全部咨询
					continue;
				}
				mTypeJsonObjects.add(nJsonObject);
			}
			mGoodsId = getExtraStringFromBundle(Run.EXTRA_GOODS_ID);
			mVCodeOn = !TextUtils.isEmpty(mSettingJsonObject.optString("askVerifyCode"));
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			mSettingJsonObject = new JSONObject();
		}
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		rootView = inflater.inflate(R.layout.fragment_goods_consult_publish, null);
		mContentEditText = (EditText) findViewById(R.id.content);
		mVCodeEditText = (EditText) findViewById(R.id.vcode);
		mVCodeImageView = (ImageView) findViewById(R.id.vcode_ib);
		mTypeFlowLayout = (FlowLayout) findViewById(R.id.type);
		mAnonymousConsultBox = (CheckBox) findViewById(R.id.anonymous_consult);
		mConsultTipTextView = (TextView) findViewById(R.id.consult_tip);
		mServicePhoneTextView = (TextView) findViewById(R.id.service_phone);

		mContentEditText.setHint("请输入咨询类容最多100字");
		mVCodeEditText.setHint("请输入图形验证码");

		mConsultTipTextView.setText(mSettingJsonObject.optString("submit_comment_notice"));
		mServicePhoneTextView.setText(mSettingJsonObject.optString("submit_comment_notice_tel"));
		mServicePhoneTextView.getPaint().setFlags(Paint.UNDERLINE_TEXT_FLAG);
		mServicePhoneTextView.setOnClickListener(this);

		mConsultTypeView = new ConsultTypeView(mTypeFlowLayout, mTypeJsonObjects);

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
				Run.alert(mActivity, "请输入咨询内容");
				mContentEditText.requestFocus();
				return;
			}

			if (mVCodeOn && mVCodeEditText.getText().length() <= 0) {
				Run.alert(mActivity, "请输入验证码");
				mVCodeEditText.requestFocus();
				return;
			}

			mConsultPublishInterface.RunRequest();
			break;

		case R.id.vcode_ib:
			reloadImageVCode();
			break;
		default:
			super.onClick(v);
			break;
		}
	}
	
	void reloadImageVCode(){
		displayRectangleImage(mVCodeImageView, String.format("%s?%s", mSettingJsonObject.optString("askVerifyCode"), System.currentTimeMillis()));
	}

	class ConsultTypeView implements View.OnClickListener {
		FlowLayout mFlowLayout;
		List<View> mFlowValues = new ArrayList<View>();
		List<JSONObject> mArray;

		int mSelectedIndex = 0;

		public JSONObject mItemJsonObject;

		int mConsultTypeValueTextSize = 13;
		ColorStateList mColorStateList;

		public ConsultTypeView(FlowLayout flowLayout, List<JSONObject> consultType) {
			mFlowLayout = flowLayout;
			mArray = consultType;
			mConsultTypeValueTextSize = mActivity.getResources().getDimensionPixelSize(R.dimen.TextSizeBigSmall);
			mColorStateList = mActivity.getResources().getColorStateList(R.color.consult_type_value_selector);

			for (int j = 0; j < mArray.size(); j++) {
				JSONObject nJsonObject = mArray.get(j);
				if (nJsonObject.optInt("type_id") == 0) {//过滤全部咨询
					continue;
				}
				
				View nView = getItemView(nJsonObject);
				nView.setTag(j);
				nView.setOnClickListener(this);
				nView.setSelected(j == mSelectedIndex ? true : false);
				mFlowValues.add(nView);
				mFlowLayout.addView(nView, LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
			}
		}

		public void clearRadioButton() {
			mFlowValues.clear();
			if (mFlowLayout != null) {
				mFlowLayout.removeAllViews();
			}
			mArray = new ArrayList<JSONObject>();
		}

		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			int nClickPosition = (Integer) v.getTag();
			if (nClickPosition == mSelectedIndex) {
				return;
			}

			mFlowValues.get(nClickPosition).setSelected(true);
			mFlowValues.get(mSelectedIndex).setSelected(false);
			if (mFlowValues.get(mSelectedIndex) instanceof RadioButton) {
				((RadioButton) mFlowValues.get(mSelectedIndex)).setChecked(false);
			}
			mSelectedIndex = nClickPosition;
		}

		View getItemView(JSONObject jsonObject) {
			RadioButton nButton = new RadioButton(mActivity);
			nButton.setBackgroundResource(R.drawable.consult_type_value_selector);
			nButton.setTextColor(mColorStateList);
			nButton.setButtonDrawable(android.R.color.transparent);
			nButton.setPadding(Run.dip2px(mActivity, 20), Run.dip2px(mActivity, 5), Run.dip2px(mActivity, 20), Run.dip2px(mActivity, 5));
			nButton.setGravity(Gravity.CENTER);
			nButton.setText(jsonObject.optString("name"));
			nButton.setTextSize(TypedValue.COMPLEX_UNIT_PX, mConsultTypeValueTextSize);
			return nButton;
		}

		public JSONObject getSelectedItem() {
			if (mArray != null && mArray.size() > mSelectedIndex) {
				return mArray.get(mSelectedIndex);
			}

			return null;
		}
	}
}
