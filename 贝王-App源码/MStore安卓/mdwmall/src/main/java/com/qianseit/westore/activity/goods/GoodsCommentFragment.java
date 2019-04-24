package com.qianseit.westore.activity.goods;

import android.os.Bundle;
import android.support.v4.util.LongSparseArray;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RatingBar;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseRadioBarFragment;
import com.qianseit.westore.base.adpter.RadioBarBean;
import com.qianseit.westore.httpinterface.goods.GoodsCommentInterface;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class GoodsCommentFragment extends BaseRadioBarFragment {
	String mGoodsId;
	ListView mOtherRatListView;
	List<JSONObject> mOtherRatJsonObjects = new ArrayList<JSONObject>();
	RatingBar mGoodsRatingBar;
	TextView mGoodsPointsTextView;
	List<RadioBarBean> mBarBeans = new ArrayList<RadioBarBean>();

	JSONObject mSettingJsonObject;
	JSONArray mCommentTypeArray;
	JSONObject mCommentsJsonObject;
	
	LongSparseArray<BaseDoFragment> mRadioBarFragment = new LongSparseArray<BaseDoFragment>();

	QianseitAdapter<JSONObject> mOtherRatAdapter = new QianseitAdapter<JSONObject>(mOtherRatJsonObjects) {
		
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			if (convertView == null) {
				convertView = View.inflate(mActivity, R.layout.item_goods_comment_rat1, null);
			}
			JSONObject nItem = getItem(position);
			((TextView)convertView.findViewById(R.id.name)).setText(nItem.optString("type_name"));
			((TextView)convertView.findViewById(R.id.points)).setText(nItem.optString("avg"));
			((RatingBar)convertView.findViewById(R.id.rat)).setRating((float) nItem.optDouble("avg"));
			return convertView;
		}
	};
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mGoodsId = getExtraStringFromBundle(Run.EXTRA_GOODS_ID);
		
		mActionBar.setTitle("商品评价");
	}
	
	@Override
	protected List<RadioBarBean> initRadioBar() {
		// TODO Auto-generated method stub
		return mBarBeans;
	}

	@Override
	protected BaseDoFragment getRadioBarFragemnt(long radioBarId) {
		// TODO Auto-generated method stub
		return mRadioBarFragment.get(radioBarId);
	}

	@Override
	protected void init() {
		// TODO Auto-generated method stub
		setRadioBarHeight(Run.dip2px(mActivity, 60));
		new GoodsCommentInterface(this, mGoodsId) {
			
			@Override
			public void responseCommentsType(JSONArray commentsTypeArray) {
				// TODO Auto-generated method stub
				mCommentTypeArray = commentsTypeArray;
			}
			
			@Override
			public void responseComments(JSONObject commentsJsonObject) {
				// TODO Auto-generated method stub
				mCommentsJsonObject = commentsJsonObject;
				parseComments();
			}
		}.RunRequest();
	}
	
	@Override
	public boolean showRadioBarsDivider() {
		// TODO Auto-generated method stub
		return false;
	}
	
	void parseRadioBar(){
		if (mCommentTypeArray == null || mCommentTypeArray.length() <= 0) {
			return;
		}
		
		for (int i = 0; i < mCommentTypeArray.length(); i++) {
			JSONObject nJsonObject = mCommentTypeArray.optJSONObject(i);
			RadioBarBean nBarBean = new RadioBarBean(String.format("%s\n(%s)", nJsonObject.optString("name"), nJsonObject.optString("count")), nJsonObject.hashCode());
			GoodsCommentRecordFragment nGoodsCommentRecordFragment = new GoodsCommentRecordFragment();
			Bundle nBundle = new Bundle();
			nBundle.putString(Run.EXTRA_GOODS_ID, mGoodsId);
			nBundle.putString(Run.EXTRA_DETAIL_TYPE, nJsonObject.optString("value"));
			nBundle.putString(Run.EXTRA_DATA, mSettingJsonObject.toString());
			nGoodsCommentRecordFragment.setArguments(nBundle);
			mRadioBarFragment.put(nJsonObject.hashCode(), nGoodsCommentRecordFragment);
			mBarBeans.add(nBarBean);
		}
		reloadRadio();
	}
	
	void parseComments(){
		JSONObject nGoodsPoints = mCommentsJsonObject.optJSONObject("goods_point");
		if (nGoodsPoints != null) {
			mGoodsPointsTextView.setText(nGoodsPoints.optString("avg_num"));
			mGoodsRatingBar.setRating((float) nGoodsPoints.optDouble("avg_num"));
		}

		mSettingJsonObject = mCommentsJsonObject.optJSONObject("setting");
		JSONArray nArray = mCommentsJsonObject.optJSONArray("_all_point");
		if (nArray != null && nArray.length() > 0) {
			for (int i = 0; i < nArray.length(); i++) {
				if (i>= 5) {//最多显示5个评分
					break;
				}
				mOtherRatJsonObjects.add(nArray.optJSONObject(i));
			}
			mOtherRatAdapter.notifyDataSetChanged();
		}

		parseRadioBar();
	}
	
	@Override
	protected void initTop(LinearLayout topLayout) {
		// TODO Auto-generated method stub
		View nView = View.inflate(mActivity, R.layout.header_goods_comment, null);
		mOtherRatListView = (ListView) nView.findViewById(R.id.other_comment_list);
		mGoodsPointsTextView = (TextView) nView.findViewById(R.id.points);
		mGoodsRatingBar = (RatingBar) nView.findViewById(R.id.rat);
		
		mOtherRatListView.setAdapter(mOtherRatAdapter);
		topLayout.addView(nView);
	}
}
