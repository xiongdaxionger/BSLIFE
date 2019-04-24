package com.qianseit.westore.activity.passport;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseLocalListFragment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MultiItemFragment extends BaseLocalListFragment<String> {

	List<String> mList = new ArrayList<String>();
	Map<String, String> mChoosedMap = new HashMap<String, String>();
	Drawable nRightDrawable;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mList = getExtraStringListFromBundle(Run.EXTRA_DATA);
		List<String> nChoosedList = getExtraStringListFromBundle(Run.EXTRA_VALUE);
		if (nChoosedList != null && nChoosedList.size() > 0) {
			for (String string : nChoosedList) {
				mChoosedMap.put(string, string);
			}
		}
		
		mActionBar.setTitle(getExtraStringFromBundle(Run.EXTRA_TITLE));

		Rect rect = new Rect(0, 0, Run.dip2px(mActivity, 20), Run.dip2px(mActivity, 20));
		nRightDrawable = mActivity.getResources().getDrawable(R.drawable.qianse_item_status_selected);
		nRightDrawable.setBounds(rect);
		
		mActionBar.setRightTitleButton("确定", new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
//				if (mChoosedMap.isEmpty()) {
//					Run.alert(mActivity, "请至少选择一项");
//					return;
//				}

				ArrayList<String> nArrayList = new ArrayList<String>();
				for (String string : mList) {
					if (mChoosedMap.containsKey(string)) {
						nArrayList.add(string);
					}
				}
				
				Intent nIntent = new Intent();
				nIntent.putExtra(Run.EXTRA_VALUE, nArrayList);
				mActivity.setResult(Activity.RESULT_OK, nIntent);
				mActivity.finish();
			}
		});
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
					String nString = ((TextView) v).getText().toString();
					if (mChoosedMap.containsKey(nString)) {
						mChoosedMap.remove(nString);
					}else{
						mChoosedMap.put(nString, nString);
					}
					
					mAdapter.notifyDataSetChanged();
				}
			});
		}

		TextView nTextView = (TextView) convertView;
		nTextView.setText(responseJson);
		nTextView.setCompoundDrawables(null, null, mChoosedMap.containsKey(responseJson) ? nRightDrawable : null, null);
//		nTextView.setCompoundDrawables(null, null, nRightDrawable, null);

		return convertView;
	}
}
