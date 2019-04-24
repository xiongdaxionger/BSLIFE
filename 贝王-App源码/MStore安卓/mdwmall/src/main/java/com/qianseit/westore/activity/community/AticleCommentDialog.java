package com.qianseit.westore.activity.community;

import org.json.JSONObject;

import android.os.Handler;
import android.os.Message;
import android.os.Handler.Callback;
import android.view.Gravity;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDialog;
import com.qianseit.westore.base.BaseDoFragment;

public abstract class AticleCommentDialog extends BaseDialog implements Callback, android.view.View.OnClickListener {
	EditText mContentEditText, mVCodeEditText;
	ImageView mVCodeImageView;
	View mContentView, mVCodeDivider;
	
	JSONObject mSettingJsonObject;
	String mCommentId;
	
	BaseDoFragment mBaseDoFragment;

	boolean mVCodeOn = false;

	Handler mHandler;
	
	public AticleCommentDialog(BaseDoFragment baseDoFragment) {
		super(baseDoFragment.mActivity);
		// TODO Auto-generated constructor stub
		mBaseDoFragment = baseDoFragment;
		mContext = baseDoFragment.mActivity;
		mWindow = getWindow();
		mWindow.setBackgroundDrawableResource(backgroundRes());
		this.setContentView(init());
		this.setCanceledOnTouchOutside(true);
		mHandler = new Handler(this);
	}

	@Override
	protected View init() {
		// TODO Auto-generated method stub
		mContentView = View.inflate(mContext, R.layout.dialog_goods_comment_reply, null);
		mContentEditText = (EditText) mContentView.findViewById(R.id.content);
		mVCodeEditText = (EditText) mContentView.findViewById(R.id.vcode);
		mVCodeImageView = (ImageView) mContentView.findViewById(R.id.vcode_ib);
		mVCodeDivider = mContentView.findViewById(R.id.vcode_divider);
		mContentView.findViewById(R.id.send).setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (mContentEditText.getText().length() <= 0) {
					Run.alert(mContext, "请输入评价内容");
					return;
				}
				commment(mContentEditText.getText().toString());
				mContentEditText.setText("");
				dismiss();
			}
		});

		mVCodeDivider.setVisibility(View.GONE);
		mContentView.findViewById(R.id.vcode_tr).setVisibility(View.GONE);
		mVCodeImageView.setOnClickListener(this);
		return mContentView;
	}

	@Override
	public void dismiss() {
		// TODO Auto-generated method stub
		Run.hideSoftInputMethod(mContext, mContentEditText);
		super.dismiss();
	}
	
	@Override
	public void show() {
		// TODO Auto-generated method stub
		super.show();
		mContentEditText.requestFocus();
		
		mHandler.sendEmptyMessageDelayed(0, 200);
	}
	
	
	
	@Override
	protected int gravity() {
		// TODO Auto-generated method stub
		return Gravity.BOTTOM;
	}

	@Override
	protected float widthScale() {
		// TODO Auto-generated method stub
		return 1;
	}

	public abstract void commment(String content);
	
	@Override
	public boolean handleMessage(Message msg) {
		// TODO Auto-generated method stub
		Run.showSoftInputMethod(getOwnerActivity(), mContentEditText);
		return false;
	}
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.vcode_ib:
			break;

		default:
			break;
		}
	}
}
