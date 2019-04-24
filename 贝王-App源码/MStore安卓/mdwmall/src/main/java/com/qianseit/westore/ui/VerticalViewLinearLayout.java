package com.qianseit.westore.ui;

import java.util.ArrayList;

import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Handler;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.qianseit.westore.Run;
import com.qianseit.westore.ui.VerticalViewLinearLayout.TextCycleViewListener;
import com.beiwangfx.R;

/**
 * 广告图片自动轮播控件</br>
 * 
 * <pre>
 *   集合ViewPager和指示器的一个轮播控件，主要用于一般常见的广告图片轮播，具有自动轮播和手动轮播功能 
 *   使用：只需在xml文件中使用{@code <com.minking.imagecycleview.ImageCycleView/>} ，
 *   然后在页面中调用  {@link #setImageResources(ArrayList, TextCycleViewListener) }即可!
 *   
 *   另外提供{@link #startImageCycle() } \ {@link #pushImageCycle() }两种方法，用于在Activity不可见之时节省资源；
 *   因为自动轮播需要进行控制，有利于内存管理
 * </pre>
 * 
 * @author minking
 */
public class VerticalViewLinearLayout extends LinearLayout {

	/**
	 * 上下文
	 */
	private Context mContext;

	/**
	 * 图片轮播视图
	 */
	private ViewPager mAdvPager = null;

	/**
	 * 滚动图片视图适配器
	 */
	private TextCycleAdapter mAdvAdapter;


	private ArrayList<JSONObject> textListArray;

	/**
	 * 图片滚动当前图片下标
	 */
	private int mImageIndex = 0;

	/**
	 * 手机密度
	 */
	private float mScale;

	/**
	 * @param context
	 */
	public VerticalViewLinearLayout(Context context) {
		super(context);
	}

	/**
	 * @param context
	 * @param attrs
	 */
	@SuppressLint("ClickableViewAccessibility")
	public VerticalViewLinearLayout(Context context, AttributeSet attrs) {
		super(context, attrs);
		mContext = context;
		mScale = context.getResources().getDisplayMetrics().density;
		LayoutInflater.from(context).inflate(R.layout.item_shopping_home_vertical_view, this);
		mAdvPager = (ViewPager) findViewById(R.id.shopping_home_vertical_pager);
		mAdvPager.setOnPageChangeListener(new GuidePageChangeListener());
		mAdvPager.setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				switch (event.getAction()) {
				case MotionEvent.ACTION_UP:
					// 开始图片滚动
					startImageTimerTask();
					break;
				default:
					// 停止图片滚动
					stopImageTimerTask();
					break;
				}
				return false;
			}
		});
	}

	/**
	 * 装填图片数据
	 *
	 * @param TextCycleViewListener
	 */
	public void setTextResources(ArrayList<JSONObject> textList,
			TextCycleViewListener TextCycleViewListener) {
		textListArray=textList;
		mAdvAdapter = new TextCycleAdapter(mContext, textList,
				TextCycleViewListener);
		mAdvPager.setAdapter(mAdvAdapter);
		startImageTimerTask();
	}

	/**
	 * 开始轮播(手动控制自动轮播与否，便于资源控制)
	 */
	public void startImageCycle() {
		startImageTimerTask();
	}

	/**
	 * 暂停轮播——用于节省资源
	 */
	public void pushImageCycle() {
		stopImageTimerTask();
	}

	/**
	 * 开始图片滚动任务
	 */
	private void startImageTimerTask() {
		stopImageTimerTask();
		// 图片每3秒滚动一次
		mHandler.postDelayed(mTextTimerTask, 3000);
	}

	/**
	 * 停止图片滚动任务
	 */
	private void stopImageTimerTask() {
		mHandler.removeCallbacks(mTextTimerTask);
	}

	private Handler mHandler = new Handler();

	/**
	 * 图片自动轮播Task
	 */
	private Runnable mTextTimerTask = new Runnable() {

		@Override
		public void run() {
			if (textListArray != null) {
				// 下标等于图片列表长度说明已滚动到最后一张图片,重置下标
				if ((++mImageIndex) == Integer.MAX_VALUE) {
					mImageIndex = 0;
				}
				mAdvPager.setCurrentItem(mImageIndex);
			}
		}
	};

	/**
	 * 轮播图片状态监听器
	 * 
	 * @author minking
	 */
	private final class GuidePageChangeListener implements OnPageChangeListener {

		@Override
		public void onPageScrollStateChanged(int state) {
			if (state == ViewPager.SCROLL_STATE_IDLE)
				startImageTimerTask(); // 开始下次计时
		}

		@Override
		public void onPageScrolled(int arg0, float arg1, int arg2) {
		}

		@Override
		public void onPageSelected(int index) {
			
		}

	}
   
	private class TextCycleAdapter extends PagerAdapter {

		/**
		 * 图片视图缓存列表
		 */
		private ArrayList<TextView> mTextViewCacheList;

		/**
		 * 图片资源列表
		 */
		private ArrayList<JSONObject> mAdList = new ArrayList<JSONObject>();

		/**
		 * 广告图片点击监听器
		 */
		private TextCycleViewListener mFastViewListener;

		private Context mContext;

		public TextCycleAdapter(Context context, ArrayList<JSONObject> adList,
				TextCycleViewListener TextCycleViewListener) {
			mContext = context;
			mAdList = adList;
			mFastViewListener = TextCycleViewListener;
			mTextViewCacheList = new ArrayList<TextView>();
		}

		@Override
		public int getCount() {
			return Integer.MAX_VALUE;
		}

		@Override
		public boolean isViewFromObject(View view, Object obj) {
			return view == obj;
		}

		@Override
		public Object instantiateItem(ViewGroup container, final int position) {
			JSONObject textJSON = mAdList.get(position%mAdList.size());
		
			TextView textView= null;
			if (mTextViewCacheList.isEmpty()) {
				textView = new TextView(mContext);
				textView.setLayoutParams(new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
				textView.setTextSize(TypedValue.COMPLEX_UNIT_SP,13);
				textView.setLines(1);
				textView.setGravity(Gravity.CENTER_VERTICAL);
                textView.setTextColor(mContext.getResources().getColor(R.color.text_goods_3_color));
			} else {
				textView = mTextViewCacheList.remove(0);
			}
			// 设置图片点击监听
			textView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					mFastViewListener.onTextClick(position, v);
				}
			});
			textView.setTag(textJSON);
			container.addView(textView);
			mFastViewListener.displayTextView(textJSON, textView);
			return textView;
		}

		@Override
		public void destroyItem(ViewGroup container, int position, Object object) {
			TextView view = (TextView) object;
			container.removeView(view);
			mTextViewCacheList.add(view);
		}

	}
	
	/**
	 * 轮播控件的监听事件
	 * 
	 * @author minking
	 */
	public interface TextCycleViewListener {

		/**
		 * 加载图片资源
		 * 
		 * @param imageURL
		 * @param imageView
		 */
		void displayTextView(JSONObject imageURLJson, TextView textView);

		/**
		 * 单击图片事件
		 * 
		 * @param position
		 * @param imageView
		 */
		void onTextClick(int position, View textView);
	}

}
