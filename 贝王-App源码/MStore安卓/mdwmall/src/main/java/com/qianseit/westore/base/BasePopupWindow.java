package com.qianseit.westore.base;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.View;
import android.widget.PopupMenu;
import android.widget.PopupWindow;

public abstract class BasePopupWindow extends PopupWindow {
	protected Context mContext;
	View mView;

	public BasePopupWindow(Context context) {
		mContext = context;
		mView = initContentView(mContext);
		this.setContentView(mView);
	}

	@Override
	public void dismiss() {
		super.dismiss();
		onDismiss();
	}

	@Override
	public void showAtLocation(View parent, int gravity, int x, int y) {
		onBeforeShow();
		super.showAtLocation(parent, gravity, x, y);
	}

	@Override
	public void showAsDropDown(View anchor) {
		// TODO Auto-generated method stub
		onBeforeShow();
		super.showAsDropDown(anchor);
	}

	@Override
	public void showAsDropDown(View anchor, int xoff, int yoff) {
		// TODO Auto-generated method stub
		onBeforeShow();
		super.showAsDropDown(anchor, xoff, yoff);
	}

	@SuppressLint("NewApi")
	@Override
	public void showAsDropDown(View anchor, int xoff, int yoff, int gravity) {
		// TODO Auto-generated method stub
		onBeforeShow();
		super.showAsDropDown(anchor, xoff, yoff, gravity);
	}

	/**
	 * 可以在popup显示前做一些预处理，如主画面半透明效果等
	 */
	protected void onBeforeShow() {
	}

	/**
	 * 可以在popup隐藏做一些预处理，如主画面取消半透明效果等
	 */
	protected void onDismiss() {
	}

	/**
	 * 初始化画面
	 * @return
	 */
	protected abstract View initContentView(Context context);
}
