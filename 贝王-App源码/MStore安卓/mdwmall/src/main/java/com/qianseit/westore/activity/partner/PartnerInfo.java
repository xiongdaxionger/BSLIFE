package com.qianseit.westore.activity.partner;

import android.os.Parcel;
import android.os.Parcelable;
import android.text.Html;
import android.text.Spanned;

import com.qianseit.westore.util.StringUtils;

import org.json.JSONObject;

import java.util.Locale;

/**
 * 会员信息
 */

public class PartnerInfo implements Parcelable{

    ///用户id
    public String userId;

    ///昵称
    public String name;

    ///头像
    public String headImageURL;

    ///带来收益金额
    public String earnAmount;

    ///收益富文本
    private Spanned earnAmountHtml;

    ///电话
    String mobile;

    ///订单数量
    int orderCount;

    ///订单数量富文本
    private Spanned orderCountHtml;

    ///下线人数
    int referral;

    ///收货地址
    String area;

    ///注册时间
    String registerTime;

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(userId);
        dest.writeString(name);
        dest.writeString(headImageURL);
        dest.writeString(earnAmount);
        dest.writeString(mobile);
        dest.writeInt(orderCount);
        dest.writeInt(referral);
        dest.writeString(area);
        dest.writeString(registerTime);
    }

    public static final Parcelable.Creator<PartnerInfo> CREATOR = new Parcelable.Creator<PartnerInfo>(){
        @Override
        public PartnerInfo createFromParcel(Parcel source) {

            PartnerInfo info = new PartnerInfo();
            info.userId = source.readString();
            info.name = source.readString();
            info.headImageURL = source.readString();
            info.earnAmount = source.readString();
            info.mobile = source.readString();
            info.orderCount = source.readInt();
            info.referral = source.readInt();
            info.area = source.readString();
            info.registerTime = source.readString();

            return info;
        }

        @Override
        public PartnerInfo[] newArray(int size) {
            return new PartnerInfo[0];
        }
    };

    public PartnerInfo() {

    }

    ///通过json字典创建
    public PartnerInfo(JSONObject object) {

        userId = object.optString("member_id");
        name = object.optString("name");
        headImageURL = object.optString("avatar");
        earnAmount = object.optString("income");
        mobile = object.optString("mobile");
        orderCount = object.optInt("order_num");
        referral = object.optInt("nums");

        JSONObject addr = object.optJSONObject("addr");
        if(addr != null){
            area = addr.optString("area");
        }

        registerTime = StringUtils.LongTimeToShortString(object.optLong("regtime"));
    }

    public Spanned getOrderCountHtml() {

        if(orderCountHtml == null){

            String string = String.format(Locale.CHINESE, "共<font color='#ff3333'>%d</font>笔订单", orderCount);

            orderCountHtml = Html.fromHtml(string);
        }
        return orderCountHtml;
    }

    public Spanned getEarnAmountHtml() {

        if(earnAmountHtml == null){

            String string = String.format(Locale.CHINESE, "累计带来收益<font color='#ff3333'>%s</font>", earnAmount);

            earnAmountHtml = Html.fromHtml(string);
        }
        return earnAmountHtml;
    }
}
