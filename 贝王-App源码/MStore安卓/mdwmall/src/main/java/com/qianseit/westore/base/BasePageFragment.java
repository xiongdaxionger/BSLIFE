package com.qianseit.westore.base;

import android.content.ContentValues;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;

import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public abstract class BasePageFragment<T> extends BaseDoFragment {

	protected class MyAdapter extends BaseAdapter {

		@Override
		public int getCount() {
			return getItemCount();
		}

		@Override
		public T getItem(int position) {
			return mResultLists.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public int getViewTypeCount() {
			// TODO Auto-generated method stub
			return BasePageFragment.this.getViewTypeCount();
		}

		@Override
		public int getItemViewType(int position) {
			// TODO Auto-generated method stub
			return BasePageFragment.this.getItemViewType(getItem(position));
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {

			return getItemView(getItem(position), convertView, parent);
		}
	}

	/**
	 * @return
	 * 用来解决一行有多个item的情况
	 */
	public int getItemCount(){
		return mResultLists.size();
	}


	
	private class PageSearchTask implements JsonTaskHandler {
		@Override
		public JsonRequestBean task_request() {
			showCancelableLoadingDialog();
			JsonRequestBean mBean = new JsonRequestBean(Run.API_URL, requestInterfaceName());
			if (mEnablePage) {
				mBean.addParams("page", String.valueOf(mPageNum));
			}
			ContentValues nContentValues = extentConditions();
			if (nContentValues != null) {
				mBean.addAllParams(nContentValues);
			}
			return mBean;
		}

		@Override
		public void task_response(String json_str) {
			if (!rootView.isShown()) {
				rootView.setVisibility(View.VISIBLE);
			}
			List<T> data = null;
			if (mPageNum == 1) {
				mResultLists.clear();
			}

			try {
				JSONObject mJsonObject = new JSONObject(json_str);
				if (BaseHttpInterfaceTask.checkRequestJson(mActivity, mJsonObject)) {
					JSONObject nDataJsonObject = mJsonObject.optJSONObject("data");
					data = fetchDatas(nDataJsonObject == null ? mJsonObject : nDataJsonObject);
					if (data != null && data.size() > 0) {
						for (int i = 0; i < data.size(); i++) {
							mResultLists.add(data.get(i));
						}
					}

					JSONObject nPageJsonObject = nDataJsonObject.optJSONObject("pager");
					if (!mEnablePage || data == null || data.size() <= 0 || (nPageJsonObject != null && nPageJsonObject.optInt("total") <= mPageNum)) {
						mIsLoadAll = true;
					}
				}else{
					String nCode = mJsonObject.optString("code");
					if (nCode.equals("cart_empty")) {
						carEmpty();
					}else{
						fail(nCode);
					}
				}
			} catch (Exception e) {
			} finally {
				boolean isNull = true;
				isNull = mResultLists.size() <= 0;
				VisbleNull(isNull);
				onLoadFinished();
				hideLoadingDialog();
				mAdapter.notifyDataSetChanged();
			}
		}
	}

	protected LoginedUser mLoginedUser;
	protected boolean mIsLoadAll;// 是否已经拿完服务器所有数据
	protected MyAdapter mAdapter;
	protected JsonTask mJsonTask;

	protected boolean mEnablePage = true;
	boolean mAutoLoad = true;
	protected int mPageNum = 1;
	protected List<T> mResultLists = new ArrayList<T>();
	protected PageSearchTask mPageSearchTask = new PageSearchTask();

	protected void PageEnable(boolean enable) {
		mEnablePage = enable;
		onPageEnable(enable);
	}

	protected void VisbleNull(boolean isNull) {

	}

	protected int getViewTypeCount() {
		return 1;
	}

	protected int getItemViewType(T t) {
		return 1;
	}

	protected ContentValues extentConditions() {
		return null;
	}

	protected abstract List<T> fetchDatas(JSONObject responseJson);

	private void firstLoad() {
		loadNextPage(0);
	}

	protected abstract View getItemView(T responseJson, View convertView, ViewGroup parent);

	public int getPageNum() {
		return mPageNum;
	}

	protected abstract void init();

	@Override
	final public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		mAdapter = new MyAdapter();

		init();

		rootView.setVisibility(View.INVISIBLE);
		// 第一加载
		if (mAutoLoad) {
			firstLoad();
		}
	}

	protected void endInit() {

	}

	protected void AutoLoad(boolean autoLoad) {
		mAutoLoad = autoLoad;
	}

	protected void initBottom(LinearLayout bottomLayout) {

	}

	protected void initTop(LinearLayout topLayout) {

	}

	protected boolean isLoadAll() {
		return mIsLoadAll;
	}
	
	protected void carEmpty(){
		
	}

	protected void fail(String failCode){
		
	}

	protected void loadNextPage(int curPageNumber) {
		this.mPageNum = curPageNumber + 1;
		if (this.mPageNum == 1) {
			mIsLoadAll = false;
		}

		if (mIsLoadAll) {
			onLoadFinished();
			return;
		}
		Run.excuteJsonTask(mJsonTask = new JsonTask(), mPageSearchTask);
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
	}

	@Override
	public void onResume() {
		super.onResume();
	}

	// 停止刷新
	protected abstract void onLoadFinished();

	protected abstract void onPageEnable(boolean enable);

	protected abstract String requestInterfaceName();

	public void setPageNum(int mPageNum) {
		this.mPageNum = mPageNum;
	}

	/**
	 * @deprecated
	 * @param pageSize
	 */
	public void setPagetSize(int pageSize) {
	}
}
