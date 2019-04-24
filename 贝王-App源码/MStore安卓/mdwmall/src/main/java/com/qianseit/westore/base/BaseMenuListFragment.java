package com.qianseit.westore.base;

import com.qianseit.westore.Run;
import com.qianseit.westore.base.bean.BaseMenuBean;
import com.beiwangfx.R;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

public abstract class BaseMenuListFragment extends BaseLocalListFragment<BaseMenuBean> {

	int mPaddingLeftHasIcon, mPaddingLeftNoIcon;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mPaddingLeftHasIcon = Run.dip2px(mActivity, 10);
		mPaddingLeftNoIcon = Run.dip2px(mActivity, 15);
	}
	
	@Override
	protected View getItemView(final BaseMenuBean menuItem, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.base_item_menu, null);
		}
		convertView.setTag(menuItem);

		ImageView nIconImageView = (ImageView) convertView.findViewById(R.id.item_menu_icon);
		ImageView nSubIconImageView = (ImageView) convertView.findViewById(R.id.item_menu_sub_icon);
		if (menuItem.getIconResId() > 0) {
			nIconImageView.setImageResource(menuItem.getIconResId());
			nIconImageView.setVisibility(View.VISIBLE);
			convertView.findViewById(R.id.item_menu_title).setPadding(mPaddingLeftHasIcon, 0, 0, 0);
		} else if (!TextUtils.isEmpty(menuItem.getIconUrl())) {
			displaySquareImage(nIconImageView, menuItem.getIconUrl());
			nIconImageView.setVisibility(View.VISIBLE);
			convertView.findViewById(R.id.item_menu_title).setPadding(mPaddingLeftHasIcon, 0, 0, 0);
		} else {
			nIconImageView.setImageBitmap(null);
			nIconImageView.setVisibility(View.GONE);
			convertView.findViewById(R.id.item_menu_title).setPadding(mPaddingLeftNoIcon, 0, 0, 0);
		}
		if (menuItem.getSubIconResId() > 0) {
			nSubIconImageView.setImageResource(menuItem.getSubIconResId());
		} else {
			nSubIconImageView.setImageBitmap(null);
		}

		int nIndex = mResultLists.indexOf(menuItem);
		if (nIndex == 0) {
			convertView.findViewById(R.id.item_menu_divide_top).setVisibility(View.GONE);
		} else {
			convertView.findViewById(R.id.item_menu_divide_top).setVisibility(View.GONE);
		}

		if (menuItem.getTitleResID() == 0) {
			((TextView) convertView.findViewById(R.id.item_menu_title)).setText(menuItem.getTitle());
		} else {
			((TextView) convertView.findViewById(R.id.item_menu_title)).setText(menuItem.getTitleResID());
		}

		if (menuItem.getContentResID() == 0) {
			((TextView) convertView.findViewById(R.id.item_menu_content)).setText(menuItem.getContent());
		} else {
			((TextView) convertView.findViewById(R.id.item_menu_content)).setText(menuItem.getContentResID());
		}

		convertView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				onMenuClick(menuItem);
			}
		});
		convertView.findViewById(R.id.item_menu_sub_icon).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				onMenuClickSub(menuItem);
			}
		});
		convertView.findViewById(R.id.item_menu_right).setVisibility(menuItem.showRight() ? View.VISIBLE : View.INVISIBLE);

		if (menuItem.hasDetail()) {
			LinearLayout nLayout = (LinearLayout) convertView.findViewById(R.id.item_menu_detail);
			nLayout.setVisibility(View.VISIBLE);
			nLayout.removeAllViews();
			nLayout.addView(getMenuDetail(menuItem));
			convertView.findViewById(R.id.item_menu_detail_divide).setVisibility(View.VISIBLE);
		} else {
			convertView.findViewById(R.id.item_menu_detail).setVisibility(View.GONE);
			convertView.findViewById(R.id.item_menu_detail_divide).setVisibility(View.GONE);
		}
		if (menuItem.hasasTopView()) {
			convertView.findViewById(R.id.item_menu_blan_view).setVisibility(View.VISIBLE);
		} else {
			convertView.findViewById(R.id.item_menu_blan_view).setVisibility(View.GONE);
		}
		return convertView;
	}

	protected View getMenuDetail(BaseMenuBean baseMenuBean) {
		return null;
	}

	protected abstract void onMenuClick(BaseMenuBean baseMenuBean);

	protected void onMenuClickSub(BaseMenuBean baseMenuBean) {

	}
}
