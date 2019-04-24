package com.qianseit.westore.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.Window;

import com.qianseit.westore.activity.acco.AccoAboutFragment;
import com.qianseit.westore.activity.acco.AccoBindMobileFragment;
import com.qianseit.westore.activity.acco.AccoBindMobileThridFragment;
import com.qianseit.westore.activity.acco.AccoCouponFragment;
import com.qianseit.westore.activity.acco.AccoCouponInstructionsFragment;
import com.qianseit.westore.activity.acco.AccoDistributionFrament;
import com.qianseit.westore.activity.acco.AccoEditItemFragment;
import com.qianseit.westore.activity.acco.AccoFeedbackFragment;
import com.qianseit.westore.activity.acco.AccoForgetBusinessPasswdFragment;
import com.qianseit.westore.activity.acco.AccoForgetPasswdFragment;
import com.qianseit.westore.activity.acco.AccoHelpCenterFragment;
import com.qianseit.westore.activity.acco.AccoJoinFragment;
import com.qianseit.westore.activity.acco.AccoLvFragment;
import com.qianseit.westore.activity.acco.AccoMyMessageFragment;
import com.qianseit.westore.activity.acco.AccoNameFragment;
import com.qianseit.westore.activity.acco.AccoPersonalInfoFragment;
import com.qianseit.westore.activity.acco.AccoPointsFragment;
import com.qianseit.westore.activity.acco.AccoPwdManagerFragment;
import com.qianseit.westore.activity.acco.AccoRecommendFragment;
import com.qianseit.westore.activity.acco.AccoResetBusinessPasswdFragment;
import com.qianseit.westore.activity.acco.AccoResetPasswdFragment;
import com.qianseit.westore.activity.acco.AccoServiceFragment;
import com.qianseit.westore.activity.acco.AccoSettingBusinessPasswdFragment;
import com.qianseit.westore.activity.acco.AccoSettingFragment;
import com.qianseit.westore.activity.acco.AccoSysMessageFragment;
import com.qianseit.westore.activity.acco.AccountAddVipFragment;
import com.qianseit.westore.activity.acco.AccountNewCustomerFragment;
import com.qianseit.westore.activity.acco.AccountTwoCodeFragment;
import com.qianseit.westore.activity.address.AccountAddressAddFragment;
import com.qianseit.westore.activity.address.AddressBookFragment;
import com.qianseit.westore.activity.address.MyAddresPickerFragment;
import com.qianseit.westore.activity.address.MyAddressPickerStreetFragment;
import com.qianseit.westore.activity.aftermarket.AftermarketAllOrdersFragment;
import com.qianseit.westore.activity.aftermarket.AftermarketNoticeFragment;
import com.qianseit.westore.activity.aftermarket.AftermarketRefundFragment;
import com.qianseit.westore.activity.aftermarket.AftermarketReturnGoodsFragment;
import com.qianseit.westore.activity.common.CommExpressoFragment;
import com.qianseit.westore.activity.common.CommRegArticleFragment;
import com.qianseit.westore.activity.common.CommonLoginFragment;
import com.qianseit.westore.activity.common.CommonRegisterFragment;
import com.qianseit.westore.activity.common.CommonRegisterHintFragment;
import com.qianseit.westore.activity.common.CommonRegisterStepOneFragment;
import com.qianseit.westore.activity.common.CommonRegisterStepThreeFragment;
import com.qianseit.westore.activity.common.CommonRegisterStepTwoFragment;
import com.qianseit.westore.activity.community.CommDiscoverCommentFragment;
import com.qianseit.westore.activity.community.CommDiscoverFragment;
import com.qianseit.westore.activity.community.CommDiscoverNoteListFragment;
import com.qianseit.westore.activity.goods.GoodsAccessRecordFragment;
import com.qianseit.westore.activity.goods.GoodsArrivalNoticeFragment;
import com.qianseit.westore.activity.goods.GoodsCollectionFragment;
import com.qianseit.westore.activity.goods.GoodsCommentFragment;
import com.qianseit.westore.activity.goods.GoodsCommentPublishFragment;
import com.qianseit.westore.activity.goods.GoodsConsultFragment;
import com.qianseit.westore.activity.goods.GoodsConsultPublishFragment;
import com.qianseit.westore.activity.goods.GoodsConsultReplyFragment;
import com.qianseit.westore.activity.goods.GoodsDetailFragment;
import com.qianseit.westore.activity.goods.GoodsImagesPreviewFragment;
import com.qianseit.westore.activity.goods.GoodsListFragment;
import com.qianseit.westore.activity.goods.GoodsSearchFragment;
import com.qianseit.westore.activity.goods.GoodsSpoorFragment;
import com.qianseit.westore.activity.goods.GoodsTwoDCodeFragment;
import com.qianseit.westore.activity.marketing.MarketingActivityFragment;
import com.qianseit.westore.activity.marketing.MarketingCouponCenterFragment;
import com.qianseit.westore.activity.marketing.MarketingInviteRegistFragment;
import com.qianseit.westore.activity.marketing.MarketingShakeFragment;
import com.qianseit.westore.activity.marketing.MarketingSignInFragment;
import com.qianseit.westore.activity.news.NewsAssetsFragment;
import com.qianseit.westore.activity.news.NewsCenterFragment;
import com.qianseit.westore.activity.news.NewsMarketingFragment;
import com.qianseit.westore.activity.news.NewsOrderFragment;
import com.qianseit.westore.activity.news.NewsPublicNoticeFragment;
import com.qianseit.westore.activity.news.NewsSystemMainFragment;
import com.qianseit.westore.activity.order.OrderDetailFragment;
import com.qianseit.westore.activity.order.OrderFragment;
import com.qianseit.westore.activity.order.OrderSegementFragment;
import com.qianseit.westore.activity.order.OrderUtils;
import com.qianseit.westore.activity.other.ArticleReaderFragment;
import com.qianseit.westore.activity.partner.PartnerDetailFragment;
import com.qianseit.westore.activity.partner.PartnerListFragment;
import com.qianseit.westore.activity.passport.MultiItemFragment;
import com.qianseit.westore.activity.passport.PrivaceFragment;
import com.qianseit.westore.activity.passport.RegistrationProtocolFragment;
import com.qianseit.westore.activity.passport.SingleItemFragment;
import com.qianseit.westore.activity.recommend.RecommendAttentionAddFragment;
import com.qianseit.westore.activity.recommend.RecommendAttentionFragment;
import com.qianseit.westore.activity.recommend.RecommendAttentionSearchFragment;
import com.qianseit.westore.activity.recommend.RecommendCollectFragment;
import com.qianseit.westore.activity.recommend.RecommendCommentFragment;
import com.qianseit.westore.activity.recommend.RecommendFansFragment;
import com.qianseit.westore.activity.recommend.RecommendGoodCommentFragment;
import com.qianseit.westore.activity.recommend.RecommendPhotoFragment;
import com.qianseit.westore.activity.recommend.RecommendPraiseFragment;
import com.qianseit.westore.activity.recommend.RecommendTelBookFragment;
import com.qianseit.westore.activity.shopping.InvoiceEditorFragment;
import com.qianseit.westore.activity.shopping.ShoppCarOneFragment;
import com.qianseit.westore.activity.shopping.ShoppGoodsTogetherFragment;
import com.qianseit.westore.activity.shopping.ShoppSecKillFragment;
import com.qianseit.westore.activity.shopping.ShoppingChooseFreagment;
import com.qianseit.westore.activity.shopping.ShoppingCommendedLanguageActivity;
import com.qianseit.westore.activity.shopping.ShoppingConfirmOrderFragment;
import com.qianseit.westore.activity.shopping.ShoppingExpressPickFragment;
import com.qianseit.westore.activity.shopping.ShoppingGoodsCommentFragment;
import com.qianseit.westore.activity.shopping.ShoppingLogisticsFragment;
import com.qianseit.westore.activity.shopping.ShoppingPayMethodFragment;
import com.qianseit.westore.activity.shopping.ShoppingPromotionsFragment;
import com.qianseit.westore.activity.shopping.ShoppingSinceAddress;
import com.qianseit.westore.activity.shopping.ShoppingSpecificStoreFragment;
import com.qianseit.westore.activity.shopping.ShoppingStoreFragment;
import com.qianseit.westore.activity.shopping.ShoppingStoreInfoFragment;
import com.qianseit.westore.activity.shopping.ShoppingStoreTimeFragment;
import com.qianseit.westore.activity.statistics.StatisticsChartActivity;
import com.qianseit.westore.activity.wealth.WealthBankCardAddFragment;
import com.qianseit.westore.activity.wealth.WealthBankCardFragment;
import com.qianseit.westore.activity.wealth.WealthBankChooseFragment;
import com.qianseit.westore.activity.wealth.WealthBillFragment;
import com.qianseit.westore.activity.wealth.WealthCollectionFragment;
import com.qianseit.westore.activity.wealth.WealthCollectionNextFragment;
import com.qianseit.westore.activity.wealth.WealthCollectionTwoCodeFragment;
import com.qianseit.westore.activity.wealth.WealthFragment;
import com.qianseit.westore.activity.wealth.WealthMyBankFragment;
import com.qianseit.westore.activity.wealth.WealthPayFinallyFragmtn;
import com.qianseit.westore.activity.wealth.WealthRechargeFragment;
import com.qianseit.westore.activity.wealth.WealthRechargePayFragment;
import com.qianseit.westore.activity.wealth.WealthWithdrawFragment;
import com.qianseit.westore.base.DoActivity;
import com.qianseit.westore.base.DoFragment;

/**
 * @author qianseit
 */
public class AgentActivity extends DoActivity {
    public static final int FRAGMENT_COMM_LOGIN = 0x0001;
    public static final int FRAGMENT_COMM_ECPRESSO = 0x0003;
    public static final int FRAGMENT_COMM_REG_ARTICLE = 0x0005;
    public static final int FRAGMENT_COMM_REGIST_HINT = 0x0006;

    //社区
    public static final int FRAGMENT_COMMUNITY_COMMENT = 0x0050;
    public static final int FRAGMENT_COMMUNITY_MODULE = 0x0051;
    public static final int FRAGMENT_COMMUNITY_NOTE_LIST = 0x0052;

    //会员注册
    public static final int FRAGMENT_PASSPORT_REGISTR = 0x0070;
    public static final int FRAGMENT_PASSPORT_REGISTRATION_PROTOCOL = 0x0071;
    public static final int FRAGMENT_PASSPORT_PRIVACE = 0x0072;
    public static final int FRAGMENT_PASSPORT_SINGLE = 0x0073;
    public static final int FRAGMENT_PASSPORT_MULTI = 0x0074;
    public static final int FRAGEMTN_PASSPORT_STEP_TWO = 0x0075;
    public static final int FRAGEMTN_PASSPORT_STEP_THREE = 0x0076;


    //商品
    public static final int FRAGMENT_GOODS_DETAIL = 0x0300;
    public static final int FRAGMENT_GOODS_IMAGES_PREVIEW = 0x0301;
    public static final int FRAGMENT_GOODS_COLLECTION = 0x0302;
    public static final int FRAGMENT_GOODS_SPOOR = 0x0303;
    public static final int FRAGMENT_GOODS_SEARCH = 0x0304;
    public static final int FRAGMENT_GOODS_ARRIVAL_NOTICE = 0x0305;
    public static final int FRAGMENT_GOODS_TWODCODE = 0x0306;


    //消息
    public static final int FRAGMENT_NEWS_CENTER = 0x0340;
    public static final int FRAGMENT_NEWS_ORDER = 0x0341;
    public static final int FRAGMENT_NEWS_PUBLIC_NOTICE = 0x0342;
    public static final int FRAGMENT_NEWS_MARKETING = 0x0343;
    public static final int FRAGMENT_NEWS_ASSETS = 0x0344;
    public static final int FRAGMENT_NEWS_SYSTEM = 0x0345;

    // 购物
    public static final int FRAGMENT_SHOPP_GOODS_CAR = 0x0601;
    public static final int FRAGMENT_SHOPP_CONFIRM_ORDER = 0x0602;
    public static final int FRAGMENT_SHOPP_ALL_ORDERS = 0x0603;
    public static final int FRAGMENT_SHOPP_PAYMETHOD = 0x0604;
    public static final int FRAGMENT_SHOPP_LOGISTICS = 0x0605;
    public static final int FRAGMENT_SHOPP_ORDERS_DETAIL = 0x0606;
    public static final int FRAGMENT_SHOPP_PICK_EXPRESS = 0x0607;
    public static final int FRAGMENT_SHOPP_STORE = 0x0608;
    public static final int FRAGMENT_SHOPP_STORE_TIME = 0x0609;
    public static final int FRAGMENT_SHOPP_GOODS_LIST = 0x060A;
    public static final int FRAGMENT_SHOPP_PROMOT = 0x060B;
    public static final int FRAGMENT_SHOPP_CHOOSE = 0x060C;
    public static final int FRAGMENT_SHOPP_COMMEND = 0x060D;
    public static final int FRAGMENT_SHOPP_ORDER_GOODS_RATING = 0x060E;
    public static final int FRAGMENT_SHOPP_BRAND = 0x060F;
    public static final int FRAGMENT_SHOPP_SINCE_ADDRESS = 0x0610;
    public static final int FRAGMENT_SHOPP_SPECIFIC_STORE = 0x0611;
    public static final int FRAGMENT_SHOPP_STORE_INFO = 0x0612;
    public static final int FRAGMENT_SHOPP_ORDER_INVOICE = 0x0613;
    public static final int FRAGMENT_SHOPP_SECKILL = 0x0614;
    public static final int FRAGMENT_SHOPP_GOODS_CONSULT = 0x0615;
    public static final int FRAGMENT_SHOPP_GOODS_CONSULT_PUBLISH = 0x0616;
    public static final int FRAGMENT_SHOPP_GOODS_CONSULT_REPLY = 0x0617;
    public static final int FRAGMENT_SHOPP_GOODS_COMMENT = 0x0618;
    public static final int FRAGMENT_SHOPP_GOODS_TOGETHER = 0x0619;
    public static final int FRAGMENT_SHOPP_ORDER_PREPARE = 0x061A;
    public static final int FRAGMENT_SHOPP_GOODS_COMMENT_PUBLISH = 0x061B;

    public static final int FRAGMENT_OTHER_ARTICLE_READER = 0x00A1;

    /**
     * 统计
     */
    public static final int FRAGMENT_STATISTICS_CHART = 0x00D0;

    public static final String EXTRA_FRAGMENT = "extra_fragment";

    public static final int FRAGMENT_CATEGORY_YING = 0x1122;

    // 个人中心
    public static final int FRAGMENT_ACCO_SETTING = 0x0100;
    public static final int FRAGMENT_ACCO_PERSONAL_INFO = 0x0104;
    public static final int FRAGMENT_ACCO_FEEDBACK = 0x0105;
    public static final int FRAGMENT_ACCO_ABUOT = 0x0106;
    public static final int FRAGMENT_ACCO_PASSWORD_MANAGE = 0x0107;
    public static final int FRAGMENT_ACCO_RESET_PASSWORD = 0x0108;
    public static final int FRAGMENT_ACCO_PASSWORD_MANAGE_MODIFY_BUSINISS_PW = 0x0109;
    public static final int FRAGMENT_ACCO_PASSWORD_MANAGE_SET_BUSINESS_PW = 0x010A;
    public static final int FRAGMENT_ACCO_PASSWORD_MANAGE_FORGET_BUSINESS_PW = 0x010B;
    public static final int FRAGMENT_ACCO_PASSWORD_MANAGE_FORGET_PW = 0x010C;
    public static final int FRAGMENT_ACCO_COUPON = 0x010D;
    public static final int FRAGMENT_ACCO_POINTS = 0x010E;
    public static final int FRAGMENT_ACCO_MESSAGE = 0x010F;
    public static final int FRAGMENT_ACCO_SYS_MESSAGE = 0x0110;
    public static final int FRAGMENT_ACCO_COUPON_INSTRUCTIONS = 0x0111;
    public static final int FRAGMENT_ACCO_DISTRIBUTION = 0x0112;
    public static final int FRAGMENT_ACCO_JOIN = 0x0113;
    public static final int FRSGMENT_ACCO_RECOMEN_PERSON = 0x0114;
    public static final int FRAGMENT_ACCO_EDIT_ITEM = 0x0116;
    public static final int FRAGMENT_ACCO_HELP_CENTER = 0x0117;
    public static final int FRAGMENT_ACCO_BIND_MOBILE = 0x0118;
    public static final int FRAGMENT_ACCO_LV = 0x0119;
    public static final int FRAGMENT_ACCO_NAME = 0x011A;
    public static final int FRAGMENT_ACCO_BIND_MOBILE_THRID = 0x011B;
    public static final int FRAGMENT_ACCO_SERVICE = 0x011C;
    public static final int FRAGMENT_ACCO_TWO_CODE = 0x011D;
    public static final int FRAGMENT_ACCO_ADD_VIP = 0x011E;
    public static final int FRAGMENT_ACCO_NEW_CUSTOMER = 0x011F;

    // 收货地址
    public static final int FRAGMENT_ADDR_BOOK = 0x0200;
    public static final int FRAGMENT_ADDR_MY_ADDRESS_PICKER = 0x0201;
    public static final int FRAGMENT_ADDR_BOOK_EDITOR = 0x0202;
    public static final int FRAGMENT_ADDR_PICKER_STREET = 0x0203;

    // 财富
    public static final int FRAGMENT_WEALTH = 0x0700;
    public static final int FRAGMENT_WEALTH_BILL = 0x0701;
    public static final int FRAGMENT_WEALTH_RECHARGE = 0x0702;
    public static final int FRAGMENT_WEALTH_PAY_FINALLY = 0x0703;
    public static final int FRAGMENT_WEALTH_WITHDRAW = 0x0704;
    public static final int FRAGMENT_WEALTH_BANK_CARD = 0x0705;
    public static final int FRAGMENT_WEALTH_BANK_CARD_ADD = 0x0706;
    public static final int FRAGMENT_WEALTH_BANK_CHOOSE = 0x0707;
    public static final int FRAGMENT_WEALTH_MYBANK = 0x0709;
    public static final int FRAGMENT_WEALTH_RECHARGE_PAY = 0x070A;
    public static final int FRAGMENT_WEAL_COLLECTION_MAIN = 0x070B;
    public static final int FRAGMENT_WEAL_COLLECTION_NEXT = 0x070C;
    public static final int FRAGMENT_WEAL_SHOPE_TWO_CODE = 0x070D;

    // 推荐
    public static final int FRAGMENT_RECOMMEND_HOME = 0x0800;
    public static final int FRAGMENT_RECOMMEND_PRAISE = 0x0801;
    public static final int FRAGMENT_RECOMMEND_COMMENT = 0x0802;
    public static final int FRAGMENT_RECOMMEND_FANS = 0x0803;
    public static final int FRAGMENT_RECOMMEND_TEL_BOOK = 0x0804;
    public static final int FRAGMENT_RECOMMEND_ATTENTION = 0x0805;
    public static final int FRAGMENT_RECOMMEND_ATTENTION_ADD = 0x0806;
    public static final int FRAGMENT_RECOMMEND_ATTENTION_SEARCH = 0x0807;
    public static final int FRAGMENT_RECOMMEND_GOODS_COMMENT = 0x0808;
    public static final int FRAGMENT_RECOMMEND_PHOTO = 0x0809;

    // 优惠活动
    public static final int FRAGMENT_MARKETING_SHAKE = 0x0900;
    public static final int FRAGMENT_MARKETING_SIGNIN = 0x0901;
    public static final int FRAGMENT_MARKETING_COUPON_CENTER = 0x0902;
    public static final int FRAGMENT_MARKETING_INVITE_REGIST = 0x0903;
    public static final int FRAGMENT_MARKETING_ACTIVITY = 0x0904;

    // 售后
    public static final int FRAGMENT_AFTERMARKET_ORDERS = 0x0A01;
    public static final int FRAGMENT_AFTERMARKET_REFUND = 0x0A02;
    public static final int FRAGMENT_AFTERMARKET_RETURN_GOODS = 0x0A03;
    public static final int FRAGMENT_AFTERMARKET_NOTICE = 0x0A04;

    ///会员列表
    public static final int FRAGMENT_PARTNR_LIST = 0x0A10;
    ///会员详情
    public static final int FRAGMENT_PARTNR_DETAIL = 0xA11;

    //商品存取记录
    public static final int FRAGMENT_GOODS_ACCESS_RECORD = 0xA12;

    DoFragment fragment = null;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        super.onCreate(savedInstanceState);

        // 在使用SDK各组件之前初始化context信息，传入ApplicationContext
        // 注意该方法要再setContentView方法之前实现

        Bundle bundle = getIntent().getExtras();
        int fragmentid = getIntent().getIntExtra(EXTRA_FRAGMENT, -1);
        switch (fragmentid) {
            case FRAGMENT_OTHER_ARTICLE_READER:
                fragment = new ArticleReaderFragment();
                break;
            case FRAGMENT_COMM_LOGIN:
                fragment = new CommonLoginFragment();
                break;
            case FRAGMENT_COMM_ECPRESSO:
                fragment = new CommExpressoFragment();
                break;
            case FRAGMENT_COMM_REG_ARTICLE:
                fragment = new CommRegArticleFragment();
                break;
            case FRAGMENT_COMM_REGIST_HINT:
                fragment = new CommonRegisterHintFragment();
                break;

            case FRAGMENT_PASSPORT_REGISTR:
//                fragment = new CommonRegisterFragment();
                fragment = new CommonRegisterStepOneFragment();
                break;
            case FRAGEMTN_PASSPORT_STEP_TWO:
                fragment = new CommonRegisterStepTwoFragment();
                break;
            case FRAGEMTN_PASSPORT_STEP_THREE:
                fragment = new CommonRegisterStepThreeFragment();
                break;
            case FRAGMENT_PASSPORT_PRIVACE:
                fragment = new PrivaceFragment();
                break;
            case FRAGMENT_PASSPORT_REGISTRATION_PROTOCOL:
                fragment = new RegistrationProtocolFragment();
                break;
            case FRAGMENT_PASSPORT_SINGLE:
                fragment = new SingleItemFragment();
                break;
            case FRAGMENT_PASSPORT_MULTI:
                fragment = new MultiItemFragment();
                break;


            case FRAGMENT_COMMUNITY_COMMENT:
                fragment = new CommDiscoverCommentFragment();
                break;
            case FRAGMENT_COMMUNITY_MODULE:
                fragment = new CommDiscoverFragment();
                break;
            case FRAGMENT_COMMUNITY_NOTE_LIST:
                fragment = new CommDiscoverNoteListFragment();
                break;

            case FRAGMENT_GOODS_DETAIL:
                fragment = new GoodsDetailFragment();
                break;
            case FRAGMENT_GOODS_IMAGES_PREVIEW:
                fragment = new GoodsImagesPreviewFragment();
                break;
            case FRAGMENT_GOODS_COLLECTION:
                fragment = new GoodsCollectionFragment();
                break;
            case FRAGMENT_GOODS_SPOOR:
                fragment = new GoodsSpoorFragment();
                break;
            case FRAGMENT_GOODS_SEARCH:
                fragment = new GoodsSearchFragment();
                break;
            case FRAGMENT_GOODS_ARRIVAL_NOTICE:
                fragment = new GoodsArrivalNoticeFragment();
                break;
            case FRAGMENT_GOODS_TWODCODE:
                fragment = new GoodsTwoDCodeFragment();
                break;

            case FRAGMENT_NEWS_CENTER:
                fragment = new NewsCenterFragment();
                break;
            case FRAGMENT_NEWS_ORDER:
                fragment = new NewsOrderFragment();
                break;
            case FRAGMENT_NEWS_PUBLIC_NOTICE:
                fragment = new NewsPublicNoticeFragment();
                break;
            case FRAGMENT_NEWS_MARKETING:
                fragment = new NewsMarketingFragment();
                break;
            case FRAGMENT_NEWS_ASSETS:
                fragment = new NewsAssetsFragment();
                break;
            case FRAGMENT_NEWS_SYSTEM:
                fragment = new NewsSystemMainFragment();
                break;

            case FRAGMENT_SHOPP_GOODS_CAR:
                fragment = new ShoppCarOneFragment();
                break;
            case FRAGMENT_SHOPP_CONFIRM_ORDER:
                fragment = new ShoppingConfirmOrderFragment();
                break;
            case FRAGMENT_SHOPP_ALL_ORDERS:
                fragment = new OrderSegementFragment();
                break;
            case FRAGMENT_SHOPP_PAYMETHOD:
                fragment = new ShoppingPayMethodFragment();
                break;
            case FRAGMENT_SHOPP_LOGISTICS:
                fragment = new ShoppingLogisticsFragment();
                break;
            case FRAGMENT_SHOPP_ORDERS_DETAIL:
                fragment = new OrderDetailFragment();
                break;
            case FRAGMENT_SHOPP_PICK_EXPRESS:
                fragment = new ShoppingExpressPickFragment();
                break;
            case FRAGMENT_SHOPP_STORE:
                fragment = new ShoppingStoreFragment();
                break;
            case FRAGMENT_SHOPP_STORE_TIME:
                fragment = new ShoppingStoreTimeFragment();
                break;
            case FRAGMENT_SHOPP_GOODS_LIST:
                fragment = new GoodsListFragment();
                break;
            case FRAGMENT_SHOPP_PROMOT:
                fragment = new ShoppingPromotionsFragment();
                break;
            case FRAGMENT_SHOPP_CHOOSE:
                fragment = new ShoppingChooseFreagment();
                break;
            case FRAGMENT_SHOPP_ORDER_GOODS_RATING:
                fragment = new ShoppingGoodsCommentFragment();
                break;
            case FRAGMENT_SHOPP_COMMEND:
                fragment = new ShoppingCommendedLanguageActivity();
                break;
            case FRAGMENT_SHOPP_SINCE_ADDRESS:
                fragment = new ShoppingSinceAddress();
                break;
            case FRAGMENT_SHOPP_SPECIFIC_STORE:
                fragment = new ShoppingSpecificStoreFragment();
                break;
            case FRAGMENT_SHOPP_STORE_INFO:
                fragment = new ShoppingStoreInfoFragment();
                break;
            case FRAGMENT_SHOPP_ORDER_INVOICE:
                fragment = new InvoiceEditorFragment();
                break;
            case FRAGMENT_SHOPP_SECKILL:
                fragment = new ShoppSecKillFragment();
                break;
            case FRAGMENT_SHOPP_GOODS_CONSULT:
                fragment = new GoodsConsultFragment();
                break;
            case FRAGMENT_SHOPP_GOODS_CONSULT_PUBLISH:
                fragment = new GoodsConsultPublishFragment();
                break;
            case FRAGMENT_SHOPP_GOODS_CONSULT_REPLY:
                fragment = new GoodsConsultReplyFragment();
                break;
            case FRAGMENT_SHOPP_GOODS_COMMENT:
                fragment = new GoodsCommentFragment();
                break;
            case FRAGMENT_SHOPP_GOODS_TOGETHER:
                fragment = new ShoppGoodsTogetherFragment();
                break;
            case FRAGMENT_SHOPP_ORDER_PREPARE:
                fragment = OrderUtils.getOrderListPrepareFragment();
                break;
            case FRAGMENT_SHOPP_GOODS_COMMENT_PUBLISH:
                fragment = new GoodsCommentPublishFragment();
                break;

            case FRAGMENT_AFTERMARKET_ORDERS:
                fragment = new AftermarketAllOrdersFragment();
                break;
            case FRAGMENT_AFTERMARKET_REFUND:
                fragment = new AftermarketRefundFragment();
                break;
            case FRAGMENT_AFTERMARKET_RETURN_GOODS:
                fragment = new AftermarketReturnGoodsFragment();
                break;
            case FRAGMENT_AFTERMARKET_NOTICE:
                fragment = new AftermarketNoticeFragment();
                break;

            case FRAGMENT_ADDR_BOOK:
                fragment = new AddressBookFragment();
                break;
            case FRAGMENT_ADDR_BOOK_EDITOR:
                fragment = new AccountAddressAddFragment();
                break;
            case FRAGMENT_ADDR_MY_ADDRESS_PICKER:
                fragment = new MyAddresPickerFragment();
                break;
            case FRAGMENT_ADDR_PICKER_STREET:
                fragment = new MyAddressPickerStreetFragment();
                break;

            case FRAGMENT_WEALTH:
                fragment = new WealthFragment();
                break;
            case FRAGMENT_WEALTH_RECHARGE:
                fragment = new WealthRechargeFragment();
                break;
            case FRAGMENT_WEALTH_RECHARGE_PAY:
                fragment = new WealthRechargePayFragment();
                break;
            case FRAGMENT_WEALTH_PAY_FINALLY:
                fragment = new WealthPayFinallyFragmtn();
                break;
            case FRAGMENT_WEALTH_BILL:
                fragment = new WealthBillFragment();
                break;
            case FRAGMENT_WEALTH_WITHDRAW:
                fragment = new WealthWithdrawFragment();
                break;
            case FRAGMENT_WEALTH_BANK_CARD:
                fragment = new WealthBankCardFragment();
                break;
            case FRAGMENT_WEALTH_BANK_CARD_ADD:
                fragment = new WealthBankCardAddFragment();
                break;
            case FRAGMENT_WEALTH_BANK_CHOOSE:
                fragment = new WealthBankChooseFragment();
                break;
            case FRAGMENT_WEALTH_MYBANK:
                fragment = new WealthMyBankFragment();
                break;
            case FRAGMENT_WEAL_SHOPE_TWO_CODE:
                fragment = new WealthCollectionTwoCodeFragment();
                break;
            case FRAGMENT_WEAL_COLLECTION_MAIN:
                fragment = new WealthCollectionFragment();
                break;
            case FRAGMENT_WEAL_COLLECTION_NEXT:
                fragment = new WealthCollectionNextFragment();
                break;

            case FRAGMENT_ACCO_SETTING:
                fragment = new AccoSettingFragment();
                break;
            case FRAGMENT_ACCO_PERSONAL_INFO:
                fragment = new AccoPersonalInfoFragment();
                break;
            case FRAGMENT_ACCO_FEEDBACK:
                fragment = new AccoFeedbackFragment();
                break;
            case FRAGMENT_ACCO_ABUOT:
                fragment = new AccoAboutFragment();
                break;
            case FRAGMENT_ACCO_PASSWORD_MANAGE:
                fragment = new AccoPwdManagerFragment();
                break;
            case FRAGMENT_ACCO_PASSWORD_MANAGE_SET_BUSINESS_PW:
                fragment = new AccoSettingBusinessPasswdFragment();
                break;
            case FRAGMENT_ACCO_PASSWORD_MANAGE_FORGET_BUSINESS_PW:
                fragment = new AccoForgetBusinessPasswdFragment();
                break;
            case FRAGMENT_ACCO_PASSWORD_MANAGE_FORGET_PW:
                fragment = new AccoForgetPasswdFragment();
                break;
            case FRAGMENT_ACCO_PASSWORD_MANAGE_MODIFY_BUSINISS_PW:
                fragment = new AccoResetBusinessPasswdFragment();
                break;
            case FRAGMENT_ACCO_RESET_PASSWORD:
                fragment = new AccoResetPasswdFragment();
                break;
            case FRAGMENT_ACCO_COUPON:
                fragment = new AccoCouponFragment();
                break;
            case FRAGMENT_ACCO_COUPON_INSTRUCTIONS:
                fragment = new AccoCouponInstructionsFragment();
                break;
            case FRAGMENT_ACCO_POINTS:
                fragment = new AccoPointsFragment();
                break;
            case FRAGMENT_ACCO_MESSAGE:
                fragment = new AccoMyMessageFragment();
                break;
            case FRAGMENT_ACCO_SYS_MESSAGE:
                fragment = new AccoSysMessageFragment();
                break;
            case FRAGMENT_ACCO_DISTRIBUTION:
                fragment = new AccoDistributionFrament();
                break;
            case FRAGMENT_ACCO_JOIN:
                fragment = new AccoJoinFragment();
                break;
            case FRSGMENT_ACCO_RECOMEN_PERSON:
                fragment = new AccoRecommendFragment();
                break;
            case FRAGMENT_ACCO_EDIT_ITEM:
                fragment = new AccoEditItemFragment();
                break;
            case FRAGMENT_ACCO_HELP_CENTER:
                fragment = new AccoHelpCenterFragment();
                break;
            case FRAGMENT_ACCO_BIND_MOBILE:
                fragment = new AccoBindMobileFragment();
                break;
            case FRAGMENT_ACCO_BIND_MOBILE_THRID:
                fragment = new AccoBindMobileThridFragment();
                break;
            case FRAGMENT_ACCO_LV:
                fragment = new AccoLvFragment();
                break;
            case FRAGMENT_ACCO_NAME:
                fragment = new AccoNameFragment();
                break;
            case FRAGMENT_ACCO_SERVICE:
                fragment = new AccoServiceFragment();
                break;
            case FRAGMENT_ACCO_ADD_VIP:
                fragment = new AccountAddVipFragment();
                break;
            case FRAGMENT_ACCO_NEW_CUSTOMER:
                fragment = new AccountNewCustomerFragment();
                break;
            case FRAGMENT_ACCO_TWO_CODE:
                fragment = new AccountTwoCodeFragment();
                break;

            case FRAGMENT_RECOMMEND_HOME:
                fragment = new RecommendCollectFragment();
                break;
            case FRAGMENT_RECOMMEND_PRAISE:
                fragment = new RecommendPraiseFragment();
                break;
            case FRAGMENT_RECOMMEND_COMMENT:
                fragment = new RecommendCommentFragment();
                break;
            case FRAGMENT_RECOMMEND_FANS:
                fragment = new RecommendFansFragment();
                break;
            case FRAGMENT_RECOMMEND_TEL_BOOK:
                fragment = new RecommendTelBookFragment();
                break;
            case FRAGMENT_RECOMMEND_ATTENTION:
                fragment = new RecommendAttentionFragment();
                break;
            case FRAGMENT_RECOMMEND_ATTENTION_ADD:
                fragment = new RecommendAttentionAddFragment();
                break;
            case FRAGMENT_RECOMMEND_ATTENTION_SEARCH:
                fragment = new RecommendAttentionSearchFragment();
                break;
            case FRAGMENT_RECOMMEND_GOODS_COMMENT:
                fragment = new RecommendGoodCommentFragment();
                break;
            case FRAGMENT_RECOMMEND_PHOTO:
                fragment = new RecommendPhotoFragment();
                break;

            case FRAGMENT_MARKETING_SHAKE:
                fragment = new MarketingShakeFragment();
                break;
            case FRAGMENT_MARKETING_SIGNIN:
                fragment = new MarketingSignInFragment();
                break;
            case FRAGMENT_MARKETING_COUPON_CENTER:
                fragment = new MarketingCouponCenterFragment();
                break;
            case FRAGMENT_MARKETING_INVITE_REGIST:
                fragment = new MarketingInviteRegistFragment();
                break;
            case FRAGMENT_MARKETING_ACTIVITY:
                fragment = new MarketingActivityFragment();
                break;
            case FRAGMENT_PARTNR_LIST:
                fragment = new PartnerListFragment();
                break;
            case FRAGMENT_PARTNR_DETAIL:
                fragment = new PartnerDetailFragment();
                break;
            case FRAGMENT_STATISTICS_CHART:
                fragment = new StatisticsChartActivity();
                break;
            case FRAGMENT_GOODS_ACCESS_RECORD :
                fragment = new GoodsAccessRecordFragment();
                break;
            default:
                finish();
                break;
        }

        // 插入Fragment
        if (fragment != null) {
            fragment.setArguments(bundle);
            setMainFragment(fragment);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
    }

    /**
     * 返回打开Fragment的Intent
     *
     * @param context
     * @param fragment
     * @return
     */
    public static Intent intentForFragment(Context context, int fragment) {
        Intent intent = new Intent(context, AgentActivity.class);
        intent.putExtra(EXTRA_FRAGMENT, fragment);
        intent.putExtra(DoActivity.EXTRA_SHOW_BACK, true);
        return intent;
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (fragment.onKeyDown(keyCode, event)) {
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        // TODO Auto-generated method stub
        if (fragment.dispatchKeyEvent(event)) {
            return true;
        }
        return super.dispatchKeyEvent(event);
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        fragment.onWindowFocusChanged(hasFocus);
    }
}