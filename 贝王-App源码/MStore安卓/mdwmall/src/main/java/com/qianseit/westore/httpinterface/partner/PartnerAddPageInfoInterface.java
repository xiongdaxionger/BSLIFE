package com.qianseit.westore.httpinterface.partner;

import android.content.Context;

import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

import org.json.JSONObject;

/**
 * Created by luohaixiong on 16/11/22.
 */

public abstract class PartnerAddPageInfoInterface extends BaseHttpInterfaceTask {


    public PartnerAddPageInfoInterface(QianseitActivityInterface activityInterface) {
        super(activityInterface);
    }

    public PartnerAddPageInfoInterface(){
        this(new QianseitActivityInterface() {
            @Override
            public void showLoadingDialog() {

            }

            @Override
            public void showCancelableLoadingDialog() {

            }

            @Override
            public void hideLoadingDialog() {

            }

            @Override
            public void hideLoadingDialog_mt() {

            }

            @Override
            public Context getContext() {
                return AgentApplication.getContext();
            }
        });
    }

    @Override
    public String InterfaceName() {
        return "distribution.fxmem.signup";
    }

    @Override
    public void SuccCallBack(JSONObject responseJson) {

        String url = "";
        if(responseJson.optBoolean("valideCode")){
            url = responseJson.optString("code_url");
        }
        getImageCodeURL(url);
    }

    @Override
    public void FailRequest() {
        super.FailRequest();
        getImageCodeURL(null);
    }

    ///获取验证码回调
    public abstract void getImageCodeURL(String url);
}
