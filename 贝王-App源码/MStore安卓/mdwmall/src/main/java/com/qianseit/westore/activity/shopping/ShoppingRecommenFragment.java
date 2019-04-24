package com.qianseit.westore.activity.shopping;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.text.Html;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.acco.AccoPointsFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.qianseit.westore.ui.CircleImageView;
import com.qianseit.westore.ui.MTextView;
import com.qianseit.westore.ui.ShareView;
import com.qianseit.westore.ui.ShareView.ShareViewDataSource;
import com.qianseit.westore.ui.ShareViewPopupWindow;
import com.qianseit.westore.ui.pull.XListView;
import com.qianseit.westore.ui.pull.XListView.IXListViewListener;
import com.qianseit.westore.util.CacheUtils;
import com.qianseit.westore.util.SelectsUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * 人气
 * 
 * @author Administrator
 * 
 */
@SuppressLint("NewApi")
public class ShoppingRecommenFragment extends BaseDoFragment implements IXListViewListener,ShareViewDataSource {
	private SelectsAdapter selectsAdapter;
	private int mPageNum = 1;
	private LoginedUser mLoginedUser;
	private String mUserId;
	private ArrayList<SelectsUtils> mGoodsArray = new ArrayList<SelectsUtils>();
	private FragmentActivity mContext;

	public ShoppingRecommenFragment() {
	}

	ShareViewPopupWindow mSharedPopWindow;
	private ShareView mSharedView;
	private XListView mListView;
	private RelativeLayout mEmptyViewRL;
	private boolean isLoadedAll = false;
	private int mPageSize = 5;
	private SelectsUtils mSharedSUtils;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		mContext = getActivity();
		rootView = inflater.inflate(R.layout.fragment_shopp_recom, container, false);

		mListView = (XListView) findViewById(R.id.listView1);
		mEmptyViewRL = (RelativeLayout) findViewById(R.id.search_error_rl);
		((TextView) mEmptyViewRL.getChildAt(0)).setText("暂无数据");
		
		mSharedPopWindow = new ShareViewPopupWindow(mActivity);
		mSharedPopWindow.setDataSource(this);
		mSharedPopWindow.setTwoCodeVisibility(false);
		mSharedPopWindow.setSmsVisibility(false);
//		mSharedView = (ShareView) findViewById(R.id.share_view);
//		mSharedView.setTwoCodeVisibility(false);
//		mSharedView.setSmsVisibility(false);

		mLoginedUser = AgentApplication.getLoginedUser(getActivity());
		mUserId = mLoginedUser.getMember().getMember_id();
		selectsAdapter = new SelectsAdapter(getActivity(), mGoodsArray, R.layout.item_new_listview);
		mListView.setAdapter(selectsAdapter);
		WindowManager wm = (WindowManager) getActivity().getSystemService(Context.WINDOW_SERVICE);
		width = wm.getDefaultDisplay().getWidth();

		mListView.setEmptyView(null);
		mListView.setXListViewListener(this);// 传入接口
		mListView.setPullLoadEnable(false);
		inte(mPageNum, true);
		return rootView;
	}

	private int width;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

	}

	private void inte(int pageNum, boolean isShow) {

		if (pageNum == 1) {
			mGoodsArray.clear();
			selectsAdapter.notifyDataSetChanged();
		}
		Run.excuteJsonTask(new JsonTask(), new ReletedListData(isShow));
	}

	@Override
	public void onResume() {
		super.onResume();

	}

	@Override
	public void onPause() {
		super.onPause();
	}

	/**
	 * 最后一次从服务器上获取的数据长度，如果为5则可以加载下一页。
	 */
	private int mDataLength = 5;

	private class ReletedListData implements JsonTaskHandler {
		private JSONObject data;
		private int newQuantity = 1;
		private boolean isShow;

		public ReletedListData(boolean isShow) {
			this.isShow = isShow;
		}

		@Override
		public void task_response(String json_str) {
			hideLoadingDialog_mt();
			JSONObject dataJson;
			try {
				dataJson = new JSONObject(json_str);
				if (Run.checkRequestJson(mActivity, dataJson)) {
					JSONArray dataJsonArray = dataJson.getJSONArray("data");
					if (dataJsonArray == null) {
						isLoadedAll = true;
						return;
					}
					isLoadedAll = dataJsonArray.length() < mPageSize;
					mDataLength = dataJsonArray.length();
					for (int i = 0; i < dataJsonArray.length(); i++) {
						SelectsUtils selectsUtils = new SelectsUtils();
						JSONObject selectsInfoAObject = dataJsonArray.getJSONObject(i);
						String id = selectsInfoAObject.getString("id");

						JSONObject objTag = selectsInfoAObject.getJSONObject("tag");
						if (objTag != null) {
							Iterator it = objTag.keys();
							List<String> keyListstr = new ArrayList<String>();
							while (it.hasNext()) {
								keyListstr.add(it.next().toString());
							}
							if (keyListstr.size() > 0) {
								selectsUtils.setHasTag(true);
								objTag = objTag.getJSONObject(keyListstr.get(0));
								selectsUtils.setImage_type(objTag.getString("image_type"));
								selectsUtils.setY(objTag.getString("y"));
								selectsUtils.setImage_tag(objTag.getString("image_tag"));
								selectsUtils.setX(objTag.getString("x"));
							} else {
								selectsUtils.setHasTag(false);
							}
						} else {
							selectsUtils.setHasTag(false);
						}

						selectsUtils.setId(id);
						String member_id = selectsInfoAObject.getString("member_id"); // 用户id
						selectsUtils.setMember_id(member_id);
						// 解析用户头像
						String head = selectsInfoAObject.getString("avatar");
						selectsUtils.setImg_brand(head);
						// 解析用户名称
						String nick = selectsInfoAObject.getString("name");
						selectsUtils.setTextview_name(nick);
						// 解析发表时间
						String time = selectsInfoAObject.getString("created");
						selectsUtils.setsTime(time);
						// 解析用户等级
						String member = selectsInfoAObject.getString("member_lv_name");
						selectsUtils.setTextview_level(member);
						// 是否关注
						String sGuanzhu = selectsInfoAObject.getString("is_attention");
						selectsUtils.setButton_related(sGuanzhu);
						// 内容图片
						String image = selectsInfoAObject.getString("image_url");
						selectsUtils.setGoods_detail_images(image);
						// 内容标题
						String goodsName = selectsInfoAObject.getString("goods_name");
						selectsUtils.setTextview_title(goodsName);
						// 内容
						String contentn = selectsInfoAObject.getString("content");
						selectsUtils.setTextview_content(contentn);
						// 评论数量
						String num = selectsInfoAObject.getString("c_num");
						selectsUtils.setTextview_comments(num);
						// 点赞数量
						String p_num = selectsInfoAObject.getString("p_num");
						selectsUtils.setP_num(p_num);
						// 是否点赞is_praise
						String is_praise = selectsInfoAObject.getString("is_praise");
						selectsUtils.setIs_praise(is_praise);
						selectsUtils.setGoodsId(selectsInfoAObject.getString("goods_id"));
						mGoodsArray.add(selectsUtils);
					}
				}
			} catch (JSONException e) {
				isLoadedAll = true;
				e.printStackTrace();
			} finally {
				if (isLoadedAll) {
					mListView.setPullLoadEnable(false);
				} else {
					mListView.setPullLoadEnable(true);
				}
				if(mGoodsArray.size()>0){
					mListView.setEmptyView(null);
				}else{
					mListView.setEmptyView(mEmptyViewRL);
				}
				mListView.stopRefresh();
				mListView.stopLoadMore();
				selectsAdapter.notifyDataSetChanged();
			}

		}

		@Override
		public JsonRequestBean task_request() {
			if (isShow)
				showCancelableLoadingDialog();
			JsonRequestBean jb = new JsonRequestBean(Run.API_URL, "mobileapi.goods.getopinionslist");
			jb.addParams("page", String.valueOf(mPageNum));
			jb.addParams("type", "praise");
			jb.addParams("page_size", String.valueOf(mPageSize));
			return jb;
		}
	}

	public class SelectsAdapter extends BaseAdapter {

		private Activity context;
		private List<SelectsUtils> selectslistdata;
		private int itemKoubeiRecommentHead;
		private LayoutInflater iLayoutInflater;// 动态布局加载器

		public SelectsAdapter(Activity context, List<SelectsUtils> selectslistdata, int itemKoubeiRecommentHead) {
			this.context = context;
			this.selectslistdata = selectslistdata;
			this.itemKoubeiRecommentHead = itemKoubeiRecommentHead;
			iLayoutInflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		}

		@Override
		public int getCount() {
			return selectslistdata.size();
		}

		public void addData(List<SelectsUtils> goodsArray) {
			if (goodsArray == null)
				return;
			for (int i = 0; i < goodsArray.size(); i++) {
				this.selectslistdata.add(goodsArray.get(i));
			}
			context.runOnUiThread(new Runnable() {

				@Override
				public void run() {
					notifyDataSetChanged();
				}
			});
		}

		@Override
		public Object getItem(int position) {
			return selectslistdata.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		class ViewHolder {
			CircleImageView img_brand; // 头像
			TextView textview_like; // 喜欢
			TextView textview_comments; // 评论
			TextView textview_time; // 日期
			TextView textview_content; // 详细内容
			TextView textview_title; // 内容标题
			ImageView goods_detail_images; // 详情图片
			TextView button_related; // 关注图标
			// TextView textview_sTime=null; //发布日期
			TextView textview_name; // 用户名
			TextView textview_level; // 等级
			ImageView textview_likes_image;
		}

		// ViewHolder hodler;

		@Override
		public View getView(final int position, View converView, ViewGroup parent) {
			CircleImageView img_brand; // 头像
			final TextView textview_like; // 喜欢
			TextView textview_comments; // 评论
			TextView textview_time; // 日期
			MTextView textview_content; // 详细内容
			TextView textview_title; // 内容标题
			ImageView goods_detail_images; // 详情图片
			final TextView button_related; // 关注图标
			// TextView textview_sTime=null; //发布日期
			TextView textview_name; // 用户名
			TextView textview_level; // 等级
			final ImageView textview_likes_image;

			// if(converView == null){
			// hodler = new ViewHolder();
			converView = iLayoutInflater.inflate(itemKoubeiRecommentHead, null, false);
			// 初始化listview的每一项的布局文件中的组件
			goods_detail_images = (ImageView) converView.findViewById(R.id.imgfilter); // 详情图片
			img_brand = (CircleImageView) converView.findViewById(R.id.img_brand_logos); // 头像
			textview_name = (TextView) converView.findViewById(R.id.textview_names); // 用户名
			textview_level = (TextView) converView.findViewById(R.id.textview_levels); // 等级
			button_related = (TextView) converView.findViewById(R.id.button_relateds); // 关注图标
			textview_title = (TextView) converView.findViewById(R.id.textview_titles); // 内容标题
			textview_content = (MTextView) converView.findViewById(R.id.textview_contents); // 详情内容
			textview_time = (TextView) converView.findViewById(R.id.textview_times); // 日期
			textview_comments = (TextView) converView.findViewById(R.id.textview_commentss); // 评论
			textview_like = (TextView) converView.findViewById(R.id.textview_likes); // 喜欢

			textview_likes_image = (ImageView) converView.findViewById(R.id.textview_likes_image); // 是否点赞

			// WindowManager wm = (WindowManager) getActivity()
			// .getSystemService(Context.WINDOW_SERVICE);
			// width = wm.getDefaultDisplay().getWidth() - Util.dip2px(mContext,
			// 10);
			// converView.setTag(hodler);
			// } else {
			// hodler = (ViewHolder) converView.getTag();
			// }
			// relaylayout=(RelativeLayout)converView.findViewById(R.id.photo_topss);
			// 封装listview的每一项的布局文件中的组件

			textview_level.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					getActivity().startActivity(AgentActivity.intentForFragment(getActivity(), AgentActivity.FRAGMENT_ACCO_POINTS).putExtra(Run.EXTRA_DETAIL_TYPE, AccoPointsFragment.POINTS_RULE));
				}
			});

			final SelectsUtils selectInfo = selectslistdata.get(position);
			final TextView textview_sharead = (TextView) converView.findViewById(R.id.textview_shareads); // 分享
			final RelativeLayout ll_position = (RelativeLayout) converView.findViewById(R.id.ll_position);
			LayoutParams layoutParams = (LayoutParams) ll_position.getLayoutParams();
			layoutParams.height = width;
			RelativeLayout picturesView = (RelativeLayout) converView.findViewById(R.id.picturess);
			LinearLayout.LayoutParams layoutParams1 = (LinearLayout.LayoutParams) picturesView.getLayoutParams();
			layoutParams1.height = width;
			displaySquareImage(img_brand, selectInfo.getImg_brand());
			displaySquareImage(goods_detail_images, selectInfo.getGoods_detail_images());
			textview_name.setText(selectInfo.getTextview_name());
			String content=selectInfo.getTextview_content();
			textview_content.setText(content);
			String title=selectInfo.getTextview_title();
			textview_title.setText(title);
			if (ll_position.getChildCount() < 2)
				if (selectInfo.isHasTag()) {
					RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
					// WindowManager wm = (WindowManager) getActivity()
					// .getSystemService(Context.WINDOW_SERVICE);
					// float width =
					// Float.valueOf(wm.getDefaultDisplay().getWidth());
					float x = (float) (Float.valueOf(selectInfo.getX()) / 100.0);
					float y = (float) (Float.valueOf(selectInfo.getY()) / 100.0);
					int xx = (int) (width * x);
					int yy = (int) (width * y);
					params.topMargin = yy;
					params.leftMargin = xx;
					final View view = LayoutInflater.from(context).inflate(R.layout.picturetagview, null, true);
					// ll_position.removeAllViews();
					TextView tvPictureTagLabel = (TextView) view.findViewById(R.id.tvPictureTagLabel);
					RelativeLayout rrTag = (RelativeLayout) view.findViewById(R.id.loTag);
					tvPictureTagLabel.setText(selectInfo.getImage_tag());
					if (selectInfo.getImage_type().equals("1")) {
						rrTag.setBackgroundResource(R.drawable.bg_picturetagview_tagview_right);
					} else {
						rrTag.setBackgroundResource(R.drawable.bg_picturetagview_tagview_left);
					}
					ll_position.addView(view, params);
					rrTag.setOnClickListener(new OnClickListener() {

						@Override
						public void onClick(View v) {

							Intent intent = AgentActivity.intentForFragment(getActivity(), AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_CLASS_ID, selectInfo.getGoodsId());
							startActivity(intent);

						}
					});

				}

			/** 分享 */
			textview_sharead.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View arg0) {

					mSharedSUtils = selectInfo;
					mSharedPopWindow.showAtLocation(rootView, android.view.Gravity.BOTTOM, 0, 0);
				}
			});

			displaySquareImage(img_brand, selectInfo.getImg_brand());
			displaySquareImage(goods_detail_images, selectInfo.getGoods_detail_images());
			textview_name.setText(selectInfo.getTextview_name());
			textview_content.setText(selectInfo.getTextview_content());
			textview_title.setText(selectInfo.getTextview_title());

			Log.i("tentinet-->", "" + selectInfo.getButton_related());
			if (selectInfo.getButton_related().equals("0")) {
				// button_related.setBackgroundResource(R.drawable.bg_account_button);
				// button_related.setTextColor(Color.RED);
				// button_related.setText("+关注");
				button_related.setBackgroundResource(R.drawable.icon_add_guanzhu);
			} else {
				button_related.setBackgroundResource(R.drawable.bg_semicircle_selector);
				button_related.setTextColor(Color.WHITE);
				button_related.setText("已关注");
			}
			textview_content.setMText(Html.fromHtml("<font size=\"4\" color=\"red\">[好物评价]</font><font size=\"4\" color=\"#9b9b9b\"></font>" + selectInfo.getTextview_content()));
			textview_time.setText(selectInfo.getsTime());
			String pinglun = "评论(" + selectInfo.getTextview_comments() + ")";
			textview_comments.setText(pinglun);
			textview_like.setText(selectInfo.getP_num());
			textview_level.setVisibility(View.VISIBLE);
			if (!selectInfo.getTextview_level().equals("null"))
				textview_level.setText( selectInfo.getTextview_level());

			/**
			 * 点赞 1 已点赞 0未点赞
			 */
			if (selectInfo.getIs_praise().equals("0")) {
				textview_likes_image.setImageResource(R.drawable.my_msg_praise);
			} else {
				textview_likes_image.setImageResource(R.drawable.my_new_fans);
			}
			textview_likes_image.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					LoginedUser mLoginedUser = AgentApplication.getLoginedUser(mContext);
					if (mLoginedUser == null) {
						startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_COMM_LOGIN));
						return;
					}
					mUserId = mLoginedUser.getMember().getMember_id();
					if (mUserId == null || mUserId.equals("")) {
						startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_COMM_LOGIN));
						return;
					}
					if (selectInfo.getIs_praise().equals("0")) {
						Run.excuteJsonTask(new JsonTask(), new AddPraiseTask(mUserId, selectInfo.getId()));
						textview_likes_image.setImageResource(R.drawable.my_new_fans);
						int like = Integer.valueOf(textview_like.getText().toString()) + 1;
						textview_likes_image.setClickable(false);
						textview_like.setText(like + "");
						selectInfo.setIs_praise("1");
						selectInfo.setP_num(like + "");
						selectslistdata.remove(position);
						selectslistdata.add(position, selectInfo);
						textview_likes_image.setClickable(true);
					} else {
						Run.excuteJsonTask(new JsonTask(), new CalcelPraiseTask(mUserId, selectInfo.getId()));
						textview_likes_image.setImageResource(R.drawable.my_msg_praise);
						selectInfo.setIs_praise("0");
						int like = Integer.valueOf(textview_like.getText().toString()) - 1;
						textview_likes_image.setClickable(false);
						textview_like.setText(like + "");
						selectInfo.setP_num(like + "");
						selectslistdata.remove(position);
						selectslistdata.add(position, selectInfo);
						textview_likes_image.setClickable(true);
					}
				}
			});
			img_brand.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {

					startActivity(AgentActivity.intentForFragment(getActivity(), AgentActivity.FRAGMENT_RECOMMEND_HOME).putExtra(Run.EXTRA_VALUE, selectInfo.getMember_id()));
				}
			});

			textview_name.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {

					startActivity(AgentActivity.intentForFragment(getActivity(), AgentActivity.FRAGMENT_RECOMMEND_HOME).putExtra(Run.EXTRA_VALUE, selectInfo.getMember_id()));
				}
			});

			/**
			 * 取消添加关注
			 */
			button_related.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View arg0) {
					LoginedUser mLoginedUser = AgentApplication.getLoginedUser(mContext);
					if (mLoginedUser == null) {
						startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_COMM_LOGIN));
						return;
					}
					mUserId = mLoginedUser.getMember().getMember_id();
					if (mUserId == null || mUserId.equals("")) {
						startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_COMM_LOGIN));
						return;
					}
					if (selectInfo.getButton_related().equals("0")) {
						Run.excuteJsonTask(new JsonTask(), new AddAttentionTask(selectInfo.getMember_id(), mUserId));
						button_related.setBackgroundResource(R.drawable.bg_follow);
						button_related.setTextColor(Color.WHITE);
						button_related.setText("已关注");
						button_related.setClickable(false);
						selectInfo.setButton_related("1");
						selectslistdata.remove(position);
						selectslistdata.add(position, selectInfo);
						button_related.setClickable(true);
					} else {
						Run.excuteJsonTask(new JsonTask(), new CalcelAttentionTaskTask(selectInfo.getMember_id(), mUserId));
						button_related.setBackgroundResource(R.drawable.bg_account_button);
						button_related.setTextColor(Color.RED);
						button_related.setText("+关注");
						button_related.setClickable(false);
						selectInfo.setButton_related("0");
						selectslistdata.remove(position);
						selectslistdata.add(position, selectInfo);
						button_related.setClickable(true);
					}
				}
			});
			/**
			 * 推荐详情
			 */
			goods_detail_images.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View arg0) {
					context.startActivity(AgentActivity.intentForFragment(context, AgentActivity.FRAGMENT_RECOMMEND_GOODS_COMMENT).putExtra("id", selectInfo.getId()));
				}
			});
			/**
			 * 评论
			 */
			textview_comments.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View arg0) {
					context.startActivity(AgentActivity.intentForFragment(context, AgentActivity.FRAGMENT_RECOMMEND_GOODS_COMMENT).putExtra("id", selectInfo.getId()));
				}
			});
			/**
			 * 跳转个人资料
			 */
			img_brand.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View arg0) {
					startActivity(AgentActivity.intentForFragment(getActivity(), AgentActivity.FRAGMENT_RECOMMEND_HOME).putExtra(Run.EXTRA_VALUE, selectInfo.getMember_id()));
				}
			});
			return converView;
		}

		/**
		 * 点赞
		 * 
		 * @author Administrator
		 * 
		 */
		private class AddPraiseTask implements JsonTaskHandler {
			private String meber_Id;
			private String opinions_Id;// 商品推荐id

			public AddPraiseTask(String meberId, String opinions_Id) {
				this.meber_Id = meberId;
				this.opinions_Id = opinions_Id;
			}

			@Override
			public JsonRequestBean task_request() {
				JsonRequestBean bean = new JsonRequestBean(Run.API_URL, "mobileapi.goods.add_opinions_praise");
				bean.addParams("member_id", meber_Id);
				bean.addParams("opinions_id", opinions_Id);
				return bean;
			}

			@Override
			public void task_response(String json_str) {
				try {
					JSONObject all = new JSONObject(json_str);
					if (Run.checkRequestJson(context, all)) {
						// Run.alert(mActivity,"点赞成功");
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		/**
		 * 取消点赞
		 * 
		 * @author Administrator
		 * 
		 */
		private class CalcelPraiseTask implements JsonTaskHandler {
			private String meber_Id;
			private String opinions_Id;// 商品推荐id

			public CalcelPraiseTask(String meberId, String opinions_Id) {
				this.meber_Id = meberId;
				this.opinions_Id = opinions_Id;
			}

			@Override
			public JsonRequestBean task_request() {
				JsonRequestBean bean = new JsonRequestBean(Run.API_URL, "mobileapi.goods.del_opinions_praise");
				bean.addParams("opinions_id", opinions_Id);
				return bean;
			}

			@Override
			public void task_response(String json_str) {
				try {
					JSONObject all = new JSONObject(json_str);
					if (Run.checkRequestJson(context, all)) {
						// Run.alert(mActivity,"已取消点赞");
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		private class AddAttentionTask implements JsonTaskHandler {
			private String meberId;
			private String fansId;

			public AddAttentionTask(String meberId, String fansId) {
				this.meberId = meberId;
				this.fansId = fansId;
			}

			@Override
			public JsonRequestBean task_request() {
				JsonRequestBean bean = new JsonRequestBean(Run.API_URL, "mobileapi.member.attention");
				bean.addParams("member_id", meberId);
				bean.addParams("fans_id", fansId);
				return bean;
			}

			@Override
			public void task_response(String json_str) {
				try {
					JSONObject all = new JSONObject(json_str);
					if (Run.checkRequestJson(context, all)) {
						String data = all.getString("data");
						if (data.equals("请重新登录")) {
							Run.alert(mActivity, "请重新登录");
						} else {
							// Toast.makeText(context, "关注成功", 5000).show();
							selectsAdapter.notifyDataSetChanged();
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		private class CalcelAttentionTaskTask implements JsonTaskHandler {
			private String meberId;
			private String fansId;

			public CalcelAttentionTaskTask(String meberId, String fansId) {
				this.meberId = meberId;
				this.fansId = fansId;
			}

			@Override
			public JsonRequestBean task_request() {
				JsonRequestBean bean = new JsonRequestBean(Run.API_URL, "mobileapi.member.un_attention");
				bean.addParams("member_id", meberId);
				bean.addParams("fans_id", fansId);
				return bean;
			}

			@Override
			public void task_response(String json_str) {
				try {
					JSONObject all = new JSONObject(json_str);
					if (Run.checkRequestJson(context, all)) {
						String data = all.getString("data");
						if (data.equals("请重新登录")) {
							Run.alert(mActivity, "请重新登录");
						} else {
							// Toast.makeText(context, "已取消关注", 5000).show();
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		public class SelectsWrapper {
			CircleImageView img_brand; // 头像
			TextView textview_sharead; // 分享
			TextView textview_like; // 喜欢
			TextView textview_comments; // 评论
			TextView textview_time; // 日期
			TextView textview_content; // 详细内容
			TextView textview_title; // 内容标题
			ImageView goods_detail_images; // 详情图片
			TextView button_related; // 关注图标
			TextView textview_name; // 用户名
			TextView textview_level; // 等级
			ImageView textview_likes_image; // 详情图片

			public SelectsWrapper(CircleImageView img_brand, TextView textview_like, TextView textview_comments, TextView textview_time, TextView textview_content,
					TextView textview_title, ImageView goods_detail_images, TextView button_related, TextView textview_name, TextView textview_level,
					ImageView textview_likes_image) {
				this.img_brand = img_brand;
				this.textview_sharead = textview_sharead;
				this.textview_like = textview_like;
				this.textview_comments = textview_comments;
				this.textview_time = textview_time;
				this.textview_content = textview_content;
				this.textview_title = textview_title;
				this.goods_detail_images = goods_detail_images;
				this.button_related = button_related;
				this.textview_name = textview_name;
				this.textview_level = textview_level;
				this.textview_likes_image = textview_likes_image;
			}
		}

	}

	@Override
	public void onRefresh() {
		mListView.setPullLoadEnable(false);
		mPageNum = 1;
		mGoodsArray.clear();
		selectsAdapter.notifyDataSetChanged();
		inte(mPageNum, false);

	}

	@Override
	public void onLoadMore() {
		mPageNum++;
		inte(mPageNum, false);

	}

	@Override
	public String getShareText() {
		return mSharedSUtils.getTextview_title()+"-"+mSharedSUtils.getTextview_content();
	}

	@Override
	public String getShareImageFile() {
		return CacheUtils.getImageCacheFile(getShareImageUrl());
	}

	@Override
	public String getShareImageUrl() {
		return mSharedSUtils.getGoods_detail_images();
	}

	@Override
	public String getShareUrl() {
		return String.format(Run.RECOMMEND_URL,mSharedSUtils.getId());
	}

	@Override
	public String getShareMessage() {
		return null;
	}

}
