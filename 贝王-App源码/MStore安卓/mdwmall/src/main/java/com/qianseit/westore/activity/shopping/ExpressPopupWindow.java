package com.qianseit.westore.activity.shopping;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.view.View.OnKeyListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.beiwangfx.R;

public abstract class ExpressPopupWindow extends PopupWindow {

	private Activity mActivity;
	private View mView;
	private ListView mListView;
	private View mActionView;

	List<JSONObject> mJsonObjects = new ArrayList<JSONObject>();

	QianseitAdapter<JSONObject> mAdapter;

	boolean isProtacted = false;
	JSONObject mCurJsonObject;
	Dialog mDialog;

	public ExpressPopupWindow(Activity activity) {
		this.mActivity = activity;
		this.init();
	}

	private void init() {

		this.mView = View.inflate(mActivity, R.layout.dialog_express_main, null);
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
		WindowManager wm = (WindowManager) mView.getContext().getSystemService(Context.WINDOW_SERVICE);
		this.setWidth(wm.getDefaultDisplay().getWidth());
		this.setHeight(wm.getDefaultDisplay().getHeight() * 3 / 4);
		this.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		this.setTouchable(true);
		this.setFocusable(true);
		this.setOutsideTouchable(true);
		this.update();

		mListView = (ListView) this.mView.findViewById(R.id.express_listview);
		mAdapter = new QianseitAdapter<JSONObject>(mJsonObjects) {

			@Override
			public View getView(int position, View convertView, ViewGroup parent) {
				// TODO Auto-generated method stub
				if (convertView == null) {
					convertView = View.inflate(mActivity, R.layout.item_express_list, null);
				}
				JSONObject jsonData = getItem(position);
				((TextView) convertView.findViewById(R.id.express_text)).setText(jsonData.optString("dt_name"));
				return convertView;
			}
		};
		mListView.setAdapter(mAdapter);
		mListView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int position, long arg3) {
				onSelected(position);
				dismiss();
			}
		});

		mActionView = this.mView.findViewById(R.id.action);
		mActionView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (isShowing()) {
					dismiss();
				}
				onItemSelected((JSONObject) v.getTag(), false);
			}
		});

		this.mView.findViewById(R.id.cancel).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if (isShowing()) {
					dismiss();
				}
			}
		});

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
	public void dismiss() {
		WindowManager.LayoutParams params = mActivity.getWindow().getAttributes();
		params.alpha = 1f;
		mActivity.getWindow().setAttributes(params);
		super.dismiss();
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
		WindowManager.LayoutParams params = mActivity.getWindow().getAttributes();
		params.alpha = 0.7f;
		mActivity.getWindow().setAttributes(params);
	}

	public void onSelected(int position) {
		if (mJsonObjects == null || mJsonObjects.size() <= position || position < 0) {
			return;
		}

		final JSONObject nJsonObject = mJsonObjects.get(position);
		boolean canProtected = nJsonObject.optBoolean("protect");
		if (canProtected) {
			if (mCurJsonObject != null && nJsonObject.optInt("dt_id") == mCurJsonObject.optInt("dt_id") && isProtacted) {
				mDialog = CommonLoginFragment.showAlertDialog(mActivity, "您使用了该物流方式的物流保价，您需要取消使用物流报价吗？", nJsonObject.optString("text"), "取消使用", "继续使用", new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub需要
						onItemSelected(nJsonObject, false);
						mDialog.dismiss();
					}
				}, null);
			} else {
				mDialog = CommonLoginFragment.showAlertDialog(mActivity, "该配送方式开启了物流报价，您需要使用物流报价吗？", nJsonObject.optString("text"), "需要", "不需要", new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub需要
						onItemSelected(nJsonObject, true);
						mDialog.dismiss();
					}
				}, new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub不需要
						onItemSelected(nJsonObject, false);
						mDialog.dismiss();
					}
				});
			}
			return;
		}

		onItemSelected(mJsonObjects.get(position), false);
	}

	public void setExpressData(JSONArray array, JSONObject curJsonObject, boolean isProtacted) {
		mActionView.setVisibility(View.GONE);
		mJsonObjects.clear();
		if (array == null) {
			return;
		}

		for (int i = 0; i < array.length(); i++) {
			JSONObject json = array.optJSONObject(i);
			if (json.optString("dt_name").contains("自提")) {
				mActionView.setVisibility(View.VISIBLE);
				mActionView.setTag(json);
			} else {
				mJsonObjects.add(json);
			}
		}

		this.isProtacted = isProtacted;
		mCurJsonObject = curJsonObject;
	}

	public void notifyDataSetChanged() {
		this.mAdapter.notifyDataSetChanged();
	}

	public abstract void onItemSelected(JSONObject selectedBean, boolean isProtacted);
}
