package com.qianseit.westore.ui;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.TextView;

public class AdvTextView extends TextView{

	public AdvTextView(Context context) {
		this(context, null, 0);
	}
	public AdvTextView(Context context, AttributeSet attrs) {
		this(context, attrs, 0);
	}
	public AdvTextView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}

	public boolean isFocused() {
		// TODO Auto-generated method stub
		return true;
	}
    
}
