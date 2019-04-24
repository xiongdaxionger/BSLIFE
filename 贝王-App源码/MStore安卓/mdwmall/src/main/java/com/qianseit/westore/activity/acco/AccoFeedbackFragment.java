package com.qianseit.westore.activity.acco;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.content.res.ColorStateList;
import android.graphics.Paint;
import android.net.Uri;
import android.os.Bundle;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.TextView;

import com.beiwangfx.R;;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.member.MemberFeedbackIndexInterface;
import com.qianseit.westore.httpinterface.member.MemberSendMsgInterface;
import com.qianseit.westore.ui.FlowLayout;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * 关于、帮助
 * 
 * 
 */
public class AccoFeedbackFragment extends BaseDoFragment implements OnClickListener {
	Dialog mDialog;

	EditText mContentEditText, mTitleEditText, mContactWayEditText;
	FlowLayout mTypeFlowLayout;
	TextView mServicePhoneTextView;

	JSONArray mTypeArray = new JSONArray();
	FeedbackTypeView mConsultTypeView;

	MemberSendMsgInterface mSendMsgInterface = new MemberSendMsgInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			Run.alert(mActivity, "您的反馈已经提交");
			mActivity.setResult(Activity.RESULT_OK);
			mContentEditText.setText("");
			mTitleEditText.setText("");
			mContactWayEditText.setText("");
			mConsultTypeView.reset();
			mTitleEditText.requestFocus();
			mActivity.finish();
		}
	};

	MemberFeedbackIndexInterface mIndexInterface = new MemberFeedbackIndexInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mTypeArray = responseJson.optJSONArray("suggest_type");
			mServicePhoneTextView.setText(responseJson.optString("suggest_mobile"));
			mConsultTypeView.setType(mTypeArray);
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("意见反馈");
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		rootView = inflater.inflate(R.layout.fragment_acco_feedback, null);
		mContentEditText = (EditText) findViewById(R.id.content);
		mTitleEditText = (EditText) findViewById(R.id.title);
		mContactWayEditText = (EditText) findViewById(R.id.contact_way);
		mTypeFlowLayout = (FlowLayout) findViewById(R.id.type);
		mServicePhoneTextView = (TextView) findViewById(R.id.service_phone);

		mServicePhoneTextView.getPaint().setFlags(Paint.UNDERLINE_TEXT_FLAG);
		mServicePhoneTextView.setOnClickListener(this);

		findViewById(R.id.submit_btn).setOnClickListener(this);
		mConsultTypeView = new FeedbackTypeView(mTypeFlowLayout, mTypeArray);
		
		mIndexInterface.RunRequest();
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.service_phone:
			mDialog = CommonLoginFragment.showAlertDialog(mActivity, String.format("确定要拨打客户热线%s吗?", mServicePhoneTextView.getText().toString()), "取消", "确定", null, new OnClickListener() {

				@Override
				public void onClick(View v) {
					String nPhone = mServicePhoneTextView.getText().toString();
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
			if (mTitleEditText.getText().length() <= 0) {
				Run.alert(mActivity, "请输入标题");
				mTitleEditText.requestFocus();
				return;
			}

			if (mContentEditText.getText().length() <= 0) {
				Run.alert(mActivity, "请输入反馈内容");
				mContentEditText.requestFocus();
				return;
			}

			mSendMsgInterface.send(mTitleEditText.getText().toString(), mContentEditText.getText().toString(), mConsultTypeView.getSelectedItem().optInt("type_id"), mContactWayEditText.getText()
					.toString());
			break;

		default:
			break;
		}
		super.onClick(v);
	}

	class FeedbackTypeView implements View.OnClickListener {
		FlowLayout mFlowLayout;
		List<View> mFlowValues = new ArrayList<View>();
		JSONArray mArray;

		int mSelectedIndex = 0;

		int mConsultTypeValueTextSize = 13;
		ColorStateList mColorStateList;

		public FeedbackTypeView(FlowLayout flowLayout, JSONArray feedbackType) {
			mFlowLayout = flowLayout;
			
			mConsultTypeValueTextSize = mActivity.getResources().getDimensionPixelSize(R.dimen.TextSizeBigSmall);
			mColorStateList = mActivity.getResources().getColorStateList(R.color.consult_type_value_selector);

			setType(feedbackType);
		}

		public void setType(JSONArray feedbackType){
			mArray = feedbackType;
			mFlowValues.clear();
			mFlowLayout.removeAllViews();
			if (feedbackType == null || feedbackType.length() <= 0) {
				return;
			}
			
			for (int j = 0; j < mTypeArray.length(); j++) {
				JSONObject nJsonObject = mTypeArray.optJSONObject(j);
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
			mArray = new JSONArray();
		}

		public void reset() {
			if (mFlowValues.size() <= 0) {
				return;
			}

			onClick(mFlowValues.get(0));
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
			if (mArray != null && mArray.length() > mSelectedIndex) {
				return mArray.optJSONObject(mSelectedIndex);
			}

			return new JSONObject();
		}
	}
}
