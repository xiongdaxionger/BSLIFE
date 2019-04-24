package com.qianseit.westore.activity.goods;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnKeyListener;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.TextView.OnEditorActionListener;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.goods.GoodsAssociateInterface;
import com.qianseit.westore.httpinterface.goods.GoodsHotSearchInterface;
import com.qianseit.westore.ui.CustomListPopupWindow;
import com.qianseit.westore.ui.CustomListPopupWindow.onCustomListPopupListener;
import com.qianseit.westore.ui.FlowLayout;

public class GoodsSearchFragment extends BaseDoFragment {
	/**
	 * 从商品列表进入
	 */
	boolean isFromGoodsList = false;

	float mTextSize = 13;
	int mTextColor = 0, mPaddingHeight, mPaddingWidth;
	FlowLayout mHotFlowLayout, mNearFlowLayout;
	private EditText mKeywordsText;
	
	View mCustomAcationBar;
	
	RelativeLayout mEmptyHotLayout, mEmptyNearLayout;
	
	LinearLayout mAssociateLayout;
	ListView mAssociateListView;
	/**
	 * 如果mAssociateInterface调用失败则不需要再调用，变为false
	 */
	boolean canAssociate = true;
	List<String> mAssociateList = new ArrayList<String>();
	QianseitAdapter<String> mAssociateAdapter = new QianseitAdapter<String>(mAssociateList) {
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			if (convertView == null) {
				convertView = View.inflate(mActivity, R.layout.item_simple_list_1, null);
			}

			((TextView)convertView).setText(getItem(position));
			return convertView;
		}
	};
	
	OnClickListener mSearchItemClickListener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			if (isFromGoodsList) {
				Intent nIntent = new Intent();
				nIntent.putExtra(Run.EXTRA_KEYWORDS, (String) v.getTag());
				mActivity.setResult(Activity.RESULT_OK, nIntent);
				mActivity.finish();
				return;
			}
			mActivity.startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_GOODS_LIST).putExtra(Run.EXTRA_KEYWORDS, (String) v.getTag())
					.putExtra(Run.EXTRA_TITLE, (String) v.getTag()));
			mActivity.finish();
		}
	};
	GoodsAssociateInterface mAssociateInterface = new GoodsAssociateInterface(this) {
		
		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			JSONArray nArray = responseJson.optJSONArray("data");
			mAssociateList.clear();
			if (nArray != null && nArray.length() > 0) {
				for (int i = 0; i < nArray.length(); i++) {
					mAssociateList.add(nArray.optString(i));
				}
				mAssociateLayout.setVisibility(View.VISIBLE);
				mAssociateAdapter.notifyDataSetChanged();
			}else{
				mAssociateLayout.setVisibility(View.GONE);
				mAssociateAdapter.notifyDataSetChanged();
			}
		}
		
		@Override
		public void FailRequest() {
			canAssociate = false;
			mAssociateList.clear();
			mAssociateLayout.setVisibility(View.GONE);
			mAssociateAdapter.notifyDataSetChanged();
		}
	};
	GoodsHotSearchInterface mHotSearchInterface = new GoodsHotSearchInterface(this) {

		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			JSONArray nArray = responseJson.optJSONArray("data");
			if (nArray != null && nArray.length() > 0) {
				mEmptyHotLayout.setVisibility(View.GONE);
				mHotFlowLayout.setVisibility(View.VISIBLE);
				for (int i = 0; i < nArray.length(); i++) {
					mHotFlowLayout.addView(getSearchView(nArray.optString(i)), LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
				}
			}else{
				mHotFlowLayout.setVisibility(View.GONE);
				mEmptyHotLayout.setVisibility(View.VISIBLE);
			}
		}
	};
	private Dialog mDeleteDialog;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setShowTitleBar(false);
		
		isFromGoodsList = getExtraBooleanFromBundle(Run.EXTRA_DATA);
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		rootView = inflater.inflate(R.layout.fragment_goods_search, null);
		mHotFlowLayout = (FlowLayout) findViewById(R.id.hot);
		mNearFlowLayout = (FlowLayout) findViewById(R.id.near);
		
		mKeywordsText = (EditText) findViewById(android.R.id.edit);
		findViewById(R.id.fragment_search_cancel).setOnClickListener(this);
		findViewById(R.id.fragment_search_search).setOnClickListener(this);
		findViewById(R.id.clear).setOnClickListener(this);
		
		mCustomAcationBar = findViewById(R.id.action_bar_topbar);
		
		mEmptyHotLayout = (RelativeLayout) findViewById(R.id.empty_hot);
		mEmptyNearLayout = (RelativeLayout) findViewById(R.id.empty_near);
		
		mAssociateLayout = (LinearLayout) findViewById(R.id.associate_ll);
		mAssociateListView = (ListView) findViewById(R.id.associate_list);
		mAssociateListView.setAdapter(mAssociateAdapter);
		mAssociateListView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				// TODO Auto-generated method stub
				mKeywordsText.setText((String)parent.getAdapter().getItem(position));
				mAssociateLayout.setVisibility(View.GONE);
				search();
			}
		});
		
		((TextView)mEmptyHotLayout.findViewById(R.id.base_error_tv)).setText("暂无热门搜索");

		mTextColor = getResources().getColor(R.color.westore_gray_textcolor);
		mPaddingHeight = Run.dip2px(mActivity, 5);
		mPaddingWidth = Run.dip2px(mActivity, 10);

		for (String string : GoodsUtil.getSearchVaue(mActivity)) {
			mNearFlowLayout.addView(getSearchView(string), LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		}
		
		if (mNearFlowLayout.getChildCount() <= 0) {
			mNearFlowLayout.setVisibility(View.GONE);
			mEmptyNearLayout.setVisibility(View.VISIBLE);
			findViewById(R.id.clear).setVisibility(View.GONE);
		}else{
			mNearFlowLayout.setVisibility(View.VISIBLE);
			mEmptyNearLayout.setVisibility(View.GONE);
			findViewById(R.id.clear).setVisibility(View.VISIBLE);
		}
		
		mKeywordsText.setOnEditorActionListener(new OnEditorActionListener() {
			
			@Override
			public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
				// TODO Auto-generated method stub
				if (actionId == EditorInfo.IME_ACTION_SEARCH) {
					search();
					return true;
				}
				return false;
			}
		});
		mKeywordsText.setOnKeyListener(new OnKeyListener() {
			
			@Override
			public boolean onKey(View v, int keyCode, KeyEvent event) {
				// TODO Auto-generated method stub
				if (keyCode == KeyEvent.KEYCODE_ENTER) {
					search();
					return true;
				}
				return false;
			}
		});
		
		mKeywordsText.addTextChangedListener(new TextWatcher() {
			
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
				if (s.length() > 0 && canAssociate && !mAssociateInterface.isExcuting()) {
					mAssociateInterface.getAssociate(s.toString());
				}else{
					mAssociateList.clear();
					mAssociateLayout.setVisibility(View.GONE);
					mAssociateAdapter.notifyDataSetChanged();
				}
			}
		});
		
		mAssociateInterface.AutoStartLoadingDialog(false);
		mHotSearchInterface.AutoStartLoadingDialog(false);
		mHotSearchInterface.RunRequest();
	}

	@Override
	public void onResume() {
		super.onResume();
		mActivity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_VISIBLE | WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			if (mAssociateLayout.isShown()) {
				mAssociateLayout.setVisibility(View.GONE);
			}else{
				back();
			}
			return true;
		}
		return false;
	}
	
	TextView getSearchView(String searchValue) {
		TextView nTextView = new TextView(mActivity);
		nTextView.setBackgroundResource(R.drawable.shape_stroke_round5_graydark);
		nTextView.setTextColor(mTextColor);
		nTextView.setPadding(mPaddingWidth, mPaddingHeight, mPaddingWidth, mPaddingHeight);
		nTextView.setGravity(Gravity.CENTER);
		nTextView.setText(searchValue);
		nTextView.setTag(searchValue);
		nTextView.setTextSize(TypedValue.COMPLEX_UNIT_SP, mTextSize);
		nTextView.setOnClickListener(mSearchItemClickListener);
		return nTextView;
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if (v.getId() == R.id.fragment_search_cancel) {
			back();
		} else if (v.getId() == R.id.fragment_search_search) {
			search();
		} else if (v.getId() == R.id.clear) {
			askClearSearch();
		} else {
			super.onClick(v);
		}
	}
	
	void search(){
		if (mKeywordsText.getText().length() <= 0) {
			Run.alert(mActivity, "请输入商品名称");
			mKeywordsText.requestFocus();
			return;
		}
		String searchKey = mKeywordsText.getText().toString();
		GoodsUtil.putSearchValue(mActivity, searchKey);
		if (isFromGoodsList) {
			Intent nIntent = new Intent();
			nIntent.putExtra(Run.EXTRA_KEYWORDS, searchKey);
			mActivity.setResult(Activity.RESULT_OK, nIntent);
			mActivity.finish();
			return;
		}
		mActivity.startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_GOODS_LIST).putExtra(Run.EXTRA_KEYWORDS, searchKey).putExtra(Run.EXTRA_TITLE, searchKey));
		mActivity.finish();
	}

	// 询问清空最近搜索历史
	private void askClearSearch() {
		mDeleteDialog = CommonLoginFragment.showAlertDialog(mActivity, "确定清空最近搜索历史吗？", "取消", "确定", null, new OnClickListener() {

			@Override
			public void onClick(View v) {
				mDeleteDialog.dismiss();
				mDeleteDialog = null;
				GoodsUtil.clearSearchValue(mActivity);
				mNearFlowLayout.removeAllViews();

				mNearFlowLayout.setVisibility(View.GONE);
				mEmptyNearLayout.setVisibility(View.VISIBLE);
				findViewById(R.id.clear).setVisibility(View.GONE);
			}
		}, false, null);
	}
}
