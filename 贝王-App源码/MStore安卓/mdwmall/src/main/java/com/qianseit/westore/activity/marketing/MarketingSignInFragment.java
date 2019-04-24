package com.qianseit.westore.activity.marketing;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.acco.AccoPointsFragment;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.base.BaseGridFragment;
import com.qianseit.westore.httpinterface.marketing.MarketingGetSignInterface;
import com.qianseit.westore.ui.ShareView.ShareViewDataSource;
import com.qianseit.westore.ui.ShareViewPopupWindow;
import com.qianseit.westore.util.Util;
import com.beiwangfx.R;

public class MarketingSignInFragment extends BaseGridFragment<JSONObject> implements ShareViewDataSource {

	String mInviteUrl;
	ShareViewPopupWindow mShareViewPopupWindow;

	View mSignLeftView;
	View mSigninInviteView;
	View mSigninMyView;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("签到");
		mActionBar.getTitleTV().setTextColor(getResources().getColor(R.color.white));
		mActionBar.getTitleBar().setBackgroundResource(R.color.westore_red);
		mActionBar.getBackButton().setImageResource(R.drawable.comm_button_back_white);
	}
	
	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		if (responseJson == null || !responseJson.has("data")) {
			return nJsonObjects;
		}
		JSONArray dataArray = responseJson.optJSONArray("data");
		if (dataArray != null && dataArray.length() > 0) {
			for (int i = 0; i < dataArray.length(); i++)
				nJsonObjects.add(dataArray.optJSONObject(i));
		}
		return nJsonObjects;
	}

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_marketing_signin_goods, null);
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONObject json = (JSONObject) v.getTag();
					if (json != null) {
						String productID = json.optString("product_id");
						Bundle nBundle = new Bundle();
						nBundle.putString(Run.EXTRA_PRODUCT_ID, productID);
						nBundle.putBoolean(Run.EXTRA_VALUE, true);//赠品
						startActivity(AgentActivity.FRAGMENT_GOODS_DETAIL, nBundle);
					}
				}
			});
		}
		ImageView imageIcon = (ImageView) convertView.findViewById(R.id.goods_icon);
		setViewSize(imageIcon, mImageWidth, mImageWidth);
		convertView.setTag(responseJson);
		displayRectangleImage(imageIcon, responseJson.optString("image_default_id"));

		((TextView) convertView.findViewById(R.id.goods_title)).setText(responseJson.optString("name"));
		((TextView) convertView.findViewById(R.id.goods_price)).setText(responseJson.optString("consume_score") + "积分");
		((TextView) convertView.findViewById(R.id.goods_mktprice)).setText("");
		return convertView;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "gift.gift.lists";
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.header_marketing_signin_invite_rl:
			mShareViewPopupWindow.showAtLocation(rootView, android.view.Gravity.BOTTOM, 0, 0);
			break;
		case R.id.header_marketing_signin_invite_my_rl:
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_POINTS).putExtra(Run.EXTRA_DETAIL_TYPE, AccoPointsFragment.POINTS_RULE));
			break;

		default:
			break;
		}
		super.onClick(v);
	}

	@Override
	protected void addHeader(LinearLayout headerLayout) {
		super.addHeader(headerLayout);
		View nHeaderView = View.inflate(mActivity, R.layout.header_marketing_signin, null);
		headerLayout.addView(nHeaderView);

		setViewHeight(findViewById(R.id.header_marketing_signin_adv), 202);
		
		findViewById(R.id.header_marketing_signin_invite_rl).setOnClickListener(this);
		findViewById(R.id.header_marketing_signin_invite_my_rl).setOnClickListener(this);
		mShareViewPopupWindow = new ShareViewPopupWindow(mActivity);
		mShareViewPopupWindow.setDataSource(this);

		mSignLeftView = findViewById(R.id.header_marketing_signin_left);
		mSigninInviteView = findViewById(R.id.header_marketing_signin_invite_rl);
		mSigninMyView = findViewById(R.id.header_marketing_signin_invite_my_rl);
//		mSignLeftView.getViewTreeObserver().addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
//
//			@Override
//			public void onGlobalLayout() {
//				// TODO Auto-generated method stub
//				setViewAbsoluteSize(mSigninInviteView, mSignLeftView.getWidth(), mSignLeftView.getHeight() / 2);
//				setViewAbsoluteSize(mSigninMyView, mSignLeftView.getWidth(), mSignLeftView.getHeight() / 2);
//			}
//		});

		new MarketingGetSignInterface(this) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				JSONObject nDataJsonObject = responseJson.optJSONObject("data");
				assignmentHeaderView(nDataJsonObject);

				mInviteUrl = nDataJsonObject.optString("inv_url");
				CommonLoginFragment.showAlertDialog(mActivity, responseJson.optString("msg"), "", "确定", null, null, false, null);
			}
		}.RunRequest();
	}
	
	void assignmentHeaderView(JSONObject headerJsonObject) {
		JSONObject nSignDataJsonObject = headerJsonObject.optJSONObject("data");
		JSONObject nRuleJsonObject = nSignDataJsonObject.optJSONObject("rule");
		JSONObject nNearJsonObject = nSignDataJsonObject.optJSONObject("near");
		((TextView) findViewById(R.id.header_marketing_signin_total)).setText(nSignDataJsonObject.optString("sign_fate"));
		((TextView) findViewById(R.id.header_marketing_signin_content)).setText(headerJsonObject.optString("content"));

		((TextView) findViewById(R.id.header_marketing_signin_rule_new)).setText(nRuleJsonObject.optString("new"));
		((TextView) findViewById(R.id.header_marketing_signin_rule_one)).setText(nRuleJsonObject.optString("one"));
		((TextView) findViewById(R.id.header_marketing_signin_rule_two)).setText(nRuleJsonObject.optString("two"));
		((TextView) findViewById(R.id.header_marketing_signin_rule_three)).setText(nRuleJsonObject.optString("three"));

		((TextView) findViewById(R.id.header_marketing_signin_near)).setText(Html.fromHtml(String.format("连续签到<font color='#ffda44'>%1$s</font>天 +<font color='#ffda44'>%2$s</font>", nNearJsonObject.optString("fate"), nNearJsonObject.optString("number"))));
		
		displayRectangleImage((ImageView) findViewById(R.id.header_marketing_topbg), nSignDataJsonObject.optString("image"));
	}

	@Override
	public String getShareText() {
		// TODO Auto-generated method stub
		return getString(R.string.app_name);
	}

	@Override
	public String getShareImageFile() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getShareImageUrl() {
		// TODO Auto-generated method stub
		Bitmap bitmap = BitmapFactory.decodeResource(mActivity.getResources(), R.drawable.comm_icon_launcher);
		Util.saveBitmap("share_iamge", bitmap);
		return Util.getPath() + "/share_iamge";
	}

	@Override
	public String getShareUrl() {
		// TODO Auto-generated method stub
		return mInviteUrl;
	}

	@Override
	public String getShareMessage() {
		// TODO Auto-generated method stub
		return getString(R.string.share_text_signin_invite);
	}
}
