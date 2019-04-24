package com.qianseit.westore.activity.acco;

import android.content.ContentValues;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;;

public class AccoCouponUnavailableListFragment extends AccoCouponListFragment {

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("status", "b2c.member.coupon");
		return nContentValues;
	}

	@Override
	protected void endInit() {
		initGoodEmptyView();
		mListView.setBackgroundResource(R.color.fragment_background_color);
		mListView.setDividerHeight(0);
	}

	void initGoodEmptyView() {
		View nView = View.inflate(mActivity, R.layout.empty_shop_car, null);
		setCustomEmptyView(nView);
		nView.findViewById(R.id.shopping_go).setVisibility(View.GONE);
		ImageView icon = (ImageView) nView.findViewById(R.id.shopping_hint_icon);
		icon.setImageResource(R.drawable.coupon_empty_new);
		TextView title = (TextView) nView.findViewById(R.id.tv_title);
		title.setText("您没有失效的优惠券");
		nView.findViewById(R.id.tv_hint).setVisibility(View.GONE);
	}
}
