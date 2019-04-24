package com.qianseit.westore.adapter;

import java.util.ArrayList;
import java.util.List;

import android.widget.BaseAdapter;

public abstract class QianseitAdapter<T> extends BaseAdapter {

	protected List<T> mDataList = new ArrayList<T>();

	public QianseitAdapter(List<T> dataList) {
		mDataList = dataList;
	}

	@Override
	public int getCount() {
		return mDataList==null?0:mDataList.size();
	}

	@Override
	public T getItem(int position) {
		return mDataList.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	public int getIndex(T item){
		if (mDataList == null) {
			return 0;
		}
		
		int nIndex = mDataList.indexOf(item);
		return nIndex;
	}
}
