package com.qianseit.westore.activity.passport;

import com.beiwangfx.R;
import com.qianseit.westore.Run;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.FrameLayout;
import android.view.View;

/**
 * 输入view，自带删除按钮，输入项提示信息
 * 
 * @author yangtq
 * @CreatTime 2015-11-24 下午4:14:17
 * 
 */
public class ItemSpaceView extends FrameLayout{

	View mDivideView;

	private boolean isInited = false;

	public ItemSpaceView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
	}

	public ItemSpaceView(Context context, int spaceHeight) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
		setSpaceHeight(spaceHeight);
	}

	public ItemSpaceView(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.initView();
	}

	public ItemSpaceView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		this.initView();
	}

	private void initView() {
		if (!isInited) {
			isInited = true;
			addView(inflate(getContext(), R.layout.base_item_space, null));
			mDivideView = findViewById(R.id.item_divide);
		}
	}
	
	void setSpaceHeight(int spaceHeight){
		android.widget.RelativeLayout.LayoutParams nLayoutParams = (android.widget.RelativeLayout.LayoutParams) mDivideView.getLayoutParams();
		nLayoutParams.height = Run.dip2px(getContext(), spaceHeight);
		mDivideView.setLayoutParams(nLayoutParams);
	}
}
