package com.qianseit.westore.httpinterface.passport;

import android.content.ContentValues;
import android.text.TextUtils;

import com.beiwangfx.R;
import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.bean.ThridLoginTrustBean;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;
import com.qianseit.westore.httpinterface.passport.RegistrMemberInterface.Gender;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONObject;

import java.util.HashMap;

import cn.sharesdk.framework.Platform;

public abstract class ThirdUserLoginInterface extends BaseHttpInterfaceTask {
    public static final String PLATFORM_WEIBO = "sina";
    public static final String PLATFORM_WECHAT = "weixin";
    public static final String PLATFORM_QQ = "qq";

    ThridLoginTrustBean nBean = new ThridLoginTrustBean();
    private String lactionString;

    Platform mPlatform;

    boolean isBind = false;

    public ThirdUserLoginInterface(QianseitActivityInterface activityInterface) {
        super(activityInterface);
        // TODO Auto-generated constructor stub
    }

    @Override
    public String InterfaceName() {
        // TODO Auto-generated method stub
        return "b2c.passport.trust_login";
    }

    @Override
    public void SuccCallBack(JSONObject responseJson) {
        // TODO Auto-generated method stub
        isBind = !TextUtils.isEmpty(StringUtils.getString(responseJson, "member_id"));
        if (nBean.getSource().equals(PLATFORM_WEIBO)) {
            loginSuccessWeibo(nBean.getOpenId(), mPlatform.getDb().getToken());
        } else {
            loginSuccessOther();
        }
    }

    public abstract void loginSuccessWeibo(String weiboId, String weboToken);

    public abstract void loginSuccessOther();

    @Override
    public ContentValues BuildParams() {
        // TODO Auto-generated method stub
        ContentValues nContentValues = new ContentValues();
        nContentValues.put("provider_code", nBean.getSource());
        nContentValues.put("openid", nBean.getOpenId());
        if (!TextUtils.isEmpty(nBean.getNickName()))
            nContentValues.put("nickname", nBean.getNickName());
        if (!TextUtils.isEmpty(nBean.getGender()))
            nContentValues.put("gender", nBean.getGender().equalsIgnoreCase(Gender.BOY) ? "1" : "0");
        if (!TextUtils.isEmpty(lactionString)) {
            nContentValues.put("country", lactionString);
        }
        if(!TextUtils.isEmpty(nBean.getUnionid())){
            nContentValues.put("unionid", nBean.getUnionid());
        }
        nContentValues.put("source_app", mBaseActivity.getContext().getString(R.string.app_channel_name));// 来源
        return nContentValues;
    }

    public void Login(String platName, Platform arg0, HashMap<String, Object> arg2) {
        mPlatform = arg0;
        nBean.setSource(platName);
        nBean.setOpenId(arg0.getDb().getUserId());
        nBean.setNickName(arg0.getDb().getUserName());
        nBean.setGender(arg0.getDb().getUserGender().equals("m") ? Gender.BOY : Gender.GIRL);
        nBean.setAvatar(arg0.getDb().getUserIcon());
        if (platName.equals(PLATFORM_WEIBO)) {
            lactionString = (String) arg2.get("location");
        } else if (platName.equals(PLATFORM_QQ)) {// QQ 微信返回地址
            nBean.setAvatar((String) arg2.get("figureurl_qq_2"));
            lactionString = String.valueOf(arg2.get("province")) + String.valueOf(arg2.get("city"));
        } else if (platName.equals(PLATFORM_WECHAT)) {
            lactionString = String.valueOf(arg2.get("province")) + String.valueOf(arg2.get("city"));
            nBean.setUnionid(String.valueOf(arg2.get("unionid")));
        }
        System.out.println("----->>-->>" + arg2.toString());
        RunRequest();
    }

    public ThridLoginTrustBean getThridLoginTrustBean() {
        return nBean;
    }

    public boolean isBindMobile() {
        return isBind;
    }
}
