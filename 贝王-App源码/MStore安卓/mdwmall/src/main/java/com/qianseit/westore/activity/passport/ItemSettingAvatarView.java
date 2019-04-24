package com.qianseit.westore.activity.passport;

import com.beiwangfx.R;
import com.qianseit.westore.util.loader.ImageLoaderUtils;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;
import android.view.View;

/**
 * 输入view，自带删除按钮，输入项提示信息
 * 
 * @author yangtq
 * @CreatTime 2015-11-24 下午4:14:17
 * 
 */
public class ItemSettingAvatarView extends FrameLayout implements ItemSettingHandler{

	ImageView mRightImageView;
	ImageView mAvatarImageView;
	TextView mTitleTextView;
	View mDivideView;
	View mTopDivideView;

	private boolean isInited = false;

	public ItemSettingAvatarView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
	}

	public ItemSettingAvatarView(Context context, String titleString, String uriString, boolean showRight,
			boolean showDivide) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(titleString, uriString, showRight, showDivide);
	}

	public ItemSettingAvatarView(Context context, String titleString, String uriString, boolean showRight,
			boolean showDivide,boolean showTopDivide) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(titleString, uriString, showRight, showDivide,showTopDivide);
	}

	public ItemSettingAvatarView(Context context, String titleString, String uriString) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(titleString, uriString, true, true);
	}

	public ItemSettingAvatarView(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.initView();
	}

	public ItemSettingAvatarView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		this.initView();
	}

	private void initView(String titleString, String uriString, boolean showRight, boolean showDivide) {
		setTitle(titleString);
		setAvatar(uriString);
		showRight(showRight);
		showDivide(showDivide);
	}

	private void initView(String titleString, String uriString, boolean showRight, boolean showDivide, boolean showTopDivide) {
		setTitle(titleString);
		setAvatar(uriString);
		showRight(showRight);
		showDivide(showDivide);
		showTopDivide(showTopDivide);
	}

	private void initView() {
		if (!isInited) {
			isInited = true;
			addView(inflate(getContext(), R.layout.base_item_setting_avatar, null));
			mAvatarImageView = (ImageView) findViewById(R.id.item_setting_avatar);
			mRightImageView = (ImageView) findViewById(R.id.item_setting_right);
			mTitleTextView = (TextView) findViewById(R.id.item_setting_title);
			mDivideView = findViewById(R.id.item_setting_divide);
			mTopDivideView = findViewById(R.id.item_setting_divide_top);

			mTitleTextView.setText("");
		}
	}

	public void setTitle(String textString) {
		mTitleTextView.setText(textString);
	}

	public void setAvatar(String uriString) {
		com.nostra13.universalimageloader.core.ImageLoader.getInstance().displayImage(uriString,
				mAvatarImageView, ImageLoaderUtils.getCircleDisplayImageOptions());
	}

	public void showRight(boolean showRight) {
		mRightImageView.setVisibility(showRight ? View.VISIBLE : View.GONE);
	}

	public void showDivide(boolean showDivide) {
		mDivideView.setVisibility(showDivide ? View.VISIBLE : View.INVISIBLE);
	}

	public void showTopDivide(boolean showDivide) {
		mTopDivideView.setVisibility(showDivide ? View.VISIBLE : View.GONE);
	}

	@Override
	public String getSettingValue() {
		// TODO Auto-generated method stub
		return null;
	}

	public void padding(int left, int right){
		mRightImageView.setPadding(mRightImageView.getPaddingLeft(), mRightImageView.getPaddingTop(), right, mRightImageView.getPaddingBottom());
		mTitleTextView.setPadding(left, mTitleTextView.getPaddingTop(), mTitleTextView.getPaddingRight(), mTitleTextView.getPaddingBottom());
	}
	
	@Override
	public void setSettingValue(String t) {
		// TODO Auto-generated method stub
		setAvatar(t);
	}

	@Override
	public boolean verifySettingValue(String t) {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public void requestFoucs() {
		// TODO Auto-generated method stub
		
	}
}