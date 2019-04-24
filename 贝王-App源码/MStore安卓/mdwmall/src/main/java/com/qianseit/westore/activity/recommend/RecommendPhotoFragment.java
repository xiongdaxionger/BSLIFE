package com.qianseit.westore.activity.recommend;

import java.io.File;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

import us.pinguo.edit.sdk.base.PGEditSDK;
import us.pinguo.edit.sdk.sample.PGEditActivity;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.text.format.DateFormat;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.widget.AdapterView;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ListPopupWindow;
import android.widget.TextView;

import com.qianseit.multiImageSelector.BaseMultiImageSelectorFragment;
import com.qianseit.multiImageSelector.BaseMultiImageSelectorFragment.Callback;
import com.qianseit.multiImageSelector.MultiImageSelectorFragment;
import com.qianseit.multiImageSelector.adapter.FolderAdapter;
import com.qianseit.multiImageSelector.bean.Folder;
import com.qianseit.multiImageSelector.bean.Image;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.CropperActivity;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.util.ChooseUtils;
import com.qianseit.westore.util.loader.ClipPictureBean;
import com.beiwangfx.R;

public class RecommendPhotoFragment extends BaseDoFragment implements Callback {

	private final int PHOTO_GRAPH = 0X100;
	
	/** 最大图片选择次数，int类型，默认9 */
	public static final String EXTRA_SELECT_COUNT = "max_select_count";
	/** 图片选择模式，默认多选 */
	public static final String EXTRA_SELECT_MODE = "select_count_mode";
	/** 是否显示相机，默认显示 */
	public static final String EXTRA_SHOW_CAMERA = "show_camera";
	/** 选择结果，返回为 ArrayList&lt;String&gt; 图片路径集合 */
	public static final String EXTRA_RESULT = "select_result";
	/** 默认选择集 */
	public static final String EXTRA_DEFAULT_SELECTED_LIST = "default_list";

	/** 单选 */
	public static final int MODE_SINGLE = 0;
	/** 多选 */
	public static final int MODE_MULTI = 1;

	private ArrayList<String> resultList = new ArrayList<String>();
	private int mDefaultCount;

	Bundle mBundle;
	ListPopupWindow mFolderPopupWindow;
	private FolderAdapter mFolderAdapter;
	TextView mCategoryTextView;
	BaseMultiImageSelectorFragment mMultiImageSelectorFragment;
	int mGridWidth, mGridHeight;
	FrameLayout mContentFrameLayout;
	
	private LinearLayout mBottomAlbum;
	private TextView mPhotographText;
	private File f;

	private ChooseUtils chooseInfo;
	int reque;
	private String mID;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);

		mActionBar.setShowTitleBar(false);
		Intent intent = mActivity.getIntent();
		mDefaultCount = intent.getIntExtra(EXTRA_SELECT_COUNT, 9);
		int mode = intent.getIntExtra(EXTRA_SELECT_MODE, MODE_SINGLE);
		boolean isShow = intent.getBooleanExtra(EXTRA_SHOW_CAMERA, false);
		if (mode == MODE_MULTI && intent.hasExtra(EXTRA_DEFAULT_SELECTED_LIST)) {
			resultList = intent.getStringArrayListExtra(EXTRA_DEFAULT_SELECTED_LIST);
		}

		mBundle = new Bundle();
		mBundle.putInt(MultiImageSelectorFragment.EXTRA_SELECT_COUNT, mDefaultCount);
		mBundle.putInt(MultiImageSelectorFragment.EXTRA_SELECT_MODE, mode);
		mBundle.putBoolean(MultiImageSelectorFragment.EXTRA_SHOW_CAMERA, isShow);
		mBundle.putStringArrayList(MultiImageSelectorFragment.EXTRA_DEFAULT_SELECTED_LIST, resultList);

		chooseInfo = (ChooseUtils) intent.getSerializableExtra(getString(R.string.intent_key_serializable));
		mID = intent.getStringExtra("ID");
		reque = intent.getIntExtra("REQUE", 0);
	}

	@Override
	public void onClick(View v) {
		super.onClick(v);
		switch (v.getId()) {
		case R.id.photo_camera:
			f = new File(Environment.getExternalStorageDirectory() + "/DCIM/Camera/" + UUID.randomUUID().toString() + ".png");
			Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
			intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(f));
			startActivityForResult(intent, PHOTO_GRAPH);
			break;
		case R.id.photo_back:
			getActivity().finish();
			break;

		default:
			break;
		}
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		rootView = inflater.inflate(R.layout.fragment_recommend_photo, null);
		mBottomAlbum = (LinearLayout) findViewById(R.id.photo_album_linear);
		mCategoryTextView = (TextView) findViewById(R.id.photo_album_title);
		findViewById(R.id.photo_back).setOnClickListener(this);
		mPhotographText = (TextView) findViewById(R.id.photo_camera);
		mPhotographText.setOnClickListener(this);
		
		// 初始化，加载所有图片
		mCategoryTextView.setText(R.string.folder_all);
		mCategoryTextView.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {

				if (mFolderPopupWindow == null) {
					createPopupFolderList(mGridWidth, mGridHeight);
				}

				if (mFolderPopupWindow.isShowing()) {
					mFolderPopupWindow.dismiss();
				} else {
					mFolderPopupWindow.show();
					int index = mFolderAdapter.getSelectIndex();
					index = index == 0 ? index : index - 1;
					mFolderPopupWindow.getListView().setSelection(index);
				}
			}
		});
		mFolderAdapter = new FolderAdapter(getActivity());

		mMultiImageSelectorFragment = new BaseMultiImageSelectorFragment(this);

		mMultiImageSelectorFragment.setArguments(mBundle);
		mActivity.getSupportFragmentManager().beginTransaction().add(R.id.image_grid, mMultiImageSelectorFragment).commit();

		mContentFrameLayout = (FrameLayout) findViewById(R.id.image_grid);
		mContentFrameLayout.getViewTreeObserver().addOnGlobalLayoutListener(new OnGlobalLayoutListener() {

			@SuppressLint("NewApi")
			@Override
			public void onGlobalLayout() {
				// TODO Auto-generated method stub
				final int width = mContentFrameLayout.getWidth();
				final int height = mContentFrameLayout.getHeight();

				mGridWidth = width;
				mGridHeight = height;

				if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
					mContentFrameLayout.getViewTreeObserver().removeOnGlobalLayoutListener(this);
				} else {
					mContentFrameLayout.getViewTreeObserver().removeGlobalOnLayoutListener(this);
				}
			}
		});

	}

	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		// TODO Auto-generated method stub
		if (mFolderPopupWindow != null) {
			if (mFolderPopupWindow.isShowing()) {
				mFolderPopupWindow.dismiss();
			}
		}

		findViewById(R.id.photo_top).getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
			@Override
			@TargetApi(Build.VERSION_CODES.JELLY_BEAN)
			public void onGlobalLayout() {

				final int height = mActivity.findViewById(R.id.photo_top).getHeight();

				if (mFolderPopupWindow != null) {
					mFolderPopupWindow.setHeight(height * 5 / 8);
				}

				if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
					mActionBar.getViewTreeObserver().removeOnGlobalLayoutListener(this);
				} else {
					mActionBar.getViewTreeObserver().removeGlobalOnLayoutListener(this);
				}
			}
		});

		super.onConfigurationChanged(newConfig);
	}

	/**
	 * 创建弹出的ListView
	 */
	private void createPopupFolderList(int width, int height) {
		mFolderPopupWindow = new ListPopupWindow(mActivity);
		mFolderPopupWindow.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		mFolderPopupWindow.setAdapter(mFolderAdapter);
		mFolderPopupWindow.setContentWidth(width);
		mFolderPopupWindow.setWidth(width);
		mFolderPopupWindow.setHeight(height * 5 / 8);
		 mFolderPopupWindow.setAnchorView(findViewById(R.id.photo_top));

		mFolderPopupWindow.setModal(true);
		mFolderPopupWindow.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {

				mFolderAdapter.setSelectIndex(i);

				final int index = i;
				final AdapterView v = adapterView;
				if (index == 0) {
					mCategoryTextView.setText(R.string.folder_all);
				} else {
					Folder folder = (Folder) v.getAdapter().getItem(index);
					mCategoryTextView.setText(folder.name);
				}

				Folder folder = (Folder) v.getAdapter().getItem(index);
				List<Image> nImages = new ArrayList<Image>();
				if (null != folder) {
					nImages = folder.images;
				}
				mMultiImageSelectorFragment.displayFolderImages(index == 0, nImages);

				mFolderPopupWindow.dismiss();
			}
		});
	}

	/**
	 * 调用系统截图工具裁剪图片
	 */
	private void gotoCrop(String path) {
		Bundle bundle = new Bundle();
		ClipPictureBean clipPictureBean = new ClipPictureBean();
		clipPictureBean.setSrcPath(path);
		clipPictureBean.setOutputX(150);
		clipPictureBean.setOutputY(150);
		clipPictureBean.setAspectX(1);
		clipPictureBean.setAspectY(1);
		bundle.putSerializable(getString(R.string.intent_key_serializable), clipPictureBean);
		bundle.putSerializable(getString(R.string.intent_key_chooses), chooseInfo);

		bundle.putSerializable(getString(R.string.intent_key_serializable), clipPictureBean);

		Intent intent = new Intent(mActivity, CropperActivity.class);

		intent.putExtras(bundle);
        intent.putExtra(Run.EXTRA_DATA, "filter");
		mActivity.startActivityForResult(intent, reque);
	}

	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (resultCode != Activity.RESULT_OK) {
			return;
		}
		// 拍照
		if (requestCode == PHOTO_GRAPH) {

			String sdStatus = Environment.getExternalStorageState();
			if (!sdStatus.equals(Environment.MEDIA_MOUNTED)) { // 检测sd是否可用
				Log.i("TestFile", "SD card is not avaiable/writeable right now.");
				return;
			}
			if (!f.exists())
				return;
			gotoCrop(f.getAbsolutePath());
		} else if (requestCode == reque) {
			String imagePath = data.getStringExtra("imagePath");
			String outpath = com.qianseit.westore.util.FileConfig.PATH_BASE + new DateFormat().format("yyyyMMdd_hhmmss", Calendar.getInstance(Locale.CHINA)) + ".jpg";
			PGEditSDK editSDK = PGEditSDK.instance();
			editSDK.startEdit(mActivity, PGEditActivity.class, imagePath, outpath);

		} else {// 上传头像
			mActivity.setResult(resultCode, data);
			getActivity().finish();
		}

	}

	@Override
	public void onSingleImageSelected(String path) {
		gotoCrop(path);
	}

	@Override
	public void onImageSelected(String path) {
		// if(!resultList.contains(path)) {
		// resultList.add(path);
		// }
		// // 有图片之后，改变按钮状态
		// if(resultList.size() > 0){
		// mSubmitButton.setText("完成("+resultList.size()+"/"+mDefaultCount+")");
		// if(!mSubmitButton.isEnabled()){
		// mSubmitButton.setEnabled(true);
		// }
		// }
	}

	@Override
	public void onImageUnselected(String path) {
		// if(resultList.contains(path)){
		// resultList.remove(path);
		// mSubmitButton.setText("完成("+resultList.size()+"/"+mDefaultCount+")");
		// }else{
		// mSubmitButton.setText("完成("+resultList.size()+"/"+mDefaultCount+")");
		// }
		// // 当为选择图片时候的状态
		// if(resultList.size() == 0){
		// mSubmitButton.setText("完成");
		// mSubmitButton.setEnabled(false);
		// }
	}

	@Override
	public void onCameraShot(File imageFile) {
		if (imageFile != null) {
			Intent data = new Intent();
			resultList.add(imageFile.getAbsolutePath());
			data.putStringArrayListExtra(EXTRA_RESULT, resultList);
			mActivity.setResult(Activity.RESULT_OK, data);
			mActivity.finish();
		}
	}

	@Override
	public void onLoadImages(ArrayList<Folder> arrayList) {
		// TODO Auto-generated method stub
		mFolderAdapter.setData(arrayList);
	}
}
