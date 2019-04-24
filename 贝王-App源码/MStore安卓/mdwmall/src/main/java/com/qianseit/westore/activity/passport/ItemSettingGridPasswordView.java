package com.qianseit.westore.activity.passport;

import com.beiwangfx.R;
import com.qianseit.westore.ui.PasswordInputView2;

import android.content.Context;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.view.View;

/**
 * 输入view，自带删除按钮，输入项提示信息
 * 
 * @author yangtq
 * @CreatTime 2015-11-24 下午4:14:17
 * 
 */
public abstract class ItemSettingGridPasswordView extends FrameLayout implements TextWatcher {

	PasswordInputView2 mGridPasswordView;
	TextView mTitleTextView;

	private boolean isInited = false;

	public ItemSettingGridPasswordView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initInputView();
	}

	public ItemSettingGridPasswordView(Context context, String titleString) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initInputView();
		initInputView(titleString);
	}

	public ItemSettingGridPasswordView(Context context, int titleRes) {
		super(context);
		// TODO Auto-generated constructor stub
		this.initInputView();
		initInputView(titleRes);
	}

	public ItemSettingGridPasswordView(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.initInputView();
	}

	public ItemSettingGridPasswordView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		this.initInputView();
	}

	private void initInputView(int titleRes) {
		setTitle(titleRes);
	}

	private void initInputView(String titleString) {
		setTitle(titleString);
	}

	private void initInputView() {
		if (!isInited) {
			isInited = true;
			addView(inflate(getContext(), R.layout.base_item_setting_gridpassword, null));
			mGridPasswordView = (PasswordInputView2) findViewById(R.id.item_setting_gridPassword);
			mTitleTextView = (TextView) findViewById(R.id.item_setting_gridpasswode_title);

			mTitleTextView.addTextChangedListener(this);

			mTitleTextView.setText("");
			mGridPasswordView.addTextChangedListener(new TextWatcher() {
				
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
					if ((!TextUtils.isEmpty(s.toString())) && s.length() >= 6) {
						onResult(s.toString());
					}
				}
			});
//			mGridPasswordView.setOnPasswordChangedListener(new OnPasswordChangedListener() {
//
//				@Override
//				public void onMaxLength(String psw) {
//				}
//
//				@Override
//				public void onChanged(String psw) {
//					if ((!TextUtils.isEmpty(psw)) && psw.length() >= 6) {
//						onResult(psw);
//					}
//				}
//			});
		}
	}

	public void setTitle(String titleString) {
		mTitleTextView.setText(titleString);
	}

	public void setTitle(int titleRes) {
		mTitleTextView.setText(titleRes);
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
			mTitleTextView.setVisibility(View.GONE);
		} else {
			mTitleTextView.setVisibility(View.VISIBLE);
		}
	}

	public abstract void onResult(String gridPassword);
}