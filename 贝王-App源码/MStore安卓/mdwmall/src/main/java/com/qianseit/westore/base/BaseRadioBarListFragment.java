package com.qianseit.westore.base;

import java.util.ArrayList;
import java.util.List;

import android.annotation.SuppressLint;
import android.app.ActionBar.LayoutParams;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;

import com.beiwangfx.R;
import com.qianseit.westore.ui.HorizontalListView;

abstract public class BaseRadioBarListFragment<T> extends BaseListFragment<T> {

	private class RadioBarAdapter extends BaseAdapter {

		@Override
		public int getCount() {
			return mRadioLists.size();
		}

		@Override
		public RadioBean getItem(int position) {
			return mRadioLists.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@SuppressLint("ResourceAsColor")
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {

			if (convertView == null) {
				convertView = View.inflate(mActivity, R.layout.base_item_radio_bar, null);
				RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(mRadioWidth, LayoutParams.WRAP_CONTENT);
				convertView.setLayoutParams(layoutParams);
			}
			final RadioBean item = this.getItem(position);
			convertView.findViewById(R.id.view_color).setSelected(item.mSelected);
			((TextView) convertView.findViewById(R.id.textView1)).setText(item.mTitleString);
			return convertView;
		}
	}
	
	void setRadiosVisible(int visibleRadios){
		WindowManager windowManager = mActivity.getWindowManager();
		mRadioWidth = (windowManager.getDefaultDisplay().getWidth()) / visibleRadios;
	}

	public class RadioBean{
		public String mTypeString;
		public String mTitleString;
		public boolean mSelected;
		
		public RadioBean(String titleString, String typeString, boolean selected){
			mTitleString = titleString;
			mTypeString = typeString;
			mSelected = selected;
		}
	}
	
	private int mRadioWidth = 0;
	protected List<RadioBean> mRadioLists = new ArrayList<RadioBean>();
	private LinearLayout mRadioBarView;
	private HorizontalListView mRadioBarHorizontalListView;
	private RadioBarAdapter mBarAdapter;
	
	private void selectedRadio(int index) {
		if (mRadioLists == null || mRadioLists.size() <= index) {
			return;
		}
		
		for (RadioBean radioBean : mRadioLists) {
			if (radioBean.mSelected) {
				radioBean.mSelected = false;
			}
		}
		
		mRadioLists.get(index).mSelected = true;
		onSelectedChanged(mRadioLists.get(index));
	}
	
	public void onSelectedChanged(RadioBean selectedRadioBean){
		
	}
	
	protected String getSelectedType() {
		String nTypeString = "";
		for (RadioBean radioBean : mRadioLists) {
			if (radioBean.mSelected) {
				nTypeString = radioBean.mTypeString;
				break;
			}
		}
		
		return nTypeString;
	}
	
	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		setRadiosVisible(4);
		initRadioBar();
		mBarAdapter.notifyDataSetChanged();
	}
	
	protected abstract void initRadioBar();
	
	@Override
	protected void initTop(LinearLayout topLayout) {
		// TODO Auto-generated method stub
		LayoutInflater nInflater = mActivity.getLayoutInflater();
		mRadioBarView = (LinearLayout) nInflater.inflate(R.layout.base_radio_bar, null);
		mRadioBarHorizontalListView = (HorizontalListView) mRadioBarView.findViewById(R.id.bar_list_view);
		mBarAdapter = new RadioBarAdapter();
		mRadioBarHorizontalListView.setAdapter(mBarAdapter);

		mRadioBarHorizontalListView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				selectedRadio(position);
				mBarAdapter.notifyDataSetChanged();
				onRefresh();
			}
		});

		LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);
		mRadioBarView.setLayoutParams(layoutParams);
		topLayout.addView(mRadioBarView);
	}
}
