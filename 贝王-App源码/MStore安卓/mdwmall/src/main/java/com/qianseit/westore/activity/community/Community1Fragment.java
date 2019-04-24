package com.qianseit.westore.activity.community;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.httpinterface.article.ArticleAddPraiseDiscoverInterface;
import com.qianseit.westore.ui.XPullDownListView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class Community1Fragment extends BaseListFragment<JSONObject> {
	final int REQUEST_DETAIL = 0x01;
	GridView mGridView;
	List<JSONObject> mNodeJsonObjects = new ArrayList<JSONObject>();
	JSONObject mCurJsonObject = null;
	QianseitAdapter mNodeAdapter = new QianseitAdapter<JSONObject>(mNodeJsonObjects) {

		@Override
		public View getView(int arg0, View arg1, ViewGroup arg2) {
			// TODO Auto-generated method stub
			if (arg1 == null) {
				arg1 = View.inflate(mActivity, R.layout.item_comm_home_grid, null);
				arg1.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View arg0) {
						// TODO Auto-generated method stub
						JSONObject nItem = (JSONObject) arg0.getTag();
						Bundle nBundle = new Bundle();
						nBundle.putString(Run.EXTRA_CLASS_ID, nItem.optString("node_id"));
						nBundle.putString(Run.EXTRA_TITLE, nItem.optString("node_name"));
						startActivity(AgentActivity.FRAGMENT_COMMUNITY_NOTE_LIST, nBundle);
					}
				});
			}

			JSONObject nItem = getItem(arg0);
			arg1.setTag(nItem);
			displaySquareImage((ImageView) arg1.findViewById(R.id.gridview_icon), nItem.optString("image"));
			((TextView) arg1.findViewById(R.id.gridview_title)).setText(nItem.optString("node_name"));
			return arg1;
		}
	};
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		mActionBar.setTitle("故事");
	}
	
	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_community, null);
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					mCurJsonObject = (JSONObject) v.getTag();
					Bundle nBundle = new Bundle();
					nBundle.putString(Run.EXTRA_ARTICLE_ID, mCurJsonObject.optString("article_id"));
					nBundle.putString(Run.EXTRA_DATA, mCurJsonObject.optString("s_url"));
					startActivityForResult(AgentActivity.FRAGMENT_COMMUNITY_COMMENT, nBundle, REQUEST_DETAIL);
				}
			});

			convertView.findViewById(R.id.comment).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					mCurJsonObject = (JSONObject) v.getTag();
					Bundle nBundle = new Bundle();
					nBundle.putString(Run.EXTRA_ARTICLE_ID, mCurJsonObject.optString("article_id"));
					nBundle.putString(Run.EXTRA_DATA, mCurJsonObject.optString("s_url"));
					startActivityForResult(AgentActivity.FRAGMENT_COMMUNITY_COMMENT, nBundle, REQUEST_DETAIL);
				}
			});

			convertView.findViewById(R.id.praise).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					final JSONObject nJsonObject = (JSONObject) v.getTag();
					new ArticleAddPraiseDiscoverInterface(Community1Fragment.this, nJsonObject.optString("article_id")) {

						@Override
						public void SuccCallBack(JSONObject responseJson) {
							// TODO Auto-generated method stub
							try {
								int nPraise = nJsonObject.optInt("praise_nums", 0);
								if (nJsonObject.optBoolean("ifpraise")) {
									nJsonObject.put("ifpraise", false);
									nJsonObject.put("praise_nums", nPraise - 1);
								} else {
									nJsonObject.put("ifpraise", true);
									nJsonObject.put("praise_nums", nPraise + 1);
								}
							} catch (JSONException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							mAdapter.notifyDataSetChanged();
						}
					}.RunRequest();
				}
			});
		}

		ImageView img=(ImageView) convertView.findViewById(R.id.image);
		displayRectangleImage(img, responseJson.optString("s_url"));
		((TextView) convertView.findViewById(R.id.title)).setText(responseJson.optString("title"));
		((TextView) convertView.findViewById(R.id.brief)).setText(responseJson.optString("brief"));

		convertView.findViewById(R.id.praise).setSelected(responseJson.optBoolean("ifpraise"));
		((TextView) convertView.findViewById(R.id.comment)).setText(responseJson.optString("discuss_nums"));
		((TextView) convertView.findViewById(R.id.praise)).setText(responseJson.optString("praise_nums"));
		
		convertView.setTag(responseJson);
		convertView.findViewById(R.id.praise).setTag(responseJson);
		convertView.findViewById(R.id.comment).setTag(responseJson);
		return convertView;
	}

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		JSONArray nArray = responseJson.optJSONArray("nodes");
		if (nArray != null && nArray.length() > 0) {
			mNodeJsonObjects.clear();
			for (int i = 0; i < nArray.length(); i++) {
				mNodeJsonObjects.add(nArray.optJSONObject(i));
			}
			mNodeAdapter.notifyDataSetChanged();
		}
		
		nArray = responseJson.optJSONArray("articles");
		if (nArray == null || nArray.length() <= 0) {
			return nJsonObjects;
		}
		
		for (int i = 0; i < nArray.length(); i++) {
			nJsonObjects.add(nArray.optJSONObject(i));
		}
		
		return nJsonObjects;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "content.article.story_index";
	}
	
	@Override
	protected void addHeader(XPullDownListView listView) {
		// TODO Auto-generated method stub
		View nView = View.inflate(mActivity, R.layout.header_community, null);
		mGridView = (GridView) nView.findViewById(R.id.nodes);
		mGridView.setAdapter(mNodeAdapter);
		listView.addHeaderView(nView);
		PageEnable(false);
		mListView.setPullRefreshEnable(true);
		AutoLoad(false);
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		onRefresh();
	}
	
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		if (resultCode != Activity.RESULT_OK) {
			return;
		}
		
		if (requestCode == REQUEST_DETAIL) {
			try {
				JSONObject nJsonObject = new JSONObject(data.getStringExtra(Run.EXTRA_DATA));
				mCurJsonObject.put("praise_nums", nJsonObject.opt("praise_nums"));
				mCurJsonObject.put("discuss_nums", nJsonObject.opt("discuss_nums"));
				mCurJsonObject.put("ifpraise", nJsonObject.opt("ifpraise"));
				mAdapter.notifyDataSetChanged();
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return;
		}
		super.onActivityResult(requestCode, resultCode, data);
	}
}
