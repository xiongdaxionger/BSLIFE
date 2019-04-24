package com.qianseit.westore.base;

import android.content.Context;

public interface QianseitActivityInterface {
	void showLoadingDialog();
	void showCancelableLoadingDialog();
	void hideLoadingDialog();
	void hideLoadingDialog_mt();
	Context getContext();
}
