package com.qianseit.westore.activity.shopping;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;

import java.util.List;


public class ShoppingStoreTimeFragment extends BaseDoFragment {
	private LayoutInflater mInflater;
	private StoreTimeAdapter mStoreTimeAdapter;
	private ListView mListView;
	private List<String> storeTimeArray;
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setTitle(R.string.confirm_order_stroe_time_title);
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		super.init(inflater, container, savedInstanceState);
		mInflater = inflater;
		rootView = inflater.inflate(R.layout.fragment_shopp_store_main, null);
		mListView = (ListView) findViewById(R.id.shopp_store_list);
		storeTimeArray=Run.getBackTime(7);
		mStoreTimeAdapter = new StoreTimeAdapter();
		mListView.setAdapter(mStoreTimeAdapter);
		mListView.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
				String strItem = (String) arg1.getTag();
				Intent intent=new Intent();
				intent.putExtra(Run.EXTRA_DATA,strItem);
				mActivity.setResult(Activity.RESULT_OK, intent);
				mActivity.finish();
			}
		});
	}

	
	
	private class StoreTimeAdapter extends BaseAdapter {

		@Override
		public int getCount() {
			return storeTimeArray.size();
		}

		@Override
		public String getItem(int position) {
			return storeTimeArray.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			ViewHolder mHolder;
			if (convertView == null) {
				mHolder = new ViewHolder();
				convertView = mInflater.inflate(R.layout.item_store, null);
				mHolder.mNameText = (TextView) convertView.findViewById(R.id.item_store_name);
				convertView.setTag(R.id.tag_object, mHolder);
			} else {
				mHolder = (ViewHolder) convertView.getTag(R.id.tag_object);
			}
			String strTime = getItem(position);
			convertView.setTag(strTime);
			mHolder.mNameText.setText(strTime);
			return convertView;
		}

		private class ViewHolder {
			private TextView mNameText;
		}

	}

}
