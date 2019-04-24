package com.qianseit.westore.ui;

import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.view.View.OnKeyListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.beiwangfx.R;

public abstract class CustomListSelectorPopupWindow extends PopupWindow {

	private Activity mActivity;
	private View mView;
	private TextView mTitleTextView;
	private ListView mListView;
	private List<CustomListSelectorBean> mLists;
	private CustomListSelectorAdapter mAdapter;
	private int mSelectedPosition = 0;

	private String mTitle;

	public CustomListSelectorPopupWindow(Activity activity, String title, List<CustomListSelectorBean> lists) {
		this.mActivity = activity;
		this.mLists = lists;
		mTitle = title;
		this.init();
	}

	private void init() {

		this.mView = View.inflate(mActivity, R.layout.popup_custom_selector, null);
		this.mView.setFocusable(true);
		this.mView.setFocusableInTouchMode(true);
		this.mView.setOnKeyListener(new OnKeyListener() {

			@Override
			public boolean onKey(View v, int keyCode, KeyEvent event) {
				if (isShowing()) {
					dismiss();
					return true;
				}
				return false;
			}
		});

		this.setContentView(mView);
		WindowManager wm = (WindowManager) mView.getContext().getSystemService(Context.WINDOW_SERVICE);
		this.setWidth(wm.getDefaultDisplay().getWidth() * 4 / 5);
		this.setHeight(LayoutParams.WRAP_CONTENT);
		this.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		this.setTouchable(true);
		this.setFocusable(true);
		this.setOutsideTouchable(true);
		this.update();

		mTitleTextView = (TextView) this.mView.findViewById(R.id.title);
		mTitleTextView.setText(mTitle);

		mListView = (ListView) this.mView.findViewById(R.id.listView1);
		mListView.setAdapter((mAdapter = new CustomListSelectorAdapter()));
		mListView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int position, long arg3) {
				onSelected(position);
				dismiss();
			}
		});

		mView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (isShowing()) {
					dismiss();
				}
			}
		});
	}

	@Override
	public void dismiss() {
		WindowManager.LayoutParams params = mActivity.getWindow().getAttributes();
		params.alpha = 1f;
		mActivity.getWindow().setAttributes(params);
		super.dismiss();
	}

	@Override
	public void showAtLocation(View parent, int gravity, int x, int y) {
		beginShow();
		super.showAtLocation(parent, gravity, x, y);
	}

	@Override
	public void showAsDropDown(View anchor) {
		// TODO Auto-generated method stub
		beginShow();
		super.showAsDropDown(anchor);
	}

	@Override
	public void showAsDropDown(View anchor, int xoff, int yoff) {
		// TODO Auto-generated method stub
		beginShow();
		super.showAsDropDown(anchor, xoff, yoff);
	}

	@SuppressLint("NewApi")
	@Override
	public void showAsDropDown(View anchor, int xoff, int yoff, int gravity) {
		// TODO Auto-generated method stub
		beginShow();
		super.showAsDropDown(anchor, xoff, yoff, gravity);
	}

	void beginShow() {
		WindowManager.LayoutParams params = mActivity.getWindow().getAttributes();
		params.alpha = 0.7f;
		mActivity.getWindow().setAttributes(params);
	}

	public void onSelected(int position) {
		if (mLists == null || mLists.size() <= position || position < 0) {
			return;
		}

		for (int i = 0; i < mLists.size(); i++) {
			mLists.get(i).mSelected = position == i;
		}

		mSelectedPosition = position;
		onItemSelected(mLists.get(position));
	}

	private class CustomListSelectorAdapter extends BaseAdapter {

		private ViewHolder mHolder;

		@Override
		public int getCount() {
			return mLists.size();
		}

		@Override
		public Object getItem(int position) {
			return mLists.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {

			if (convertView == null) {
				mHolder = new ViewHolder();
				convertView = View.inflate(mActivity, R.layout.item_custom_list_selector_popup, null);
				mHolder.mSelect = (Button) convertView.findViewById(R.id.button1);
				mHolder.mTitle = (TextView) convertView.findViewById(R.id.textView1);
				convertView.setTag(mHolder);
			} else {
				mHolder = (ViewHolder) convertView.getTag();
			}

			CustomListSelectorBean nBean = mLists.get(position);
			mHolder.mSelect.setSelected(nBean.mSelected);
			mHolder.mTitle.setText(nBean.mName);
			return convertView;
		}

		private class ViewHolder {
			public TextView mTitle;
			public Button mSelect;
		}
	}

	public void notifyDataSetChanged() {
		this.mAdapter.notifyDataSetChanged();
	}

	public abstract void onItemSelected(CustomListSelectorBean selectedBean);

	public static class CustomListSelectorBean {
		public String mID = "";
		public String mName = "";
		public String mType = "";
		public boolean mSelected = false;

		public CustomListSelectorBean(String id, String type, String name, boolean selected) {
			mID = id;
			mType = type;
			mName = name;
			mSelected = selected;
		}

		public CustomListSelectorBean(String id, String name, boolean selected) {
			mID = id;
			mType = "";
			mName = name;
			mSelected = selected;
		}
	}
}
