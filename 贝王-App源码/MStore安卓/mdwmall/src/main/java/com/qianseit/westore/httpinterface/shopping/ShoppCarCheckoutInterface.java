package com.qianseit.westore.httpinterface.shopping;


import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

import java.util.Set;

/**
 * @author qianseit 3.7 订单确认页
 */
public abstract class ShoppCarCheckoutInterface extends BaseHttpInterfaceTask {
    String mIsFastBuy = "";

    final String mSelectedIdentName = "obj_ident[%d]";
    protected ContentValues mSelectedContentValues = new ContentValues();

    public ShoppCarCheckoutInterface(QianseitActivityInterface activityInterface) {
        super(activityInterface);
        // TODO Auto-generated constructor stub
    }

    @Override
    public String InterfaceName() {
        // TODO Auto-generated method stub
        return "b2c.cart.checkout";
    }

    @Override
    public ContentValues BuildParams() {
        // TODO Auto-generated method stub
        ContentValues nContentValues = new ContentValues();
        if (mSelectedContentValues.size() > 0) {
            nContentValues.putAll(mSelectedContentValues);
        }
        if (!TextUtils.isEmpty(mIsFastBuy)) {
            nContentValues.put("isfastbuy", mIsFastBuy);
        }
        return nContentValues;
    }

    /**
     * 重置，即清空缓存的商品
     */
    public void reset() {
        mIsFastBuy = "";
        mSelectedContentValues.clear();
    }

    /**
     * 立即购买
     */
    public void setFastbuy() {
        mIsFastBuy = "true";
    }

    /**
     * 是否可以提交（没有选中商品不能提交）
     *
     * @return
     */
    public boolean canCheckout() {
        return mSelectedContentValues.size() > 0;
    }

    /**
     * @param goodsIdent 商品（ident_id）
     */
    public void addGoodsIdent(String goodsIdent) {
        Set<String> nStrings = mSelectedContentValues.keySet();
        for (String string : nStrings) {
            if (mSelectedContentValues.getAsString(string).equals(goodsIdent)) {
                return;
            }
        }

        mSelectedContentValues.put(String.format(mSelectedIdentName, mSelectedContentValues.size()), goodsIdent);
    }
}
