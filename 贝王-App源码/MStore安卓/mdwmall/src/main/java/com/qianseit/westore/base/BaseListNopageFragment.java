package com.qianseit.westore.base;

import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;

import com.beiwangfx.R;;

public abstract class BaseListNopageFragment<T> extends BasePageFragment<T> {

	private ImageView mEmptyImageView;
	private String mEmptyString = "";

	private int mEmptyStringRes = -1;
	private TextView mEmptyTextView;

	private RelativeLayout mEmptyViewRL;
	private int mImageRes = -1;


	protected ListView mListView;
	int mScreenHeight = 0;

	protected abstract View getItemView(T responseJson, View convertView, ViewGroup parent);

	protected void init() {
		
		rootView = View.inflate(mActivity, R.layout.base_fragment_listnopage, null);

		mListView = (ListView) findViewById(R.id.base_lv);
		mEmptyViewRL = (RelativeLayout) findViewById(R.id.base_error_rl);
		mEmptyImageView = (ImageView) findViewById(R.id.base_error_iv);
		mEmptyTextView = (TextView) findViewById(R.id.base_error_tv);
		mEmptyViewRL.setVisibility(View.GONE);
		findViewById(R.id.base_reload_tv).setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				onRefresh();
			}
		});
		
		mListView.setEmptyView(mEmptyViewRL);
		addHeader(mListView);
		addFooter(mListView);
		mAdapter = new MyAdapter();
		mListView.setAdapter(mAdapter);

		if (mImageRes != -1) {
			setEmptyImage(mImageRes);
		}
		if (mEmptyStringRes != -1) {
			setEmptyText(mEmptyStringRes);
		}
		if (mEmptyString != null && !TextUtils.isEmpty(mEmptyString)) {
			setEmptyText(mEmptyString);
		}
		
		mEmptyViewRL.setVisibility(View.GONE);

		endInit();
	}
	
	protected void setCustomEmptyView(View customEmptyView){
		mEmptyViewRL.removeAllViews();

		mEmptyViewRL.addView(customEmptyView);
		RelativeLayout.LayoutParams nLayoutParams = (LayoutParams) customEmptyView.getLayoutParams();
		nLayoutParams.width = LayoutParams.MATCH_PARENT;
	}
	
	final protected void setEmptyImage(int imgRes) {
		if (mEmptyImageView == null) {
			mImageRes = imgRes;
			return;
		}
		mEmptyImageView.setImageResource(imgRes);
	}

	final protected void setEmptyText(int strRes) {
		if (mEmptyImageView == null) {
			mEmptyStringRes = strRes;
			return;
		}
		mEmptyTextView.setText(strRes);
	}

	final protected void setEmptyText(String emptyString) {
		if (mEmptyImageView == null) {
			mEmptyString = emptyString;
			return;
		}
		mEmptyTextView.setText(emptyString);
	}

	@Override
	protected void onLoadFinished() {
		// TODO Auto-generated method stub
	}
	
	protected void onRefresh(){
		loadNextPage(0);
	}
	
	@Override
	protected void onPageEnable(boolean enable) {
		// TODO Auto-generated method stub
	}

	protected void addFooter(ListView listView) {

	}

	protected void addHeader(ListView listView) {

	}
}
