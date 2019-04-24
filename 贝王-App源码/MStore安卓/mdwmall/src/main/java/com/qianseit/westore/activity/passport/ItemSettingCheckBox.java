package com.qianseit.westore.activity.passport;

import com.beiwangfx.R;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.CheckBox;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.view.View;

/**
 * 输入view，自带删除按钮，输入项提示信息
 * 
 * @author yangtq
 * @CreatTime 2015-11-24 下午4:14:17
 * 
 */
public class ItemSettingCheckBox extends FrameLayout{

	CheckBox mCheckBox;
	TextView mContentTextView;
	TextView mTitleTextView;
	View mDivideView;

	private boolean isInited = false;

	public ItemSettingCheckBox(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
	}

	public ItemSettingCheckBox(Context context, String titleString, String contentString, boolean checkState,
			boolean showDivide) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(titleString, contentString, checkState, showDivide);
	}

	public ItemSettingCheckBox(Context context, String titleString, String contentString) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(titleString, contentString, true, true);
	}

	public ItemSettingCheckBox(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.initView();
	}

	public ItemSettingCheckBox(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		this.initView();
	}

	private void initView(String titleString, String contentString, boolean checkState, boolean showDivide) {
		setTitle(titleString);
		setContent(contentString);
		setCheckState(checkState);
		showDivide(showDivide);
	}

	private void initView() {
		if (!isInited) {
			isInited = true;
			addView(inflate(getContext(), R.layout.base_item_setting_checkbox, null));
			mContentTextView = (TextView) findViewById(R.id.item_setting_content);
			mCheckBox = (CheckBox) findViewById(R.id.item_setting_checkbox);
			mTitleTextView = (TextView) findViewById(R.id.item_setting_title);
			mDivideView = findViewById(R.id.item_setting_divide);

			mContentTextView.setText("");
			mTitleTextView.setText("");
		}
	}

	public void setTitle(String textString) {
		mTitleTextView.setText(textString);
	}

	public void padding(int left, int right){
		mCheckBox.setPadding(mCheckBox.getPaddingLeft(), mCheckBox.getPaddingTop(), right, mCheckBox.getPaddingBottom());
		mTitleTextView.setPadding(left, mTitleTextView.getPaddingTop(), mTitleTextView.getPaddingRight(), mTitleTextView.getPaddingBottom());
	}
	
	public void setContent(String contentString) {
		mContentTextView.setText(contentString);
	}

	public void setCheckState(boolean checkState) {
		mCheckBox.setChecked(checkState);
	}
	
	public void setOnCheckedChangeListener(OnCheckedChangeListener l){
		mCheckBox.setOnCheckedChangeListener(l);
	}

	public void showDivide(boolean showDivide) {
		mDivideView.setVisibility(showDivide ? View.VISIBLE : View.INVISIBLE);
	}
}