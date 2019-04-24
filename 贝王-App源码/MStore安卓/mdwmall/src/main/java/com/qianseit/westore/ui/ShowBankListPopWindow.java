package com.qianseit.westore.ui;

import com.beiwangfx.R;
import com.qianseit.westore.Run;
import com.qianseit.westore.util.Util;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.Point;
import android.graphics.drawable.ColorDrawable;
import android.support.v4.app.FragmentActivity;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

public class ShowBankListPopWindow extends PopupWindow {
	private FragmentActivity context;
	private ListView listView;
	private String[] arrayList;
	private OnItemBankClicklistener clicklistener;

	public ShowBankListPopWindow(FragmentActivity activity) {
		this.context = activity;
		arrayList = activity.getResources().getStringArray(R.array.bank_array);
		listView = new ListView(activity);
		listView.setCacheColorHint(Color.TRANSPARENT);
		listView.setAdapter(new MyAdapter());
		setContentView(listView);
		Point screenSize = Run.getScreenSize(activity.getWindowManager());
		setWidth(screenSize.x / 2);
		// 设置SelectPicPopupWindow弹出窗体可点击
		this.setFocusable(true);
		this.setOutsideTouchable(true);
		// 设置SelectPicPopupWindow弹出窗体的高
		this.setHeight(LayoutParams.WRAP_CONTENT);
		// 实例化一个ColorDrawable颜色为半透明
		ColorDrawable dw = new ColorDrawable(0000000000);
		// 点back键和其他地方使其消失,设置了这个才能触发OnDismisslistener ，设置其他控件变化等操作
		this.setBackgroundDrawable(dw);
		listView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				clicklistener.onItem(arrayList[position]);
				dismiss();
			}
		});
	}

	public void showPopupWindow(View parent, OnItemBankClicklistener listener) {
		if (!this.isShowing()) {
			// this.showAsDropDown(parent, parent.getLayoutParams().width / 2,
			// 18);
			this.clicklistener = listener;
			showAsDropDown(parent);
		} else {
			this.dismiss();
		}
	}

	private class MyAdapter extends BaseAdapter {

		@Override
		public int getCount() {
			return arrayList.length;
		}

		@Override
		public Object getItem(int position) {
			return null;
		}

		@Override
		public long getItemId(int position) {
			return 0;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			convertView = context.getLayoutInflater().inflate(
					R.layout.item_textview, null);
			TextView tvName = (TextView) convertView.findViewById(R.id.tv_name);
			tvName.setText(arrayList[position]);
			return convertView;
		}

	}

	public OnItemBankClicklistener setOnItemBankClicklistener() {
		return clicklistener;
	}

	public interface OnItemBankClicklistener {
		void onItem(String item);
	}

}
