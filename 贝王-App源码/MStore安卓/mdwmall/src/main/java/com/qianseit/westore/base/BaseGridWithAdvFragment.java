package com.qianseit.westore.base;

import android.content.ContentValues;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.qianseit.westore.ui.ImageCycleView;
import com.qianseit.westore.ui.ImageCycleView.ImageCycleViewListener;
import com.qianseit.westore.ui.MyScrollView.OnScrollListener;
import com.qianseit.westore.ui.pull.PullToRefreshLayout;
import com.qianseit.westore.ui.pull.PullToRefreshLayout.OnRefreshListener;
import com.qianseit.westore.ui.pull.PullableScrollView;
import com.qianseit.westore.util.Util;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public abstract class BaseGridWithAdvFragment<T> extends BasePageFragment<T> implements OnRefreshListener, ImageCycleViewListener {

	public class TopAdsTask implements JsonTaskHandler {
		@Override
		public JsonRequestBean task_request() {
			JsonRequestBean mBean = new JsonRequestBean(Run.API_URL, requestAdsInterfaceName());
			ContentValues nContentValuess = extentAdsConditions();
			if (nContentValuess != null) {
				mBean.addAllParams(nContentValuess);
			}
			return mBean;
		}

		@Override
		public void task_response(String json_str) {
			List<JSONObject> data = null;
			mTopAdsArray.clear();
			try {
				JSONObject mJsonObject = new JSONObject(json_str);
				if (Run.checkRequestJson(mActivity, mJsonObject)) {
					data = fetchAdsDatas(mJsonObject);
					if (data != null && data.size() > 0) {
						for (int i = 0; i < data.size(); i++) {
							mTopAdsArray.add(data.get(i));
						}
					}
				}
			} catch (Exception e) {
			} finally {
				if (mTopAdsArray != null && mTopAdsArray.size() > 0) {
					mImageCycleView.setImageResources(mTopAdsArray, BaseGridWithAdvFragment.this);
				} else {
					mImageCycleView.setVisibility(View.GONE);
				}
			}
		}
	}

	//轮播广告
	ImageCycleView mImageCycleView;
	protected ArrayList<JSONObject> mTopAdsArray = new ArrayList<JSONObject>();
	
	//no data view
	private ImageView mEmptyImageView;
	private TextView mEmptyTextView;
	private RelativeLayout mEmptyViewRL;
	private String mEmptyString = "";
	private int mEmptyStringRes = -1;
	private int mImageRes = -1;

	protected int mImageWidth;

	//pull view
	private PullToRefreshLayout mPullToRefreshLayout;
	protected GridView mGridView;

	PullableScrollView mPullableScrollView; 
	int mScreenHeight = 0;
	ImageView mToTopImageView;

	@Override
	protected void onLoadFinished() {
		// TODO Auto-generated method stub
		mPullToRefreshLayout.refreshFinish(PullToRefreshLayout.SUCCEED);
		mPullToRefreshLayout.loadmoreFinish(PullToRefreshLayout.SUCCEED);
	}

	@Override
	protected void onPageEnable(boolean enable) {
		// TODO Auto-generated method stub
		mPullToRefreshLayout.setPullDown(enable);
		mPullToRefreshLayout.setPullUp(enable);
	}
	
	@Override
	protected void init() {
		// TODO Auto-generated method stub
		rootView = View.inflate(mActivity, R.layout.base_fragment_grid_with_topadv, null);

		mPullToRefreshLayout = ((PullToRefreshLayout) findViewById(R.id.refresh_view));
		mPullToRefreshLayout.setOnRefreshListener(this);

		mEmptyViewRL = (RelativeLayout) findViewById(R.id.base_error_rl);
		mEmptyImageView = (ImageView) findViewById(R.id.base_error_iv);
		mEmptyTextView = (TextView) findViewById(R.id.base_error_tv);
		mEmptyViewRL.setVisibility(View.GONE);
		findViewById(R.id.base_reload_tv).setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				onRefresh(null);
			}
		});
		
		mImageWidth = (1080 - Run.dip2px(mActivity, 5 * (getNumColumns() + 1))) / 2;
		mGridView = (GridView) findViewById(R.id.base_gv);
		mGridView.setAdapter(mAdapter);
		mGridView.setEmptyView(mEmptyViewRL);
		mGridView.setNumColumns(getNumColumns());
		mGridView.setHorizontalSpacing(Util.dip2px(mActivity, 5));
		mGridView.setVerticalSpacing(Util.dip2px(mActivity, 5));
		mGridView.setStretchMode(GridView.STRETCH_COLUMN_WIDTH);

		//轮播广告
		mImageCycleView = (ImageCycleView) findViewById(R.id.base_ad_view);
		mImageCycleView.requestDisallowInterceptTouchEvent(true);
		
		//no data view
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
		
		endInit();
	}

	void initToTop(){
		mScreenHeight = Run.getWindowsHeight(mActivity);

		mToTopImageView = (ImageView)findViewById(R.id.to_top);
		mToTopImageView.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				mPullableScrollView.smoothScrollTo(0, 0);
			}
		});
		
		mPullableScrollView = (PullableScrollView) findViewById(R.id.base_pull_scrollview);
		mPullableScrollView.setOnScrollListener(new OnScrollListener() {
			
			@Override
			public void onScroll(int scrollY) {
				// TODO Auto-generated method stub
				if (Math.abs(scrollY) > mScreenHeight * 2) {
					mToTopImageView.setVisibility(View.VISIBLE);
				}else{
					mToTopImageView.setVisibility(View.GONE);
				}
			}
		});
	}

	protected abstract List<JSONObject> fetchAdsDatas(JSONObject responseJson);
	protected abstract String requestAdsInterfaceName();
	protected ContentValues extentAdsConditions() {
		return null;
	}
	
	protected int getNumColumns() {
		return 2;
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

	private void showDivideTop(boolean show) {
		findViewById(R.id.base_fragment_top_divide).setVisibility(show ? View.VISIBLE : View.GONE);
	}

	@Override
	public void onRefresh(PullToRefreshLayout pullToRefreshLayout) {
		// TODO Auto-generated method stub
		loadNextPage(0);
	}
	
	@Override
	protected void loadNextPage(int curPageNumber) {
		// TODO Auto-generated method stub
		if (curPageNumber == 0) {
			Run.excuteJsonTask(new JsonTask(), new TopAdsTask());
		}
		super.loadNextPage(curPageNumber);
	}
	
	@Override
	public void onLoadMore(PullToRefreshLayout pullToRefreshLayout) {
		// TODO Auto-generated method stub
		loadNextPage(mPageNum);
	}
}
