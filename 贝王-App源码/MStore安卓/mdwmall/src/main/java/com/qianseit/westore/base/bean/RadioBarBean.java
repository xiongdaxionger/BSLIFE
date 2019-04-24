package com.qianseit.westore.base.bean;

import android.content.ContentValues;
import android.graphics.drawable.Drawable;

import com.qianseit.westore.base.BaseDoFragment;

import java.util.List;

public class RadioBarBean {

	public int mId;
	public String mTitleString;
	public boolean mSelected;

	public ContentValues mFilternContentValuess;
	public int mCurFilterItemIndex = 0;
	public BaseDoFragment mFragment;
	public List<Drawable> mFilterDrawable;
	public Object mRawValue;

	public RadioBarBean(String titleString, int id, BaseDoFragment fragment) {
		mTitleString = titleString;
		mId = id;
		mSelected = false;
		mFragment = fragment;
	}

	public RadioBarBean(String titleString, int id, Object rawValue) {
		mTitleString = titleString;
		mId = id;
		mSelected = false;
		mFragment = null;
		mRawValue = rawValue;
	}

	public RadioBarBean(String titleString, int id, BaseDoFragment fragment, ContentValues basicnContentValuess) {
		mTitleString = titleString;
		mId = id;
		mSelected = false;
		mFragment = fragment;
		mFilternContentValuess = basicnContentValuess;
	}

	public RadioBarBean(String titleString, int id, BaseDoFragment fragment, ContentValues basicnContentValuess,List<Drawable> drawableList) {
		mTitleString = titleString;
		mId = id;
		mSelected = false;
		mFragment = fragment;
		mFilternContentValuess = basicnContentValuess;
		mFilterDrawable=drawableList;
	}
}
