package com.qianseit.westore.activity.passport;

import com.beiwangfx.R;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.view.View;

/**
 * 提示信息组件，包含分割线
 * 
 * @author yangtq
 * @CreatTime 2015-11-24 下午4:14:17
 * 
 */
public class ItemSettingTipView extends FrameLayout {

	TextView mTipTextView;
	View mDivideView;

	private boolean isInited = false;

	public ItemSettingTipView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
	}

	public ItemSettingTipView(Context context, String tipString, boolean showDivide) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(tipString, showDivide);
	}

	public ItemSettingTipView(Context context, String tipString) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		this.initView(tipString, true);
	}

	public ItemSettingTipView(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.initView();
	}

	public ItemSettingTipView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		this.initView();
	}

	private void initView(String tipString, boolean showDivide) {
		showDivide(showDivide);
		setTip(tipString);
	}

	private void initView() {
		if (!isInited) {
			isInited = true;
			addView(inflate(getContext(), R.layout.base_item_setting_tip, null));
			mTipTextView = (TextView) findViewById(R.id.item_setting_tip);
			mDivideView = findViewById(R.id.item_setting_divide);
			mTipTextView.setText("");
		}
	}

	public void setTip(String textString) {
		mTipTextView.setText(textString);
	}
	
	public void setTextGravity(int textAlignment){
		mTipTextView.setGravity(textAlignment);
	}

	public void showDivide(boolean showDivide) {
		mDivideView.setVisibility(showDivide ? View.VISIBLE : View.INVISIBLE);
	}
}