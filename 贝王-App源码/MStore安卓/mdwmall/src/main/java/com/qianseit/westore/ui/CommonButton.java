package com.qianseit.westore.ui;

import android.content.Context;
import android.graphics.Typeface;
import android.util.AttributeSet;
import android.view.ViewDebug.CapturedViewProperty;
import android.widget.Button;

import com.qianseit.westore.AgentApplication;

public class CommonButton extends Button {

	public CommonButton(Context context) {
		super(context);
		this.setTypeface(AgentApplication.getApp(getContext()).getTypeface());
//		Typeface typeFace = Typeface.createFromAsset(getContext().getAssets(),
//				"fonts/heandertext.otf");
//		setTypeface(typeFace);
	}

	public CommonButton(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.setTypeface(AgentApplication.getApp(getContext()).getTypeface());
//		Typeface typeFace = Typeface.createFromAsset(getContext().getAssets(),
//				"fonts/heandertext.otf");
//		setTypeface(typeFace);
	}

	public CommonButton(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		this.setTypeface(AgentApplication.getApp(getContext()).getTypeface());
//		Typeface typeFace = Typeface.createFromAsset(getContext().getAssets(),
//				"fonts/heandertext.otf");
//		setTypeface(typeFace);
	}

	@Override
	@CapturedViewProperty
	public CharSequence getText() {
		
		return super.getText();
	}
}
