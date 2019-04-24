package com.qianseit.westore.activity.news;

import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONObject;

public class NewsAssetsFragment extends BaseNewsFragment {

	@Override
	protected String msgType() {
		// TODO Auto-generated method stub
		return "assets";
	}

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_news_assets, null);
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONObject nJsonObject = (JSONObject) v.getTag();
					readNews(nJsonObject);
					String nCouponString = nJsonObject.optString("coupon_name");
					if (TextUtils.isEmpty(nCouponString)) {
						startActivity(AgentActivity.FRAGMENT_WEALTH);
					} else {
						startActivity(AgentActivity.FRAGMENT_ACCO_COUPON);
					}
				}
			});
			setViewSize(convertView.findViewById(R.id.coupon_name), 310, 170);
		}
		
		((TextView) convertView.findViewById(R.id.time)).setText(StringUtils.LongTimeToLongString(responseJson.optLong("time")));
		((TextView) convertView.findViewById(R.id.title)).setText(responseJson.optString("title"));
		((TextView) convertView.findViewById(R.id.message)).setText(responseJson.optString("comment"));
		
		TextView nCouponTextView = (TextView) convertView.findViewById(R.id.coupon_name);
		String nCouponString = responseJson.optString("coupon_name");
		if (TextUtils.isEmpty(nCouponString)) {
			nCouponTextView.setVisibility(View.GONE);
		}else{
			nCouponTextView.setVisibility(View.VISIBLE);
			nCouponTextView.setText(nCouponString);
		}

		convertView.setTag(responseJson);
		return convertView;
	}

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		super.endInit();
		mListView.setDividerHeight(0);
	}
}
