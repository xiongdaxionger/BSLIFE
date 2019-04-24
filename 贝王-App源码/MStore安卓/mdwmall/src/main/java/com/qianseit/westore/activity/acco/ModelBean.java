package com.qianseit.westore.activity.acco;

/**
 * 模块bean，主要用来构建菜单项画面（listview或gridview方式）
 * Created by qianseit on 2016-09-18.
 */

public class ModelBean {
    /**
     * 标题
     */
    public String mTitle;
    /**
     * 标题（res方式)
     */
    public int mTitleRes;
    /**
     * 图标（res方式）
     */
    public int mIconRes;
    /**
     * 类型，用来标识是哪个菜单
     */
    public int mType;
    /**
     * 副标题
     */
    public String mSubTitle;

    public ModelBean(int type, String title, int iconRes) {
        mTitle = title;
        mIconRes = iconRes;
        mType = type;
        mTitleRes = 0;
        mSubTitle = "";
    }

    public ModelBean(int type, int titleRes, int iconRes) {
        mTitle = "";
        mIconRes = iconRes;
        mType = type;
        mTitleRes = titleRes;
        mSubTitle = "";
    }

    public ModelBean(int type, int titleRes, String subTitle) {
        mTitle = "";
        mIconRes = 0;
        mType = type;
        mTitleRes = titleRes;
        mSubTitle = subTitle;
    }

    public ModelBean(int type, String title, String subTitle) {
        mTitle = title;
        mIconRes = 0;
        mType = type;
        mTitleRes = 0;
        mSubTitle = subTitle;
    }
}
