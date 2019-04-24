package com.qianseit.westore.activity.goods;

import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.base.BaseRadioBarFragment;
import com.qianseit.westore.base.adpter.RadioBarBean;

import java.util.ArrayList;
import java.util.List;

/**
 * 商品存取记录
 */

public class GoodsAccessRecordFragment extends BaseRadioBarFragment {

    GoodsStoreFragment mGoodsStoreFragment;

    GoodsPickFragment mGoodsPickFragment;

    @Override
    protected void init() {
        super.init();
        mActionBar.setTitle("存取记录");
    }

    @Override
    protected List<RadioBarBean> initRadioBar() {
        ArrayList<RadioBarBean> bean = new ArrayList<>(2);
        bean.add(new RadioBarBean("存货列表", 0));
        bean.add(new RadioBarBean("存取记录", 1));

        return bean;
    }

    @Override
    protected BaseDoFragment getRadioBarFragemnt(long radioBarId) {
        int id = ((Long)radioBarId).intValue();
        switch (id){
            case 0 : {
                if(mGoodsStoreFragment == null){
                    mGoodsStoreFragment = new GoodsStoreFragment();
                }
                return mGoodsStoreFragment;
            }
            case 1 : {
                if(mGoodsPickFragment == null){
                    mGoodsPickFragment = new GoodsPickFragment();
                }
                return mGoodsPickFragment;
            }
        }
        return null;
    }
}
