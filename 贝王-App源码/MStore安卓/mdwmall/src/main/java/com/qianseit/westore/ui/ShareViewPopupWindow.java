package com.qianseit.westore.ui;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.text.ClipboardManager;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnKeyListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.beiwangfx.R;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.ui.ShareView.ShareViewDataSource;
import com.qianseit.westore.util.ImageUtil;
import com.qianseit.westore.util.Md5;
import com.qianseit.westore.util.loader.FileUtils;

import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.tencent.qzone.QZone;
import cn.sharesdk.wechat.friends.Wechat;
import cn.sharesdk.wechat.moments.WechatMoments;

public class ShareViewPopupWindow extends PopupWindow implements OnClickListener, PlatformActionListener {

	private class BarGridAdapter extends BaseAdapter {

		@Override
		public int getCount() {
			return sharedArray.size();
		}

		@Override
		public Object getItem(int position) {
			return sharedArray.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@SuppressLint("ViewTag")
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {

			if (convertView == null) {
				convertView = View.inflate(mActivity, R.layout.item_shared_text, null);
			}
			JSONObject item = (JSONObject) this.getItem(position);
			convertView.setLayoutParams(layoutParams);
			TextView sharItem = (TextView) convertView.findViewById(R.id.share_item_name);
			int icon = item.optInt("icon");
			sharItem.setCompoundDrawablesWithIntrinsicBounds(null, mActivity.getResources().getDrawable(icon), null, null);
			sharItem.setText(item.optString("name"));
			sharItem.setTag(icon);
			sharItem.setOnClickListener(ShareViewPopupWindow.this);
			return convertView;
		}

	}

	ImageLoader mImageLoader = ImageLoader.getInstance();
	private ShareViewDataSource mDataSource;
	private Activity mActivity;
	private View mView;
	private AbsListView.LayoutParams layoutParams;
	private ArrayList<JSONObject> sharedArray = new ArrayList<JSONObject>();
	private Handler mHandler = new Handler();
	FileUtils mFileUtils;

	public ShareViewPopupWindow(Activity activity) {
		this.mActivity = activity;
		mFileUtils = new FileUtils(activity);
		this.init();
	}

	private void init() {

		this.mView = View.inflate(mActivity, R.layout.share_view_new, null);
		this.mView.setFocusable(true);
		this.mView.setFocusableInTouchMode(true);
		this.mView.setOnKeyListener(new OnKeyListener() {

			@Override
			public boolean onKey(View v, int keyCode, KeyEvent event) {
				if (isShowing()) {
					dismiss();
					return true;
				}
				return false;
			}
		});

		this.setContentView(mView);
		this.setWidth(LayoutParams.MATCH_PARENT);
		this.setHeight(LayoutParams.MATCH_PARENT);
		this.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		this.setTouchable(true);
		this.setFocusable(true);
		this.setOutsideTouchable(true);
		this.update();

		int width = Run.getWindowsWidth(mActivity) / 4;
		layoutParams = new AbsListView.LayoutParams(width, width);
		getSharedData();

		GridView sharedGridView = (GridView) mView.findViewById(R.id.shared_grid);
		sharedGridView.setAdapter(new BarGridAdapter());
		mView.findViewById(R.id.share_cancel).setOnClickListener(this);

		mView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (isShowing()) {
					dismiss();
				}
			}
		});
	}

	@Override
	public void dismiss() {
		WindowManager.LayoutParams params = mActivity.getWindow().getAttributes();
		params.alpha = 1f;
		mActivity.getWindow().setAttributes(params);
		super.dismiss();
	}

	public void setTwoCodeVisibility(boolean isVisib) {
		if (!isVisib) {
			removValue("生成二维码");
		}

	}

	public void setSmsVisibility(boolean isVisib) {
		if (!isVisib) {
			removValue("发短信");
		}

	}

	public void setCopeVisibility(boolean isVisib) {
		if (!isVisib) {
			removValue("复制链接");
		}

	}

	public void setWechatCirVisibility(boolean isVisib) {
		if (!isVisib) {
			removValue("朋友圈");
		}

	}

	public void setWechatVisibility(boolean isVisib) {
		if (!isVisib) {
			removValue("微信");
		}

	}

	public void setQzoneVisibility(boolean isVisib) {
		if (!isVisib) {
			removValue("QQ空间");
		}

	}

	public void setQQVisibility(boolean isVisib) {
		if (!isVisib) {
			removValue("QQ");
		}

	}

	public void setSinaVisibility(boolean isVisib) {
		if (!isVisib) {
			removValue("微博");
		}

	}

	public void removValue(String name) {
		for (int i = 0; i < sharedArray.size(); i++) {
			JSONObject valueJSON = sharedArray.get(i);
			if (valueJSON.opt("name").equals(name)) {
				sharedArray.remove(valueJSON);
			}
		}
	}

	public void getSharedData() {
		try {
			sharedArray.add(new JSONObject().put("name", "微信").put("icon", R.drawable.share_wechat));
			sharedArray.add(new JSONObject().put("name", "朋友圈").put("icon", R.drawable.share_wechat_circle));
			sharedArray.add(new JSONObject().put("name", "QQ").put("icon", R.drawable.share_qq));
			sharedArray.add(new JSONObject().put("name", "QQ空间").put("icon", R.drawable.share_qzone));
			sharedArray.add(new JSONObject().put("name", "微博").put("icon", R.drawable.share_sina));
			sharedArray.add(new JSONObject().put("name", "发短信").put("icon", R.drawable.share_sms));
			sharedArray.add(new JSONObject().put("name", "复制链接").put("icon", R.drawable.share_copy));
			sharedArray.add(new JSONObject().put("name", "生成二维码").put("icon", R.drawable.share_qrcode));
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * 设置分享数据源
	 * 
	 * @param mDataSource
	 */
	public void setDataSource(ShareViewDataSource mDataSource) {
		this.mDataSource = mDataSource;
	}

	void shareImageUrlToFile(final int shareIconRes) {
		mImageLoader.loadImage(mDataSource.getShareImageUrl(), new ImageLoadingListener() {

			@Override
			public void onLoadingStarted(String arg0, View arg1) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onLoadingFailed(String arg0, View arg1, FailReason arg2) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onLoadingComplete(String arg0, View arg1, Bitmap arg2) {
				// TODO Auto-generated method stub
				if (arg2 != null && !TextUtils.isEmpty(mDataSource.getShareImageUrl())) {
					String nShareImageUrl = mDataSource.getShareImageUrl();
					if (nShareImageUrl.indexOf("http") >= 0) {
						nShareImageUrl = nShareImageUrl.substring(nShareImageUrl.indexOf("http"));
					}
					nShareImageUrl = Md5.getMD5(nShareImageUrl);
					try {
						File nFile = mFileUtils.savaBitmap(nShareImageUrl, ImageUtil.compressThumImage(arg2));
						share(shareIconRes, nFile.getAbsolutePath());
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}

			@Override
			public void onLoadingCancelled(String arg0, View arg1) {
				// TODO Auto-generated method stub

			}
		});
	}

	void share(int shareIconRes, String shareImageUrlFileFullName) {

		String shareImageUrl = mDataSource.getShareImageUrl();
		String shareImageFile = mDataSource.getShareImageFile();
		String shareText = mDataSource.getShareText();

		Platform platform = null;
		String shareUrl = mDataSource.getShareUrl();
		String message = mDataSource.getShareMessage();
		if (message == null || TextUtils.isEmpty(message)) {
			message = TextUtils.isEmpty(shareText) ? "" : shareText;
		}

		if (message == null || TextUtils.isEmpty(message)) {
			message = TextUtils.isEmpty(shareUrl) ? "" : shareUrl;
		}
		
		if (shareIconRes == R.drawable.share_copy) {
			alertSuccess("复制链接成功");
			ClipboardManager cm = (ClipboardManager) mActivity.getSystemService(Context.CLIPBOARD_SERVICE);
			cm.setText(shareUrl);
		} else if (shareIconRes == R.drawable.share_qq) {
			platform = ShareSDK.getPlatform(mActivity, QQ.NAME);
			QQ.ShareParams params = new QQ.ShareParams();

			if (!TextUtils.isEmpty(shareImageFile)) {
				params.setShareType(Platform.SHARE_IMAGE);
				params.setImagePath(shareImageFile);
			} else {
				params.setShareType(Platform.SHARE_WEBPAGE);
				params.setTitle(shareText);
				params.setText(message);
				params.setTitleUrl(shareUrl);
				params.setSiteUrl(shareUrl);
				params.setUrl(shareUrl);
				params.setImagePath(shareImageUrlFileFullName);
				// params.setImageUrl(shareImageUrl);
			}
			platform.share(params);
		} else if (shareIconRes == R.drawable.share_qzone) {
			platform = ShareSDK.getPlatform(mActivity, QZone.NAME);
			QZone.ShareParams params = new QZone.ShareParams();
			if (!TextUtils.isEmpty(shareImageFile)) {
				params.setShareType(Platform.SHARE_IMAGE);
				params.setImagePath(shareImageFile);
			} else {
				params.setShareType(Platform.SHARE_WEBPAGE);
				params.setText(message);
				params.setTitle(shareText);
				params.setTitleUrl(shareUrl);
				// params.setImageUrl(shareImageUrl);
				params.setImagePath(shareImageUrlFileFullName);
				params.setSite(message);
				params.setSiteUrl(shareUrl);
			}
			platform.share(params);
		} else if (shareIconRes == R.drawable.share_wechat) {
			platform = ShareSDK.getPlatform(mActivity, Wechat.NAME);
			Wechat.ShareParams params = new Wechat.ShareParams();

			if (!TextUtils.isEmpty(shareImageFile)) {
				params.setShareType(Platform.SHARE_IMAGE);
				params.setImagePath(shareImageFile);
			} else {
				params.setShareType(Platform.SHARE_WEBPAGE);
				params.setText(message);
				params.setTitle(shareText);
				params.setTitleUrl(shareUrl);
				// params.setImageUrl(shareImageUrl);
				params.setImagePath(shareImageUrlFileFullName);
				params.setUrl(shareUrl);
			}
			platform.share(params);
		} else if (shareIconRes == R.drawable.share_wechat_circle) {
			platform = ShareSDK.getPlatform(mActivity, WechatMoments.NAME);
			WechatMoments.ShareParams params = new WechatMoments.ShareParams();
			if (shareImageFile != null && !shareImageFile.equals("")) {
				params.setImagePath(shareImageFile);
				params.setShareType(Platform.SHARE_IMAGE);
			} else {
				params.setShareType(Platform.SHARE_WEBPAGE);
				params.setTitle(shareText);
				params.setTitleUrl(shareUrl);
				// params.setImageUrl(shareImageUrl);
				params.setImagePath(shareImageUrlFileFullName);
				params.setUrl(shareUrl);
				params.setText(message);
			}
			platform.share(params);
		} else if (shareIconRes == R.drawable.share_sina) {
			platform = ShareSDK.getPlatform(mActivity, SinaWeibo.NAME);
			SinaWeibo.ShareParams paramsw = new SinaWeibo.ShareParams();
			if (shareImageFile != null && !shareImageFile.equals("")) {
				paramsw.setImagePath(shareImageFile);
				paramsw.setShareType(Platform.SHARE_IMAGE);
			} else {
				paramsw.setShareType(Platform.SHARE_WEBPAGE);
				paramsw.setTitle(shareText);
				paramsw.setTitleUrl(shareUrl);
				// paramsw.setImageUrl(shareImageUrl);
				paramsw.setImagePath(shareImageUrlFileFullName);
				paramsw.setUrl(shareUrl);
				paramsw.setText(message);
				platform.share(paramsw);
			}
		} else if (shareIconRes == R.drawable.share_qrcode) {

			if (TextUtils.isEmpty(shareUrl)) {
				Run.alert(mActivity, "分享链接为空不能生成二维码");
				return;
			}

			Intent intent = new Intent(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_TWODCODE));
			Bundle nBundle = new Bundle();
			nBundle.putString(Run.EXTRA_VALUE, shareUrl);
			nBundle.putString(Run.EXTRA_TITLE, message);
			intent.putExtras(nBundle);
			mActivity.startActivity(intent);
		} else if (shareIconRes == R.drawable.share_sms) {
			// 发短信
			Uri smsToUri = Uri.parse("smsto:");
			Intent sendIntent = new Intent(Intent.ACTION_SENDTO, smsToUri);
			sendIntent.putExtra("sms_body", (TextUtils.isEmpty(mDataSource.getShareMessage()) ? shareText : message) + ":" + mDataSource.getShareUrl());
			mActivity.startActivity(sendIntent);

		}

		if (platform != null) {
			platform.setPlatformActionListener(this);
		}
		dismiss();
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if (v.getId() == R.id.share_cancel) {
			dismiss();
			return;
		}
		int icon = (Integer) v.getTag();

		// 没有数据源无法分享
		if (mDataSource == null)
			return;

		String shareImageUrl = mDataSource.getShareImageUrl();
		String shareImageFile = mDataSource.getShareImageFile();
		String shareText = mDataSource.getShareText();

		shareText = shareText.replaceAll("null", "");
		if (TextUtils.isEmpty(shareText) && TextUtils.isEmpty(shareImageFile))
			return;

		if (TextUtils.isEmpty(shareImageFile) && !TextUtils.isEmpty(shareImageUrl) && shareImageUrl.startsWith("http://")) {
			shareImageUrlToFile(icon);
		} else {
			share(icon, shareImageUrl);
		}
	}

	private void alertSuccess(final String platName) {
		final Context ctx = mActivity;
		mHandler.post(new Runnable() {
			@Override
			public void run() {
				Run.alert(ctx, ctx.getString(R.string.share_success, platName));
			}
		});
	}

	private void alertFailed(final String platName) {
		final Context ctx = mActivity;
		mHandler.post(new Runnable() {
			@Override
			public void run() {
				Run.alert(ctx, ctx.getString(R.string.share_failed, platName));
			}
		});
	}

	@Override
	public void showAtLocation(View parent, int gravity, int x, int y) {
		beginShow();
		super.showAtLocation(parent, gravity, x, y);
	}

	@Override
	public void showAsDropDown(View anchor) {
		// TODO Auto-generated method stub
		beginShow();
		super.showAsDropDown(anchor);
	}

	@Override
	public void showAsDropDown(View anchor, int xoff, int yoff) {
		// TODO Auto-generated method stub
		beginShow();
		super.showAsDropDown(anchor, xoff, yoff);
	}

	@SuppressLint("NewApi")
	@Override
	public void showAsDropDown(View anchor, int xoff, int yoff, int gravity) {
		// TODO Auto-generated method stub
		beginShow();
		super.showAsDropDown(anchor, xoff, yoff, gravity);
	}

	void beginShow() {
		WindowManager.LayoutParams params = mActivity.getWindow().getAttributes();
		params.alpha = 0.7f;
		mActivity.getWindow().setAttributes(params);
	}

	@SuppressLint("SimpleDateFormat")
	private String getSavedFile() {
		return Run.buildString(new SimpleDateFormat("yyyyMMddkkmmss").format(System.currentTimeMillis()), ".jpg");
	}

	@Override
	public void onCancel(Platform arg0, int arg1) {
//		alertFailed(mActivity.getString(R.string.share));
	}

	@Override
	public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
		alertSuccess(mActivity.getString(R.string.share));
	}

	@Override
	public void onError(Platform arg0, int arg1, Throwable arg2) {
//		alertFailed(mActivity.getString(R.string.share));
	}

}
