package com.qianseit.westore.bean.member;

import com.qianseit.westore.bean.BaseBean;

public class MemberIndex extends BaseBean {

	/**
	 * 
	 */
	private static final long serialVersionUID = 720219888022501989L;
	String comment_switch_discuss;
	String comment_switch_ask;
	String deposit_status;
	boolean prepare_status;
	boolean distribution_status;
	Member member;
	MemberLv switch_lv;
	String shopname; ///昵称前缀
	String referrals_url; ///邀请注册链接

	public String getReferrals_url() {
		return referrals_url;
	}

	public void setReferrals_url(String referrals_url) {
		this.referrals_url = referrals_url;
	}

	/**
	 * @return
	 * 开启商品咨询
	 */
	public String getComment_switch_discuss() {
		return comment_switch_discuss;
	}
	/**
	 * @param comment_switch_discuss
	 * 开启商品咨询
	 */
	public void setComment_switch_discuss(String comment_switch_discuss) {
		this.comment_switch_discuss = comment_switch_discuss;
	}
	/**
	 * @return
	 * 开启商品评论
	 */
	public String getComment_switch_ask() {
		return comment_switch_ask;
	}
	/**
	 * @param comment_switch_ask
	 * 开启商品评论
	 */
	public void setComment_switch_ask(String comment_switch_ask) {
		this.comment_switch_ask = comment_switch_ask;
	}
	/**
	 * @return
	 * 开启预存款
	 */
	public String getDeposit_status() {
		return deposit_status;
	}
	/**
	 * @param deposit_status
	 * 开启预存款
	 */
	public void setDeposit_status(String deposit_status) {
		this.deposit_status = deposit_status;
	}
	public Member getMember() {
		return member;
	}

	public String getShopname() {
		return shopname;
	}

	public void setShopname(String shopname) {
		this.shopname = shopname;
	}
	public void setMember(Member member) {
		this.member = member;
	}
	public MemberLv getSwitch_lv() {
		return switch_lv;
	}
	public void setSwitch_lv(MemberLv switch_lv) {
		this.switch_lv = switch_lv;
	}
	public boolean isPrepare_status() {
		return prepare_status;
	}
	public void setPrepare_status(boolean prepare_status) {
		this.prepare_status = prepare_status;
	}
	public boolean isDistribution_status() {
		return distribution_status;
	}
	public void setDistribution_status(boolean distribution_status) {
		this.distribution_status = distribution_status;
	}

	public void clear(){
		setComment_switch_ask("");
		setComment_switch_discuss("");
		setDeposit_status("");
		setDistribution_status(false);
		setPrepare_status(false);
		member.clear();
		switch_lv.clear();
		setShopname("");
	}
}
