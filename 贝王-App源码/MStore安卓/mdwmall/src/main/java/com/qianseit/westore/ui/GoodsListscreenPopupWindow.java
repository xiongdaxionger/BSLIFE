package com.qianseit.westore.ui;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.text.Html;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnKeyListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class GoodsListscreenPopupWindow extends PopupWindow implements OnClickListener {

	private Context mContext;
	private View mView;
	private LinearLayout mContentLinear;
	private onScreenListPopupCheckListener mListener;
	private List<JSONObject> dataJSON;
	int mDockViewID;
	private LayoutInflater mInflater;
	private int displayWidth;
	private int mGoodsNum;
	private TextView mGoodsNumText;
	int mWidth = 0;

	public GoodsListscreenPopupWindow(Context context, int dockViewID, onScreenListPopupCheckListener listener, List<JSONObject> dataJSON, ImageLoader mImageLoader, int GoodsNum) {
		this.mContext = context;
		mInflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		this.mListener = listener;
		this.dataJSON = dataJSON;
		this.mGoodsNum = GoodsNum;
		mDockViewID = dockViewID;
		mWidth = Run.getWindowsWidth((Activity) context) - Run.dip2px(context, 50);
		displayWidth = (mWidth - Run.dip2px(context, 4 * 15)) / 3;
		this.init();
		fillData(dataJSON, true);
	}

	public void setGoodsNum(int goodsNum) {
		String numStr = "<font color='#333333'>共</font><font color='#f52322'>" + goodsNum + "</font><font color='#333333'>件商品</font>";
		mGoodsNumText.setText(Html.fromHtml(numStr));
	}

	// 填充数据
	public void fillData(List<JSONObject> JSONData, boolean isRefresh) {
		if (isRefresh) {
			mContentLinear.removeAllViews();

			if (JSONData != null && JSONData.size() > 0) {
				for (int i = 0; i < JSONData.size(); i++) {
					JSONObject data = JSONData.get(i);
					fillGridView(mContentLinear, data, i);
				}
			}
		}
	}

	private void fillGridView(LinearLayout parentView, final JSONObject data, final int postion) { // 规格
		// 类型等
		View view = mInflater.inflate(R.layout.item_screening, null);
		String type = data.optString("screen_name");
		((TextView) view.findViewById(R.id.screeing_type_tv)).setText(type);
		final ImageView mIcon = ((ImageView) view.findViewById(R.id.screeing_more_img));
		final MyGridView mGridView = (MyGridView) view.findViewById(R.id.screeing_grid);
		RelativeLayout mTypeRelative = ((RelativeLayout) view.findViewById(R.id.screeing_type_Relative));
		JSONArray optionsArray = data.optJSONArray("options");
		final List<JSONObject> listData = new ArrayList<JSONObject>();

		if (optionsArray != null && optionsArray.length() > 0) {
			for (int i = 0; i < optionsArray.length(); i++) {
				JSONObject optionsJSON = optionsArray.optJSONObject(i);
//				initItemStatus(optionsJSON, 2);
				listData.add(optionsJSON);
			}
		}
		
		GoodsListGridAdapter mAdapter;
		view.setTag(R.id.about_tel, listData);// 原始数据
//		if (postion == 0) {
			if (listData.size() > 3) {
				mIcon.setVisibility(View.VISIBLE);
				mTypeRelative.setEnabled(true);
				mTypeRelative.setTag(false);
				List<JSONObject> incomeData = new ArrayList<JSONObject>();
				for (int i = 0; i < 3; i++) {
					incomeData.add(listData.get(i));
				}
				mAdapter = new GoodsListGridAdapter(incomeData);
			} else {
				mIcon.setVisibility(View.GONE);
				mTypeRelative.setEnabled(false);
				mAdapter = new GoodsListGridAdapter(listData);
			}
//		} else {
//			mIcon.setVisibility(View.VISIBLE);
//			mTypeRelative.setTag(false);
//			mTypeRelative.setEnabled(true);
//			mGridView.setVisibility(View.GONE);
//			mAdapter = new GoodsListGridAdapter(listData);
//		}
		mGridView.setAdapter(mAdapter);

		view.setTag(R.id.tag_object, data);
		parentView.addView(view);

		mTypeRelative.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				boolean status = (Boolean) v.getTag();
//				if (postion == 0) {
					if (!status) { // 展开
						mIcon.setImageResource(R.drawable.screening_icon);
						mGridView.setAdapter(new GoodsListGridAdapter(listData));
					} else { // 收缩
						mIcon.setImageResource(R.drawable.screening_more_icon);
						List<JSONObject> incomeData = new ArrayList<JSONObject>();
						for (int i = 0; i < 3; i++) {
							incomeData.add(listData.get(i));
						}
						mGridView.setAdapter(new GoodsListGridAdapter(incomeData));
					}
//				} else {
//					if (!status) { // 展开
//						mGridView.setVisibility(View.VISIBLE);
//					} else {
//						mGridView.setVisibility(View.GONE);
//					}
//				}
				v.setTag(status ? false : true);
			}
		});
		// 选中效果
		mGridView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

				if (!data.optBoolean("screen_single", false)) { // 多选
					initMulData(listData, position);

				} else { // 单选
					initSingle(listData, position);
				}
				((GoodsListGridAdapter) parent.getAdapter()).notifyDataSetChanged();
			}
		});

	}

	private void initSingle(List<JSONObject> jsonData, int postion) {
		for (int i = 0; i < jsonData.size(); i++) {
			if (i != postion) {
				JSONObject itemJSON = jsonData.get(i);
				initItemStatus(itemJSON, 2);
			}
		}
		initItemStatus(jsonData.get(postion), 1);
	}

	// 初始筛选(多选 不包含全部)
	private void initMulData(List<JSONObject> jsonData, int postion) {

		JSONObject itemJSON = jsonData.get(postion);
		initItemStatus(itemJSON, 1);

	}

	// 初始筛选(多选 包含全部)
	private void initMulDataAll(List<JSONObject> jsonData, int postion) {
		if (postion == 0) {
			if (jsonData.size() > 1) {
				for (int i = 1; i < jsonData.size(); i++) {
					JSONObject itemJSON = jsonData.get(i);
					initItemStatus(itemJSON, 2);
				}
			}
			JSONObject itemJSON = jsonData.get(postion);
			initItemStatus(itemJSON, 0);

		} else {
			JSONObject itemJSON = jsonData.get(postion);
			initItemStatus(itemJSON, 1);

			if (isALLNoSelect(jsonData)) {
				JSONObject allJSON = jsonData.get(0);
				initItemStatus(allJSON, 0);
			} else {
				JSONObject allJSON = jsonData.get(0);
				initItemStatus(allJSON, 2);
			}

		}
	}

	private boolean isALLNoSelect(List<JSONObject> allArray) {
		for (int i = 1; i < allArray.size(); i++) {
			JSONObject dataJSON = allArray.get(i);
			if (!dataJSON.isNull("mark") && dataJSON.optBoolean("mark")) {
				return false;
			}
		}
		return true;
	}

	private void initItemStatus(JSONObject itemJSON, int status) { // 0:选中当前项
																	// 1:改变当前项状态
																	// (选中改变成不选中，不选中改成选中)
																	// 2:不选中其中项
		switch (status) {
		case 0:
			try {
				if (itemJSON.isNull("mark")) {

					itemJSON.put("mark", true);

				} else {
					itemJSON.remove("mark");
					itemJSON.put("mark", true);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			break;
		case 1:
			try {
				if (itemJSON.isNull("mark") || !itemJSON.optBoolean("mark")) {
					if (itemJSON.isNull("mark")) {
						itemJSON.put("mark", true);
					} else {
						itemJSON.remove("mark");
						itemJSON.put("mark", true);
					}
				} else {
					itemJSON.remove("mark");
					itemJSON.put("mark", false);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			break;
		case 2:
			try {
				try {
					if (itemJSON.isNull("mark")) {

						itemJSON.put("mark", false);

					} else {
						itemJSON.remove("mark");
						itemJSON.put("mark", false);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			break;
		default:
			break;
		}

	}

	private void init() {

		this.mView = View.inflate(mContext, R.layout.fragment_list_screening, null);
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
		this.setWidth(mWidth);
		this.setHeight(LayoutParams.MATCH_PARENT);
		this.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		this.setTouchable(true);
		this.setFocusable(true);
		this.setOutsideTouchable(true);
		this.update();
		mContentLinear = (LinearLayout) this.mView.findViewById(R.id.list_screening_content_linear);
		mGoodsNumText = (TextView) this.mView.findViewById(R.id.list_goods_num);
		this.mView.findViewById(R.id.list_screening_reset_but).setOnClickListener(this);
		this.mView.findViewById(R.id.list_screening_confirm_but).setOnClickListener(this);
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
		WindowManager.LayoutParams params = ((Activity) mContext).getWindow().getAttributes();
		params.alpha = 0.7f;
		((Activity) mContext).getWindow().setAttributes(params);
	}

	@Override
	public void dismiss() {
		WindowManager.LayoutParams params = ((Activity) mContext).getWindow().getAttributes();
		params.alpha = 1f;
		((Activity) mContext).getWindow().setAttributes(params);
		super.dismiss();
	}

	private class GoodsListGridAdapter extends BaseAdapter {
		private ViewHolder mHolder;
		private List<JSONObject> mLists;

		public GoodsListGridAdapter(List<JSONObject> mLists) {
			this.mLists = mLists;
		}

		@Override
		public int getCount() {
			return mLists.size();
		}

		@Override
		public Object getItem(int position) {
			return mLists.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {

			if (convertView == null) {
				int padding = Run.dip2px(mContext, 1);
				mHolder = new ViewHolder();
				convertView = View.inflate(mContext, R.layout.item_screen_grid, null);
				mHolder.mTitle = (TextView) convertView.findViewById(R.id.item_values_text);
				mHolder.mIcon = (ImageView) convertView.findViewById(R.id.item_values_icon);
				mHolder.mLayout = (RelativeLayout) convertView.findViewById(R.id.item_values_linear);
				mHolder.mStatus = (TextView) convertView.findViewById(R.id.item_values_status);
				RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(displayWidth, displayWidth / 2);
				mHolder.mLayout.setLayoutParams(layoutParams);
				mHolder.mLayout.setPadding(padding, padding, padding, padding);
				convertView.setTag(mHolder);
			} else {
				mHolder = (ViewHolder) convertView.getTag();
			}
			JSONObject json = mLists.get(position);

			if (json.isNull("logo")) {
				mHolder.mLayout.setVisibility(View.GONE);
				mHolder.mTitle.setVisibility(View.VISIBLE);
				mHolder.mTitle.setSelected(json.optBoolean("mark", false));
				if (json.isNull("mark") || !json.optBoolean("mark")) {
					mHolder.mTitle.setBackgroundResource(R.drawable.shape_solid_round2_gray);
				} else {
					mHolder.mTitle.setBackgroundResource(R.drawable.shape_solid_round2_red);
				}

				mHolder.mTitle.setText(json.optString("name"));
			} else {
				mHolder.mTitle.setVisibility(View.GONE);
				mHolder.mLayout.setVisibility(View.VISIBLE);
				BaseDoFragment.displaySquareImage(mHolder.mIcon, json.optString("logo"));
				if (json.isNull("mark") || !json.optBoolean("mark")) {
					mHolder.mLayout.setBackgroundResource(R.drawable.white);
				} else {
					mHolder.mLayout.setBackgroundResource(R.drawable.shape_stroke_round2_red);
				}
			}
			return convertView;
		}

		private class ViewHolder {
			public TextView mTitle;
			public TextView mStatus;
			public ImageView mIcon;
			public RelativeLayout mLayout;
		}
	}

	public void notifyDataSetChanged() {
		// this.mAdapter.notifyDataSetChanged();
	}

	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.list_screening_reset_but) { // 重置
			fillData(dataJSON, true);
		} else if (v.getId() == R.id.list_screening_confirm_but) { // 完成
			int count = mContentLinear.getChildCount();
			List<JSONObject> ListResult = new ArrayList<JSONObject>();
			try {
				for (int i = 0; i < count; i++) {
					View childView = mContentLinear.getChildAt(i);
					@SuppressWarnings("unchecked")
					List<JSONObject> itemListData = (List<JSONObject>) childView.getTag(R.id.about_tel);
					JSONObject childJSON = (JSONObject) childView.getTag(R.id.tag_object);
					String key = "";
					if (childJSON == null) {
						continue;
					}
					
					key = childJSON.optString("screen_field");
					
					if (itemListData != null && itemListData.size() > 0) {
						int nKeyIndex = 0;
						for (int j = 0; j < itemListData.size(); j++) {
							JSONObject itemJSON = itemListData.get(j);
							if (itemJSON.optBoolean("mark", false)) {
								JSONObject ValueJSON = new JSONObject();
								ValueJSON.put("key", String.format("%s[%d]", key, nKeyIndex));
								ValueJSON.put("value", itemJSON.optString("val"));
								nKeyIndex++;
								ListResult.add(ValueJSON);
							}
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			mListener.onScreenResult(ListResult, 0);
			dismiss();
		}

	}

	public interface onScreenListPopupCheckListener {
		void onScreenResult(List<JSONObject> ListJson, int dockViewID);
	}
}
