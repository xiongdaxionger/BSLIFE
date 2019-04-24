package com.qianseit.westore.activity.shopping;

import android.content.Context;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.base.BaseDialog;
import com.qianseit.westore.ui.wheelview.WheelAdapter;
import com.qianseit.westore.util.StringUtils;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kankan.wheel.widget.OnWheelChangedListener;
import kankan.wheel.widget.WheelView;
import kankan.wheel.widget.adapters.ArrayWheelAdapter;

public class ShoppShippingTimeDialog extends BaseDialog implements OnWheelChangedListener {

	WheelView mTime1LoopView, mTime2LoopView, mTime3LoopView;
	WheelAdapter mTime1Adapter, mTime2Adapter, mTime3Adapter;
	JSONObject mShippingTime;

	List<String> mTypeList, mDayList, mDayDisplayList, mTimeList;
	Map<String, List<String>> mTimeMap = new HashMap<String, List<String>>();

	Map<String, JSONObject> mDayOptionsMap = new HashMap<String, JSONObject>(), mTimeOptionsMap = new HashMap<String, JSONObject>();
	
	ShippingTimeSelectedListener mSelectedListener;
	
	public void setTimeSelectedListener(ShippingTimeSelectedListener timeSelectedListener){
		mSelectedListener = timeSelectedListener;
	}

	public ShoppShippingTimeDialog(Context context, JSONObject shippingTime) {
		super(context);
		// TODO Auto-generated constructor stub
		mContext = context;
		mWindow = getWindow();
		mWindow.setBackgroundDrawableResource(backgroundRes());
		mShippingTime = shippingTime;
		this.setContentView(init());
		this.setCanceledOnTouchOutside(true);
		parseShippingTime();
	}

	@Override
	protected int backgroundRes() {
		return R.color.transparent;
	}

	@Override
	protected View init() {
		LinearLayout view = null;
		try {
			view = (LinearLayout) LayoutInflater.from(mContext).inflate(R.layout.dialog_order_confirm_shippingtime, null);

			view.findViewById(R.id.cancel).setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					dismiss();
				}
			});
			view.findViewById(R.id.finish).setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					returnSelectedTime();
					dismiss();
				}
			});

			mTime1LoopView = (WheelView) view.findViewById(R.id.time1);
			mTime2LoopView = (WheelView) view.findViewById(R.id.time2);
			mTime3LoopView = (WheelView) view.findViewById(R.id.time3);

			mTime1LoopView.addChangingListener(this);
			mTime2LoopView.addChangingListener(this);
		} catch (Exception e) {
			// TODO: handle exception
			Log.w(Run.TAG, e.getMessage());
		}
		return view;
	}

	public void returnSelectedTime(){
		if (mSelectedListener != null) {
			String nTypeName = mTypeList.get(mTime1LoopView.getCurrentItem());
			String nTypeValue = mDayOptionsMap.get(nTypeName).optString("value");
			String nDate = "";
			
			if (nTypeValue.equals("special")) {
				String nTimeDisplay = mTimeList.get(mTime3LoopView.getCurrentItem());
				String nTimeValue = mTimeOptionsMap.get(nTimeDisplay).optString("value");
				String nTime = nTimeValue.equals("上午")?" 08:00-12:00":(nTimeValue.equals("下午")?" 12:00-18:00":" 18:00-22:00");
				nDate = mDayList.get(mTime2LoopView.getCurrentItem()) + nTime;
			}else{
				String nTimeDisplay = mTimeList.get(mTime3LoopView.getCurrentItem());
				String nTimeValue = mTimeOptionsMap.get(nTimeDisplay).optString("value");
				nDate = nTimeValue;
			}
			
			mSelectedListener.selected(nTypeValue, nDate);
		}
	}
	
	@Override
	protected float widthScale() {
		return 1;
	}

	@Override
	protected int gravity() {
		// TODO Auto-generated method stub
		return Gravity.BOTTOM;
	}

	void parseShippingTime() {
		mTypeList = new ArrayList<String>();
		mDayList = new ArrayList<String>();
		mDayDisplayList = new ArrayList<String>();
		mTimeList = new ArrayList<String>();
		
		if (mShippingTime == null) {
			return;
		}

		JSONArray nDaysOptionArray = mShippingTime.optJSONArray("days_options");
		if (nDaysOptionArray == null || nDaysOptionArray.length() <= 0) {
			return;
		}
		for (int i = 0; i < nDaysOptionArray.length(); i++) {
			JSONObject nJsonObject = nDaysOptionArray.optJSONObject(i);
			String nName = nJsonObject.optString("name");
			mDayOptionsMap.put(nName, nJsonObject);
			mTypeList.add(nName);
		}

		List<String> nTimeOptionList = new ArrayList<String>();
		JSONArray nTimesOptionArray = mShippingTime.optJSONArray("times_options");
		if (nTimesOptionArray == null || nTimesOptionArray.length() <= 0) {
			return;
		}
		for (int i = 0; i < nTimesOptionArray.length(); i++) {
			JSONObject nJsonObject = nTimesOptionArray.optJSONObject(i);
			String nName = nJsonObject.optString("name");
			mTimeOptionsMap.put(nName, nJsonObject);
			nTimeOptionList.add(nName);
		}

		int nBeginTime = mShippingTime.optInt("begin_time");
		int nEndTime = mShippingTime.optInt("end_time");

		long nOneHour = 60 * 60 * 1000;
		long nOneDay = 24 * nOneHour;
		long nBeginDateLong = mShippingTime.optLong("begin_day") * 1000;
		long nEndDateLong = mShippingTime.optLong("end_day") * 1000;
		long nTodayDayLong = nBeginDateLong / nOneDay;
		long nTodayHourLong = Long.parseLong(StringUtils.LongTimeToString("HH", nBeginDateLong));

		for (String string : mTypeList) {
			if (string.equals("指定日期")) {
				while (nBeginDateLong / nOneDay < nEndDateLong / nOneDay) {

					long nDayLong = nBeginDateLong / nOneDay;
					List<String> nItemList = new ArrayList<String>();
					if (nDayLong == nTodayDayLong) {// 今天
						for (String string2 : nTimeOptionList) {
							if ((string2.equals("上午") && nBeginTime < 12 && nTodayHourLong < nBeginTime) || (string2.equals("下午") && nBeginTime < 18 && nEndTime > 12 && nTodayHourLong < 12)
									|| (string2.equals("晚上") && nBeginTime < 22 && nEndTime > 18 && nTodayHourLong < 18)) {
								nItemList.add(string2);
							}
						}

					} else {// 其他时间
						for (String string2 : nTimeOptionList) {
							if ((string2.equals("上午") && nBeginTime < 12) || (string2.equals("下午") && nBeginTime < 18 && nEndTime > 12) || (string2.equals("晚上") && nBeginTime < 22 && nEndTime > 18)) {
								nItemList.add(string2);
							}
						}
					}

					if (nItemList.size() > 0) {
						Date nDate = new Date(nBeginDateLong);
						String nShortTime = StringUtils.LongTimeToString("yyyy-MM-dd", nBeginDateLong);
						String nDateString = String.format("%s(%s)", nShortTime, StringUtils.DateToWeek(nDate));
						mDayDisplayList.add(nDateString);
						mDayList.add(nShortTime);
						mTimeMap.put(nShortTime, nItemList);
					}

					nBeginDateLong += nOneDay;
				}
			} else {
				List<String> nItemList = new ArrayList<String>();
				for (String string2 : nTimeOptionList) {
					if ((string2.equals("上午") && nBeginTime < 12) || (string2.equals("下午") && nBeginTime < 18 && nEndTime > 12) || (string2.equals("晚上") && nBeginTime < 22 && nEndTime > 18)
							|| (string2.equals("任意时间段"))) {
						nItemList.add(string2);
					}
				}

				if (nItemList.size() > 0) {
					mTimeMap.put(string, nItemList);
				}
			}
		}

		String[] nTypeStrings = new String[mTypeList.size()];
		mTypeList.toArray(nTypeStrings);
		mTime1LoopView.setViewAdapter(new ArrayWheelAdapter<String>(mContext, nTypeStrings));
		mTime1LoopView.setCurrentItem(0);
		onChanged(mTime1LoopView, 0, 0);
	}

	@Override
	public void onChanged(WheelView wheel, int oldValue, int newValue) {
		// TODO Auto-generated method stub
		if (wheel == mTime1LoopView) {
			if (mTypeList.get(newValue).equals("指定日期")) {
				mTime2LoopView.setVisibility(View.VISIBLE);

				String[] nTypeStrings = new String[mDayDisplayList.size()];
				mDayDisplayList.toArray(nTypeStrings);
				mTime2LoopView.setViewAdapter(new ArrayWheelAdapter<String>(mContext, nTypeStrings));
				mTime2LoopView.setCurrentItem(0);
				onChanged(mTime2LoopView, 0, 0);
			} else {
				mTime2LoopView.setVisibility(View.GONE);

				mTimeList.clear();
				mTimeList.addAll(mTimeMap.get(mTypeList.get(newValue)));
				String[] nTypeStrings = new String[mTimeList.size()];
				mTimeList.toArray(nTypeStrings);
				mTime3LoopView.setViewAdapter(new ArrayWheelAdapter<String>(mContext, nTypeStrings));
				mTime3LoopView.setCurrentItem(0);
			}
		} else if (wheel == mTime2LoopView) {
			mTimeList.clear();
			mTimeList.addAll(mTimeMap.get(mDayList.get(newValue)));
			String[] nTypeStrings = new String[mTimeList.size()];
			mTimeList.toArray(nTypeStrings);
			mTime3LoopView.setViewAdapter(new ArrayWheelAdapter<String>(mContext, nTypeStrings));
			mTime3LoopView.setCurrentItem(0);
		}
	}
	
	public interface ShippingTimeSelectedListener{
		/**
		 * @param typeValue
		 * @param date
		 */
		void selected(String typeValue, String date);
	}
}
