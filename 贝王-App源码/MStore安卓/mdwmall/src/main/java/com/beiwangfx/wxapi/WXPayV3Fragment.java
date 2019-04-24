package com.beiwangfx.wxapi;

import org.json.JSONObject;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.ViewGroup;

import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelpay.PayReq;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

public class WXPayV3Fragment extends BaseDoFragment implements IWXAPIEventHandler {

    IWXAPI msgApi;
    PayReq req;
    private JSONObject data;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        msgApi = WXAPIFactory.createWXAPI(mActivity, null);
    }

    @Override
    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.init(inflater, container, savedInstanceState);
    }

    public void callWXPay(JSONObject data) {
        this.data = data;
        genPayReq();
    }

    private void genPayReq() {

        Run.savePrefs(mActivity, "WXPayResult", false);
        Run.savePrefs(mActivity, "PayResult", false);
        JSONObject returnData = data.optJSONObject("return");
        Run.savePrefs(mActivity, "orderId", data.optString("order_id"));
        Run.savePrefs(mActivity, "sign", returnData.optString("sign"));
        Run.savePrefs(mActivity, "appid", returnData.optString("appid"));
        req = new PayReq();
        req.appId = returnData.optString("appid");
        req.partnerId = returnData.optString("partnerid");
        req.prepayId = returnData.optString("prepayid");
        req.packageValue = returnData.optString("package");
        req.nonceStr = returnData.optString("noncestr");
        req.timeStamp = returnData.optString("timestamp");
        req.sign = returnData.optString("sign");
        msgApi.registerApp(Constants.APP_ID);
        msgApi.sendReq(req);
    }

    @Override
    public void onReq(BaseReq arg0) {

    }

    @Override
    public void onResp(BaseResp arg0) {

    }
}
