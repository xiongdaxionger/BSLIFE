package com.qianseit.westore.activity.shopping;

import android.annotation.SuppressLint;
import android.app.ActionBar.LayoutParams;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseDoFragment;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class ShoppingExpressPickFragment extends BaseDoFragment {

	private List<JSONObject> mExpressGridArray = new ArrayList<JSONObject>();
	private List<JSONObject> mTopDisplayGridArray = new ArrayList<JSONObject>();
	private List<JSONObject> mExpressListArray = new ArrayList<JSONObject>();
	private final static int MGETADDRESS = 0X100;
	private final static int MGETSTORE = 0X101;
	private final static int MGETSTORETIME = 0X102;
	private LayoutInflater mLayoutInflater;
	private int mTopPostion = 0, mListPostion = 0;
	private int gridWidth;
	private GridView mGridView;
	private BarGridAdapter mBarGridAdapter;
	private ExpressListAdapter mListAdapter;
	private LinearLayout mHintLinear, mSinceLinear;
	private String address;
	private String SinceResult;
	private JSONObject mStoreJSON;
	private String StoreTime;
	private long mLastBackDownTime = 0;
	private JSONObject JSONExpress;
	private ListView mListView;
	private String productId;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setTitle(R.string.confirm_order_expresspick);
		int width = Run.getWindowsWidth(mActivity);
		gridWidth = width / 4 - Run.dip2px(mActivity, 20);
		Intent data = mActivity.getIntent();
		productId = data.getStringExtra(Run.EXTRA_CLASS_ID);
		try {
			String jsonStr = data.getStringExtra(Run.EXTRA_VALUE);
			JSONArray child = new JSONArray(jsonStr);
			if (child.length() > 0) {
				for (int i = 0, c = child.length(); i < c; i++)
					mExpressGridArray.add(child.getJSONObject(i));
			}
			mTopDisplayGridArray.add(new JSONObject().put("dt_name", "送货上门"));
			for (int i = 0; i < mExpressGridArray.size(); i++) {
				JSONObject json = mExpressGridArray.get(i);
				if (json.optString("dt_name").contains("自提")) {
					mTopDisplayGridArray.add(json);
				} else {
					mExpressListArray.add(json);
				}
			}
		} catch (Exception e) {
			mActivity.finish();
		}

		mActionBar.setRightTitleButton("确定", new OnClickListener() {

			@Override
			public void onClick(View v) {
				setBank();

			}
		});

	}

	public static void setListViewHeightBasedOnChildren(ListView listView) {
		ListAdapter listAdapter = listView.getAdapter();
		if (listAdapter == null) {
			return;
		}
		int totalHeight = 0;
		for (int i = 0; i < listAdapter.getCount(); i++) {
			View listItem = listAdapter.getView(i, null, listView);
			listItem.measure(0, 0);
			totalHeight += listItem.getMeasuredHeight();
		}

		ViewGroup.LayoutParams params = listView.getLayoutParams();

		params.height = totalHeight + (listView.getDividerHeight() * (listAdapter.getCount() - 1));
		listView.setLayoutParams(params);
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		super.init(inflater, container, savedInstanceState);
		mLayoutInflater = inflater;
		rootView = inflater.inflate(R.layout.fragment_express_main, null);
		mGridView = (GridView) findViewById(R.id.express_grid);
		mListView = (ListView) findViewById(R.id.express_listview);
		mHintLinear = (LinearLayout) findViewById(R.id.express_hint_linear);
		mSinceLinear = (LinearLayout) findViewById(R.id.express_since_layout);
		findViewById(R.id.express_address_layout).setOnClickListener(this);
		findViewById(R.id.express_store_layout).setOnClickListener(this);
		findViewById(R.id.express_time_layout).setOnClickListener(this);

		mBarGridAdapter = new BarGridAdapter();
		mGridView.setAdapter(mBarGridAdapter);
		mListAdapter = new ExpressListAdapter();
		mListView.setAdapter(mListAdapter);
		setListViewHeightBasedOnChildren(mListView);

		if (mTopDisplayGridArray.size() > 0) {
			JSONObject josnBase = mExpressGridArray.get(0);
			setVisibLinear(josnBase);
		}
		mGridView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
				if (mTopPostion != arg2) {
					mTopPostion = arg2;
					JSONObject jsonData = (JSONObject) arg1.getTag();
					setVisibLinear(jsonData);
					mBarGridAdapter.notifyDataSetChanged();
				}

			}
		});

	}

	// 返回键处理
	// @Override
	// public boolean onKeyDown(int keyCode, KeyEvent event) {
	// if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
	// setBank();
	// return true;
	// }
	//
	// return super.onKeyDown(keyCode, event);
	// }

	void setBank() {
		long now = System.currentTimeMillis();
		// 点击Back键提示退出程序
		if (now - mLastBackDownTime > 3000) {
			mLastBackDownTime = now;
			if (mSinceLinear.getVisibility() == View.VISIBLE) {
				if (mStoreJSON == null || TextUtils.isEmpty(StoreTime)) {
					if (mStoreJSON == null) {
						Run.alert(mActivity, "请选择自提门店");
					} else if (TextUtils.isEmpty(StoreTime)) {
						Run.alert(mActivity, "请选择自提时间");
					}
				} else {
					try {
						JSONExpress.put("branch_id", mStoreJSON.optString("branch_id"));// 门店
						JSONExpress.put("time", StoreTime); // 时间
						Intent data = new Intent();
						data.putExtra(Run.EXTRA_DATA, JSONExpress.toString());
						mActivity.setResult(Activity.RESULT_OK, data);
						mActivity.finish();
					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			} else if (mHintLinear.getVisibility() == View.VISIBLE) {
				Intent data = new Intent();
				data.putExtra(Run.EXTRA_VALUE, "express");
				data.putExtra(Run.EXTRA_DATA, JSONExpress.toString());
				mActivity.setResult(Activity.RESULT_OK, data);
				mActivity.finish();
			} else {
				mActivity.finish();
			}
		} else {
			mActivity.finish();
		}
	}

	@Override
	public void onClick(View v) {
		super.onClick(v);
		if (v.getId() == R.id.express_address_layout) {
			startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_SINCE_ADDRESS).putExtra(Run.EXTRA_VALUE, productId), MGETADDRESS);
		} else if (v.getId() == R.id.express_store_layout) {
			// if (TextUtils.isEmpty(address)) {
			// Run.alert(mActivity, "请选择所在地区");
			// return;
			// }
			// startActivityForResult(AgentActivity.intentForFragment(mActivity,
			// AgentActivity.FRAGMENT_SHOPP_STORE).putExtra(Run.EXTRA_ADDR,
			// address).putExtra(Run.EXTRA_VALUE, SinceResult), MGETSTORE);
			startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_SPECIFIC_STORE).putExtra(Run.EXTRA_VALUE, productId), MGETSTORE);
		} else if (v.getId() == R.id.express_time_layout) {
			// if (TextUtils.isEmpty(address)) {
			// Run.alert(mActivity, "请选择所在地区");
			// return;
			// }
			if (mStoreJSON == null) {
				Run.alert(mActivity, "请选择自提门店");
				return;
			}
			startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_STORE_TIME), MGETSTORETIME);
		}
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (resultCode == Activity.RESULT_OK) {
			if (requestCode == MGETADDRESS) {
				address = data.getStringExtra(Run.EXTRA_ADDR);
				SinceResult = data.getStringExtra(Run.EXTRA_DATA);
				((TextView) findViewById(R.id.express_address_text)).setText(address);
				((TextView) findViewById(R.id.express_store_text)).setText("");
				mStoreJSON = null;
			} else if (requestCode == MGETSTORE) {
				String storeStr = data.getStringExtra(Run.EXTRA_DATA);
				try {
					mStoreJSON = new JSONObject(storeStr);
					if (!mStoreJSON.isNull("name")) {
						((TextView) findViewById(R.id.express_store_text)).setText(mStoreJSON.optString("name"));
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
			} else if (requestCode == MGETSTORETIME) {
				StoreTime = data.getStringExtra(Run.EXTRA_DATA);
				((TextView) findViewById(R.id.express_time_text)).setText(StoreTime);
			}
		}
	}

	private void setVisibLinear(JSONObject json) {
		if (json.optString("dt_name").contains("自提")) {
			JSONExpress = json;
			mListPostion = 0;
			mListAdapter.notifyDataSetChanged();
			mHintLinear.setVisibility(View.GONE);
			mSinceLinear.setVisibility(View.VISIBLE);
		} else {
			mHintLinear.setVisibility(View.VISIBLE);
			mSinceLinear.setVisibility(View.GONE);
			address = "";
			mStoreJSON = null;
			StoreTime = "";
			JSONExpress = mExpressListArray.get(mListPostion);

			((TextView) findViewById(R.id.express_store_text)).setText("");
			((TextView) findViewById(R.id.express_address_text)).setText("");
			((TextView) findViewById(R.id.express_time_text)).setText("");

		}
	}

	private class ExpressListAdapter extends BaseAdapter {

		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			return mExpressListArray.size();
		}

		@Override
		public JSONObject getItem(int position) {
			// TODO Auto-generated method stub
			return mExpressListArray.get(position);
		}

		@Override
		public long getItemId(int position) {
			// TODO Auto-generated method stub
			return position;
		}

		@Override
		public View getView(final int position, View convertView, ViewGroup parent) {
			ViewHolder mViewHolder;
			if (convertView == null) {
				mViewHolder = new ViewHolder();
				convertView = LayoutInflater.from(mActivity).inflate(R.layout.item_express_list, null);
				mViewHolder.mImageView = (ImageView) convertView.findViewById(R.id.express_img);
				mViewHolder.mTitleText = (TextView) convertView.findViewById(R.id.express_text);
				convertView.setTag(R.id.about_tel, mViewHolder);
			} else {
				mViewHolder = (ViewHolder) convertView.getTag(R.id.about_tel);
			}
			JSONObject jsonData = getItem(position);
			mViewHolder.mTitleText.setText(jsonData.optString("dt_name"));
			if (mListPostion == position) {
				mViewHolder.mImageView.setImageResource(R.drawable.qianse_item_status_selected);
			} else {
				mViewHolder.mImageView.setImageResource(R.drawable.qianse_item_status_unselected);
			}
			convertView.setTag(jsonData);
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					if (mListPostion != position) {
						mListPostion = position;
						JSONExpress = (JSONObject) v.getTag();
						mListAdapter.notifyDataSetChanged();
					}

				}
			});
			return convertView;
		}

		private class ViewHolder {
			private TextView mTitleText;
			private ImageView mImageView;

		}

	}

	private class BarGridAdapter extends BaseAdapter {

		private ViewHolder mHolder;

		@Override
		public int getCount() {
			return mTopDisplayGridArray.size();
		}

		@Override
		public Object getItem(int position) {
			return mTopDisplayGridArray.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@SuppressLint("ViewTag")
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {

			if (convertView == null) {
				mHolder = new ViewHolder();
				convertView = mLayoutInflater.inflate(R.layout.item_express, null);
				mHolder.mClassNameTV = (TextView) convertView.findViewById(R.id.bar_name_tv);
				RelativeLayout.LayoutParams layoutParams2 = new RelativeLayout.LayoutParams(gridWidth, LayoutParams.MATCH_PARENT);
				mHolder.mClassNameTV.setLayoutParams(layoutParams2);
				convertView.setTag(R.id.about_tel, mHolder);
			} else {
				mHolder = (ViewHolder) convertView.getTag(R.id.about_tel);
			}
			JSONObject item = (JSONObject) this.getItem(position);
			convertView.setTag(item);
			if (mTopPostion == position) {
				mHolder.mClassNameTV.setSelected(true);
			} else {
				mHolder.mClassNameTV.setSelected(false);
			}

			if (item != null) {
				mHolder.mClassNameTV.setText(item.optString("dt_name"));
			}
			return convertView;
		}

		private class ViewHolder {
			public TextView mClassNameTV;
		}
	}

}
