package com.qianseit.westore.ui;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;

import org.apache.commons.io.FileUtils;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Handler;
import android.text.ClipboardManager;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.FrameLayout;
import android.widget.GridView;
import android.widget.TextView;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.tencent.qzone.QZone;
import cn.sharesdk.wechat.friends.Wechat;
import cn.sharesdk.wechat.moments.WechatMoments;

import com.qianseit.westore.Run;
import com.qianseit.westore.SimpleAnimListener;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.util.Util;
import com.beiwangfx.R;

public class ShareView extends FrameLayout implements OnClickListener, PlatformActionListener {
	private boolean isInited = false;

	private ShareViewDismiss mShareViewDismiss;
	private ShareViewDataSource mDataSource;
	private Handler mHandler = new Handler();
	private View ShareView;
	private Context mContext;
	private ArrayList<JSONObject> sharedArray = new ArrayList<JSONObject>();
	private AbsListView.LayoutParams layoutParams;

	public ShareView(Context context) {
		super(context);
		this.initShareView(context);
	}

	public ShareView(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.initShareView(context);
	}

	public ShareView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		this.initShareView(context);
	}

	public void setTwoCodeVisibility(boolean isVisib) {
		if (!isVisib) {
			removValue("二维码");
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

	public void removValue(String name) {
		for (int i = 0; i < sharedArray.size(); i++) {
			JSONObject valueJSON = sharedArray.get(i);
			if (valueJSON.opt("name").equals(name)) {
				sharedArray.remove(valueJSON);
			}
		}
	}

	private void initShareView(Context context) {
		int width = Run.getWindowsWidth((Activity) context) / 4;
		layoutParams = new AbsListView.LayoutParams(width, width);
		mContext = context;
		getSharedData();
		if (!isInited) {
			isInited = true;
			ShareView = inflate(mContext, R.layout.share_view_new, null);
			GridView sharedGridView = (GridView) ShareView.findViewById(R.id.shared_grid);
			sharedGridView.setAdapter(new BarGridAdapter());
			addView(ShareView);

			findViewById(R.id.share_cancel).setOnClickListener(this);
		}
	}

	public void getSharedData() {
		try {
			sharedArray.add(new JSONObject().put("name", "微信").put("icon", R.drawable.share_wechat));
			sharedArray.add(new JSONObject().put("name", "朋友圈").put("icon", R.drawable.share_wechat_circle));
			sharedArray.add(new JSONObject().put("name", "二维码").put("icon", R.drawable.share_qrcode));
			sharedArray.add(new JSONObject().put("name", "QQ空间").put("icon", R.drawable.share_qzone));
			sharedArray.add(new JSONObject().put("name", "QQ").put("icon", R.drawable.share_qq));
			sharedArray.add(new JSONObject().put("name", "复制链接").put("icon", R.drawable.share_copy));
			sharedArray.add(new JSONObject().put("name", "发短信").put("icon", R.drawable.share_sms));
			sharedArray.add(new JSONObject().put("name", "新浪微博").put("icon", R.drawable.share_sina));
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

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
				convertView = inflate(mContext, R.layout.item_shared_text, null);

			}
			JSONObject item = (JSONObject) this.getItem(position);
			convertView.setLayoutParams(layoutParams);
			TextView sharItem = (TextView) convertView;
			int icon = item.optInt("icon");
			sharItem.setCompoundDrawablesWithIntrinsicBounds(null, mContext.getResources().getDrawable(icon), null, null);
			sharItem.setText(item.optString("name"));
			sharItem.setTag(icon);
			sharItem.setOnClickListener(ShareView.this);
			return sharItem;
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

	/**
	 * 设置画面隐藏
	 * 
	 * @param mDataSource
	 */
	public void setOnDismiss(ShareViewDismiss dismiss) {
		this.mShareViewDismiss = dismiss;
	}

	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.share_cancel) {
			dismissShareView();
			return;
		}
		int icon = (Integer) v.getTag();

		// 没有数据源无法分享
		if (mDataSource == null)
			return;

		boolean isShareQRCode = false;
		String shareImageUrl = mDataSource.getShareImageUrl();
		String shareImageFile = mDataSource.getShareImageFile();
		if ((shareImageUrl == null || TextUtils.isEmpty(shareImageFile)) && !TextUtils.isEmpty(shareImageFile) && shareImageFile.contains("share_qrcode")) {// 二维码邀请特殊处理
			isShareQRCode = true;
		}
		String shareText = mDataSource.getShareText();
		shareText = shareText.replaceAll("null", "");
		if (TextUtils.isEmpty(shareText) && TextUtils.isEmpty(shareImageFile))
			return;

		File file = null;
		if (!isShareQRCode) {
			// 暂时移到这里，开放分享图片后移到最前面
			if (!TextUtils.isEmpty(shareImageFile)) {
				file = new File(shareImageFile);
				File destFile = new File(Run.doFolder, "share_image.jpg");
				try {
					FileUtils.copyFile(file, destFile);
					file = destFile;
				} catch (Exception e) {
					e.printStackTrace();
					file = null;
				}
			}

			if (file == null) {
				shareImageFile = Util.getPath() + "/share_qrcode";
				Bitmap bitmap = BitmapFactory.decodeResource(getContext().getResources(), R.drawable.comm_icon_launcher);
				Util.saveBitmap("share_iamge", bitmap);
				file = new File(shareImageFile);
				File destFile = new File(Run.doFolder, "share_image.jpg");
				try {
					FileUtils.copyFile(file, destFile);
					file = destFile;
				} catch (Exception e) {
					e.printStackTrace();
					file = null;
				}
			}
		} else {
			shareImageFile = Util.getPath() + "/share_image";
			file = new File(shareImageFile);
			File destFile = new File(Run.doFolder, "share_image.jpg");
			try {
				FileUtils.copyFile(file, destFile);
				file = destFile;
			} catch (Exception e) {
				e.printStackTrace();
				file = null;
			}
		}

		Platform platform = null;
		String shareUrl = mDataSource.getShareUrl();
		String message = mDataSource.getShareMessage();
		if (message == null || TextUtils.isEmpty(message)) {
			message = TextUtils.isEmpty(shareUrl) ? "" : shareUrl;
		}

		if (icon == R.drawable.share_copy) {
			alertSuccess(((TextView) v).getText().toString());
			ClipboardManager cm = (ClipboardManager) getContext().getSystemService(Context.CLIPBOARD_SERVICE);
			cm.setText(shareUrl);
		} else if (icon == R.drawable.share_qq) {
			platform = ShareSDK.getPlatform(getContext(), QQ.NAME);
			QQ.ShareParams params = new QQ.ShareParams();

			if (!shareImageFile.equals(""))
				params.setImagePath(shareImageFile);
			params.setTitle(shareText);
			params.setText(message);
			params.setTitleUrl(shareUrl);
			params.setSiteUrl(shareUrl);
			params.setUrl(shareUrl);
			params.setImageUrl(shareImageUrl);
			platform.share(params);
		} else if (icon == R.drawable.share_qzone) {
			platform = ShareSDK.getPlatform(getContext(), QZone.NAME);
			QZone.ShareParams params = new QZone.ShareParams();

			if (!shareImageFile.equals(""))
				params.setImagePath(shareImageFile);
			params.setTitle(shareText);
			params.setText(message);
			params.setTitleUrl(mDataSource.getShareUrl());
			params.setSite(message);
			params.setSiteUrl(mDataSource.getShareUrl());
			params.setImageUrl(shareImageUrl);
			platform.share(params);
		} else if (icon == R.drawable.share_wechat) {
			platform = ShareSDK.getPlatform(getContext(), Wechat.NAME);
			Wechat.ShareParams params = new Wechat.ShareParams();

			if (file != null && !shareImageFile.equals("")) {
				params.setImagePath(shareImageFile);
			}
			if (!TextUtils.isEmpty(shareUrl)) {
				params.setShareType(Platform.SHARE_WEBPAGE);
			}
			// else if (file != null){
			// params.setShareType(Platform.SHARE_IMAGE);
			// }
			params.setText(message);
			params.setTitle(shareText);
			params.setTitleUrl(shareUrl);
			params.setImageUrl(shareImageUrl);
			params.setUrl(shareUrl);
			platform.share(params);
		} else if (icon == R.drawable.share_wechat_circle) {
			platform = ShareSDK.getPlatform(getContext(), WechatMoments.NAME);
			WechatMoments.ShareParams params = new WechatMoments.ShareParams();
			if (!shareImageFile.equals("")) {
				params.setImagePath(shareImageFile);
				params.setShareType(Platform.SHARE_IMAGE);
			}
			if (!TextUtils.isEmpty(shareUrl)) {
				params.setShareType(Platform.SHARE_WEBPAGE);
			}
			params.setTitle(shareText);
			params.setTitleUrl(shareUrl);
			params.setImageUrl(shareImageUrl);
			params.setUrl(shareUrl);
			params.setText(message);
			platform.share(params);
		} else if (icon == R.drawable.share_sina) {
			platform = ShareSDK.getPlatform(getContext(), SinaWeibo.NAME);
			SinaWeibo.ShareParams paramsw = new SinaWeibo.ShareParams();
			if (!shareImageFile.equals("")) {
				paramsw.setImagePath(shareImageFile);
				paramsw.setShareType(Platform.SHARE_IMAGE);
			}
			if (!TextUtils.isEmpty(shareUrl)) {
				paramsw.setShareType(Platform.SHARE_WEBPAGE);
			}

			paramsw.setTitle(shareText);
			paramsw.setTitleUrl(shareUrl);
			paramsw.setImageUrl(shareImageUrl);
			paramsw.setUrl(shareUrl);
			paramsw.setText(message);
			platform.share(paramsw);
		} else if (icon == R.drawable.share_qrcode) {
			// Intent intent = new
			// Intent(AgentActivity.intentForFragment(getContext(),
			// AgentActivity.FRAGMENT_ACCO_TWO_CODE));
			// getContext().startActivity(intent);
		} else if (icon == R.drawable.share_sms) {
			// 发短信
			Uri smsToUri = Uri.parse("smsto:");
			Intent sendIntent = new Intent(Intent.ACTION_SENDTO, smsToUri);
			sendIntent.putExtra("sms_body", (TextUtils.isEmpty(mDataSource.getShareMessage()) ? shareText : message) + ":" + mDataSource.getShareUrl());
			getContext().startActivity(sendIntent);

		}

		if (platform != null)
			platform.setPlatformActionListener(this);
		this.dismissShareView();
	}

	private void alertSuccess(final String platName) {
		final Context ctx = getContext();
		mHandler.post(new Runnable() {
			@Override
			public void run() {
				Run.alert(ctx, ctx.getString(R.string.share_success, platName));
			}
		});
	}

	private void alertFailed(final String platName) {
		final Context ctx = getContext();
		mHandler.post(new Runnable() {
			@Override
			public void run() {
				Run.alert(ctx, ctx.getString(R.string.share_failed, platName));
			}
		});
	}

	private String getSavedFile() {
		return Run.buildString(new SimpleDateFormat("yyyyMMddkkmmss").format(System.currentTimeMillis()), ".jpg");
	}

	// 显示分享
	public void showShareView() {
		setVisibility(View.VISIBLE);
		View animView = findViewById(R.id.share_view_zone);
		Animation animIn = AnimationUtils.loadAnimation(getContext(), R.anim.push_up_in);
		animView.startAnimation(animIn);
	}

	// 隐藏分享
	public void dismissShareView() {
		View animView = findViewById(R.id.share_view_zone);
		Animation animOut = AnimationUtils.loadAnimation(getContext(), R.anim.push_down_out);
		animOut.setAnimationListener(new SimpleAnimListener() {
			@Override
			public void onAnimationEnd(Animation animation) {
				if (ShareView.this.mShareViewDismiss != null) {
					ShareView.this.mShareViewDismiss.dismiss();
				}
				setVisibility(View.GONE);
			}
		});
		animView.startAnimation(animOut);
	}

	@Override
	public void onCancel(Platform arg0, int arg1) {
		alertFailed(getContext().getString(R.string.share));
	}

	@Override
	public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
		alertSuccess(getContext().getString(R.string.share));
	}

	@Override
	public void onError(Platform arg0, int arg1, Throwable arg2) {
		alertFailed(getContext().getString(R.string.share));
	}

	public interface ShareViewDataSource {
		String getShareText();

		/**
		 * 只分享图片,其它参数无效
		 * @return
		 */
		String getShareImageFile();

		/**
		 * 分享链接 除ShareImageFile外的参数有效
		 * @return
		 */
		String getShareImageUrl();

		String getShareUrl();

		String getShareMessage();
	}

	public interface ShareViewDismiss {
		String dismiss();
	}
}
