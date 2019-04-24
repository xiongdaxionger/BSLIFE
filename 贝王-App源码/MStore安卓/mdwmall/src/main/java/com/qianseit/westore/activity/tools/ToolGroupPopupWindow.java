package com.qianseit.westore.activity.tools;

import java.util.ArrayList;
import java.util.List;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonMainActivity;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDoFragment;

public class ToolGroupPopupWindow extends PopupWindow {
	ListView mListView;
	List<ToolBtnBean> mBeans = new ArrayList<ToolGroupPopupWindow.ToolBtnBean>();
	ToolBtnBean mNewBean;

	Context mContext;

	LoginedUser mLoginedUser = LoginedUser.getInstance();

	BaseDoFragment mParentFragment;

	public ToolGroupPopupWindow(BaseDoFragment fragment) {
		// TODO Auto-generated constructor stub
		mBeans.add(mNewBean = new ToolBtnBean(ToolBtnBean.TOOL_BTN_NEW, "消息", R.drawable.tool_btn_new, mLoginedUser.isLogined() ? mLoginedUser.getMember().getUn_readMsg() : 0));
		mBeans.add(new ToolBtnBean(ToolBtnBean.TOOL_BTN_HOME, "首页", R.drawable.tool_btn_home));
		// mBeans.add(new ToolBtnBean(ToolBtnBean.TOOL_BTN_SERACH, "搜索",
		// R.drawable.tool_btn_search));
		mBeans.add(new ToolBtnBean(ToolBtnBean.TOOL_BTN_ATTENTION, "我的收藏", R.drawable.tool_btn_attention));
		mBeans.add(new ToolBtnBean(ToolBtnBean.TOOL_BTN_SPOOR, "我的足迹", R.drawable.tool_btn_spoor));

		mParentFragment = fragment;
		mContext = mParentFragment.mActivity;
		this.setContentView(initContentView(mParentFragment.mActivity));
		this.setWidth(Run.dip2px(mParentFragment.mActivity, 140));
		this.setHeight(LayoutParams.WRAP_CONTENT);
		this.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
		this.setTouchable(true);
		this.setFocusable(true);
		this.setOutsideTouchable(true);
		this.update();
	}

	public void setNews() {
		mNewBean.mNews = mLoginedUser.isLogined() ? mLoginedUser.getMember().getUn_readMsg() : 0;
		mAdapter.notifyDataSetChanged();
	}

	protected View initContentView(Context context) {
		// TODO Auto-generated method stub
		View nView = View.inflate(context, R.layout.popup_tool_group, null);
		mListView = (ListView) nView.findViewById(R.id.list);
		mListView.setAdapter(mAdapter);
		return nView;
	}

	/**
	 * 可以在popup显示前做一些预处理，如主画面半透明效果等
	 */
	protected void onBeforeShow() {
		mAdapter.notifyDataSetChanged();
	}

	QianseitAdapter<ToolBtnBean> mAdapter = new QianseitAdapter<ToolGroupPopupWindow.ToolBtnBean>(mBeans) {

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			if (convertView == null) {
				convertView = View.inflate(mContext, R.layout.item_tool_group, null);
				convertView.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						dismiss();
						onItemClicked(getItem((Integer) v.getTag()));
					}
				});
			}

			ToolBtnBean nBean = getItem(position);
			convertView.findViewById(R.id.has_unread).setVisibility(nBean.mNews > 0 ? View.VISIBLE : View.GONE);
			((ImageView) convertView.findViewById(R.id.tool_icon)).setImageResource(nBean.mIconRes);
			((TextView) convertView.findViewById(R.id.tool_name)).setText(nBean.mName);
			convertView.setTag(position);

			return convertView;
		}
	};

	public void onItemClicked(ToolBtnBean bean) {
		switch (bean.mId) {
		case ToolBtnBean.TOOL_BTN_ATTENTION:
			mParentFragment.startActivity(AgentActivity.FRAGMENT_GOODS_COLLECTION);
			break;
		case ToolBtnBean.TOOL_BTN_SPOOR:
			mParentFragment.startActivity(AgentActivity.FRAGMENT_GOODS_SPOOR);
			break;
		case ToolBtnBean.TOOL_BTN_SERACH:

			break;
		case ToolBtnBean.TOOL_BTN_NEW:
			mParentFragment.startNeedloginActivity(AgentActivity.FRAGMENT_NEWS_CENTER);
			break;
		case ToolBtnBean.TOOL_BTN_HOME:
			mParentFragment.startActivity(CommonMainActivity.GetMainTabActivity(mParentFragment.getContext()));
			break;

		default:
			break;
		}
	}

	@Override
	public void dismiss() {
		super.dismiss();
		onDismiss();
	}

	@Override
	public void showAtLocation(View parent, int gravity, int x, int y) {
		onBeforeShow();
		super.showAtLocation(parent, gravity, x, y);
	}

	@Override
	public void showAsDropDown(View anchor) {
		// TODO Auto-generated method stub
		onBeforeShow();
		super.showAsDropDown(anchor);
	}

	@Override
	public void showAsDropDown(View anchor, int xoff, int yoff) {
		// TODO Auto-generated method stub
		onBeforeShow();
		super.showAsDropDown(anchor, xoff, yoff);
	}

	@SuppressLint("NewApi")
	@Override
	public void showAsDropDown(View anchor, int xoff, int yoff, int gravity) {
		// TODO Auto-generated method stub
		onBeforeShow();
		super.showAsDropDown(anchor, xoff, yoff, gravity);
	}

	/**
	 * 可以在popup隐藏做一些预处理，如主画面取消半透明效果等
	 */
	protected void onDismiss() {
	}

	public static class ToolBtnBean {
		public final static int TOOL_BTN_NEW = 1;
		public final static int TOOL_BTN_HOME = 2;
		public final static int TOOL_BTN_SERACH = 3;
		public final static int TOOL_BTN_ATTENTION = 4;
		public final static int TOOL_BTN_SPOOR = 5;
		public int mId;
		public String mName;
		public int mIconRes;
		public int mNews = 0;

		public ToolBtnBean(int id, String name, int iconRes) {
			this(id, name, iconRes, 0);
		}

		public ToolBtnBean(int id, String name, int iconRes, int news) {
			mId = id;
			mName = name;
			mIconRes = iconRes;
			mNews = news;
		}
	}
}
