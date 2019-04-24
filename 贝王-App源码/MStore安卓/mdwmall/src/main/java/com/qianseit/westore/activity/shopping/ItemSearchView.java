package com.qianseit.westore.activity.shopping;

import com.beiwangfx.R;;

import android.content.Context;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.view.View.OnClickListener;

public class ItemSearchView extends LinearLayout implements OnClickListener {

	private TextView mSearTextView;
	private ImageView mSeardelectImageView;
	private Button mCancelBut, mConfirmBut;
	private EditText mSearchEditText;

	boolean canInput = true;

	private boolean isInited = false;

	SearchCallback mCallback;

	public ItemSearchView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		initView();
	}

	public ItemSearchView(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub
		initView();
	}

	public ItemSearchView(Context context, AttributeSet attrs, int defStyleAttr) {
		super(context, attrs, defStyleAttr);
		// TODO Auto-generated constructor stub
		initView();
	}

	public void setSearchCallback(SearchCallback callback) {
		this.mCallback = callback;
	}

	private void initView() {
		if (!isInited) {
			isInited = true;
			addView(inflate(getContext(), R.layout.item_search_bar, null));

			mSearTextView = (TextView) findViewById(R.id.search_text);
			mSeardelectImageView = (ImageView) findViewById(R.id.search_delete_ig);
			mCancelBut = (Button) findViewById(R.id.search_cancel_but);
			mConfirmBut = (Button) findViewById(R.id.search_confirm_but);
			mSearchEditText = (EditText) findViewById(R.id.search_edit);

			mSearTextView.setOnClickListener(this);
			mCancelBut.setOnClickListener(this);
			mConfirmBut.setOnClickListener(this);
			mSeardelectImageView.setOnClickListener(this);
			findViewById(R.id.bar_search_iv).setOnClickListener(this);

			mSearchEditText.addTextChangedListener(new TextWatcher() {

				@Override
				public void onTextChanged(CharSequence s, int start, int before, int count) {

				}

				@Override
				public void beforeTextChanged(CharSequence s, int start, int count, int after) {
					// TODO Auto-generated method stub

				}

				@Override
				public void afterTextChanged(Editable s) {
					if (!TextUtils.isEmpty(s)) {
						mSeardelectImageView.setVisibility(View.VISIBLE);
						mConfirmBut.setVisibility(View.VISIBLE);
						mCancelBut.setVisibility(View.GONE);
					} else {
						mSeardelectImageView.setVisibility(View.GONE);
						mConfirmBut.setVisibility(View.GONE);
						if (mSearTextView.getVisibility() == View.GONE) {
							mCancelBut.setVisibility(View.VISIBLE);
						}
					}

				}
			});

			mSearchEditText.setOnEditorActionListener(new TextView.OnEditorActionListener() {

				@Override
				public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
					/* 判断是否是“GO”键 */
					if (actionId == EditorInfo.IME_ACTION_GO || actionId == EditorInfo.IME_ACTION_SEARCH) {
						/* 隐藏软键盘 */
						InputMethodManager imm = (InputMethodManager) v.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
						if (imm.isActive()) {
							imm.hideSoftInputFromWindow(v.getApplicationWindowToken(), 0);
						}
						// 跳转
						String searchStr = mSearchEditText.getText().toString().trim();
						if (searchStr.length() > 0 && mCallback != null) {
							mCallback.search(searchStr);
						}
						return true;
					}
					return false;
				}
			});
		}
	}

	@Override
	public void onClick(View v) {
		if (!canInput) {
			mCallback.search("");
			return;
		}

		if (v.getId() == R.id.search_text) {
			((LinearLayout) mSearchEditText.getParent()).setVisibility(View.VISIBLE);
			mSearchEditText.requestFocus();
			mSearTextView.setVisibility(View.GONE);
			mCancelBut.setVisibility(View.VISIBLE);

			InputMethodManager inputManager = (InputMethodManager) mSearchEditText.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
			inputManager.showSoftInput(mSearchEditText, InputMethodManager.SHOW_FORCED);
		} else if (v.getId() == R.id.search_confirm_but) {
			String searchStr = mSearchEditText.getText().toString().trim();
			if (searchStr.length() > 0 && mCallback != null) {
				mCallback.search(searchStr);
			}
		} else if (v.getId() == R.id.search_cancel_but) {
			((LinearLayout) mSearchEditText.getParent()).setVisibility(View.GONE);
			mSearchEditText.setText("");
			mSearTextView.setVisibility(View.VISIBLE);
			mCancelBut.setVisibility(View.GONE);
			InputMethodManager imm = (InputMethodManager) getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
			imm.hideSoftInputFromWindow(mSearchEditText.getWindowToken(), 0);
		} else if (v.getId() == R.id.search_delete_ig) {
			mSearchEditText.setText("");
		}
	}

	public void setHint(String hint){
		mSearTextView.setText(hint);
	}
	
	public void setCanInput(boolean canInput) {
		// TODO Auto-generated method stub
		this.canInput = canInput;
	}
}
