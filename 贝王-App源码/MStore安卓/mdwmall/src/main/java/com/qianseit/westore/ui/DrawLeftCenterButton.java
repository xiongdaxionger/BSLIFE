package com.qianseit.westore.ui;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.ViewDebug.CapturedViewProperty;
import android.widget.Button;

import com.qianseit.westore.AgentApplication;

public class DrawLeftCenterButton extends Button {

    public DrawLeftCenterButton(Context context) {
        super(context);
        this.setTypeface(AgentApplication.getApp(getContext()).getTypeface());
    }

    public DrawLeftCenterButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.setTypeface(AgentApplication.getApp(getContext()).getTypeface());
    }

    public DrawLeftCenterButton(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        this.setTypeface(AgentApplication.getApp(getContext()).getTypeface());
    }

    @Override
    @CapturedViewProperty
    public CharSequence getText() {

        return super.getText();
    }

    /* (非 Javadoc)
    * <p>Title: onDraw</p>
    * <p>Description: </p>
    * @param canvas
    * @see android.widget.TextView#onDraw(android.graphics.Canvas)
    */
    @Override
    protected void onDraw(Canvas canvas) {
        // TODO 自动生成的方法存根
        Drawable[] drawables = getCompoundDrawables();
        Drawable drawableLeft = drawables[0];
        if (drawableLeft != null) {
            float textWidth = getPaint().measureText(getText().toString());
            int drawablePadding = getCompoundDrawablePadding();
            int drawableWidth = 0;
            drawableWidth = drawableLeft.getIntrinsicWidth();
            float bodyWidth = textWidth + drawableWidth + drawablePadding;
            canvas.translate((getWidth() - bodyWidth) / 2, 0);
        }
        super.onDraw(canvas);
    }
}
