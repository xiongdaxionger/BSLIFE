package com.qianseit.westore.ui;

import android.content.Context;
import android.graphics.Typeface;
import android.util.AttributeSet;
import android.widget.EditText;

import com.qianseit.westore.AgentApplication;

public class CommonEditText extends EditText {

	public CommonEditText(Context context) {
		super(context);
		setTypeface(AgentApplication.getApp(getContext()).getTypeface());
//		Typeface typeFace = Typeface.createFromAsset(getContext().getAssets(),
//				"fonts/heandertext.otf");
//		setTypeface(typeFace);
	}

	public CommonEditText(Context context, AttributeSet attrs) {
		super(context, attrs);
		setTypeface(AgentApplication.getApp(getContext()).getTypeface());
//		Typeface typeFace = Typeface.createFromAsset(getContext().getAssets(),
//				"fonts/heandertext.otf");
//		setTypeface(typeFace);
	}

	public CommonEditText(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		setTypeface(AgentApplication.getApp(getContext()).getTypeface());
//		Typeface typeFace = Typeface.createFromAsset(getContext().getAssets(),
//				"fonts/heandertext.otf");
//		setTypeface(typeFace);
	}

}
