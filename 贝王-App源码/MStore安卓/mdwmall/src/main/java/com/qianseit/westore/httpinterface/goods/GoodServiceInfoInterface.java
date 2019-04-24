package com.qianseit.westore.httpinterface.goods;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * Created by Hank on 16/11/24.
 */

public abstract class GoodServiceInfoInterface extends BaseHttpInterfaceTask {

    public GoodServiceInfoInterface(QianseitActivityInterface activityInterface){
        super(activityInterface);
    }

    @Override
    public String InterfaceName() {
        // TODO Auto-generated method stub
        return "b2c.activity.shopinfo";
    }

    @Override
    public ContentValues BuildParams() {
        // TODO Auto-generated method stub
        ContentValues nContentValues = new ContentValues();
        nContentValues.put("default", "default");
        return nContentValues;
    }
}
