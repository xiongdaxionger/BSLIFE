package com.qianseit.westore.activity.acco;

import org.json.JSONObject;

import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.beiwangfx.R;;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.base.BaseWebviewFragment;
import com.qianseit.westore.httpinterface.member.MemberLvRemarkInterface;

public class AccoLvFragment extends BaseWebviewFragment {
	ImageView mAvatarImageView;
	TextView mUNameTextView, mUpgradeInfoTextView, mUpgradeInfo1TextView, mProgressTextView, mLvTextView;
	ProgressBar mProgressBar;

	LoginedUser mLoginedUser = LoginedUser.getInstance();

	String mContent = "";

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("会员");
	}

	@Override
	protected void init() {
		// TODO Auto-generated method stub
		new MemberLvRemarkInterface(this) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				mContent = responseJson.optString("explain");
				loadWebContent();
			}
		}.RunRequest();
	}

	@Override
	public String getContent() {
		// TODO Auto-generated method stub
		return mContent;
	}

	@Override
	protected void initTop(LinearLayout topContainLayout) {
		// TODO Auto-generated method stub
		View nHeader = View.inflate(mActivity, R.layout.header_acco_lv, null);
		topContainLayout.addView(nHeader);

		mAvatarImageView = (ImageView) nHeader.findViewById(R.id.acco_header_avatar);
		mUNameTextView = (TextView) nHeader.findViewById(R.id.acco_header_name);
		mLvTextView = (TextView) nHeader.findViewById(R.id.acco_hander_lv);
		mProgressTextView = (TextView) nHeader.findViewById(R.id.acco_hander_progress_tv);
		mUpgradeInfoTextView = (TextView) nHeader.findViewById(R.id.upgrade_tip);
		mUpgradeInfo1TextView = (TextView) nHeader.findViewById(R.id.upgrade1_tip);
		mProgressBar = (ProgressBar) nHeader.findViewById(R.id.acco_hander_progress_lv);

		mUNameTextView.setText(mLoginedUser.getMember().getUname());
		displayCircleImage(mAvatarImageView, mLoginedUser.getAvatarUri());
		mLvTextView.setText(mLoginedUser.getMemberLvName());

		int nProgress = mLoginedUser.mMemberIndex.getSwitch_lv().getSwitch_type() == 0 ? mLoginedUser.getMember().getUsage_point() : mLoginedUser.getMember().getExperience();
		int nMax = mLoginedUser.mMemberIndex.getSwitch_lv().getLv_data();
		if (mLoginedUser.mMemberIndex.getSwitch_lv().getShow().equalsIgnoreCase("yes")) {
			mProgressTextView.setText(Html.fromHtml(String.format("<font color='#fff600'>%d</font>/%d", nProgress, nMax)));
			mProgressBar.setMax(nMax);
			mProgressBar.setProgress(nProgress);
			mUpgradeInfoTextView.setText(String.format("即将晋升：%s", mLoginedUser.mMemberIndex.getSwitch_lv().getLv_name()));
		}else{
			mProgressTextView.setText("");
			mProgressBar.setMax(10);
			mProgressBar.setProgress(10);
			mUpgradeInfoTextView.setText("");
		}
		showTopDivider(false);
	}
	
	@Override
	public void onWindowFocusChanged(boolean hasFocus) {
		// TODO Auto-generated method stub
		super.onWindowFocusChanged(hasFocus);
		float nRealLen = mProgressTextView.getPaint().measureText(mProgressTextView.getText().toString());
		nRealLen += mUpgradeInfoTextView.getPaint().measureText(mUpgradeInfoTextView.getText().toString());
		if (nRealLen >= mProgressBar.getWidth()) {
			mUpgradeInfoTextView.setVisibility(View.GONE);
			mUpgradeInfo1TextView.setText(mUpgradeInfoTextView.getText());
			mUpgradeInfo1TextView.setVisibility(View.VISIBLE);
		}
	}
}
