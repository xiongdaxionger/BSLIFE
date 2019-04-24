package com.qianseit.westore.activity.wealth;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;

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

public class WealthCollectionTwoCodeFragment extends BaseDoFragment implements PlatformActionListener {

	private LoginedUser mLoginedUser;
	private ImageView twoCodeImg;
	private TextView shopName, shopUrlTextView, fromShop, shareWechat, shareWechatCircle;
	// private TextView userUrl;
	// private String mShopId;
	// private String mMemberId;
	// private String mShopName;
	// private String mShopLink;
	private String imageurl;
	// 分享
	// private ShareView mShareView;

	private View mQRCodeView;
	Platform platform = null;
	private File file;
	public String shareUrl;
	public String type; //1:店铺收钱 2：邀请开店

	public WealthCollectionTwoCodeFragment() {
		super();
	}

	public void onCreate(Bundle bundle) {
		super.onCreate(bundle);
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
		Intent intent=mActivity.getIntent();
		type=intent.getStringExtra(Run.EXTRA_TITLE);
		shareUrl=intent.getStringExtra(Run.EXTRA_VALUE);
	}

	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		
		rootView = inflater.inflate(R.layout.fragment_shop_two_code_invite, null);
		findViewById(R.id.qrcode_save).setOnClickListener(this);

		twoCodeImg = (ImageView) findViewById(R.id.user_two_code);
		mQRCodeView = findViewById(R.id.qrcode_layout);
		mQRCodeView.setDrawingCacheEnabled(true);
		shopName = (TextView) findViewById(R.id.shop_name);
		fromShop = (TextView) findViewById(R.id.from);
		shareWechat = (TextView) findViewById(R.id.share_wechat);
		shareWechatCircle = (TextView) findViewById(R.id.share_wechat_circle);
		shareWechat.setOnClickListener(this);
		shareWechatCircle.setOnClickListener(this);
		
		fromShop.setText("From" + mLoginedUser.getName());

//		   if("1".equals(type)){
//			  mActionBar.setTitle("收钱二维码");
//			  shopName.setText(mLoginedUser.getName()+"直接收款");// 昵称
//			}else if("2".equals(type)){
//			  mActionBar.setTitle("邀请开店二维码");
//			  shopName.setText("邀请你的朋友开店");//昵称
//			}
		displaySquareImage(twoCodeImg, shareUrl);
	}

	@Override
	public void onClick(View v) {

		if (v.getId() == R.id.qrcode_save) {
			if (v.getId() == R.id.qrcode_save) {
				if (saveToLocal()) {
					Run.alert(mActivity, "保存成功");
				}
			}
		} else if (v == shareWechat) {
			platform = ShareSDK.getPlatform(mActivity, Wechat.NAME);
			Wechat.ShareParams params = new Wechat.ShareParams();

			if (file == null) {
				if (!saveToLocal()) {
					return;
				}
			}
			// else if (shareUrl != null) {
			// params.setShareType(Platform.SHARE_WEBPAGE);
			// params.setImageUrl(shareUrl);
			// }

			params.setImageUrl(shareUrl);
			params.setUrl(shareUrl);
//			params.setText("长按二维码识别或直接扫码进入哦");
//			params.setTitle(shopName.getText().toString() + "  好货多多");
			params.setShareType(Platform.SHARE_IMAGE);
			params.setImagePath(file.getAbsolutePath());
			platform.share(params);
		} else if (v == shareWechatCircle) {
			platform = ShareSDK.getPlatform(mActivity, WechatMoments.NAME);
			WechatMoments.ShareParams params = new WechatMoments.ShareParams();

			if (file == null) {
				if (!saveToLocal()) {
					return;
				}
			}
			// else if (shareUrl != null) {
			// params.setShareType(Platform.SHARE_WEBPAGE);
			// params.setImageUrl(shareUrl);
			// }

			params.setImageUrl(shareUrl);
			params.setUrl(shareUrl);
//			params.setText("长按二维码识别或直接扫码进入哦");
//			params.setTitle(shopName.getText().toString() + "  好货多多");
			params.setShareType(Platform.SHARE_IMAGE);
			params.setImagePath(file.getAbsolutePath());
			platform.share(params);
		}
	}

	boolean saveToLocal() {
		//Bitmap b = mImageLoader.getInstance().loadImageSync(shareUrl);
		Bitmap b = mQRCodeView.getDrawingCache();
		
		// 首先保存图片
		File filePath = new File(Environment.getExternalStorageDirectory(), "Xyms-QrCode");
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


	// 分享失败
	private void alertFailed(final String platName) {
		mHandler.post(new Runnable() {
			@Override
			public void run() {
				Run.alert(mActivity, mActivity.getString(R.string.share_failed, platName));
			}
		});
	}

	// 分享成功
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
