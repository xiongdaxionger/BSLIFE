package com.qianseit.westore.activity.aftermarket;

import android.content.ContentValues;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseExpandListFragment;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class AftermarketRefundListFragment extends BaseExpandListFragment<JSONObject, JSONObject> {

	@Override
	protected List<ExpandListItemBean<JSONObject, JSONObject>> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<ExpandListItemBean<JSONObject, JSONObject>> nBeans = new ArrayList<BaseExpandListFragment.ExpandListItemBean<JSONObject, JSONObject>>();
		JSONArray array = responseJson.optJSONArray("return_list");
		for (int i = 0, count = array.length(); i < count; i++) {

			ExpandListItemBean<JSONObject, JSONObject> nBean = new ExpandListItemBean<JSONObject, JSONObject>();
			nBean.mGrupItem = array.optJSONObject(i);

			JSONArray goodsArray = nBean.mGrupItem.optJSONArray("product_data");

			if (goodsArray != null && goodsArray.length() > 0) {
				for (int j = 0; j < goodsArray.length(); j++)
					nBean.mDetailLists.add(goodsArray.optJSONObject(j));
			}
			nBeans.add(nBean);
		}
		return nBeans;
	}

	@Override
	protected View getGroupItemView(com.qianseit.westore.base.BaseExpandListFragment.ExpandListItemBean<JSONObject, JSONObject> groupBean, boolean isExpanded, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_shopping_orders_group, null);
			convertView.findViewById(R.id.shopping_orders_group_status).setVisibility(View.GONE);
		}
		JSONObject all = groupBean.mGrupItem;
		String ordersNum = all.optString("order_id");
		convertView.setTag(all);

		// 订单号
		TextView textNumber = (TextView) convertView.findViewById(R.id.shopping_orders_group_number);
		textNumber.setText(ordersNum);

		View goDetailView = convertView.findViewById(R.id.shopping_orders_group_go_detail);
		goDetailView.setTag(all);
		goDetailView.setOnClickListener(this);

		return convertView;
	}

	@Override
	protected View getDetailItemView(ExpandListItemBean<JSONObject, JSONObject> groupBean, JSONObject detailBean, boolean isLastChild, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_shopping_orders_detail, null);
			convertView.findViewById(R.id.acco_orders_item_recommend).setVisibility(View.GONE);
		}
		JSONObject goods = detailBean;
		if (goods != null) {
				ImageView goodsImage = (ImageView) convertView.findViewById(R.id.acco_orders_item_thumb);
				TextView goodsTiTextView = (TextView) convertView.findViewById(R.id.shopping_orders_group_title);
				TextView goodsQuantityextView = (TextView) convertView.findViewById(R.id.acco_orders_item_quantity);
				TextView goodsPricetView = (TextView) convertView.findViewById(R.id.acco_orders_item_price);

				goodsImage.setTag(goods);
				goodsImage.setOnClickListener(this);
				convertView.findViewById(R.id.acco_orders_item_recommend_divider).setVisibility(View.GONE);
				displaySquareImage(goodsImage, goods.optString("image_default_id"));
				goodsTiTextView.setText(goods.optString("name"));
				goodsQuantityextView.setText(Run.buildString("x", goods.optString("num")));
				goodsPricetView.setText(goods.optString("price"));
		}

		((LinearLayout) convertView.findViewById(R.id.shopping_orders_group_footer)).removeAllViews();
		if (isLastChild) {
			((LinearLayout) convertView.findViewById(R.id.shopping_orders_group_footer)).addView(getGroupFooterView(groupBean));
		}

		return convertView;
	}

	protected View getGroupFooterView(ExpandListItemBean<JSONObject, JSONObject> groupBean) {
		View nFooterView = View.inflate(mActivity, R.layout.item_shopping_aftermarket_refund_orders_group_footer, null);

		nFooterView.findViewById(R.id.shopping_orders_item_express_ll).setVisibility(View.GONE);
		
		((TextView) nFooterView.findViewById(R.id.shopping_orders_item_reason_tip)).setText("申请退款理由");
		((TextView) nFooterView.findViewById(R.id.shopping_orders_item_reason_content)).setText(String.format("%1$s，%2$s", groupBean.mGrupItem.optString("title"), groupBean.mGrupItem.optString("content")));
		
		JSONArray nCommentArray = groupBean.mGrupItem.optJSONArray("comment");
		if (nCommentArray == null ||nCommentArray.length() <= 0) {
			nFooterView.findViewById(R.id.shopping_orders_item_comment_ll).setVisibility(View.GONE);
		}else{
			nFooterView.findViewById(R.id.shopping_orders_item_comment_ll).setVisibility(View.VISIBLE);
			
			StringBuilder nBuilder = new StringBuilder();
			for (int i = 0; i < nCommentArray.length(); i++) {
				JSONObject nItemJsonObject = nCommentArray.optJSONObject(i);
				nBuilder.append(StringUtils.LongTimeToString("yyyy-MM-dd HH:mm:ss", nItemJsonObject.optLong("time")));
				nBuilder.append("    ");
				nBuilder.append(nItemJsonObject.optString("content"));
				nBuilder.append("\n");
			}
			if (nBuilder.length() > 0) {
				nBuilder.deleteCharAt(nBuilder.length() - 1);
			}
			
			((TextView) nFooterView.findViewById(R.id.shopping_orders_item_comment_content)).setText(nBuilder.toString());
			nBuilder.delete(0, nBuilder.length());
		}
		
		((Button) nFooterView.findViewById(R.id.shopping_orders_item_action)).setText(groupBean.mGrupItem.optString("status"));
		
		return nFooterView;
	}

	@Override
	protected void initActionBar() {
		// TODO Auto-generated method stub
		mActionBar.setShowTitleBar(false);
	}

	@Override
	protected void init() {
		setEmptyText("暂无退款记录");
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("type", "refund");
		return nContentValues;
	}

	/* (non-Javadoc)
	 * @see com.qianseit.westore.base.BaseExpandListFragment#requestInterfaceName()
	 * 4.45 退货/退款记录
	 */
	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "aftersales.aftersales.afterrec";
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if (v.getId() == R.id.shopping_orders_group_go_detail) {
			final JSONObject nOrderJsonObject = (JSONObject) v.getTag();
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_ORDERS_DETAIL).putExtra(Run.EXTRA_ORDER_ID, nOrderJsonObject.optString("order_id")));
		}
	}

}
