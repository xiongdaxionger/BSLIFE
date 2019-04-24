package com.qianseit.westore.activity.wealth;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ImageView;
import android.widget.TextView;

import com.baoyz.swipemenulistview.SwipeMenuItem;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.base.BaseSwticListFragment;
import com.qianseit.westore.bean.BankInfo;
import com.qianseit.westore.httpinterface.wealth.WealthBankCardDeleteInterface;
import com.qianseit.westore.ui.XPullDownSwipeMenuListView;
import com.qianseit.westore.util.StringUtils;
import com.beiwangfx.R;

/**
 * 银行卡 如果是从提现页面跳转过来 则需要传title 如果是从充值页面过来 也需要传title
 * 
 * @author Administrator
 * 
 */
public class WealthBankCardFragment extends BaseSwticListFragment {

	private String title;
	private Dialog mDelDialog;
	String mVCodeUrl = "";
	JSONObject mCurJsonObject;

	WealthBankCardDeleteInterface mDeleteInterface = new WealthBankCardDeleteInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mResultLists.remove(mCurJsonObject);
			mAdapter.notifyDataSetChanged();
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		title = getActivity().getIntent().getStringExtra(Run.EXTRA_TITLE);
		mActionBar.setShowHomeView(true);
		mActionBar.setTitle(title == null ? "银行卡" : title);
		mActionBar.setShowBackButton(true);
		mActionBar.setShowRightButton(true);
	}

	@Override
	public void onClick(View v) {
		super.onClick(v);
		switch (v.getId()) {
		case R.id.bank_add_linear:
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_WEALTH_BANK_CARD_ADD).putExtra(Run.EXTRA_TITLE, "提现账号").putExtra(Run.EXTRA_DATA, mVCodeUrl));
			break;
		default:
			break;
		}
	}

	@Override
	protected void addFooter(XPullDownSwipeMenuListView listView) {
		// TODO Auto-generated method stub
		View bankAddView = View.inflate(mActivity, R.layout.fragment_add_bank_item, null);
		bankAddView.setOnClickListener(this);
		listView.addFooterView(bankAddView);
		listView.setEmptyView(null);
		listView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				// TODO Auto-generated method stub

				JSONObject nJsonObject = (JSONObject) parent.getAdapter().getItem(position);
				Intent intent = new Intent();
				BankInfo nBankInfo = new BankInfo();
				nBankInfo.setBank_id(nJsonObject.optString("member_bank_id"));
				nBankInfo.setBank_name(nJsonObject.optString("bank_name"));
				nBankInfo.setBank_num(nJsonObject.optString("bank_num"));
				nBankInfo.setBank_type(nJsonObject.optString("bank_type"));
				nBankInfo.setImgPath(nJsonObject.optString("bank_img"));
				nBankInfo.setReal_name(nJsonObject.optString("real_name"));
				nBankInfo.setSelected(true);
				intent.putExtra(Run.EXTRA_DATA, nBankInfo);
				mActivity.setResult(Activity.RESULT_OK, intent);
				mActivity.finish();
			}
		});
	}
	
	void DelDialog(final String backID) {

		mDelDialog = CommonLoginFragment.showAlertDialog(mActivity, getString(R.string.acco_bank_confirm), R.string.cancel, R.string.ok, null, new OnClickListener() {

			@Override
			public void onClick(View v) {
				mDelDialog.dismiss();
				mDeleteInterface.delete(backID);
			}
		}, false, null);
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		super.onActivityResult(requestCode, resultCode, data);
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		onRefresh();
	}
	
	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = getActivity().getLayoutInflater().inflate(R.layout.item_bank_card, null);
		}
		if (responseJson.optInt("bank_type") == 2) {
			((TextView) convertView.findViewById(R.id.tv_title)).setText(StringUtils.BankCardNumber(responseJson.optString("bank_num")));
			((TextView) convertView.findViewById(R.id.tv_content)).setText(responseJson.optString("real_name") + "   " + responseJson.optString("bank_name"));
			((ImageView) convertView.findViewById(R.id.iv_icon)).setImageResource(R.drawable.icon_pay_2);
		} else {
			((TextView) convertView.findViewById(R.id.tv_content)).setText(responseJson.optString("real_name") + "   " + responseJson.optString("bank_name"));
			displayImage((ImageView) convertView.findViewById(R.id.iv_icon), responseJson.optString("bank_img"), R.drawable.icon_pay_1);
			((TextView) convertView.findViewById(R.id.tv_title)).setText(StringUtils.BankCardNumber(responseJson.optString("bank_num")));
		}
		convertView.setTag(responseJson);
		return convertView;
	}

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		mVCodeUrl = responseJson.optString("code_url");
		if (!responseJson.optBoolean("show_varycode")) {
			mVCodeUrl = "";
		}
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		
		JSONArray nArray = responseJson.optJSONArray("banklists");
		if (nArray == null || nArray.length() <= 0) {
			return nJsonObjects;
		}
		
		for (int i = 0; i < nArray.length(); i++) {
			nJsonObjects.add(nArray.optJSONObject(i));
		}
		
		return nJsonObjects;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.wallet.get_banklists";
	}

	@Override
	public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
		// TODO Auto-generated method stub

	}

	@Override
	protected void initActionBar() {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		PageEnable(false);
		AutoLoad(false);
	}

	@Override
	protected List<SwipeMenuItem> createSwipeMenuItems(int viewType) {
		// TODO Auto-generated method stub
		List<SwipeMenuItem> nItems = new ArrayList<SwipeMenuItem>();
		SwipeMenuItem deleteItem = new SwipeMenuItem(mActivity);
		deleteItem.setBackground(new ColorDrawable(Color.rgb(0xF9, 0x3F, 0x25)));
		deleteItem.setWidth(Run.dip2px(mActivity, 60));
		deleteItem.setIcon(R.drawable.ic_delete);
		nItems.add(deleteItem);
		return nItems;
	}

	@Override
	protected void onSwipeMenuItemClick(JSONObject positionJsonObject, int index) {
		// TODO Auto-generated method stub
		String bankID = positionJsonObject.optString("member_bank_id");
		mCurJsonObject = positionJsonObject;
		DelDialog(bankID);
	}
}
