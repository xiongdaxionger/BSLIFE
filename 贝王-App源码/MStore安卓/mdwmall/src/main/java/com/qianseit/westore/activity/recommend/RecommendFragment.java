package com.qianseit.westore.activity.recommend;

import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.text.Html;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;
import android.widget.Toast;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.httpinterface.goods.GoodsAddPraiseInterface;
import com.qianseit.westore.httpinterface.goods.GoodsDelPraiseInterface;
import com.qianseit.westore.ui.ShareView.ShareViewDataSource;
import com.qianseit.westore.ui.ShareViewPopupWindow;
import com.qianseit.westore.util.CacheUtils;
import com.qianseit.westore.util.StringUtils;
import com.qianseit.westore.util.Util;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public abstract class RecommendFragment extends BaseListFragment<JSONObject> {

	int mWidth;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		WindowManager wm = (WindowManager) mActivity.getSystemService(Context.WINDOW_SERVICE);
		DisplayMetrics dm = new DisplayMetrics();
		wm.getDefaultDisplay().getMetrics(dm);
		mWidth = wm.getDefaultDisplay().getWidth() - Util.dip2px(mActivity, 10);
		
		mActionBar.setShowTitleBar(false);
	}

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
	protected void endInit() {
		// TODO Auto-generated method stub
		if (mLoginedUser.getMember().getMember_id().equals(getUserId())) {
			setEmptyText("你目前还没有评价过好物哦");
		} else {
			setEmptyText("TA目前还没有评价过好物哦");
		}
	}
	
	@Override
	protected View getItemView(final JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_recommend, null);
		}
		final TextView textview_sharead = (TextView) convertView.findViewById(R.id.textview_shareads); // 分享
		final RelativeLayout ll_position = (RelativeLayout) convertView.findViewById(R.id.ll_position);
		final TextView nLikeTextview = (TextView) convertView.findViewById(R.id.textview_likes); // 喜欢
		final ImageView nLikesImageView = (ImageView) convertView.findViewById(R.id.textview_likes_image); // 是否点赞

		nLikesImageView.setTag(responseJson);

		displayCircleImage((ImageView) convertView.findViewById(R.id.img_brand_logos), responseJson.optString("brand_name"));
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
		((TextView) convertView.findViewById(R.id.textview_levels)).setText("LV." + responseJson.optString("member_lv_id"));

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
						return String.format(Run.RECOMMEND_URL, responseJson.optString("image_url"));
					}

					@Override
					public String getShareText() {
						return responseJson.optString("goods_name") + "-" + responseJson.optString("content");
					}

					@Override
					public String getShareImageUrl() {
						return responseJson.optString("image");
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
					new GoodsAddPraiseInterface(RecommendFragment.this, getUserId(), responseJson.optString("id")) {

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
								Run.alert(mActivity, "点赞成功");
							} catch (JSONException e) {
								e.printStackTrace();
							}
						}
					}.RunRequest();

				} else {
					new GoodsDelPraiseInterface(RecommendFragment.this, getUserId(), responseJson.optString("id")) {

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
								Run.alert(mActivity, "取消点赞");
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
				startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_GOODS_COMMENT).putExtra("id", responseJson.optString("id")).putExtra(Run.EXTRA_DATA, mLoginedUser.getMember().getMember_id().equals(getUserId())));
			}
		});
		/**
		 * 评论
		 */
		convertView.findViewById(R.id.textview_commentss).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_GOODS_COMMENT).putExtra("id", responseJson.optString("id")).putExtra(Run.EXTRA_DATA, mLoginedUser.getMember().getMember_id().equals(getUserId())));
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

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("son_object", "json");
		nContentValues.put("member_id", getUserId());
		return nContentValues;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.goods.getopinionsformember";
	}

	public abstract String getUserId();
}
