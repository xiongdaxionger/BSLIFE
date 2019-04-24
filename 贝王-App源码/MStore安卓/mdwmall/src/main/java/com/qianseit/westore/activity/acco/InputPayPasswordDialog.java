package com.qianseit.westore.activity.acco;

import android.app.ActionBar.LayoutParams;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.WindowManager;
import android.widget.TextView;

import com.amap.api.maps.TextureMapFragment;
import com.github.pay.GridPasswordView;
import com.github.pay.GridPasswordView.OnPasswordChangedListener;
import com.qianseit.westore.Run;
import com.beiwangfx.R;;

public class InputPayPasswordDialog extends Dialog {

	private static InputPayPasswordDialog mDialog;

	private Context mContext;
	private GridPasswordView mGridPasswordView;
	private OnPayPasswordListener mListener;
	TextView mHintTextView;
	String mHint;

	public InputPayPasswordDialog(Context context, OnPayPasswordListener listener, String hint) {
		super(context, R.style.CustomDialog);
		this.mContext = context;
		this.mListener = listener;
		mHint = hint;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_VISIBLE | WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
		this.setContentView(R.layout.item_input_pay_password_dialog);
		setScreenScale(4,0);
		mGridPasswordView = (GridPasswordView) findViewById(R.id.gridPasswordView1);
		mGridPasswordView.setOnPasswordChangedListener(new OnPasswordChangedListener() {
			
			@Override
			public void onMaxLength(String psw) { }
			
			@Override
			public void onChanged(String psw) {
				if((!TextUtils.isEmpty(psw)) && psw.length() >= 6) {
					if(mListener != null) {
						mListener.onResult(psw);
						mDialog.closeDialog();
					}
				}
			}
		});
		if(mListener != null) {
			((TextView) findViewById(R.id.payment_amount_tv)).setText(mListener.onPaymentAmount());
		}else {
			((TextView) findViewById(R.id.payment_amount_tv)).setText(mContext.getString(R.string.shopping_car_price, 0));
		}
		
		mHintTextView = (TextView) findViewById(R.id.input_password_hint);
		if (!TextUtils.isEmpty(mHint)) {
			mHintTextView.setText(mHint);
		}
		
		findViewById(R.id.payment_amount_tv_close).setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				mDialog.closeDialog();
			}
		});
	}
	
	public void setScreenScale(int widthScale, int heightScale) {
		DisplayMetrics mMetrics = this.mContext.getResources().getDisplayMetrics();
		int width = widthScale == 0 ? LayoutParams.WRAP_CONTENT : mMetrics.widthPixels - (mMetrics.widthPixels / widthScale);
		int height = heightScale == 0 ? LayoutParams.WRAP_CONTENT : mMetrics.heightPixels - (mMetrics.heightPixels / heightScale);
		this.getWindow().setLayout(width, height);
	}
	
	public static synchronized void openDialog(Context context, OnPayPasswordListener listener) {
		openDialog(context, listener, "");
	}

	public static synchronized void openDialog(Context context, OnPayPasswordListener listener, String hint) {
		if(mDialog == null) { 
			mDialog = new InputPayPasswordDialog(context, listener, hint);
			mDialog.setCancelable(false);
		}
		mDialog.show();	
	}
	
	public void closeDialog() {
		if(mDialog != null && mDialog.isShowing()) {
			mDialog.dismiss();
			mDialog = null;
		}
	}
	
	@Override
	protected void onStop() {
		this.closeDialog();
		super.onStop();
	}
	
	public interface OnPayPasswordListener {
		String onPaymentAmount();
		void onResult(String payPassword);
	}
}