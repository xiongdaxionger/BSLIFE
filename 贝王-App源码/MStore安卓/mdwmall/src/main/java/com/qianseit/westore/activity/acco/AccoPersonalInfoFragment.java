package com.qianseit.westore.activity.acco;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.LinearLayout;

import com.beiwangfx.R;;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.CropperActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.activity.other.MultiImageSelectorActivity;
import com.qianseit.westore.activity.passport.ItemSettingAvatarView;
import com.qianseit.westore.activity.passport.ItemSettingHandler;
import com.qianseit.westore.activity.passport.ItemSettingTextView;
import com.qianseit.westore.base.BaseSettingFragment;
import com.qianseit.westore.httpinterface.passport.DIYEditItemsInterface;
import com.qianseit.westore.httpinterface.passport.RegistrMemberInterface.Gender;
import com.qianseit.westore.httpinterface.setting.SaveSettingInterface;
import com.qianseit.westore.ui.MyAlertDialog;
import com.qianseit.westore.util.StringUtils;
import com.qianseit.westore.util.loader.ClipPictureBean;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("ALL")
public class AccoPersonalInfoFragment extends BaseSettingFragment {
	final int PICKER_AREA_REQUEST = 100;
	final int PICKER_SINGLE_REQUEST = 101;
	final int PICKER_MULTI_REQUEST = 102;
	final int PICKER_TEXT_REQUEST = 103;
	private final int TAKE_PHOTO_ID = Menu.FIRST;
	private final int SELECT_PHOTO_ID = Menu.FIRST + 1;
	private final int CROPPER_PHOTO_ID = Menu.FIRST + 2;

	private ItemSettingHandler mCurHandler;

	private Dialog mPictureDialog, mGenderDialog;
	File mFile;
	String mDefualtAvatarUrl = "";

	JSONObject mMemJsonObject = new JSONObject();

	boolean hasAvatar = false;

	///是否是点击昵称
	boolean mSelectName = false;


	List<ItemSettingHandler> mItemSettingHandlers = new ArrayList<ItemSettingHandler>();
	List<JSONObject> mSettingItems = new ArrayList<JSONObject>();
	DIYEditItemsInterface mEditItemsInterface = new DIYEditItemsInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			if (responseJson == null) {
				return;
			}

			mDefualtAvatarUrl = responseJson.optString("addUploadImg");
			mSettingItems.clear();

			mMemJsonObject = responseJson.optJSONObject("mem");

			JSONArray nArray = responseJson.optJSONArray("attr");
			if (nArray == null || nArray.length() <= 0) {
				return;
			}

			for (int i = 0; i < nArray.length(); i++) {
				JSONObject nJsonObject = nArray.optJSONObject(i);
				if (nJsonObject.optString("attr_type").equalsIgnoreCase("image")) {
					hasAvatar = true;
				}
				mSettingItems.add(nArray.optJSONObject(i));
			}

			reloadSettingItems();
		}
	};
	SaveSettingInterface mSaveSettingInterface = new SaveSettingInterface(this, "", "") {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			String nType = mSettingItems.get(mItemSettingHandlers.indexOf(mCurHandler)).optString("attr_type");
			if (nType.equals("gender")) {
				mCurHandler.setSettingValue(getGenderDisplay(getValue()));
			} else if (nType.equals("image")) {
				mCurHandler.setSettingValue(responseJson.optString("image_src"));
				mLoginedUser.setAvatarUri(responseJson.optString("image_src"));
			} else if (nType.equals("checkbox")) {
				StringBuilder nBuilder = new StringBuilder();
				JSONObject nJsonObject = mSettingItems.get(mItemSettingHandlers.indexOf(mCurHandler));
				JSONArray nArray = new JSONArray();
				for (String nString : getValueList()) {
					nBuilder.append(nString).append("，");
					nArray.put(nString);
				}
				try {
					nJsonObject.put("attr_value", nArray);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				if (nBuilder.length() > 0) {
					nBuilder.deleteCharAt(nBuilder.length() - 1);
				}
				mCurHandler.setSettingValue(nBuilder.toString());
				nBuilder.delete(0, nBuilder.length());
			} else if (nType.equals("region")) {
				mCurHandler.setSettingValue(StringUtils.FormatArea(getValue()));
			} else {
				mCurHandler.setSettingValue(getValue());
			}
		}
	};

	@Override
	protected void initActionBar() {
		// TODO Auto-generated method stub
		mActionBar.setTitle(R.string.acco_personalinfo_title);
		mEditItemsInterface.RunRequest();

		mPictureDialog = new Dialog(mActivity, R.style.select_popum_dialog);
		View diaViw = mActivity.getLayoutInflater().inflate(R.layout.select_pic_popup, null);
		mPictureDialog.setContentView(diaViw);
		Window dialogWindow = mPictureDialog.getWindow();
		WindowManager.LayoutParams lp = dialogWindow.getAttributes();
		dialogWindow.setGravity(Gravity.BOTTOM);
		dialogWindow.setAttributes(lp);

		diaViw.findViewById(R.id.btn_pick_photo).setOnClickListener(this);
		diaViw.findViewById(R.id.btn_take_photo).setOnClickListener(this);
		diaViw.findViewById(R.id.btn_cancel).setOnClickListener(this);
	}

	@Override
	protected void initSettingItems(LinearLayout parentView) {
		// TODO Auto-generated method stub
		mItemSettingHandlers.clear();

		if (!hasAvatar && mMemJsonObject != null) {
			String nName = mMemJsonObject.optString("local");
			if (TextUtils.isEmpty(nName) && nName.equalsIgnoreCase("null")) {
				nName = "";
			}
			addItem("用户名", nName, TextUtils.isEmpty(nName), AgentActivity.FRAGMENT_ACCO_NAME);
			String nMobile = mMemJsonObject.optString("mobile");
			if (TextUtils.isEmpty(nMobile) && nMobile.equalsIgnoreCase("null")) {
				nMobile = "";
			}
			addItem("手机号", nMobile, TextUtils.isEmpty(nMobile), AgentActivity.FRAGMENT_ACCO_BIND_MOBILE);
			String nEmail = mMemJsonObject.optString("email");
			if (TextUtils.isEmpty(nEmail) && nEmail.equalsIgnoreCase("null")) {
				nEmail = "";
			}
			addItem("邮箱", nEmail, false, 0);
		}
		
		for (JSONObject itemJsonObject : mSettingItems) {
			addDIYItem(itemJsonObject);
		}
	}

	/**
	 * 
	 * @param jsonObject
	 * { "attr_id":9, "attr_show":"true", "attr_edit":"false", "attr_order":8,
	 * "attr_name":"字符（测试）",
	 * "attr_type":"text",//region|text|gender|date|select|checkbox
	 * "attr_required":"false", "attr_search":"false", "attr_option":"",
	 * "attr_valtype":"alpha",//alpha|alphaint|number "attr_tyname":"仅限输入字符",
	 * "attr_group":"input", "attr_column":"chars", "attr_sdfpath":null,
	 * "attr_value":null }
	 */
	void addDIYItem(JSONObject jsonObject) {
		if (jsonObject == null) {
			return;
		}

		String nItemType = jsonObject.optString("attr_type");
		if (nItemType.equalsIgnoreCase("region")) {// 地区
			parseRegion(jsonObject);
		} else if (nItemType.equalsIgnoreCase("text")) {// 文本
			parseText(jsonObject);
		} else if (nItemType.equalsIgnoreCase("gender")) {// 性别
			parseGender(jsonObject);
		} else if (nItemType.equalsIgnoreCase("date")) {// 日期
			parseDate(jsonObject);
		} else if (nItemType.equalsIgnoreCase("select")) {// 单选
			parseSingle(jsonObject);
		} else if (nItemType.equalsIgnoreCase("checkbox")) {// 多选
			parseMulti(jsonObject);
		} else if (nItemType.equalsIgnoreCase("image")) {// 头像
			parseAvatar(jsonObject);
		}
	}

	/**
	 * @param jsonObject
	 *            多选
	 */
	void parseMulti(final JSONObject jsonObject) {
		ItemSettingTextView nItemSettingTextView = new ItemSettingTextView(mActivity, jsonObject.optString("attr_name"), jsonObject.optString("attr_values"));
		final boolean nCanEdit = jsonObject.optBoolean("attr_edit");
		nItemSettingTextView.showRight(nCanEdit);
		nItemSettingTextView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (!nCanEdit) {
					return;
				}
				mCurHandler = (ItemSettingHandler) v;
				ArrayList<String> nArrayList = new ArrayList<String>();
				JSONArray nArray = jsonObject.optJSONArray("attr_option");
				if (nArray != null && nArray.length() > 0) {
					for (int i = 0; i < nArray.length(); i++) {
						nArrayList.add(nArray.optString(i));
					}
				}

				ArrayList<String> nChoosedArrayList = new ArrayList<String>();
				nArray = jsonObject.optJSONArray("attr_value");
				if (nArray != null && nArray.length() > 0) {
					for (int i = 0; i < nArray.length(); i++) {
						nChoosedArrayList.add(nArray.optString(i));
					}
				}

				Bundle nBundle = new Bundle();
				nBundle.putString(Run.EXTRA_TITLE, jsonObject.optString("attr_name"));
				nBundle.putStringArrayList(Run.EXTRA_DATA, nArrayList);
				nBundle.putStringArrayList(Run.EXTRA_VALUE, nChoosedArrayList);
				startActivityForResult(AgentActivity.FRAGMENT_PASSPORT_MULTI, nBundle, PICKER_MULTI_REQUEST);
			}
		});
		if (mItemSettingHandlers.size() <= 0) {
			nItemSettingTextView.showTopDivide(true);
		}
		mItemSettingHandlers.add(nItemSettingTextView);
		mContentLinearLayout.addView(nItemSettingTextView);
	}

	/**
	 * @param jsonObject
	 *            单选
	 */
	void parseSingle(final JSONObject jsonObject) {
		ItemSettingTextView nItemSettingTextView = new ItemSettingTextView(mActivity, jsonObject.optString("attr_name"), jsonObject.optString("attr_value"));
		final boolean nCanEdit = jsonObject.optBoolean("attr_edit");
		nItemSettingTextView.showRight(nCanEdit);
		nItemSettingTextView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (!nCanEdit) {
					return;
				}
				mCurHandler = (ItemSettingHandler) v;
				ArrayList<String> nArrayList = new ArrayList<String>();
				JSONArray nArray = jsonObject.optJSONArray("attr_option");
				if (nArray != null && nArray.length() > 0) {
					for (int i = 0; i < nArray.length(); i++) {
						nArrayList.add(nArray.optString(i));
					}
				}

				Bundle nBundle = new Bundle();
				nBundle.putString(Run.EXTRA_TITLE, jsonObject.optString("attr_name"));
				nBundle.putStringArrayList(Run.EXTRA_DATA, nArrayList);
				startActivityForResult(AgentActivity.FRAGMENT_PASSPORT_SINGLE, nBundle, PICKER_SINGLE_REQUEST);
			}
		});
		if (mItemSettingHandlers.size() <= 0) {
			nItemSettingTextView.showTopDivide(true);
		}
		mItemSettingHandlers.add(nItemSettingTextView);
		mContentLinearLayout.addView(nItemSettingTextView);
	}

	/**
	 * @param jsonObject
	 *            日期
	 */
	void parseDate(final JSONObject jsonObject) {
		ItemSettingTextView nItemSettingTextView = new ItemSettingTextView(mActivity, jsonObject.optString("attr_name"), jsonObject.optString("attr_value"));
		final boolean nCanEdit = jsonObject.optBoolean("attr_edit");
		nItemSettingTextView.showRight(nCanEdit);
		nItemSettingTextView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (!nCanEdit) {
					return;
				}
				mCurHandler = (ItemSettingHandler) v;
				setTimDialog();
			}
		});
		if (mItemSettingHandlers.size() <= 0) {
			nItemSettingTextView.showTopDivide(true);
		}
		mItemSettingHandlers.add(nItemSettingTextView);
		mContentLinearLayout.addView(nItemSettingTextView);
	}

	private void setTimDialog() {
		final MyAlertDialog dialog = new MyAlertDialog(mActivity).builder().setNegativeButton("取消", new OnClickListener() {
			@Override
			public void onClick(View v) {

			}
		});
		dialog.setPositiveButton("确定", new OnClickListener() {
			@Override
			public void onClick(View v) {
				final String birthday = dialog.getResult();
				mSaveSettingInterface.save(mSettingItems.get(mItemSettingHandlers.indexOf(mCurHandler)).optString("attr_column"), birthday);
			}
		});
		dialog.show();
	}

	/**
	 * @param regionJsonObject
	 *            地区
	 */
	void parseRegion(final JSONObject regionJsonObject) {
		ItemSettingTextView nRegionItemSettingTextView = new ItemSettingTextView(mActivity, regionJsonObject.optString("attr_name"), StringUtils.FormatArea(regionJsonObject.optString("attr_value")));
		final boolean nCanEdit = regionJsonObject.optBoolean("attr_edit");
		nRegionItemSettingTextView.showRight(nCanEdit);
		nRegionItemSettingTextView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (!nCanEdit) {
					return;
				}
				mCurHandler = (ItemSettingHandler) v;
				startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ADDR_MY_ADDRESS_PICKER), PICKER_AREA_REQUEST);
			}
		});
		if (mItemSettingHandlers.size() <= 0) {
			nRegionItemSettingTextView.showTopDivide(true);
		}
		mItemSettingHandlers.add(nRegionItemSettingTextView);
		mContentLinearLayout.addView(nRegionItemSettingTextView);
	}

	/**
	 * @param textJsonObject
	 *            字符串
	 */
	void parseText(final JSONObject textJsonObject) {

		String text = textJsonObject.optString("attr_value");
		String column = textJsonObject.optString("attr_column");
		if(column != null && column.equals("contact[name]")){
			text = mLoginedUser.getDisplayName();
		}
		ItemSettingTextView nRegionItemSettingTextView = new ItemSettingTextView(mActivity, textJsonObject.optString
				("attr_name"), text);
		final boolean nCanEdit = textJsonObject.optBoolean("attr_edit");
		nRegionItemSettingTextView.showRight(nCanEdit);
		nRegionItemSettingTextView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (!nCanEdit) {
					return;
				}

				String column = textJsonObject.optString("attr_column");
				if(column != null && column.equals("contact[name]")){
					mSelectName = true;
				}else {
					mSelectName = false;
				}
				mCurHandler = (ItemSettingHandler) v;
				Bundle nBundle = new Bundle();
				nBundle.putString(Run.EXTRA_DATA, textJsonObject.toString());
				startActivityForResult(AgentActivity.FRAGMENT_ACCO_EDIT_ITEM, nBundle, PICKER_TEXT_REQUEST);
			}
		});
		if (mItemSettingHandlers.size() <= 0) {
			nRegionItemSettingTextView.showTopDivide(true);
		}
		mItemSettingHandlers.add(nRegionItemSettingTextView);
		mContentLinearLayout.addView(nRegionItemSettingTextView);
	}

	/**
	 * @param avatarJsonObject
	 *            头像
	 */
	void parseAvatar(final JSONObject avatarJsonObject) {
		String nImageUrl = avatarJsonObject.optString("attr_value");
		if (TextUtils.isEmpty(nImageUrl) || nImageUrl.equalsIgnoreCase("null")) {
			nImageUrl = mDefualtAvatarUrl;
		}

		ItemSettingAvatarView nItemSettingTextView = new ItemSettingAvatarView(mActivity, avatarJsonObject.optString("attr_name"), nImageUrl);
		final boolean nCanEdit = avatarJsonObject.optBoolean("attr_edit");
		nItemSettingTextView.showRight(nCanEdit);
		nItemSettingTextView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (!nCanEdit) {
					return;
				}
				mCurHandler = (ItemSettingHandler) v;
				mPictureDialog.show();
			}
		});
		if (mItemSettingHandlers.size() <= 0) {
			nItemSettingTextView.showTopDivide(true);
		}
		mItemSettingHandlers.add(nItemSettingTextView);
		mContentLinearLayout.addView(nItemSettingTextView);

		if (mMemJsonObject != null) {
			String nName = mMemJsonObject.optString("local");
			if (TextUtils.isEmpty(nName) && nName.equalsIgnoreCase("null")) {
				nName = "";
			}
			addItem("用户名", nName, TextUtils.isEmpty(nName), AgentActivity.FRAGMENT_ACCO_NAME);
			String nMobile = mMemJsonObject.optString("mobile");
			if (TextUtils.isEmpty(nMobile) && nMobile.equalsIgnoreCase("null")) {
				nMobile = "";
			}
			addItem("手机号", nMobile, TextUtils.isEmpty(nMobile), AgentActivity.FRAGMENT_ACCO_BIND_MOBILE);
			String nEmail = mMemJsonObject.optString("email");
			if (TextUtils.isEmpty(nEmail) && nEmail.equalsIgnoreCase("null")) {
				nEmail = "";
			}
			addItem("邮箱", nEmail, false, 0);
		}
	}

	/**
	 * @param itemName
	 * @param itemValue
	 * @param canEdit
	 * @param fragmentId
	 */
	void addItem(final String itemName, final String itemValue, final boolean canEdit, final int fragmentId) {
		ItemSettingTextView nItemSettingTextView = new ItemSettingTextView(mActivity, itemName, itemValue);
		nItemSettingTextView.showRight(canEdit);
		nItemSettingTextView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (!canEdit) {
					return;
				}
				mCurHandler = (ItemSettingHandler) v;
				Bundle nBundle = new Bundle();
				nBundle.putString(Run.EXTRA_DATA, itemValue);
				nBundle.putString(Run.EXTRA_TITLE, itemName);
				startActivityForResult(fragmentId, nBundle, PICKER_TEXT_REQUEST);
			}
		});
		// if (mItemSettingHandlers.size() <= 0) {
		// nRegionItemSettingTextView.showTopDivide(true);
		// }
		// mItemSettingHandlers.add(nRegionItemSettingTextView);
		mContentLinearLayout.addView(nItemSettingTextView);
	}

	void parseGender(final JSONObject jsonObject) {
		ItemSettingTextView nGenderView = new ItemSettingTextView(mActivity, jsonObject.optString("attr_name"), getGenderDisplay(jsonObject.optString("attr_value")));
		if (mItemSettingHandlers.size() <= 0) {
			nGenderView.showTopDivide(true);
		}
		final boolean nCanEdit = jsonObject.optBoolean("attr_edit");
		nGenderView.showRight(nCanEdit);
		nGenderView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (!nCanEdit) {
					return;
				}
				mCurHandler = (ItemSettingHandler) v;
				mGenderDialog = CommonLoginFragment.showAlertDialog(mActivity, "性别选择", "男", "女", new OnClickListener() {

					@Override
					public void onClick(View v) {// 男
						// TODO Auto-generated method stub
						mSaveSettingInterface.save(mSettingItems.get(mItemSettingHandlers.indexOf(mCurHandler)).optString("attr_column"), Gender.BOY);
						mGenderDialog.dismiss();
					}
				}, new OnClickListener() {

					@Override
					public void onClick(View v) {// 女
						// TODO Auto-generated method stub
						mSaveSettingInterface.save(mSettingItems.get(mItemSettingHandlers.indexOf(mCurHandler)).optString("attr_column"), Gender.GIRL);
						mGenderDialog.dismiss();
					}
				}, false, null);
			}
		});
		mItemSettingHandlers.add(nGenderView);
		mContentLinearLayout.addView(nGenderView);
	}

	String getGenderDisplay(String gender) {
		String nString = "男";
		if (!TextUtils.isEmpty(gender) && gender.equals(Gender.GIRL)) {
			nString = "女";
		}
		return nString;
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if (v.getId() == R.id.btn_pick_photo) {
			Intent intent = new Intent(mActivity, MultiImageSelectorActivity.class);
			// 是否显示拍摄图片
			intent.putExtra(MultiImageSelectorActivity.EXTRA_SHOW_CAMERA, false);
			// 最大可选择图片数量
			int nMaxCount = 1;
			intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_COUNT, nMaxCount);
			// 选择模式
			intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_MODE, MultiImageSelectorActivity.MODE_SINGLE);
			startActivityForResult(intent, SELECT_PHOTO_ID);
			mPictureDialog.dismiss();
		} else if (v.getId() == R.id.btn_take_photo) {
			takePicture();
			mPictureDialog.dismiss();
		} else if (v.getId() == R.id.btn_cancel) {
			mPictureDialog.dismiss();
		} else {
			super.onClick(v);
		}
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO 自动生成的方法存根
		if (resultCode != Activity.RESULT_OK) {
			super.onActivityResult(requestCode, resultCode, data);
			return;
		}

		switch (requestCode) {
		case SELECT_PHOTO_ID:
			gotoCrop(data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT).get(0));
			break;
		case CROPPER_PHOTO_ID:
			updateAvatarFromFullPath(data.getStringExtra("imagePath"));
			break;
		case TAKE_PHOTO_ID:
			gotoCrop(mFile.getAbsolutePath());
			break;
		case PICKER_AREA_REQUEST:
			final String areaDisplayString = data.getStringExtra(Run.EXTRA_VALUE);
			final String areaValueString = data.getStringExtra(Run.EXTRA_DATA);
			mSaveSettingInterface.save(mSettingItems.get(mItemSettingHandlers.indexOf(mCurHandler)).optString("attr_column"), areaValueString);
			break;
		case PICKER_SINGLE_REQUEST:
			mSaveSettingInterface.save(mSettingItems.get(mItemSettingHandlers.indexOf(mCurHandler)).optString("attr_column"), data.getStringExtra(Run.EXTRA_VALUE));
			break;
		case PICKER_MULTI_REQUEST:
			List<String> nList = data.getStringArrayListExtra(Run.EXTRA_VALUE);
			mSaveSettingInterface.save(mSettingItems.get(mItemSettingHandlers.indexOf(mCurHandler)).optString("attr_column"), nList);
			break;
		case PICKER_TEXT_REQUEST:

			String value = data.getStringExtra(Run.EXTRA_VALUE);
			if(mSelectName){
				value = mLoginedUser.getDisplayName();
			}
			mCurHandler.setSettingValue(value);
			if (mItemSettingHandlers.contains(mCurHandler)) {
				try {
					mSettingItems.get(mItemSettingHandlers.indexOf(mCurHandler)).put("attr_value", data.getStringExtra(Run.EXTRA_VALUE));
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			break;

		default:
			super.onActivityResult(requestCode, resultCode, data);
			break;
		}
	}

	void updateAvatarFromFullPath(String fileFullpathString) {
		try {
			FileOutputStream fos = null;
			Bitmap nBitmap = com.qianseit.westore.util.loader.FileUtils.getBitMap(fileFullpathString);
			if (nBitmap == null) {
				CommonLoginFragment.showAlertDialog(mActivity, "图片不存在，请重新拍摄或在相册中选择", "", "OK", null, null, false, null);
				return;
			}

			File file = new File(Run.doCacheFolder, "file");
			if (!file.getParentFile().exists())
				file.getParentFile().mkdirs();

			fos = new FileOutputStream(file);
			nBitmap.compress(CompressFormat.JPEG, 100, fos);
			fos.flush();

			// 更新到服务器
			mSaveSettingInterface.save(mSettingItems.get(mItemSettingHandlers.indexOf(mCurHandler)).optString("attr_column"), file);
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
			mFile = com.qianseit.westore.util.loader.FileUtils.createFile();
			Intent i = new Intent("android.media.action.IMAGE_CAPTURE");
			i.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(mFile));
			startActivityForResult(i, TAKE_PHOTO_ID);
		} catch (IOException e) {
			// TODO 自动生成的 catch 块
			Log.w(Run.TAG, e.getMessage());
		}
	}

	/**
	 * 调用系统截图工具裁剪图片
	 */
	private void gotoCrop(String path) {
		Log.i("tentinet---->", "" + "333333333" + path);
		Bundle bundle = new Bundle();
		ClipPictureBean clipPictureBean = new ClipPictureBean();
		clipPictureBean.setSrcPath(path);
		clipPictureBean.setOutputX(150);
		clipPictureBean.setOutputY(150);
		// clipPictureBean.setOutputX(600);
		// clipPictureBean.setOutputY(600);
		clipPictureBean.setAspectX(1);
		clipPictureBean.setAspectY(1);
		bundle.putSerializable(getString(R.string.intent_key_serializable), clipPictureBean);
		// IntentUtil.gotoActivityForResult(this, ClipPictureActivity.class,
		// bundle, RequestCode.REQUEST_CODE_CROP_ICON);
		// Bundle bundle = new Bundle();
		// bundle.putByteArray("picture", data);
		bundle.putSerializable(getString(R.string.intent_key_serializable), clipPictureBean);
		// IntentUtil.gotoActivityForResult(this, ClipPictureActivity.class,
		// bundle, RequestCode.REQUEST_CODE_CROP_ICON);
		// Intent intent = new Intent(mActivity, ClipPictureActivitys.class);
		Intent intent = new Intent(mActivity, CropperActivity.class);
		// Bundle bundle = new Bundle();
		// bundle.putByteArray("picture", data);
		intent.putExtras(bundle);
		// startActivity(intent);

		//
		// Intent intent = AgentActivity.intentForFragment(mActivity,
		// AgentActivity.FRAGMENT_GOODS_XIUJIAN);
		// intent.putExtras(bundle);
		// intent.putExtra("ID",mID);
		// startActivityForResult(intent, reque);
		// getActivity().finish();
		intent.putExtra("ID", "");
		startActivityForResult(intent, CROPPER_PHOTO_ID);
	}
}
