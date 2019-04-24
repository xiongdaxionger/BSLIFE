package com.qianseit.westore.base;

import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Message;
import android.text.Html.ImageGetter;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AbsListView.LayoutParams;
import android.widget.ImageView;

import com.beiwangfx.R;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.qianseit.westore.AgentApplication;
import com.qianseit.westore.LoginedUser;
import com.qianseit.westore.Run;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonMainActivity;
import com.qianseit.westore.http.JsonRequestBean;
import com.qianseit.westore.http.JsonRequestBean.JsonRequestCallback;
import com.qianseit.westore.http.JsonTask;
import com.qianseit.westore.http.JsonTaskHandler;
import com.qianseit.westore.util.loader.ImageLoaderUtils;

import org.json.JSONObject;

import java.io.File;

public class BaseDoFragment extends DoFragment {
    public class LoadCheckoutHistoryTask implements JsonTaskHandler {
        private int pageNum = 0;

        public LoadCheckoutHistoryTask(int pageNum) {
            this.pageNum = pageNum;
        }

        @Override
        public JsonRequestBean task_request() {
            // CustomDialog dialog = getProgressDialog();
            if (!isDialogShowing())
                showCancelableLoadingDialog();

            return new JsonRequestBean(Run.API_URL, "mobileapi.member.withdrawal").addParams("page_no", String.valueOf(pageNum));
        }

        @Override
        public void task_response(String json_str) {
            onCheckoutHistoryLoaded(json_str);
        }
    }

    // 更新店铺封面
    public class UpdateWallpaperTask implements JsonTaskHandler {
        private File file = null;
        private String type = null;
        private JsonRequestCallback callback;

        public UpdateWallpaperTask(File file, String type, JsonRequestCallback callback) {
            this.file = file;
            this.type = type;
            this.callback = callback;
        }

        @Override
        public JsonRequestBean task_request() {
            showCancelableLoadingDialog();

            JsonRequestBean bean = new JsonRequestBean(Run.API_URL, "mobileapi.member.upload_image");
            if (file != null) {
                bean.addParams("type", type);
                bean.files.put(file.getName(), file);
            }
            return bean;
        }

        @Override
        public void task_response(String json_str) {
            hideLoadingDialog_mt();
            try {
                JSONObject all = new JSONObject(json_str);
                if (Run.checkRequestJson(mActivity, all)) {
                    LoginedUser user = AgentApplication.getLoginedUser(mActivity);
                    if (type.equals("cover")) {
                    } else {
                        user.setAvatarUri(all.optString("data"));
                    }

                    if (callback != null)
                        callback.task_response(json_str);
                    // ImageView view = (ImageView)
                    // findViewById(R.id.westore_header_view_avatar);
                    // view.setImageBitmap(Run.placeImage(
                    // BitmapFactory.decodeFile(file.getAbsolutePath()),
                    // app.mAvatarMask, app.mAvatarCover));
                }
            } catch (Exception e) {
            }
        }
    }

    public final static String REQUEST_CODE_TYPE = "request_type";
    public final static String RESULT_DATA_KEY = "RESULT_DATA_KEY";

    public static void displayCircleImage(ImageView imageView, String uriString) {
        String mOldUrl = (String) imageView.getTag(R.id.tag_first);
        if (mOldUrl != null && mOldUrl.equals(uriString)) {
            return;
        }
        imageView.setTag(R.id.tag_first, uriString);
        mImageLoader.displayImage(uriString, imageView, ImageLoaderUtils.getCircleDisplayImageOptions());
    }

    public static void displayCircleImage(ImageView imageView, String uriString, int defualtRes) {
        String mOldUrl = (String) imageView.getTag(R.id.tag_first);
        if (mOldUrl != null && mOldUrl.equals(uriString)) {
            return;
        }
        imageView.setTag(R.id.tag_first, uriString);
        mImageLoader.displayImage(uriString, imageView, ImageLoaderUtils.getCircleDisplayImageOptions(defualtRes));
    }

    public static void displayImage(ImageView imageView, String uriString, int defualtRes) {
        String mOldUrl = (String) imageView.getTag(R.id.tag_first);
        if (mOldUrl != null && mOldUrl.equals(uriString)) {
            return;
        }
        imageView.setTag(R.id.tag_first, uriString);
        mImageLoader.displayImage(uriString, imageView, ImageLoaderUtils.getDisplayImageOptions(defualtRes, ImageScaleType.EXACTLY));
    }

    public static void displayImage(ImageView imageView, String uriString, int defualtRes, ImageScaleType scaleType) {
        String mOldUrl = (String) imageView.getTag(R.id.tag_first);
        if (mOldUrl != null && mOldUrl.equals(uriString)) {
            return;
        }
        imageView.setTag(R.id.tag_first, uriString);
        mImageLoader.displayImage(uriString, imageView, ImageLoaderUtils.getDisplayImageOptions(defualtRes, scaleType));
    }

    public static void displayRectangleImage(ImageView imageView, String uriString) {
        String mOldUrl = (String) imageView.getTag(R.id.tag_first);
        if (mOldUrl != null && mOldUrl.equals(uriString)) {
            return;
        }
        imageView.setTag(R.id.tag_first, uriString);
        mImageLoader.displayImage(uriString, imageView, ImageLoaderUtils.getRectangleDisplayImageOptions());
    }

    public static void displayRectangleImage(ImageView imageView, String uriString, ImageScaleType scaleType) {
        String mOldUrl = (String) imageView.getTag(R.id.tag_first);
        if (mOldUrl != null && mOldUrl.equals(uriString)) {
            return;
        }
        imageView.setTag(R.id.tag_first, uriString);
        mImageLoader.displayImage(uriString, imageView, ImageLoaderUtils.getRectangleDisplayImageOptions(scaleType));
    }

    public static void displayRoundImage(ImageView imageView, String uriString, int radiusPixels) {
        String mOldUrl = (String) imageView.getTag(R.id.tag_first);
        if (mOldUrl != null && mOldUrl.equals(uriString)) {
            return;
        }
        imageView.setTag(R.id.tag_first, uriString);
        mImageLoader.displayImage(uriString, imageView, ImageLoaderUtils.getRoundDisplayImageOptions(R.drawable.default_img_rect, radiusPixels));
    }

    public static void displaySquareImage(ImageView imageView, String uriString) {
        String mOldUrl = (String) imageView.getTag(R.id.tag_first);
        if (mOldUrl != null && mOldUrl.equals(uriString)) {
            return;
        }
        imageView.setTag(R.id.tag_first, uriString);
        mImageLoader.displayImage(uriString, imageView, ImageLoaderUtils.getSquareDisplayImageOptions());
    }

    public static void displaySquareImage(ImageView imageView, String uriString, ImageScaleType scaleType) {
        String mOldUrl = (String) imageView.getTag(R.id.tag_first);
        if (mOldUrl != null && mOldUrl.equals(uriString)) {
            return;
        }
        imageView.setTag(R.id.tag_first, uriString);
        mImageLoader.displayImage(uriString, imageView, ImageLoaderUtils.getSquareDisplayImageOptions(scaleType));
    }

    public static void displaySquarePayImage(ImageView imageView, String uriString, ImageScaleType scaleType) {
        String mOldUrl = (String) imageView.getTag(R.id.tag_first);
        if (mOldUrl != null && mOldUrl.equals(uriString)) {
            return;
        }
        imageView.setTag(R.id.tag_first, uriString);
        mImageLoader.displayImage(uriString, imageView, ImageLoaderUtils.getRectangleDisplayImagePayOptions(scaleType));
    }

    // ListView的底部View
    public static View makeListFooterView(Context context, int height) {
        View footerView = new View(context);
        footerView.setLayoutParams(new AbsListView.LayoutParams(LayoutParams.MATCH_PARENT, Run.dip2px(context, height)));
        return footerView;
    }

    public final int REQUEST_CODE_FOR_CHOOSE = 0x13;

    public final int REQUEST_CODE_FOR_NORMOL = -1;

    protected int mRequestType = REQUEST_CODE_FOR_NORMOL;

    public final int REQUEST_CODE_USER_LOGIN = 0x11;

    public final int REQUEST_CODE_USER_REGIST = 0x12;

    protected static ImageLoader mImageLoader = com.nostra13.universalimageloader.core.ImageLoader.getInstance();

    /**
     * 获取资源图片，html.fromhtml用
     */
    protected ImageGetter imgResGetter = new ImageGetter() {

        @Override
        public Drawable getDrawable(String source) {
            // TODO Auto-generated method stub
            int id = Integer.parseInt(source);
            Drawable d = getResources().getDrawable(id);
            if (d != null)
                d.setBounds(0, 0, d.getIntrinsicWidth(), d.getIntrinsicHeight());
            return d;
        }
    };

    public BaseDoFragment() {
    }

    // 检测用户登录状态
    public boolean checkUserLoginStatus() {
        LoginedUser user = AgentApplication.getApp(mActivity).getLoginedUser();
        return user.isLogined();

    }

    public void excuteJsonTask(JsonTaskHandler... params) {
        showCancelableLoadingDialog();
        Run.excuteJsonTask(new JsonTask(), params);
    }

    @Override
    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
    }

    /**
     * 我的可提现金额和提现记录加载成功
     *
     * @param json_str
     */
    public void onCheckoutHistoryLoaded(String json_str) {
    }

    /**
     * @param urlType    'product'=>'货品', 'gallery'=>'分类商品列表', 'goods_cat'=>'分类列表',
     *                   'recharge'=>'充值页面', 'virtual_cat'=>'虚拟分类商品列表',
     *                   'article'=>'文章', 'yiy'=>'摇一摇', 'signin'=>'签到',
     *                   'starbuy'=>'秒杀专区', 'custom'=>'自定义链接', 'preparesell'=>'预售列表','get_coupons'=>'领劵中心'
     * @param typeValueu
     * @param name
     */
    protected void onClick(String urlType, String typeValueu, String name) {
        if ("product".equals(urlType)) {
            startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_GOODS_DETAIL).putExtra(Run.EXTRA_PRODUCT_ID, typeValueu));
        } else if ("article".equals(urlType)) {
            Bundle nBundle = new Bundle();
            nBundle.putString(Run.EXTRA_ARTICLE_ID, typeValueu);
            nBundle.putString(Run.EXTRA_TITLE, name);
            startActivity(AgentActivity.FRAGMENT_COMMUNITY_COMMENT, nBundle);
        } else if ("gallery".equals(urlType)) {
            startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_GOODS_LIST).putExtra(Run.EXTRA_CLASS_ID, typeValueu).putExtra(Run.EXTRA_TITLE, name));
        } else if ("goods_cat".equals(urlType)) {
            CommonMainActivity.mActivity.chooseRadio(1);
        } else if ("recharge".equals(urlType)) {
            startNeedloginActivity(AgentActivity.FRAGMENT_WEALTH_RECHARGE);
        } else if ("virtual_cat".equals(urlType)) {
            startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_GOODS_LIST).putExtra(Run.EXTRA_VITUAL_CATE, typeValueu).putExtra(Run.EXTRA_TITLE, name));
        } else if ("brand".equals(urlType)) {
            startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_GOODS_LIST).putExtra(Run.EXTRA_BRAND_ID, typeValueu).putExtra(Run.EXTRA_TITLE, name));
        } else if ("preparesell".equals(urlType)) {
            startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_SHOPP_GOODS_LIST).putExtra(Run.EXTRA_DETAIL_TYPE, true).putExtra(Run.EXTRA_TITLE, name));
        } else if ("yiy".equals(urlType)) {
            startNeedloginActivity(AgentActivity.FRAGMENT_MARKETING_SHAKE);
        } else if ("signin".equals(urlType) || "sign".equals(urlType)) {
            startNeedloginActivity(AgentActivity.FRAGMENT_MARKETING_SIGNIN);
        } else if ("starbuy".equals(urlType)) {
            startActivity(AgentActivity.FRAGMENT_SHOPP_SECKILL);
        } else if ("coupons".equals(urlType)) {
            startActivity(AgentActivity.FRAGMENT_MARKETING_COUPON_CENTER);
        } else if ("get_coupons".equals(urlType)) {
            startActivity(AgentActivity.FRAGMENT_MARKETING_COUPON_CENTER);
        } else if ("register".equals(urlType)) {
            startNeedloginActivity(AgentActivity.FRAGMENT_MARKETING_INVITE_REGIST);
        } else if ("custom".equals(urlType)) {
            String nProductKey = "product-";
            if (!typeValueu.contains("product-")){
                nProductKey = "product_id=";
                if(!typeValueu.contains("product_id=")){
                    nProductKey = "";
                }
            }

            if (typeValueu.startsWith(Run.DOMAIN) && !TextUtils.isEmpty(nProductKey)) {
                int index = typeValueu.indexOf(nProductKey);
                int end = typeValueu.indexOf('.', index);
                if(end <= 0)end = typeValueu.indexOf('&', index);
                if (end <= 0) {
                    end = typeValueu.length();
                }

                Bundle nBundle = new Bundle();
                nBundle.putString(Run.EXTRA_PRODUCT_ID, typeValueu.substring(index + nProductKey.length(), end));
                startActivity(AgentActivity.FRAGMENT_GOODS_DETAIL, nBundle);
                return;
            }

            startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_OTHER_ARTICLE_READER).putExtra("com.qianseit.westore.EXTRA_URL", typeValueu)
                    .putExtra(Run.EXTRA_TITLE, name));
        }
    }

    @Override
    public void onClick(View v) {
        // 点击返回按钮，回到上一个界面，不退出应用
        if (mActionBar.isBackButton(v)) {
            mActivity.finish();
        } else {
            super.onClick(v);
        }
    }

    protected void onClickData(JSONObject data) {
        if (data.has("url_type")) {
            String urlType = data.optString("url_type");
            onClick(urlType, data.optString("url_id"), data.optString("ad_name"));
            return;
        }

        JSONObject nUrlJsonObject = data.optJSONObject("url");
        if (nUrlJsonObject == null) {
            return;
        }

        onClick(nUrlJsonObject.optString("url_type"), nUrlJsonObject.optString("url_id"), nUrlJsonObject.optString("ad_name"));
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mActionBar.getBackButton().setVisibility(View.VISIBLE);

        Bundle nBundle = getArguments();
        if (nBundle != null) {
            mRequestType = nBundle.getInt(REQUEST_CODE_TYPE, REQUEST_CODE_FOR_NORMOL);
        } else {
            Intent nIntent = mActivity.getIntent();
            if (nIntent != null) {
                mRequestType = nIntent.getIntExtra(REQUEST_CODE_TYPE, REQUEST_CODE_FOR_NORMOL);
            }
        }
    }

    @Override
    public void ui(int what, Message msg) {
    }
}
