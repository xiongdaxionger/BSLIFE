package com.qianseit.westore.activity.passport;

import android.content.Context;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.httpinterface.passport.RegistrMemberInterface.Gender;

/**
 * 输入view，自带删除按钮，输入项提示信息
 * 
 * @author yangtq
 * @CreatTime 2015-11-24 下午4:14:17
 * 
 */
public class ItemSettingGenderView extends FrameLayout implements ItemSettingHandler {

	ImageView mRightImageView;
	RadioGroup mGenderGroup;
	TextView mTitleTextView;
	View mDivideView;
	View mTopDivideView;
	String mGender = Gender.BOY;

	private boolean isInited = false;

	public ItemSettingGenderView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
	}

	public ItemSettingGenderView(Context context, String titleString, String gender, boolean showRight, boolean showDivide) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(titleString, gender, showRight, showDivide);
	}

	public ItemSettingGenderView(Context context, String titleString, String gender, boolean showRight, boolean showDivide, boolean showTopDivide) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(titleString, gender, showRight, showDivide, showTopDivide);
	}

	public ItemSettingGenderView(Context context, String titleString, String gender) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(titleString, gender, true, true);
	}

	public ItemSettingGenderView(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.initView();
	}

	public ItemSettingGenderView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		this.initView();
	}

	private void initView(String titleString, String gender, boolean showRight, boolean showDivide) {
		setTitle(titleString);
		setSettingValue(gender);
		showRight(showRight);
		showDivide(showDivide);
	}

	private void initView(String titleString, String gender, boolean showRight, boolean showDivide, boolean showTopDivide) {
		setTitle(titleString);
		setSettingValue(gender);
		showRight(showRight);
		showDivide(showDivide);
		showTopDivide(showDivide);
	}

	private void initView() {
		if (!isInited) {
			isInited = true;
			addView(inflate(getContext(), R.layout.base_item_setting_gender, null));
			mGenderGroup = (RadioGroup) findViewById(R.id.item_setting_content);
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
		return mGenderGroup.getCheckedRadioButtonId() == R.id.item_setting_boy ? String.valueOf(Gender.BOY) : String.valueOf(Gender.GIRL);
	}

	public void padding(int left, int right){
		mRightImageView.setPadding(mRightImageView.getPaddingLeft(), mRightImageView.getPaddingTop(), right, mRightImageView.getPaddingBottom());
		mTitleTextView.setPadding(left, mTitleTextView.getPaddingTop(), mTitleTextView.getPaddingRight(), mTitleTextView.getPaddingBottom());
	}
	
	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.qianseit.westore.activity.passport.ItemSettingHandler#setSettingValue
	 * (java.lang.String)
	 * 
	 * @param t 1:男|0：女
	 */
	@Override
	public void setSettingValue(String t) {
		// TODO Auto-generated method stub
		String nGender = Gender.BOY;
		if (!TextUtils.isEmpty(t)) {
			nGender = t;
		}
		mGenderGroup.check(nGender.equals(Gender.BOY) ? R.id.item_setting_boy : R.id.item_setting_girl);
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