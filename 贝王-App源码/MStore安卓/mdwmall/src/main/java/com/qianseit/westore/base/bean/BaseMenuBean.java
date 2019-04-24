package com.qianseit.westore.base.bean;

public class BaseMenuBean {
	boolean mHasDetail = false;
	boolean mHasTopView= false;
	boolean mShowRight= true;
	int mId;
	int mIconResId;
	String mIconUrl;
	int mSubIconResId;
	String mTitle;
	String mContent;
	int mTitleResID;
	int mContentResID;
	public BaseMenuBean(int id, int iconResId, int titleResID){
		init(id, iconResId, 0, titleResID, 0, "", "");
	}
	public BaseMenuBean(int id, int iconResId, int subIconResId, int titleResID){
		init(id, iconResId, subIconResId, titleResID, 0, "", "");
	}
	public BaseMenuBean(int id, int iconResId, int subIconResId, int titleResID, int contentResID){
		init(id, iconResId, subIconResId, titleResID, contentResID, "", "");
	}
	public BaseMenuBean(int id, int iconResId, int subIconResId, int titleResID, String content){
		init(id, iconResId, subIconResId, titleResID, 0, "", content);
	}
	public BaseMenuBean(int id, int iconResId, int titleResID, String content){
		init(id, iconResId, 0, titleResID, 0, "", content);
	}
	public BaseMenuBean(int id, int iconResId, int subIconResId, String title, String content){
		init(id, iconResId, subIconResId, 0, 0, title, content);
	}
	public BaseMenuBean(int id, int iconResId, String title){
		init(id, iconResId, 0, 0, 0, title, "");
	}
	public BaseMenuBean(int id, String iconUrl, String title){
		init(id, iconUrl, 0, 0, 0, 0, title, "");
	}
	public String getContent() {
		return mContent;
	}
	public int getContentResID() {
		return mContentResID;
	}

	public int getIconResId() {
		return mIconResId;
	}

	public String getIconUrl() {
		return mIconUrl;
	}

	public int getId() {
		return mId;
	}

	public int getSubIconResId() {
		return mSubIconResId;
	}

	public String getTitle() {
		return mTitle;
	}

	public int getTitleResID() {
		return mTitleResID;
	}

	public boolean hasDetail() {
		return mHasDetail;
	}
	public boolean hasasTopView(){
		return mHasTopView;
	}
	public void setHasDetail(boolean hasDetail) {
		this.mHasDetail = hasDetail;
	}
	public void setHasTopView(boolean hasTopView){
		this.mHasTopView=hasTopView;
	}
	public void setShowRight(boolean showRight) {
		this.mShowRight = showRight;
	}
	public boolean showRight(){
		return mShowRight;
	}
	void init(int id, int iconResId, int subIconResId, int titleResID, int contentResID, String title, String content){
		init(id, "", iconResId, subIconResId, titleResID, contentResID, title, content);
	}

	void init(int id, String iconUrl, int iconResId, int subIconResId, int titleResID, int contentResID, String title, String content){
		mId = id;
		mIconResId = iconResId;
		mIconUrl = iconUrl;
		mSubIconResId = subIconResId;
		mTitleResID = titleResID;
		mSubIconResId = 0;
		mTitle = title;
		mContent = content;
	}
}
