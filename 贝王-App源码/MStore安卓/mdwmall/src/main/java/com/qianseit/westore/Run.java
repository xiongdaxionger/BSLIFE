package com.qianseit.westore;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.Intent.ShortcutIconResource;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.RectF;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.provider.Telephony.Sms;
import android.telephony.SmsMessage;
import android.text.TextPaint;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;;
import com.qianseit.westore.activity.AgentActivity;
import com.qianseit.westore.activity.common.CommonLauncherActivity;
import com.qianseit.westore.util.CacheUtils;
import com.qianseit.westore.util.ImageLoader;
import com.qianseit.westore.util.ImageLoader.DecodeImageCallback;
import com.qianseit.westore.util.ImageLoader.DisplayImageCallback;
import com.qianseit.westore.util.Util;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.util.Locale;
import java.util.regex.Pattern;

public class Run extends Util {
    // public static final String REQUEST_SUCCESS_CODE = "0";

    public static long countdown_time = 0;
    public static int goodsCounts = 0;
    public static final String EXTRA_BASE_LAYOUT_ID = "com.qianseit.westore.EXTRA_BASE_LAYOUT_ID";
    public static final String EXTRA_BASE_FRRAMLAYOUT_CONTAINER_ID = "com.qianseit.westore.EXTRA_BASE_FRRAMLAYOUT_CONTAINER_ID";
    public static final String ACTION_SMS_RECEIVED = "android.provider.Telephony.SMS_RECEIVED";
    public static final String ACTION_SMS_DELIVER = "android.provider.Telephony.SMS_DELIVER";

    public static final String EXTRA_DETAIL_TYPE = "com.qianseit.westore.EXTRA_DETAIL_TYPE";
    public static final String EXTRA_TAB_POSITION = "com.qianseit.westore.EXTRA_TAB_POSITION";
    // public static final String EXTRA_FILE_NAME =
    // "com.qianseit.westore.EXTRA_FILE_NAME";
    public static final String EXTRA_CLASS_ID = "com.qianseit.westore.EXTRA_CLASS_ID";
    public static final String EXTRA_BRAND_ID = "com.qianseit.westore.EXTRA_BRAND_ID";
    // public static final String EXTRA_BUY_CODE =
    // "com.qianseit.westore.EXTRA_BUY_CODE";
    public static final String EXTRA_ARTICLE_ID = "com.qianseit.westore.EXTRA_ARTICLE_ID";
    public static final String EXTRA_DATA = "com.qianseit.westore.EXTRA_DATA";
    public static final String EXTRA_VALUE = "com.qianseit.westore.EXTRA_VALUE";
    public static final String EXTRA_TITLE = "com.qianseit.westore.EXTRA_TITLE";
    // public static final String EXTRA_METHOD =
    // "com.qianseit.westore.EXTRA_METHOD";
    public static final String EXTRA_KEYWORDS = "com.qianseit.westore.EXTRA_KEYWORDS";
    public static final String EXTRA_HTML = "com.qianseit.westore.EXTRA_HTML";
    // public static final String EXTRA_URL = "com.qianseit.westore.EXTRA_URL";
    public static final String EXTRA_VITUAL_CATE = "com.qianseit.westore.EXTRA_VITUAL_CATE";
    public static final String EXTRA_ADDR = "com.qianseit.westore.EXTRA_ADDR";
    // public static final String EXTRA_AREA_ID =
    // "com.qianseit.westore.AREA_ID";
    public static final String EXTRA_PRODUCT_ID = "com.qianseit.westore.PRODUCT_ID";
    public static final String EXTRA_GOODS_ID = "com.qianseit.westore.GOODS_ID";
    public static final String EXTRA_ORDER_ID = "com.qianseit.westore.ORDER_ID";
    public static final String EXTRA_DELIVERY_ID = "com.qianseit.westore.DELIVERY_ID";
    public static final String EXTRA_FROM_EXTRACT = "com.qianseit.westore.FROM_EXTRACT";
    public static final String EXTRA_COUPON_DATA = "com.qianseit.westore.COUPON_DATA";
    public static final String EXTRA_SCAN_REZULT = "com.qianseit.westore.SCAN_REZULT";
    public static final String EXTRA_GOODS_DETAIL_BRAND = "com.qianseit.westore.DETAIL_BRAND";
    public static final String EXTRA_STROE_DELETE_GOODS = "com.qianseit.westore.STROE_DELETE_GOODS";

    // 合伙人信息
    public static final String EXTRA_PARTNER_NAME = "com.qianseit.westore.PARTNER_NAME";
    public static final String EXTRA_PARTNER_AVATAR = "com.qianseit.westore.PARTNER_AVATAR";
    public static final String EXTRA_PARTNER_MOBILE = "com.qianseit.westore.PARTNER_MOBILE";
    public static final String EXTRA_PARTNER_MEMBER_ID = "com.qianseit.westore.PARTNER_MEMBER_ID";
    public static final String EXTRA_PARTNER_ADDRESS = "com.qianseit.westore.PARTNER_ADDRESS";
    public static final String EXTRA_PARTNER_ORDER_NUM = "com.qianseit.westore.PARTNER_ORDER_NUM";
    public static final String EXTRA_PARTNER_ORDER_SALE = "com.qianseit.westore.PARTNER_ORDER_SALE";

    // 用户信息
    public static final String pk_logined_username = "logined_username";
    public static final String pk_logined_user_password = "logined_user_password";
    public static final String pk_shortcut_installed = "shortcut_installed";
    public static final String pk_third_platform = "third_platform";
    // public static final String pk_newest_version_code =
    // "newest_version_code";
    public static final String logined_user_memberId = "logined_user_memberId";

    public static final String gesture_pw_isshow = "gesture_pw_show";
    public static final String gesture_password = "gesture_password";

    public static final String DOMAIN = "http://www.ibwang.cn";
    public static final String TOKEN = "c04b237488bfa8680f9bc99ede8f7c6e0684ba336b0733c6d13b037d52e615b0";

    public static final String MAIN_URL = DOMAIN + "/index.php/";
    // public static final String PRODUCT_URL = MAIN_URL +
    // "wap/product-%s.html";
    public static final String GOODS_URL = DOMAIN + "/wap/agoods-info.html?goods_id=%s&member_id=%s";
    public static final String RECOMMEND_URL = DOMAIN + "/wap/opinions-info.html?opinions_id=%s";
    public static final String VCODE_URL = MAIN_URL + "index-gen_vcode-b2c-4.html?";
    public static final String API_URL = MAIN_URL + "mobile/";
    // public static final String VERSION_URL = DOMAIN
    // + "/app_version/version_info.php";

    public static final String FILE_HOME_ADS_JSON = "home_ads_json.cache";

    /***
     * 判断手机号的正则表达式
     ***/
    public static final String phone_judge = "^1[3|4|5|7|8][0-9]\\d{8}$";
    public static final String tel_judge = "((\\d{12})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)|(\\d{11})";

    // public static final Pattern sDrawableRegex = Pattern
    // .compile(" *@(drawable/[a-z0-9_]+) *");
    // public static final Pattern sStringRegex = Pattern
    // .compile(" *@(string/[a-z0-9_]+) *");

    /**
     * 移除2端的引号
     *
     * @param source
     * @return
     */
    public static String removeQuotes(String source) {
        if (source.startsWith("\""))
            source = source.substring(1);
        if (source.endsWith("\""))
            source = source.substring(0, source.length() - 1);
        return source;
    }

    /**
     * 移除2端的引号
     *
     * @param source
     * @return
     */
    public static String removeQuotes2(String source) {
        if (source.startsWith("{"))
            source = source.substring(1);
        if (source.endsWith("}"))
            source = source.substring(0, source.length());
        return source;
    }

    /**
     * 打开图片选择
     *
     * @return
     */
    public static Intent pickerPhotoIntent(int width, int heigth) {
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT, null);
        intent.setType("image/*");
        intent.putExtra("crop", "false");
        intent.putExtra("aspectX", width);
        intent.putExtra("aspectY", heigth);
        intent.putExtra("outputX", width);
        intent.putExtra("outputY", heigth);
        intent.putExtra("return-data", false);
        return intent;
    }

    /**
     * 判断是否为手机号
     *
     * @param number the input number to be tested
     * @return 返回true则是手机号
     */
    public static boolean isChinesePhoneNumber(String number) {

        if (TextUtils.isEmpty(number))
            return false;
        return Pattern.compile(phone_judge).matcher(number).matches();
    }

    /**
     * 判断是否为手机号
     *
     * @param number the input number to be tested
     * @return 返回true则是手机号
     */
    public static boolean isChineseTelNumber(String number) {

        if (TextUtils.isEmpty(number))
            return false;
        return Pattern.compile(tel_judge).matcher(number).matches();
    }

    public static boolean checkRequestJson(Context ctx, JSONObject all) {
        return checkRequestJson(ctx, all, true, false);
    }

    public static boolean checkRequestJson(Context ctx, JSONObject all, boolean isGoodsDeta) {
        return checkRequestJson(ctx, all, true, isGoodsDeta);
    }

    /**
     * 检测请求的状态
     *
     * @param ctx
     * @param all
     * @return
     */
    public static boolean checkRequestJson(Context ctx, JSONObject all, boolean alert, boolean isGoodsDeta) {
        if (all == null)
            return false;

        String nCode = all.optString("code");
        if (TextUtils.isEmpty(nCode))
            return true;

        if (TextUtils.equals(nCode, "need_login")) {
            if (isGoodsDeta) {
                savePrefs(ctx, "goodsdetastatus", true);
            } else {
                savePrefs(ctx, "goodsdetastatus", false);
            }
            ctx.startActivity(AgentActivity.intentForFragment(ctx, AgentActivity.FRAGMENT_COMM_LOGIN).setFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
            AgentApplication.getLoginedUser(ctx).setIsLogined(false);
            return false;
        }

        // 提示语不为空则提示用户
        String dataStr = all.isNull("data") ? EMPTY_STR : all.optString("data");
        if (TextUtils.isEmpty(dataStr))
            dataStr = all.optString("res");
        if (!TextUtils.isEmpty(dataStr) && alert) {
            try {
                JSONObject dataJson = new JSONObject(dataStr);
                alert(ctx, decodeUnicode(dataJson.optString("msg")));
            } catch (Exception e) {
                alert(ctx, decodeUnicode(dataStr));
            }
        }
        return false;
    }

    /**
     * 获取默认的图片缓存类
     *
     * @param context
     * @param resources
     * @return
     */
    public static ImageLoader getDefaultImageLoader(final Context context, final Resources resources) {
        return getDefaultImageLoader(context, resources, true);
    }

    /**
     * 获取默认的图片缓存类
     *
     * @param context
     * @param resources
     * @return
     */
    public static ImageLoader getDefaultImageLoader(final Context context, final Resources resources, final boolean scaleLimit) {
        ImageLoader mImageLoader = ImageLoader.getInstance(context);
        mImageLoader.setDisplayImageCallback(new DisplayImageCallback() {
            @Override
            public boolean displayImage(View v, Drawable drawable) {
                ((ImageView) v).setImageDrawable(drawable);
                return true;
            }
        });
        mImageLoader.setDecodeImageCallback(new DecodeImageCallback() {
            @Override
            public Drawable decodeImage(Object object) {
                if (object != null && object instanceof Uri) {
                    Uri imageUri = (Uri) object;
                    Bitmap bitmap = CacheUtils.getImageIntelligent(imageUri.toString(), scaleLimit);
                    if (bitmap != null)
                        return new BitmapDrawable(resources, bitmap);
                }
                return null;
            }
        });

        return mImageLoader;
    }

    /**
     * 改变Resources的语言
     *
     * @param res
     * @param locale
     */
    @SuppressLint("NewApi")
    public static void changeResourceLocale(Resources res, Locale locale) {
        Configuration config = res.getConfiguration();
        DisplayMetrics dm = res.getDisplayMetrics();
        try {
            config.setLocale(locale);
        } catch (NoSuchMethodError e) {
            config.locale = locale;
        }
        res.updateConfiguration(config, dm);
    }

    /**
     * 移除View
     *
     * @param view
     */
    public static void removeFromSuperView(View view) {
        ViewGroup parent = (ViewGroup) view.getParent();
        if (parent != null)
            parent.removeView(view);
    }

    /**
     * 解析地址area_id
     *
     * @param address
     * @return
     */
    public static String parseAddressId(JSONObject address) {
        String nValue = address.optString("value");
        if (!TextUtils.isEmpty(nValue)) {
            JSONObject nJsonObject;
            try {
                nJsonObject = new JSONObject(nValue);
                return nJsonObject.optString("area");
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }

        return "";
    }

    /**
     * 计算文件夹大小
     *
     * @param file
     * @return
     */
    public static long countFileSize(File file) {
        long size = 0;
        if (file.isDirectory()) {
            File[] files = file.listFiles();
            if (files != null) {
                for (int i = 0, c = files.length; i < c; i++)
                    size += countFileSize(files[i]);
            }
        } else {
            size += file.length();
        }

        return size;
    }

    /**
     * 删除所有文件
     *
     * @param file
     * @return
     */
    public static void deleteAllFiles(File file) {
        if (file != null && file.exists() && file.isDirectory()) {
            File[] files = file.listFiles();
            if (files != null) {
                for (int i = 0, c = files.length; i < c; i++)
                    deleteAllFiles(files[i]);
            }
        } else {
            if (file != null)
                file.delete();
        }
    }

    /**
     * 是否为线下支付
     *
     * @param payinfo
     * @return
     */
    public static boolean isOfflinePayment(JSONObject payinfo) {
        return TextUtils.equals("offline", payinfo.optString("pay_app_id")) || TextUtils.equals("offline", payinfo.optString("app_id"));
    }

    /**
     * 是否App内支付
     *
     * @param payinfo
     * @return
     */
    public static boolean isOfflinePayType(JSONObject payinfo) {
        if (payinfo == null) {
            return false;
        }
        return !payinfo.optBoolean("app_pay_type", false);
    }

    /**
     * 绘制圆形的avatar
     *
     * @param avatar 源图片
     * @param mask1  源图会按照mask1的形状切掉透明区域
     * @param mask2  mask2会盖在被切掉的图片上 <br>
     * @return 新的图片
     */
    public static Bitmap placeImage(Bitmap avatar, Bitmap mask1, Bitmap mask2) {
        final Paint p = new Paint();
        p.setAntiAlias(true);
        p.setFilterBitmap(true);
        int width = mask1.getWidth(), height = mask1.getHeight();
        RectF dest = new RectF(0, 0, width, height);
        final Bitmap b = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        final Canvas c = new Canvas(b);

        // draw the whole canvas as transparent
        p.setColor(Color.TRANSPARENT);
        c.drawPaint(p);
        // draw the mask normally
        p.setColor(0xFFFFFFFF);
        c.drawBitmap(mask1, null, dest, p);

        Paint pdpaint = new Paint();
        pdpaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
        pdpaint.setStyle(Paint.Style.STROKE);
        c.drawRect(0, 0, width, height, pdpaint);
        c.drawBitmap(avatar, null, dest, pdpaint);
        c.drawBitmap(mask2, null, dest, p);
        avatar.recycle();
        return b;
    }

    /**
     * 获取默认的头像缓存类
     *
     * @param context
     * @param resources
     * @return
     */
    public static ImageLoader getDefaultAvatarLoader(final Context context, final Resources resources) {
        ImageLoader mImageLoader = ImageLoader.getInstance(context);
        mImageLoader.setDefautImage(R.drawable.base_avatar_default);
        mImageLoader.setDisplayImageCallback(new DisplayImageCallback() {
            @Override
            public boolean displayImage(View v, Drawable drawable) {
                ((ImageView) v).setImageDrawable(drawable);
                return true;
            }
        });
        mImageLoader.setDecodeImageCallback(new DecodeImageCallback() {
            @Override
            public Drawable decodeImage(Object object) {
                if (object != null && object instanceof Uri) {
                    Uri imageUri = (Uri) object;
                    Bitmap bitmap = CacheUtils.getImageIntelligent(imageUri.toString(), true);
                    if (bitmap != null) {
                        AgentApplication app = AgentApplication.getApp(context);
                        return new BitmapDrawable(resources, placeImage(bitmap, app.mAvatarMask, app.mAvatarCover));
                    }
                }
                return null;
            }
        });

        return mImageLoader;
    }

    /**
     * 检测并打开第三方支付
     *
     * @param mActivity
     * @param all
     */
    public static boolean startThirdPartyPayment(Activity mActivity, JSONObject all) {
        if (!TextUtils.isEmpty(all.optString("res"))) {
            mActivity.startActivity(AgentActivity.intentForFragment(mActivity, AgentActivity.FRAGMENT_OTHER_ARTICLE_READER).putExtra(Run.EXTRA_HTML, all.optString("res")));
            return true;
        }
        return false;
    }

    /**
     * 检测订单是否付款成功
     *
     * @param all
     */
    public static boolean checkPaymentStatus(Activity activity, JSONObject all) {
        try {
            JSONObject data = all.optJSONObject("data");
            JSONObject order = data.optJSONObject("order");
            Run.alert(activity, data.optString("msg"));
            return (order.optInt("pay_status") == 1);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 加密字符串，将中间的字符转换成“***”
     *
     * @param source    源字符串
     * @param secretLen 加密的位数
     * @return <br />
     * 加密后的字符串
     */
    public static String makeSecretString(String source, int secretLen) {
        if (TextUtils.isEmpty(source) || source.length() < secretLen + 2)
            return source;

        // 替换的字符串
        StringBuilder secStr = new StringBuilder();
        for (int i = 0; i < secretLen; i++)
            secStr.append("*");

        int start = (source.length() - secretLen) / 2;
        int end = start + secretLen;
        return source.replaceFirst(source.substring(start, end), secStr.toString());
    }

    /**
     * 生成桌面快捷方式
     *
     * @param context
     */
    public static void createShortcut(Context context) {
        Intent main = new Intent();
        main.setComponent(new ComponentName(context, CommonLauncherActivity.class));
        main.setAction(Intent.ACTION_MAIN);
        main.addCategory(Intent.CATEGORY_LAUNCHER);
        //要添加这句话
        main.setFlags(Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED | Intent.FLAG_ACTIVITY_NEW_TASK);

        Intent shortcutIntent = new Intent(ACTION_INSTALL_SHORTCUT);
        shortcutIntent.putExtra(EXTRA_SHORTCUT_DUPLICATE, true);
        shortcutIntent.putExtra(Intent.EXTRA_SHORTCUT_NAME, context.getString(R.string.app_name));
        shortcutIntent.putExtra(Intent.EXTRA_SHORTCUT_INTENT, main);
        shortcutIntent.putExtra(Intent.EXTRA_SHORTCUT_ICON_RESOURCE, ShortcutIconResource.fromContext(context, R.drawable.comm_icon_launcher));
        context.sendBroadcast(shortcutIntent);
    }

    /**
     * 解析短信
     *
     * @param intent
     * @return
     */
    @SuppressLint("NewApi")
    public static String handleSmsReceived(Intent intent) {
        SmsMessage[] msgs = Sms.Intents.getMessagesFromIntent(intent);

        // 读取长信息内容
        StringBuilder body = new StringBuilder();
        int len = (msgs != null) ? msgs.length : 0;
        for (int i = 0; i < len; i++)
            body.append(msgs[i].getDisplayMessageBody());
        return body.toString();
    }

    public static int getWindowsWidth(Activity activity) {
        DisplayMetrics dm = new DisplayMetrics();
        activity.getWindowManager().getDefaultDisplay().getMetrics(dm);
        int width = dm.widthPixels;// 宽度height = dm.heightPixels
        return width;
    }

    public static int getWindowsHeight(Activity activity) {
        DisplayMetrics dm = new DisplayMetrics();
        activity.getWindowManager().getDefaultDisplay().getMetrics(dm);
        int height = dm.heightPixels;// 宽度height = dm.heightPixels
        return height;
    }

    public static boolean TextNull(String text) {
        return TextUtils.isEmpty(text) || "null".equalsIgnoreCase(text);
    }

    // 计算出该TextView中文字的长度(像素)
    public static int getTextViewLength(TextView textView, String text) {
        TextPaint paint = textView.getPaint();
        // 得到使用该paint写上text的时候,像素为多少
        float textLength = paint.measureText(text);
        return (int) textLength;
    }

    public static String ToDBC(String input) {
        char[] c = input.toCharArray();
        for (int i = 0; i < c.length; i++) {
            if (c[i] == 12288) {
                c[i] = (char) 32;
                continue;
            }
            if (c[i] > 65280 && c[i] < 65375)
                c[i] = (char) (c[i] - 65248);
        }
        return new String(c);
    }

    public static String defaultName(String name) {
        if (TextUtils.isEmpty(name)) {
            return "粉丝";
        }
        return name;
    }
}
