package com.qianseit.westore.activity.shopping;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonMainActivity;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.qianseit.westore.ui.pull.XListView;
import com.qianseit.westore.ui.pull.XListView.IXListViewListener;
import com.qianseit.westore.util.ChooseUtils;
import com.qianseit.westore.util.SelectsUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class ShoppingChooseFreagment extends BaseDoFragment implements IXListViewListener {
	private SelectsAdapter selectsAdapter;
	private int mPageNum=1;
	private LoginedUser mLoginedUser;
	private String mUserId;
	private ArrayList<ChooseUtils> mGoodsArray = new ArrayList<ChooseUtils>();
	private FragmentActivity context;
	private int imageWidth;
	private View mEmptyView;
	private XListView mListView;
	private RelativeLayout mEmptyViewRL;
	private boolean isLoadedAll = false;
	private int mPageSize = 10;
	private SelectsUtils mSharedSUtils;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setTitle(R.string.goods_shooseg);
		mActionBar.setShowHomeView(false);
		context = getActivity();
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);
		WindowManager wm = (WindowManager) mActivity.getSystemService(Context.WINDOW_SERVICE);
		DisplayMetrics dm = new DisplayMetrics();
		wm.getDefaultDisplay().getMetrics(dm);
		float width = Float.valueOf(dm.widthPixels);
		imageWidth = (int) ((width - Run.dip2px(mActivity, 15)) / 2);

	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		rootView = inflater.inflate(R.layout.gridview_new_fragment, null);

		mEmptyView = inflater.inflate(R.layout.item_choose_null,null);
		mListView = (XListView) findViewById(R.id.listView1);

		mEmptyView.findViewById(R.id.empty_view_goto_shop).setOnClickListener(this);
		selectsAdapter = new SelectsAdapter();
		mListView.setAdapter(selectsAdapter);
		mListView.setEmptyView(null);
		mListView.setXListViewListener(this);// 传入接口
		mListView.setPullLoadEnable(false);
		
	}

	@Override
	public void onResume() {
		super.onResume();
		if (!mLoginedUser.isLogined()) {
			// startActivityForResult(AgentActivity.intentForFragment(mActivity,
			// AgentActivity.FRAGMENT_ACCOUNT_LOGIN),
			// REQUEST_CODE_USER_LOGIN);
			getActivity().finish();
		} else
			inte(mPageNum, true);
	}

	private void inte(int pageNum, boolean isShow) {
		if (pageNum == 1) {
			mGoodsArray.clear();
			selectsAdapter.notifyDataSetChanged();
		}
		Run.excuteJsonTask(new JsonTask(), new SelectsListData(isShow));
	}

	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.empty_view_goto_shop) {
			startActivity(CommonMainActivity.GetMainTabActivity(mActivity));
		     mActivity.finish();
		} else {
			super.onClick(v);
		}
	}

	public class SelectsAdapter extends BaseAdapter {

		@Override
		public int getCount() {

			if (mGoodsArray.size() % 2 == 0) {
				return mGoodsArray.size() / 2;
			}

			return mGoodsArray.size() / 2 + 1;
		}

		@Override
		public ChooseUtils getItem(int position) {
			return mGoodsArray.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		class ViewHolder {
			ImageView imageview;
			TextView texttime;
			TextView textview;
			LinearLayout imageButton;
			Button imageCalcelButton;
			Button imageCalcelButton1;
			LinearLayout imageButton1;
			ImageView imageview1;
			TextView texttime1;
			TextView textview1;
			LinearLayout mLinearLayoutleft;
			LinearLayout mLinearLayoutright;
		}

		@Override
		public View getView(final int position, View converView, ViewGroup parent) {
			ViewHolder holder = null;
			if (converView == null) {
				converView = LayoutInflater.from(getActivity()).inflate(R.layout.gridview_item_pull, null);
				holder = new ViewHolder();
				holder.imageview = (ImageView) converView.findViewById(R.id.goods_detail_images);
				holder.texttime = (TextView) converView.findViewById(R.id.textview_times);
				holder.textview = (TextView) converView.findViewById(R.id.textview_titles);
				holder.imageButton = (LinearLayout) converView.findViewById(R.id.button_related);
				holder.imageCalcelButton = (Button) converView.findViewById(R.id.button_calcel_related);
				holder.imageview1 = (ImageView) converView.findViewById(R.id.goods_detail_images1);
				holder.texttime1 = (TextView) converView.findViewById(R.id.textview_times1);
				holder.textview1 = (TextView) converView.findViewById(R.id.textview_titles1);
				holder.imageButton1 = (LinearLayout) converView.findViewById(R.id.button_related1);
				holder.imageCalcelButton1 = (Button) converView.findViewById(R.id.button_calcel_related1);
				holder.mLinearLayoutleft = (LinearLayout) converView.findViewById(R.id.ll_left);
				holder.mLinearLayoutright = (LinearLayout) converView.findViewById(R.id.ll_left1);

				LayoutParams params = new LinearLayout.LayoutParams(imageWidth, imageWidth);
				holder.imageview.setLayoutParams(params);
				holder.imageview1.setLayoutParams(params);
				converView.setTag(holder);
			} else {
				holder = (ViewHolder) converView.getTag();
			}
			ChooseUtils chooseUtils1 = getItem(position * 2);
			displaySquareImage(holder.imageview, chooseUtils1.getImagePath());
			holder.textview.setText(chooseUtils1.getGoods_name());
			holder.texttime.setText(chooseUtils1.getSelectsTime());
			if (chooseUtils1.getIs_opinions().equals("0")) {
				holder.imageButton.setVisibility(View.VISIBLE);
				holder.imageCalcelButton.setVisibility(View.GONE);
				holder.imageButton.setTag(chooseUtils1);
				holder.imageButton.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View view) {
						Bundle bundle = new Bundle();
						bundle.putSerializable(context.getString(R.string.intent_key_serializable), (ChooseUtils) view.getTag());
						 Intent intent = AgentActivity.intentForFragment(
						 context, AgentActivity.FRAGMENT_RECOMMEND_PHOTO);
						 intent.putExtras(bundle);
						 context.startActivity(intent);

					}
				});
			} else {
				holder.imageButton.setVisibility(View.GONE);
				holder.imageCalcelButton.setVisibility(View.VISIBLE);
			}

			if ((position * 2 + 1) < mGoodsArray.size()) {
				holder.mLinearLayoutright.setVisibility(View.VISIBLE);
				ChooseUtils chooseUtils2 = getItem(position * 2 + 1);
				displaySquareImage(holder.imageview1, chooseUtils2.getImagePath());
				holder.textview1.setText(chooseUtils2.getGoods_name());
				holder.texttime1.setText(chooseUtils2.getSelectsTime());
				if (chooseUtils2.getIs_opinions().equals("0")) {
					holder.imageButton1.setVisibility(View.VISIBLE);
					holder.imageCalcelButton1.setVisibility(View.GONE);
					holder.imageButton1.setTag(chooseUtils2);
					holder.imageButton1.setOnClickListener(new OnClickListener() {
						@Override
						public void onClick(View view) {
							Bundle bundle = new Bundle();
							bundle.putSerializable(context.getString(R.string.intent_key_serializable), (ChooseUtils) view.getTag());
							 Intent intent =
							 AgentActivity.intentForFragment(
							 context,
							 AgentActivity.FRAGMENT_RECOMMEND_PHOTO);
							 intent.putExtras(bundle);
							 context.startActivity(intent);
						}
					});
				} else {
					holder.imageCalcelButton1.setVisibility(View.VISIBLE);
					holder.imageButton1.setVisibility(View.GONE);
				}
			} else {
				holder.mLinearLayoutright.setVisibility(View.INVISIBLE);
			}

			return converView;
		}

	}

	private class SelectsListData implements JsonTaskHandler {
		private JSONObject data;
		private int newQuantity = 1;
		private boolean isShow;

		public SelectsListData(boolean isShow) {
			this.isShow = isShow;
		}

		/*
		 * (non-Javadoc)
		 * 
		 * @see
		 * com.qianseit.westore.http.JsonTaskHandler#task_response(java.lang
		 * .String)
		 */
		@Override
		public void task_response(String json_str) {
			hideLoadingDialog();
			JSONObject dataJson;
			try {
				dataJson = new JSONObject(json_str);
				if (Run.checkRequestJson(mActivity, dataJson, false)) {
					JSONArray dataJsonArray = dataJson.getJSONArray("data");
					if (dataJsonArray == null || dataJsonArray.length() <= 0) {
						isLoadedAll = true;
						return;
					} else {
						isLoadedAll = dataJson.length() < mPageSize;
					}
					if (dataJsonArray.length() > 0) {
						for (int i = 0; i < dataJsonArray.length(); i++) {
							ChooseUtils chooseUtil = new ChooseUtils();
							JSONObject selectsInfoAObject = dataJsonArray.getJSONObject(i);

							String order_ids = selectsInfoAObject.getString("order_id");
							chooseUtil.setOrder_id(order_ids);
							String goods_id = selectsInfoAObject.getString("goods_id");
							chooseUtil.setGoods_id(goods_id);
							String goods_name = selectsInfoAObject.getString("goods_name");
							chooseUtil.setGoods_name(goods_name);
							String brand_name = selectsInfoAObject.getString("brand_name");
							chooseUtil.setBrand_name(brand_name);
							String createtime = selectsInfoAObject.getString("createtime");
							chooseUtil.setSelectsTime(createtime);
							String image = selectsInfoAObject.getString("image");
							chooseUtil.setImagePath(image);
							String is_opinions = selectsInfoAObject.getString("is_opinions");
							chooseUtil.setIs_opinions(is_opinions);
							String is_comment = selectsInfoAObject.getString("is_comment");
							chooseUtil.setIs_comment(is_comment);

							mGoodsArray.add(chooseUtil);
						}
					}

				}

			} catch (JSONException e) {
				isLoadedAll=true;
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
					((ViewGroup)mListView.getParent()).addView(mEmptyView);  
					mListView.setEmptyView(mEmptyView);
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
			JsonRequestBean jrbean = new JsonRequestBean(Run.API_URL, "mobileapi.goods.get_goods_for_order");
			jrbean.addParams("goods_id", "unopinions");
			jrbean.addParams("page", String.valueOf(mPageNum));
			jrbean.addParams("page_size",String.valueOf( mPageSize));
			return jrbean;
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
}
