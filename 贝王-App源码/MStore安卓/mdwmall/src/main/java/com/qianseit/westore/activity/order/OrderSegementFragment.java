package com.qianseit.westore.activity.order;

import com.beiwangfx.R;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.order.OrderFragment;
import com.qianseit.westore.base.BaseDoFragment;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.ViewGroup;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Hank on 16/11/21.
 */

public class OrderSegementFragment extends BaseDoFragment implements OnCheckedChangeListener {

    /**暴露外界的传值key
     */
    public final static String ORDER_SEGEMENT_DEFUALT_SELECT = "ORDER_SEGEMENT_DEFUALT_SELECT";
    /**分段控件
     */
    private RadioGroup mOrderSegement;
    /**id对应的Fragment
     */
    Map<Integer, BaseDoFragment> mFragmenntMap;
    /**默认选中的分段ID
     */
    int mDefualtOrderSelectID = R.id.segement_left;
    /**订单类型
     */
    int mDefaultOrderType = 0;

    private LoginedUser mLoginedUser;

    /**周期方法
     * @param savedInstanceState
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        mDefualtOrderSelectID = mActivity.getIntent().getIntExtra(ORDER_SEGEMENT_DEFUALT_SELECT, R.id.segement_left);
        mDefaultOrderType = (int) mActivity.getIntent().getLongExtra(Run.EXTRA_DETAIL_TYPE,OrderFragment.ALL);
        mLoginedUser = AgentApplication.getLoginedUser(mActivity);

    }

    /**初始化方法
     * @param inflater
     * @param container
     * @param savedInstanceState
     */
    @Override
    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.init(inflater, container, savedInstanceState);
        rootView = inflater.inflate(R.layout.fragment_bill_segement, null);
        mOrderSegement = (RadioGroup) findViewById(R.id.bill_segement);
        mOrderSegement.setOnCheckedChangeListener(this);
        Run.removeFromSuperView(mOrderSegement);
        if (mLoginedUser.isLogined() && mLoginedUser.mMemberIndex.isDistribution_status()) {
            mActionBar.setCustomTitleView(mOrderSegement);
        }
        else {
            mActionBar.setTitle("我的订单");
        }
        initFragmentMap();

        ((RadioButton) mOrderSegement.findViewById(mDefualtOrderSelectID)).setChecked(true);
        ((RadioButton) mOrderSegement.findViewById(R.id.segement_left)).setText("我的订单");
        ((RadioButton) mOrderSegement.findViewById(R.id.segement_right)).setText("代购订单");
        switchFragment(mFragmenntMap.get(mDefualtOrderSelectID));
    }

    @SuppressLint("UseSparseArrays")
    /**初始化Fragment内容
     */
    void initFragmentMap(){
        mFragmenntMap = new HashMap<Integer, BaseDoFragment>();
        long orderType = OrderFragment.ALL;
        switch (mDefaultOrderType){
            case 0:
                orderType = OrderFragment.ALL;
                break;
            case 1:
                orderType = OrderFragment.WAIT_PAY;
                break;
            case 2:
                orderType = OrderFragment.WAIT_SHIPPING;
                break;
            case 3:
                orderType = OrderFragment.WAIT_RECEIPT;
                break;
            case 4:
                orderType = mDefualtOrderSelectID == R.id.segement_right ? OrderFragment.WAIT_RECEIPT : OrderFragment.WAIT_COMMENT;
                break;
        }
        OrderFragment myOrderFragment = new OrderFragment();
        Bundle nBundle = new Bundle();
        nBundle.putLong(Run.EXTRA_DETAIL_TYPE, orderType);
        nBundle.putBoolean(OrderFragment.ORDER_COMMISION_TYPE,false);
        myOrderFragment.setArguments(nBundle);
        Bundle nComisionBundle = new Bundle();
        nComisionBundle.putLong(Run.EXTRA_DETAIL_TYPE,orderType);
        nComisionBundle.putBoolean(OrderFragment.ORDER_COMMISION_TYPE,true);
        nComisionBundle.putInt(Run.EXTRA_BASE_LAYOUT_ID, R.layout.base_fragment_radiobar2);
        nComisionBundle.putInt(Run.EXTRA_BASE_FRRAMLAYOUT_CONTAINER_ID, R.id.base_fragment_main_content2);
        OrderFragment commisionOrderFragment = new OrderFragment();
        commisionOrderFragment.setArguments(nComisionBundle);
        mFragmenntMap.put(R.id.segement_left, myOrderFragment);
        mFragmenntMap.put(R.id.segement_right, commisionOrderFragment);
    }

    /**分段控件点击事件
     * @param group
     * @param checkedId
     */
    @Override
    public void onCheckedChanged(RadioGroup group, int checkedId) {
        switchFragment(mFragmenntMap.get(checkedId));
    }

    /**切换fragment
     */
    private void switchFragment(BaseDoFragment baseFragment) {
        if (baseFragment == null) {
            return;
        }

        FragmentTransaction fragmentTransaction = mActivity.getSupportFragmentManager().beginTransaction();
        fragmentTransaction.replace(R.id.segement_content, baseFragment);
        fragmentTransaction.commit();
    }
}
