package com.qianseit.westore.activity.passport;

import com.beiwangfx.R;

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
public class ItemSettingTextView extends FrameLayout implements ItemSettingHandler{

	ImageView mRightImageView;
	TextView mContentTextView;
	TextView mTitleTextView;
	View mDivideView;
	View mTopDivideView;

	private boolean isInited = false;

	public ItemSettingTextView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
	}

	public ItemSettingTextView(Context context, String titleString, String contentString, boolean showRight, boolean showDivide) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(titleString, contentString, showRight, showDivide);
	}

	public ItemSettingTextView(Context context, String titleString, String contentString, boolean showRight, boolean showDivide, boolean showTopDivide) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(titleString, contentString, showRight, showDivide, showTopDivide);
	}

	public ItemSettingTextView(Context context, String titleString, String contentString) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(titleString, contentString, true, true);
	}

	public ItemSettingTextView(Context context, String titleString, String contentString, int contentTextColor) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(titleString, contentString, true, true);
		setContentTextColor(contentTextColor);
	}

	public ItemSettingTextView(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.initView();
	}

	public ItemSettingTextView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		this.initView();
	}

	private void initView(String titleString, String contentString, boolean showRight, boolean showDivide) {
		setTitle(titleString);
		setSettingValue(contentString);
		showRight(showRight);
		showDivide(showDivide);
	}

	private void initView(String titleString, String contentString, boolean showRight, boolean showDivide, boolean showTopDivide) {
		setTitle(titleString);
		setSettingValue(contentString);
		showRight(showRight);
		showDivide(showDivide);
		showTopDivide(showDivide);
	}

	private void initView() {
		if (!isInited) {
			isInited = true;
			addView(inflate(getContext(), R.layout.base_item_setting_text, null));
			mContentTextView = (TextView) findViewById(R.id.item_setting_content);
			mRightImageView = (ImageView) findViewById(R.id.item_setting_right);
			mTitleTextView = (TextView) findViewById(R.id.item_setting_title);
			mDivideView = findViewById(R.id.item_setting_divide);
			mTopDivideView = findViewById(R.id.item_setting_divide_top);

			mContentTextView.setText("");
			mTitleTextView.setText("");
		}
	}

	public void setTitle(String textString) {
		mTitleTextView.setText(textString);
	}

	public String getTitle(){
		return  mTitleTextView.getText().toString();
	}

	public void setContentTextColor(int color) {
		mContentTextView.setTextColor(color);
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

	public void padding(int left, int right){
		mRightImageView.setPadding(mRightImageView.getPaddingLeft(), mRightImageView.getPaddingTop(), right, mRightImageView.getPaddingBottom());
		mTitleTextView.setPadding(left, mTitleTextView.getPaddingTop(), mTitleTextView.getPaddingRight(), mTitleTextView.getPaddingBottom());
	}
	
	@Override
	public String getSettingValue() {
		// TODO Auto-generated method stub
		return mContentTextView.getText().toString().replace("选填", "");
	}

	@Override
	public void setSettingValue(String t) {
		// TODO Auto-generated method stub
		if (t.equalsIgnoreCase("null")) {
			t = "";
		}
		mContentTextView.setText(t);
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