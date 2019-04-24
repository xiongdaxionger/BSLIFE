package com.qianseit.westore.activity.acco;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import android.app.Activity;
import android.app.Dialog;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;

import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.activity.common.CommonLoginFragment.InputHandler;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseRadioBarFragment;
import com.qianseit.westore.base.adpter.RadioBarBean;
import com.qianseit.westore.httpinterface.member.MemberGetCouponInterface;

public class AccoCouponFragment extends BaseRadioBarFragment {
	public final static long COUPON_STATUS_AVAILABLE = 1;
	public final static long COUPON_STATUS_UNAVAILABLE = 2;
	
	Map<Long, BaseDoFragment> mFragmentMap;

	Dialog mDialog;

	MemberGetCouponInterface mGetCouponInterface = new MemberGetCouponInterface(this) {
		
		@Override
		public void SuccCallBack(JSONObject responseJson) {
			// TODO Auto-generated method stub
			mActivity.setResult(Activity.RESULT_OK);
			((AccoCouponListFragment)getSelectedFragment()).onRefresh();
		}
	};
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("优惠劵");

		mActionBar.setRightTitleButton("添加", new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				mDialog = CommonLoginFragment.showInputDialog(mActivity, "添加优惠券码", "输入优惠券码", "确定","#F3273F","取消","#F3273F", new InputHandler() {
					
					@Override
					public boolean verify(String inputString) {
						// TODO Auto-generated method stub
						return true;
					}
					
					@Override
					public void onOk(String inputString) {
						// TODO Auto-generated method stub
						mGetCouponInterface.getCoupon(inputString);
					}
				});
			}
		});
	}
	
	@Override
	protected void back() {
		// TODO Auto-generated method stub
		((AccoCouponListFragment)getSelectedFragment()).back();
	}
	
	@Override
	protected List<RadioBarBean> initRadioBar() {
		// TODO Auto-generated method stub
		mFragmentMap = new HashMap<Long, BaseDoFragment>();
		
		List<RadioBarBean> nBarBeans = new ArrayList<RadioBarBean>();
		AccoCouponListFragment nAccoCouponListFragment = new AccoCouponListFragment();
		nAccoCouponListFragment.setArguments(mActivity.getIntent().getExtras());
		nBarBeans.add(new RadioBarBean("可用", COUPON_STATUS_AVAILABLE));
		mFragmentMap.put(COUPON_STATUS_AVAILABLE, nAccoCouponListFragment);
		
		nBarBeans.add(new RadioBarBean("失效", COUPON_STATUS_UNAVAILABLE));
		mFragmentMap.put(COUPON_STATUS_UNAVAILABLE, new AccoCouponUnavailableListFragment());
		return nBarBeans;
	}

	@Override
	protected BaseDoFragment getRadioBarFragemnt(long radioBarId) {
		// TODO Auto-generated method stub
		return mFragmentMap.get(radioBarId);
	}

}
