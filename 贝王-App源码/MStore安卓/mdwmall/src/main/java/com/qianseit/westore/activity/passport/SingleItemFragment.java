package com.qianseit.westore.activity.passport;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseLocalListFragment;

public class SingleItemFragment extends BaseLocalListFragment<String> {

	List<String> mList = new ArrayList<String>();
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mList = getExtraStringListFromBundle(Run.EXTRA_DATA);
		mActionBar.setTitle(getExtraStringFromBundle(Run.EXTRA_TITLE));
	}
	
	
	@Override
	protected List<String> buildLocalItems() {
		// TODO Auto-generated method stub
		return mList;
	}

	@Override
	protected View getItemView(String responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_setting_single, null);
			convertView.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					Intent nIntent = new Intent();
					nIntent.putExtra(Run.EXTRA_VALUE, ((TextView)v).getText().toString());
					mActivity.setResult(Activity.RESULT_OK, nIntent);
					mActivity.finish();
				}
			});
		}
		
		((TextView)convertView).setText(responseJson);
		
		return convertView;
	}

}
