package com.qianseit.westore.base;

import java.util.List;

import org.json.JSONObject;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.baoyz.swipemenulistview.SwipeMenu;
import com.baoyz.swipemenulistview.SwipeMenuCreator;
import com.baoyz.swipemenulistview.SwipeMenuItem;
import com.baoyz.swipemenulistview.SwipeMenuListView;
import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.ui.XPullDownSwipeMenuListView;
import com.qianseit.westore.ui.XPullDownSwipeMenuListView.IXListViewListener;

public abstract class BaseSwticListFragment extends BasePageFragment<JSONObject> implements OnItemClickListener, IXListViewListener {
	private ImageView mEmptyImageView;
	private String mEmptyString = "";

	private int mEmptyStringRes = -1;
	private TextView mEmptyTextView;

	private RelativeLayout mEmptyViewRL;
	private int mImageRes = -1;

	private LinearLayout mListBottomRelativeLayout;
	private RelativeLayout mListRelativeLayout;
	private LinearLayout mListTopRelativeLayout;

	protected XPullDownSwipeMenuListView mListView;

	protected abstract void initActionBar();

	protected void init() {
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
		rootView = View.inflate(mActivity, R.layout.base_fragment_swticlist, null);
		initActionBar();

		mListRelativeLayout = (RelativeLayout) findViewById(R.id.base_fragment_listview_rl);
		mListBottomRelativeLayout = (LinearLayout) findViewById(R.id.base_fragment_listview_bottom_ll);
		mListTopRelativeLayout = (LinearLayout) findViewById(R.id.base_fragment_listview_top_ll);
		mListView = (XPullDownSwipeMenuListView) findViewById(R.id.base_lv);
		mEmptyViewRL = (RelativeLayout) findViewById(R.id.base_error_rl);
		mEmptyImageView = (ImageView) findViewById(R.id.base_error_iv);
		mEmptyTextView = (TextView) findViewById(R.id.base_error_tv);
		findViewById(R.id.base_reload_tv).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				onRefresh();
			}
		});

		mEmptyViewRL.setVisibility(View.GONE);
		mListView.setEmptyView(mEmptyViewRL);
		mListView.setAdapter(mAdapter);
		mListView.setXPullDownListViewListener(this);
		mListView.setPullLoadEnable(true);
		createMenuItems();

		if (mImageRes != -1) {
			setEmptyImage(mImageRes);
		}
		if (mEmptyStringRes != -1) {
			setEmptyText(mEmptyStringRes);
		}
		if (mEmptyString != null && !TextUtils.isEmpty(mEmptyString)) {
			setEmptyText(mEmptyString);
		}

		initTop(mListTopRelativeLayout);
		initBottom(mListBottomRelativeLayout);
		addHeader(mListView);
		addFooter(mListView);
		
		endInit();
	}

	@Override
	protected void onPageEnable(boolean enable) {
		// TODO Auto-generated method stub
		mListView.setPullLoadEnable(enable);
		mListView.setPullRefreshEnable(enable);
	}

	protected void initBottom(LinearLayout bottomLayout) {

	}

	protected void initTop(LinearLayout topLayout) {

	}

	protected void addFooter(XPullDownSwipeMenuListView listView) {

	}

	protected void addHeader(XPullDownSwipeMenuListView listView) {

	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

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
	public void onResume() {
		super.onResume();
		mEmptyViewRL.setVisibility(View.GONE);
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

	protected void setCustomEmptyView(View customEmptyView) {
		mEmptyViewRL.removeAllViews();

		mEmptyViewRL.addView(customEmptyView);
		RelativeLayout.LayoutParams nLayoutParams = (LayoutParams) customEmptyView.getLayoutParams();
		nLayoutParams.width = LayoutParams.MATCH_PARENT;
	}

	private void createMenuItems() {
		SwipeMenuCreator creator = new SwipeMenuCreator() {

			@Override
			public void create(SwipeMenu menu) {
				// create "delete" item
				List<SwipeMenuItem> nItems = createSwipeMenuItems(menu.getViewType());
				if (nItems == null || nItems.size() <= 0) {
					return;
				}

				for (SwipeMenuItem swipeMenuItem : nItems) {
					menu.addMenuItem(swipeMenuItem);
				}
			}
		};
		// set creator
		mListView.setMenuCreator(creator);
		// step 2. listener item click event
		mListView.setOnMenuItemClickListener(new SwipeMenuListView.OnMenuItemClickListener() {
			@Override
			public boolean onMenuItemClick(int position, SwipeMenu menu, int index) {
				JSONObject jsonGoods = mResultLists.get(position);
				onSwipeMenuItemClick(jsonGoods, index);
				return false;
			}
		});

		mListView.setOnItemClickListener(this);
	}

	protected List<SwipeMenuItem> createSwipeMenuItems(int viewType) {
		return null;
	}

	protected void onSwipeMenuItemClick(JSONObject positionJsonObject, int index) {

	}
}
