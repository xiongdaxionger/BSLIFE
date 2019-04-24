package com.qianseit.westore.ui;

import java.util.Timer;
import java.util.TimerTask;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.beiwangfx.R;

@SuppressLint("HandlerLeak")
public class RushBuyCountDownTimerView extends LinearLayout {
	/**
	 * 黑底白字
	 */
	public static final int STYLE_DARK = 1;
	/**
	 * 灰边框、黑字、白底
	 */
	public static final int STYLE_DARK_ROUND = 2;
	/**
	 * 白底黑字
	 */
	public static final int STYLE_WHITE = 3;
	/**
	 * 白色边框、白字
	 */
	public static final int STYLE_WHITE_ROUND = 4;

	private TextView tv_hour_unit, tv_hour_colon;
	private TextView tv_min_unit, tv_min_colon;
	private TextView tv_sec_unit;
	private TextView tv_day_unit, tv_day_colon;
	private TextView tv_end;
	private LinearLayout linear_day_unit;
	private Context context;
	CountDownTimerListener mCountDownTimerListener;

	// ��ʱ��
	private Timer timer;

	private Handler handler = new Handler() {

		public void handleMessage(Message msg) {
			countDown();
		}
	};

	public void setOnCountDownTimerListener(CountDownTimerListener downTimerListener) {
		mCountDownTimerListener = downTimerListener;
	}

	public RushBuyCountDownTimerView(Context context, AttributeSet attrs) {
		super(context, attrs);

		this.context = context;
		LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View view = inflater.inflate(R.layout.view_countdowntimer, this);
		tv_hour_unit = (TextView) view.findViewById(R.id.tv_hour_unit);
		tv_min_unit = (TextView) view.findViewById(R.id.tv_min_unit);
		tv_sec_unit = (TextView) view.findViewById(R.id.tv_sec_unit);
		tv_hour_colon = (TextView) view.findViewById(R.id.tv_hour_unit_tip);
		tv_min_colon = (TextView) view.findViewById(R.id.tv_min_unit_tip);
		tv_day_colon = (TextView) view.findViewById(R.id.tv_day_unit_tip);
		tv_end = (TextView) view.findViewById(R.id.tv_end);
		if (!isInEditMode()) {
			linear_day_unit = (LinearLayout) view.findViewById(R.id.linear_day_unit);
		}
		if (!isInEditMode()) {
			tv_day_unit = (TextView) view.findViewById(R.id.tv_day_unit);
		}
	}

	public void setCountdownStyle(int style){
		int nTimeColor = getResources().getColor(R.color.white);
		int nColonColor = getResources().getColor(R.color.westore_gray_textcolor);
		int nTimeBgRes = R.drawable.shape_countdown_dark_time;
		int nEndColor = getResources().getColor(R.color.westore_second_gray_textcolor);
		switch (style) {
		case STYLE_DARK:
			nTimeColor = getResources().getColor(R.color.white);
			nColonColor = getResources().getColor(R.color.westore_gray_textcolor);
			nTimeBgRes = R.drawable.shape_countdown_dark_time;
			nEndColor = getResources().getColor(R.color.westore_second_gray_textcolor);
			break;
		case STYLE_DARK_ROUND:
			nTimeColor = getResources().getColor(R.color.westore_dark_textcolor);
			nColonColor = getResources().getColor(R.color.westore_dark_textcolor);
			nTimeBgRes = R.drawable.shape_countdown_dark_round_time;
			nEndColor = getResources().getColor(R.color.westore_second_gray_textcolor);
			break;
		case STYLE_WHITE:
			nTimeColor = getResources().getColor(R.color.westore_dark_textcolor);
			nColonColor = getResources().getColor(R.color.white);
			nTimeBgRes = R.drawable.shape_countdown_white_time;
			nEndColor = getResources().getColor(R.color.westore_second_gray_textcolor);
			break;
		case STYLE_WHITE_ROUND:
			nTimeColor = getResources().getColor(R.color.white);
			nColonColor = getResources().getColor(R.color.white);
			nTimeBgRes = R.drawable.shape_countdown_white_round_time;
			nEndColor = getResources().getColor(R.color.westore_second_gray_textcolor);
			break;

		default:
			break;
		}
		
		tv_hour_unit.setTextColor(nTimeColor);
		tv_min_unit.setTextColor(nTimeColor);
		tv_sec_unit.setTextColor(nTimeColor);
		tv_day_unit.setTextColor(nTimeColor);

		tv_hour_colon.setTextColor(nColonColor);
		tv_min_colon.setTextColor(nColonColor);
		tv_day_colon.setTextColor(nColonColor);

		tv_end.setTextColor(nEndColor);
		
		tv_hour_unit.setBackgroundResource(nTimeBgRes);
		tv_min_unit.setBackgroundResource(nTimeBgRes);
		tv_sec_unit.setBackgroundResource(nTimeBgRes);
		tv_day_unit.setBackgroundResource(nTimeBgRes);
		
		tv_hour_unit.setPadding(10, 0, 10, 0);
		tv_day_unit.setPadding(10, 0, 10, 0);
		tv_sec_unit.setPadding(10, 0, 10, 0);
		tv_min_unit.setPadding(10, 0, 10, 0);
	}
	
	/**
	 * 
	 * @Description: ��ʼ��ʱ
	 * @param
	 * @return void
	 * @throws
	 */
	public void start() {
		tv_hour_unit.setVisibility(View.VISIBLE);
		tv_min_unit.setVisibility(View.VISIBLE);
		tv_sec_unit.setVisibility(View.VISIBLE);
		findViewById(R.id.tv_hour_unit_tip).setVisibility(View.VISIBLE);
		findViewById(R.id.tv_min_unit_tip).setVisibility(View.VISIBLE);
		findViewById(R.id.tv_end).setVisibility(View.GONE);
		if (timer == null) {
			timer = new Timer();
			timer.schedule(new TimerTask() {

				@Override
				public void run() {
					handler.sendEmptyMessage(0);
				}
			}, 0, 1000);
		}
	}

	/**
	 * 
	 * @Description: ֹͣ��ʱ
	 * @param
	 * @return void
	 * @throws
	 */
	public void stop() {
		if (timer != null) {
			timer.cancel();
			timer = null;
		}

		if (mCountDownTimerListener != null) {
			mCountDownTimerListener.CountDownTimeEnd();
		}
	}

	/**
	 * @throws Exception
	 * 
	 * @Description: ���õ���ʱ��ʱ��
	 * @param
	 * @return void
	 * @throws
	 */
	public boolean setTime(int day, int hour, int min, int sec) {
		stop();

		if (day < 0 || min >= 60 || sec >= 60 || hour < 0 || min < 0 || sec < 0 || (hour == 0 && min == 0 && sec == 0)) {
			tv_hour_unit.setVisibility(View.GONE);
			tv_min_unit.setVisibility(View.GONE);
			tv_sec_unit.setVisibility(View.GONE);
			findViewById(R.id.linear_day_unit).setVisibility(View.GONE);
			findViewById(R.id.tv_hour_unit_tip).setVisibility(View.GONE);
			findViewById(R.id.tv_min_unit_tip).setVisibility(View.GONE);
			findViewById(R.id.tv_end).setVisibility(View.VISIBLE);

			tv_hour_unit.setText("00");
			tv_min_unit.setText("00");
			tv_sec_unit.setText("00");
			tv_day_unit.setText("00");
			stop();

			return false;
		} else {
			if (day == 0) {
				linear_day_unit.setVisibility(View.GONE);
			} else {
				linear_day_unit.setVisibility(View.VISIBLE);
			}
			tv_hour_unit.setText(hour / 10 == 0 ? ("0" + hour + "") : (hour + ""));
			tv_min_unit.setText(min / 10 == 0 ? ("0" + min + "") : (min + ""));
			tv_sec_unit.setText(sec / 10 == 0 ? ("0" + sec + "") : (sec + ""));
			tv_day_unit.setText(day / 10 == 0 ? ("0" + day + "") : (day + ""));
			return true;
		}

	}

	/**
	 * @throws Exception
	 * 
	 * @Description: ���õ���ʱ��ʱ��
	 * @param
	 * @return void
	 * @throws
	 */
	public boolean setTime(long countDownTimeSec, long currentTimeSec) {
		int min = 0;
		int hour = 0;
		int sec = 0;
		int day = 0;
		long time = countDownTimeSec - currentTimeSec;
		sec = (int) time;
		if (sec > 60) {
			min = sec / 60;
			sec = sec % 60;
		}
		if (time > 60) {
			hour = min / 60;
			min = min % 60;
		}

		return setTime(day, hour, min, sec);
	}

	/**
	 * 
	 * @Description: ����ʱ
	 * @param
	 * @return boolean
	 * @throws
	 */
	private void countDown() {

		if (isUnit(tv_sec_unit)) {
			if (isUnit(tv_min_unit)) {

				if (isHourUnit(tv_hour_unit)) {
					if (isUnit(tv_day_unit)) {
						tv_hour_unit.setVisibility(View.GONE);
						tv_min_unit.setVisibility(View.GONE);
						tv_sec_unit.setVisibility(View.GONE);
						findViewById(R.id.linear_day_unit).setVisibility(View.GONE);
						findViewById(R.id.tv_hour_unit_tip).setVisibility(View.GONE);
						findViewById(R.id.tv_min_unit_tip).setVisibility(View.GONE);
						findViewById(R.id.tv_end).setVisibility(View.VISIBLE);

						tv_hour_unit.setText("00");
						tv_min_unit.setText("00");
						tv_sec_unit.setText("00");
						tv_day_unit.setText("00");
						stop();
					}
				}
			}
		}

	}

	private boolean isUnit(TextView tv) {
		int time = Integer.valueOf(tv.getText().toString());
		time = time - 1;
		if (time < 0) {
			time = 59;
			tv.setText(time + "");
			return true;
		} else {
			tv.setText(time / 10 == 0 ? ("0" + time + "") : (time + ""));
			return false;
		}
	}

	private boolean isHourUnit(TextView tv) {
		int time = Integer.valueOf(tv.getText().toString());
		time = time - 1;
		if (time < 0) {
			time = 23;
			tv.setText(time + "");
			return true;
		} else {
			tv.setText(time / 10 == 0 ? ("0" + time + "") : (time + ""));
			return false;
		}
	}

	public interface CountDownTimerListener {
		void CountDownTimeEnd();
	}

}
