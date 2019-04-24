package com.qianseit.westore.activity.goods;

import android.content.ContentValues;
import android.os.Bundle;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseExpandListFragment;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GoodsCommentRecordFragment extends BaseExpandListFragment<JSONObject, JSONObject> {
	String mType = "";
	String mGoodsId;
	JSONObject mSettingJsonObject;

	boolean mCanReply = true, mCanPublish = true, mNeedCheck = false;
	String mReplyContentFormat = "<font color=\"#333333\">%s：</font><font color=\"#808080\">%s</font>";

	Map<Integer, List<JSONObject>> mMoreChildMap = new HashMap<Integer, List<JSONObject>>();

	GoodsCommentReplyDialog mCommentReplyDialog;

	int mPaddingLeft = 0;
	int mChildPaddingLeft = 0;
	int mPaddingRight = 0;
	int mPaddingTop = 0;
	int mPaddingBottom = 0;

	int mSingleImageWidth = 0;
	int mMultiImageWidth = 0;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Bundle nBundle = getArguments();
		mType = nBundle.getString(Run.EXTRA_DETAIL_TYPE);
		mGoodsId = nBundle.getString(Run.EXTRA_GOODS_ID);
		try {
			mSettingJsonObject = new JSONObject(nBundle.getString(Run.EXTRA_DATA));
			mCanReply = mSettingJsonObject.optString("switch_reply").equalsIgnoreCase("on");
			mCanPublish = mSettingJsonObject.optBoolean("power_status");
			mNeedCheck = mSettingJsonObject.optBoolean("display");
		} catch (JSONException e) {
			e.printStackTrace();
			mSettingJsonObject = new JSONObject();
		}
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("goods_id", mGoodsId);
		nContentValues.put("type", mType);
		return nContentValues;
	}

	@Override
	protected List<ExpandListItemBean<JSONObject, JSONObject>> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		if (mPageNum == 1) {
			mMoreChildMap.clear();
		}

		List<ExpandListItemBean<JSONObject, JSONObject>> nBeans = new ArrayList<ExpandListItemBean<JSONObject, JSONObject>>();
		JSONObject nCommentsJsonObject = responseJson.optJSONObject("comments");
		if (nCommentsJsonObject == null || nCommentsJsonObject.isNull("list")) {
			return nBeans;
		}

		JSONArray nArray = nCommentsJsonObject.optJSONObject("list").optJSONArray("discuss");
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
						if (!mMoreChildMap.containsKey(nKey)) {
							mMoreChildMap.put(nKey, new ArrayList<JSONObject>());
						}
						mMoreChildMap.get(nKey).add(nArray2.optJSONObject(j));
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
		GridView nGridView = null;
		ArrayList<String> nStrings = new ArrayList<String>();
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_goods_comment_parent, null);
			convertView.findViewById(R.id.reply).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONObject nCommentJsonObject = (JSONObject) v.getTag();
					mCommentReplyDialog.setData(mSettingJsonObject, nCommentJsonObject.optString("comment_id"));
					mCommentReplyDialog.show();
				}
			});
			convertView.findViewById(R.id.reply).setVisibility(mCanReply ? View.VISIBLE : View.GONE);

			nGridView = (GridView) convertView.findViewById(R.id.image_gv);
			nGridView.setAdapter(new QianseitAdapter<String>(nStrings) {

				@Override
				public View getView(int position, View convertView, ViewGroup parent) {
					// TODO Auto-generated method stub
					if (convertView == null) {
						convertView = View.inflate(mActivity, R.layout.item_goods_comment_record_image, null);
						setViewAbsoluteSize(convertView.findViewById(R.id.image), mMultiImageWidth, mMultiImageWidth);
						convertView.findViewById(R.id.image).setOnClickListener(new OnClickListener() {

							@Override
							public void onClick(View v) {
								// TODO Auto-generated method stub
								Bundle nBundle = new Bundle();
								nBundle.putStringArrayList(Run.EXTRA_DATA, (ArrayList<String>) mDataList);
								nBundle.putString(Run.EXTRA_VALUE, (String) v.getTag(R.id.tag_object));
								startActivity(AgentActivity.FRAGMENT_GOODS_IMAGES_PREVIEW, nBundle);
							}
						});
					}

					convertView.findViewById(R.id.image).setTag(R.id.tag_object, getItem(position));
					displayRectangleImage((ImageView) convertView.findViewById(R.id.image), getItem(position));
					return convertView;
				}
			});
			nGridView.setTag(nStrings);
		} else {
			nGridView = (GridView) convertView.findViewById(R.id.image_gv);
			nStrings = (ArrayList<String>) nGridView.getTag();
		}

		convertView.findViewById(R.id.reply).setTag(groupBean.mGrupItem);
		((TextView) convertView.findViewById(R.id.nickname)).setText(groupBean.mGrupItem.optString("author"));
		String nLv = groupBean.mGrupItem.optString("member_lv_name");
		TextView nLvTextView = (TextView) convertView.findViewById(R.id.lv);
		nLvTextView.setText(groupBean.mGrupItem.optString("member_lv_name"));
		nLvTextView.setVisibility(TextUtils.isEmpty(nLv) || nLv.equalsIgnoreCase("null") ? View.GONE : View.VISIBLE);
		((TextView) convertView.findViewById(R.id.time)).setText(StringUtils.friendlyFormatTime(groupBean.mGrupItem.optLong("time")));
		((TextView) convertView.findViewById(R.id.comment)).setText(groupBean.mGrupItem.optString("comment"));
		displayCircleImage((ImageView) convertView.findViewById(R.id.avatar), groupBean.mGrupItem.optString("member_avatar"));
		((RatingBar) convertView.findViewById(R.id.rat)).setRating(groupBean.mGrupItem.optInt("goods_point"));

		int nPosition = mResultLists.indexOf(groupBean);
		convertView.findViewById(R.id.divider).setVisibility(nPosition == 0 ? View.INVISIBLE : View.VISIBLE);

		if (groupBean.mDetailLists.size() > 0) {
			convertView.setPadding(mPaddingLeft, 0, mPaddingRight, 0);
		} else {
			convertView.setPadding(mPaddingLeft, 0, mPaddingRight, mPaddingBottom);
		}

		nStrings.clear();
		JSONArray nImageArray = groupBean.mGrupItem.optJSONArray("images");
		if (nImageArray != null && nImageArray.length() > 0) {
			for (int i = 0; i < nImageArray.length(); i++) {
				nStrings.add(nImageArray.optString(i));
			}
		}
		if (nStrings.size() <= 0) {
			nGridView.setVisibility(View.GONE);
		} else {
			((QianseitAdapter<String>) nGridView.getAdapter()).notifyDataSetChanged();
			nGridView.setVisibility(View.VISIBLE);
		}

		return convertView;
	}

	@Override
	protected View getDetailItemView(ExpandListItemBean<JSONObject, JSONObject> groupBean, JSONObject detailBean, boolean isLastChild, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_goods_comment_child, null);
			convertView.findViewById(R.id.more).setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					int nPosition = (Integer) v.getTag();

					if (mMoreChildMap.containsKey(mResultLists.get(nPosition).mGrupItem.hashCode())) {
						mResultLists.get(nPosition).mDetailLists.addAll(mMoreChildMap.remove(mResultLists.get(nPosition).mGrupItem.hashCode()));
						mAdatpter.notifyDataSetChanged();
					}
				}
			});
		}

		String nHtmlContent = String.format(mReplyContentFormat, detailBean.optString("author"), detailBean.optString("comment"));
		((TextView) convertView.findViewById(R.id.replay_content)).setText(Html.fromHtml(nHtmlContent));
		TextView nMoreView = (TextView) convertView.findViewById(R.id.more);
		int nPosition = mResultLists.indexOf(groupBean);
		nMoreView.setTag(nPosition);
		if (mMoreChildMap.containsKey(groupBean.mGrupItem.hashCode())) {
			nMoreView.setVisibility(View.VISIBLE);
			nMoreView.setText(String.format("更多%s条评价", mMoreChildMap.get(groupBean.mGrupItem.hashCode()).size() + ""));
		} else {
			nMoreView.setVisibility(View.GONE);
			nMoreView.setText(String.format("更多%s条评价", "0"));
		}

		if (!isLastChild) {
			convertView.setPadding(mChildPaddingLeft, 0, mPaddingRight, 0);
			nMoreView.setVisibility(View.GONE);
		} else {
			convertView.setPadding(mChildPaddingLeft, 0, mPaddingRight, mPaddingBottom);
		}

		return convertView;
	}

	@Override
	protected void initActionBar() {
		// TODO Auto-generated method stub
		mActionBar.setShowTitleBar(false);
	}

	@Override
	protected void init() {
		// TODO Auto-generated method stub
		mListView.setDividerHeight(0);
		// setEmptyImage(R.drawable.empty_consult);
		setEmptyText("暂无商品评价");
		mPaddingBottom = Run.dip2px(mActivity, 10);
		mPaddingTop = Run.dip2px(mActivity, 10);
		mPaddingLeft = Run.dip2px(mActivity, 10);
		mChildPaddingLeft = Run.dip2px(mActivity, 80);
		mPaddingRight = Run.dip2px(mActivity, 10);

		mSingleImageWidth = Run.getWindowsWidth(mActivity) - Run.dip2px(mActivity, 90);
		mMultiImageWidth = (mSingleImageWidth - Run.dip2px(mActivity, 3 * 2)) / 3;

		mCommentReplyDialog = new GoodsCommentReplyDialog(this) {

			@Override
			public void replySucc() {
				// TODO Auto-generated method stub
				onRefresh();
			}
		};
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.comment.getDiscuss";
	}

}
