package com.qianseit.westore.ui;

import android.content.Context;
import android.os.Handler;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View.MeasureSpec;
import android.widget.HorizontalScrollView;
import android.widget.ScrollView;

/*
 * ScrollView并没有实现滚动监听，所以我们必须自行实现对ScrollView的监听，
 * 我们很自然的想到在onTouchEvent()方法中实现对滚动Y轴进行监听
 * ScrollView的滚动Y值进行监听
 */
public class MyHorizontalScrollView extends HorizontalScrollView {

	public MyHorizontalScrollView(Context context) {
		super(context, null);
	}

	public MyHorizontalScrollView(Context context, AttributeSet attrs) {
		super(context, attrs, 0);
	}

	public MyHorizontalScrollView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}

	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		// TODO Auto-generated method stub
		int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2, MeasureSpec.AT_MOST);
		super.onMeasure(widthMeasureSpec, expandSpec);
	}
}