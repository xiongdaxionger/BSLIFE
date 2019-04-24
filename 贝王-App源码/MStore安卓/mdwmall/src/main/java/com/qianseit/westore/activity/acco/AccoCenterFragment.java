package com.qianseit.westore.activity.acco;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.beiwangfx.R;;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.goods.GoodsUtil;
import com.qianseit.westore.activity.order.OrderFragment;
import com.qianseit.westore.activity.order.OrderSegementFragment;
import com.qianseit.westore.adapter.QianseitAdapter;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.bean.member.Member;
import com.qianseit.westore.httpinterface.member.MemberIndexInterface;
import com.qianseit.westore.httpinterface.member.MemberSecurityInterface;
import com.qianseit.westore.ui.BadgeView;

import java.util.ArrayList;
import java.util.List;

public class AccoCenterFragment extends BaseDoFragment {
	final static int MENU_COLLECTION = 1;
	final static int MENU_SPOOR = 2;
	final static int MENU_PRESELL_ORDER = 3;
	final static int MENU_ARFTERMARKET = 4;
	final static int MENU_COUPON_CENTER = 5;
	final static int MENU_ACTIVITY = 6;
	final static int MENU_ADDR = 7;
	final static int MENU_SERVICE = 8;
	final static int MENU_JOIN_IN = 11; ///合伙人加盟
	final static int MENU_PARTNER = 12; ///我的会员
	final static int MENU_COLLECT_MONEY = 13; ///收钱
	final static int MENU_STATISTICAL = 14; ///统计
	final static int MENU_ACCESS = 15; ///存取记录

	TextView mNickNameTextView;
	ImageView mAvatarImageView;
	TextView mHanderLvTextView;

	View hasNewsView;

	Member mMember = null;

	boolean isBindedMobile = false;
	boolean isFirst = true;

	BadgeView mPayBadgeView, mReceiptBadgeView, mDeliveryBadgeView, mRecommentBadgeView;
	TextView mPayTextView, mReceiptTextView, mDeliveryTextView, mRecommentTextView;
	TextView mDepositTextView, mScoreTextView, mCouponTextView, mIncomeTextView;

	ListView mModelListView;
	List<ModelBean> mModelBeans = new ArrayList<ModelBean>();

	int mModelImageWidth = 0;

	QianseitAdapter<ModelBean> mModelAdapter = new QianseitAdapter<ModelBean>(mModelBeans) {

		@Override
		public View getView(int arg0, View arg1, ViewGroup arg2) {
			// TODO Auto-generated method stub
			if (arg1 == null) {
				arg1 = View.inflate(mActivity, R.layout.item_acco_model, null);
				arg1.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View arg0) {
						// TODO Auto-generated method stub
						if (arg0 == null) {
							return;
						}
						Object nObject = arg0.getTag();
						if (nObject == null || !(nObject instanceof Integer)) {
							return;
						}
						onModelClick((Integer) arg0.getTag());
					}
				});
			}

			int nStar = arg0 * 4;
			assignmentChildItem(getItem(nStar), arg1.findViewById(R.id.model1));
			assignmentChildItem(getItem(nStar + 1), arg1.findViewById(R.id.model2));
			assignmentChildItem(getItem(nStar + 2), arg1.findViewById(R.id.model3));
			assignmentChildItem(getItem(nStar + 3), arg1.findViewById(R.id.model4));
			arg1.findViewById(R.id.divider).setVisibility(arg0 < getCount() - 1 ? View.VISIBLE : View.GONE);

			return arg1;
		}

		@Override
		public int getCount() {
			return (int) Math.ceil(mDataList.size() / 4.0);
		}

		@Override
		public ModelBean getItem(int position) {
			if (position < mDataList.size()) {
				return mDataList.get(position);
			}
			return null;
		}

		void assignmentChildItem(ModelBean item, View itemView) {
			ImageView nImageView = (ImageView) itemView.findViewById(R.id.gridview_icon);
			setViewAbsoluteHeight(itemView.findViewById(R.id.gridview_icon_rl), mModelImageWidth);
			setViewAbsoluteSize(nImageView, mModelImageWidth, mModelImageWidth);
			TextView nSubTitleView = (TextView) itemView.findViewById(R.id.gridview_sub_title);
			if (item == null) {
				itemView.setOnClickListener(null);
				((TextView) itemView.findViewById(R.id.gridview_title)).setText("");
				nImageView.setImageBitmap(null);
				nSubTitleView.setVisibility(View.GONE);
				return;
			}

			if (item.mIconRes <= 0){
				nImageView.setVisibility(View.GONE);
				nSubTitleView.setVisibility(View.VISIBLE);
				nSubTitleView.setText(item.mSubTitle);
			}else{
				nSubTitleView.setVisibility(View.GONE);
				nImageView.setVisibility(View.VISIBLE);
				nImageView.setImageResource(item.mIconRes);
			}
			if (item.mTitleRes <= 0) {
				((TextView) itemView.findViewById(R.id.gridview_title)).setText(item.mTitle);
			} else {
				((TextView) itemView.findViewById(R.id.gridview_title)).setText(item.mTitleRes);
			}
			itemView.setTag(item.mType);

			itemView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View arg0) {
					// TODO Auto-generated method stub
					onModelClick((Integer) arg0.getTag());
				}
			});
		}
	};

	MemberSecurityInterface mSecurityInterface = new MemberSecurityInterface(this) {

		@Override
		public void isBindMobile(boolean isBinded) {
			// TODO Auto-generated method stub
			isBindedMobile = isBinded;
			mMemberIndexInterface.RunRequest();
		}

		@Override
		public void FailRequest() {
			if (!rootView.isShown()) {
				rootView.setVisibility(View.VISIBLE);
			}
		}
	};

	MemberIndexInterface mMemberIndexInterface = new MemberIndexInterface(this) {

		@Override
		public void responseSucc() {
			// TODO Auto-generated method stub
			mMember = mLoginedUser.mMemberIndex.getMember();
			assignmentDetail();
			// onRefresh();
		}

		@Override
		public void task_response(String json_str) {
			if (!rootView.isShown()) {
				rootView.setVisibility(View.VISIBLE);
			}
			super.task_response(json_str);
		}
	};
	private LoginedUser mLoginedUser;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle(R.string.acco_home_title);
		mActionBar.setShowTitleBar(false);
		mLoginedUser = AgentApplication.getLoginedUser(mActivity);

		mModelImageWidth = Run.dip2px(mActivity, 23);
	}

	protected void onModelClick(int type) {
		// TODO Auto-generated method stub
		switch (type) {
		case MENU_JOIN_IN:
			// startActivity(AgentActivity.intentForFragment(mActivity,
			// AgentActivity.FRAGMENT_ACCO_DISTRIBUTION));
            startActivity(AgentActivity.FRAGMENT_ACCO_JOIN);
			break;
		case MENU_ADDR:
			startNeedloginActivity(AgentActivity.FRAGMENT_ADDR_BOOK);
			break;
		case MENU_COLLECTION:
			startActivity(AgentActivity.FRAGMENT_GOODS_COLLECTION);
			break;
		case MENU_SPOOR:
			startActivity(AgentActivity.FRAGMENT_GOODS_SPOOR);
			break;
		case MENU_COUPON_CENTER:
			startActivity(AgentActivity.FRAGMENT_MARKETING_COUPON_CENTER);
			break;
		case MENU_PRESELL_ORDER:
			startNeedloginActivity(AgentActivity.FRAGMENT_SHOPP_ORDER_PREPARE);
			break;
		case MENU_ACTIVITY:
			startActivity(AgentActivity.FRAGMENT_MARKETING_ACTIVITY);
			break;
		case MENU_ARFTERMARKET:
			startNeedloginActivity(AgentActivity.FRAGMENT_AFTERMARKET_ORDERS);
			break;
		case MENU_SERVICE:
			startNeedloginActivity(AgentActivity.FRAGMENT_ACCO_SERVICE);
			break;
			case MENU_PARTNER :
				startNeedloginActivity(AgentActivity.FRAGMENT_PARTNR_LIST);
				break;
			case MENU_COLLECT_MONEY :
				startActivity(AgentActivity.FRAGMENT_WEAL_COLLECTION_MAIN);
				break;
			case MENU_STATISTICAL :
				startNeedloginActivity(AgentActivity.FRAGMENT_STATISTICS_CHART);
				break;
			case MENU_ACCESS :
				startNeedloginActivity(AgentActivity.FRAGMENT_GOODS_ACCESS_RECORD);
				break;
		default:
			break;
		}
	}

	protected List<ModelBean> buildModelItems() {
		List<ModelBean> nModelItems = new ArrayList<ModelBean>();
		nModelItems.add(new ModelBean(MENU_COLLECTION, R.string.menu_collection, mMember != null ? mMember.getFavorite_num() + "" : "0"));
		nModelItems.add(new ModelBean(MENU_SPOOR, R.string.menu_spoor, GoodsUtil.getSpoor(mActivity).size() + ""));
		if (mLoginedUser.mMemberIndex != null && mLoginedUser.mMemberIndex.isPrepare_status()) {
			nModelItems.add(new ModelBean(MENU_PRESELL_ORDER, R.string.menu_presell, R.drawable.home_presell));
		}
		nModelItems.add(new ModelBean(MENU_ARFTERMARKET, R.string.menu_aftermarket, R.drawable.home_aftermarket));

		nModelItems.add(new ModelBean(MENU_COUPON_CENTER, R.string.menu_coupon_center, R.drawable.home_coupon_ceter));
		nModelItems.add(new ModelBean(MENU_ACTIVITY, R.string.menu_activity, R.drawable.home_activity));
		nModelItems.add(new ModelBean(MENU_ADDR, R.string.menu_addr, R.drawable.home_addr));
		nModelItems.add(new ModelBean(MENU_SERVICE, R.string.menu_service, R.drawable.home_service));

		if(!mLoginedUser.isLogined()) {
			nModelItems.add(new ModelBean(MENU_JOIN_IN, R.string.menu_join_in, R.drawable.home_join_in));
		}

		if (mLoginedUser.isLogined() && mLoginedUser.mMemberIndex.isDistribution_status()) {
			nModelItems.add(new ModelBean(MENU_PARTNER, R.string.menu_partner, R.drawable.home_partner));
			nModelItems.add(new ModelBean(MENU_COLLECT_MONEY, R.string.menu_collect_money, R.drawable.home_collect_money));
			nModelItems.add(new ModelBean(MENU_STATISTICAL, R.string.menu_statistical, R.drawable.home_statistical));
		}

		nModelItems.add(new ModelBean(MENU_ACCESS, "存取记录", mMember != null ? mMember.getAccess_num() +
				"" : "0"));

		return nModelItems;
	}

	/**
	 * 处理个人中心数据
	 * 
	 */
	protected void assignmentDetail() {
		// TODO Auto-generated method stub
		mNickNameTextView.setText(mLoginedUser.getDisplayName());
		displayCircleImage(mAvatarImageView, mLoginedUser.getAvatarUri());
		mHanderLvTextView.setText(mLoginedUser.getMemberLvName());
		mHanderLvTextView.setVisibility(!TextUtils.isEmpty(mLoginedUser.getMemberLvName()) ? View.VISIBLE : View.GONE);
		hasNewsView.setVisibility(mMember != null && mMember.getUn_readMsg() > 0 ? View.VISIBLE : View.GONE);

		mPayBadgeView.setNewsCount(mMember != null ? mMember.getUn_pay_orders() : 0);
		mDeliveryBadgeView.setNewsCount(mMember != null ? mMember.getUn_ship_orders() : 0);
		mReceiptBadgeView.setNewsCount(mMember != null ? mMember.getUn_received_orders() : 0);
		mRecommentBadgeView.setNewsCount(mMember != null ? mMember.getUn_discuss_orders() : 0);

		mDepositTextView.setText(mMember != null ? mMember.getAdvance() + "" : "0");
		mCouponTextView.setText(mMember != null ? mMember.getCoupon_num() + "" : "0");
		mScoreTextView.setText(mMember != null ? mMember.getUsage_point() + "" : "0");
		mIncomeTextView.setText(mMember != null ? mMember.getUsage_point() + "" : "0");

//		if (mLoginedUser.mMemberIndex != null && mLoginedUser.mMemberIndex.isDistribution_status()) {
//			findViewById(R.id.menu_deposit_income_ll).setVisibility(View.VISIBLE);
//		} else {

			findViewById(R.id.menu_deposit_income_ll).setVisibility(View.GONE);
//		}
		
		findViewById(R.id.binding_phone).setVisibility(!mLoginedUser.isLogined() || isBindedMobile?View.GONE:View.VISIBLE);

		mModelBeans.clear();
		mModelBeans.addAll(buildModelItems());
		mModelAdapter.notifyDataSetChanged();
	}

	@Override
	public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.init(inflater, container, savedInstanceState);

		rootView = View.inflate(mActivity, R.layout.fragment_acco, null);
		rootView.setVisibility(View.INVISIBLE);
		setViewHeight(findViewById(R.id.acco_header_rl), 460);

		mModelListView = (ListView) rootView.findViewById(R.id.model);
		mModelListView.setAdapter(mModelAdapter);

		hasNewsView = rootView.findViewById(R.id.has_unread);

		mNickNameTextView = (TextView) findViewById(R.id.acco_header_name);
		mAvatarImageView = (ImageView) findViewById(R.id.acco_header_avatar);
		mHanderLvTextView = (TextView) findViewById(R.id.acco_hander_lv);

		findViewById(R.id.acco_header_modify_icon).setOnClickListener(this);
		mAvatarImageView.setOnClickListener(this);
		mHanderLvTextView.setOnClickListener(this);
		mNickNameTextView.setText(mLoginedUser.getMember().getUname());
		displayCircleImage(mAvatarImageView, mLoginedUser.getAvatarUri());
		mHanderLvTextView.setText(mLoginedUser.getMemberLvName());

		mPayTextView = (TextView) findViewById(R.id.menu_order_wait_payment);
		mPayBadgeView = new BadgeView(mActivity, mPayTextView);
		mPayBadgeView.setBadgePosition(BadgeView.POSITION_TOP_RIGHT);
		mDeliveryTextView = (TextView) findViewById(R.id.menu_order_wait_deliver);
		mDeliveryBadgeView = new BadgeView(mActivity, mDeliveryTextView);
		mDeliveryBadgeView.setBadgePosition(BadgeView.POSITION_TOP_RIGHT);
		mReceiptTextView = (TextView) findViewById(R.id.menu_order_wait_receipt);
		mReceiptBadgeView = new BadgeView(mActivity, mReceiptTextView);
		mReceiptBadgeView.setBadgePosition(BadgeView.POSITION_TOP_RIGHT);
		mRecommentTextView = (TextView) findViewById(R.id.menu_order_wait_recommend);
		mRecommentBadgeView = new BadgeView(mActivity, mRecommentTextView);
		mRecommentBadgeView.setBadgePosition(BadgeView.POSITION_TOP_RIGHT);
		findViewById(R.id.menu_order_wait_payment_ll).setOnClickListener(this);
		findViewById(R.id.menu_order_wait_deliver_ll).setOnClickListener(this);
		findViewById(R.id.menu_order_wait_receipt_ll).setOnClickListener(this);
		findViewById(R.id.menu_order_wait_recommend_ll).setOnClickListener(this);
		findViewById(R.id.menu_order_all_ll).setOnClickListener(this);

		mDepositTextView = (TextView) findViewById(R.id.menu_deposit_balance);
		mScoreTextView = (TextView) findViewById(R.id.menu_deposit_score);
		mCouponTextView = (TextView) findViewById(R.id.menu_deposit_coupon);
		mIncomeTextView = (TextView) findViewById(R.id.menu_deposit_income);
		findViewById(R.id.menu_deposit_balance_ll).setOnClickListener(this);
		findViewById(R.id.menu_deposit_coupon_ll).setOnClickListener(this);
		findViewById(R.id.menu_deposit_score_ll).setOnClickListener(this);
		findViewById(R.id.menu_deposit_income_ll).setOnClickListener(this);

		findViewById(R.id.acco_info).setOnClickListener(this);
		findViewById(R.id.acco_header_setting).setOnClickListener(this);
		findViewById(R.id.acco_header_news).setOnClickListener(this);
		findViewById(R.id.login).setOnClickListener(this);
		findViewById(R.id.binding_phone).setOnClickListener(this);
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();

		if (mLoginedUser.isLogined()) {
			findViewById(R.id.acco_header_loginedon).setVisibility(View.VISIBLE);
			findViewById(R.id.acco_header_unlogined).setVisibility(View.GONE);
			mSecurityInterface.RunRequest();
		} else {
			findViewById(R.id.acco_header_loginedon).setVisibility(View.GONE);
			findViewById(R.id.acco_header_unlogined).setVisibility(View.VISIBLE);
			if (!isFirst) {
				hasNewsView.setVisibility(mMember == null || mMember.getUn_readMsg() > 0 ? View.VISIBLE : View.GONE);
			}
			
			if (!rootView.isShown()) {
				rootView.setVisibility(View.VISIBLE);
			}
			assignmentDetail();
		}

		isFirst = false;
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		Bundle nBundle = new Bundle();
		switch (v.getId()) {
		case R.id.menu_deposit_coupon_ll:
			startNeedloginActivity(AgentActivity.FRAGMENT_ACCO_COUPON);
			break;
		case R.id.menu_deposit_balance_ll:
			startNeedloginActivity(AgentActivity.FRAGMENT_WEALTH);
			break;
		case R.id.menu_deposit_score_ll:
			startNeedloginActivity(AgentActivity.FRAGMENT_ACCO_POINTS);
			break;
		case R.id.menu_order_wait_payment_ll:
			nBundle.putLong(Run.EXTRA_DETAIL_TYPE, OrderFragment.WAIT_PAY);
			nBundle.putInt(OrderSegementFragment.ORDER_SEGEMENT_DEFUALT_SELECT,R.id.segement_left);
			startNeedloginActivity(AgentActivity.FRAGMENT_SHOPP_ALL_ORDERS, nBundle);
			break;
		case R.id.menu_order_wait_deliver_ll:
			nBundle.putLong(Run.EXTRA_DETAIL_TYPE, OrderFragment.WAIT_SHIPPING);
			nBundle.putInt(OrderSegementFragment.ORDER_SEGEMENT_DEFUALT_SELECT,R.id.segement_left);
			startNeedloginActivity(AgentActivity.FRAGMENT_SHOPP_ALL_ORDERS, nBundle);
			break;
		case R.id.menu_order_wait_receipt_ll:
			nBundle.putLong(Run.EXTRA_DETAIL_TYPE, OrderFragment.WAIT_RECEIPT);
			nBundle.putInt(OrderSegementFragment.ORDER_SEGEMENT_DEFUALT_SELECT,R.id.segement_left);
			startNeedloginActivity(AgentActivity.FRAGMENT_SHOPP_ALL_ORDERS, nBundle);
			break;
		case R.id.menu_order_wait_recommend_ll:
			nBundle.putLong(Run.EXTRA_DETAIL_TYPE, OrderFragment.WAIT_COMMENT);
			nBundle.putInt(OrderSegementFragment.ORDER_SEGEMENT_DEFUALT_SELECT,R.id.segement_left);
			startNeedloginActivity(AgentActivity.FRAGMENT_SHOPP_ALL_ORDERS, nBundle);
			break;
		case R.id.acco_header_modify_icon:
			startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_ACCO_PERSONAL_INFO));
			break;
		case R.id.acco_header_avatar:
			startActivity(AgentActivity.intentForFragment(getActivity(), AgentActivity.FRAGMENT_ACCO_PERSONAL_INFO));
			break;
		case R.id.acco_header_news:
			startNeedloginActivity(AgentActivity.FRAGMENT_NEWS_CENTER);
			break;
		case R.id.acco_hander_lv:
			startActivity(AgentActivity.FRAGMENT_ACCO_LV);
			break;
		case R.id.acco_info:
			startActivity(AgentActivity.FRAGMENT_ACCO_PERSONAL_INFO);
			break;
		case R.id.login:
			startActivity(AgentActivity.FRAGMENT_COMM_LOGIN);
			break;
		case R.id.acco_header_setting:
			startActivity(AgentActivity.FRAGMENT_ACCO_SETTING);
			break;
		case R.id.binding_phone:
			startActivity(AgentActivity.FRAGMENT_ACCO_BIND_MOBILE);
			break;
		case R.id.menu_order_all_ll:
			nBundle.putLong(Run.EXTRA_DETAIL_TYPE, OrderFragment.ALL);
			nBundle.putInt(OrderSegementFragment.ORDER_SEGEMENT_DEFUALT_SELECT,R.id.segement_left);
			startNeedloginActivity(AgentActivity.FRAGMENT_SHOPP_ALL_ORDERS);
			break;
		default:
			super.onClick(v);
			break;
		}
	}
}
