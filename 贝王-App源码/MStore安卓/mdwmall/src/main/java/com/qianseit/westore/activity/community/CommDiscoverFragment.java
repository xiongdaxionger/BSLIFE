package com.qianseit.westore.activity.community;

import android.os.Bundle;

import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseRadioPageViewFragment;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class CommDiscoverFragment extends BaseRadioPageViewFragment {

	List<RadioBarBean> mBarBeans;
	List<CommDiscoverNoteListFragment> mCommDiscoverArray;
	int defualtId = -1;
	JSONArray mNodeJsonArray;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("社区板块");
		try {
			defualtId = getExtraIntFromBundle(Run.EXTRA_CLASS_ID);
			mNodeJsonArray = new JSONArray(getExtraStringFromBundle(Run.EXTRA_DATA));
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	@Override
	protected List<RadioBarBean> initRadioBar() {
		// TODO Auto-generated method stub
		return mBarBeans;
	}
	protected  List<CommDiscoverNoteListFragment> initFragments() {
		return mCommDiscoverArray;
	}

	@Override
	public int DefaultSelectRadio() {
		// TODO Auto-generated method stub
		return defualtId;
	}
	
	protected boolean setVisDivide() {
		return false;
	}

	@Override
	protected void init() {
		setRadiosVisible(0);
		
		mBarBeans = new ArrayList<BaseRadioPageViewFragment.RadioBarBean>();
		mCommDiscoverArray=new ArrayList<CommDiscoverNoteListFragment>();

		if (mNodeJsonArray != null && mNodeJsonArray.length() > 0) {
			for (int i = 0; i < mNodeJsonArray.length(); i++) {
				final JSONObject jsonItem = mNodeJsonArray.optJSONObject(i);
				if (jsonItem != null) {
					CommDiscoverNoteListFragment mCommDiscoverNoteListFragment = new CommDiscoverNoteListFragment();
					Bundle nBundle = new Bundle();
					nBundle.putString(Run.EXTRA_CLASS_ID, jsonItem.optString("node_id"));
					nBundle.putString(Run.EXTRA_TITLE, jsonItem.optString("node_name"));
					mCommDiscoverNoteListFragment.setArguments(nBundle);
					RadioBarBean nBarBean = new RadioBarBean(jsonItem.optString("node_name"), jsonItem.optInt("node_id"), mCommDiscoverNoteListFragment);
					mBarBeans.add(nBarBean);
					mCommDiscoverArray.add(mCommDiscoverNoteListFragment);
				}
			}
		}
		reloadRadio();
	}
	
	@Override
	public void onPageScrollStateChanged(int arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onPageScrolled(int arg0, float arg1, int arg2) {
		// TODO Auto-generated method stub
		
	}

}
