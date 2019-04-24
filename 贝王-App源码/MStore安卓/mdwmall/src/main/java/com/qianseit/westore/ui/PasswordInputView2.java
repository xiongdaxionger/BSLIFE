package com.qianseit.westore.ui;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.FontMetrics;
import android.graphics.Paint.FontMetricsInt;
import android.graphics.Rect;
import android.graphics.RectF;
import android.text.InputType;
import android.util.AttributeSet;
import android.widget.EditText;

import com.beiwangfx.R;

/**
 * Desc: User: tiansj
 */
public class PasswordInputView2 extends EditText {

	private int textLength;

	private int borderColor;
	private float borderWidth;
	private float borderRadius;

	private int passwordLength;
	private int passwordColor;
	private float passwordWidth;
	private float passwordRadius;

	private Paint passwordPaint = new Paint(android.graphics.Paint.ANTI_ALIAS_FLAG);
	private Paint borderPaint = new Paint(android.graphics.Paint.ANTI_ALIAS_FLAG);
	private Paint textPaint;

	private int defaultContMargin = 2;
	private final int defaultSplitLineWidth = 2;

	public PasswordInputView2(Context context, AttributeSet attrs) {
		super(context, attrs);
		final Resources res = getResources();

		final int defaultBorderColor = res.getColor(R.color.default_ev_border_color);
		final float defaultBorderWidth = res.getDimension(R.dimen.default_ev_border_width);
		final float defaultBorderRadius = res.getDimension(R.dimen.default_ev_border_radius);

		final int defaultPasswordLength = res.getInteger(R.integer.default_ev_password_length);
		final int defaultPasswordColor = res.getColor(R.color.default_ev_password_color);
		final float defaultPasswordWidth = res.getDimension(R.dimen.default_ev_password_width);
		final float defaultPasswordRadius = res.getDimension(R.dimen.default_ev_password_radius);

		TypedArray a = context.getTheme().obtainStyledAttributes(attrs, R.styleable.PasswordInputView, 0, 0);
		try {
			borderColor = a.getColor(R.styleable.PasswordInputView_borderColor, defaultBorderColor);
			borderWidth = a.getDimension(R.styleable.PasswordInputView_borderWidth, defaultBorderWidth);
			borderRadius = a.getDimension(R.styleable.PasswordInputView_borderRadiusPW, defaultBorderRadius);
			passwordLength = a.getInt(R.styleable.PasswordInputView_passwordLength, defaultPasswordLength);
			passwordColor = a.getColor(R.styleable.PasswordInputView_passwordColor, defaultPasswordColor);
			passwordWidth = a.getDimension(R.styleable.PasswordInputView_passwordWidth, defaultPasswordWidth);
			passwordRadius = a.getDimension(R.styleable.PasswordInputView_passwordRadius, defaultPasswordRadius);
		} finally {
			a.recycle();
		}

//		defaultContMargin = (int) borderWidth;

		borderPaint.setStrokeWidth(borderWidth);
		borderPaint.setColor(borderColor);
		passwordPaint.setStrokeWidth(passwordWidth);
		passwordPaint.setStyle(Paint.Style.FILL);
		passwordPaint.setColor(passwordColor);

		textPaint = getPaint();
	}

	@SuppressLint("DrawAllocation")
	@Override
	protected void onDraw(Canvas canvas) {
		int width = getWidth();
		int height = getHeight();

		// 外边框
		RectF rect = new RectF(0, 0, width, height);
		borderPaint.setColor(borderColor);
		canvas.drawRoundRect(rect, borderRadius, borderRadius, borderPaint);

		// 内容区
		RectF rectIn = new RectF(rect.left + defaultContMargin, rect.top + defaultContMargin, rect.right - defaultContMargin, rect.bottom - defaultContMargin);
		borderPaint.setColor(Color.WHITE);
		canvas.drawRoundRect(rectIn, borderRadius, borderRadius, borderPaint);

		// 分割线
		borderPaint.setColor(borderColor);
		borderPaint.setStrokeWidth(defaultSplitLineWidth);
		for (int i = 1; i < passwordLength; i++) {
			float x = width * i / passwordLength;
			canvas.drawLine(x, 0, x, height, borderPaint);
		}

		// 密码
		float cx, cy = height / 2;
		float half = width / passwordLength / 2;

		// // 画字符或密文
		if (this.getInputType() == (InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_VARIATION_PASSWORD)
				|| this.getInputType() == (InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD)
				|| this.getInputType() == (InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_WEB_PASSWORD)
				|| this.getInputType() == (InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD)) {
			// 密码 画圆
			for (int i = 0; i < textLength; i++) {
				cx = width * i / passwordLength + half;
				canvas.drawCircle(cx, cy, passwordWidth, passwordPaint);
			}

		} else {
			String nTextString = super.getText().toString();
			for (int i = 0; i < textLength; i++) {
				String nPaintTextString = nTextString.substring(i, i + 1);
				paintText(canvas, nPaintTextString, textPaint, passwordLength, width, half, height, i);
			}
		}
	}

	void paintText(Canvas canvas, String nString, Paint paint, int textMaxLength, int viewWidth, float half, int height, int i) {
		float cx = viewWidth * i / passwordLength + half - paint.measureText(nString) / 2;
		Rect targetRect = new Rect(textMaxLength * i / passwordLength, 0, textMaxLength * i / passwordLength, height);
		FontMetricsInt fontMetrics = paint.getFontMetricsInt();
		int baseline = targetRect.top + (targetRect.bottom - targetRect.top - fontMetrics.bottom + fontMetrics.top) / 2 - fontMetrics.top;
		canvas.drawText(nString, cx, baseline, paint);
	}

	public int getFontHeight(float fontSize) {
		Paint paint = new Paint();
		paint.setTextSize(fontSize);
		FontMetrics fm = paint.getFontMetrics();
		return (int) Math.ceil(fm.descent - fm.top) + 2;
	}

	@Override
	protected void onTextChanged(CharSequence text, int start, int lengthBefore, int lengthAfter) {
		super.onTextChanged(text, start, lengthBefore, lengthAfter);
		this.textLength = text.toString().length();
		invalidate();
	}

	public int getBorderColor() {
		return borderColor;
	}

	public void setBorderColor(int borderColor) {
		this.borderColor = borderColor;
		borderPaint.setColor(borderColor);
		invalidate();
	}

	public float getBorderWidth() {
		return borderWidth;
	}

	public void setBorderWidth(float borderWidth) {
		this.borderWidth = borderWidth;
		borderPaint.setStrokeWidth(borderWidth);
		invalidate();
	}

	public float getBorderRadius() {
		return borderRadius;
	}

	public void setBorderRadius(float borderRadius) {
		this.borderRadius = borderRadius;
		invalidate();
	}

	public int getPasswordLength() {
		return passwordLength;
	}

	public void setPasswordLength(int passwordLength) {
		this.passwordLength = passwordLength;
		invalidate();
	}

	public int getPasswordColor() {
		return passwordColor;
	}

	public void setPasswordColor(int passwordColor) {
		this.passwordColor = passwordColor;
		passwordPaint.setColor(passwordColor);
		invalidate();
	}

	public float getPasswordWidth() {
		return passwordWidth;
	}

	public void setPasswordWidth(float passwordWidth) {
		this.passwordWidth = passwordWidth;
		passwordPaint.setStrokeWidth(passwordWidth);
		invalidate();
	}

	public float getPasswordRadius() {
		return passwordRadius;
	}

	public void setPasswordRadius(float passwordRadius) {
		this.passwordRadius = passwordRadius;
		invalidate();
	}

}
