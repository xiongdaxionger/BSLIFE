package com.qianseit.westore.activity.recommend;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseRadioBarFragment;
import com.qianseit.westore.base.adpter.RadioBarBean;
import com.qianseit.westore.httpinterface.member.MemberAttentionInterface;
import com.qianseit.westore.httpinterface.member.MemberInfoInterface;
import com.qianseit.westore.httpinterface.member.MemberUnAttentionInterface;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class RecommendHomeFragment extends BaseRadioBarFragment {
	public final static int COLLECT = 1;
	public final static int RECOMMEND = 2;

	private ImageView avatarView;
	private TextView mUserLv;
	private TextView mUserName;
	private TextView mLiked;
	private TextView mRecommend;
	private TextView mFans;
	private TextView mAttention;
	private TextView mInfo;
	private ImageView sexIcon;
	private Button cancelBut;
	private LinearLayout addLinear,attentionLinear;
	private LoginedUser mLoginedUser;
	private LinearLayout mAttentLayout;

	int mDefualtOrderType = COLLECT;

	private boolean isMy = true;
	private boolean isFrist = true;
	String mUserId;
	String userId;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mDefualtOrderType = mActivity.getIntent().getIntExtra(Run.EXTRA_DETAIL_TYPE, COLLECT);
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
		mActionBar.setTitle(R.string.recommend_person_title);

		mUserId = mLoginedUser.getMember().getMember_id();
		Intent mIntent = mActivity.getIntent();
		userId = mIntent.getStringExtra(Run.EXTRA_VALUE);
		boolean b = TextUtils.isEmpty(userId);
		if (!b) {
			isMy = TextUtils.equals(userId, mLoginedUser.getMember().getMember_id());
		} else {
			userId = mUserId;
			isMy = true;
		}
	}

//	@Override
//	public int defualtSelectRadioBarId(){
//		// TODO Auto-generated method stub
//		return mDefualtOrderType;
//	}

	@Override
	protected List<RadioBarBean> initRadioBar() {
		// TODO Auto-generated method stub
		List<RadioBarBean> nBarBeans = new ArrayList<RadioBarBean>();
//		RecommendCollectFragment collectFragment = new RecommendCollectFragment();
//		Bundle bundle = new Bundle();
//		bundle.putString(Run.EXTRA_VALUE, userId);
//		collectFragment.setArguments(bundle);
//		nBarBeans.add(new RadioBarBean("收藏", COLLECT, collectFragment));
//
//		RecommendFragment recommendFragment = new RecommendFragment();
//		bundle = new Bundle();
//		bundle.putString(Run.EXTRA_VALUE, userId);
//		collectFragment.setArguments(bundle);
//		nBarBeans.add(new RadioBarBean("评价", RECOMMEND, recommendFragment));
		return nBarBeans;
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.recommend_fans_linear:
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_FANS).putExtra(Run.EXTRA_VALUE, userId));
			break;
		case R.id.recommend_like_linear:
			if (!isMy) {
				return;
			}
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_PRAISE));
			break;
		case R.id.recommend_attention_linear:
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_ATTENTION).putExtra(Run.EXTRA_VALUE, userId));
			break;
		case R.id.account_click_but:
			new MemberAttentionInterface(this, userId, mLoginedUser.getMember().getMember_id()) {
				
				@Override
				public void SuccCallBack(JSONObject responseJson) {
					// TODO Auto-generated method stub
					loadUserInfo();
				}
			}.RunRequest();
			break;
		case R.id.account_attention_linear:
			new MemberUnAttentionInterface(this, userId, mLoginedUser.getMember().getMember_id()) {
				
				@Override
				public void SuccCallBack(JSONObject responseJson) {
					// TODO Auto-generated method stub
					loadUserInfo();
				}
			}.RunRequest();
			break;
		default:
			super.onClick(v);
			break;
		}
	}

	@Override
	protected void initTop(LinearLayout topLayout) {
		// TODO Auto-generated method stub
		View nView = View.inflate(mActivity, R.layout.header_recommend_home, null);
		topLayout.addView(nView);

		mLiked = (TextView) findViewById(R.id.personal_liked);
		mFans = (TextView) findViewById(R.id.personal_fans);
		mAttention = (TextView) findViewById(R.id.personal_attention);
		mRecommend = (TextView) findViewById(R.id.personal_recommend);
		avatarView = (ImageView) findViewById(R.id.recommend_personal_avatar);
		mUserLv = (TextView) findViewById(R.id.recommend_personal_lv);
		mUserLv.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// Intent intent = AgentActivity
				// .intentForFragment(
				// getActivity(),
				// AgentActivity.FRAGMENT_HELP_ARTICLE)
				// .putExtra("title", "商派等级规则");
				// if (isMy) {
				// intent.putExtra(
				// "url",
				// Run.buildString(Constant.DOMAIN,"/wap/statics-pointLv.html?from=app&member_id=",
				// mLoginedUser.getMember().getMember_id()));
				// } else {
				// intent.putExtra(
				// "url",Run.buildString(Constant.DOMAIN,"/wap/statics-pointLv.html?from=app"));
				// }
				// getActivity().startActivity(intent);

			}
		});

		mUserName = (TextView) findViewById(R.id.recommend_name);
		sexIcon = (ImageView) findViewById(R.id.recommend_sex);
		findViewById(R.id.recommend_fans_linear).setOnClickListener(this);
		findViewById(R.id.recommend_attention_linear).setOnClickListener(this);
		cancelBut = (Button) findViewById(R.id.account_click_but);
		cancelBut.setOnClickListener(this);
		addLinear = (LinearLayout) findViewById(R.id.recommend_like_linear);
		attentionLinear=(LinearLayout)findViewById(R.id.account_attention_linear);
		addLinear.setOnClickListener(this);
		attentionLinear.setOnClickListener(this);
		mAttentLayout = (LinearLayout) findViewById(R.id.recommend_attention);
		mAttentLayout.setOnClickListener(this);
		mInfo = (TextView) findViewById(R.id.personal_info);

		loadUserInfo();
	}

	void loadUserInfo(){
		new MemberInfoInterface(this, userId) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				JSONObject data = responseJson.optJSONObject("data");
				setTopValues(data);
			}

		}.RunRequest();
	}
	
	void setTopValues(JSONObject dataJsonObject) {
		mUserLv.setVisibility(View.GONE);
		mUserLv.setText(dataJsonObject.optString("member_lv_name"));
		Uri avatarUri = Uri.parse(dataJsonObject.optString("avatar"));
		avatarView.setTag(avatarUri);
		// loader.showImage(avatarView, avatarUri);
		displayCircleImage(avatarView, dataJsonObject.optString("avatar"));
		mUserName.setText("null".equals(dataJsonObject.optString("name")) ? "未设置昵称" : dataJsonObject.optString("name"));
		int sex = dataJsonObject.optInt("sex");
		if (sex == 0) {
			sexIcon.setImageResource(R.drawable.home_nv);
		} else if (sex == 1) {
			sexIcon.setImageResource(R.drawable.home_nan);
		} else {
			sexIcon.setVisibility(View.GONE);
		}
		if ("0".equals(dataJsonObject.optString("is_attention"))) {
			attentionLinear.setVisibility(View.VISIBLE);
			cancelBut.setVisibility(View.GONE);
		} else {
			attentionLinear.setVisibility(View.GONE);
			cancelBut.setVisibility(View.VISIBLE);
		}
		mRecommend.setText(dataJsonObject.optString("opinions_num"));
		mLiked.setText(dataJsonObject.optString("praise_num"));
		mFans.setText(dataJsonObject.optString("fans_num"));
		mAttention.setText(dataJsonObject.optString("follow_num"));
		if ("null".equals(dataJsonObject.optString("desc")) || "".equals(dataJsonObject.optString("desc"))) {

		} else {
			mInfo.setText(dataJsonObject.optString("desc"));
		}
	}

	@Override
	protected BaseDoFragment getRadioBarFragemnt(long radioBarId) {
		// TODO Auto-generated method stub
		return null;
	}
}
