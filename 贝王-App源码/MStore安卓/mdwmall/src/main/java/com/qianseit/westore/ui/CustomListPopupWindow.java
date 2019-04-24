package com.qianseit.westore.ui;

import java.util.List;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnKeyListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.beiwangfx.R;

public class CustomListPopupWindow extends PopupWindow {

	private Context mContext;
	private View mView;
	private ListView mListView;
	private onCustomListPopupListener mListener;
	private List<String> mLists;
	private CustomListCheckAdapter mAdapter;

	public CustomListPopupWindow(Context context, onCustomListPopupListener listener, List<String> lists) {
		this.mContext = context;
		this.mListener = listener;
		this.mLists = lists;
		this.init();
	}

	private void init() {

		this.mView = View.inflate(mContext, R.layout.popup_custom_check, null);
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
		this.setWidth(LayoutParams.MATCH_PARENT);
		this.setHeight(LayoutParams.MATCH_PARENT);
		this.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		this.setTouchable(true);
		this.setFocusable(true);
		this.setOutsideTouchable(true);
		this.update();

		mListView = (ListView) this.mView.findViewById(R.id.listView1);
		mListView.setAdapter((mAdapter = new CustomListCheckAdapter()));
		mListView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int position, long arg3) {
				mListener.onClick((String)arg0.getAdapter().getItem(position));
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

	private class CustomListCheckAdapter extends BaseAdapter {

		@Override
		public int getCount() {
			return mLists.size();
		}

		@Override
		public String getItem(int position) {
			return mLists.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {

			if (convertView == null) {
				convertView = View.inflate(mContext, R.layout.item_simple_list_1, null);
			}

			((TextView)convertView).setText(getItem(position));
			return convertView;
		}
	}

	public void notifyDataSetChanged() {
		this.mAdapter.notifyDataSetChanged();
	}

	public interface onCustomListPopupListener {
		void onClick(String item);
	}
}
