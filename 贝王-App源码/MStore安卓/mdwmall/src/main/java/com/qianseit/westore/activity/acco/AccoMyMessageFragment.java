package com.qianseit.westore.activity.acco;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import android.graphics.Point;
import android.os.Bundle;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextUtils.TruncateAt;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.httpinterface.member.MemberMymessageInterface;
import com.qianseit.westore.util.StringUtils;
import com.qianseit.westore.util.Util;
import com.umeng.analytics.MobclickAgent;
import com.beiwangfx.R;;

public class AccoMyMessageFragment extends BaseDoFragment {

	private View mNewComment;
	private View mNewPraise;
	private View mNewFans;
	private View mNewSysMsg;
	private Point point;
	private LinearLayout mCommentContainer;
	private LinearLayout mPraiseContainer;
	private LinearLayout mFansContainer;
	private LinearLayout mSysmsgContainer;
	private ArrayList<JSONObject> listMsg = new ArrayList<JSONObject>();
	private GridView mGridViewPraise, mGridViewFans;
	private LayoutInflater mInflater;
	private boolean isNeedRefresh;

	private TextView mNewCommentCount, mNewPraiseCount, mNewFansCount, mNewSysMsgCount;
	private View mNewCommentDivider, mNewPraiseDivider, mNewFansDivider, mNewSysMsgDivider;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("我的消息");
		point = Run.getScreenSize(mActivity.getWindowManager());
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		mInflater = inflater;
		rootView = inflater.inflate(R.layout.fragment_acco_mymessage, null);
		mNewComment = rootView.findViewById(R.id.my_message_new_comment);
		mNewPraise = rootView.findViewById(R.id.my_message_new_praise);
		mNewFans = rootView.findViewById(R.id.my_message_new_fans);
		mNewSysMsg = rootView.findViewById(R.id.my_message_new_systemmsg);
		mCommentContainer = (LinearLayout) mNewComment.findViewById(R.id.my_message_new_comment_container);
		mPraiseContainer = (LinearLayout) mNewPraise.findViewById(R.id.my_message_new_praise_container);
		mFansContainer = (LinearLayout) mNewFans.findViewById(R.id.my_message_new_fans_container);
		mSysmsgContainer = (LinearLayout) mNewSysMsg.findViewById(R.id.my_message_new_systemmsg_container);
		mGridViewPraise = (GridView) (inflater.inflate(R.layout.my_message_gridview, null).findViewById(R.id.my_message_gridview));
		mGridViewFans = (GridView) (inflater.inflate(R.layout.my_message_gridview, null).findViewById(R.id.my_message_gridview));

		mNewCommentCount = (TextView) mNewComment.findViewById(R.id.my_msg_new_comment_count);
		mNewPraiseCount = (TextView) mNewPraise.findViewById(R.id.my_message_new_praise_count);
		mNewFansCount = (TextView) mNewFans.findViewById(R.id.my_msg_new_fans_count);
		mNewSysMsgCount = (TextView) mNewSysMsg.findViewById(R.id.my_message_new_systemmsg_count);

		mNewCommentDivider = mNewComment.findViewById(R.id.my_message_new_comment_divider);
		mNewPraiseDivider = mNewPraise.findViewById(R.id.my_message_new_praise_divider);
		mNewFansDivider = mNewFans.findViewById(R.id.my_message_new_fans_divider);
		mNewSysMsgDivider = mNewSysMsg.findViewById(R.id.my_message_new_systemmsg_divider);

		rootView.findViewById(R.id.fragment_mymessage_comment).setOnClickListener(this);
		rootView.findViewById(R.id.fragment_mymessage_praise).setOnClickListener(this);
		rootView.findViewById(R.id.fragment_mymessage_fans).setOnClickListener(this);
		rootView.findViewById(R.id.fragment_mymessage_sysmsg).setOnClickListener(this);
	}

	@Override
	public void onResume() {
		super.onResume();
		MobclickAgent.onPageStart("1_11_5");
		if (isNeedRefresh || listMsg.size() == 0) {
			getMsg();
		}
	}

	void getMsg() {
		new MemberMymessageInterface(this) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				JSONObject data = responseJson.optJSONObject("data");
				listMsg.clear();
				if (data != null) {
					listMsg.add(data.optJSONObject("comment"));
					listMsg.add(data.optJSONObject("praise"));
					listMsg.add(data.optJSONObject("fans"));
					listMsg.add(data.optJSONObject("sysmsg"));
				}
				isNeedRefresh = false;
				Run.removeFromSuperView(mGridViewPraise);
				Run.removeFromSuperView(mGridViewFans);
				fillUpView();
			}
		}.RunRequest();
	}

	@Override
	public void onPause() {
		super.onPause();
		MobclickAgent.onPageEnd("1_11_5");
	}

	@Override
	public void onClick(View v) {
		super.onClick(v);
		isNeedRefresh = true;
		if (v.getId() == R.id.fragment_mymessage_comment) {
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_COMMENT));
		} else if (v.getId() == R.id.fragment_mymessage_praise) {
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_PRAISE));
		} else if (v.getId() == R.id.fragment_mymessage_fans) {
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_FANS).putExtra(Run.EXTRA_VALUE, AgentApplication.getLoginedUser(mActivity).getMember().getMember_id()));
		} else if (v.getId() == R.id.fragment_mymessage_sysmsg) {
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_SYS_MESSAGE));
		}
	}

	private void fillUpView() {
		if (listMsg.size() < 4) {
			return;
		}
		if (listMsg.get(0).optInt("count") > 0) {
			mNewCommentCount.setText(listMsg.get(0).optString("count"));
			mNewCommentCount.setVisibility(View.VISIBLE);
			mNewCommentDivider.setVisibility(View.VISIBLE);
		} else {
			mNewCommentCount.setVisibility(View.GONE);
			mCommentContainer.setVisibility(View.GONE);
			mNewCommentDivider.setVisibility(View.GONE);
		}
		if (listMsg.get(1).optInt("count") > 0) {
			mNewPraiseCount.setText(listMsg.get(1).optString("count"));
			mNewPraiseCount.setVisibility(View.VISIBLE);
			mNewPraiseDivider.setVisibility(View.VISIBLE);
		} else {
			mPraiseContainer.setVisibility(View.GONE);
			mNewPraiseCount.setVisibility(View.GONE);
			mNewPraiseDivider.setVisibility(View.GONE);
		}
		if (listMsg.get(2).optInt("count") > 0) {
			mNewFansCount.setText(listMsg.get(2).optString("count"));
			mNewFansCount.setVisibility(View.VISIBLE);
			mNewFansDivider.setVisibility(View.VISIBLE);
		} else {
			mNewFansCount.setVisibility(View.GONE);
			mFansContainer.setVisibility(View.GONE);
			mNewFansDivider.setVisibility(View.GONE);
		}
		if (listMsg.get(3).optInt("count") > 0) {
			mNewSysMsgCount.setText(listMsg.get(3).optString("count"));
			mNewSysMsgCount.setVisibility(View.VISIBLE);
			mNewSysMsgDivider.setVisibility(View.VISIBLE);
		} else {
			mNewSysMsgCount.setVisibility(View.GONE);
			mNewSysMsgDivider.setVisibility(View.GONE);
		}
		mCommentContainer.removeAllViews();
		if (listMsg.get(0) != null && listMsg.get(0).has("res")) {
			TextView comment = null;
			JSONObject json;
			JSONArray listC = listMsg.get(0).optJSONArray("res");
			for (int i = 0; i < listC.length() && i < 3; i++) {
				json = listC.optJSONObject(i);
				comment = new TextView(mActivity);
				if (i != 0) {
					comment.setPadding(0, Util.dip2px(mActivity, 5), 0, 0);
				}
				comment.setTextColor(0xffbababa);
				comment.setText(getCommentString(json.optString("name") + "：", json.optString("content"), 0xff333333));
				mCommentContainer.addView(comment);
			}
			if (listC.length() >= 3) {
				TextView c4 = new TextView(mActivity);
				c4.setPadding(0, Util.dip2px(mActivity, 5), 0, 0);
				c4.setTextColor(0xffbababa);
				c4.setText("...");
				mCommentContainer.addView(c4);
			}
		}

		mSysmsgContainer.removeAllViews();
		if (listMsg.get(3) != null && listMsg.get(3).has("res")) {
			TextView comment = null;
			JSONObject json;
			JSONArray listC = listMsg.get(3).optJSONArray("res");
			for (int i = 0; i < listC.length() && i < 3; i++) {
				json = listC.optJSONObject(i);
				comment = new TextView(mActivity);
				comment.setSingleLine(true);
				comment.setEllipsize(TruncateAt.END);
				if (i != 0) {
					comment.setPadding(0, Util.dip2px(mActivity, 5), 0, 0);
				}
				comment.setTextColor(0xffbababa);
				comment.setText(json.optString("detail"));
				mSysmsgContainer.addView(comment);
			}
			if (listC.length() >= 3) {
				TextView c4 = new TextView(mActivity);
				c4.setPadding(0, Util.dip2px(mActivity, 5), 0, 0);
				c4.setTextColor(0xffbababa);
				c4.setText("...");
				mSysmsgContainer.addView(c4);
			}
		}

		if (listMsg.get(1).has("res")) {
			AvatarNameAdapter praiseAdapter = new AvatarNameAdapter(listMsg.get(1).optJSONArray("res"));
			mGridViewPraise.setAdapter(praiseAdapter);
			mPraiseContainer.addView(mGridViewPraise);
		}
		if (listMsg.get(2).has("res")) {
			AvatarNameAdapter fansAdapter = new AvatarNameAdapter(listMsg.get(2).optJSONArray("res"));
			mGridViewFans.setAdapter(fansAdapter);
			mFansContainer.addView(mGridViewFans);
		}

	}

	private SpannableString getCommentString(String user, String comment, int color) {
		SpannableString sp = new SpannableString(user + comment);
		ForegroundColorSpan span1 = new ForegroundColorSpan(color);
		sp.setSpan(span1, 0, user.length(), Spannable.SPAN_INCLUSIVE_EXCLUSIVE);
		return sp;
	}

	private class AvatarNameAdapter extends BaseAdapter implements OnClickListener {

		private JSONArray list;

		public AvatarNameAdapter(JSONArray list) {
			this.list = list;
		}

		@Override
		public int getCount() {
			if (list != null) {
				if (list.length() >= 5) {
					return 6;
				}
				return list.length();
			}
			return 0;
		}

		@Override
		public Object getItem(int position) {
			return null;
		}

		@Override
		public long getItemId(int position) {
			return 0;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			ViewHolder holder;
			if (convertView == null) {
				holder = new ViewHolder();
				convertView = mInflater.inflate(R.layout.item_avatar_name, null);
				holder.avatar = (ImageView) convertView.findViewById(R.id.message_user_avtar);
				int width = (point.x - Run.dip2px(mActivity, 5) * 10 - Run.dip2px(mActivity, 30)) / 6;
				LayoutParams paramsa = holder.avatar.getLayoutParams();
				paramsa.width = width;
				paramsa.height = width;
				holder.avatar.setLayoutParams(paramsa);
				holder.userName = (TextView) convertView.findViewById(R.id.message_user_name);
				LayoutParams paramst = holder.userName.getLayoutParams();
				paramst.width = width;
				holder.userName.setLayoutParams(paramst);
				convertView.setOnClickListener(this);
				convertView.setTag(holder);
			} else {
				holder = (ViewHolder) convertView.getTag();
			}
			if (position == 5) {
				holder.avatar.setImageResource(0);
				holder.userName.setText("...");
			} else {
				JSONObject obj = list.optJSONObject(position);
				displayCircleImage(holder.avatar, obj.optString("avatar"));
				holder.userName.setText(StringUtils.CommfilterString(obj.optString("name")));
				convertView.setTag(R.id.tag_object, obj);
			}
			return convertView;
		}

		@Override
		public void onClick(View v) {
			if (v.getTag(R.id.tag_object) != null) {
				JSONObject json = (JSONObject) v.getTag(R.id.tag_object);
				mActivity.startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_HOME).putExtra("userId", json.optString("member_id")));
			}
		}

	}

	private class ViewHolder {
		private ImageView avatar;
		private TextView userName;
	}

}
