package com.qianseit.westore.activity.address;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.beiwangfx.R;;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.member.MemberAddrDefualtInterface;
import com.qianseit.westore.httpinterface.member.MemberAddrDeleteInterface;
import com.qianseit.westore.httpinterface.member.MemberReceiverAddrInterface;
import com.qianseit.westore.util.StringUtils;
import com.umeng.analytics.MobclickAgent;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class AddressBookFragment extends BaseDoFragment {
	private final int REQUEST_CODE_EDIT_ADDRESS = 0x100;
	private final String CHOOSED_ADDR = "choosed_addr";
	/**会员ID
	 */
	private String mSelectMemberID = LoginedUser.getInstance().getMember().getMember_id();
	private ListView mlisListView;

	private ArrayList<JSONObject> mAddressList = new ArrayList<JSONObject>();
	private AddressAdapter mAdapter;
	private boolean isPickAddress;
	private View mAddReceiverAddrtextView;

	private JSONObject oldAddress;

	MemberReceiverAddrInterface mReceiverAddrInterface = new MemberReceiverAddrInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mAddressList.clear();
			String addr_id = "";
			if (oldAddress != null) {
				addr_id = oldAddress.optString("addr_id");
			}

			try {
				JSONArray child = responseJson.optJSONArray("receiver");
				if (child != null && child.length() > 0) {
					for (int i = 0, c = child.length(); i < c; i++) {
						JSONObject nJsonObject = child.optJSONObject(i);
						if (!TextUtils.isEmpty(addr_id)) {
							nJsonObject.put(CHOOSED_ADDR, addr_id.equals(nJsonObject.optString("addr_id")));
						}
						mAddressList.add(nJsonObject);
					}
				}
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			mAddReceiverAddrtextView.setVisibility(View.VISIBLE);
			mAdapter.notifyDataSetChanged();
		}
	};

	MemberAddrDefualtInterface mAddrDefualtInterface = new MemberAddrDefualtInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mReceiverAddrInterface.getAddressList(mSelectMemberID);
		}
	};
	MemberAddrDeleteInterface mAddrDeleteInterface = new MemberAddrDeleteInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mReceiverAddrInterface.getAddressList(mSelectMemberID);
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		try {
			Intent data = mActivity.getIntent();
			isPickAddress = data.getBooleanExtra(Run.EXTRA_VALUE, false);
			String address = data.getStringExtra("old_address");
			mSelectMemberID = data.getStringExtra("member_id");
			if (address != null && !TextUtils.isEmpty(address)) {
				try {
					oldAddress = new JSONObject(address);
				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
		} catch (Exception e) {
		}
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// mActionBar.getBackButton().setOnClickListener(this);
		rootView = inflater.inflate(R.layout.fragment_my_address_book, null);
		mAddReceiverAddrtextView = rootView.findViewById(R.id.account_add_address_text);
		mAddReceiverAddrtextView.setVisibility(View.GONE);
		mlisListView = (ListView) findViewById(android.R.id.list);
		mAddReceiverAddrtextView.setOnClickListener(this);
		mAdapter = new AddressAdapter();
		mlisListView.setAdapter(mAdapter);
		mlisListView.setEmptyView(findViewById(R.id.base_error_rl));

		// 加载收获地址列表
		mReceiverAddrInterface.getAddressList(mSelectMemberID);
	}

	@Override
	protected void back() {
		// TODO Auto-generated method stub
		if (isPickAddress) {
			setResult();
		}
		super.back();
	}

	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.account_add_address_text) {
			startActivityForResult(
					AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ADDR_BOOK_EDITOR).putExtra("com.qianseit.westore.EXTRA_FILE_NAME", ((TextView) v).getText().toString()).putExtra("member_id",mSelectMemberID),
					REQUEST_CODE_EDIT_ADDRESS);
		} else {
			super.onClick(v);
		}
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			setResult();
			mActivity.finish();
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

	@Override
	public void onResume() {
		super.onResume();
		if (isPickAddress) {
			mActionBar.setTitle(R.string.order_detail_address);
		} else {
			mActionBar.setTitle(R.string.accout_my_address_book);
		}
	}

	@Override
	public void onPause() {
		super.onPause();
		MobclickAgent.onPageEnd("1_11_6");
	}

	private void setResult() {
		JSONObject addressObj = null;
		for (int i = 0; i < mAddressList.size(); i++) {
			if (mAddressList.get(i).optBoolean(CHOOSED_ADDR)) {
				addressObj = mAddressList.get(i);
				break;
			}
		}
		if (addressObj != null) {
			Intent data = new Intent();
			data.putExtra(Run.EXTRA_DATA, addressObj.toString());
			mActivity.setResult(Activity.RESULT_OK, data);
		} else {
			Intent data = new Intent();
			data.putExtra(Run.EXTRA_DATA, "{}");
			mActivity.setResult(Activity.RESULT_OK, data);
		}
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == REQUEST_CODE_EDIT_ADDRESS && resultCode == Activity.RESULT_OK) {
			if (isPickAddress) {
				mActivity.setResult(Activity.RESULT_OK, data);
				mActivity.finish();
			}else{
				mReceiverAddrInterface.getAddressList(mSelectMemberID);
			}
		}
	}

	private class AddressAdapter extends BaseAdapter implements OnClickListener {
		private LayoutInflater inflater;
		private Dialog mDialog;

		public AddressAdapter() {
			inflater = mActivity.getLayoutInflater();
		}

		@Override
		public int getCount() {
			return mAddressList.size();
		}

		@Override
		public JSONObject getItem(int position) {
			return mAddressList.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			if (convertView == null) {
				int layout = R.layout.fragment_account_address_item;
				convertView = inflater.inflate(layout, null);
				convertView.setOnClickListener(this);
				convertView.findViewById(R.id.my_address_book_item_edit).setOnClickListener(this);
				convertView.findViewById(R.id.my_address_book_item_default).setOnClickListener(this);
				convertView.findViewById(R.id.my_address_book_item_delete).setOnClickListener(this);
				convertView.findViewById(R.id.my_address_book_item_edit_tv).setOnClickListener(this);
			}

			if (!isPickAddress) {
				convertView.findViewById(R.id.my_address_book_item_default).setVisibility(View.INVISIBLE);
			} else {
				convertView.findViewById(R.id.my_address_book_item_default).setVisibility(View.VISIBLE);
			}

			JSONObject all = getItem(position);
			if (all == null)
				return convertView;

			((TextView) convertView.findViewById(R.id.my_address_book_item_name)).setText(all.optString("name"));

			String userSFId = all.optString("card_num");
			String newUserSFId = userSFId;
			if (userSFId.length() >= 15 && userSFId.length() <= 18) {
				newUserSFId = userSFId.substring(0, 6) + "******";
				newUserSFId += userSFId.substring(userSFId.length() - 4, userSFId.length());
			}
			((TextView) convertView.findViewById(R.id.my_address_book_item_id)).setText(newUserSFId);

			String nString = StringUtils.getString(all, "mobile");
			if (TextUtils.isEmpty(nString)) {
				nString = StringUtils.getString(all, "tel");
			}
			((TextView) convertView.findViewById(R.id.my_address_book_item_phone)).setText(nString);
			((TextView) convertView.findViewById(R.id.my_address_book_item_address)).setText(Run.buildString(StringUtils.FormatArea(all.optString("area")), " ", all.optString("addr")));

			convertView.setTag(all);
			convertView.findViewById(R.id.my_address_book_item_edit).setTag(all);
			convertView.findViewById(R.id.my_address_book_item_default).setTag(all);
			convertView.findViewById(R.id.my_address_book_item_delete).setTag(all);
			convertView.findViewById(R.id.my_address_book_item_edit_tv).setTag(all);

			// 是否为默认
			boolean isDef = all.optInt("def_addr") == 1;
			if (isDef) {
				convertView.findViewById(R.id.my_address_book_item_default_tv).setVisibility(View.VISIBLE);
				((TextView) convertView.findViewById(R.id.my_address_book_item_default_tv)).setText("[默认]");
			} else {
				convertView.findViewById(R.id.my_address_book_item_default_tv).setVisibility(View.GONE);
			}

			((Button) convertView.findViewById(R.id.my_address_book_item_default)).setCompoundDrawablesWithIntrinsicBounds(isDef ? R.drawable.qianse_item_status_selected
					: R.drawable.qianse_item_status_unselected, 0, 0, 0);
			return convertView;
		}

		@Override
		public void onClick(View v) {
			if (v.getTag() != null) {
				final JSONObject all = (JSONObject) v.getTag();
				if (isPickAddress && v.getId() == R.id.my_address_book_item_parent) {
					Intent data = new Intent();
					data.putExtra(Run.EXTRA_DATA, all.toString());
					mActivity.setResult(Activity.RESULT_OK, data);
					mActivity.finish();
				} else if (v.getId() == R.id.my_address_book_item_default) {
					setSelectedAddress(all);
					notifyDataSetChanged();
				} else if (v.getId() == R.id.my_address_book_item_edit || v.getId() == R.id.my_address_book_item_edit_tv) {

					startActivityForResult(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ADDR_BOOK_EDITOR).putExtra(Run.EXTRA_DATA, all.toString())
							.putExtra(Run.EXTRA_VALUE, false), REQUEST_CODE_EDIT_ADDRESS);

				} else if (v.getId() == R.id.my_address_book_item_delete) {
					// 删除地址
					final JSONObject mJSONObject = (JSONObject) v.getTag();
					mDialog = CommonLoginFragment.showAlertDialog(mActivity, "确定删除此收货信息？", "取消", "确定", new OnClickListener() {

						@Override
						public void onClick(View v) {
							mDialog.dismiss();
						}
					}, new OnClickListener() {

						@Override
						public void onClick(View v) {
							String addrId = mJSONObject.optString("addr_id");
							mAddrDeleteInterface.delete(addrId,mSelectMemberID);
							mDialog.dismiss();
						}
					}, false, null);
				}
			}
		}

		void setSelectedAddress(JSONObject addressJsonObject) {
			oldAddress = addressJsonObject;
			int index = mAddressList.indexOf(addressJsonObject);
			try {
				for (int i = 0; i < mAddressList.size(); i++) {
					mAddressList.get(i).put(CHOOSED_ADDR, i == index);
				}
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}