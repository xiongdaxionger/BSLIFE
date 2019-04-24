package com.qianseit.westore.activity.goods;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDialog;

public class GoodsProptyDialog extends BaseDialog implements android.view.View.OnClickListener {

	ListView mListView;
	List<JSONObject> mJsonObjects = new ArrayList<JSONObject>();
	QianseitAdapter<JSONObject> mAdapter = new QianseitAdapter<JSONObject>(mJsonObjects) {

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			if (convertView == null) {
				convertView = View.inflate(mContext, R.layout.item_goods_propty, null);
			}

			JSONObject nItem = getItem(position);
			((TextView) convertView.findViewById(R.id.goods_propty_name)).setText(nItem.optString("name"));
			((TextView) convertView.findViewById(R.id.goods_propty_value)).setText(nItem.optString("value"));

			return convertView;
		}
	};

	public GoodsProptyDialog(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		mContext = context;
		mWindow = getWindow();
		mWindow.setBackgroundDrawableResource(backgroundRes());
		this.setContentView(init());
		this.setCanceledOnTouchOutside(true);
	}

	@Override
	protected View init() {
		// TODO Auto-generated method stub
		View nView = View.inflate(mContext, R.layout.goods_propty_dialog, null);
		mListView = (ListView) nView.findViewById(R.id.goods_propty_list);
		mListView.setAdapter(mAdapter);

		nView.findViewById(R.id.goods_propty_ok).setOnClickListener(this);

		return nView;
	}

	/**
	 * [//商品扩展属性 { "name": "适合性别", "value": "男" }, { "name": "油炸", "value": "否"
	 * }, { "name": "尺寸", "value": "中毫升" } ]
	 * 
	 * @param jsonArray
	 */
	public void setData(JSONArray jsonArray) {
		if (jsonArray == null || jsonArray.length() <= 0) {
			return;
		}
		
		mJsonObjects.clear();

		for (int i = 0; i < jsonArray.length(); i++) {
			mJsonObjects.add(jsonArray.optJSONObject(i));
		}
		mAdapter.notifyDataSetChanged();
	}

	@Override
	protected int gravity() {
		// TODO Auto-generated method stub
		return Gravity.BOTTOM;
	}

	@Override
	protected float widthScale() {
		// TODO Auto-generated method stub
		return 1;
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.goods_propty_ok:
			dismiss();
			break;

		default:
			break;
		}
	}
}
