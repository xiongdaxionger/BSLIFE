package com.qianseit.westore.base;

import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.listener.ListScrollDistanceCalculator;
import com.qianseit.westore.base.listener.ListScrollDistanceCalculator.ScrollDistanceListener;
import com.qianseit.westore.ui.XPullDownListView;
import com.qianseit.westore.ui.XPullDownListView.IXListViewListener;

public abstract class BaseListFragment<T> extends BasePageFragment<T> implements IXListViewListener {

	private ImageView mEmptyImageView;
	private String mEmptyString = "";

	private int mEmptyStringRes = -1;
	private TextView mEmptyTextView;

	private RelativeLayout mEmptyViewRL;
	private int mImageRes = -1;

	private LinearLayout mListBottomLinearLayout;
	protected RelativeLayout mListRelativeLayout;
	private LinearLayout mListTopLinearLayout;
	private View mDivideTop1;

	ImageView mToTopImageView;
	protected XPullDownListView mListView;
	ListScrollDistanceCalculator mListScrollDistanceCalculator;
	int mScreenHeight = 0;

	protected void addFooter(XPullDownListView listView) {

	}

	protected void addHeader(XPullDownListView listView) {

	}

	protected abstract View getItemView(T responseJson, View convertView, ViewGroup parent);

	protected void init() {
		
		rootView = View.inflate(mActivity, R.layout.base_fragment_list, null);

		mListRelativeLayout = (RelativeLayout) findViewById(R.id.base_fragment_listview_rl);
		mListBottomLinearLayout = (LinearLayout) findViewById(R.id.base_fragment_listview_bottom_ll);
		mListTopLinearLayout = (LinearLayout) findViewById(R.id.base_fragment_listview_top_ll);
		mListView = (XPullDownListView) findViewById(R.id.base_lv);
		mEmptyViewRL = (RelativeLayout) findViewById(R.id.base_error_rl);
		mEmptyImageView = (ImageView) findViewById(R.id.base_error_iv);
		mEmptyTextView = (TextView) findViewById(R.id.base_error_tv);
		mEmptyViewRL.setVisibility(View.GONE);
		findViewById(R.id.base_reload_tv).setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				onRefresh();
			}
		});
		
		mListView.setEmptyView(mEmptyViewRL);
		mAdapter = new MyAdapter();
		mListView.setAdapter(mAdapter);
		mListView.setXPullDownListViewListener(this);
		mListView.setPullLoadEnable(true);

		mDivideTop1 = findViewById(R.id.base_fragment_top_divide1);

		if (mImageRes != -1) {
			setEmptyImage(mImageRes);
		}
		if (mEmptyStringRes != -1) {
			setEmptyText(mEmptyStringRes);
		}
		if (mEmptyString != null && !TextUtils.isEmpty(mEmptyString)) {
			setEmptyText(mEmptyString);
		}
		
		initToTop();

		initTop(mListTopLinearLayout);
		initBottom(mListBottomLinearLayout);
		addHeader(mListView);
		addFooter(mListView);

		mEmptyViewRL.setVisibility(View.GONE);
		endInit();
	}
	
	void initToTop(){
		mScreenHeight = Run.getWindowsHeight(mActivity);

		mToTopImageView = (ImageView)findViewById(R.id.to_top);
		mToTopImageView.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				mListView.setSelectionAfterHeaderView();
				mListView.smoothScrollToPosition(0);
			}
		});
		mListScrollDistanceCalculator = new ListScrollDistanceCalculator();
		mListScrollDistanceCalculator.setScrollDistanceListener(new ScrollDistanceListener() {
			
			@Override
			public void onScrollDistanceChanged(int delta, int total) {
				// TODO Auto-generated method stub
				if (Math.abs(total) > mScreenHeight * 2) {
					mToTopImageView.setVisibility(View.VISIBLE);
				}else{
					mToTopImageView.setVisibility(View.GONE);
				}
			}
		});
		
		mListView.setOnScrollListener(mListScrollDistanceCalculator);

	}
	
	protected void setCustomEmptyView(View customEmptyView){
		mEmptyViewRL.removeAllViews();

		mEmptyViewRL.addView(customEmptyView);
		RelativeLayout.LayoutParams nLayoutParams = (LayoutParams) customEmptyView.getLayoutParams();
		nLayoutParams.width = LayoutParams.MATCH_PARENT;
	}
	
	protected void initBottom(LinearLayout bottomLayout) {

	}

	protected void initTop(LinearLayout topLayout) {

	}

	@Override
	public void onLoadMore() {
		loadNextPage(mPageNum);
	}

	@Override
	public void onRefresh() {
		if (mEnablePage) {
			mListView.setPullLoadEnable(true);
		}
		loadNextPage(0);
	}

	final protected void setEmptyImage(int imgRes) {
		if (mEmptyImageView == null) {
			mImageRes = imgRes;
			return;
		}
		mEmptyImageView.setImageResource(imgRes);
	}

	final protected void setEmptyText(int strRes) {
		if (mEmptyImageView == null) {
			mEmptyStringRes = strRes;
			return;
		}
		mEmptyTextView.setText(strRes);
	}

	final protected void setEmptyText(String emptyString) {
		if (mEmptyImageView == null) {
			mEmptyString = emptyString;
			return;
		}
		mEmptyTextView.setText(emptyString);
	}

	@Override
	protected void onLoadFinished() {
		// TODO Auto-generated method stub
		mListView.stopRefresh();
		mListView.stopLoadMore();
		mListView.setRefreshTime("刚刚");
		if (isLoadAll()) {
			mListView.setPullLoadEnable(false);
		}
	}

	@Override
	protected void onPageEnable(boolean enable) {
		// TODO Auto-generated method stub
		mListView.setPullLoadEnable(enable);
		mListView.setPullRefreshEnable(enable);
	}
	
	protected void showDivideTop1(boolean show) {
		mDivideTop1.setVisibility(show ? View.VISIBLE : View.GONE);
	}

	private void showDivideTop(boolean show) {
		findViewById(R.id.base_fragment_top_divide).setVisibility(show ? View.VISIBLE : View.GONE);
	}
}
