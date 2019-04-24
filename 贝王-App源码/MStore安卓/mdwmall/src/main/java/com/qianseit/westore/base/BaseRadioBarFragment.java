package com.qianseit.westore.base;

import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.adpter.BaseRadioBarAdapter;
import com.qianseit.westore.base.adpter.BaseRadioBarAdapter.RadioBarCallback;
import com.qianseit.westore.base.adpter.RadioBarBean;
import com.qianseit.westore.ui.HorizontalListView;

import java.util.List;

abstract public class BaseRadioBarFragment extends BaseDoFragment implements RadioBarCallback {

	protected LoginedUser mLoginedUser;
	private HorizontalListView mRadioBarHorizontalListView;
	protected BaseRadioBarAdapter mBarAdapter;
	private LinearLayout mListTopLinearLayout;
	int mFragmentLayoutId = R.layout.base_fragment_radiobar;
	int mContainerId = R.id.base_fragment_main_content;

	private void switchFragment(BaseDoFragment baseFragment) {
		FragmentTransaction fragmentTransaction = mActivity.getSupportFragmentManager().beginTransaction();
		fragmentTransaction.replace(mContainerId, baseFragment);
		fragmentTransaction.commit();
	}

	protected void initTop(LinearLayout topLayout) {

	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		int nLayoutId = getExtraIntFromBundle(Run.EXTRA_BASE_LAYOUT_ID);
		int nContainerId = getExtraIntFromBundle(Run.EXTRA_BASE_FRRAMLAYOUT_CONTAINER_ID);

		Bundle nBundler = getArguments();
		if(nLayoutId > 0) {
			mFragmentLayoutId = nLayoutId;
		}else if(nBundler != null){
			mFragmentLayoutId = nBundler.getInt(Run.EXTRA_BASE_LAYOUT_ID, mFragmentLayoutId);
		}
		if(nContainerId > 0) {
			mContainerId = nContainerId;
		}else if(nBundler != null){
			mContainerId = nBundler.getInt(Run.EXTRA_BASE_FRRAMLAYOUT_CONTAINER_ID, mContainerId);
		}
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
		rootView = inflater.inflate(mFragmentLayoutId, null);
		mListTopLinearLayout = (LinearLayout) findViewById(R.id.base_fragment_top_ll);
		mRadioBarHorizontalListView = (HorizontalListView) findViewById(R.id.bar_list_view);
		initTop(mListTopLinearLayout);

		mBarAdapter = new BaseRadioBarAdapter(mActivity, initRadioBar(), this) {
			@Override
			public void onSelectedChanged(int selectedIndex) {
				// TODO Auto-generated method stub
				onSelectedRadioBar(getItem(selectedIndex));
			}

			@Override
			public void notifyDataSetChanged() {
				// TODO Auto-generated method stub
				super.notifyDataSetChanged();
				if (getCount() <= 1) {
					mRadioBarHorizontalListView.setVisibility(View.GONE);
					if (getCount() == 1)
						onSelectedRadioBar(getItem(0));
				} else {
					mRadioBarHorizontalListView.setVisibility(View.VISIBLE);
					super.notifyDataSetChanged();
				}
			}

			@Override
			public int defaultSelectedIndex() {
				// TODO Auto-generated method stub
				return BaseRadioBarFragment.this.defaultSelectedIndex();
			}
		};
		mBarAdapter.setDivideColor(divideDrawable());
		mBarAdapter.setVisibleRadios(visibleCount());
		init();
		mRadioBarHorizontalListView.setAdapter(mBarAdapter);
		mBarAdapter.notifyDataSetChanged();
	}

	protected Drawable divideDrawable() {
		return null;
	}

	protected int defaultSelectedIndex() {
		return 0;
	}

	/**
	 * 小于等于0时为根据内容自动适应 最大值是5
	 */
	protected int visibleCount() {
		return 5;
	}

	protected void init() {
		// TODO Auto-generated method stub
	}

	protected void setRadioBarHeight(int height) {
		mRadioBarHorizontalListView.getLayoutParams().height = height;
	}

	@Override
	public boolean showRadioBarsDivider() {
		// TODO Auto-generated method stub
		return true;
	}

	protected abstract List<RadioBarBean> initRadioBar();

	public int parentWindowsWidth() {
		// TODO Auto-generated method stub
		return Run.getWindowsWidth(mActivity);
	}

	protected void reloadRadio() {
		mBarAdapter.notifyDataSetChanged();
	}

	protected BaseDoFragment getSelectedFragment() {
		return getRadioBarFragemnt(mBarAdapter.getSelectedItem().mId);
	}

	@Override
	public boolean onSelectedRadioBar(RadioBarBean barBean) {
		// TODO Auto-generated method stub
		switchFragment(getRadioBarFragemnt(barBean.mId));
		return true;
	}

	protected abstract BaseDoFragment getRadioBarFragemnt(long radioBarId);
}
