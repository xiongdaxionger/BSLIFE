package com.qianseit.westore.activity.passport;

import com.beiwangfx.R;

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
public class ItemDivideView extends FrameLayout{

	View mDivideView;

	private boolean isInited = false;

	public ItemDivideView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initView();
	}

	public ItemDivideView(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.initView();
	}

	public ItemDivideView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		this.initView();
	}

	private void initView() {
		if (!isInited) {
			isInited = true;
			addView(inflate(getContext(), R.layout.base_item_divide, null));
			mDivideView = findViewById(R.id.item_divide);
		}
	}
}