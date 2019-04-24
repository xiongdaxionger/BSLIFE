package com.qianseit.westore.activity.passport;

import com.beiwangfx.R;
import com.qianseit.westore.bean.BaseBean;

import android.content.Context;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextWatcher;
import android.text.method.NumberKeyListener;
import android.util.AttributeSet;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;
import android.view.View;
import android.view.View.OnClickListener;

/**
 * 输入view，自带删除按钮，输入项提示信息
 * @author yangtq
 * @CreatTime 2015-11-24 下午4:14:17
 *
 */
public class ItemSettingItemMultiView extends FrameLayout implements OnClickListener, TextWatcher {
	
	EditText mEditText;
	ImageView mDelImageView;
	TextView mTipTextView;
	TextView mInputLenTextView;
	int mMaxLength = 10;

	private boolean isInited = false;
	public ItemSettingItemMultiView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initInputView();
	}

	public ItemSettingItemMultiView(Context context, int inputType, int maxLength, String textString, String tipString, String hintString) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initInputView();
		initInputView(inputType, maxLength, textString, tipString, hintString);
	}

	public ItemSettingItemMultiView(Context context, int inputType, int maxLength, String textString, int tipRes, int hintRes) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initInputView();
		initInputView(inputType, maxLength, textString, tipRes, hintRes);
	}

	public ItemSettingItemMultiView(Context context, int inputType, int maxLength, int textRes, int tipRes, int hintRes) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initInputView();
		initInputView(inputType, maxLength, textRes, tipRes, hintRes);
	}
	
	public ItemSettingItemMultiView(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.initInputView();
	}

	public ItemSettingItemMultiView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		this.initInputView();
	}

	private void initInputView(int inputType, int maxLength, String textString, int tipRes, int hintRes){
		setInputType(inputType);
		setMaxLength(maxLength);
		setText(textString);
		setTip(tipRes);
		setHint(hintRes);
	}

	private void initInputView(int inputType, int maxLength, int textRes, int tipRes, int hintRes){
		setInputType(inputType);
		setMaxLength(maxLength);
		setText(textRes);
		setTip(tipRes);
		setHint(hintRes);
	}

	private void initInputView(int inputType, int maxLength, String textString, String tipString, String hintString){
		setInputType(inputType);
		setMaxLength(maxLength);
		setText(textString);
		setTip(tipString);
		setHint(hintString);
	}
	
	public void setKeyListener(NumberKeyListener l) {
		// TODO Auto-generated method stub
		mEditText.setKeyListener(l);
	}
	
	private void initInputView() {
		if (!isInited) {
			isInited = true;
			addView(inflate(getContext(), R.layout.base_item_setting_item_multi, null));
			mEditText = (EditText) findViewById(R.id.item_setting_item_et);
			mDelImageView = (ImageView) findViewById(R.id.item_setting_item_del_iv);
			mTipTextView = (TextView) findViewById(R.id.item_setting_item_tip_tv);
			mInputLenTextView = (TextView) findViewById(R.id.item_setting_item_input_len);
			
			mDelImageView.setOnClickListener(this);
			mTipTextView.addTextChangedListener(this);
			mEditText.addTextChangedListener(new TextWatcher() {
				
				@Override
				public void onTextChanged(CharSequence s, int start, int before, int count) {
					
				}
				
				@Override
				public void beforeTextChanged(CharSequence s, int start, int count, int after) {
					// TODO Auto-generated method stub
					
				}
				
				@Override
				public void afterTextChanged(Editable s) {
					// TODO Auto-generated method stub
					mInputLenTextView.setText(String.valueOf(s.length()));
					if (s.length() > 0) {
						mDelImageView.setEnabled(true);
						mInputLenTextView.setVisibility(View.VISIBLE);
					}else{
						mDelImageView.setEnabled(false);
						mInputLenTextView.setVisibility(View.INVISIBLE);
					}
				}
			});

			mTipTextView.setText("");
			mEditText.setText("");
		}
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if (v.getId() == R.id.item_setting_item_del_iv) {
			mEditText.setText("");
			mEditText.requestFocus();
		}
	}
	
	public void setText(String textString){
		mEditText.setText(textString.replace(BaseBean.NULL_VALUE, ""));
	}

	public void setText(int textRes){
		mEditText.setText(textRes);
	}
	
	public String getText(){
		return mEditText.getText().toString();
	}
	
	public void setInputType(int inputType){
		mEditText.setInputType(inputType);

		mEditText.setSingleLine(false);	
		mEditText.setHorizontallyScrolling(false);
	}
	
	public void setMaxLength(int maxLength){
		mMaxLength = maxLength;
		InputFilter[] nFilters = new InputFilter[]{new InputFilter.LengthFilter(maxLength)};
		mEditText.setFilters(nFilters);
	}
	
	public void setTip(String tipString){
		mTipTextView.setText(tipString);
	}

	public void setHint(String hintString){
		mEditText.setHint(hintString);
	}

	public void setTip(int tipRes){
		mTipTextView.setText(tipRes);
	}

	public void setHint(int hintRes){
		mEditText.setHint(hintRes);
	}
	
	@Override
	public void beforeTextChanged(CharSequence s, int start, int count, int after) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onTextChanged(CharSequence s, int start, int before, int count) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void afterTextChanged(Editable s) {
		// TODO Auto-generated method stub
		if (s.length() <= 0) {
			mTipTextView.setVisibility(View.GONE);
		}else{
			mTipTextView.setVisibility(View.VISIBLE);
		}
	}
}