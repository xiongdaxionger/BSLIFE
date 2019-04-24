package com.qianseit.westore.util.loader;

import android.content.Context;
import android.graphics.Bitmap;
import android.text.TextUtils;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;

import com.beiwangfx.R;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;

public class VolleyImageLoader {
	
	private static VolleyImageLoader mImageLoader;

	public static VolleyImageLoader getImageLoader(Context context){
		if (mImageLoader == null) {
			mImageLoader = new VolleyImageLoader();
		}
		return mImageLoader;
	}
	public void showImage(ImageView imageView, String strImgUrl){
		if (TextUtils.isEmpty(strImgUrl) || !strImgUrl.contains("http")) {
			return;
		}
        //显示图片的配置  
        DisplayImageOptions options = new DisplayImageOptions.Builder()  
                .showImageOnLoading(R.drawable.default_img_rect)  
                .showImageOnFail(R.drawable.default_img_rect)  
                .cacheInMemory(true)  
                .cacheOnDisk(true)  
                .bitmapConfig(Bitmap.Config.RGB_565)  
                .build();  
          
        ImageLoader.getInstance().displayImage(strImgUrl, imageView, options);  
			
	}
	
	public void showImage(ImageView imageView, String strImgUrl ,ScaleType scaleType){
		if (TextUtils.isEmpty(strImgUrl) || !strImgUrl.contains("http")) {
			return;
		}
		imageView.setScaleType(scaleType);
		 DisplayImageOptions options = new DisplayImageOptions.Builder()  
         .showImageOnLoading(R.drawable.default_img_rect)  
         .showImageOnFail(R.drawable.default_img_rect)  
         .cacheInMemory(true)  
         .cacheOnDisk(true)  
         .bitmapConfig(Bitmap.Config.RGB_565)  
         .build();  
   
      ImageLoader.getInstance().displayImage(strImgUrl, imageView, options);
	}

	/**
	 * 删除存在 SDCARD 的 ImageCache 文件
	 * @author chesonqin
	 * 2014-12-11
	 */
	public void deleteImageCache(){
		
		
	}
}
