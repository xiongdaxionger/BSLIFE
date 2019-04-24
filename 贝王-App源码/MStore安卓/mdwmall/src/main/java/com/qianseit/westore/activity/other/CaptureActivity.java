package com.qianseit.westore.activity.other;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Context;
import android.app.Dialog;
import android.content.Intent;
import android.content.res.AssetFileDescriptor;
import android.graphics.Bitmap;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.Vibrator;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.KeyEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import android.view.SurfaceView;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.Result;
import com.google.zxing.camera.CameraManager;
import com.google.zxing.decoding.CaptureActivityHandler;
import com.google.zxing.decoding.InactivityTimer;
import com.google.zxing.view.ViewfinderView;
import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;
import com.qianseit.westore.ui.LoadingDialog;

import org.json.JSONObject;

import java.io.IOException;
import java.util.Vector;

public class CaptureActivity extends Activity implements Callback ,OnClickListener , QianseitActivityInterface{

	private final int REQUEST_MEMBER_LOGIN_FOR_STARACTIVITY = 0x1001;
	private final int HANDLE_HIDE_LOADING_DIALOG = 100;
	private final int HANDLE_SHOW_LOADING_DIALOG = 101;
	private final int HANDLE_SHOW_CANCEL_LOADING_DIALOG = 102;

	private CaptureActivityHandler handler;
	private ViewfinderView viewfinderView;
	private boolean hasSurface;
	private Vector<BarcodeFormat> decodeFormats;
	private String characterSet;
	private InactivityTimer inactivityTimer;
	private MediaPlayer mediaPlayer;
	private boolean playBeep;
	private final float BEEP_VOLUME = 0.10f;
	private boolean vibrate;

	
	boolean canFinish = true;


	private LoadingDialog progress1;
	boolean mProgressIsShow = false;

	Dialog mDialog;
	
	RelativeLayout mScanAreaLayout;
	View mScanLineView;
	TranslateAnimation mScanAnimation;
	
	/**
	 * 请求扫描内容，扫描到内容后直接返回，交由调用扫描者处理
	 */
	boolean isRequstContent = false;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.other_capture);
		// 初始化 CameraManager
		CameraManager.init(getApplication());

		viewfinderView = (ViewfinderView) findViewById(R.id.viewfinder_view);
		hasSurface = false;
		inactivityTimer = new InactivityTimer(this);
		findViewById(R.id.scanner_back).setOnClickListener(this);
		
		mScanAreaLayout = (RelativeLayout) findViewById(R.id.scan_area);
		
		DisplayMetrics dm = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(dm);
		int nScanAreaSize = (int) (dm.widthPixels * 0.8);
		
		RelativeLayout.LayoutParams nLayoutParams = (LayoutParams) mScanAreaLayout.getLayoutParams();
		nLayoutParams.height = nScanAreaSize;
		nLayoutParams.width = nScanAreaSize;
		nLayoutParams.leftMargin = (dm.widthPixels - nScanAreaSize) / 2;
		nLayoutParams.topMargin = (dm.heightPixels - nScanAreaSize) / 2;
		mScanLineView = findViewById(R.id.scan_line);
		BaseDoFragment.setViewAbsoluteSize(mScanLineView, nScanAreaSize, Run.dip2px(this, 1));
		mScanAnimation = new TranslateAnimation(0, 0, 0, nScanAreaSize);
		mScanAnimation.setDuration(3000);
		mScanAnimation.setRepeatMode(Animation.RESTART);
		mScanAnimation.setRepeatCount(10000);
		mScanLineView.setAnimation(mScanAnimation);
		
		isRequstContent = getIntent().getBooleanExtra(Run.EXTRA_DETAIL_TYPE, false);
	}

	@Override
	protected void onResume() {
		super.onResume();
		/**
		 * 这里就是一系列初始化相机view的过程
		 */
		SurfaceView surfaceView = (SurfaceView) findViewById(R.id.preview_view);
		SurfaceHolder surfaceHolder = surfaceView.getHolder();
		if (hasSurface) {
			initCamera(surfaceHolder);
		} else {
			surfaceHolder.addCallback(this);
			surfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
		}
		decodeFormats = null;
		characterSet = null;

		/**
		 * 这里就是看看是否是正常声音播放模式，如果是就播放声音，如果不是，则不播放
		 */
		playBeep = true;
		AudioManager audioService = (AudioManager) getSystemService(AUDIO_SERVICE);
		if (audioService.getRingerMode() != AudioManager.RINGER_MODE_NORMAL) {
			playBeep = false;
		}
		/**
		 * 初始化声音
		 */
		initBeepSound();
		/**
		 * 是否震动
		 */
		vibrate = true;
		
		mScanAnimation.startNow();
		mScanAreaLayout.setVisibility(View.VISIBLE);
	}
	
	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.scanner_back) {
			back();
		}
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		// TODO Auto-generated method stub
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			back();
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}
	
	void back(){
		if (canFinish) {
			finish();
		}else{
			canFinish = true;
//			drawViewfinder();
			handler.restartPreviewAndDecode();
			mScanAnimation.startNow();
			mScanAreaLayout.setVisibility(View.VISIBLE);
		}
	}
	
	@Override
	protected void onPause() {
		super.onPause();
		/**
		 * 关掉相机，关掉解码线程，清空looper队列中message
		 */
		if (handler != null) {
			handler.quitSynchronously();
			handler = null;
		}
		CameraManager.get().closeDriver();// 关掉相机
		mScanAnimation.cancel();
	}

	@Override
	protected void onDestroy() {
		inactivityTimer.shutdown();
		super.onDestroy();
	}

	/**
	 * 初始化相机
	 */
	private void initCamera(SurfaceHolder surfaceHolder) {
		try {
			CameraManager.get().openDriver(surfaceHolder);
		} catch (IOException ioe) {
			ioe.printStackTrace();
			alertErrorMsg();
			return;
		} catch (RuntimeException e) {
			e.printStackTrace();
			alertErrorMsg();
			return;
		}
		if (handler == null) {
			/**
			 * 新建解码结果handler
			 */
			handler = new CaptureActivityHandler(this, decodeFormats,
					characterSet);
		}
	}

//	提示错误信息
	private void alertErrorMsg(){
		mDialog = CommonLoginFragment.showAlertDialog(this, "无法获取摄像头数据，请检查是否已打开摄像头权限", "确定",
				new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						mDialog.dismiss();

						CaptureActivity.this.finish();
					}
				});
	}

	@Override
	public void surfaceChanged(SurfaceHolder holder, int format, int width,
			int height) {

	}

	@Override
	public void surfaceCreated(SurfaceHolder holder) {
		/**
		 * 初始化相机
		 */
		if (!hasSurface) {
			hasSurface = true;
			initCamera(holder);
		}
	}

	@Override
	public void surfaceDestroyed(SurfaceHolder holder) {
		hasSurface = false;
	}

	/**
	 * 返回显示的view
	 */
	public ViewfinderView getViewfinderView() {
		return viewfinderView;
	}

	/**
	 * 返回处理解码结果的handler
	 */
	public Handler getHandler() {
		return handler;
	}

	/**
	 * 清空view中先前扫描成功的图片
	 */
	public void drawViewfinder() {
		viewfinderView.drawViewfinder();

	}

	public void handleDecode(final Result obj, Bitmap barcode) {
		/**
		 * 重新计时
		 */
		inactivityTimer.onActivity();
		/**
		 * 将结果绘制到view中
		 */
		viewfinderView.drawResultBitmap(barcode);
		/**
		 * 播放jeep声音
		 */
		playBeepSoundAndVibrate();
		/**
		 * 显示解码字符串
		 */
//		txtResult.setText(obj.getBarcodeFormat().toString() + ":"
//				+ obj.getText());

		final String contents = obj.getText();
		if (isRequstContent) {
			Intent nIntent = new Intent();
			nIntent.putExtra(Run.EXTRA_SCAN_REZULT, contents);
			this.setResult(Activity.RESULT_OK, nIntent);
			finish();
			return;
		}

		String nProductKey = "product-";
		if (!contents.contains("product-")){
			nProductKey = "product_id=";
			if(!contents.contains("product_id=")){
				nProductKey = "";
			}
		}

		if (contents.startsWith(Run.DOMAIN) && !TextUtils.isEmpty(nProductKey)) {
			int index = contents.indexOf(nProductKey);
			int end = contents.indexOf('.', index);
			if(end <= 0)end = contents.indexOf('&', index);
			if (end <= 0) {
				end = contents.length();
			}
			startActivity(AgentActivity.intentForFragment(this, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, contents.substring(index + nProductKey.length(), end)));
			return;
		} else if (contents.contains("http")){
			Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(contents));
			intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET);
			startActivity(intent);
		} else {
//			Run.alert(this, "请扫描商品条码");
			canFinish = false;
			mScanAnimation.cancel();
			mScanAreaLayout.setVisibility(View.GONE);

			BaseHttpInterfaceTask task = new BaseHttpInterfaceTask(this) {
				@Override
				public String InterfaceName() {
					return "b2c.product.bnParams";
				}

				@Override
				public ContentValues BuildParams() {

					ContentValues values = new ContentValues();
					values.put("bn", contents);
					return values;
				}

				@Override
				public void SuccCallBack(JSONObject responseJson) {
					JSONObject object = responseJson.optJSONObject("goods");
					if(object != null){
						String productId = object.optString("product_id");
						startActivity(AgentActivity.intentForFragment(CaptureActivity.this, AgentActivity
								.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, productId));
					}else {
						Run.alert(CaptureActivity.this, "请扫描商品条码");
					}
				}
			};
			task.RunRequest();
		}
		
	}

	private void initBeepSound() {
		if (playBeep && mediaPlayer == null) {
			// The volume on STREAM_SYSTEM is not adjustable, and users found it
			// too loud,
			// so we now play on the music stream.
			setVolumeControlStream(AudioManager.STREAM_MUSIC);
			mediaPlayer = new MediaPlayer();
			mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
			mediaPlayer.setOnCompletionListener(beepListener);

			AssetFileDescriptor file = getResources().openRawResourceFd(
					R.raw.beep);
			try {
				mediaPlayer.setDataSource(file.getFileDescriptor(),
						file.getStartOffset(), file.getLength());
				file.close();
				mediaPlayer.setVolume(BEEP_VOLUME, BEEP_VOLUME);
				mediaPlayer.prepare();
			} catch (IOException e) {
				mediaPlayer = null;
			}
		}
	}

	/**
	 * 震动时间
	 */
	private final long VIBRATE_DURATION = 200L;

	private void playBeepSoundAndVibrate() {
		/**
		 * 播放声音
		 */
		if (playBeep && mediaPlayer != null) {
			mediaPlayer.start();
		}
		/**
		 * 震动
		 */
		if (vibrate) {
			Vibrator vibrator = (Vibrator) getSystemService(VIBRATOR_SERVICE);
			vibrator.vibrate(VIBRATE_DURATION);
		}
	}

	/**
	 * When the beep has finished playing, rewind to queue up another one.
	 */
	private final OnCompletionListener beepListener = new OnCompletionListener() {
		public void onCompletion(MediaPlayer mediaPlayer) {
			mediaPlayer.seekTo(0);
		}
	};

	/**
	 * 显示加载提示框
	 */
	public void showLoadingDialog() {
		mProgressIsShow = true;
		tHandler.sendEmptyMessage(HANDLE_SHOW_LOADING_DIALOG);
	}

	/**
	 * 显示可以取消的提示框
	 */
	public void showCancelableLoadingDialog() {
		mProgressIsShow = true;
		tHandler.sendEmptyMessage(HANDLE_SHOW_CANCEL_LOADING_DIALOG);
	}

	/**
	 * 主线程直接调用显示可以取消的提示框<br/>
	 */
	public void showCancelableLoadingDialog_mt() {
		// if (progress != null && progress.isShowing())
		// progress.dismiss();
		// progress = Util.showLoadingDialog(getActivity(), null, null);
		// if (progress != null)
		// progress.setCancelable(true);
		mProgressIsShow = true;
		if (progress1 != null && progress1.isShowing())
			progress1.dismiss();
		progress1 = new LoadingDialog(this);
		progress1.show();
		if (progress1 != null)
			progress1.setCancelable(true);

	}

	// 隐藏提示框
	public void hideLoadingDialog() {
		mProgressIsShow = false;
		tHandler.sendEmptyMessageDelayed(HANDLE_HIDE_LOADING_DIALOG, 1000);
	}

	/**
	 * 主线程直接调用取消提示框<br/>
	 */
	public void hideLoadingDialog_mt() {
		// Util.hideLoading(progress);
		mProgressIsShow = false;
		if (progress1 != null) {
			progress1.dismiss();
		}
	}

	@Override
	public Context getContext() {
		return this;
	}

	private Handler tHandler = new Handler() {
		public void handleMessage(Message msg) {
			switch (msg.what) {
				case HANDLE_SHOW_LOADING_DIALOG:
					// if (progress != null && progress.isShowing())
					// progress.dismiss();
					// progress = Util.showLoadingDialog(mActivity, null, null);
					// if (progress != null)
					// progress.setCancelable(false);

					if (progress1 != null && progress1.isShowing())
						progress1.dismiss();
					if (mProgressIsShow) {
						progress1 = new LoadingDialog(CaptureActivity.this);
						progress1.show();
						if (progress1 != null) {
							progress1.setCancelable(false);
						}
					}
					break;
				case HANDLE_SHOW_CANCEL_LOADING_DIALOG:
					if (mProgressIsShow) {
						showCancelableLoadingDialog_mt();
					}

					break;
				case HANDLE_HIDE_LOADING_DIALOG:
					hideLoadingDialog_mt();
					break;
			}
		}
	};
}