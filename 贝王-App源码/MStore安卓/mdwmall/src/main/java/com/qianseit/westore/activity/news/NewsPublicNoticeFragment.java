package com.qianseit.westore.activity.news;

import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONObject;

public class NewsPublicNoticeFragment extends BaseNewsFragment {
	String mNodeId;

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_news_public_notice, null);
			convertView.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONObject nJsonObject = (JSONObject) v.getTag();
					readNews(nJsonObject);
					NewsPublicNoticeFragment.this.onClick("article", nJsonObject.optString("article_id"), nJsonObject.optString("title"));
				}
			});
		}
		
		displaySquareImage((ImageView) convertView.findViewById(R.id.image), responseJson.optString("img"));
		((TextView)convertView.findViewById(R.id.title)).setText(responseJson.optString("title"));
		((TextView)convertView.findViewById(R.id.time)).setText("时间：" + StringUtils.LongTimeToLongString(responseJson.optLong("pubtime")));
		convertView.setTag(responseJson);
		return convertView;
	}

	@Override
	protected String msgType() {
		// TODO Auto-generated method stub
		return "article";
	}

}
