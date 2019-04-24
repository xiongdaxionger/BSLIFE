package com.qianseit.westore.ui;

import com.beiwangfx.R;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.View;
import android.widget.GridView;

public class LineGridView extends GridView {
	int mLineColor;
	public LineGridView(Context context) {
		super(context);
		mLineColor = context.getResources().getColor(R.color.text_goods_f3_color);
	}

	public LineGridView(Context context, AttributeSet attrs) {
		super(context, attrs);
		mLineColor = context.getResources().getColor(R.color.text_goods_f3_color);
	}

	public LineGridView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		mLineColor = context.getResources().getColor(R.color.text_goods_f3_color);
	}

	protected void dispatchDraw(Canvas canvas) {
		super.dispatchDraw(canvas);
		if (getChildAt(0) != null) {
			View localView1 = getChildAt(0);
			int column =  getWidth() / localView1.getWidth();
			int childCount = getChildCount();
			int row = 0;
			if (childCount % column == 0) {
				row = childCount / column;
			} else {
				row = childCount / column + 1;
			}
			int endAllcolumn = (row - 1) * column;
			Paint localPaint, localPaint2;
			localPaint = new Paint();
			localPaint2 = new Paint();
			localPaint.setStyle(Paint.Style.STROKE);
			localPaint2.setStyle(Paint.Style.STROKE);
			localPaint.setStrokeWidth(1);
			localPaint2.setStrokeWidth(1);
			localPaint.setColor(mLineColor);
			localPaint2.setColor(mLineColor);
			for (int i = 0; i < childCount; i++) {
				View cellView = getChildAt(i);
//				if ((i + 1) % column != 0) {
					canvas.drawLine(cellView.getRight(), cellView.getTop(), cellView.getRight(), cellView.getBottom(), localPaint);
					canvas.drawLine(cellView.getRight() + 1, cellView.getTop(), cellView.getRight() + 1, cellView.getBottom(), localPaint2);
//				}
//				if ((i + 1) <= endAllcolumn) {
					canvas.drawLine(cellView.getLeft(), cellView.getBottom(), cellView.getRight(), cellView.getBottom(), localPaint);
					canvas.drawLine(cellView.getLeft(), cellView.getBottom() + 1, cellView.getRight(), cellView.getBottom() + 1, localPaint2);
//				}
				
				if (i % column == 0) {
					canvas.drawLine(cellView.getLeft(), cellView.getTop(), cellView.getLeft(), cellView.getBottom(), localPaint);
					canvas.drawLine(cellView.getLeft() + 1, cellView.getTop(), cellView.getLeft() + 1, cellView.getBottom(), localPaint2);
				}
				
//				if (i / column == 0) {
//					canvas.drawLine(cellView.getLeft(), cellView.getTop(), cellView.getRight(), cellView.getTop(), localPaint);
//					canvas.drawLine(cellView.getLeft(), cellView.getTop() + 1, cellView.getRight(), cellView.getTop() + 1, localPaint2);
//				}
				
//				if (i / column + 1 == row) {
//					canvas.drawLine(cellView.getLeft(), cellView.getBottom() - 1, cellView.getRight(), cellView.getBottom() - 1, localPaint);
//				}
			}
//			if (childCount % column != 0) {
//				for (int j = 0; j < (column - childCount % column); j++) {
//					View lastView = getChildAt(childCount - 1);
//					canvas.drawLine(lastView.getRight() + lastView.getWidth() * j, lastView.getTop(), lastView.getRight() + lastView.getWidth() * j, lastView.getBottom(), localPaint);
//					canvas.drawLine(lastView.getRight() + lastView.getWidth() * j + 1, lastView.getTop(), lastView.getRight() + lastView.getWidth() * j + 1, lastView.getBottom(), localPaint2);
//				}
//			}
		}
	}
}