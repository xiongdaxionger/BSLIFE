package com.qianseit.westore.activity.news;

import android.os.Bundle;
import android.support.v4.util.LongSparseArray;

import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseRadioBarFragment;
import com.qianseit.westore.base.adpter.RadioBarBean;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class NewsSystemMainFragment extends BaseRadioBarFragment {

	JSONArray mSystemNewsTypeArray;
	LongSparseArray<BaseDoFragment> mSparseArray = new LongSparseArray<BaseDoFragment>();

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		try {
			mSystemNewsTypeArray = new JSONArray(getExtraStringFromBundle(Run.EXTRA_DATA));
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			mSystemNewsTypeArray = new JSONArray();
		}
		mActionBar.setTitle("系统消息");
	}

	@Override
	protected List<RadioBarBean> initRadioBar() {
		// TODO Auto-generated method stub
		List<RadioBarBean> nBarBeans = new ArrayList<RadioBarBean>();
		if (mSystemNewsTypeArray == null || mSystemNewsTypeArray.length() <= 0) {
			return nBarBeans;
		}

		for (int i = 0; i < mSystemNewsTypeArray.length(); i++) {
			JSONObject nJsonObject = mSystemNewsTypeArray.optJSONObject(i);
			String nType = nJsonObject.optString("type");
			BaseDoFragment nBaseDoFragment = null;
			if (nType.equalsIgnoreCase("ask")) {
				nBaseDoFragment = new NewsConsultFragment();
			} else if (nType.equalsIgnoreCase("discuss")) {
				nBaseDoFragment = new NewsCommentFragment();
			} else if (nType.equalsIgnoreCase("system")) {
				nBaseDoFragment = new NewsSystemFragment();
			} else {
				continue;
			}

			Bundle nBundle = new Bundle();
			nBundle.putString(Run.EXTRA_TITLE, nJsonObject.optString("name"));
			nBaseDoFragment.setArguments(nBundle);
			nBarBeans.add(new RadioBarBean(nJsonObject.optString("name"), nJsonObject.hashCode()));
			mSparseArray.append(nBarBeans.get(nBarBeans.size() - 1).mId, nBaseDoFragment);
		}

		return nBarBeans;
	}

	@Override
	protected BaseDoFragment getRadioBarFragemnt(long radioBarId) {
		// TODO Auto-generated method stub
		return mSparseArray.get(radioBarId);
	}

}
