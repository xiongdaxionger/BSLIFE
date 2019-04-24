package com.qianseit.westore.ui.pull;

import android.content.Context;
import android.util.AttributeSet;

import com.baoyz.swipemenulistview.SwipeMenuListView;
import com.qianseit.westore.bean.Pullable;

public class PullableTopListView extends SwipeMenuListView implements Pullable
{

	public PullableTopListView(Context context)
	{
		super(context);
	}

	public PullableTopListView(Context context, AttributeSet attrs)
	{
		super(context, attrs);
	}

	public PullableTopListView(Context context, AttributeSet attrs, int defStyle)
	{
		super(context, attrs, defStyle);
	}

	@Override
	public boolean canPullDown()
	{
			return false;
	}

	@Override
	public boolean canPullUp()
	{
		if (getCount() == 0)
		{
			// 没有item的时候也可以上拉加载
			return false;
		} else if (getLastVisiblePosition() == (getCount() - 1))
		{
			// 滑到底部了


			if (getChildAt(getLastVisiblePosition() - getFirstVisiblePosition()) != null
					&& getChildAt(
							getLastVisiblePosition()
									- getFirstVisiblePosition()).getBottom() <= getMeasuredHeight())
				return true;
		}
		return false;
	}
}
