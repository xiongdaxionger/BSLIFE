package com.qianseit.westore.httpinterface.passport;

import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.Run;
import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * 检测账号是否已注册
 */
public abstract class DetectAccountExistInterface extends BaseHttpInterfaceTask {

    ///要检测的账号
    String mAccount;

    public DetectAccountExistInterface(QianseitActivityInterface activityInterface) {
        super(activityInterface);
        AutoStartLoadingDialog(false);
    }

    @Override
    public String InterfaceName() {

        return "b2c.passport.signup_ajax_check_name";
    }

    @Override
    public ContentValues BuildParams() {

        ContentValues values = new ContentValues();
        values.put("pam_account[login_name]", mAccount);
        values.put("type", "trustlogin");

        return values;
    }

    @Override
    public void task_response(String json_str) {

        try {
            if (!TextUtils.isEmpty(json_str) && TextUtils.isDigitsOnly(json_str)){
                Run.alert(mBaseActivity.getContext(), json_str);
                return;
            }

            JSONObject all = new JSONObject(json_str);
            if (checkRequestJson(mBaseActivity.getContext(), all, false)) {
                JSONObject nJsonObject = all.optJSONObject("data");
                SuccCallBack(nJsonObject == null ? all : nJsonObject);
            } else {
                mErrorJsonObject = all;
                FailRequest();
            }
        }catch (JSONException jsonE){
            Run.alert(mBaseActivity.getContext(), jsonE.getMessage());
        }catch (Exception e) {
            FailRequest();
        }
    }

    ///检测账号
    public void detectAccount(String account){

        mAccount = account;
        RunRequest();
    }
}
