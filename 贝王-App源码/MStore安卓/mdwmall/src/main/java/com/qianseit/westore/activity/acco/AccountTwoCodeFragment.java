package com.qianseit.westore.activity.acco;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.util.StringUtils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.wechat.friends.Wechat;
import cn.sharesdk.wechat.moments.WechatMoments;

public class AccountTwoCodeFragment extends BaseDoFragment implements PlatformActionListener{
		 
	private LoginedUser mLoginedUser;
	private ImageView twoCodeImg;
	private TextView shareWechat,shareWechatCircle, nameTextView;

	Platform platform = null;
	public String shareUrl;
	private View mQRCodeView;
	private File file;
	private int iconWidth;


	public AccountTwoCodeFragment() {
		super();
	}

	public void onCreate(Bundle bundle) {
		super.onCreate(bundle);
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
		iconWidth=Run.getWindowsWidth(mActivity)-Run.dip2px(mActivity, 60);
		
	}
	
	
	

	public void init(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		mActionBar.setTitle(R.string.two_code_invite_register);

		rootView = inflater.inflate(R.layout.fragment_acco_two_code_invite, null);
		findViewById(R.id.qrcode_save).setOnClickListener(this);

		twoCodeImg = (ImageView) findViewById(R.id.user_two_code);

		nameTextView = (TextView) findViewById(R.id.name);
		mQRCodeView = findViewById(R.id.code_view);
		mQRCodeView.setDrawingCacheEnabled(true);

		android.view.ViewGroup.LayoutParams layoutParams = mQRCodeView.getLayoutParams();
		layoutParams.height = Run.getWindowsWidth(mActivity) / 4 * 5;
		mQRCodeView.setLayoutParams(layoutParams);

		shareWechat = (TextView)findViewById(R.id.share_wechat);
		shareWechatCircle = (TextView)findViewById(R.id.share_wechat_circle);
		shareWechat.setOnClickListener(this);
		shareWechatCircle.setOnClickListener(this);

		twoCodeImg.setImageBitmap(
				Run.CreateTwoDCodeDip(mActivity, mLoginedUser.mMemberIndex.getReferrals_url(), 250, 250));
//		shareUrl= mLoginedUser.mMemberIndex.getReferrals_url();
//		displaySquareImage(twoCodeImg,shareUrl);
		String name = mLoginedUser.getName();
		if(TextUtils.isEmpty(name)){
			name = mLoginedUser.getUName();
		}
		nameTextView.setText("我是" + name);
	}
	
	boolean saveToLocal() {
	//	Bitmap b = mImageLoader.getInstance().loadImageSync(shareUrl);
		Bitmap b = mQRCodeView.getDrawingCache();
		// 首先保存图片
		File filePath = new File(Environment.getExternalStorageDirectory(),Run.TAG);
		if (!filePath.exists()) {
			filePath.mkdir();
		}
		String fileName = System.currentTimeMillis() + ".jpg";
		file = new File(filePath, fileName);
		try {
			FileOutputStream fos = new FileOutputStream(file);
			b.compress(CompressFormat.JPEG, 100, fos);
			fos.flush();
			fos.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			Run.alert(mActivity, e.getMessage());
			return false;
		} catch (IOException e) {
			Run.alert(mActivity, e.getMessage());
			e.printStackTrace();
			return false;
		}

		// 其次把文件插入到系统图库
		try {
			MediaStore.Images.Media.insertImage(mActivity.getContentResolver(), file.getAbsolutePath(), fileName, null);
		} catch (FileNotFoundException e) {
			Run.alert(mActivity, e.getMessage());
			e.printStackTrace();
			return false;
		}
		// 最后通知图库更新
		mActivity.sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.fromFile(file)));

		return true;
	}

	@Override
	public void onClick(View v) {
			if (v.getId() == R.id.qrcode_save) {
				if (v.getId() == R.id.qrcode_save) {
					if (saveToLocal()) {
						Run.alert(mActivity, "保存成功");
					}
				}
			//分享图片到微信
		}else if(v == shareWechat){
			platform = ShareSDK.getPlatform(mActivity, Wechat.NAME);
			Wechat.ShareParams params = new Wechat.ShareParams();
			if (file == null) {
				if (!saveToLocal()) {
					return;
				}
			}
			if ( file!= null) {
				params.setShareType(Platform.SHARE_IMAGE);
				params.setImagePath(file.getAbsolutePath());
			}else if(shareUrl != null){
				params.setShareType(Platform.SHARE_WEBPAGE);
				params.setImageUrl(shareUrl);
			}
			platform.share(params);
		//分享图片到微信朋友圈
		}else if(v == shareWechatCircle){
			platform = ShareSDK.getPlatform(mActivity, WechatMoments.NAME);
			WechatMoments.ShareParams params = new WechatMoments.ShareParams();
			if (file == null) {
				if (!saveToLocal()) {
					return;
				}
			}
			params.setShareType(Platform.SHARE_IMAGE);
			if (file != null) {
				params.setImagePath(file.getAbsolutePath());
			}else if(shareUrl != null){
				params.setShareType(Platform.SHARE_WEBPAGE);
				params.setImageUrl(shareUrl);
			}
			platform.share(params);
		}
		}


	//分享失败
	private void alertFailed(final String platName) {
		mHandler.post(new Runnable() {
			@Override
			public void run() {
				Run.alert(mActivity, mActivity.getString(R.string.share_failed, platName));
			}
		});
	}
	//分享成功
	private void alertSuccess(final String platName) {
		mHandler.post(new Runnable() {
			@Override
			public void run() {
				Run.alert(mActivity, mActivity.getString(R.string.share_success, platName));
			}
		});
	}


	@Override
	public void onCancel(Platform arg0, int arg1) {
		alertFailed(mActivity.getString(R.string.share));
	}

	@Override
	public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
		alertSuccess(mActivity.getString(R.string.share));
	}

	@Override
	public void onError(Platform arg0, int arg1, Throwable arg2) {
		alertFailed(mActivity.getString(R.string.share));
	}
}
