package com.qianseit.westore.activity.shopping;

import android.os.Bundle;

import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseRadioBarFragment;
import com.qianseit.westore.base.adpter.RadioBarBean;
import com.qianseit.westore.base.adpter.RadioBarBeanList;
import com.qianseit.westore.httpinterface.shopping.ShoppGoodsTogetherInterface;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ShoppGoodsTogetherFragment extends BaseRadioBarFragment {
	RadioBarBeanList mBarBeans = new RadioBarBeanList();
	Map<Long, BaseDoFragment> mDoFragment = new HashMap<Long, BaseDoFragment>();
	
	@Override
	protected List<RadioBarBean> initRadioBar() {
		// TODO Auto-generated method stub
		return mBarBeans;
	}

	@Override
	protected BaseDoFragment getRadioBarFragemnt(long radioBarId) {
		// TODO Auto-generated method stub
		return mDoFragment.get(radioBarId);
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("凑单");
	}
	
	@Override
	protected void init() {
		// TODO Auto-generated method stub
		new ShoppGoodsTogetherInterface(this) {
			
			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				JSONArray nArray = responseJson.optJSONArray("fororder_tab");
				if (nArray == null || nArray.length() <= 0) {
					return;
				}
				
				for (int i = 0; i < nArray.length(); i++) {
					JSONObject nJsonObject = nArray.optJSONObject(i);
					mBarBeans.add(nJsonObject.hashCode(), nJsonObject.optString("tab_name"), nJsonObject.optString("tab_filter"));
					mDoFragment.put(mBarBeans.get(mBarBeans.size() - 1).mId, getShoppGoodsTogethereListFragment(nJsonObject.optString("tab_filter")));
				}
				
				reloadRadio();
			}
		}.RunRequest();
	}

	ShoppGoodsTogethereListFragment getShoppGoodsTogethereListFragment(String tabFilter){
		Bundle nBundle = new Bundle();
		nBundle.putString(ShoppGoodsTogethereListFragment.TAB_FILTER, tabFilter);
		ShoppGoodsTogethereListFragment nOrderListFragment = new ShoppGoodsTogethereListFragment();
		nOrderListFragment.setArguments(nBundle);
		return  nOrderListFragment;
	}
}
