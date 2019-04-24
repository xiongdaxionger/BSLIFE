package com.qianseit.westore.bean.member;

import com.qianseit.westore.bean.BaseBean;

/**
 * @author qianseit
 *{
        "member": {
            "member_id": "32622",
            "uname": "18588880154",
            "local_uname": null,
            "name": "",
            "sex": "女",
            "point": 115169,
            "usage_point": 115169,//会员积分
            "experience": "5020",//经验值
            "email": null,
            "member_lv": "3",
            "member_cur": "CNY",
            "advance": "99994960.000",//会员余额
            "levelname": "VIP会员",//会员等级
            "un_pay_orders": 5,//待付款订单数
            "un_ship_orders": 5,//待发货订单数
            "un_received_orders": 5,//待收货订单数
            "un_discuss_orders": 0,//待评论订单数
            "aftersales_orders": 0,//待评论订单数
            "prepare_pay_orders": 3,//售后订单数
            "sto_goods_num": 0,//到货通知
            "un_readAskMsg": 0,//咨询回复数
            "un_readDiscussMsg": 0,//评论回复数
            "un_readMsg": 18//未读数
            "favorite_num":10//商品收藏总数
            "has_pay_password":true//是否有预存款支付密码
        }
    },
 "comment_switch_discuss": "on",//开启商品咨询
"comment_switch_ask": "on",//开启商品评论
"deposit_status": "true",//开启预存款
 */
public class Member extends BaseBean {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1435895784569783605L;

	String member_id = "";
	String uname = "";
	String local_uname = "";
	String name = "";
	String sex = "";
	int point = 0;
	int usage_point = 0;
	int experience = 0;
	String email = "";
	String member_lv_id = "";
	String member_lv = "";
	String member_cur = "";
	String cur = "";
	String advance = "";
	String pay_password = "";
	String lang = "";
	String levelname = "";
	String avatar = "";




	boolean has_pay_password = false;
	String coupon_num = "";
	int un_pay_orders = 0;
	int un_ship_orders = 0;
	int un_received_orders = 0;
	int un_discuss_orders = 0;
	int aftersales_orders = 0;
	int prepare_pay_orders = 0;
	int sto_goods_num = 0;
	int un_readAskMsg = 0;
	int un_readDiscussMsg = 0;
	int un_readMsg = 0;
	int favorite_num = 0;
	int cart_number = 0;
	int cart_count = 0;

	int access_num = 0;

	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getUname() {
		return uname;
	}
	public void setUname(String uname) {
		this.uname = uname;
	}
	public String getLocal_uname() {
		return local_uname;
	}
	public void setLocal_uname(String local_uname) {
		this.local_uname = local_uname;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public int getPoint() {
		return point;
	}
	public void setPoint(int point) {
		this.point = point;
	}
	/**
	 * @return
	 * 会员积分
	 */
	public int getUsage_point() {
		return usage_point;
	}
	/**
	 * @param usage_point
	 * 会员积分
	 */
	public void setUsage_point(int usage_point) {
		this.usage_point = usage_point;
	}
	/**
	 * @return
	 * 经验值
	 */
	public int getExperience() {
		return experience;
	}
	/**
	 * @param experience
	 * 经验值
	 */
	public void setExperience(int experience) {
		this.experience = experience;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getMember_lv_id() {
		return member_lv_id;
	}
	public void setMember_lv_id(String member_lv_id) {
		this.member_lv_id = member_lv_id;
	}
	public String getMember_lv() {
		return member_lv;
	}
	public void setMember_lv(String member_lv) {
		this.member_lv = member_lv;
	}
	public String getMember_cur() {
		return member_cur;
	}
	public void setMember_cur(String member_cur) {
		this.member_cur = member_cur;
	}
	public String getCur() {
		return cur;
	}
	public void setCur(String cur) {
		this.cur = cur;
	}
	/**
	 * @return
	 * 会员余额
	 */
	public String getAdvance() {
		return advance;
	}
	/**
	 * @param advance
	 * 会员余额
	 */
	public void setAdvance(String advance) {
		this.advance = advance;
	}
	public String getPay_password() {
		return pay_password;
	}
	public void setPay_password(String pay_password) {
		this.pay_password = pay_password;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
	/**
	 * @return
	 * 会员等级
	 */
	public String getLevelname() {
		return levelname;
	}
	/**
	 * @param levelname
	 * 会员等级
	 */
	public void setLevelname(String levelname) {
		this.levelname = levelname;
	}
	/**
	 * @return
	 * 是否有预存款支付密码
	 */
	public boolean isHas_pay_password() {
		return has_pay_password;
	}
	/**
	 * @param has_pay_password
	 * 是否有预存款支付密码
	 */
	public void setHas_pay_password(boolean has_pay_password) {
		this.has_pay_password = has_pay_password;
	}
	/**
	 * @return
	 * 待付款订单数
	 */
	public int getUn_pay_orders() {
		return un_pay_orders;
	}
	/**
	 * @param un_pay_orders
	 * 待付款订单数
	 */
	public void setUn_pay_orders(int un_pay_orders) {
		this.un_pay_orders = un_pay_orders;
	}
	/**
	 * @return
	 * 待发货订单数
	 */
	public int getUn_ship_orders() {
		return un_ship_orders;
	}
	/**
	 * @param un_ship_orders
	 * 待发货订单数
	 */
	public void setUn_ship_orders(int un_ship_orders) {
		this.un_ship_orders = un_ship_orders;
	}
	/**
	 * @return
	 * 待收货订单数
	 */
	public int getUn_received_orders() {
		return un_received_orders;
	}
	/**
	 * @param un_received_orders
	 * 待收货订单数
	 */
	public void setUn_received_orders(int un_received_orders) {
		this.un_received_orders = un_received_orders;
	}
	/**
	 * @return
	 * 待评论订单数
	 */
	public int getUn_discuss_orders() {
		return un_discuss_orders;
	}
	/**
	 * @param un_discuss_orders
	 * 待评论订单数
	 */
	public void setUn_discuss_orders(int un_discuss_orders) {
		this.un_discuss_orders = un_discuss_orders;
	}
	/**
	 * @return
	 * 待评论订单数
	 */
	public int getAftersales_orders() {
		return aftersales_orders;
	}
	/**
	 * @param aftersales_orders
	 * 待评论订单数
	 */
	public void setAftersales_orders(int aftersales_orders) {
		this.aftersales_orders = aftersales_orders;
	}
	/**
	 * @return
	 * 售后订单数
	 */
	public int getPrepare_pay_orders() {
		return prepare_pay_orders;
	}
	/**
	 * @param prepare_pay_orders
	 * 售后订单数
	 */
	public void setPrepare_pay_orders(int prepare_pay_orders) {
		this.prepare_pay_orders = prepare_pay_orders;
	}
	/**
	 * @return
	 * 到货通知
	 */
	public int getSto_goods_num() {
		return sto_goods_num;
	}
	/**
	 * @param sto_goods_num
	 * 到货通知
	 */
	public void setSto_goods_num(int sto_goods_num) {
		this.sto_goods_num = sto_goods_num;
	}
	/**
	 * @return
	 * 咨询回复数
	 */
	public int getUn_readAskMsg() {
		return un_readAskMsg;
	}
	/**
	 * @param un_readAskMsg
	 * 咨询回复数
	 */
	public void setUn_readAskMsg(int un_readAskMsg) {
		this.un_readAskMsg = un_readAskMsg;
	}
	/**
	 * @return
	 * 评论回复数
	 */
	public int getUn_readDiscussMsg() {
		return un_readDiscussMsg;
	}
	/**
	 * @param un_readDiscussMsg
	 * 评论回复数
	 */
	public void setUn_readDiscussMsg(int un_readDiscussMsg) {
		this.un_readDiscussMsg = un_readDiscussMsg;
	}
	/**
	 * @return
	 * 未读数
	 */
	public int getUn_readMsg() {
		return un_readMsg;
	}
	/**
	 * @param un_readMsg
	 * 未读数
	 */
	public void setUn_readMsg(int un_readMsg) {
		this.un_readMsg = un_readMsg;
	}
	/**
	 * @return
	 * 商品收藏总数
	 */
	public int getFavorite_num() {
		return favorite_num;
	}
	/**
	 * @param favorite_num
	 * 商品收藏总数
	 */
	public void setFavorite_num(int favorite_num) {
		this.favorite_num = favorite_num;
	}
	public String getAvatar() {
		return avatar;
	}
	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}
	public String getCoupon_num() {
		return coupon_num;
	}
	public void setCoupon_num(String coupon_num) {
		this.coupon_num = coupon_num;
	}
	/**
	 * @return
	 * 购物车数量
	 */
	public int getCart_number() {
		return cart_number;
	}
	/**
	 * @param cart_number
	 * 购物车数量
	 */
	public void setCart_number(int cart_number) {
		this.cart_number = cart_number;
	}
	/**
	 * @return
	 * 购物车种类
	 */
	public int getCart_count() {
		return cart_count;
	}
	/**
	 * @param cart_count
	 * 购物车种类
	 */
	public void setCart_count(int cart_count) {
		this.cart_count = cart_count;
	}

	public int getAccess_num() {
		return access_num;
	}

	public void setAccess_num(int access_num) {
		this.access_num = access_num;
	}

	public void clear(){
		setAdvance("0");
		setAftersales_orders(0);
		setAvatar("");
		setCart_count(0);
		setCart_number(0);
		setCoupon_num("0");
		setCur("");
		setEmail("");
		setExperience(0);
		setFavorite_num(0);
		setHas_pay_password(false);
		setLang("");
		setLevelname("");
		setLocal_uname("");
		setMember_cur("");
		setMember_id("");
		setMember_lv("");
		setMember_lv_id("");
		setName("");
		setPay_password("");
		setPoint(0);
		setPrepare_pay_orders(0);
		setSex("");
		setSto_goods_num(0);
		setUn_discuss_orders(0);
		setUn_pay_orders(0);
		setUn_readAskMsg(0);
		setUn_readDiscussMsg(0);
		setUn_readMsg(0);
		setUn_received_orders(0);
		setUn_ship_orders(0);
		setUname("");
		setUsage_point(0);
		setAccess_num(0);
	}
}
