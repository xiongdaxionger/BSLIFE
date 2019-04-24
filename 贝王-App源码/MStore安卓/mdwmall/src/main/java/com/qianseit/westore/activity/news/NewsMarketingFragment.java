package com.qianseit.westore.activity.news;

import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONObject;

public class NewsMarketingFragment extends BaseNewsFragment {

	int mImageWidth = 1080;
	int mImageHight = 1080;
	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_news_marketing, null);
//			setViewAbsoluteSize(convertView.findViewById(R.id.marketing_image), mImageWidth, mImageHight);
			convertView.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONObject nJsonObject = (JSONObject) v.getTag();
					readNews(nJsonObject);
					NewsMarketingFragment.this.onClick("custom", nJsonObject.optString("hot_link"), nJsonObject.optString("title"));
				}
			});
		}

		((TextView) convertView.findViewById(R.id.time)).setText(StringUtils.LongTimeToLongString(responseJson.optLong("time")));
		((TextView) convertView.findViewById(R.id.title)).setText(responseJson.optString("title"));
		((TextView) convertView.findViewById(R.id.message)).setText(responseJson.optString("comment"));
		
		displaySquareImage((ImageView) convertView.findViewById(R.id.marketing_image), responseJson.optString("img"));
		convertView.setTag(responseJson);
		return convertView;
	}

	@Override
	protected String msgType() {
		// TODO Auto-generated method stub
		return "active";
	}

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		super.endInit();
		mListView.setDividerHeight(0);
		mImageWidth = Run.getWindowsWidth(mActivity) - Run.dip2px(mActivity, 10);
		mImageHight = mImageWidth * 4 / 9;
	}
}
