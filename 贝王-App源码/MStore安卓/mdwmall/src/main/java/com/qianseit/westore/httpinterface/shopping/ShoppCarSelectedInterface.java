package com.qianseit.westore.httpinterface.shopping;



import android.content.ContentValues;

import com.qianseit.westore.base.QianseitActivityInterface;

import java.util.Set;

public abstract class ShoppCarSelectedInterface extends BaseShoppCarInterface {

	final String mSelectedIdentName = "obj_ident[%d]";
	protected ContentValues mSelectedContentValues = new ContentValues();
	public ShoppCarSelectedInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.cart.select_cart_item";
	}

	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		if (mSelectedContentValues.size() > 0) {
			nContentValues.putAll(mSelectedContentValues);
		}
		return nContentValues;
	}
	
	/**
	 * 重置，即清空缓存的已选中项
	 */
	public void reset(){
		mSelectedContentValues.clear();
	}
	
	/**
	 * @param goodsIdent
	 */
	public void addSelected(String goodsIdent){
		Set<String> nStrings = mSelectedContentValues.keySet();
		for (String string : nStrings) {
			if (mSelectedContentValues.getAsString(string).equals(goodsIdent)) {
				return;
			}
		}
		
		mSelectedContentValues.put(String.format(mSelectedIdentName, mSelectedContentValues.size()), goodsIdent);
	}
}
