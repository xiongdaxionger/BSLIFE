package com.qianseit.westore.base.adpter;

import java.util.List;

import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;

import com.qianseit.westore.adapter.QianseitAdapter;

public abstract class BaseSelectAdapter<T> extends QianseitAdapter<T> {
	private int mSelectedIndex = 0;
	private boolean mIsOnSelectedChanged = false;

	public BaseSelectAdapter(List<T> dataList) {
		super(dataList);
		// TODO Auto-generated constructor stub
		
		mSelectedIndex = defaultSelectedIndex();
	}

	@Override
	final public View getView(int position, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		View nView = getSelectView(position, convertView, parent, position == mSelectedIndex);
		if (position == mSelectedIndex && !mIsOnSelectedChanged) {
			mIsOnSelectedChanged = true;
			onSelectedChanged(position);
		}
		nView.setTag(position);
		nView.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				int nPosition = (Integer) v.getTag();
				if (nPosition == mSelectedIndex) {
					onItemClick(nPosition, getItem(nPosition), v);
				}else{
					onItemChangeChick(nPosition, mSelectedIndex, v);
				}
			}
		});
		return nView;
	}

	/**
	 * @param position
	 * 选中项改变才会触发
	 */
	public void onItemChangeChick(int position, int oldPosition, View itemView){
		mSelectedIndex = position;
		mIsOnSelectedChanged = false;
		notifyDataSetChanged();
	}
	
	public int defaultSelectedIndex(){
		return 0;
	}
	
	public int getSelectedIndex() {
		return mSelectedIndex;
	}

	public T getSelectedItem() {
		return getItem(mSelectedIndex);
	}

	public void setSelected(int index) {
		if (index >= 0 && index < getCount() && mSelectedIndex != index) {
			mSelectedIndex = index;
			mIsOnSelectedChanged = false;
			notifyDataSetChanged();
		}
	}

	public void setSelected(T item) {
		setSelected(getIndex(item));
	}

	public abstract View getSelectView(int position, View convertView, ViewGroup parent, boolean isSelected);
	
	/**
	 * 选中项改变
	 * @param selectedIndex
	 */
	public void onSelectedChanged(int selectedIndex){
		
	}
	
	/**
	 * 选中项没有改变且发生点击事件时触发
	 * @param position
	 * @param item
	 * @param itemView
	 */
	public void onItemClick(int position, T item, View itemView){
		
	}
}
