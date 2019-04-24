package com.qianseit.westore.activity.acco;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.qianseit.westore.Run;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.qianseit.westore.ui.MyListView;
import com.qianseit.westore.ui.pull.PullToRefreshLayout;
import com.qianseit.westore.ui.pull.PullToRefreshLayout.OnRefreshListener;
import com.beiwangfx.R;;

public class AccoInvitationFrament extends BaseDoFragment implements OnRefreshListener {
	PullToRefreshLayout mPullToRefreshLayout;
	private List<JSONObject> memberArray = new ArrayList<JSONObject>();
	private int mPageNum = 1;
	private int pagesize = 10;
	private MemberAdapter mAdapter;
	private LinearLayout mTopLayout;
	private MyListView mListView;
	private LayoutInflater mInflater;
	private JSONObject mTopJSON;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setShowTitleBar(false);
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		super.init(inflater, container, savedInstanceState);
		mInflater = inflater;
		rootView = inflater.inflate(R.layout.fragment_distribution_main, null);
		mPullToRefreshLayout = ((PullToRefreshLayout) findViewById(R.id.refresh_view));
		mPullToRefreshLayout.setOnRefreshListener(this);
		mTopLayout = (LinearLayout) findViewById(R.id.item_top_Linear);
		mListView = (MyListView) findViewById(R.id.item_list);
		mAdapter = new MemberAdapter(memberArray);
		mListView.setAdapter(mAdapter);
		loadNextPage(mPageNum, null);
		mListView.setFocusable(false);
	}

	private void loadNextPage(int oldPageNum, PullToRefreshLayout pullToRefreshLayout) {
		this.mPageNum = oldPageNum;
		if (this.mPageNum == 1) {
			memberArray.clear();
			mAdapter.notifyDataSetChanged();
		}
		Run.excuteJsonTask(new JsonTask(), new GetMemberTask(pullToRefreshLayout));
	}

	private void setOnlineData(JSONObject data) {
		if (data == null) {
			if (mPageNum == 1 && memberArray.size() > 0) {
				mTopLayout.removeAllViews();
				View botView = mInflater.inflate(R.layout.item_member_text, null);
				((TextView) botView.findViewById(R.id.item_title_tv)).setText("我邀请的人");
				mTopLayout.addView(botView);
			} else {
				if (mPageNum == 1) {
					mTopLayout.removeAllViews();
					View nullView = mInflater.inflate(R.layout.item_list_null, null);
					((TextView) nullView.findViewById(R.id.item_list_text)).setText("暂无数据");
					mTopLayout.addView(nullView);
				}
			}
		} else {
			if (mPageNum == 1) {
				mTopLayout.removeAllViews();
				View topView = mInflater.inflate(R.layout.item_member_text, null);
				((TextView) topView.findViewById(R.id.item_title_tv)).setText("我的邀请人");
				View itemView = mInflater.inflate(R.layout.item_member_list, null);
				ImageView iconImage = (ImageView) itemView.findViewById(R.id.item_member_icon);
				displayRoundImage(iconImage, data.optString("avatar"), 5);
				((TextView) itemView.findViewById(R.id.item_member_lv)).setText(data.optString("lv"));
				((TextView) itemView.findViewById(R.id.item_member_name_tv)).setText(data.optString("name"));
				((TextView) itemView.findViewById(R.id.item_member_phone_tv)).setText(data.optString("mobile"));

				mTopLayout.addView(topView);
				mTopLayout.addView(itemView);
				if (memberArray.size() > 0) {
					View botView = mInflater.inflate(R.layout.item_member_text, null);
					botView.findViewById(R.id.item_len_view).setVisibility(View.VISIBLE);
					((TextView) botView.findViewById(R.id.item_title_tv)).setText("我邀请的人");
					mTopLayout.addView(botView);
				}
			}
		}
	}

	private class GetMemberTask implements JsonTaskHandler {
		public PullToRefreshLayout mPullToRefreshLayout;

		public GetMemberTask(PullToRefreshLayout pullToRefreshLayout) {
			this.mPullToRefreshLayout = pullToRefreshLayout;
		}

		@Override
		public void task_response(String json_str) {
			try {
				JSONObject all = new JSONObject(json_str);
				if (Run.checkRequestJson(mActivity, all)) {
					JSONArray dataArray = all.optJSONArray("data");
					if (dataArray != null && dataArray.length() > 0) {
						for (int i = 0; i < dataArray.length(); i++) {
							JSONObject dataJSON = dataArray.optJSONObject(i);
							if (dataJSON != null) {
								if (!dataJSON.has("is_fmember")) {
									memberArray.add(dataJSON);
								} else {
									if (mTopJSON == null) {
										mTopJSON = dataJSON;
									}
								}
							}
						}
						if (dataArray.length() < pagesize) {
							mPullToRefreshLayout.setPullUp(false);
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (mPullToRefreshLayout != null) {
					mPullToRefreshLayout.loadmoreFinish(PullToRefreshLayout.SUCCEED);
					mPullToRefreshLayout.refreshFinish(PullToRefreshLayout.SUCCEED);
				}
				setOnlineData(mTopJSON);
				if (memberArray.size() > 0) {
					mAdapter.notifyDataSetChanged();
				}
			}

		}

		@Override
		public JsonRequestBean task_request() {
			JsonRequestBean req = new JsonRequestBean(Run.API_URL, "mobileapi.member.all_members");
			req.addParams("page", String.valueOf(mPageNum));
			req.addParams("page_size", String.valueOf(pagesize));
			return req;
		}

	}

	private class MemberAdapter extends QianseitAdapter<JSONObject> {

		public MemberAdapter(List<JSONObject> dataList) {
			super(dataList);
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			if (convertView == null) {
				convertView = mInflater.inflate(R.layout.item_member_list, null);
			}
			ImageView iconImage = ((ImageView) convertView.findViewById(R.id.item_member_icon));
			TextView nameText = ((TextView) convertView.findViewById(R.id.item_member_name_tv));
			TextView phoneText = ((TextView) convertView.findViewById(R.id.item_member_phone_tv));
			JSONObject dataJSON = getItem(position);
			((TextView) convertView.findViewById(R.id.item_member_lv)).setText(dataJSON.optString("lv"));
			displayRoundImage(iconImage, dataJSON.optString("avatar"), 5);
			nameText.setText(dataJSON.optString("name"));
			phoneText.setText(dataJSON.optString("mobile"));
			return convertView;
		}

	}

	@Override
	public void onRefresh(PullToRefreshLayout pullToRefreshLayout) {
		mPageNum = 1;
		mPullToRefreshLayout.setPullUp(true);
		loadNextPage(mPageNum, pullToRefreshLayout);

	}

	@Override
	public void onLoadMore(PullToRefreshLayout pullToRefreshLayout) {
		mPageNum++;
		loadNextPage(mPageNum, pullToRefreshLayout);
	}

}
