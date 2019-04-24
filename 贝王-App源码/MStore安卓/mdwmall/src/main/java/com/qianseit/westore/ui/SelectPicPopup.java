package com.qianseit.westore.ui;

import com.beiwangfx.R;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.PopupWindow;

@SuppressLint("ViewConstructor")
public class SelectPicPopup extends PopupWindow implements OnClickListener {

	private View mMenuView;

	OnClickListener yesOnClickListener;

	/**
	 * @return yesOnClickListener
	 */
	public OnClickListener getYesOnClickListener() {
		return yesOnClickListener;
	}

	/**
	 * @param yesOnClickListener
	 */
	public void setYesOnClickListener(OnClickListener yesOnClickListener) {
		this.yesOnClickListener = yesOnClickListener;
	}

	String mMessageString;

	/**
	 * @return mMessageString
	 */
	public String getmMessageString() {
		return mMessageString;
	}

	/**
	 * @param mMessageString
	 */
	public void setmMessageString(String messageString) {
		this.mMessageString = messageString;
	}

	String mTitleString;

	public SelectPicPopup(Context context) {
		super(context);
		try {
			LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			mMenuView = inflater.inflate(R.layout.select_pic_popup, null);
			mMenuView.findViewById(R.id.btn_take_photo).setOnClickListener(this);
			mMenuView.findViewById(R.id.btn_pick_photo).setOnClickListener(this);
			mMenuView.findViewById(R.id.btn_cancel).setOnClickListener(this);

			mMenuView.setOnTouchListener(new OnTouchListener() {

				public boolean onTouch(View v, MotionEvent event) {

//					int height = mMenuView.findViewById(R.id.pop_layout).getTop();
//					int y = (int) event.getY();
//					if (event.getAction() == MotionEvent.ACTION_UP) {
//						if (y < height) {
//							dismiss();
//						}
//					}
					return true;
				}
			});

			// 设置按钮监听
			// mPictureButton.setOnClickListener(itemsOnClick);
			// mVideoButton.setOnClickListener(itemsOnClick);
			// 设置SelectPicPopupWindow的View
			this.setContentView(mMenuView);
			this.setFocusable(true);
			this.setWindowLayoutMode(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);

		} catch (Exception e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
		}
	}

	/*
	 * (非 Javadoc) <p>Title: onClick</p> <p>Description: </p>
	 * 
	 * @param v
	 * 
	 * @see android.view.View.OnClickListener#onClick(android.view.View)
	 */
	@Override
	public void onClick(View v) {
		// TODO 自动生成的方法存根
		switch (v.getId()) {
		case R.id.btn_take_photo:

			break;
		case R.id.btn_pick_photo:

			break;
		case R.id.btn_cancel:
			this.dismiss();
			break;

		default:
			break;
		}
	}
}