package com.qianseit.westore.activity.passport;

import com.beiwangfx.R;
import com.qianseit.westore.bean.BaseBean;

import android.content.Context;
import android.text.Editable;
import android.text.Html;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextUtils;
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
 * 
 * @author yangtq
 * @CreatTime 2015-11-24 下午4:14:17
 * 
 */
public class ItemSettingItemView extends FrameLayout implements OnClickListener, TextWatcher, ItemSettingHandler {

	protected EditText mEditText;
	ImageView mDelImageView;
	TextView mTipTextView, mTextView;
	Context mContext;

	final char[] KEYS_ALPHA = new char[] { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E',
			'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };
	final char[] KEYS_ALPHA_NUMBER = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
			'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };

	private boolean isInited = false;

	public ItemSettingItemView(Context context) {
		super(context);
		mContext = context;
		// TODO Auto-generated constructor stub
		this.initInputView();
	}

	public ItemSettingItemView(Context context, int inputType, int maxLength, String textString, String tipString, String hintString) {
		super(context);
		mContext = context;
		this.initInputView();
		// TODO Auto-generated constructor stub
		initInputView(inputType, maxLength, textString, tipString, hintString);
	}

	public ItemSettingItemView(Context context, int inputType, int maxLength, String textString, int tipRes, int hintRes) {
		super(context);
		mContext = context;
		// TODO Auto-generated constructor stub
		this.initInputView();
		initInputView(inputType, maxLength, textString, tipRes, hintRes);
	}

	public ItemSettingItemView(Context context, int inputType, int maxLength, int textRes, int tipRes, int hintRes) {
		super(context);
		mContext = context;
		// TODO Auto-generated constructor stub
		this.initInputView();
		initInputView(inputType, maxLength, textRes, tipRes, hintRes);
	}

	public ItemSettingItemView(Context context, AttributeSet attrs) {
		super(context, attrs);
		mContext = context;
		this.initInputView();
	}

	public ItemSettingItemView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		mContext = context;
		this.initInputView();
	}

	private void initInputView(int inputType, int maxLength, String textString, int tipRes, int hintRes) {
		setInputType(inputType);
		setMaxLength(maxLength);
		setSettingValue(textString);
		setTip(tipRes);
		setHint(hintRes);
	}

	public void padding(int left, int right){
		mTextView.setPadding(left, mTextView.getPaddingTop(), mTextView.getPaddingRight(), mTextView.getPaddingBottom());
	}
	
	private void initInputView(int inputType, int maxLength, int textRes, int tipRes, int hintRes) {
		setInputType(inputType);
		setMaxLength(maxLength);
		setText(textRes);
		setTip(tipRes);
		setHint(hintRes);
	}

	private void initInputView(int inputType, int maxLength, String textString, String tipString, String hintString) {
		setInputType(inputType);
		setMaxLength(maxLength);
		setSettingValue(textString);
		setTip(tipString);
		setHint(hintString);
	}

	public void setKeyListener(NumberKeyListener l) {
		// TODO Auto-generated method stub
		mEditText.setKeyListener(l);
	}

	public void TextChanged(Editable s) {
		// TODO Auto-generated method stub
	}

	private void initInputView() {
		if (!isInited) {
			isInited = true;
			addView(inflate(getContext(), R.layout.base_item_setting_item, null));
			mEditText = (EditText) findViewById(R.id.item_setting_item_et);
			mDelImageView = (ImageView) findViewById(R.id.item_setting_item_del_iv);
			mTipTextView = (TextView) findViewById(R.id.item_setting_item_tip_tv);
			mTextView = (TextView) findViewById(R.id.item_setting_item);

			mDelImageView.setOnClickListener(this);
			mTipTextView.addTextChangedListener(this);

			mEditText.addTextChangedListener(new TextWatcher() {

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
						mDelImageView.setVisibility(View.VISIBLE);
						mDelImageView.setEnabled(true);
					} else {
						mDelImageView.setVisibility(View.INVISIBLE);
						mDelImageView.setEnabled(false);
					}
					TextChanged(s);
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

	public void setText(int textRes) {
		setSettingValue(mEditText.getResources().getString(textRes));
	}

	public void setInputAlpha() {
		mEditText.setKeyListener(new NumberKeyListener() {

			@Override
			public int getInputType() {
				// TODO Auto-generated method stub
				return InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_NORMAL;
			}

			@Override
			protected char[] getAcceptedChars() {
				// TODO Auto-generated method stub
				return KEYS_ALPHA;
			}
		});
	}

	public void setInputAlphaNumber() {
		mEditText.setKeyListener(new NumberKeyListener() {

			@Override
			public int getInputType() {
				// TODO Auto-generated method stub
				return InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_NORMAL;
			}

			@Override
			protected char[] getAcceptedChars() {
				// TODO Auto-generated method stub
				return KEYS_ALPHA_NUMBER;
			}
		});
	}

	public void setInputType(int inputType) {
		mEditText.setInputType(inputType);
	}

	public void setMaxLength(int maxLength) {
		InputFilter[] nFilters = new InputFilter[] { new InputFilter.LengthFilter(maxLength) };
		mEditText.setFilters(nFilters);
	}

	public void setTip(String tipString) {
		mTipTextView.setText(Html.fromHtml(tipString));
	}

	public void setHint(String hintString) {
		mEditText.setHint(hintString);
		mTextView.setText(hintString);
	}

	public void setTip(int tipRes) {
		mTipTextView.setText(Html.fromHtml(mContext.getString(tipRes)));
	}

	public void setHint(int hintRes) {
		mEditText.setHint(hintRes);
		mTextView.setText(hintRes);
	}

	public void showLeftTitle(boolean show) {
		mTextView.setVisibility(show ? View.VISIBLE : View.GONE);
		if (show) {
			mEditText.setHint("");
		}else{
			mEditText.setHint(mTextView.getText());
		}
	}

	public void showLeftTitle(boolean show, String hint) {
		mTextView.setVisibility(show ? View.VISIBLE : View.GONE);
		mEditText.setHint(hint);
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
		} else {
			mTipTextView.setVisibility(View.VISIBLE);
		}
	}

	public void showTopDivider(boolean show) {
		findViewById(R.id.item_setting_item_top_divider).setVisibility(show ? View.VISIBLE : View.GONE);
	}

	public void showBottomDivider(boolean show) {
		findViewById(R.id.item_setting_item_bottom_divider).setVisibility(show ? View.VISIBLE : View.GONE);
	}

	@Override
	public String getSettingValue() {
		// TODO Auto-generated method stub
		return mEditText.getText().toString();
	}

	@Override
	public void setSettingValue(String t) {
		// TODO Auto-generated method stub
		if (t == null || t.equalsIgnoreCase("null")) {
			t = "";
		}
		mEditText.setText(t.replace(BaseBean.NULL_VALUE, ""));
		mEditText.setSelection(mEditText.getText().length());
	}

	@Override
	public boolean verifySettingValue(String t) {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public void requestFoucs() {
		// TODO Auto-generated method stub
		mEditText.requestFocus();
		mEditText.setSelection(mEditText.getText().length());
	}
}