package com.qianseit.westore.activity.recommend;

import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.text.Html;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;
import android.widget.Toast;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseGridWithHeaderRadioBarFragment;
import com.qianseit.westore.httpinterface.goods.GoodsAddPraiseInterface;
import com.qianseit.westore.httpinterface.goods.GoodsDelPraiseInterface;
import com.qianseit.westore.httpinterface.member.MemberAddFavInterface;
import com.qianseit.westore.httpinterface.member.MemberAttentionInterface;
import com.qianseit.westore.httpinterface.member.MemberDelFavInterface;
import com.qianseit.westore.httpinterface.member.MemberInfoInterface;
import com.qianseit.westore.httpinterface.member.MemberUnAttentionInterface;
import com.qianseit.westore.ui.ShareView.ShareViewDataSource;
import com.qianseit.westore.ui.ShareViewPopupWindow;
import com.qianseit.westore.util.CacheUtils;
import com.qianseit.westore.util.StringUtils;
import com.qianseit.westore.util.Util;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class RecommendCollectFragment extends BaseGridWithHeaderRadioBarFragment<JSONObject> {
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
	private LinearLayout addLinear, attentionLinear;
	private LinearLayout mAttentLayout;

	String userId;
	int mWidth;
	int mDefualtOrderType = COLLECT;

	@Override
	protected List<JSONObject> fetchDatas(JSONObject responseJson) {
		// TODO Auto-generated method stub
		List<JSONObject> nJsonObjects = new ArrayList<JSONObject>();
		JSONArray dataArray = responseJson.optJSONArray("data");
		if (dataArray != null && dataArray.length() > 0) {
			for (int i = 0; i < dataArray.length(); i++)
				nJsonObjects.add(dataArray.optJSONObject(i));
		}
		return nJsonObjects;
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("son_object", "json");
		nContentValues.put("member_id", getUserId());
		nContentValues.put("limit", "20");
		return nContentValues;
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle(R.string.recommend_person_title);

		WindowManager wm = (WindowManager) mActivity.getSystemService(Context.WINDOW_SERVICE);
		DisplayMetrics dm = new DisplayMetrics();
		wm.getDefaultDisplay().getMetrics(dm);
		mWidth = wm.getDefaultDisplay().getWidth() - Util.dip2px(mActivity, 10);

		Intent mIntent = mActivity.getIntent();
		userId = mIntent.getStringExtra(Run.EXTRA_VALUE);
		mDefualtOrderType = mIntent.getIntExtra(Run.EXTRA_DETAIL_TYPE, COLLECT);

		boolean b = TextUtils.isEmpty(userId);
		setPagetSize(10);
	}

	@Override
	public int DefaultSelectRadio() {
		// TODO Auto-generated method stub
		return mDefualtOrderType;
	}

	@Override
	protected View getItemView(JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (getItemViewType(responseJson) == 0) {
			return getCollectView(responseJson, convertView, parent);
		} else {
			return getRecommendView(responseJson, convertView, parent);
		}
	}

	View getRecommendView(final JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_recommend, null);
		}
		final TextView textview_sharead = (TextView) convertView.findViewById(R.id.textview_shareads); // 分享
		final RelativeLayout ll_position = (RelativeLayout) convertView.findViewById(R.id.ll_position);
		final TextView nLikeTextview = (TextView) convertView.findViewById(R.id.textview_likes); // 喜欢
		final ImageView nLikesImageView = (ImageView) convertView.findViewById(R.id.textview_likes_image); // 是否点赞

		nLikesImageView.setTag(responseJson);

		displayCircleImage((ImageView) convertView.findViewById(R.id.img_brand_logos), responseJson.optString("avatar"));
		displayRectangleImage((ImageView) convertView.findViewById(R.id.imgfilter), responseJson.optString("image_url"));
		((TextView) convertView.findViewById(R.id.textview_names)).setText(responseJson.optString("name"));
		((TextView) convertView.findViewById(R.id.textview_contents)).setText(Html.fromHtml("<font size=\"4\" color=\"red\">[好物评价]</font><font size=\"4\" color=\"#9b9b9b\"></font>"
				+ responseJson.optString("content")));
		((TextView) convertView.findViewById(R.id.textview_titles)).setText(responseJson.optString("goods_name"));

		((TextView) convertView.findViewById(R.id.textview_times)).setText(responseJson.optString("created"));
		TextView nRelated = (TextView) convertView.findViewById(R.id.button_relateds);
		nRelated.setBackgroundColor(Color.parseColor("#ffffff"));
		nRelated.setTextColor(Color.parseColor("#666666"));
		nRelated.setText(StringUtils.friendlyFormatLongStringTime(responseJson.optString("created")));
		String pinglun = "评论(" + responseJson.optString("c_num") + ")";
		((TextView) convertView.findViewById(R.id.textview_commentss)).setText(pinglun);
		nLikeTextview.setText(responseJson.optString("p_num"));
		((TextView) convertView.findViewById(R.id.textview_levels)).setText(responseJson.optString("member_lv_name"));

		/**
		 * 点赞 1 已点赞 0未点赞
		 */
		if (responseJson.optString("is_praise").equals("0")) {
			nLikesImageView.setImageResource(R.drawable.my_msg_praise);
		} else {
			nLikesImageView.setImageResource(R.drawable.my_new_fans);
		}

		JSONObject tagJSON = responseJson.optJSONObject("tag");
		if (ll_position.getChildCount() >= 2)
			ll_position.removeViewAt(1);
		if (tagJSON != null) {

			Iterator it = tagJSON.keys();
			List<String> keyListstr = new ArrayList<String>();
			while (it.hasNext()) {
				keyListstr.add(it.next().toString());
			}
			if (keyListstr.size() > 0) {
				JSONObject objTag = tagJSON.optJSONObject(keyListstr.get(0));

				RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
				float x = (float) (Float.valueOf(objTag.optString("x")) / 100.0);
				float y = (float) (Float.valueOf(objTag.optString("y")) / 100.0);
				int xx = (int) (mWidth * x);
				int yy = (int) (Util.dip2px(mActivity, 320) * y);
				params.topMargin = yy;
				params.leftMargin = xx;
				final View view = View.inflate(mActivity, R.layout.picturetagview, null);
				// ll_position.removeAllViews();
				TextView tvPictureTagLabel = (TextView) view.findViewById(R.id.tvPictureTagLabel);
				RelativeLayout rrTag = (RelativeLayout) view.findViewById(R.id.loTag);
				if (objTag.optString("image_type").equals("1")) {
					rrTag.setBackgroundResource(R.drawable.bg_picturetagview_tagview_right);
				} else {
					rrTag.setBackgroundResource(R.drawable.bg_picturetagview_tagview_left);
				}

				rrTag.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						Intent intent = AgentActivity.intentForFragment(getActivity(), AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_CLASS_ID, responseJson.optString("goods_id"));
						startActivity(intent);
					}
				});
				tvPictureTagLabel.setText(objTag.optString("image_tag"));
				ll_position.addView(view, params);
			}

		}

		/** 分享 */
		textview_sharead.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {

				final ShareViewPopupWindow morePopWindow = new ShareViewPopupWindow(mActivity);
				final ShareViewDataSource dataSource = new ShareViewDataSource() {

					@Override
					public String getShareUrl() {
						// return goodsData.optString("image_url");
						return String.format(Run.RECOMMEND_URL, responseJson.optString("id"));
					}

					@Override
					public String getShareText() {
						return responseJson.optString("goods_name") + "-" + responseJson.optString("content");
					}

					@Override
					public String getShareImageUrl() {
						return responseJson.optString("image_url");
					}

					@Override
					public String getShareImageFile() {
						return CacheUtils.getImageCacheFile(responseJson.optString("image_url"));
					}

					@Override
					public String getShareMessage() {
						// TODO Auto-generated method stub
						return null;
					}
				};

				morePopWindow.setDataSource(dataSource);
				morePopWindow.showAtLocation(rootView, android.view.Gravity.BOTTOM, 0, 0);
			}
		});

		convertView.findViewById(R.id.textview_likes_image).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				if (responseJson.optString("is_praise").equals("0")) {
					new GoodsAddPraiseInterface(RecommendCollectFragment.this, getUserId(), responseJson.optString("id")) {

						@Override
						public void SuccCallBack(JSONObject responseJson) {
							// TODO Auto-generated method stub
							nLikesImageView.setImageResource(R.drawable.my_new_fans);
							int like = Integer.valueOf(nLikeTextview.getText().toString()) + 1;
							nLikeTextview.setText(like + "");
							responseJson.remove("is_praise");
							try {
								responseJson.put("is_praise", 1);
								responseJson.remove("p_num");
								responseJson.put("p_num", like + "");
								Toast.makeText(mActivity, "点赞成功", 5000).show();
							} catch (JSONException e) {
								e.printStackTrace();
							}
						}
					}.RunRequest();

				} else {
					new GoodsDelPraiseInterface(RecommendCollectFragment.this, getUserId(), responseJson.optString("id")) {

						@Override
						public void SuccCallBack(JSONObject responseJson) {
							// TODO Auto-generated method stub
							nLikesImageView.setImageResource(R.drawable.my_msg_praise);
							int like = Integer.valueOf(nLikeTextview.getText().toString()) - 1;
							nLikeTextview.setText(like + "");
							responseJson.remove("is_praise");
							try {
								responseJson.put("is_praise", 0);
								responseJson.remove("p_num");
								responseJson.put("p_num", like + "");
								Toast.makeText(mActivity, "取消点赞", 5000).show();
							} catch (JSONException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
					}.RunRequest();

				}
			}
		});

		/**
		 * 推荐详情
		 */
		convertView.findViewById(R.id.imgfilter).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_GOODS_COMMENT).putExtra("id", responseJson.optString("id"))
						.putExtra(Run.EXTRA_DATA, mLoginedUser.getMember().getMember_id().equals(getUserId())));
			}
		});
		/**
		 * 评论
		 */
		convertView.findViewById(R.id.textview_commentss).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_GOODS_COMMENT).putExtra("id", responseJson.optString("id"))
						.putExtra(Run.EXTRA_DATA, mLoginedUser.getMember().getMember_id().equals(getUserId())));
			}
		});
		/**
		 * 跳转个人资料
		 */
		convertView.findViewById(R.id.img_brand_logos).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_HOME).putExtra(Run.EXTRA_VALUE, getUserId()));
			}
		});
		return convertView;
	}

	View getCollectView(JSONObject responseJson, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_recommend_collect, null);
			convertView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					JSONObject json = (JSONObject) v.getTag();
					if (json != null) {
						if (json.optBoolean("marketable", false)) {
							String goodsIID = json.optString("goods_id");
							Intent intent = AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_CLASS_ID, goodsIID);
							mActivity.startActivity(intent);
						}
					}
				}
			});
		}
		ImageView imageIcon = (ImageView) convertView.findViewById(R.id.goods_item_icon);
		View goodsRelView = convertView.findViewById(R.id.goods_item_rel);
		setViewSize(goodsRelView, mImageWidth, mImageWidth);
		String value = responseJson.optString("price");
		BigDecimal b;
		if (!TextUtils.isEmpty(value)) {
			b = new BigDecimal(value);
		} else {
			b = new BigDecimal("0.00");
		}

		b = b.setScale(2, BigDecimal.ROUND_DOWN);
		((TextView) convertView.findViewById(R.id.goods_item_price)).setText(Run.buildString("￥", b));
		((TextView) convertView.findViewById(R.id.goods_item_title)).setText(responseJson.optString("name"));
		((TextView) convertView.findViewById(R.id.goods_item_time)).setText(StringUtils.LongTimeToString("yyyy-MM-dd", responseJson.optLong("fav_add_time")));
		if (responseJson.optBoolean("marketable", false)) {
			convertView.findViewById(R.id.goods_item_shelf_icon).setVisibility(View.GONE);
		} else {
			convertView.findViewById(R.id.goods_item_shelf_icon).setVisibility(View.VISIBLE);
		}
		View viewCalcel = convertView.findViewById(R.id.goods_item_time_calcel);
		View viewRelative = convertView.findViewById(R.id.goods_item_time_relative);
		viewCalcel.setOnClickListener(this);
		View viewAdd = convertView.findViewById(R.id.goods_item_time_add);
		viewAdd.setOnClickListener(this);
		if (getUserId().equals(mLoginedUser.getMember().getMember_id())) {
			viewRelative.setVisibility(View.VISIBLE);
			if (responseJson.isNull("isFav")) {
				viewCalcel.setVisibility(View.VISIBLE);
				viewAdd.setVisibility(View.GONE);
			} else {
				viewAdd.setVisibility(View.VISIBLE);
				viewCalcel.setVisibility(View.GONE);
			}
		} else {
			// viewRelative.setVisibility(View.GONE);
			viewAdd.setVisibility(View.GONE);
			viewCalcel.setVisibility(View.GONE);
		}
		viewCalcel.setTag(responseJson);
		viewAdd.setTag(responseJson);
		convertView.setTag(responseJson);
		displayRectangleImage(imageIcon, responseJson.optString("image_default_url"));
		return convertView;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		if (getSelectedType() == COLLECT) {
			return "mobileapi.info.favorite";
		} else {
			return "mobileapi.goods.getopinionsformember";
		}

	}

	@Override
	protected void addBelowBarHeader(LinearLayout headerLayout) {
		// TODO Auto-generated method stub
		View nView = View.inflate(mActivity, R.layout.header_recommend_home, null);
		headerLayout.addView(nView);

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
		attentionLinear = (LinearLayout) findViewById(R.id.account_attention_linear);
		addLinear.setOnClickListener(this);
		attentionLinear.setOnClickListener(this);
		mAttentLayout = (LinearLayout) findViewById(R.id.recommend_attention);
		mAttentLayout.setOnClickListener(this);
		mInfo = (TextView) findViewById(R.id.personal_info);
		onSelectedChanged(getSelectedRadioBean());
		loadUserInfo();
		AutoLoad(false);
	}

	void loadUserInfo() {
		new MemberInfoInterface(this, userId) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				JSONObject data = responseJson.optJSONObject("data");
				setTopValues(data);
				onRefresh(null);

			}

		}.RunRequest();
	}

	void setTopValues(JSONObject dataJsonObject) {
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
		if (mLoginedUser.getMember().getMember_id().equals(getUserId())) {
			mAttentLayout.setVisibility(View.GONE);
		} else {
			mAttentLayout.setVisibility(View.VISIBLE);
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
		if ("null".equals(dataJsonObject.optString("descsign")) || "".equals(dataJsonObject.optString("descsign"))) {
			mInfo.setText("");
		} else {
			mInfo.setText(dataJsonObject.optString("descsign"));
		}
	}

	@Override
	public void onSelectedChanged(RadioBarBean selectedRadioBean) {
		// TODO Auto-generated method stub
		if (selectedRadioBean.mId == COLLECT && selectedRadioBean.mSelected) {
			if (mLoginedUser.getMember().getMember_id().equals(getUserId())) {
				setEmptyText("你目前还没有收藏过好物哦");
			} else {
				setEmptyText("TA目前还没有收藏过好物哦");
			}
		} else {
			if (mLoginedUser.getMember().getMember_id().equals(getUserId())) {
				setEmptyText("你目前还没有评价过好物哦");
			} else {
				setEmptyText("TA目前还没有评价过好物哦");
			}
		}
	}

	@Override
	protected int getViewTypeCount() {
		// TODO Auto-generated method stub
		return 2;
	}

	@Override
	protected int getItemViewType(JSONObject t) {
		// TODO Auto-generated method stub
		if (getSelectedType() == COLLECT) {
			mImageWidth = (1080 - Run.dip2px(mActivity, 5 * (2 + 1))) / 2;
			mGridView.setNumColumns(2);
			return 0;
		} else {
			mImageWidth = (1080 - Run.dip2px(mActivity, 5 * (1 + 1))) / 2;
			mGridView.setNumColumns(1);
			return 1;
		}
	}

	public String getUserId() {
		return userId;
	}

	@Override
	protected List<RadioBarBean> initRadioBar() {
		// TODO Auto-generated method stub
		List<RadioBarBean> nBarBeans = new ArrayList<RadioBarBean>();
		nBarBeans.add(new RadioBarBean("收藏", COLLECT));
		nBarBeans.add(new RadioBarBean("评价", RECOMMEND));
		return nBarBeans;
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		final JSONObject jsonObject;
		switch (v.getId()) {
		case R.id.goods_item_icon:
			break;
		case R.id.goods_item_time_add:
			jsonObject = (JSONObject) v.getTag();
			new MemberAddFavInterface(this, jsonObject.optString("goods_id")) {

				@Override
				public void SuccCallBack(JSONObject responseJson) {
					// TODO Auto-generated method stub
					jsonObject.remove("isFav");
					Run.alert(mActivity, "收藏成功");
					mAdapter.notifyDataSetChanged();
				}
			}.RunRequest();
			break;
		case R.id.goods_item_time_calcel:
			jsonObject = (JSONObject) v.getTag();
			new MemberDelFavInterface(this, jsonObject.optString("goods_id")) {

				@Override
				public void SuccCallBack(JSONObject responseJson) {
					// TODO Auto-generated method stub
					try {
						jsonObject.put("isFav", "add");
						Run.alert(mActivity, "已取消收藏");
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					mAdapter.notifyDataSetChanged();
				}
			}.RunRequest();
			break;
		case R.id.recommend_fans_linear:
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_FANS).putExtra(Run.EXTRA_VALUE, userId));
			break;
		case R.id.recommend_like_linear:
			if (!getUserId().equals(mLoginedUser.getMember().getMember_id())) {
				return;
			}
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_PRAISE));
			break;
		case R.id.recommend_attention_linear:
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_ATTENTION).putExtra(Run.EXTRA_VALUE, userId));
			break;
		case R.id.account_click_but:

			new MemberUnAttentionInterface(this, userId, mLoginedUser.getMember().getMember_id()) {

				@Override
				public void SuccCallBack(JSONObject responseJson) {
					// TODO Auto-generated method stub
					Run.alert(mActivity, "已取消关注");
					loadUserInfo();
				}
			}.RunRequest();
			break;

		case R.id.account_attention_linear:
			new MemberAttentionInterface(this, userId, mLoginedUser.getMember().getMember_id()) {

				@Override
				public void SuccCallBack(JSONObject responseJson) {
					// TODO Auto-generated method stub
					Run.alert(mActivity, "关注成功");
					loadUserInfo();
				}
			}.RunRequest();
			break;
		default:
			super.onClick(v);
			break;
		}
	}
}
