package com.qianseit.westore.base;

import com.beiwangfx.R;
import android.app.Dialog;
import android.content.Context;
import android.view.Display;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

abstract public class BaseDialog extends Dialog{

	protected Context mContext;
	protected Window mWindow;
	
	public BaseDialog(Context context) {
		super(context, R.style.Theme_dialog);
		// TODO Auto-generated constructor stub
	}

	abstract protected View init();
	
	/**
	 * 显示位置：居中、靠上、靠下、靠左、靠右
	 * @see Gravity
	 * @return
	 */
	protected int gravity(){
		return Gravity.CENTER;
	}
	
	/**
	 * @return
	 */
	protected int backgroundRes(){
		return R.color.white;
	}
	
	/**
	 * @return
	 */
	protected int animations(){
		return R.anim.push_up_in;
	}
	
	/**
	 * 宽度占屏比0~1
	 * @return
	 */
	protected float widthScale(){
		return 0.7f;
	}

//	/**
//	 * 宽度占屏比0~1
//	 * @return
//	 */
//	protected float heightScale(){
//		return 0.7f;
//	}

	@Override
	public void show() {
		// TODO Auto-generated method stub
		mWindow.setGravity(gravity());
		mWindow.setWindowAnimations(animations());
		super.show();
		WindowManager wm = (WindowManager) mContext.getSystemService(Context.WINDOW_SERVICE);
		Display display = wm.getDefaultDisplay();
		WindowManager.LayoutParams lp = this.getWindow().getAttributes();
		lp.width = (int) (display.getWidth() * widthScale()); // 设置宽度
//		lp.height = (int) (display.getHeight() * heightScale()); // 设置宽度
		mWindow.setAttributes(lp);
	}
}
