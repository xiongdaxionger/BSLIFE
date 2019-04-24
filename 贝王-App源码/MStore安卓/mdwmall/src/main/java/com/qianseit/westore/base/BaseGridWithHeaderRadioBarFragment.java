package com.qianseit.westore.base;

import java.util.ArrayList;
import java.util.List;

import android.annotation.SuppressLint;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.qianseit.westore.ui.HorizontalListView;
import com.beiwangfx.R;

public abstract class BaseGridWithHeaderRadioBarFragment<T> extends BaseGridFragment<T> {

	private class RadioBarAdapter extends BaseAdapter {

		@Override
		public int getCount() {
			return mRadioLists.size();
		}

		@Override
		public RadioBarBean getItem(int position) {
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
				RelativeLayout barRelativeLayout=(RelativeLayout)convertView.findViewById(R.id.bar_item_rel);
				RelativeLayout.LayoutParams layoutParams=(android.widget.RelativeLayout.LayoutParams) barRelativeLayout.getLayoutParams();
				layoutParams.width=mRadioWidth;
			}
			final RadioBarBean item = this.getItem(position);
			convertView.findViewById(R.id.textView1).setSelected(item.mSelected);
			convertView.findViewById(R.id.view_color).setSelected(item.mSelected);
			((TextView) convertView.findViewById(R.id.textView1)).setText(item.mTitleString);
			if (item.mSelected) {
				loadNextPage(0);
			}

			if (position < getCount()) {
				convertView.findViewById(R.id.view_divide).setSelected(true);
			} else {
				convertView.findViewById(R.id.view_divide).setSelected(false);
			}

			return convertView;
		}
	}

	public int DefaultSelectRadio() {
		if (mRadioLists.size() > 0) {
			return mRadioLists.get(0).mId;
		}

		return 0;
	}

	protected void setRadiosVisible(int visibleRadios) {
		WindowManager windowManager = mActivity.getWindowManager();
		mRadioWidth = (windowManager.getDefaultDisplay().getWidth()) / visibleRadios;
	}

	public class RadioBarBean {
		public int mId;
		public String mTitleString;
		public boolean mSelected;

		public RadioBarBean(String titleString, int id) {
			mTitleString = titleString;
			mId = id;
			mSelected = false;
		}
	}

	private int mRadioWidth = 0;
	protected List<RadioBarBean> mRadioLists = new ArrayList<RadioBarBean>();
	private HorizontalListView mRadioBarHorizontalListView;
	private RadioBarAdapter mBarAdapter;
	private LinearLayout mListHeaderLinearLayout;

	private void selectedRadio(int index) {
		if (mRadioLists == null || mRadioLists.size() <= index) {
			return;
		}

		for (RadioBarBean radioBean : mRadioLists) {
			if (radioBean.mSelected) {
				radioBean.mSelected = false;
			}
		}

		mRadioLists.get(index).mSelected = true;
		onSelectedChanged(mRadioLists.get(index));
	}

	public void onSelectedChanged(RadioBarBean selectedRadioBean) {

	}

	protected int getSelectedType() {
		return getSelectedRadioBean().mId;
	}

	protected RadioBarBean getSelectedRadioBean() {
		RadioBarBean nBarBean = mRadioLists.get(0);
		for (RadioBarBean radioBean : mRadioLists) {
			if (radioBean.mSelected) {
				return radioBean;
			}
		}
		return nBarBean;
	}

	protected void addBelowBarHeader(LinearLayout headerLayout){
		
	}
	
	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		mListHeaderLinearLayout = (LinearLayout) findViewById(R.id.base_fragment_header_ll);
		mRadioBarHorizontalListView = (HorizontalListView) findViewById(R.id.bar_list_view);
		mBarAdapter = new RadioBarAdapter();
		
		mRadioBarHorizontalListView.setVisibility(View.VISIBLE);
		mListHeaderLinearLayout.setVisibility(View.VISIBLE);
		findViewById(R.id.base_fragment_top_divide_bar).setVisibility(View.GONE);

		mRadioBarHorizontalListView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				selectedRadio(position);
				mBarAdapter.notifyDataSetChanged();
			}
		});

		mRadioLists.addAll(initRadioBar());
		selectedDefaultRadio();
		setRadiosVisible(mRadioLists.size());

		addBelowBarHeader(mListHeaderLinearLayout);

		mRadioBarHorizontalListView.setAdapter(mBarAdapter);
		mBarAdapter.notifyDataSetChanged();
	}
	
	void selectedDefaultRadio() {
		boolean nHasDefaultSelectedRadio = false;
		for (RadioBarBean item : mRadioLists) {
			item.mSelected = item.mId == DefaultSelectRadio();
			if (!nHasDefaultSelectedRadio) {
				nHasDefaultSelectedRadio = item.mSelected;
			}
		}
		
		if (!nHasDefaultSelectedRadio && mRadioLists.size() > 0) {
			mRadioLists.get(0).mSelected = true;
		}
	}

	protected abstract List<RadioBarBean> initRadioBar();
}
