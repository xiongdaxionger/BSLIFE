package com.qianseit.westore.ui;

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
import android.widget.Button;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.amap.api.maps.model.Text;
import com.beiwangfx.R;

import java.util.List;

public class CustomListCheckPopupWindow extends PopupWindow {

	private Context mContext;
	private View mView;
	private ListView mListView;
	private onCustomListPopupCheckListener mListener;
	private List<CustomListCheckBean> mLists;
	private CustomListCheckAdapter mAdapter;
	int mDockViewID;
	private int mSelectedPosition = 0;

	public CustomListCheckPopupWindow(Context context, int dockViewID, onCustomListPopupCheckListener listener, List<CustomListCheckBean> lists) {
		this.mContext = context;
		this.mListener = listener;
		this.mLists = lists;
		mDockViewID = dockViewID;
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

	/**
	 * 只改变选中项，不调用回调接口方法
	 * @param position
	 */
	public void onSelectedNoCallback(int position) {
		if (mLists == null || mLists.size() <= position || position < 0) {
			return;
		}

		for (int i = 0; i < mLists.size(); i++) {
			mLists.get(i).mSelected = position == i;
		}

		mSelectedPosition = position;
	}

	public void onSelected(int position) {
		if (mLists == null || mLists.size() <= position || position < 0) {
			return;
		}

		for (int i = 0; i < mLists.size(); i++) {
			mLists.get(i).mSelected = position == i;
		}

		mSelectedPosition = position;
		if (mListener != null)
			mListener.onResult(mLists.get(position), mDockViewID);
	}
	
	public CustomListCheckBean getSelectedItem(){
		return mLists.get(mSelectedPosition);
	}

	public void onSelected() {
		if (mListener != null)
			mListener.onResult(mLists.get(mSelectedPosition), mDockViewID);
	}
	
	public void onUnChecked(){
		if (mLists == null || mLists.size() <= 0) {
			return;
		}

		for (int i = 0; i < mLists.size(); i++) {
			mLists.get(i).mSelected = 0 == i;
		}

		mSelectedPosition = 0;
		if (mListener != null)
			mListener.onUnCheckedResult(mLists.get(mSelectedPosition), mDockViewID);
	}

	private class CustomListCheckAdapter extends BaseAdapter {

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
				convertView = View.inflate(mContext, R.layout.item_custom_list_check_popup, null);
				mHolder.mSelect = (TextView) convertView.findViewById(R.id.button1);
				mHolder.mTitle = (TextView) convertView.findViewById(R.id.textView1);
				mHolder.mSelect.setEnabled(false);
				convertView.setTag(mHolder);
			} else {
				mHolder = (ViewHolder) convertView.getTag();
			}

			CustomListCheckBean nBean = mLists.get(position);
			mHolder.mSelect.setSelected(nBean.mSelected);
			mHolder.mTitle.setText(nBean.mName);
			return convertView;
		}

		private class ViewHolder {
			public TextView mTitle;
			public TextView mSelect;
		}
	}

	public void notifyDataSetChanged() {
		this.mAdapter.notifyDataSetChanged();
	}

	public interface onCustomListPopupCheckListener {
		void onResult(CustomListCheckBean checkBean, int dockViewID);
		void onUnCheckedResult(CustomListCheckBean checkBean, int dockViewID);
	}

	public static class CustomListCheckBean {
		public String mID = "";
		public String mName = "";
		public String mType = "";
		public boolean mSelected = false;

		public CustomListCheckBean(String id, String type, String name, boolean selected) {
			mID = id;
			mType = type;
			mName = name;
			mSelected = selected;
		}

		public CustomListCheckBean(String id, String name, boolean selected) {
			mID = id;
			mType = "";
			mName = name;
			mSelected = selected;
		}
	}
}
