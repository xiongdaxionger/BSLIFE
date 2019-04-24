package com.qianseit.westore.activity;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Point;
import android.os.Bundle;
import android.text.format.DateFormat;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.LinearLayout;

import com.edmodo.cropper.CropImageView;
import com.beiwangfx.R;;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.shopping.ShoppingLableActivity;
import com.qianseit.westore.base.DoActivity;
import com.qianseit.westore.util.ChooseUtils;
import com.qianseit.westore.util.FileConfig;
import com.qianseit.westore.util.loader.ClipPictureBean;
import com.qianseit.westore.util.loader.FileUtils;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Calendar;
import java.util.Locale;

import us.pinguo.edit.sdk.base.PGEditResult;
import us.pinguo.edit.sdk.base.PGEditSDK;
import us.pinguo.edit.sdk.sample.PGEditActivity;

public class CropperActivity extends DoActivity {
	private final int REQUEST_CODE_PICK_PICTURE = 0x100001;
	// Static final constants
	private final int DEFAULT_ASPECT_RATIO_VALUES = 10;
	private final int ROTATE_NINETY_DEGREES = 90;
	private final String ASPECT_RATIO_X = "ASPECT_RATIO_X";
	private final String ASPECT_RATIO_Y = "ASPECT_RATIO_Y";
	private final int ON_TOUCH = 1;
	private final int ON = 2;

	// Instance variables
	private int mAspectRatioX = DEFAULT_ASPECT_RATIO_VALUES;
	private int mAspectRatioY = DEFAULT_ASPECT_RATIO_VALUES;
	private Point screenSize;

	Bitmap croppedImage;
	private String imgPaths;
	private String CropperStatus;

	/** 图片裁剪属性 */
	private ClipPictureBean clipPictureBean;
	private ChooseUtils chooseInfo;

	// Saves the state upon rotating the screen/restarting the activity
	@Override
	protected void onSaveInstanceState(Bundle bundle) {
		super.onSaveInstanceState(bundle);
		bundle.putInt(ASPECT_RATIO_X, mAspectRatioX);
		bundle.putInt(ASPECT_RATIO_Y, mAspectRatioY);
	}

	// Restores the state upon rotating the screen/restarting the activity
	@Override
	protected void onRestoreInstanceState(Bundle bundle) {
		super.onRestoreInstanceState(bundle);
		mAspectRatioX = bundle.getInt(ASPECT_RATIO_X);
		mAspectRatioY = bundle.getInt(ASPECT_RATIO_Y);
	}

	@SuppressLint("NewApi")
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		// this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.other_cropper_main);
		screenSize = Run.getScreenSize(getWindowManager());
		clipPictureBean = (ClipPictureBean) this.getIntent().getSerializableExtra(getString(R.string.intent_key_serializable));
		chooseInfo = (ChooseUtils) this.getIntent().getSerializableExtra(getString(R.string.intent_key_chooses));
		// Bitmap bm =FileUtils.getBitMap(clipPictureBean.getSrcPath()) ;
		Bitmap bm = FileUtils.getSmallBitmap(clipPictureBean.getSrcPath(), 720, 1280);
		CropperStatus = this.getIntent().getStringExtra(Run.EXTRA_DATA);

		// Initialize components of the ap
		final CropImageView cropImageView = (CropImageView) findViewById(R.id.CropImageView);
		cropImageView.setImageBitmap(bm);
		int height = screenSize.x * bm.getHeight() / bm.getWidth();
		cropImageView.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, height));
		// 是否显示裁剪框网格线
		cropImageView.setGuidelines(2);
		// 是否限制裁剪比例
		cropImageView.setFixedAspectRatio(true);
		// Sets initial aspect ratio to 10/10, for demonstration purposes

		mAspectRatioX = clipPictureBean.getAspectX();
		mAspectRatioY = clipPictureBean.getAspectY();
		cropImageView.setAspectRatio(mAspectRatioX, mAspectRatioY);

		final Button cropButton = (Button) findViewById(R.id.submit);
		cropButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				croppedImage = cropImageView.getCroppedImage();
				@SuppressWarnings("static-access")
				String paths = FileConfig.PATH_BASE + new DateFormat().format("yyyyMMdd_hhmmss", Calendar.getInstance(Locale.CHINA)) + ".jpg";
				boolean b = saveBitmapToFile(paths, croppedImage);
				if (b) {
					imgPaths = paths;
					// if("IDPHOTE".equals(mID)){
					if ("filter".equals(CropperStatus)) { // 滤镜
						String outpath = com.qianseit.westore.util.FileConfig.PATH_BASE + new DateFormat().format("yyyyMMdd_hhmmss", Calendar.getInstance(Locale.CHINA)) + ".jpg";
						PGEditSDK editSDK = PGEditSDK.instance();
						editSDK.startEdit(CropperActivity.this, PGEditActivity.class, imgPaths, outpath);
					} else {
						Intent mIntent = new Intent();
						mIntent.putExtra("imagePath", paths);
						setResult(RESULT_OK, mIntent);
						finish();
					}

				}

			}
		});
		findViewById(R.id.action_bar_titlebar_lefts).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				finish();
			}
		});
	}

	/**
	 * 保存图片
	 * 
	 * @param saveParentPath
	 *            图片保存路径
	 * @param bitmap
	 *            位图对象
	 */
	public boolean saveBitmapToFile(String saveParentPath, Bitmap bitmap) {

		try {
			File saveimg = new File(saveParentPath);
			if (!saveimg.getParentFile().exists())
				saveimg.getParentFile().mkdirs();

			if (!saveimg.exists())
				saveimg.createNewFile();
			BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(saveimg));
			bitmap.compress(Bitmap.CompressFormat.JPEG, 30, bos);
			bos.flush();
			bos.close();
			return true;
		} catch (IOException e) {
			Log.i("tentinet", e.toString());

			e.printStackTrace();
			return false;
		}
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		if (croppedImage != null) {
			croppedImage.recycle();
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		super.onActivityResult(requestCode, resultCode, data);
		String resultPhotoPath;
		if (requestCode == PGEditSDK.PG_EDIT_SDK_REQUEST_CODE && resultCode == Activity.RESULT_OK) {

			PGEditResult editResult = PGEditSDK.instance().handleEditResult(data);

			// 获取编辑后的缩略图
			// Bitmap thumbNail = editResult.getThumbNail();

			resultPhotoPath = editResult.getReturnPhotoPath();
			Intent intent = new Intent();
			Bundle bundle = new Bundle();
			intent.setClass(CropperActivity.this, ShoppingLableActivity.class);
			bundle.putSerializable(getString(R.string.intent_key_chooses), chooseInfo);
			intent.putExtra("bitmap", resultPhotoPath);
			intent.putExtras(bundle);
			startActivity(intent);
			CropperActivity.this.finish();

		}

		if (requestCode == PGEditSDK.PG_EDIT_SDK_REQUEST_CODE && resultCode == PGEditSDK.PG_EDIT_SDK_RESULT_CODE_CANCEL) {
			// 用户取消编辑
			CropperActivity.this.finish();
		}

		if (requestCode == PGEditSDK.PG_EDIT_SDK_REQUEST_CODE && resultCode == PGEditSDK.PG_EDIT_SDK_RESULT_CODE_NOT_CHANGED) {
			// 照片没有修改
			resultPhotoPath = imgPaths;
			Intent intent = new Intent();
			Bundle bundle = new Bundle();
			intent.setClass(CropperActivity.this, ShoppingLableActivity.class);
			bundle.putSerializable(getString(R.string.intent_key_chooses), chooseInfo);
			intent.putExtra("bitmap", resultPhotoPath);
			intent.putExtras(bundle);
			startActivity(intent);
			CropperActivity.this.finish();
		}
		if (resultCode == 0001) {
			CropperActivity.this.finish();
		}
	}

}
