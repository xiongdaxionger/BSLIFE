package com.qianseit.westore.ui;

import android.content.Context;
import android.util.AttributeSet;
import android.webkit.WebView;

public class MyWebView extends WebView {

	public MyWebView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
	}

	public MyWebView(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub
	}

	public MyWebView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		// TODO Auto-generated constructor stub
	}

	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		// TODO Auto-generated method stub
		invalidate();
		super.onMeasure(widthMeasureSpec, heightMeasureSpec);
	}
}
