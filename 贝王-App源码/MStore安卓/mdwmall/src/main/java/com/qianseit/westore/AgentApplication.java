package com.qianseit.westore;

import im.fir.sdk.FIR;

import java.net.CookieHandler;
import java.net.CookieManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.json.JSONObject;

import us.pinguo.edit.sdk.PGEditImageLoader;
import us.pinguo.edit.sdk.base.PGEditSDK;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.Application;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Typeface;
import android.text.TextUtils;
import android.util.Log;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.wechat.friends.Wechat;

import com.beiwangfx.R;
import com.nostra13.universalimageloader.cache.disc.impl.UnlimitedDiscCache;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;
import com.nostra13.universalimageloader.core.decode.BaseImageDecoder;
import com.nostra13.universalimageloader.core.download.BaseImageDownloader;
import com.qianseit.westore.activity.acco.AccoSettingFragment;
import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.http.CookieHelper;
import com.qianseit.westore.httpinterface.index.ServiceTimeInterface;
import com.qianseit.westore.httpinterface.member.MemberIndexInterface;
import com.qianseit.westore.httpinterface.passport.LoginInterface;
import com.qianseit.westore.httpinterface.passport.ThirdUserLoginInterface;
import com.qianseit.westore.httpinterface.setting.SendXGTokenInterface;
import com.qianseit.westore.util.loader.FileUtils;
import com.tencent.android.tpush.XGNotifaction;
import com.tencent.android.tpush.XGPushManager;
import com.tencent.android.tpush.XGPushNotifactionCallback;

public class AgentApplication extends Application {
	private LoginedUser mLoginedUser;

	public Bitmap mAvatarMask, mAvatarCover;
	public String payMoney;// 充值金额

	private ArrayList<Activity> mRecentActivies = new ArrayList<Activity>();

	public JSONObject mOrderDetail;
	public boolean gotoMyFavorite = false;
	private Typeface typeface;
	private static AgentApplication instance;
	public static String XGToken = "";

	///全局context
	private static Context context;

	public static Context getContext() {

		return context;
	}

	public boolean isMainProcess() {
		ActivityManager am = ((ActivityManager) getSystemService(Context.ACTIVITY_SERVICE));
		List<RunningAppProcessInfo> processInfos = am.getRunningAppProcesses();
		String mainProcessName = getPackageName();
		int myPid = android.os.Process.myPid();
		for (RunningAppProcessInfo info : processInfos) {
			if (info.pid == myPid && mainProcessName.equals(info.processName)) {
				return true;
			}
		}


		return false;
	}

	@Override
	public void onCreate() {

		super.onCreate();
		FIR.init(this);
		initImageLoader(this);

		// 初始化滤镜
		PGEditImageLoader.initImageLoader(this);
		PGEditSDK.instance().initSDK(this);
		// //创建默认的ImageLoader配置参数
		// ImageLoaderConfiguration configuration = ImageLoaderConfiguration
		// .createDefault(this);
		//
		// //Initialize ImageLoader with configuration.
		// ImageLoader.getInstance().init(configuration);

		// ShareSDK
		ShareSDK.initSDK(this, "136ce5af7e8ac");

		instance = this;

		// 信鸽处理
		if (isMainProcess()) {
			// 为保证弹出通知前一定调用本方法，需要在application的onCreate注册
			// 收到通知时，会调用本回调函数。
			// 相当于这个回调会拦截在信鸽的弹出通知之前被截取
			// 一般上针对需要获取通知内容、标题，设置通知点击的跳转逻辑等等
			XGPushManager.setNotifactionCallback(new XGPushNotifactionCallback() {

				@Override
				public void handleNotify(XGNotifaction xGNotifaction) {
					Log.i("test", "处理信鸽通知：" + xGNotifaction);
					if (!Run.loadOptionBoolean(AgentApplication.this, AccoSettingFragment.WURAOMODE, false)) {
						// 获取标签、内容、自定义内容
						// 其它的处理
						// 如果还要弹出通知，可直接调用以下代码或自己创建Notifaction，否则，本通知将不会弹出在通知栏中。
						xGNotifaction.doNotify();
					}
				}
			});
		}

		// 头像
		Resources resources = getResources();
		mAvatarMask = BitmapFactory.decodeResource(resources, R.drawable.base_avatar_default);

		// 错误信息收集
		CrashHandler crashHandler = CrashHandler.getInstance();
		crashHandler.init(getApplicationContext());

		// cookie管理
		CookieManager cookieManager = null;
		cookieManager = new CookieManager(null, null);
		CookieHandler.setDefault(cookieManager);

		mLoginedUser = LoginedUser.getInstance();

		this.userAutoLogin();

		context = getApplicationContext();
	}

	public static AgentApplication getInstance() {
		return instance;
	}

	public Typeface getTypeface() {
		return typeface;
	}

	public static void initImageLoader(Context context) {
		// This configuration tuning is custom. You can tune every option, you
		// may tune some of them,
		// or you can create default configuration by
		// ImageLoaderConfiguration.createDefault(this);
		// method.
		ImageLoaderConfiguration.Builder config = new ImageLoaderConfiguration.Builder(context);
		config.threadPriority(Thread.NORM_PRIORITY - 1);
		// config.denyCacheImageMultipleSizesInMemory();
		// config.memoryCache(new WeakMemoryCache());
		config.threadPoolSize(3);
		config.diskCacheFileNameGenerator(new Md5FileNameGenerator());
		config.imageDownloader(new BaseImageDownloader(context));
		config.imageDecoder(new BaseImageDecoder(false));
		config.defaultDisplayImageOptions(DisplayImageOptions.createSimple());
		// config.diskCacheSize(800 * 1024 * 1024);
		// config.diskCacheSize(50 * 1024 * 1024); // 50 MiB
		config.tasksProcessingOrder(QueueProcessingType.LIFO);
		config.writeDebugLogs(); // Remove for release app
		config.diskCache(new UnlimitedDiscCache(FileUtils.getImageCacheDir())).diskCacheFileCount(800).diskCacheSize(800 * 1024 * 1024);

		// Initialize ImageLoader with configuration.
		ImageLoader.getInstance().init(config.build());
	}

	// 自动登录
	public void userAutoLogin() {
		if (!TextUtils.isEmpty(Run.loadOptionString(this, Run.pk_logined_username, Run.EMPTY_STR)) && !TextUtils.isEmpty(Run.loadOptionString(this, Run.pk_logined_user_password, Run.EMPTY_STR))) {
			LoginInterface nLoginInterface = new LoginInterface(mActivityInterface) {

				@Override
				public void SuccCallBack(JSONObject responseJson) {
					// TODO Auto-generated method stub
					new MemberIndexInterface(mActivityInterface) {

						@Override
						public void responseSucc() {
							// TODO Auto-generated method stub

						}
					}.RunRequest();
				}

				@Override
				public void task_response(String json_str) {
					Run.goodsCounts = CookieHelper.getCarQty();
					mBaseActivity.hideLoadingDialog_mt();
					try {
						JSONObject all = new JSONObject(json_str);
						if (checkRequestJson(mBaseActivity.getContext(), all, false)) {
							JSONObject nJsonObject = all.optJSONObject("data");
							SuccCallBack(nJsonObject == null ? all : nJsonObject);
						} else {
							mErrorJsonObject = all;
							FailRequest();
						}
					} catch (Exception e) {
						FailRequest();
					}
				}
			};

			String nUName = Run.loadOptionString(this, Run.pk_logined_username, Run.EMPTY_STR);
			String nPwd = Run.loadOptionString(this, Run.pk_logined_user_password, Run.EMPTY_STR);
			nLoginInterface.setLoginInfo(nUName, nPwd, "");
			nLoginInterface.RunRequest();
		}else if(!TextUtils.isEmpty(Run.loadOptionString(this, Run.pk_third_platform, Run.EMPTY_STR))){
			String nPlatform = Run.loadOptionString(this, Run.pk_third_platform, Run.EMPTY_STR);
			String nPlat = nPlatform.equals(ThirdUserLoginInterface.PLATFORM_QQ)?QQ.NAME:(nPlatform.equals(ThirdUserLoginInterface.PLATFORM_WECHAT)?Wechat.NAME:SinaWeibo.NAME);
			Platform platWB = ShareSDK.getPlatform(this, nPlat);
			platWB.setPlatformActionListener(new ThirdLoginListener(nPlatform));
			platWB.SSOSetting(false);// 设置为false或者不设置这个值，如果设置为 true 则调用客户端
			platWB.showUser(null);
		}

		new ServiceTimeInterface(mActivityInterface);
	}

	@Override
	public void onTerminate() {
		ShareSDK.stopSDK(this);
		mLoginedUser.clearLoginedStatus();
		super.onTerminate();
	}

	/**
	 * 正在查看的订单
	 *
	 * @param mOrderDetail
	 */
	public void setOrderDetail(JSONObject mOrderDetail) {
		this.mOrderDetail = mOrderDetail;
	}

	/**
	 * 打开的Activity历史
	 *
	 * @return
	 */
	public ArrayList<Activity> getRecentActivies() {
		return mRecentActivies;
	}

	/**
	 * 获取App代理
	 *
	 * @param context
	 * @return
	 */
	public static AgentApplication getApp(Context context) {
		return (AgentApplication) context.getApplicationContext();
	}

	/**
	 * 登录的用户
	 *
	 * @return
	 */
	public LoginedUser getLoginedUser() {
		return mLoginedUser;
	}

	QianseitActivityInterface mActivityInterface = new QianseitActivityInterface() {

		@Override
		public void showLoadingDialog() {
			// TODO Auto-generated method stub

		}

		@Override
		public void showCancelableLoadingDialog() {
			// TODO Auto-generated method stub

		}

		@Override
		public void hideLoadingDialog_mt() {
			// TODO Auto-generated method stub

		}

		@Override
		public void hideLoadingDialog() {
			// TODO Auto-generated method stub

		}

		@Override
		public Context getContext() {
			// TODO Auto-generated method stub
			return AgentApplication.this;
		}
	};

	ThirdUserLoginInterface mThirdUserLoginInterface = new ThirdUserLoginInterface(mActivityInterface) {

		@Override
		public void loginSuccessWeibo(String weiboId, String weboToken) {
			// TODO Auto-generated method stub
			if (isBindMobile()) {
				new MemberIndexInterface(mActivityInterface) {

					@Override
					public void responseSucc() {
						// TODO Auto-generated method stub
					}
				}.RunRequest();
			}
		}

		@Override
		public void loginSuccessOther() {
			// TODO Auto-generated method stub
			if (isBindMobile()) {
				new MemberIndexInterface(mActivityInterface) {

					@Override
					public void responseSucc() {
						// TODO Auto-generated method stub
					}
				}.RunRequest();
			}
		}
	};

	private class ThirdLoginListener implements PlatformActionListener {
		private String platformName;

		public ThirdLoginListener(String platName) {
			this.platformName = platName;
		}

		@Override
		public void onError(Platform arg0, int arg1, Throwable arg2) {
			System.out.println("-------" + arg2.getMessage() + "--------");
			arg2.printStackTrace();
		}

		@Override
		public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
			mThirdUserLoginInterface.Login(platformName, arg0, arg2);
		}

		@Override
		public void onCancel(Platform arg0, int arg1) {
			System.out.println("-------MSG_AUTH_CANCEL--------");
			Run.log("onCancel:", arg1);
		}

	}

	/**
	 * 登录的用户
	 *
	 * @return
	 */
	public static LoginedUser getLoginedUser(Context context) {
		return AgentApplication.getApp(context).getLoginedUser();
	}

	public void sendToken() {
		if (TextUtils.isEmpty(XGToken)) {
			return;
		}
		new SendXGTokenInterface(mActivityInterface, XGToken) {
			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				XGToken = "";
			}
		}.RunRequest();

	}
}
