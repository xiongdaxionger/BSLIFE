package com.qianseit.westore.base.adpter;

public class RadioBarBean {

	public long mId;
	public String mTitleString;

	public int mCurFilterItemIndex = 0;
	public Object mRawValue;

	public RadioBarBean(String titleString, long id) {
		mTitleString = titleString;
		mId = id;
	}

	public RadioBarBean(String titleString, long id, Object rawValue) {
		mTitleString = titleString;
		mId = id;
		mRawValue = rawValue;
	}
}
