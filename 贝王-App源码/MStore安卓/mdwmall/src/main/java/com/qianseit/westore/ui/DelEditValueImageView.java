package com.qianseit.westore.ui;

import android.content.Context;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;

public class DelEditValueImageView extends ImageView {
	
	EditText mRelationEditText;
	public DelEditValueImageView(Context context) {
		super(context);
		init();
	}

	public DelEditValueImageView(Context context, AttributeSet attrs) {
		super(context, attrs);
		init();
	}

	public DelEditValueImageView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		init();
	}
	
	public void RelationEditText(EditText editText){
		mRelationEditText = editText;
		if (mRelationEditText == null) {
			return;
		}
		mRelationEditText.addTextChangedListener(new TextWatcher() {
			
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void afterTextChanged(Editable s) {
				// TODO Auto-generated method stub
				if (s.length() > 0) {
					DelEditValueImageView.this.setVisibility(View.VISIBLE);
					DelEditValueImageView.this.setEnabled(true);
				}else{
					DelEditValueImageView.this.setVisibility(View.INVISIBLE);
					DelEditValueImageView.this.setEnabled(false);
				}
			}
		});
	}
	
	void init(){
		this.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (mRelationEditText == null) {
					return;
				}
				
				mRelationEditText.setText("");
				mRelationEditText.requestFocus();
			}
		});
	}
}
