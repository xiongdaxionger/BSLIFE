package com.qianseit.westore.activity.goods;

import android.content.ContentValues;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDialog;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.goods.GoodsReplyInterface;

import org.json.JSONObject;

public abstract class GoodsCommentReplyDialog extends BaseDialog implements android.view.View.OnClickListener {
	EditText mContentEditText, mVCodeEditText;
	ImageView mVCodeImageView;
	View mContentView, mVCodeDivider;
	
	JSONObject mSettingJsonObject;
	String mCommentId;
	
	BaseDoFragment mBaseDoFragment;

	GoodsReplyInterface mConsultPublishInterface;
	boolean mVCodeOn = false;

	public GoodsCommentReplyDialog(BaseDoFragment baseDoFragment) {
		super(baseDoFragment.mActivity);
		// TODO Auto-generated constructor stub
		mBaseDoFragment = baseDoFragment;
		mConsultPublishInterface = new GoodsReplyInterface(mBaseDoFragment) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				Run.alert(mBaseDoFragment.mActivity, "回复成功");
				replySucc();
				dismiss();
			}

			@Override
			public ContentValues BuildParams() {
				ContentValues nContentValues = new ContentValues();
				nContentValues.put("comment", mContentEditText.getText().toString());
				if (mVCodeOn) {
					nContentValues.put("replyverifyCode", mVCodeEditText.getText().toString());
				}
				nContentValues.put("id", mCommentId);
				return nContentValues;
			}
			
			@Override
			public void FailRequest() {
				reloadVCodeImage();
			}
		};
		mContext = baseDoFragment.mActivity;
		mWindow = getWindow();
		mWindow.setBackgroundDrawableResource(backgroundRes());
		this.setContentView(init());
		this.setCanceledOnTouchOutside(true);
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
					Run.alert(mContext, "请输入回复内容");
					return;
				}
				if (mVCodeOn && mVCodeEditText.getText().length() <= 0) {
					Run.alert(mContext, "请输入图文验证码");
					return;
				}
				mConsultPublishInterface.RunRequest();
			}
		});
		mVCodeImageView.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				reloadVCodeImage();
			}
		});

		return mContentView;
	}

	public void setData(JSONObject settingJsonObject, String commentId) {
		mCommentId = commentId;
		mSettingJsonObject = settingJsonObject;
		mVCodeOn = !TextUtils.isEmpty(mSettingJsonObject.optString("verifyCode"));
		if (!mVCodeOn) {
			mVCodeDivider.setVisibility(View.GONE);
			mContentView.findViewById(R.id.vcode_tr).setVisibility(View.GONE);
		}else{
			mVCodeDivider.setVisibility(View.VISIBLE);
			mContentView.findViewById(R.id.vcode_tr).setVisibility(View.VISIBLE);
		}
		reloadVCodeImage();
	}
	
	void reloadVCodeImage(){
		if (mBaseDoFragment == null) {
			return;
		}
		
		BaseDoFragment.displayRectangleImage(mVCodeImageView, String.format("%s?%s", mSettingJsonObject.optString("verifyCode"), System.currentTimeMillis()));
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

	@Override
	public void show() {
		// TODO Auto-generated method stub
		super.show();
		mContentEditText.requestFocus();
		Run.showSoftInputMethod(mBaseDoFragment.mActivity, mVCodeImageView);
		reloadVCodeImage();
	}
	
	public abstract void replySucc();
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.goods_propty_ok:
			dismiss();
			break;

		default:
			break;
		}
	}
}
