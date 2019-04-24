package com.qianseit.westore.ui;

import java.util.Calendar;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.view.Display;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.DatePicker.OnDateChangedListener;
import android.widget.FrameLayout;
import android.widget.LinearLayout;

import com.qianseit.westore.Run;
import com.beiwangfx.R;

public class MyAlertDialog {
	private Context context;
	private Dialog dialog;

	private Display display;
	private LinearLayout lLayout_bg;
	private DatePicker datePicker;
	private int year, newYear, month, newMonth, day, newDay;
	private Button btn_pos, btn_neg;

	public MyAlertDialog(Context context) {
		this.context = context;
		WindowManager windowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
		display = windowManager.getDefaultDisplay();
	}

	public MyAlertDialog builder() {
		View view = LayoutInflater.from(context).inflate(R.layout.dialog_data_select, null);

		lLayout_bg = (LinearLayout) view.findViewById(R.id.lLayout_bg);
		btn_pos = (Button) view.findViewById(R.id.btn_pos);
		btn_neg = (Button) view.findViewById(R.id.btn_calcel);

		DatePicker datePicker = (DatePicker) view.findViewById(R.id.datePicker);
		dialog = new Dialog(context, R.style.dialog_name);
		dialog.setContentView(view);
		Window windwos = dialog.getWindow();
		LayoutParams layoutParams = windwos.getAttributes();
		layoutParams.width = LayoutParams.MATCH_PARENT;
		windwos.getAttributes().gravity = Gravity.BOTTOM;

		Calendar c = Calendar.getInstance();
		newYear = c.get(Calendar.YEAR);
		newMonth = c.get(Calendar.MONTH);
		newDay = c.get(Calendar.DAY_OF_MONTH);
		year=newYear;
		month=newMonth+1;
		day=newDay;
		datePicker.init(newYear, newMonth, newDay, new OnDateChangedListener() {

			@Override
			public void onDateChanged(DatePicker arg0, int year, int month, int day) {
				MyAlertDialog.this.year = year;
				MyAlertDialog.this.month = month+1;
				MyAlertDialog.this.day = day;
				// 显示当前日期、时间

				if (isDateAfter(arg0)) {
					arg0.init(newYear, newMonth, newDay, this);
				}else if (isDateBefore(arg0)) {
					arg0.init(newYear, newMonth, newDay, this);
				}else if (isDateDayBefore(arg0)) {
					arg0.init(newYear, newMonth, newDay, this);
				}
			}
		});

		return this;
	}

	private boolean isDateAfter(DatePicker tempView) {
		return tempView.getYear() > newYear;
	}

	private boolean isDateBefore(DatePicker tempView) {
		return tempView.getYear() == newYear && tempView.getMonth() > newMonth;
	}

	private boolean isDateDayBefore(DatePicker tempView) {
		return tempView.getYear() == newYear && tempView.getMonth() == newMonth && tempView.getDayOfMonth() > newDay;
	}

	public String getResult() {
		return year + "-" + month + "-" + day;
	}

	public MyAlertDialog setMsg(String msg) {

		return this;
	}

	public MyAlertDialog setCancelable(boolean cancel) {
		dialog.setCancelable(cancel);
		return this;
	}



	public void show() {
		dialog.show();
	}

	public MyAlertDialog setPositiveButton(String text, final OnClickListener listener) {
		if ("".equals(text)) {
			btn_pos.setText("确定");
		} else {
			btn_pos.setText(text);
		}
		btn_pos.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				listener.onClick(v);
				dialog.dismiss();
			}
		});
		return this;
	}

	public MyAlertDialog setNegativeButton(String text, final OnClickListener listener) {
		if ("".equals(text)) {
			btn_neg.setText("取消");
		} else {
			btn_neg.setText(text);
		}
		btn_neg.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				listener.onClick(v);
				dialog.dismiss();
			}
		});
		return this;
	}
}
