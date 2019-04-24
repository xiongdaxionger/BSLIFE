package com.qianseit.westore.base;

import android.annotation.SuppressLint;
import android.content.ContentValues;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.community.CommDiscoverNoteListFragment;
import com.qianseit.westore.ui.HorizontalListView;

import java.util.ArrayList;
import java.util.List;

abstract public class BaseRadioPageViewFragment extends BaseDoFragment implements OnPageChangeListener {

	private class pageAdapter extends FragmentPagerAdapter {

		public pageAdapter(FragmentManager fm) {
			super(fm);
			// TODO Auto-generated constructor stub
		}

		@Override
		public Fragment getItem(int arg0) {
			// TODO Auto-generated method stub
			return mFragments.get(arg0);
		}

		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			return mFragments.size();
		}

		@Override
		public int getItemPosition(Object object) {
			return super.getItemPosition(object);
		}
	}

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
				RelativeLayout barRelativeLayout = (RelativeLayout) convertView.findViewById(R.id.bar_item_rel);
				RelativeLayout.LayoutParams layoutParams = (android.widget.RelativeLayout.LayoutParams) barRelativeLayout.getLayoutParams();
				layoutParams.width = mRadioWidth;
			}
			final RadioBarBean item = this.getItem(position);
			convertView.findViewById(R.id.textView1).setSelected(item.mSelected);
			convertView.findViewById(R.id.view_color).setSelected(item.mSelected);
			((TextView) convertView.findViewById(R.id.textView1)).setText(item.mTitleString);
			if (item.mSelected) {
				if (item.mFilternContentValuess != null && item.mFilternContentValuess.size() > 0) {
					if (item.mFilterDrawable != null && item.mFilterDrawable.size() > 0) {
						if (item.mCurFilterItemIndex < item.mFilterDrawable.size()) {
							((TextView) convertView.findViewById(R.id.textView1)).setCompoundDrawablePadding(5);
							((TextView) convertView.findViewById(R.id.textView1)).setCompoundDrawablesWithIntrinsicBounds(null, null, item.mFilterDrawable.get(item.mCurFilterItemIndex), null);
						} else {
							((TextView) convertView.findViewById(R.id.textView1)).setCompoundDrawablePadding(5);
							((TextView) convertView.findViewById(R.id.textView1)).setCompoundDrawablesWithIntrinsicBounds(null, null,
									item.mFilterDrawable.get(item.mCurFilterItemIndex % item.mFilterDrawable.size()), null);
						}
					}
				}

			} else {
				item.mCurFilterItemIndex = 0;
				if (item.mFilternContentValuess != null && item.mFilternContentValuess.size() > 0) {
					if (item.mFilterDrawable != null && item.mFilterDrawable.size() > 0) {
						((TextView) convertView.findViewById(R.id.textView1)).setCompoundDrawablePadding(5);
						((TextView) convertView.findViewById(R.id.textView1)).setCompoundDrawablesWithIntrinsicBounds(null, null,
								item.mFilterDrawable.get(item.mCurFilterItemIndex % item.mFilterDrawable.size()), null);
					}
				}
			}

			if (position > 0 && setVisDivide()) {
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

	protected boolean setVisDivide() {
		return true;
	}

	protected void setRadiosVisible(int visibleRadios) {
		if (visibleRadios <= 0) {
			mRadioWidth = RelativeLayout.LayoutParams.WRAP_CONTENT;
			return;
		}
		mRadioWidth = width / visibleRadios;
	}

	public class RadioBarBean {
		public int mId;
		public String mTitleString;
		public boolean mSelected;

		public ContentValues mFilternContentValuess;
		public List<Drawable> mFilterDrawable;
		public int mCurFilterItemIndex = 0;
		public BaseDoFragment mFragment;

		public RadioBarBean(String titleString, int id, BaseDoFragment fragment) {
			mTitleString = titleString;
			mId = id;
			mSelected = false;
			mFragment = fragment;
		}

		public RadioBarBean(String titleString, int id, BaseDoFragment fragment, ContentValues basicnContentValuess, List<Drawable> drawableList) {
			mTitleString = titleString;
			mId = id;
			mSelected = false;
			mFragment = fragment;
			mFilternContentValuess = basicnContentValuess;
			mFilterDrawable = drawableList;
		}
	}

	protected LoginedUser mLoginedUser;
	private int mRadioWidth = 0;
	protected List<RadioBarBean> mRadioLists = new ArrayList<RadioBarBean>();
	protected List<CommDiscoverNoteListFragment> mFragments = new ArrayList<CommDiscoverNoteListFragment>();
	private HorizontalListView mRadioBarHorizontalListView;
	private RadioBarAdapter mBarAdapter;
	private LinearLayout mListTopLinearLayout;
	private int width;
	private pageAdapter mPageAdapter;
	private ViewPager mViewPager;
	int screenWidth = 0;

	public void selectedRadio(int index) {
		if (mRadioLists == null || mRadioLists.size() <= index) {
			return;
		}

		if (mRadioLists.get(index).mSelected) {
			RadioBarBean radioBean = mRadioLists.get(index);
			if (radioBean.mFilternContentValuess != null && radioBean.mFilternContentValuess.size() > 0) {
				if (radioBean.mCurFilterItemIndex < radioBean.mFilternContentValuess.size() - 1) {
					radioBean.mCurFilterItemIndex++;
				} else {
					radioBean.mCurFilterItemIndex = 0;
				}

				onFilterChanged(radioBean);
			}

		}

		for (RadioBarBean radioBean : mRadioLists) {
			if (radioBean.mSelected) {
				radioBean.mSelected = false;
			}
		}
		RadioBarBean mRadioBarBean = mRadioLists.get(index);
		mRadioBarBean.mSelected = true;
		mViewPager.setCurrentItem(index);
		mBarAdapter.notifyDataSetChanged();
		mMoveToThePosition = index;
		if (!mIsFirst) {
			new Handler().postDelayed(new Runnable() {


				public void run() {
					mRadioBarHorizontalListView.setSelection(mMoveToThePosition);
				}
			}, 50);
		}
	}

	boolean mIsFirst = true;
	int mMoveToThePosition = -1;
	@Override
	public void onWindowFocusChanged(boolean hasFocus) {
		super.onWindowFocusChanged(hasFocus);
		if(hasFocus && mMoveToThePosition >= 0){
			mRadioBarHorizontalListView.setSelection(mMoveToThePosition);
			mIsFirst = false;
		}
	}
	
	void scrollToIndex(int index){
		if (mRadioBarHorizontalListView.getChildCount() <= index) {
			return;
		}
		
		int toWidth = 0;
		int leftWidth = 0;
		for (int i = 0; i < index; i++) {
			leftWidth = leftWidth + mRadioBarHorizontalListView.getChildAt(i).getWidth();
		}
		int[] location = new int[2]; 
		mRadioBarHorizontalListView.getChildAt(index).getLocationInWindow(location);
		int nIndexX = location[0];
		int nIndexW = mRadioBarHorizontalListView.getChildAt(index).getWidth();
		if (nIndexX + nIndexW > screenWidth) {
			toWidth = (int) (mRadioBarHorizontalListView.getChildAt(index).getX() + (nIndexX + nIndexW - screenWidth));
			mRadioBarHorizontalListView.scrollTo(toWidth, 0);
		}
		else if(nIndexX < 0){
			mRadioBarHorizontalListView.scrollTo(leftWidth, 0);
		}
	}
	
	public void onSelectedChanged(RadioBarBean selectedRadioBean) {

	}

	public void onFilterChanged(RadioBarBean selectedRadioBean) {

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

	protected void initTop(LinearLayout topLayout) {

	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		WindowManager wm = (WindowManager) mActivity.getSystemService(Context.WINDOW_SERVICE);
		screenWidth = wm.getDefaultDisplay().getWidth();
		
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
		rootView = inflater.inflate(R.layout.base_fragment_pageview_radiobar, null);
		mListTopLinearLayout = (LinearLayout) findViewById(R.id.base_fragment_top_ll);
		mRadioBarHorizontalListView = (HorizontalListView) findViewById(R.id.bar_list_view);
		mViewPager = (ViewPager) findViewById(R.id.base_fragment_main_pageview);
		mBarAdapter = new RadioBarAdapter();
		mPageAdapter = new pageAdapter(mActivity.getSupportFragmentManager());
		mViewPager.setAdapter(mPageAdapter);
		mViewPager.setOnPageChangeListener(this);
		mRadioBarHorizontalListView.setAdapter(mBarAdapter);
		width = Run.getWindowsWidth(mActivity);
		mRadioWidth = width / 5;
		mRadioBarHorizontalListView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				selectedRadio(position);
			}
		});

		initTop(mListTopLinearLayout);
		init();

		reloadRadio();
	}

	protected void reloadRadio() {
		mRadioLists.clear();
		mFragments.clear();
		mRadioLists.addAll(initRadioBar());
		mFragments.addAll(initFragments());
		// setRadiosVisible(mRadioLists.size());
		mPageAdapter.notifyDataSetChanged();
		selectedDefaultRadio();
		mBarAdapter.notifyDataSetChanged();
	}

	void selectedDefaultRadio() {
		boolean nHasDefaultSelectedRadio = false;
		int i = 0;
		for (RadioBarBean item : mRadioLists) {
			item.mSelected = item.mId == DefaultSelectRadio();
			if (!nHasDefaultSelectedRadio) {
				nHasDefaultSelectedRadio = item.mSelected;
				mViewPager.setCurrentItem(i);
			}
			i++;
		}

		if (!nHasDefaultSelectedRadio && mRadioLists.size() > 0) {
			mRadioLists.get(0).mSelected = true;
			mViewPager.setCurrentItem(0);
		}
	}

	protected void init() {
		// TODO Auto-generated method stub
	}

	@Override
	public void onPageSelected(int arg0) {
		selectedRadio(arg0);
	}

	protected abstract List<RadioBarBean> initRadioBar();

	protected abstract List<CommDiscoverNoteListFragment> initFragments();

}
