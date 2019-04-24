package com.qianseit.westore.httpinterface.passport;

import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * Created by Hank on 16/11/29.
 */

public abstract class GetSmsCodeInterface extends BaseHttpInterfaceTask {

    String mPhone;
    String mType;

    public GetSmsCodeInterface(QianseitActivityInterface activityInterface) {
        super(activityInterface);
        // TODO Auto-generated constructor stub
    }

    @Override
    public String InterfaceName() {
        // TODO Auto-generated method stub
        return "b2c.passport.get_vcode";
    }

    @Override
    public ContentValues BuildParams() {
        // TODO Auto-generated method stub
        ContentValues nContentValues = new ContentValues();
        nContentValues.put("uname", mPhone);
        nContentValues.put("type",mType);
        return nContentValues;
    }

    public void getSmsCode(String uname,String type){
        mPhone = uname;
        mType = type;
        RunRequest();
    }
}
