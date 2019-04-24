package com.qianseit.westore.activity.goods;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDoFragment;
import com.qianseit.westore.ui.ShareViewPopupWindow;
import com.qianseit.westore.util.Util;

import org.json.JSONObject;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.wechat.friends.Wechat;
import cn.sharesdk.wechat.moments.WechatMoments;

public class GoodsTwoDCodeFragment extends BaseDoFragment implements PlatformActionListener {

    private ImageView twoCodeImg;
    private TextView shareWechat, shareWechatCircle, fromShop;
    private TextView twoUserNameText, twoHintText;

    ShareViewPopupWindow mShareViewPopupWindow;

    private View mQRCodeView;
    Platform platform = null;
    private File file;
    String mGoodsShareUrl;
    String mGoodsName;

    JSONObject dataJson;

    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
//		mActionBar.setRightImageButton(R.drawable.share2, new OnClickListener() {
//			
//			@Override
//			public void onClick(View v) {
//				// TODO Auto-generated method stub
//				if (file == null) {
//					if (!saveToLocal()) {
//						return;
//					}
//				}
//				
//				mShareViewPopupWindow.showAtLocation(rootView, android.view.Gravity.BOTTOM, 0, 0);
//			}
//		});
        mGoodsShareUrl = getExtraStringFromBundle(Run.EXTRA_VALUE);
        mGoodsName = getExtraStringFromBundle(Run.EXTRA_TITLE);
        mActionBar.setTitle("二维码");
    }

    public void init(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        rootView = inflater.inflate(R.layout.fragment_goods_twodcode, null);

        twoCodeImg = (ImageView) findViewById(R.id.user_two_code);
        final int nWidth = (int) (Run.getWindowsWidth(mActivity) * 0.8);
        setViewAbsoluteSize(twoCodeImg, nWidth, nWidth);
        mQRCodeView = findViewById(R.id.qrcode_layout);
        mQRCodeView.setDrawingCacheEnabled(true);
        twoCodeImg.setDrawingCacheEnabled(true);
        fromShop = (TextView) findViewById(R.id.from);
        shareWechat = (TextView) findViewById(R.id.share_wechat);
        shareWechatCircle = (TextView) findViewById(R.id.share_wechat_circle);
        twoUserNameText = (TextView) findViewById(R.id.two_name_tv);
        twoHintText = (TextView) findViewById(R.id.two_hint_tv);
        findViewById(R.id.user_two_code_divider).setLayerType(View.LAYER_TYPE_SOFTWARE, null);

        findViewById(R.id.qrcode_save).setOnClickListener(this);
        shareWechat.setOnClickListener(this);
        shareWechatCircle.setOnClickListener(this);

        twoUserNameText.setText(mGoodsName);

        mHandler.post(new Runnable() {

            @Override
            public void run() {
                // TODO Auto-generated method stub
                twoCodeImg.setImageBitmap(Util.CreateTwoDCode(mActivity, mGoodsShareUrl, nWidth, nWidth));
            }
        });
    }

    @Override
    public void onClick(View v) {

        if (v.getId() == R.id.qrcode_save) {
            if (saveToLocal()) {
                Run.alert(mActivity, "保存成功");
            }
        } else if (v == shareWechat) {
            platform = ShareSDK.getPlatform(mActivity, Wechat.NAME);
            Wechat.ShareParams params = new Wechat.ShareParams();

            if (file == null) {
                if (!saveToLocal()) {
                    return;
                }
            }

            params.setShareType(Platform.SHARE_IMAGE);
            params.setImagePath(file.getAbsolutePath());
            platform.share(params);
        } else if (v == shareWechatCircle) {
            platform = ShareSDK.getPlatform(mActivity, WechatMoments.NAME);
            WechatMoments.ShareParams params = new WechatMoments.ShareParams();

            if (file == null) {
                if (!saveToLocal()) {
                    return;
                }
            }

            params.setShareType(Platform.SHARE_IMAGE);
            params.setImagePath(file.getAbsolutePath());
            platform.share(params);
        }
    }

    boolean saveToLocal() {
        //Bitmap b = mImageLoader.getInstance().loadImageSync(shareUrl);
        Bitmap b = mQRCodeView.getDrawingCache();

        // 首先保存图片
        File filePath = new File(Environment.getExternalStorageDirectory(), "Xyms-QrCode");
        if (!filePath.exists()) {
            filePath.mkdir();
        }
        String fileName = System.currentTimeMillis() + ".jpg";
        file = new File(filePath, fileName);
        try {
            FileOutputStream fos = new FileOutputStream(file);
            b.compress(CompressFormat.JPEG, 100, fos);
            fos.flush();
            fos.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            Run.alert(mActivity, e.getMessage());
            return false;
        } catch (IOException e) {
            Run.alert(mActivity, e.getMessage());
            e.printStackTrace();
            return false;
        }

        // 其次把文件插入到系统图库
        try {
            MediaStore.Images.Media.insertImage(mActivity.getContentResolver(), file.getAbsolutePath(), fileName, null);
        } catch (FileNotFoundException e) {
            Run.alert(mActivity, e.getMessage());
            e.printStackTrace();
            return false;
        }
        // 最后通知图库更新
        mActivity.sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.fromFile(file)));

        return true;
    }


    // 分享失败
    private void alertFailed(final String platName) {
        mHandler.post(new Runnable() {
            @Override
            public void run() {
                Run.alert(mActivity, mActivity.getString(R.string.share_failed, platName));
            }
        });
    }

    // 分享成功
    private void alertSuccess(final String platName) {
        mHandler.post(new Runnable() {
            @Override
            public void run() {
                Run.alert(mActivity, mActivity.getString(R.string.share_success, platName));
            }
        });
    }

    @Override
    public void onCancel(Platform arg0, int arg1) {
        alertFailed(mActivity.getString(R.string.share));
    }

    @Override
    public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
        alertSuccess(mActivity.getString(R.string.share));
    }

    @Override
    public void onError(Platform arg0, int arg1, Throwable arg2) {
        alertFailed(mActivity.getString(R.string.share));
    }
}
