package com.qianseit.westore.util.loader;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Handler;

import com.beiwangfx.R;
import com.nostra13.universalimageloader.cache.disc.impl.UnlimitedDiscCache;
import com.nostra13.universalimageloader.cache.memory.impl.LruMemoryCache;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;
import com.nostra13.universalimageloader.core.decode.BaseImageDecoder;
import com.nostra13.universalimageloader.core.display.FadeInBitmapDisplayer;
import com.nostra13.universalimageloader.core.display.RoundedBitmapDisplayer;
import com.nostra13.universalimageloader.core.download.BaseImageDownloader;

/**
 * 
 * @author yangtq
 */
public class ImageLoaderUtils {

	public static ImageLoaderConfiguration getImageLoaderConfiguration(Context context) {

		ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(context)// .memoryCacheExtraOptions(480,
																						// 800)
				// default = device screen dimensions
				// .discCacheExtraOptions(480, 800, CompressFormat.JPEG, 75,
				// null)
				// .taskExecutor(...)
				// .taskExecutorForCachedImages(...)
				.threadPoolSize(3)
				// default
				.threadPriority(Thread.NORM_PRIORITY - 1)
				// default
				.tasksProcessingOrder(QueueProcessingType.FIFO)
				// default
				.denyCacheImageMultipleSizesInMemory().memoryCache(new LruMemoryCache(2 * 1024 * 1024))
				// .memoryCache(new LruMemoryCache(20 * 1024 * 1024))
				.memoryCacheSize(2 * 1024 * 1024).memoryCacheSizePercentage(13) // default
				.diskCache(new UnlimitedDiscCache(FileUtils.getImageCacheDir())).diskCacheFileCount(800).diskCacheSize(800 * 1024 * 1024)
				// .discCache(new UnlimitedDiscCache(cacheDir))// default
				// .discCacheSize(50 * 1024 * 1024) // 缓冲大小
				// .discCacheFileCount(100) // 缓冲文件数目
				// .discCacheFileNameGenerator(new HashCodeFileNameGenerator())
				// // default
				.imageDownloader(new BaseImageDownloader(context)) // default
				.imageDecoder(new BaseImageDecoder(false)) // default
				.defaultDisplayImageOptions(DisplayImageOptions.createSimple()) // default
				.writeDebugLogs().build();
		return config;
	}

	public static DisplayImageOptions getSquareDisplayImageOptions() {
		return getDisplayImageOptions(R.drawable.default_img_square, ImageScaleType.EXACTLY);
	}

	public static DisplayImageOptions getSquareDisplayImageOptions(ImageScaleType imageScaleType) {
		return getDisplayImageOptions(R.drawable.default_img_square, imageScaleType);
	}

	public static DisplayImageOptions getRectangleDisplayImageOptions() {
		return getDisplayImageOptions(R.drawable.default_img_rect, ImageScaleType.EXACTLY);
	}

	public static DisplayImageOptions getRectangleDisplayImageOptions(ImageScaleType imageScaleType) {
		return getDisplayImageOptions(R.drawable.default_img_rect, imageScaleType);
	}

	public static DisplayImageOptions getRectangleDisplayImagePayOptions(ImageScaleType imageScaleType) {
		return getDisplayImageOptions(R.drawable.default_pay, imageScaleType);
	}

	public static DisplayImageOptions getDisplayImageOptions(int defaultImagRes, ImageScaleType imageScaleType) {
		@SuppressWarnings("deprecation")
		DisplayImageOptions nOptions = new DisplayImageOptions.Builder()// .showStubImage(R.drawable.default_img_rect)
																		// //
																		// image在加载过程中，显示的图片
				.showImageForEmptyUri(defaultImagRes) // empty URI时显示的图片
				.showImageOnFail(defaultImagRes) // 不是图片文件 显示图片
				.showImageOnLoading(defaultImagRes)
				.resetViewBeforeLoading(false) // default
				.delayBeforeLoading(100).cacheInMemory(true) // default 不缓存至内存
				.cacheOnDisc(true) // default 不缓存至手机SDCard
				// .preProcessor(...)
				// .postProcessor(...)
				// .extraForDownloader(...)
				.imageScaleType(imageScaleType)// default
				.displayer(new FadeInBitmapDisplayer(300, true, true, true)).bitmapConfig(Bitmap.Config.RGB_565) // default
				// .decodingOptions(...)
				// 可以设置动画，比如圆角或者渐变
				.handler(new Handler()) // default
				.build();
		return nOptions;
	}

	public static DisplayImageOptions getCircleDisplayImageOptions(int defaultImagRes) {
		DisplayImageOptions nOptions = new DisplayImageOptions.Builder()// .showStubImage(R.drawable.shop_avatar)
																		// //
				.showImageOnLoading(defaultImagRes)														// image在加载过程中，显示的图片
				.showImageForEmptyUri(defaultImagRes) // empty URI时显示的图片
				.showImageOnFail(defaultImagRes) // 不是图片文件 显示图片
				.resetViewBeforeLoading(false) // default
				.delayBeforeLoading(100).cacheInMemory(true) // default 不缓存至内存
				.cacheOnDisc(false) // default 不缓存至手机SDCard
				// .preProcessor(...)
				// .postProcessor(...)
				// .extraForDownloader(...)
				.imageScaleType(ImageScaleType.EXACTLY)// default
				.displayer(new CircleBitmapDisplayer()).bitmapConfig(Bitmap.Config.RGB_565) // default
				// .decodingOptions(...)
				// 可以设置动画，比如圆角或者渐变
				.handler(new Handler()) // default
				.build();
		return nOptions;
	}

	public static DisplayImageOptions getRoundDisplayImageOptions(int defaultImagRes, int radiusPixels) {
		DisplayImageOptions nOptions = new DisplayImageOptions.Builder()// .showStubImage(R.drawable.shop_avatar)
																		// //
				.showImageOnLoading(defaultImagRes)														// image在加载过程中，显示的图片
				.showImageForEmptyUri(defaultImagRes) // empty URI时显示的图片
				.showImageOnFail(defaultImagRes) // 不是图片文件 显示图片
				.resetViewBeforeLoading(false) // default
				.delayBeforeLoading(100).cacheInMemory(true) // default 不缓存至内存
				.cacheOnDisc(false) // default 不缓存至手机SDCard
				// .preProcessor(...)
				// .postProcessor(...)
				// .extraForDownloader(...)
				.imageScaleType(ImageScaleType.EXACTLY)// default
				.displayer(new RoundedBitmapDisplayer(radiusPixels)) // default
				// .decodingOptions(...)
				// 可以设置动画，比如圆角或者渐变
				.handler(new Handler()) // default
				.build();
		return nOptions;
	}

	public static DisplayImageOptions getCircleDisplayImageOptions() {
		return getCircleDisplayImageOptions(R.drawable.base_avatar_default);
	}

	public static DisplayImageOptions getCommonCircleDisplayImageOptions() {
		DisplayImageOptions nOptions = new DisplayImageOptions.Builder()// .showStubImage(R.drawable.shop_avatar)
																		// //
				.showImageOnLoading(R.drawable.default_img_square)													// image在加载过程中，显示的图片
				.showImageForEmptyUri(R.drawable.default_img_square) // empty
																	// URI时显示的图片
				.showImageOnFail(R.drawable.default_img_square) // 不是图片文件 显示图片
				.resetViewBeforeLoading(false) // default
				.delayBeforeLoading(100).cacheInMemory(false) // default 不缓存至内存
				.cacheOnDisc(false) // default 不缓存至手机SDCard
				// .preProcessor(...)
				// .postProcessor(...)
				// .extraForDownloader(...)
				.imageScaleType(ImageScaleType.IN_SAMPLE_INT)// default
				.displayer(new CircleBitmapDisplayer()).bitmapConfig(Bitmap.Config.RGB_565) // default
				// .decodingOptions(...)
				// 可以设置动画，比如圆角或者渐变
				.handler(new Handler()) // default
				.build();
		return nOptions;
	}
}
