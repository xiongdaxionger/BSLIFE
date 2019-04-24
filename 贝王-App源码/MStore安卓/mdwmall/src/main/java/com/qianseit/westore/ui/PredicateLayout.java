package com.qianseit.westore.ui;

import java.util.Hashtable;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

/**
 * 此控件为自动换行控件
 * 
 */
public class PredicateLayout extends ViewGroup {
	int mLeft, mRight, mTop, mBottom;
	Hashtable<View, Position> map = new Hashtable<View, Position>();
	private final static int DEFAULT_DIVIDORCOL = 10;
	int currentmaxChildHight;
	
    
	/**
	 * 每个view上下的间距
	 */
	private final int dividerLine = 20;
	/**
	 * 每个view左右的间距
	 */
	private int dividerCol = DEFAULT_DIVIDORCOL;

	public PredicateLayout(Context context) {
		super(context);
	}

	public PredicateLayout(Context context, int horizontalSpacing,
			int verticalSpacing) {
		super(context);
	}

	public PredicateLayout(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		System.out.println("onMeasure() onMeasure()");

		int mWidth = MeasureSpec.getSize(widthMeasureSpec);
		int mCount = getChildCount();
		mLeft = 10;
		mRight = 10;
		mTop = 10;
		mBottom = 0;

		int j = 0;

		for (int i = 0; i < mCount; i++) {
			final View child = getChildAt(i);
			//计算每个子控件的宽和高
			child.measure(MeasureSpec.UNSPECIFIED, MeasureSpec.UNSPECIFIED);
			// 此处增加onlayout中的换行判断，用于计算所需的高度
			int childw = child.getMeasuredWidth();
			int childh = child.getMeasuredHeight();
			
			
			mRight += childw; // 将每次子控件宽度进行统计叠加，如果大于设定的宽度则需要换行，高度即Top坐标也需重新设置

			Position position = new Position();
			mLeft = getPosition(i - j, i);
			mRight = mLeft + child.getMeasuredWidth();
			if (mRight >= mWidth) {//超过一行则进行换行同时对每个child间隙进行平均分配
				j = i;
				mLeft = getPaddingLeft() + dividerCol-DEFAULT_DIVIDORCOL;
				mRight = mLeft + child.getMeasuredWidth();
				if(currentmaxChildHight<childh){
					mTop += currentmaxChildHight + dividerLine;
				}else{
					mTop += childh + dividerLine;
				}
				// PS：如果发现高度还是有问题就得自己再细调了
			}
			
			if(i==0){
				currentmaxChildHight = childh;
			}else{
				if(currentmaxChildHight<=childh){
					currentmaxChildHight = childh;
				}
			}
			mBottom = mTop + currentmaxChildHight;
			// mY = mTop; //每次的高度必须记录 否则控件会叠加到一起
			// mX = mRight;
			position.left = mLeft;
			position.top = mTop;
			position.right = mRight;
			position.bottom = mBottom;
			map.put(child, position);
		}
		setMeasuredDimension(mWidth, mBottom + getPaddingBottom());
	}
	@Override
	protected LayoutParams generateDefaultLayoutParams() {
		return new LayoutParams(30, 30); // default of 1px spacing
	}

	@Override
	protected void onLayout(boolean changed, int l, int t, int r, int b) {
		int count = getChildCount();
		for (int i = 0; i < count; i++) {
			View child = getChildAt(i);
			Position pos = map.get(child);
			if (pos != null) {
				child.layout(pos.left, pos.top, pos.right, pos.bottom);
			} else {
				Log.i("MyLayout", "error");
			}
		}
	}

	private class Position {
		int left, top, right, bottom;
	}

	public int getPosition(int IndexInRow, int childIndex) {
		if (IndexInRow > 0) {
			return getPosition(IndexInRow - 1, childIndex - 1)
					+ getChildAt(childIndex - 1).getMeasuredWidth()
					+ dividerCol;
		}
		return getPaddingLeft();
	}
}

