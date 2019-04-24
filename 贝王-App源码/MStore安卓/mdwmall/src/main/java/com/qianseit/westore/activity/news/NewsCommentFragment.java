package com.qianseit.westore.activity.news;

import android.content.ContentValues;
import android.os.Bundle;
import android.os.Message;
import android.text.Html;
import android.text.TextUtils;
import android.util.SparseArray;
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
import com.qianseit.westore.activity.goods.GoodsCommentReplyDialog;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseExpandListFragment;
import com.qianseit.westore.httpinterface.member.MemberReadNewsInterface;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class NewsCommentFragment extends BaseExpandListFragment<JSONObject, JSONObject> {
	final int READ_MSG = 0x01;

	String mReplyContentFormat = "<font color=\"#333333\">%s：</font><font color=\"#808080\">%s</font>";

	SparseArray<List<JSONObject>> mMoreChildArray = new SparseArray<List<JSONObject>>();

	GoodsCommentReplyDialog mCommentReplyDialog;

	int mPaddingLeft = 0;
	int mChildPaddingLeft = 0;
	int mPaddingRight = 0;
	int mPaddingTop = 0;
	int mPaddingBottom = 0;

	int mSingleImageWidth = 0;
	int mMultiImageWidth = 0;

	protected String mTitle;

	List<Message> mMessages = new ArrayList<Message>();
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
		mTitle = getArguments().getString(Run.EXTRA_TITLE);
		mActionBar.setShowTitleBar(false);
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("type", "discuss");
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
		GridView nGridView = null;
		ArrayList<String> nStrings = new ArrayList<String>();
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_news_comment, null);
			convertView.findViewById(R.id.reply).setVisibility(View.GONE);

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

		((TextView) convertView.findViewById(R.id.title)).setText(groupBean.mGrupItem.optString("type"));
		((TextView) convertView.findViewById(R.id.goods_name)).setText(groupBean.mGrupItem.optString("name"));
		((TextView) convertView.findViewById(R.id.title)).setText(groupBean.mGrupItem.optString("type"));
		displaySquareImage((ImageView) convertView.findViewById(R.id.goods_image), groupBean.mGrupItem.optString("image_default_id"));
		convertView.findViewById(R.id.goods_tr).setTag(groupBean.mGrupItem.optString("product_id"));

		convertView.findViewById(R.id.reply).setTag(groupBean.mGrupItem);
		((TextView) convertView.findViewById(R.id.nickname)).setText(mLoginedUser.getUName());
		if (TextUtils.isEmpty(groupBean.mGrupItem.optString("member_lv_name"))) {
			convertView.findViewById(R.id.lv).setVisibility(View.GONE);
		} else {
			((TextView) convertView.findViewById(R.id.lv)).setText(groupBean.mGrupItem.optString("member_lv_name"));
		}
		((TextView) convertView.findViewById(R.id.time)).setText(StringUtils.LongTimeToLongString(groupBean.mGrupItem.optLong("time")));
		((TextView) convertView.findViewById(R.id.comment)).setText(groupBean.mGrupItem.optString("comment"));
		displayCircleImage((ImageView) convertView.findViewById(R.id.avatar), mLoginedUser.getAvatarUri());
		((RatingBar) convertView.findViewById(R.id.rat)).setRating(groupBean.mGrupItem.optInt("goods_point"));

		int nPosition = mResultLists.indexOf(groupBean);
		convertView.findViewById(R.id.divider_top).setVisibility(nPosition == 0 ? View.GONE : View.VISIBLE);

		if (groupBean.mDetailLists.size() > 0) {
			convertView.setPadding(0, 0, 0, 0);
		} else {
			convertView.setPadding(0, 0, 0, mPaddingBottom);
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

		readNews(groupBean.mGrupItem);

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

					if (mMoreChildArray.get(mResultLists.get(nPosition).mGrupItem.hashCode()) != null) {
						mResultLists.get(nPosition).mDetailLists.addAll(mMoreChildArray.get(mResultLists.get(nPosition).mGrupItem.hashCode()));
						mMoreChildArray.delete(mResultLists.get(nPosition).mGrupItem.hashCode());
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
		if (mMoreChildArray.get(groupBean.mGrupItem.hashCode()) != null) {
			nMoreView.setVisibility(View.VISIBLE);
			nMoreView.setText(String.format("更多%s条评价", mMoreChildArray.get(groupBean.mGrupItem.hashCode()).size() + ""));
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
		setEmptyText("暂无" + mTitle);
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

	protected void readNews(JSONObject newsJsonObject) {
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
