package com.qianseit.westore.activity.wealth;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.text.ClipboardManager;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.qianseit.westore.ui.GoodsShared;
import com.qianseit.westore.ui.MsherdGridView;
import com.qianseit.westore.util.Util;

import org.apache.commons.io.FileUtils;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.tencent.qzone.QZone;
import cn.sharesdk.wechat.friends.Wechat;
import cn.sharesdk.wechat.moments.WechatMoments;

public class WealthCollectionNextFragment extends BaseDoFragment implements GoodsShared {
	private final int WHAT = 0x1000;
	private final int WEIXING = 0x100;
	private final int PENYOUCHUAN = 0x101;
	private final int ERWEIMA = 0x102;
	private final int QQKONGJIAN = 0x103;
	private final int MQQ = 0x104;
	private final int COPEURL = 0x105;
	private final int DUANXIN = 0x106;
	private final int WEIBO = 0x108;
	private TextView mNameText;
	private TextView mMoneyText;
	private MsherdGridView mSherdGridView;
	private List<JSONObject> mGridArray = new ArrayList<JSONObject>();
	private LayoutInflater mLayoutInflater;
	private String money;
	private boolean cheack;
	private LoginedUser mLoginedUser;
	private String sharedUrl;
	private String IconLink;

	///收钱描述 key
	public static final String COLLECT_DESC_KEY = "collectDesc";

	///收钱描述
	private String mCollectDesc;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
		mActionBar.setTitle("收钱");
		mActionBar.setRightTitleButton("完成", new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				mActivity.finish();
			}
		});
		mActionBar.getRightButton().setTextColor(ContextCompat.getColor(mActivity, R.color.but_gray_click_color));
		Intent intent = mActivity.getIntent();
		if (intent != null) {
			money = String.valueOf(Double.valueOf(intent.getStringExtra(Run.EXTRA_DATA)));
			cheack = intent.getBooleanExtra(Run.EXTRA_CLASS_ID, true);
			mCollectDesc = intent.getStringExtra(COLLECT_DESC_KEY);
		}
		try {
			mGridArray.add(new JSONObject().put("name", "微信").put("type", WEIXING));
			mGridArray.add(new JSONObject().put("name", "朋友圈").put("type", PENYOUCHUAN));
			mGridArray.add(new JSONObject().put("name", "QQ").put("type", MQQ));
			mGridArray.add(new JSONObject().put("name", "QQ空间").put("type", QQKONGJIAN));
			mGridArray.add(new JSONObject().put("name", "微博").put("type", WEIBO));
			mGridArray.add(new JSONObject().put("name", "发短信").put("type", DUANXIN));
			mGridArray.add(new JSONObject().put("name", "复制链接").put("type", COPEURL));
			mGridArray.add(new JSONObject().put("name", "二维码").put("type", ERWEIMA));
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	private void alertSuccess(final String platName) {
		mHandler.post(new Runnable() {
			@Override
			public void run() {
				Run.alert(mActivity, mActivity.getString(R.string.share_success, platName));
			}
		});
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		super.init(inflater, container, savedInstanceState);
		mLayoutInflater = inflater;
		rootView = inflater.inflate(R.layout.collection_main_two, null);
		mNameText = (TextView) findViewById(R.id.collection_name);
		mMoneyText = (TextView) findViewById(R.id.collection_money);
		mNameText.setText(mLoginedUser.getName() + "直接收款");
		mMoneyText.setText(String.valueOf(money));
		mSherdGridView = (MsherdGridView) findViewById(R.id.collection_grid);
		mSherdGridView.setAdapter(new MyGridAdapter());

		Run.excuteJsonTask(new JsonTask(), new GetMoneyTask());

		mSherdGridView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				JSONObject json = (JSONObject) view.getTag(R.id.tag_object);
				String shareImageUrl = getShareImageUrl();
				String shareImageFile = getShareImageFile();
				String shareText = getShareText();
				String shareUrl = getShareUrl();
				String message = getMessage();

				if (TextUtils.isEmpty(shareText) || TextUtils.isEmpty(shareImageFile))
					return;

				File file = null;
				// 暂时移到这里，开放分享图片后移到最前面
				if (!TextUtils.isEmpty(shareImageFile)) {
					file = new File(getShareImageFile());
					File destFile = new File(Run.doFolder, "share_image.jpg");
					try {
						FileUtils.copyFile(file, destFile);
						file = destFile;
					} catch (Exception e) {
					}
				}
				Platform platform = null;
				switch (json.optInt("type")) {
				case WEIXING:
					platform = ShareSDK.getPlatform(mActivity, Wechat.NAME);
					Wechat.ShareParams params = new Wechat.ShareParams();
					if (file != null) {
						params.setImagePath(file.getAbsolutePath());
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
					break;
				case PENYOUCHUAN:
					platform = ShareSDK.getPlatform(mActivity, WechatMoments.NAME);
					WechatMoments.ShareParams params3 = new WechatMoments.ShareParams();
					if (file != null) {
						params3.setImagePath(file.getAbsolutePath());
						params3.setShareType(Platform.SHARE_IMAGE);
					}
					if (!TextUtils.isEmpty(shareUrl)) {
						params3.setShareType(Platform.SHARE_WEBPAGE);
					}
					params3.setTitle(shareText);
					params3.setTitleUrl(shareUrl);
					params3.setImageUrl(shareImageUrl);
					params3.setUrl(shareUrl);
					params3.setText(message);
					platform.share(params3);
					break;
				case ERWEIMA:
//					 Intent intent = new
//					 Intent(AgentActivity.intentForFragment(
//					 mActivity, AgentActivity.FRAGMENT_WEAL_SHOPE_TWO_CODE).putExtra(Run.EXTRA_TITLE, "1").putExtra(Run.EXTRA_VALUE,IconLink));
//					 mActivity.startActivity(intent);
					Intent intent = new Intent(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_TWODCODE));
					Bundle nBundle = new Bundle();
					nBundle.putString(Run.EXTRA_VALUE, shareUrl);
					nBundle.putString(Run.EXTRA_TITLE, message);
					intent.putExtras(nBundle);
					mActivity.startActivity(intent);
					break;
				case QQKONGJIAN:
					platform = ShareSDK.getPlatform(mActivity, QZone.NAME);
					QZone.ShareParams params1 = new QZone.ShareParams();
					if (!TextUtils.isEmpty(shareImageUrl))
						params1.setImageUrl(shareImageUrl);
					params1.setTitle(shareText);
					params1.setText(message);
					params1.setTitleUrl(getShareUrl());
					params1.setSite(message);
					params1.setSiteUrl(getShareUrl());
					platform.share(params1);
					break;
				case MQQ:
					platform = ShareSDK.getPlatform(mActivity, QQ.NAME);
					QQ.ShareParams params2 = new QQ.ShareParams();
					if (file != null)
						params2.setImagePath(file.getAbsolutePath());
					params2.setTitle(shareText);
					params2.setText(message);
					params2.setTitleUrl(shareUrl);
					params2.setSiteUrl(shareUrl);
					params2.setUrl(shareUrl);
					platform.share(params2);
					break;
				case COPEURL:
					ClipboardManager cm = (ClipboardManager) mActivity.getSystemService(Context.CLIPBOARD_SERVICE);
					cm.setText(shareUrl);
					alertSuccess("复制");

					break;
				case DUANXIN:
					Uri smsToUri = Uri.parse("smsto:");
					Intent sendIntent = new Intent(Intent.ACTION_SENDTO, smsToUri);
					sendIntent.putExtra("sms_body", message + ":" + shareUrl);
					mActivity.startActivity(sendIntent);
					break;
					case WEIBO:
						platform = ShareSDK.getPlatform(mActivity, SinaWeibo.NAME);
						SinaWeibo.ShareParams weiboParams = new SinaWeibo.ShareParams();
						if (file != null)
							weiboParams.setImagePath(file.getAbsolutePath());
						weiboParams.setTitle(shareText);
						weiboParams.setText(message);
						weiboParams.setTitleUrl(shareUrl);
						weiboParams.setSiteUrl(shareUrl);
						weiboParams.setUrl(shareUrl);
						platform.share(weiboParams);
						break;
				default:
					break;
				}

			}
		});

	}

	public class MyGridAdapter extends BaseAdapter {

		@Override
		public int getCount() {
			return mGridArray.size();
		}

		@Override
		public JSONObject getItem(int position) {
			// TODO Auto-generated method stub
			return mGridArray.get(position);
		}

		@Override
		public long getItemId(int position) {
			// TODO Auto-generated method stub
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			Holderview holderview;
			if (convertView == null) {
				holderview = new Holderview();
				convertView = mLayoutInflater.inflate(R.layout.goods_grid_item, null);
				holderview.icon = (ImageView) convertView.findViewById(R.id.goods_item_icon);
				holderview.nameText = (TextView) convertView.findViewById(R.id.goods_item_name);
				convertView.setTag(holderview);
			} else {
				holderview = (Holderview) convertView.getTag();
			}
			JSONObject json = getItem(position);
			convertView.setTag(R.id.tag_object, json);
			holderview.nameText.setText(json.optString("name"));
			switch (json.optInt("type")) {
			case WEIXING:
				holderview.icon.setImageResource(R.drawable.share_wechat);
				break;
			case PENYOUCHUAN:
				holderview.icon.setImageResource(R.drawable.share_wechat_circle);
				break;
			case ERWEIMA:
				holderview.icon.setImageResource(R.drawable.share_qrcode);
				break;
			case QQKONGJIAN:
				holderview.icon.setImageResource(R.drawable.share_qzone);
				break;
			case MQQ:
				holderview.icon.setImageResource(R.drawable.share_qq);
				break;
			case COPEURL:
				holderview.icon.setImageResource(R.drawable.share_copy);
				break;
			case DUANXIN:
				holderview.icon.setImageResource(R.drawable.share_sms);
				break;
				case WEIBO:
					holderview.icon.setImageResource(R.drawable.share_sina);
					break;
			default:
				break;
			}

			return convertView;
		}

		class Holderview {
			private ImageView icon;
			private TextView nameText;
		}
	}

	private class GetMoneyTask implements JsonTaskHandler {

		@Override
		public void task_response(String json_str) {
			// TODO Auto-generated method stub
			hideLoadingDialog_mt();
			try {
				JSONObject all = new JSONObject(json_str);
				if (Run.checkRequestJson(mActivity, all)) {
					JSONObject dataJson = all.optJSONObject("data");
					if (dataJson != null) {
						sharedUrl=dataJson.optString("link");
						IconLink=dataJson.optString("qrcode");
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		@Override
		public JsonRequestBean task_request() {
			// TODO Auto-generated method stub
			showCancelableLoadingDialog();
			JsonRequestBean bean = new JsonRequestBean(Run.API_URL, "b2c.wallet.collect");
			bean.addParams("money", money);
			bean.addParams("collect_desc", mCollectDesc);
			return bean;
		}

	}

	@Override
	public String getShareText() {

		return getString(R.string.app_name);
	}

	@Override
	public String getShareImageFile() {// 已存在本地的图片
		Bitmap bitmap = BitmapFactory.decodeResource(mActivity.getResources(), R.drawable.comm_icon_launcher);
		Util.saveBitmap("share_image", bitmap);
		return Util.getPath() + "/share_image";
	}

	@Override
	public String getShareImageUrl() { // 分享商品图片url
		return LoginedUser.getInstance().getAvatarUri();
	}

	@Override
	public String getShareUrl() {
		return sharedUrl;
	}

	public String getMessage() {

		return mLoginedUser.getName() + "直接收款";
	}

}
