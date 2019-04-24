package com.qianseit.westore.activity.news;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONObject;

public class NewsOrderFragment extends BaseNewsFragment {

	@Override
	protected String msgType() {
		// TODO Auto-generated method stub
		return "order";
	}

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_news_order, null);
			convertView.findViewById(R.id.goods_image).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					String nProductId = (String) v.getTag();
					if (TextUtils.isEmpty(nProductId)) {
						return;
					}

					Bundle nBundle = new Bundle();
					nBundle.putString(Run.EXTRA_PRODUCT_ID, nProductId);
					startActivity(AgentActivity.FRAGMENT_GOODS_DETAIL, nBundle);
				}
			});
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONObject nJsonObject = (JSONObject) v.getTag();
					JSONObject nDeliveryInfo = nJsonObject.optJSONObject("delivery");
					readNews(nJsonObject);
					if (nDeliveryInfo != null && nDeliveryInfo.optBoolean("status")) {
						Bundle nBundle = new Bundle();
						nBundle.putString(Run.EXTRA_DELIVERY_ID, nDeliveryInfo.optString("delivery_id"));
						startActivity(AgentActivity.FRAGMENT_SHOPP_LOGISTICS, nBundle);
					} else {
						startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_ORDERS_DETAIL).putExtra(Run.EXTRA_ORDER_ID, nJsonObject.optString("order_id")));
					}
				}
			});
		}
		
		((TextView) convertView.findViewById(R.id.time)).setText(StringUtils.LongTimeToLongString(responseJson.optLong("time")));
		((TextView) convertView.findViewById(R.id.title)).setText(responseJson.optString("title"));
		((TextView) convertView.findViewById(R.id.message)).setText(responseJson.optString("comment"));

		JSONArray nArray = responseJson.optJSONArray("goods");
		JSONObject nGoodsJsonObject = new JSONObject();
		if (nArray != null && nArray.length() > 0) {
			nGoodsJsonObject = nArray.optJSONObject(0);
		}
		displaySquareImage((ImageView) convertView.findViewById(R.id.goods_image), nGoodsJsonObject.optString("image_default_id"));
		convertView.findViewById(R.id.goods_image).setTag(nGoodsJsonObject.optString("product_id"));

		JSONObject nDeliveryInfo = responseJson.optJSONObject("delivery");
		if (nDeliveryInfo != null) {
			((TextView) convertView.findViewById(R.id.crop_name)).setText(StringUtils.getString(nDeliveryInfo, "logi_name"));
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
