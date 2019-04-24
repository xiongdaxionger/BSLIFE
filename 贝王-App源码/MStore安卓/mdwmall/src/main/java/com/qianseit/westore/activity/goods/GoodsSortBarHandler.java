package com.qianseit.westore.activity.goods;

import android.content.ContentValues;

public interface GoodsSortBarHandler {
	void onSortConditionChanged(ContentValues basicnContentValues);
	int parentWidth();
	void beginShowPopup();
}
