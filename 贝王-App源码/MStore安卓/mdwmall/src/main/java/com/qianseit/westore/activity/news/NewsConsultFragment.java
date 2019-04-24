package com.qianseit.westore.activity.news;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.os.Bundle;
import android.os.Message;
import android.text.TextUtils;
import android.util.SparseArray;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ExpandableListView;
import android.widget.ExpandableListView.OnGroupClickListener;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseExpandListFragment;
import com.qianseit.westore.httpinterface.member.MemberReadNewsInterface;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class NewsConsultFragment extends BaseExpandListFragment<JSONObject, JSONObject> {
	final int READ_MSG = 0x01;
	List<Message> mMessages = new ArrayList<Message>();

	SparseArray<List<JSONObject>> mMoreChildArray = new SparseArray<List<JSONObject>>();

	boolean mIsFirst = true;

	int mPaddingLeft = 0;
	int mPaddingRight = 0;
	int mPaddingTop = 0;
	int mPaddingBottom = 0;

	protected String mTitle;

	MemberReadNewsInterface mReadNewsInterface = new MemberReadNewsInterface(this) {
		@Override
		public void SuccCallBack(JSONObject responseJson) {
			if (mMessages.size() > 0) {
				mHandler.sendMessageDelayed(mMessages.get(0), 10);
			}
		}
	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setShowTitleBar(false);
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("type", "ask");
		mTitle = getArguments().getString(Run.EXTRA_TITLE);
		return nContentValues;
	}

	@Override
	protected List<ExpandListItemBean<JSONObject, JSONObject>> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		if (mPageNum == 1) {
			mMoreChildArray.clear();
		}

		List<ExpandListItemBean<JSONObject, JSONObject>> nBeans = new ArrayList<ExpandListItemBean<JSONObject, JSONObject>>();

		JSONArray nArray = responseJson.optJSONArray("commentList");
		if (nArray == null || nArray.length() <= 0) {
			return nBeans;
		}

		for (int i = 0; i < nArray.length(); i++) {
			ExpandListItemBean<JSONObject, JSONObject> nBean = new ExpandListItemBean<JSONObject, JSONObject>();
			nBean.mGrupItem = nArray.optJSONObject(i);
			JSONArray nArray2 = nBean.mGrupItem.optJSONArray("items");
			if (nArray2 != null && nArray2.length() > 0) {
				for (int j = 0; j < nArray2.length(); j++) {
					if (j >= 2) {
						int nKey = nBean.mGrupItem.hashCode();
						if (mMoreChildArray.get(nKey) == null) {
							mMoreChildArray.put(nKey, new ArrayList<JSONObject>());
						}
						mMoreChildArray.get(nKey).add(nArray2.optJSONObject(j));
					} else {
						nBean.mDetailLists.add(nArray2.optJSONObject(j));
					}
				}
			}
			nBeans.add(nBean);
		}

		return nBeans;
	}

	@Override
	protected View getGroupItemView(ExpandListItemBean<JSONObject, JSONObject> groupBean, boolean isExpanded, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_news_consult, null);
			convertView.findViewById(R.id.goods_tr).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					String nProductId = (String) v.getTag();
					if (TextUtils.isEmpty(nProductId)) {
						return;
					}

					Bundle nBundle = new Bundle();
					nBundle.putString(Run.EXTRA_PRODUCT_ID, nProductId);
					startActivity(AgentActivity.FRAGMENT_GOODS_DETAIL, nBundle);
				}
			});
		}

		((TextView) convertView.findViewById(R.id.title)).setText(groupBean.mGrupItem.optString("type"));
		((TextView) convertView.findViewById(R.id.goods_name)).setText(groupBean.mGrupItem.optString("name"));
		((TextView) convertView.findViewById(R.id.title)).setText(groupBean.mGrupItem.optString("type"));
		displaySquareImage((ImageView) convertView.findViewById(R.id.goods_image), groupBean.mGrupItem.optString("image_default_id"));
		convertView.findViewById(R.id.goods_tr).setTag(groupBean.mGrupItem.optString("product_id"));

		((TextView) convertView.findViewById(R.id.time)).setText(StringUtils.LongTimeToLongString(groupBean.mGrupItem.optLong("time")));
		((TextView) convertView.findViewById(R.id.comment)).setText(groupBean.mGrupItem.optString("comment"));

		int nPosition = mResultLists.indexOf(groupBean);
		convertView.findViewById(R.id.divider_top).setVisibility(nPosition == 0 ? View.GONE : View.VISIBLE);

		if (groupBean.mDetailLists.size() > 0) {
			convertView.setPadding(0, 0, 0, 0);
		} else {
			convertView.setPadding(0, 0, 0, mPaddingBottom);
		}

		readNews(groupBean.mGrupItem);

		return convertView;
	}

	@Override
	protected View getDetailItemView(ExpandListItemBean<JSONObject, JSONObject> groupBean, JSONObject detailBean, boolean isLastChild, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_goods_consult_child, null);

			final TextView moreView = (TextView) convertView.findViewById(R.id.more);
			moreView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					int nPosition = (Integer) v.getTag();

					int nKey = mResultLists.get(nPosition).mGrupItem.hashCode();
					if (mResultLists.get(nPosition).mDetailLists.size() <= 2) {
						mResultLists.get(nPosition).mDetailLists.addAll(mMoreChildArray.get(nKey));
					} else {
						mResultLists.get(nPosition).mDetailLists.removeAll(mMoreChildArray.get(nKey));
					}
					mAdatpter.notifyDataSetChanged();

				}
			});
		}

		TextView nameTextView = (TextView) convertView.findViewById(R.id.admin);
		nameTextView.setText(detailBean.optString("author"));

		TextView contentTextView = (TextView) convertView.findViewById(R.id.replay_content);
		contentTextView.setText(detailBean.optString("comment"));


		TextView nMoreView = (TextView) convertView.findViewById(R.id.more);
		int nPosition = mResultLists.indexOf(groupBean);
		nMoreView.setTag(nPosition);

		int nKey = mResultLists.get(nPosition).mGrupItem.hashCode();
		nMoreView.setVisibility(isLastChild && mMoreChildArray.get(nKey) != null ? View.VISIBLE :
				View.GONE);
		nMoreView.setText(mResultLists.get(nPosition).mDetailLists.size() > 2 ? "点击收起" : "点击查看更多");

		if (!isLastChild) {
			convertView.setPadding(mPaddingLeft, 0, mPaddingRight, 0);
		} else {
			convertView.setPadding(mPaddingLeft, 0, mPaddingRight, mPaddingBottom);
		}

		return convertView;
	}

	@Override
	protected void initActionBar() {
		// TODO Auto-generated method stub
		mActionBar.setShowTitleBar(false);
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		if (resultCode == Activity.RESULT_OK) {
			onRefresh();
		}
		super.onActivityResult(requestCode, resultCode, data);
	}

	@Override
	protected void init() {
		// TODO Auto-generated method stub
		mListView.setDividerHeight(0);
		setEmptyImage(R.drawable.empty_consult);
		setEmptyText("暂无" + mTitle);
		mPaddingBottom = Run.dip2px(mActivity, 15);
		mPaddingTop = Run.dip2px(mActivity, 15);
		mPaddingLeft = Run.dip2px(mActivity, 15);
		mPaddingRight = Run.dip2px(mActivity, 15);
		mListView.setOnGroupClickListener(new OnGroupClickListener() {

			@Override
			public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) {
				// TODO Auto-generated method stub
				return true;
			}
		});
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.member.comment";
	}

	@Override
	public void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		mMessages.clear();
		mHandler.removeMessages(READ_MSG);
	}

	@Override
	public void ui(int what, Message msg) {
		// TODO Auto-generated method stub
		if (what == READ_MSG) {
			mReadNewsInterface.read(((JSONObject) msg.obj).optString("comment_id"));
			mMessages.remove(0);
		} else {
			super.ui(what, msg);
		}
	}

	protected void readNews(JSONObject newsJsonObject){
		if (newsJsonObject == null || newsJsonObject.optInt("unReadNum") <= 0) {
			return;
		}

		Message nMessage = new Message();
		nMessage.what = READ_MSG;
		nMessage.obj = newsJsonObject;

		if (mMessages.size() <= 0) {
			mHandler.sendMessageDelayed(nMessage, 10);
		}
		mMessages.add(nMessage);
	}
}
