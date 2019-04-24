package com.qianseit.westore.activity.goods;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RatingBar;
import android.widget.RatingBar.OnRatingBarChangeListener;
import android.widget.TextView;

import com.beiwangfx.R;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.activity.other.MultiImageSelectorActivity;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.goods.GoodsCommentIndexInterface;
import com.qianseit.westore.httpinterface.goods.GoodsCommentPublishInterface;
import com.qianseit.westore.httpinterface.member.MemberUploadImageInterface;
import com.qianseit.westore.util.ImageUtil;
import com.qianseit.westore.util.loader.FileUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class GoodsCommentPublishFragment extends BaseDoFragment {
	final int REQUEST_PFT_FOR_CHOOSE = 1001;
	final int REQUEST_EDIT_SPEC = 1002;
	private final int TAKE_PHOTO_ID = Menu.FIRST;
	private final int SELECT_PHOTO_ID = Menu.FIRST + 1;
	
	ImageView mGoodsImageView;
	RatingBar mGoodsBar;

	EditText mContentEditText, mVCodeEditText;
	TextView mLenTextView;
	TextView mCommentTypeTextView;
	CheckBox mAnonymousBox;
	ImageView mVCodeImageView;

	GridView mImagesGridView;
	ListView mOtherRatListView;

	JSONObject mProductObject;
	JSONObject mDefaultCommentTypeJsonObject;
	String mOrderId;

	private Dialog mDialog;
	File mFile;
	ArrayList<String> mSelectPath;
	
	int mCommetMaxLen = 1000;

	List<ImageViewBean> mImageViewBeans = new ArrayList<ImageViewBean>();
	ImageViewAdapter mImageViewAdapter = new ImageViewAdapter(mImageViewBeans, 0, 6);

	JSONObject mSettingJsonObject;
	boolean mVCodeOn = false;

	List<JSONObject> mOtherRatJsonObjects = new ArrayList<JSONObject>();
	List<JSONObject> mRatJsonObjects = new ArrayList<JSONObject>();
	QianseitAdapter<JSONObject> mOtherRatAdapter = new QianseitAdapter<JSONObject>(mOtherRatJsonObjects) {

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			if (convertView == null) {
				convertView = View.inflate(mActivity, R.layout.item_goods_comment_rat, null);
				RatingBar nRatingBar = (RatingBar) convertView.findViewById(R.id.rat);
				nRatingBar.setIsIndicator(false);
				nRatingBar.setStepSize(1);
				nRatingBar.setOnRatingBarChangeListener(new OnRatingBarChangeListener() {

					@Override
					public void onRatingChanged(RatingBar ratingBar, float rating, boolean fromUser) {
						// TODO Auto-generated method stub
						JSONObject nItem = (JSONObject) ratingBar.getTag();
						try {
							nItem.put("rat", rating);
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						notifyDataSetChanged();
					}
				});
			}
			JSONObject nItem = getItem(position);
			convertView.findViewById(R.id.rat).setTag(nItem);
			((TextView) convertView.findViewById(R.id.name)).setText(nItem.optString("name"));
			((TextView) convertView.findViewById(R.id.points)).setText(String.format("%.1f", nItem.optDouble("rat")));
			((RatingBar) convertView.findViewById(R.id.rat)).setRating((float) nItem.optDouble("rat"));
			return convertView;
		}
	};

	GoodsCommentIndexInterface mCommentInterface = new GoodsCommentIndexInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mSettingJsonObject = responseJson;

			JSONArray nArray = mSettingJsonObject.optJSONArray("comment_goods_type");
			if (nArray != null && nArray.length() > 0) {
				try {
					for (int i = 0; i < nArray.length(); i++) {
						if (i >= 6) {// 最多显示6个评分(包括默认评分)
							break;
						}
						JSONObject nJsonObject = nArray.optJSONObject(i);
						nJsonObject.put("rat", 0);
						mRatJsonObjects.add(nJsonObject);

						if (nJsonObject.optInt("is_default") == 1) {
							nJsonObject.put("rat", 5);
							mDefaultCommentTypeJsonObject = nJsonObject;
						} else {
							mOtherRatJsonObjects.add(nArray.optJSONObject(i));
						}
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				mOtherRatAdapter.notifyDataSetChanged();
			}

			mContentEditText.setHint(mSettingJsonObject.optString("submit_comment_notice"));
			mVCodeOn = !TextUtils.isEmpty(mSettingJsonObject.optString("verifyCode"));
			if (mDefaultCommentTypeJsonObject != null) {
				((TextView) findViewById(R.id.goods_rat_tip)).setText(mDefaultCommentTypeJsonObject.optString("name"));
			}

			if (mVCodeOn) {
				reloadImageVCode();
				mVCodeImageView.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						reloadImageVCode();
					}
				});
			} else {
				findViewById(R.id.vcode_tr).setVisibility(View.GONE);
				findViewById(R.id.divider).setVisibility(View.GONE);
			}
		}

		@Override
		public void task_response(String json_str) {
			if (!rootView.isShown()) {
				rootView.setVisibility(View.VISIBLE);
			}
			
			super.task_response(json_str);
		}
	};
	GoodsCommentPublishInterface mCommentPublishInterface = new GoodsCommentPublishInterface(this) {
		
		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			Run.alert(mActivity, "评价提交成功");
			for (ImageViewBean imageViewBean : mImageViewBeans) {
				if (!imageViewBean.image_new) {
					FileUtils.deleteFile(imageViewBean.image_uri.replace("file://", ""));
				}
			}
			mActivity.setResult(Activity.RESULT_OK);
			mActivity.finish();
		}
		
		@Override
		public void FailRequest() {
			reloadImageVCode();
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("商品评价");
		try {
			mProductObject = new JSONObject(getExtraStringFromBundle(Run.EXTRA_DATA));
			mOrderId = getExtraStringFromBundle(Run.EXTRA_ORDER_ID);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		rootView = inflater.inflate(R.layout.fragment_goods_comment_publish, null);
		rootView.setVisibility(View.INVISIBLE);
		mGoodsImageView = (ImageView) findViewById(R.id.goods_image);
		displaySquareImage(mGoodsImageView, mProductObject.optString("thumbnail_pic"));
		mGoodsBar = (RatingBar) findViewById(R.id.goods_rat);
		mGoodsBar.setStepSize(1);
		mDefaultCommentTypeJsonObject = new JSONObject();
		mGoodsBar.setOnRatingBarChangeListener(new OnRatingBarChangeListener() {

			@Override
			public void onRatingChanged(RatingBar ratingBar, float rating, boolean fromUser) {
				// TODO Auto-generated method stub
				try {
					mDefaultCommentTypeJsonObject.put("rat", rating);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		});
		mGoodsBar.setRating(5);

		mContentEditText = (EditText) findViewById(R.id.content);
		mLenTextView = (TextView) findViewById(R.id.input_len);
		mLenTextView.setText(String.valueOf(mCommetMaxLen));
		mContentEditText.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				// TODO Auto-generated method stub

			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
				// TODO Auto-generated method stub

			}

			@Override
			public void afterTextChanged(Editable s) {
				// TODO Auto-generated method stub
				mLenTextView.setText(String.valueOf(mCommetMaxLen - s.length()));
			}
		});

		mCommentTypeTextView = (TextView) findViewById(R.id.comment_type);
		mAnonymousBox = (CheckBox) findViewById(R.id.anonymous_comment);

		mImagesGridView = (GridView) findViewById(R.id.imgs_gv);
		mImageViewAdapter.createItem();
		mImagesGridView.setAdapter(mImageViewAdapter);

		mVCodeEditText = (EditText) findViewById(R.id.vcode);
		mVCodeImageView = (ImageView) findViewById(R.id.vcode_ib);

		mOtherRatListView = (ListView) findViewById(R.id.other_comment_list);
		mOtherRatListView.setAdapter(mOtherRatAdapter);

		mDialog = new Dialog(mActivity, R.style.select_popum_dialog);
		View diaViw = mActivity.getLayoutInflater().inflate(R.layout.select_pic_popup, null);
		mDialog.setContentView(diaViw);
		Window dialogWindow = mDialog.getWindow();
		WindowManager.LayoutParams lp = dialogWindow.getAttributes();
		dialogWindow.setGravity(Gravity.BOTTOM);
		dialogWindow.setAttributes(lp);

		diaViw.findViewById(R.id.btn_pick_photo).setOnClickListener(this);
		diaViw.findViewById(R.id.btn_take_photo).setOnClickListener(this);
		diaViw.findViewById(R.id.btn_cancel).setOnClickListener(this);
		
		findViewById(R.id.submit_btn).setOnClickListener(this);

		mCommentInterface.RunRequest();
	}

	void reloadImageVCode() {
		displayRectangleImage(mVCodeImageView, String.format("%s?%s", mSettingJsonObject.optString("verifyCode"), System.currentTimeMillis()));
	}

	public void takePicture() {
		try {
			mFile = com.qianseit.westore.util.loader.FileUtils.createFile();
			Intent i = new Intent("android.media.action.IMAGE_CAPTURE");
			i.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(mFile));
			startActivityForResult(i, TAKE_PHOTO_ID);
		} catch (IOException e) {
			// TODO 自动生成的 catch 块
			Log.w(Run.TAG, e.getMessage());
		}
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO 自动生成的方法存根
		if (resultCode != Activity.RESULT_OK) {
			super.onActivityResult(requestCode, resultCode, data);
			return;
		}
		if (TAKE_PHOTO_ID == requestCode) {
			new Thread(new Runnable() {

				@Override
				public void run() {
					// TODO Auto-generated method stub
					updateAvatarFromFullPath(mFile.getAbsolutePath());
				}
			}).start();
		} else if (requestCode == SELECT_PHOTO_ID) {
			mSelectPath = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
			new Thread(new Runnable() {

				@Override
				public void run() {
					// TODO Auto-generated method stub
					updateImagesFromFullPaths(mSelectPath);
				}
			}).start();
		} else {
			super.onActivityResult(requestCode, resultCode, data);
		}
	}

	MemberUploadImageInterface getUpdateImageHandlerFromFullPath(final String fileFullpathString, int index) {
		try {
			FileOutputStream fos = null;
			Bitmap nBitmap = ImageUtil.getimage(fileFullpathString);// com.qianseit.westore.util.loader.FileUtils.getBitMap(fileFullpathString);

			if (nBitmap == null) {
				CommonLoginFragment.showAlertDialog(mActivity, "图片不存在，请重新拍摄或在相册中选择", "", "OK", null, null, false, null);
				return null;
			}

			File file = new File(Run.doCacheFolder, String.valueOf(fileFullpathString.hashCode()));
			if (!file.getParentFile().exists())
				file.getParentFile().mkdirs();

			fos = new FileOutputStream(file);
			nBitmap.compress(CompressFormat.JPEG, 100, fos);
			fos.flush();

			// 更新到服务器
			MemberUploadImageInterface nImageInterface = new MemberUploadImageInterface(this, file) {

				@Override
				public void SuccCallBack(JSONObject responseJson) {
					// TODO Auto-generated method stub
					JSONObject nDataJsonObject = responseJson;
					ImageViewAdapter nAdapter = mImageViewAdapter;
					ImageViewBean nBean;
					nBean = nAdapter.getItem(nAdapter.getCount() - 1);
					nBean.image_uri = getFileFullPath();
					nBean.image_id = nDataJsonObject.optString("imgpath");
					nBean.image_url = nDataJsonObject.optString("imgurl");
					nBean.image_name = nDataJsonObject.optString("imgpath");
					nBean.image_new = false;
					nAdapter.createItem();

					nAdapter.notifyDataSetChanged();
				}
			};

			return nImageInterface;
		} catch (FileNotFoundException e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
			Log.w(Run.TAG, e.getMessage());
		} catch (IOException e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
			Log.w(Run.TAG, e.getMessage());
		}
		return null;
	}

	void updateImagesFromFullPaths(ArrayList<String> fileFullpathArrayList) {
		ArrayList<MemberUploadImageInterface> nArrayList = new ArrayList<MemberUploadImageInterface>();
		for (String fileString : fileFullpathArrayList) {
			MemberUploadImageInterface nImageInterface = getUpdateImageHandlerFromFullPath(fileString, fileFullpathArrayList.indexOf(fileString));
			if (nImageInterface != null) {
				nArrayList.add(nImageInterface);
			}
		}

		if (nArrayList.size() > 0) {
			MemberUploadImageInterface[] nImageInterfaces = new MemberUploadImageInterface[nArrayList.size()];
			nArrayList.toArray(nImageInterfaces);
			excuteJsonTask(nImageInterfaces);
		}
	}

	void updateAvatarFromFullPath(final String fileFullpathString) {
		try {
			FileOutputStream fos = null;
			Bitmap nBitmap = ImageUtil.getimage(fileFullpathString);// com.qianseit.westore.util.loader.FileUtils.getBitMap(fileFullpathString);

			if (nBitmap == null) {
				CommonLoginFragment.showAlertDialog(mActivity, "图片不存在，请重新拍摄或在相册中选择", "", "OK", null, null, false, null);
				return;
			}

			File file = new File(Run.doCacheFolder, String.valueOf(fileFullpathString.hashCode()));
			if (!file.getParentFile().exists())
				file.getParentFile().mkdirs();

			fos = new FileOutputStream(file);
			nBitmap.compress(CompressFormat.JPEG, 100, fos);
			fos.flush();

			// 更新到服务器
			new MemberUploadImageInterface(this, file) {

				@Override
				public void SuccCallBack(JSONObject responseJson) {
					// TODO Auto-generated method stub
					JSONObject nJsonObject = responseJson;
					ImageViewAdapter nAdapter = mImageViewAdapter;
					ImageViewBean nBean = null;
					nBean = nAdapter.getItem(nAdapter.getCount() - 1);
					nBean.image_uri = getFileFullPath();
					nBean.image_id = nJsonObject.optString("imgpath");
					nBean.image_url = nJsonObject.optString("imgurl");
					nBean.image_name = nJsonObject.optString("imgpath");
					nBean.image_new = false;
					nAdapter.createItem();

					nAdapter.notifyDataSetChanged();
				}
			}.RunRequest();
		} catch (FileNotFoundException e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
			Log.w(Run.TAG, e.getMessage());
		} catch (IOException e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
			Log.w(Run.TAG, e.getMessage());
		}
	}

	public static class ImageViewBean {
		String image_id;
		String image_url;
		String image_name;

		String image_uri;
		boolean image_new;

		public ImageViewBean() {
			image_id = "";
			image_url = "";
			image_name = "";
			image_uri = "";
			image_new = true;
		}
	}

	public class ImageViewAdapter extends BaseAdapter {

		List<ImageViewBean> mImageViewBeans;
		int mImageTypeAdapter;
		int mMaxCount;

		public int getMaxCount() {
			return mMaxCount;
		}

		public ImageViewAdapter(List<ImageViewBean> imageViewBeans, int imageType, int maxCount) {
			mImageViewBeans = imageViewBeans;
			mImageTypeAdapter = imageType;
			mMaxCount = maxCount;
		}

		@Override
		public int getCount() {
			return mImageViewBeans.size();
		}

		@Override
		public ImageViewBean getItem(int position) {
			return mImageViewBeans.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		public void createItem() {
			if (getCount() < mMaxCount) {
				mImageViewBeans.add(new ImageViewBean());
			}
		}

		public void addItem(ImageViewBean nBean) {
			if (getCount() < mMaxCount) {
				mImageViewBeans.add(nBean);
			}
		}

		public void addItem(ImageViewBean nBean, int index) {
			if (getCount() < mMaxCount) {
				mImageViewBeans.add(index, nBean);
			}
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			if (convertView == null) {
				convertView = View.inflate(mActivity, R.layout.item_goods_comment_image, null);
				setViewSize(convertView.findViewById(R.id.image), 200, 200);
			}

			final ImageViewBean nBean = getItem(position);
			if (nBean.image_new) {
				displayImage((ImageView) convertView.findViewById(R.id.image), nBean.image_uri, R.drawable.photograph);
				convertView.findViewById(R.id.image).setBackgroundResource(R.color.westore_red);
				convertView.findViewById(R.id.del_image).setVisibility(View.GONE);
			} else {
				displaySquareImage((ImageView) convertView.findViewById(R.id.image), nBean.image_uri, ImageScaleType.EXACTLY_STRETCHED);
				convertView.findViewById(R.id.image).setBackgroundResource(R.color.white);
				convertView.findViewById(R.id.del_image).setVisibility(View.VISIBLE);
			}

			convertView.findViewById(R.id.del_image).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					if (!nBean.image_new) {
						mImageViewBeans.remove(nBean);
						if (!mImageViewBeans.get(mImageViewBeans.size() - 1).image_new) {
							createItem();
						}
						notifyDataSetChanged();
					}
				}
			});

			convertView.findViewById(R.id.image).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					if (nBean.image_new) {
						mDialog.show();
					}
				}
			});
			return convertView;
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.btn_pick_photo:

			Intent intent = new Intent(mActivity, MultiImageSelectorActivity.class);
			// 是否显示拍摄图片
			intent.putExtra(MultiImageSelectorActivity.EXTRA_SHOW_CAMERA, false);
			// 最大可选择图片数量
			int nMaxCount = mImageViewAdapter.getMaxCount() - mImageViewAdapter.getCount() + 1;
			intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_COUNT, nMaxCount);
			// 选择模式
			intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_MODE, MultiImageSelectorActivity.MODE_MULTI);
			// // 默认选择
			// if (mSelectPath != null && mSelectPath.size() > 0) {
			// intent.putExtra(MultiImageSelectorActivity.EXTRA_DEFAULT_SELECTED_LIST,
			// mSelectPath);
			// }
			startActivityForResult(intent, SELECT_PHOTO_ID);

			// Intent intent = new Intent(Intent.ACTION_PICK,
			// android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
			// intent.setType("image/*");
			// startActivityForResult(intent, SELECT_PHOTO_ID);
			mDialog.dismiss();
			break;
		case R.id.btn_take_photo:
			takePicture();
			mDialog.dismiss();
			break;
		case R.id.btn_cancel:
			mDialog.dismiss();
			break;
		case R.id.submit_btn:
			if (mContentEditText.getText().length() <= 0) {
				Run.alert(mActivity, "请输入评价内容");
				mContentEditText.requestFocus();
				return;
			}
			if (mVCodeOn && mVCodeEditText.getText().length() <= 0) {
				Run.alert(mActivity, "请输入图形验证码");
				mVCodeEditText.requestFocus();
				return;
			}
			mCommentPublishInterface.setGoods(mProductObject.optString("goods_id"), mProductObject.optString("product_id"), mOrderId);
			for (JSONObject ratItem : mRatJsonObjects) {
				mCommentPublishInterface.addPoint(ratItem.optDouble("rat"));
			}
			for (ImageViewBean imageViewBean : mImageViewBeans) {
				if (!imageViewBean.image_new) {
					mCommentPublishInterface.addImage(imageViewBean.image_id);
				}
			}
			mCommentPublishInterface.comment(mContentEditText.getText().toString(), mVCodeOn?mVCodeEditText.getText().toString():"", mAnonymousBox.isChecked());
			
			break;
		default:
			super.onClick(v);
			break;
		}
	}

}
