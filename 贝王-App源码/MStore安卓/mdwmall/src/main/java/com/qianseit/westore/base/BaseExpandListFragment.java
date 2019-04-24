package com.qianseit.westore.base;

import android.content.ContentValues;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.listener.ListScrollDistanceCalculator;
import com.qianseit.westore.base.listener.ListScrollDistanceCalculator.ScrollDistanceListener;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;
import com.qianseit.westore.ui.XPullDownExpandListView;
import com.qianseit.westore.ui.XPullDownListView.IXListViewListener;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public abstract class BaseExpandListFragment<GroupItemT, DetailItemT> extends BaseDoFragment implements IXListViewListener {

	public static class ExpandType{
		public final static int ALL = 1;
		public final static int FIRST = 2;
		public final static int NONE = 3;
	}
	protected class MyAdapter extends BaseExpandableListAdapter {

		@Override
		public int getGroupCount() {
			// TODO Auto-generated method stub
			return mResultLists.size();
		}

		@Override
		public int getChildrenCount(int groupPosition) {
			// TODO Auto-generated method stub
			return mResultLists.get(groupPosition).mDetailLists.size();
		}

		@Override
		public ExpandListItemBean<GroupItemT, DetailItemT> getGroup(int groupPosition) {
			// TODO Auto-generated method stub
			return mResultLists.get(groupPosition);
		}

		@Override
		public DetailItemT getChild(int groupPosition, int childPosition) {
			// TODO Auto-generated method stub
			return mResultLists.get(groupPosition).mDetailLists.get(childPosition);
		}

		@Override
		public long getGroupId(int groupPosition) {
			// TODO Auto-generated method stub
			return mResultLists.get(groupPosition).hashCode();
		}

		@Override
		public long getChildId(int groupPosition, int childPosition) {
			// TODO Auto-generated method stub
			return mResultLists.get(groupPosition).mDetailLists.get(childPosition).hashCode();
		}

		@Override
		public boolean hasStableIds() {
			// TODO Auto-generated method stub
			return false;
		}

		@Override
		public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			return getGroupItemView(getGroup(groupPosition), isExpanded, convertView, parent);
		}

		@Override
		public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			return getDetailItemView(getGroup(groupPosition), getChild(groupPosition, childPosition), isLastChild, convertView, parent);
		}

		@Override
		public boolean isChildSelectable(int groupPosition, int childPosition) {
			// TODO Auto-generated method stub
			return false;
		}
	}

	private class PageSearchTask implements JsonTaskHandler {

		{
			if (mPageNum == 1) {
				mResultLists.clear();
				mAdatpter.notifyDataSetChanged();
				mListView.setPullLoadEnable(false);
			}
		}

		@Override
		public JsonRequestBean task_request() {
			showCancelableLoadingDialog();
			JsonRequestBean mBean = new JsonRequestBean(Run.API_URL, requestInterfaceName());
			if (mEnablePage) {
				mBean.addParams("page", String.valueOf(mPageNum));
			}
			ContentValues nContentValuess = extentConditions();
			if (nContentValuess != null) {
				mBean.addAllParams(nContentValuess);
			}
			return mBean;
		}

		@Override
		public void task_response(String json_str) {
			if (!rootView.isShown()) {
				rootView.setVisibility(View.VISIBLE);
			}
			List<ExpandListItemBean<GroupItemT, DetailItemT>> data = null;
			try {
				JSONObject mJsonObject = new JSONObject(json_str);
				if (BaseHttpInterfaceTask.checkRequestJson(mActivity, mJsonObject)) {
					JSONObject nDataJsonObject = mJsonObject.optJSONObject("data");
					data = fetchDatas(nDataJsonObject);
					if (data != null && data.size() > 0) {
						for (int i = 0; i < data.size(); i++) {
							mResultLists.add(data.get(i));
						}
					}

					JSONObject nPageJsonObject = nDataJsonObject.optJSONObject("pager");
					if (!mEnablePage || data == null || data.size() <= 0 ||(nPageJsonObject != null && nPageJsonObject.optInt("total") <= mPageNum)) {
						isLoadedAll = true;
					}
				}
			} catch (Exception e) {
			} finally {
				onStopLoad();
				hideLoadingDialog_mt();
				mAdatpter.notifyDataSetChanged();
				if (mAdatpter.getGroupCount() > 0) {
					if (defualtExpandType() == ExpandType.ALL) {
						for (int i = 0; i < mAdatpter.getGroupCount(); i++) {
							mListView.expandGroup(i);
						}
					}else if (defualtExpandType() == ExpandType.FIRST) {
						//mListView.expandGroup(0);//默认打开第一个
					}
				}
				setPageState();
			}
		}
	}
	
	protected int defualtExpandType(){
		return ExpandType.ALL;
	}
	
	protected static class ExpandListItemBean<GroupItemT, DetailItemT> {
		public ExpandListItemBean() {
			// TODO Auto-generated constructor stub
		}
		public GroupItemT mGrupItem;
		public List<DetailItemT> mDetailLists = new ArrayList<DetailItemT>();
		public void addDetail(DetailItemT detailItemT){
			mDetailLists.add(detailItemT);
		}
	}

	protected LoginedUser mLoginedUser;
	private boolean isLoadedAll;// 是否已经拿完服务器所有数据
	protected MyAdapter mAdatpter;
	private ImageView mEmptyImageView;
	private String mEmptyString = "";

	private int mEmptyStringRes = -1;
	private TextView mEmptyTextView;

	private RelativeLayout mEmptyViewRL;
	private int mImageRes = -1;

	private LinearLayout mListBottomRelativeLayout;
	protected RelativeLayout mListRelativeLayout;
	private LinearLayout mListTopRelativeLayout;
	private View mDivideTop1;
	boolean mEnablePage = true;

	ImageView mToTopImageView;
	protected XPullDownExpandListView mListView;
	ListScrollDistanceCalculator mListScrollDistanceCalculator;
	int mScreenHeight = 0;

	protected int mPageNum = 1;

	protected int mPageSize = 5;

	protected List<ExpandListItemBean<GroupItemT, DetailItemT>> mResultLists = new ArrayList<ExpandListItemBean<GroupItemT, DetailItemT>>();

	protected void addFooter(XPullDownExpandListView listView) {

	}

	protected void addHeader(XPullDownExpandListView listView) {

	}

	protected void disablePage() {
		mEnablePage = false;
		mListView.setPullLoadEnable(false);
	}

	protected void disableReflash() {
		mListView.setPullRefreshEnable(false);
	}

	protected ContentValues extentConditions() {
		return null;
	}

	protected abstract List<ExpandListItemBean<GroupItemT, DetailItemT>> fetchDatas(JSONObject responseJson);

	private void firstLoad() {
		mPageNum = 1;
		loadNextPage(mPageNum);
	}

	protected abstract View getGroupItemView(ExpandListItemBean<GroupItemT, DetailItemT> groupBean, boolean isExpanded, View convertView, ViewGroup parent);

	protected abstract View getDetailItemView(ExpandListItemBean<GroupItemT, DetailItemT> groupBean, DetailItemT detailBean, boolean isLastChild, View convertView, ViewGroup parent);

	public int getPageNum() {
		return mPageNum;
	}

	protected void init() {

	}

	@Override
	final public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
		rootView = inflater.inflate(R.layout.base_fragment_expandlist, null);
		rootView.setVisibility(View.INVISIBLE);
		initActionBar();

		mListRelativeLayout = (RelativeLayout) findViewById(R.id.base_fragment_listview_rl);
		mListBottomRelativeLayout = (LinearLayout) findViewById(R.id.base_fragment_listview_bottom_ll);
		mListTopRelativeLayout = (LinearLayout) findViewById(R.id.base_fragment_listview_top_ll);
		mListView = (XPullDownExpandListView) findViewById(R.id.base_lv);
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
		mListView.setEmptyView(mEmptyViewRL);
		
		mAdatpter = new MyAdapter();
		mListView.setAdapter(mAdatpter);
		mListView.setXPullDownListViewListener(this);
		mListView.setPullLoadEnable(false);

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
		
		initTop(mListTopRelativeLayout);
		initBottom(mListBottomRelativeLayout);
		addHeader(mListView);
		addFooter(mListView);
		init();

		mEmptyViewRL.setVisibility(View.GONE);
		// 第一加载
		firstLoad();
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
	
	protected abstract void initActionBar();

	protected void initBottom(LinearLayout bottomLayout) {

	}

	protected void initTop(LinearLayout topLayout) {

	}

	protected void loadNextPage(int pageNumber) {
		if (pageNumber == 1) {
			isLoadedAll = false;
		}

		if (isLoadedAll) {
			return;
		}

		Run.excuteJsonTask(new JsonTask(), new PageSearchTask());
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

	}

	@Override
	public void onLoadMore() {
		mPageNum++;
		loadNextPage(mPageNum);
	}

	@Override
	public void onRefresh() {
		mPageNum = 1;
		loadNextPage(mPageNum);
	}

	@Override
	public void onResume() {
		super.onResume();
	}

	// 停止刷新
	protected void onStopLoad() {
		mListView.stopRefresh();
		mListView.stopLoadMore();
		mListView.setRefreshTime("刚刚");
	}

	protected abstract String requestInterfaceName();

	final protected void setEmptyImage(int imgRes) {
		if (mEmptyImageView == null) {
			mImageRes = imgRes;
			return;
		}
		mEmptyImageView.setImageResource(imgRes);
		mEmptyImageView.setVisibility(View.VISIBLE);
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

	public void setPageNum(int mPageNum) {
		this.mPageNum = mPageNum;
	}

	protected void setPageState() {
		if (mEnablePage && !isLoadedAll) {
			mListView.setPullLoadEnable(true);
		} else {
			mListView.setPullLoadEnable(false);
		}
	}

	protected void showDivideTop1(boolean show) {
		mDivideTop1.setVisibility(show ? View.VISIBLE : View.GONE);
	}
}
