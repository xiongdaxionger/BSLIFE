package com.qianseit.westore.base.adpter;

import com.qianseit.westore.base.bean.RadioBarBean;

public interface RadioBarCallback {
	int parentWindowsWidth();
	void onSelectedRadioBarChanged(RadioBarBean selectedRadioBean);
	void onClickRadioBar(RadioBarBean selectedRadioBean);
	boolean showRadioBarsDivider();
	boolean highlightSelectedRadioBar();
	int defualtSelectRadioBarId();

}
