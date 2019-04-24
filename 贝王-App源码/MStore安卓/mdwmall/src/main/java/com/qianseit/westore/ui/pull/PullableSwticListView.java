package com.qianseit.westore.ui.pull;

import android.content.Context;
import android.util.AttributeSet;

import com.baoyz.swipemenulistview.SwipeMenuListView;
import com.qianseit.westore.bean.Pullable;

public class PullableSwticListView extends SwipeMenuListView implements Pullable {
	public PullableSwticListView(Context context) {
		super(context);
	}

	public PullableSwticListView(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public PullableSwticListView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}

	@Override
	public boolean canPullDown() {
		if (getChildAt(0) == null)
			return true;
		if (getCount() == 0) {
			// 没有item的时候也可以下拉刷新
			return true;
		} else // 滑到ListView的顶部了
			return getFirstVisiblePosition() == 0 && getChildAt(0).getTop() >= 0;
	}

	@Override
	public boolean canPullUp() {
		if (getCount() == 0) {
			// 没有item的时候也可以上拉加载
			return false;
		} else if (getLastVisiblePosition() == (getCount() - 1)) {
			// 滑到底部了
			if (getChildAt(getLastVisiblePosition() - getFirstVisiblePosition()) != null && getChildAt(getLastVisiblePosition() - getFirstVisiblePosition()).getBottom() <= getMeasuredHeight())
				return true;
		}
		return false;
	}
}