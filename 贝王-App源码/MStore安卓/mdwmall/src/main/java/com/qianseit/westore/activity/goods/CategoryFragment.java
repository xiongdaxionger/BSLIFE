package com.qianseit.westore.activity.goods;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.Dialog;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;

import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.activity.other.CaptureActivity;
import com.qianseit.westore.activity.shopping.ItemSearchView;
import com.qianseit.westore.activity.shopping.SearchCallback;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseRadioBarFragment;
import com.qianseit.westore.base.adpter.RadioBarBean;
import com.beiwangfx.R;

public class CategoryFragment extends BaseRadioBarFragment {
	final long CATEGORY_GOODS = 1;
	final long CATEGORY_BRAND = 2;
	
	Map<Long, BaseDoFragment> mFragmentMap = new HashMap<Long, BaseDoFragment>();

	///弹窗
	Dialog mDialog;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);

		ItemSearchView nItemSearchView = new ItemSearchView(mActivity);
		nItemSearchView.setSearchCallback(new SearchCallback() {

			@Override
			public void search(String searchKey) {
				// TODO Auto-generated method stub
				startActivity(AgentActivity.FRAGMENT_GOODS_SEARCH);
			}
		});
		nItemSearchView.setCanInput(false);
		mActionBar.setCustomTitleView(nItemSearchView);
		mActionBar.setRightImageButton(R.drawable.news_dark, new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				startNeedloginActivity(AgentActivity.FRAGMENT_NEWS_CENTER);
			}
		});
//		mActionBar.getBackButton().setImageResource(R.drawable.phone_icon_dark);
		mActionBar.getBackButton().setImageResource(R.drawable.scan_dark);
		mActionBar.getBackButton().setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub

				///拨打客服电话
//				if(mLoginedUser.getPhone() != null){
//					makePhoneCall(mLoginedUser.getPhone());
//				}else {
//
//					showLoadingDialog();
//					///加载客服电话
//					mLoginedUser.loadServicePhone(new LoginedUser.LoadServicePhoneHandler() {
//						@Override
//						public void onComplete() {
//							hideLoadingDialog();
//							makePhoneCall(mLoginedUser.getPhone());
//						}
//					});
//				}
				Intent nIntent = new Intent(mActivity, CaptureActivity.class);
				startActivity(nIntent);
			}
		});
	}

	///拨打电话
	void makePhoneCall(String phone){
		if(TextUtils.isEmpty(phone))
			return;
		final String nPhone = phone;
		///拨打客服电话
		mDialog = CommonLoginFragment.showAlertDialog(mActivity, String.format("%s", nPhone), "取消", "拨打", null, new View.OnClickListener() {

			@Override
			public void onClick(View v) {

				String phone = nPhone;
				if (phone.contains("-")) {
					phone = phone.replaceAll("-", "");
				}
				Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:" + phone));
				intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
				startActivity(intent);
				mDialog.hide();
			}
		}, false, null);
	}
	
	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		mActionBar.setShowBackButton(true);
		if (mLoginedUser.isLogined()) {
			mActionBar.setHasNews(mLoginedUser.getMember().getUn_readMsg() > 0);
		}else
			mActionBar.setHasNews(false);
	}
	
	@Override
	protected List<RadioBarBean> initRadioBar() {
		// TODO Auto-generated method stub
		List<RadioBarBean> nBarBeans = new ArrayList<RadioBarBean>();
		nBarBeans.add(new RadioBarBean("分类", CATEGORY_GOODS));
		mFragmentMap.put(CATEGORY_GOODS, new CategoryGoodsFragment());
		
		nBarBeans.add(new RadioBarBean("品牌", CATEGORY_BRAND));
		mFragmentMap.put(CATEGORY_BRAND, new CategoryBrandFragment());
		return nBarBeans;
	}
   
	@Override
	protected Drawable divideDrawable() {
		return mActivity.getResources().getDrawable(R.drawable.radio_bar_class_selector);
	}

	@Override
	protected BaseDoFragment getRadioBarFragemnt(long radioBarId) {
		// TODO Auto-generated method stub
		return mFragmentMap.get(radioBarId);
	}
}
