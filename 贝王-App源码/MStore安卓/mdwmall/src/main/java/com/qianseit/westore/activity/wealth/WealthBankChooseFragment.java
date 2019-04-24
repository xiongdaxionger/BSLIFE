package com.qianseit.westore.activity.wealth;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.TextView;

import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseListFragment;
import com.beiwangfx.R;

public class WealthBankChooseFragment extends BaseListFragment<String> {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setShowHomeView(true);
		mActionBar.setShowBackButton(true);
		mActionBar.setShowTitleBar(true);
		mActionBar.setTitle("选择银行卡");
	}

	@Override
	protected View getItemView(String responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = mActivity.getLayoutInflater().inflate(R.layout.item_textview, null);
			convertView.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					Intent intent = new Intent();
					intent.putExtra(Run.EXTRA_DATA, (String)v.getTag());
					mActivity.setResult(Activity.RESULT_OK, intent);
					mActivity.finish();
				}
			});
		}
		TextView tvName = (TextView) convertView.findViewById(R.id.tv_name);
		tvName.setText(Run.removeQuotes(responseJson));
		convertView.setTag(responseJson);
		return convertView;
	}

	@Override
	protected List<String> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<String> nList = new ArrayList<String>();
		if (responseJson != null) {
			Iterator<String> itt = responseJson.keys();
			while (itt.hasNext()) {
				String key = itt.next().toString();
				if (!TextUtils.isEmpty(key)) {
					nList.add(key);
				}
			}
		}
		return nList;
	}

	@Override
	protected void endInit() {
		// TODO Auto-generated method stub
		PageEnable(false);
	}
	
	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.wallet.banklist";
	}
}
