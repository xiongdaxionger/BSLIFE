package com.qianseit.westore.activity.partner;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.beiwangfx.R;;
import com.qianseit.westore.activity.community.CommDiscoverNoteListFragment;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseRadioBarFragment;
import com.qianseit.westore.base.BaseRadioPageViewFragment;
import com.qianseit.westore.base.adpter.RadioBarBean;

import java.util.ArrayList;
import java.util.List;

/**
 * 会员详情
 */

public class PartnerDetailFragment extends BaseRadioBarFragment {

    ///会员信息key
    public static final String PARTNER_INFO_KEY = "partnerInfo";

    ///层级
    public static final String HIERARCHY_KEY = "hierarchy";

    ///会员id可以
    public static final String USERID_KEY = "userId";

    ///会员信息
    private PartnerInfo mPartnerInfo;

    ///层级 小于等于1时无法查看团队
    private int mHierarchy;

    ///会员简介
    PartnerIntroFragment mPartnerIntroFragment;

    ///团队下线
    PartnerTeamFragment mPartnerTeamFragment;

    ///订单
    PartnerOrderFragment mPartnerOrderFragment;

    @Override
    protected List<RadioBarBean> initRadioBar() {

        ArrayList<RadioBarBean> list = new ArrayList<>();
        list.add(new RadioBarBean("简介", 0));
        if(mHierarchy > 1){
            list.add(new RadioBarBean("团队", 1));
        }
        list.add(new RadioBarBean("订单", 2));
        return list;
    }

    @Override
    protected BaseDoFragment getRadioBarFragemnt(long radioBarId) {

        switch ((int)radioBarId){

            case 0 :
                ///会员简介
                if(mPartnerIntroFragment == null){
                    mPartnerIntroFragment = new PartnerIntroFragment();

                    Bundle bundle = new Bundle(1);
                    bundle.putParcelable(PARTNER_INFO_KEY, mPartnerInfo);
                    mPartnerIntroFragment.setArguments(bundle);
                }

                return mPartnerIntroFragment;
            case 1 :
                ///团队
                if(mPartnerTeamFragment == null){
                    mPartnerTeamFragment = new PartnerTeamFragment();

                    Bundle bundle = new Bundle(1);
                    bundle.putString(USERID_KEY, mPartnerInfo.userId);
                    bundle.putInt(HIERARCHY_KEY, mHierarchy);
                    mPartnerTeamFragment.setArguments(bundle);
                }

                return mPartnerTeamFragment;
            case 2 :
                ///订单
                if(mPartnerOrderFragment == null){
                    mPartnerOrderFragment = new PartnerOrderFragment();

                    Bundle bundle = new Bundle(1);
                    bundle.putString(USERID_KEY, mPartnerInfo.userId);
                    mPartnerOrderFragment.setArguments(bundle);
                }

                return mPartnerOrderFragment;
        }

        return null;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Intent intent = mActivity.getIntent();
        mPartnerInfo = intent.getParcelableExtra(PARTNER_INFO_KEY);
        mHierarchy = intent.getIntExtra(HIERARCHY_KEY, 0);
        mActionBar.setTitle("会员详情");
        mActionBar.setShowBackButton(true);
    }

    @Override
    protected void initTop(LinearLayout topLayout) {
        super.initTop(topLayout);

        ///头部
        View header = View.inflate(mActivity, R.layout.partner_detail_header, null);

        ///头像
        ImageView imageView = (ImageView)header.findViewById(R.id.header);
        displayCircleImage(imageView, mPartnerInfo.headImageURL);

        ///昵称
        TextView textView = (TextView)header.findViewById(R.id.name_textView);
        textView.setText(mPartnerInfo.name);

        topLayout.addView(header);
    }
}
