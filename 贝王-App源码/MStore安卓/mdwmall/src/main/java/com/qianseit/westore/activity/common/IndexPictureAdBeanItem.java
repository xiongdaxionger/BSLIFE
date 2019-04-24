package com.qianseit.westore.activity.common;


public class IndexPictureAdBeanItem {
	public float width;
	public float height;
	public int order;
	public String imageUrl;
	/**
	 * 'product'=>'货品', 'gallery'=>'分类商品列表', 'goods_cat'=>'分类列表',
	 * 'recharge'=>'充值页面', 'virtual_cat'=>'虚拟分类商品列表', 'article'=>'文章',
	 * 'yiy'=>'摇一摇', 'signin'=>'签到', 'starbuy'=>'秒杀专区', 'custom'=>'自定义链接'
	 */
	public String type;
	public String typeValue;
	
	public int realScreenWidth;
	public int definedWidth;
	
	public float left = 0;
	public float top = 0;
	
	public IndexPictureAdBeanItem(int order, float width, float height, String type, String typevalue, String imageUrl){
		this.width = width;
		this.order = order;
		this.height = height;
		this.type = type;
		this.typeValue = typevalue;
		this.imageUrl = imageUrl;
	}
	
	public int getRealWidth(){
		float nRealWidth = width * realScreenWidth / definedWidth;
		if (definedWidth - width - left < 1) {
			return (int) Math.ceil(nRealWidth);
		}else{
			return Math.round(nRealWidth);
		}
	}
	
	public int getRealHeight(){
		return Math.round(height * realScreenWidth / definedWidth);
	}
	public int getRealLeft(){
		return (int) Math.ceil(left * realScreenWidth / definedWidth);
	}
	public int getRealTop(){
		return (int) Math.ceil(top * realScreenWidth / definedWidth);
	}
}
