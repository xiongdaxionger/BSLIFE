package com.qianseit.westore.activity.passport;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;
import android.view.View;

/**
 * 验证码组件
 * 
 * @author yangtq
 * @CreatTime 2015-11-24 下午4:14:17
 * 
 */
public class ItemSettingImageVCodeView extends FrameLayout implements android.view.View.OnClickListener {
	TextView mTitleTextView;
	EditText mVCodeEditText;
	View mDivideView;
	View mTopDivideView;
	String mVCodeUrlString;
	ImageView mImageVCodeImageView;

	private boolean isInited = false;

	public ItemSettingImageVCodeView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
	}

	public ItemSettingImageVCodeView(Context context, boolean isSend) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
	}

	public ItemSettingImageVCodeView(Context context, String vcodeUrlString, boolean showDivide) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(vcodeUrlString, showDivide);
	}

	public ItemSettingImageVCodeView(Context context, String vcodeUrlString, boolean showDivide, boolean showTopDivide) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(vcodeUrlString, showDivide);
		this.initView(vcodeUrlString, showDivide, showTopDivide);
	}

	public ItemSettingImageVCodeView(Context context, String vcodeUrlString, boolean showDivide, boolean showTopDivide, boolean isSend) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(vcodeUrlString, showDivide);
		this.initView(vcodeUrlString, showDivide, showTopDivide);
	}

	public ItemSettingImageVCodeView(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.initView();
	}

	public ItemSettingImageVCodeView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		this.initView();
	}

	private void initView(String vcodeUrlString, boolean showDivide) {
		showDivide(showDivide);
		mVCodeUrlString = vcodeUrlString;
		reloadVCode();
	}

	private void initView(String vcodeUrlString, boolean showDivide, boolean showTopDivide) {
		showDivide(showDivide);
		showTopDivide(showTopDivide);
		mVCodeUrlString = vcodeUrlString;
		reloadVCode();
	}

	private void initView() {
		if (!isInited) {
			isInited = true;
			addView(inflate(getContext(), R.layout.base_item_setting_imagevcode, null));
			mTitleTextView = (TextView) findViewById(R.id.item_setting_vcode_title);
			mVCodeEditText = (EditText) findViewById(R.id.vcode_et);
			mDivideView = findViewById(R.id.item_setting_divide);
			mTopDivideView = findViewById(R.id.item_setting_divide_top);
			mImageVCodeImageView = (ImageView) findViewById(R.id.vcode_ib);
			findViewById(R.id.vcode_ib).setOnClickListener(this);

			mVCodeEditText.setText("");
		}
	}

	public void setTip(String textString) {
		mTitleTextView.setText(textString);
	}
	
	public String getVCode(){
		return mVCodeEditText.getText().toString();
	}

	public void showDivide(boolean showDivide) {
		mDivideView.setVisibility(showDivide ? View.VISIBLE : View.INVISIBLE);
	}

	public void showTopDivide(boolean showDivide) {
		mTopDivideView.setVisibility(showDivide ? View.VISIBLE : View.GONE);
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if (v.getId() == R.id.vcode_ib) {
			reloadVCode();
		}
	}
	
	public void reloadVCode(){
		BaseDoFragment.displayRectangleImage(mImageVCodeImageView, Run.buildString(mVCodeUrlString, "?", System.currentTimeMillis()));
	}
}