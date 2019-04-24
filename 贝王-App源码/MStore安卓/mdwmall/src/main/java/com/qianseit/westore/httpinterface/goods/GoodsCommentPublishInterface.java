package com.qianseit.westore.httpinterface.goods;

import android.content.ContentValues;
import android.text.TextUtils;

import com.qianseit.westore.base.QianseitActivityInterface;
import com.qianseit.westore.httpinterface.BaseHttpInterfaceTask;

/**
 * @author admin
 * 2.14 发表商品评论
 */
public abstract class GoodsCommentPublishInterface extends BaseHttpInterfaceTask {
	String mGoodsId;
	String mProductId;
	String mOrderId;
	
	String mCommentContent;
	String mVCode;
	boolean mAnonymous = true;
	
	ContentValues mImageContentValues = new ContentValues();
	ContentValues mPointContentValues = new ContentValues();

	public GoodsCommentPublishInterface(QianseitActivityInterface activityInterface) {
		super(activityInterface);
		// TODO Auto-generated constructor stub
	}
	
	@Override
	public ContentValues BuildParams() {
		// TODO Auto-generated method stub
		ContentValues nContentValues = new ContentValues();
		nContentValues.put("goods_id", mGoodsId);
		nContentValues.put("product_id", mProductId);
		nContentValues.put("comment", mCommentContent);
		nContentValues.put("order_id", mOrderId);
		if (!TextUtils.isEmpty(mVCode)) {
			nContentValues.put("discussverifyCode", mVCode);
		}
		nContentValues.put("hidden_name", mAnonymous ? "YES" : "NO");
		nContentValues.putAll(mPointContentValues);
		if (mImageContentValues.size() > 0) {
			nContentValues.putAll(mImageContentValues);
		}
		
		return nContentValues;
	}
	
	public void setGoods(String goodsId, String productId, String orderId){
		mGoodsId = goodsId;
		mProductId = productId;
		mOrderId = orderId;
		
		mImageContentValues.clear();
		mPointContentValues.clear();
		
		mAnonymous = true;
		mCommentContent = "";
		mVCode = "";
	}
	
	/**
	 * @param imageShortUrl 没有域名的图片路径
	 */
	public void addImage(String imageShortUrl){
		mImageContentValues.put(String.format("images[%d]", mImageContentValues.size()), imageShortUrl);
	}
	
	/**
	 * @param point
	 */
	public void addPoint(double point){
		mPointContentValues.put(String.format("point_type[%d][point]", mPointContentValues.size()), String.format("%.1f", point));
	}
	
	public void comment(String commentContent, String vcode, boolean anonymous){
		mCommentContent = commentContent;
		mVCode = vcode;
		mAnonymous = anonymous;
		
		RunRequest();
	}

	@Override
	public String InterfaceName() {
		// TODO Auto-generated method stub
		return "b2c.comment.toDiscuss";
	}
}
