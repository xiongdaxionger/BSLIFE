package com.qianseit.westore.util;

import android.text.InputType;
import android.text.method.NumberKeyListener;

public class ListenterUtils {
	public static NumberKeyListener IdentityListener = new NumberKeyListener() {
		protected char[] getAcceptedChars()
		{
			char[] numberChars = { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'X' ,'x'};
			return numberChars;
		}
		@Override
		public int getInputType() {
			return InputType.TYPE_CLASS_TEXT;
		}
	};
}
