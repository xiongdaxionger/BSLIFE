package com.qianseit.westore.activity.acco;

import java.util.ArrayList;
import java.util.List;

import android.os.Bundle;

import com.qianseit.westore.activity.marketing.MarketingInviteRegistFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseRadioBarFragment;
import com.qianseit.westore.base.adpter.RadioBarBean;

public class AccoDistributionFrament extends BaseRadioBarFragment {
	final int FRAGMENT_TWO_CODE = 0x100;
	final int FRAGMENT_INVITATION = 0x101;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mActionBar.setTitle("我的好友");
	}

	protected List<RadioBarBean> initRadioBar() {
		List<RadioBarBean> nBarBeans = new ArrayList<RadioBarBean>();
		nBarBeans.add(new RadioBarBean("推广二维码", FRAGMENT_TWO_CODE, new MarketingInviteRegistFragment()));
		nBarBeans.add(new RadioBarBean("邀请人", FRAGMENT_INVITATION, new AccoInvitationFrament()));
		return nBarBeans;
	}

	@Override
	protected BaseDoFragment getRadioBarFragemnt(long radioBarId) {
		// TODO Auto-generated method stub
		return null;
	}

}
