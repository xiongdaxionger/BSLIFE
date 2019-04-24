package com.qianseit.westore.activity.recommend;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.base.BaseListFragment;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.httpinterface.goods.GoodsAddOptionsCommentsInterface;
import com.qianseit.westore.httpinterface.goods.GoodsAddPraiseInterface;
import com.qianseit.westore.httpinterface.goods.GoodsDelOptionsInterface;
import com.qianseit.westore.httpinterface.goods.GoodsDelPraiseInterface;
import com.qianseit.westore.httpinterface.goods.GoodsGetOptionsInfoInterface;
import com.qianseit.westore.httpinterface.goods.GoodsTopOptionsInterface;
import com.qianseit.westore.ui.CommendPopupWindow;
import com.qianseit.westore.ui.MTextView;
import com.qianseit.westore.ui.ShareView.ShareViewDataSource;
import com.qianseit.westore.ui.ShareViewPopupWindow;
import com.qianseit.westore.ui.XPullDownListView;
import com.qianseit.westore.util.CacheUtils;
import com.qianseit.westore.util.StringUtils;
import com.qianseit.westore.util.Util;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

public class RecommendGoodCommentFragment extends BaseListFragment<JSONObject> {

	public class MyCommendPopupWindow extends CommendPopupWindow {

		public MyCommendPopupWindow(Activity context) {
			super(context);
		}

		@Override
		public void onClick(View v) {
			if (v.getId() == R.id.acco_top1) {
				new GoodsDelOptionsInterface(RecommendGoodCommentFragment.this, mId) {

					@Override
					public void SuccCallBack(JSONObject responseJson) {
						// TODO Auto-generated method stub
						Run.alert(mActivity, "删除成功");
						mActivity.finish();
					}
				}.RunRequest();
			} else if (v.getId() == R.id.acco_top2) {
				new GoodsTopOptionsInterface(RecommendGoodCommentFragment.this, mId) {

					@Override
					public void SuccCallBack(JSONObject responseJson) {
						// TODO Auto-generated method stub
						Run.alert(mActivity, "置顶成功");
						mActivity.finish();
					}
				}.RunRequest();
			}
			dismiss();
		}

	}

	private ImageView sImageView;
	private RelativeLayout picture;
	private String goodsId;
	private String imagePath;
	private FragmentActivity mContext;
	private MTextView mPhoto_album_title;
	private TextView mContentName;
	private TextView mRatingNum;
	private LinearLayout mLinearLayout;
	private String id;
	private String mId;
	private int mCommendNum;
	private LinearLayout mLinearLayout2;
	private RelativeLayout mRl_position;
	private TextView mShare;
	private TextView mLike;
	private EditText mEt_comment;
	private Button mSendBut;
	private ImageView mImage;
	private String mUserId;
	public JsonTask mTask1;
	public int width;
	public int imageWidth;
	private WindowManager wm;
	private JSONArray mPraseArray;
	private boolean isPerson = false;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("评论");
		Intent intent = getActivity().getIntent();
		isPerson = intent.getBooleanExtra(Run.EXTRA_DATA, false);
		mActionBar.setRightImageButton(R.drawable.recommend_mor, new OnClickListener() {

			@Override
			public void onClick(View v) {
				MyCommendPopupWindow morePopWindow = new MyCommendPopupWindow(mActivity);
				morePopWindow.showPopupWindow(v);
			}
		});
		mActionBar.setShowRightButton(isPerson);
		mId = intent.getStringExtra("id");
		wm = getActivity().getWindowManager();
		DisplayMetrics display = new DisplayMetrics();
		wm.getDefaultDisplay().getMetrics(display);
		width = display.widthPixels - Util.dip2px(mActivity, 10);
		imageWidth = width / 13;
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
	protected View getItemView(final JSONObject responseJson, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		if (convertView == null) {
			convertView = View.inflate(mActivity, R.layout.item_recommend_goods_comment, null);
		}
		ImageView nHeadIv = (ImageView) convertView.findViewById(R.id.iv_head);
		displayCircleImage(nHeadIv, responseJson.optString("avatar"));
		nHeadIv.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				startActivity(AgentActivity.intentForFragment(getActivity(), AgentActivity.FRAGMENT_RECOMMEND_HOME).putExtra(Run.EXTRA_VALUE, responseJson.optString("member_id")));

			}
		});

		((TextView) convertView.findViewById(R.id.tv_nikename)).setText(responseJson.optString("name"));
		((TextView) convertView.findViewById(R.id.textview_levels)).setText(responseJson.optString("member_lv_name"));
		((TextView) convertView.findViewById(R.id.tv_comtent)).setText(responseJson.optString("content"));
		((TextView) convertView.findViewById(R.id.tv_time)).setText(StringUtils.friendlyFormatLongStringTime(responseJson.optString("created")));
		return convertView;
	}

	@Override
	protected ContentValues extentConditions() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("opinions_id", mId);
		nContentValues.put("limit", String.valueOf(20));
		return nContentValues;
	}

	@Override
	protected String requestInterfaceName() {
		// TODO Auto-generated method stub
		return "mobileapi.goods.get_comment_list";
	}

	@Override
	protected void addHeader(XPullDownListView listView) {
		// TODO Auto-generated method stub
		View nHeaderView = View.inflate(mActivity, R.layout.header_recommend_goods_comment, null);
		listView.setEmptyView(null);
		listView.addHeaderView(nHeaderView);

		sImageView = (ImageView) findViewById(R.id.imgfilter);
		picture = (RelativeLayout) findViewById(R.id.picturess);
		picture.setDrawingCacheEnabled(true);
		mPhoto_album_title = (MTextView) findViewById(R.id.photo_album_title);
		mContentName=(TextView)findViewById(R.id.photo_album_name);
		mRatingNum = (TextView) findViewById(R.id.pingpai_rating_num);
		mRl_position = (RelativeLayout) findViewById(R.id.ll_position);
		mShare = (TextView) findViewById(R.id.textview_shareads);
		mLike = (TextView) findViewById(R.id.textview_likes);
		mImage = (ImageView) findViewById(R.id.textview_likes_image);

		getOptionsInfo();
	}

	@Override
	protected void initBottom(LinearLayout bottomLayout) {
		// TODO Auto-generated method stub
		View nBottomView = View.inflate(mActivity, R.layout.footer_recommend_goods_comment, null);
		bottomLayout.addView(nBottomView);
		if (mLoginedUser != null)
			mUserId = mLoginedUser.getMember().getMember_id();

		mEt_comment = (EditText) findViewById(R.id.et_comment);
		mSendBut = ((Button) findViewById(R.id.send));
		mSendBut.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				if (mUserId == null) {
					Run.alert(mActivity, "请登录");
					return;
				}
				if (mEt_comment.getText().toString().trim().equals("")) {
					Run.alert(mActivity, "请输入评论内容");
					return;
				}
				mSendBut.setEnabled(false);

				new GoodsAddOptionsCommentsInterface(RecommendGoodCommentFragment.this, mUserId, mId, mEt_comment.getText().toString()) {

					@Override
					public void SuccCallBack(JSONObject responseJson) {
						// TODO Auto-generated method stub
						mCommendNum++;
						mRatingNum.setText("共有" + mCommendNum + "条评论");
						mSendBut.setEnabled(true);
						Run.alert(getActivity(), "评论成功");
						JSONObject mCommendJson = new JSONObject();
						try {
							mCommendJson.put("member_id", mUserId);
							mCommendJson.put("name", mLoginedUser.getMember().getUname());
							mCommendJson.put("avatar", mLoginedUser.getAvatarUri());
							mCommendJson.put("content", mEt_comment.getText().toString());
							Date date = new Date(System.currentTimeMillis());
							SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							mCommendJson.put("created", sf.format(date));
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						mResultLists.add(mCommendJson);
						mAdapter.notifyDataSetChanged();
						mEt_comment.setText("");
						mListView.setSelection(mResultLists.size());
					}
				}.RunRequest();

			}
		});
	}

	private void initData(final JSONObject obj) {
		JSONObject objTag = obj.optJSONObject("tag");
		final String goodId = obj.optString("goods_id");
		if (objTag != null) {
			findViewById(R.id.rr_comm).setVisibility(View.VISIBLE);

			Iterator it = objTag.keys();
			List<String> keyListstr = new ArrayList<String>();
			while (it.hasNext()) {
				keyListstr.add(it.next().toString());
			}
			if (keyListstr.size() > 0) {
				objTag = objTag.optJSONObject(keyListstr.get(0));
				RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
				// float width =
				// Float.valueOf(wm.getDefaultDisplay().getWidth());
				float x = (float) (Float.valueOf(objTag.optString("x")) / 100.0);
				float y = (float) (Float.valueOf(objTag.optString("y")) / 100.0);
				int xx = (int) (width * x);
				int yy = (int) (width * y);
				params.topMargin = yy;
				params.leftMargin = xx;
				View view = View.inflate(mActivity, R.layout.picturetagview, null);
				TextView tvPictureTagLabel = (TextView) view.findViewById(R.id.tvPictureTagLabel);
				RelativeLayout rrTag = (RelativeLayout) view.findViewById(R.id.loTag);
				tvPictureTagLabel.setText(objTag.optString("image_tag"));
				if (objTag.optString("image_type").equals("1")) {
					rrTag.setBackgroundResource(R.drawable.bg_picturetagview_tagview_right);
				} else {
					rrTag.setBackgroundResource(R.drawable.bg_picturetagview_tagview_left);
				}
				mRl_position.addView(view, params);
				/**
				 * 跳转至商品详情
				 */
				rrTag.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View arg0) {

						Intent intent = AgentActivity.intentForFragment(getActivity(), AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_CLASS_ID, goodId);
						startActivity(intent);
					}
				});
			}

		}
		mCommendNum = obj.optInt("c_num");
		mRatingNum.setText("共有" + mCommendNum + "条评论");
		mContentName.setText(obj.optString("goods_name"));
		mPhoto_album_title.setMText( "[好物评价]" + obj.optString("content"));
		mLike.setText(obj.optString("p_num"));

		/**
		 * 点赞 1 已点赞 0未点赞
		 */
		if (obj.optString("is_praise").equals("0")) {
			mImage.setImageResource(R.drawable.my_msg_praise);
		} else {
			mImage.setImageResource(R.drawable.my_new_fans);
		}
		mShare.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				final ShareViewPopupWindow morePopWindow = new ShareViewPopupWindow(mActivity);
				final ShareViewDataSource dataSource = new ShareViewDataSource() {

					@Override
					public String getShareUrl() {
						return String.format(Run.RECOMMEND_URL, obj.optString("id"));
					}

					@Override
					public String getShareText() {
						try {
							return obj.getString("goods_name") + "-" + obj.getString("content");
						} catch (JSONException e) {
							e.printStackTrace();
						}
						return null;
					}

					@Override
					public String getShareImageUrl() {
						try {
							return obj.getString("image_url");
						} catch (JSONException e) {
							e.printStackTrace();
						}
						return null;
					}

					@Override
					public String getShareImageFile() {
						return CacheUtils.getImageCacheFile(obj.optString("image_url"));
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
		findViewById(R.id.ll_dianzan).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				try {
					if (mLoginedUser == null) {
						startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_COMM_LOGIN));
						return;
					}
					mUserId = mLoginedUser.getMember().getMember_id();
					if (mUserId == null || mUserId.equals("")) {
						startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_COMM_LOGIN));
						return;
					}
					if (obj.getString("is_praise").equals("0")) {
						new GoodsAddPraiseInterface(RecommendGoodCommentFragment.this, mUserId, mId) {

							@Override
							public void SuccCallBack(JSONObject responseJson) {
								// TODO Auto-generated method stub
								mImage.setImageResource(R.drawable.my_new_fans);
								int like = Integer.valueOf(mLike.getText().toString()) + 1;
								mLike.setText(like + "");
								try {
									obj.put("is_praise", "1");
								} catch (JSONException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
								Run.alert(mActivity, "点赞成功");
								getOptionsInfo();
							}
						}.RunRequest();

					} else {
						new GoodsDelPraiseInterface(RecommendGoodCommentFragment.this, mUserId, mId) {

							@Override
							public void SuccCallBack(JSONObject responseJson) {
								// TODO Auto-generated method stub
								mImage.setImageResource(R.drawable.my_msg_praise);
								int like = Integer.valueOf(mLike.getText().toString()) - 1;
								mLike.setText(like + "");
								try {
									obj.put("is_praise", like + "");
									obj.put("is_praise", "0");
								} catch (JSONException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
								Run.alert(mActivity, "已取消点赞");
								getOptionsInfo();
							}
						}.RunRequest();
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});

		if (null != obj.optString("image_url")) {
			displaySquareImage(sImageView, obj.optString("image_url"));
			if (obj.has("praise")) {
				mPraseArray = obj.optJSONArray("praise");
				if (mPraseArray != null && mPraseArray.length() > 0)
					initPrase(mPraseArray);

			}
		}
	}

	public void initPrase(JSONArray array) {
		mLinearLayout = (LinearLayout) findViewById(R.id.main_ll);
		mLinearLayout.removeAllViews();
		for (int i = 0; i < array.length(); i++) {
			JSONObject jsonParse = array.optJSONObject(i);
			if (i == array.length()) {
			} else {
				final View convertView = View.inflate(mActivity, R.layout.comment_personal_item, null);
				ImageView iv = (ImageView) convertView.findViewById(R.id.circle_imageview);
				LayoutParams params = new RelativeLayout.LayoutParams(imageWidth, imageWidth);
				iv.setLayoutParams(params);
				String header = jsonParse.optString("avatar");
				if ("".equals(header)) {
					iv.setImageResource(R.drawable.base_avatar_default);
				} else {
					displayCircleImage(iv, header);
				}
				convertView.setTag(jsonParse);
				convertView.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View arg0) {
						try {
							JSONObject obj = (JSONObject) arg0.getTag();
							String member_id = obj.getString("member_id");
							startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_HOME).putExtra(Run.EXTRA_VALUE, member_id));
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				});
				mLinearLayout.addView(convertView);
			}

		}
		if (array.length() == 10) {
			ImageView imageView = new ImageView(mActivity);
			LayoutParams params = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, imageWidth);
			imageView.setLayoutParams(params);
			imageView.setPadding(20, 10, 20, 10);
			imageView.setImageResource(R.drawable.base_arrow_right_pink_n);
			imageView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View arg0) {
					startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_RECOMMEND_PRAISE).putExtra("id", mId));
				}
			});
			mLinearLayout.addView(imageView);
		}
	}

	void getOptionsInfo() {
		new GoodsGetOptionsInfoInterface(this, mId) {

			@Override
			public void SuccCallBack(JSONObject responseJson) {
				// TODO Auto-generated method stub
				JSONObject dataJsonObject = responseJson.optJSONObject("data");
				goodsId = dataJsonObject.optString("goods_id");
				initData(dataJsonObject);
			}
		}.RunRequest();
	}
}
