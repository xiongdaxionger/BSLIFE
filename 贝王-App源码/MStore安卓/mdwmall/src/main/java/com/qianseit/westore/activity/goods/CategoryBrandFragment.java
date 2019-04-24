package com.qianseit.westore.activity.goods;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseGridFragment;
import com.beiwangfx.R;

public class CategoryBrandFragment extends BaseGridFragment<JSONObject> {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setShowTitleBar(false);
	}

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_category_brand, null);
			setViewSize(convertView.findViewById(R.id.item_category_brand_icon), mImageWidth, mImageWidth);
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONObject nJsonObject = (JSONObject) v.getTag();
					Bundle nBundle = new Bundle();
					nBundle.putString(Run.EXTRA_BRAND_ID, nJsonObject.optString("brand_id"));
					nBundle.putString(Run.EXTRA_TITLE, nJsonObject.optString("brand_name"));
					startActivity(AgentActivity.FRAGMENT_SHOPP_GOODS_LIST, nBundle);
				}
			});
		}

		convertView.setTag(responseJson);
		displaySquareImage((ImageView) convertView.findViewById(R.id.item_category_brand_icon), responseJson.optString("brand_logo"));
		return convertView;
	}

	@Override
	protected int getNumColumns() {
		// TODO Auto-generated method stub
		return 3;
	}
	
	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		if (responseJson == null || !responseJson.has("brandList")) {
			return nJsonObjects;
		}

		JSONArray nArray = responseJson.optJSONArray("brandList");
		if (nArray == null || nArray.length() <= 0) {
			return nJsonObjects;
		}

		for (int i = 0; i < nArray.length(); i++) {
			nJsonObjects.add(nArray.optJSONObject(i));
		}

		return nJsonObjects;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.brand.showList";
	}

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		mGridView.setBackgroundResource(R.color.text_goods_f3_color);
	}
}
