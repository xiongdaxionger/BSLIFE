package com.qianseit.westore.base;

import android.content.ContentValues;
import android.view.View;

import org.json.JSONObject;

import java.util.List;

public abstract class BaseLocalListFragment<T> extends BaseListNopageFragment<T> {

	@Override
	final protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "";
	}
	
	@Override
	final protected List<T> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	final protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		PageEnable(false);
	}
	
	abstract protected List<T> buildLocalItems();

	@Override
	protected void loadNextPage(int pageNumber) {
		// TODO Auto-generated method stub
		mResultLists.clear();
		List<T> data = buildLocalItems();
		if (data != null) {
			mResultLists.addAll(data);
		}
		if (!rootView.isShown()) {
			rootView.setVisibility(View.VISIBLE);
		}
		mAdapter.notifyDataSetChanged();
		onLoadFinished();
	}
}
