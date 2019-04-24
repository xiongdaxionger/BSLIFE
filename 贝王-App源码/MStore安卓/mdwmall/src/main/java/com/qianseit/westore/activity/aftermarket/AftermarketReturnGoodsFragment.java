package com.qianseit.westore.activity.aftermarket;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Paint;
import android.graphics.Bitmap.CompressFormat;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.activity.goods.GoodsCommentPublishFragment.ImageViewBean;
import com.qianseit.westore.activity.other.MultiImageSelectorActivity;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.aftermarket.AftermarketGetRefundInterface;
import com.qianseit.westore.httpinterface.aftermarket.AftermarketRefundSubmitInterface;
import com.qianseit.westore.httpinterface.member.MemberUploadImageInterface;
import com.qianseit.westore.util.ImageUtil;
import com.qianseit.westore.util.loader.FileUtils;
import com.beiwangfx.R;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;

public class AftermarketReturnGoodsFragment extends BaseDoFragment {
	final String CHOOSED_FIELD = "choosed";
	final String INPUT_QTY_FIELD = "inputqty";
	private final int TAKE_PHOTO_ID = Menu.FIRST;
	private final int SELECT_PHOTO_ID = Menu.FIRST + 1;

	List<JSONObject> mList;
	QianseitAdapter<JSONObject> mAdapter;
	ListView mListView;
	JSONObject mOrderJsonObject, mReshipTypeJsonObject;
	String mOrderIdString;

	TextView mTotalAmountTextView;
	EditText mTitleEditText;
	EditText mContentEditText;

	private Dialog mDialog;
	File mImageFile;
	ArrayList<String> mSelectPath;

	GridView mImagesGridView;
	List<ImageViewBean> mImageViewBeans = new ArrayList<ImageViewBean>();
	ImageViewAdapter mImageViewAdapter = new ImageViewAdapter(mImageViewBeans, 0, 3);

	boolean mIsReturnGoodsAll;
	AftermarketRefundSubmitInterface mReshipSubmitInterface = new AftermarketRefundSubmitInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			Intent nIntent = new Intent();
			nIntent.putExtra(Run.EXTRA_DATA, mIsReturnGoodsAll);
			for (ImageViewBean imageViewBean : mImageViewBeans) {
				if (!imageViewBean.image_new) {
					FileUtils.deleteFile(imageViewBean.image_uri.replace("file://", ""));
				}
			}
			mActivity.setResult(Activity.RESULT_OK, nIntent);
			mActivity.finish();
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("申请退货");

		Bundle nBundle = mActivity.getIntent().getExtras();
		mList = new ArrayList<JSONObject>();
		if (nBundle != null) {
			mOrderIdString = nBundle.getString(Run.EXTRA_ORDER_ID);
		}

		if (TextUtils.isEmpty(mOrderIdString)) {
			Run.alert(mActivity, "待售后服务订单Id不能为空");
			mActivity.finish();
		}
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		rootView = inflater.inflate(R.layout.fragment_aftermarket_return_goods, null);

		mListView = (ListView) findViewById(R.id.aftermarket_return_goods_list);
		mAdapter = new QianseitAdapter<JSONObject>(mList) {

			@Override
			public View getView(int position, View convertView, ViewGroup parent) {
				// TODO Auto-generated method stub
				if (convertView == null) {
					int layout = R.layout.item_aftermarket_goods;
					convertView = LayoutInflater.from(mActivity).inflate(layout, null);
					convertView.findViewById(R.id.selected).setOnClickListener(AftermarketReturnGoodsFragment.this);
					convertView.findViewById(R.id.minus).setOnClickListener(AftermarketReturnGoodsFragment.this);
					convertView.findViewById(R.id.plus).setOnClickListener(AftermarketReturnGoodsFragment.this);
					convertView.findViewById(R.id.thumb).setOnClickListener(AftermarketReturnGoodsFragment.this);
				}

				JSONObject all = getItem(position);
				if (all == null)
					return convertView;

				convertView.setTag(all);
				assignmentItemView(convertView, all);
				convertView.findViewById(R.id.selected).setTag(all);
				convertView.findViewById(R.id.thumb).setTag(all);
				convertView.findViewById(R.id.plus).setTag(all);
				convertView.findViewById(R.id.minus).setTag(all);

				// 选中与否
				((ImageButton) convertView.findViewById(R.id.selected)).setImageResource(all.optBoolean(CHOOSED_FIELD) ? R.drawable.qianse_item_status_selected
						: R.drawable.qianse_item_status_unselected);
				return convertView;
			}
		};
		mListView.setAdapter(mAdapter);

		mTotalAmountTextView = (TextView) findViewById(R.id.aftermarket_return_goods_price);
		mTitleEditText = (EditText) findViewById(R.id.aftermarket_return_goods_reason);
		mContentEditText = (EditText) findViewById(R.id.aftermarket_return_goods_remark);

		findViewById(R.id.base_submit_btn).setOnClickListener(this);

		mImagesGridView = (GridView) findViewById(R.id.imgs_gv);
		mImageViewAdapter.createItem();
		mImagesGridView.setAdapter(mImageViewAdapter);

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

		new AftermarketGetRefundInterface(this, mOrderIdString, "reship") {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				mOrderJsonObject = responseJson;
				JSONArray nTypeArray = mOrderJsonObject.optJSONArray("refund_type");
				mReshipTypeJsonObject = nTypeArray != null && nTypeArray.length() > 0 ? nTypeArray.optJSONObject(0) : new JSONObject();
				mReshipSubmitInterface.setRefundType(mOrderJsonObject.optString("order_id"), mReshipTypeJsonObject.optInt("value"));

				JSONArray nArray = mOrderJsonObject.optJSONArray("goods_items");
				try {
					for (int i = 0; i < nArray.length(); i++) {
						JSONObject nItem = nArray.optJSONObject(i);
						nItem.put(CHOOSED_FIELD, true);
						nItem.put(INPUT_QTY_FIELD, nItem.optInt("quantity"));
						mList.add(nItem);
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				mAdapter.notifyDataSetChanged();
				assignmentTotalAmount();
			}
		}.RunRequest();

		findViewById(R.id.aftermarket_return_goods_notice).setOnClickListener(this);
	}

	private void assignmentItemView(View view, final JSONObject all) {
		EditText mCarQuantity = ((EditText) view.findViewById(R.id.quantity));
		mCarQuantity.setText(all.optString(INPUT_QTY_FIELD));
		mCarQuantity.setEnabled(false);

		// 商品信息
		JSONObject product = all;
		((TextView) view.findViewById(R.id.price)).setText(product.optString("price_format"));
		// 原价
		TextView oldPriceTV = (TextView) view.findViewById(R.id.oldprice);
		oldPriceTV.setVisibility(View.INVISIBLE);
		oldPriceTV.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);

		((TextView) view.findViewById(R.id.title)).setText(product.optString("name"));
		if (!product.isNull("attr"))
			((TextView) view.findViewById(R.id.info1)).setText(product.optString("attr"));
		displaySquareImage((ImageView) view.findViewById(R.id.thumb), all.optString("thumbnail_pic"));
	}

	void assignmentTotalAmount() {
		double nTotalAmount = 0;
		for (int i = 0; i < mList.size(); i++) {
			if (mList.get(i).optBoolean(CHOOSED_FIELD)) {
				nTotalAmount = nTotalAmount + mList.get(i).optDouble("price") * mList.get(i).optInt(INPUT_QTY_FIELD);
			}
		}

		mTotalAmountTextView.setText(String.format("%.2f", nTotalAmount));
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		JSONObject all;
		switch (v.getId()) {
		case R.id.base_submit_btn:
			mReshipSubmitInterface.reset();
			mIsReturnGoodsAll = true;
			for (int i = 0; i < mList.size(); i++) {
				if (mList.get(i).optBoolean(CHOOSED_FIELD)) {
					JSONObject nJsonObject = mList.get(i);
					mReshipSubmitInterface.addGoods(nJsonObject.optString("product_id"), nJsonObject.optString("bn"), nJsonObject.optString(INPUT_QTY_FIELD), nJsonObject.optString("name"),
							nJsonObject.optString("price"));
					if (nJsonObject.optInt(INPUT_QTY_FIELD) < nJsonObject.optInt("quantity")) {
						mIsReturnGoodsAll = false;
					}
				} else {
					mIsReturnGoodsAll = false;
				}
			}

			if (mReshipSubmitInterface.getRefundProductCount() < 1) {
				Run.alert(mActivity, "请选择要退换的商品");
				return;
			}

			if (mTitleEditText.getText().length() <= 0) {
				Run.alert(mActivity, "请填写退换理由");
				mTitleEditText.requestFocus();
				return;
			}

			for (ImageViewBean imageViewBean : mImageViewBeans) {
				if (!imageViewBean.image_new) {
					mReshipSubmitInterface.addImage(imageViewBean.image_id);
				}
			}

			mReshipSubmitInterface.refund(mTitleEditText.getText().toString(), mContentEditText.getText().toString());

			break;
		case R.id.plus:
			all = (JSONObject) v.getTag();
			modQty(all, true);
			break;
		case R.id.minus:
			all = (JSONObject) v.getTag();
			modQty(all, false);
			break;
		case R.id.selected:
			all = (JSONObject) v.getTag();
			try {
				all.put(CHOOSED_FIELD, !all.optBoolean(CHOOSED_FIELD));
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			mAdapter.notifyDataSetChanged();
			assignmentTotalAmount();
			break;
		case R.id.thumb:
			all = (JSONObject) v.getTag();
			JSONObject product = all.optJSONObject("products");
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_CLASS_ID, product.optString("goods_id")));
			break;
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
		case R.id.aftermarket_return_goods_notice:
			startActivity(AgentActivity.FRAGMENT_AFTERMARKET_NOTICE);
			break;
		default:
			super.onClick(v);
			break;
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
					updateAvatarFromFullPath(mImageFile.getAbsolutePath());
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
					nBean.image_uri = fileFullpathString;
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
					nBean.image_uri = fileFullpathString;
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

	public void takePicture() {
		try {
			mImageFile = com.qianseit.westore.util.loader.FileUtils.createFile();
			Intent i = new Intent("android.media.action.IMAGE_CAPTURE");
			i.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(mImageFile));
			startActivityForResult(i, TAKE_PHOTO_ID);
		} catch (IOException e) {
			// TODO 自动生成的 catch 块
			Log.w(Run.TAG, e.getMessage());
		}
	}

	void modQty(JSONObject all, boolean add) {
		int nOQty = all.optInt("quantity");
		int nIQty = all.optInt(INPUT_QTY_FIELD);

		if ((!add && nIQty <= 1) || (add && nIQty >= nOQty)) {
			return;
		}

		if (add) {
			nIQty++;
		} else {
			nIQty--;
		}

		try {
			all.put(INPUT_QTY_FIELD, nIQty);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		mAdapter.notifyDataSetChanged();
		assignmentTotalAmount();
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
				displayImage((ImageView) convertView.findViewById(R.id.image), nBean.image_url, R.drawable.photograph);
				convertView.findViewById(R.id.image).setBackgroundResource(R.color.westore_red);
				convertView.findViewById(R.id.del_image).setVisibility(View.GONE);
			} else {
				displaySquareImage((ImageView) convertView.findViewById(R.id.image), nBean.image_url, ImageScaleType.EXACTLY_STRETCHED);
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

}
