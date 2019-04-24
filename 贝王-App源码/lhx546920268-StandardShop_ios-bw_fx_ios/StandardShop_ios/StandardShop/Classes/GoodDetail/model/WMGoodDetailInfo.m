//
//  WMGoodDetailInfo.m
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailInfo.h"
#import "WMGoodDetailPointInfo.h"
#import "WMGoodDetailSettingInfo.h"
#import "WMGoodDetailPromotionInfo.h"
#import "WMGoodDetailPrepareInfo.h"
#import "WMGoodDetailTabInfo.h"
#import "WMGoodDetailAdjGroupInfo.h"
#import "WMGoodDetailParamInfo.h"
#import "WMGoodDetailSpecInfo.h"
#import "WMGoodSimilarInfo.h"
#import "WMBrandInfo.h"
#import "WMGoodDetailOperation.h"
#import "WMGoodDetailGiftInfo.h"

@implementation WMGoodDetailInfo
/**初始化
 */
+ (instancetype)returnGoodDetailInfoWithDict:(NSDictionary *)dict{
    
    WMGoodDetailInfo *info = [WMGoodDetailInfo new];
    
    NSDictionary *goodBasicDict = [dict dictionaryForKey:@"page_product_basic"];
    
    BOOL isGift = [[goodBasicDict numberForKey:@"is_gift"] boolValue];
    
    info.goodBuyQuantity = 1;
    
    info.marketAble = [[goodBasicDict sea_stringForKey:@"product_marketable"] isEqualToString:@"true"];
    
    info.goodUnit = [NSString isEmpty:[goodBasicDict sea_stringForKey:@"unit"]] ? @"" : [goodBasicDict sea_stringForKey:@"unit"];
    
    info.settingInfo = [WMGoodDetailSettingInfo returnGoodDetailSettingInfoWithDict:[dict dictionaryForKey:@"setting"]];
    
    if ([dict dictionaryForKey:@"goods_point"] == nil) {
        
        info.settingInfo.goodDetailShowCommentPoint = NO;
    }
    else{
        
        info.settingInfo.goodDetailShowCommentPoint = YES;
    }
    
    info.pointInfo = [WMGoodDetailPointInfo returnGoooDetailPointInfoWithDict:dict];
    
    NSArray *tagsArr = [dict arrayForKey:@"service_tag_list"];
    
    NSMutableArray *tagsContentArr = [NSMutableArray new];
    
    for (NSDictionary *tagDict in tagsArr) {
        
        [tagsContentArr addObject:[tagDict sea_stringForKey:@"name"]];
    }
    
    info.goodTagsArr = [NSArray arrayWithArray:tagsContentArr];
    
    info.adviceCount = [dict sea_stringForKey:@"askCount"];
    
    info.goodMenuBarInfosArr = [NSMutableArray new];
    
    info.goodAdjGroupsArr = [WMGoodDetailAdjGroupInfo returnGoodDetailAdjGroupInfoArrWithDictArr:[dict arrayForKey:@"page_goods_adjunct"] imagesDict:[dict dictionaryForKey:@"adjunct_images"]];
            
    info.goodAdjGroupsNameArr = [NSMutableArray new];
    
    for (WMGoodDetailAdjGroupInfo *groupInfo in info.goodAdjGroupsArr) {
        
        [info.goodAdjGroupsNameArr addObject:groupInfo.groupName];
    }
    
    info.goodDetailParamsArr = [WMGoodDetailParamInfo returnGoodDetailParamInfosArrWithDictArr:[goodBasicDict arrayForKey:@"params"]];
    
    info.goodPropsArr = [goodBasicDict arrayForKey:@"props"];
    
    info.goodSpecInfosArr = [WMGoodDetailSpecInfo returnGoodSpecInfoArrWithDictArr:[goodBasicDict arrayForKey:@"spec"]];

    info.specInfoAttrString = [WMGoodDetailInfo changeGoodBuyQuantityWithNewQuantity:info.goodBuyQuantity specInfosArr:info.goodSpecInfosArr goodUnit:info.goodUnit];
    
    NSString *promotionType = [goodBasicDict sea_stringForKey:@"promotion_type"];
    
    if ([NSString isEmpty:promotionType]) {
        
        info.type = GoodPromotionTypeNothing;
    }
    else{
        
        if ([promotionType isEqualToString:@"starbuy"]) {
            
            info.type = GoodPromotionTypeSecondKill;
        }
        else if ([promotionType isEqualToString:@"prepare"]){
            
            info.type = GoodPromotionTypePrepare;
        }
    }
    
    NSString *brief = [goodBasicDict sea_stringForKey:@"brief"];
    
    NSMutableParagraphStyle *paragarphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragarphStyle setLineSpacing:8];
    
    NSMutableAttributedString *attrString = [NSMutableAttributedString new];
    
    if ([NSString isEmpty:brief]) {
        
        info.goodBrief = nil;
    }
    else{
        
        attrString = [[NSMutableAttributedString alloc] initWithString:brief];
        
        UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
        
        if ([brief stringSizeWithFont:font contraintWith:_width_ - 2 * 8.0].height > font.lineHeight) {
            
            [attrString addAttribute:NSParagraphStyleAttributeName value:paragarphStyle range:NSMakeRange(0, [brief length])];
        }
        
        [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:15],NSForegroundColorAttributeName:WMMarketPriceColor} range:NSMakeRange(0, [brief length])];
        
        info.goodBrief = attrString;
    }
    
    info.goodImagesArr = [NSMutableArray new];
    
    for (NSString *imageString in [goodBasicDict arrayForKey:@"images"]) {
        
        [info.goodImagesArr addNotNilObject:imageString];
    }
    
    if (!info.goodImagesArr.count) {
        
        [info.goodImagesArr addObject:@""];
    }
    
    NSDictionary *brandDict = [goodBasicDict dictionaryForKey:@"brand"];
    
    if (![NSString isEmpty:[brandDict sea_stringForKey:@"brand_id"]]) {
        
        info.goodBrandInfo = [WMBrandInfo infoFromDictionary:brandDict];
    }
    
    NSDictionary *promotionDict = [goodBasicDict dictionaryForKey:@"promotion"];
    
    if (promotionDict) {
        
        info.promotionInfo = [WMGoodDetailPromotionInfo returnGoodDetailPromotionInfoWithDict:promotionDict];
    }
    
    NSDictionary *prepareDict = [goodBasicDict dictionaryForKey:@"prepare"];
    
    if (prepareDict) {
        
        info.prepareInfo = [WMGoodDetailPrepareInfo returnGoodDetailPrepareInfoWithDict:prepareDict];
        
        NSMutableString *prepareString = [NSMutableString new];
        
        [prepareString appendString:[NSString stringWithFormat:@"预售状态：%@\n",info.prepareInfo.prepareStatusMessage]];
        
        [prepareString appendString:[NSString stringWithFormat:@"预售描述：%@\n",info.prepareInfo.prepareRuleDescription]];
        
        [prepareString appendString:[NSString stringWithFormat:@"预售规则：%@",info.prepareInfo.prepareRuleName]];
        
        attrString = [[NSMutableAttributedString alloc] initWithString:prepareString];
        
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragarphStyle range:NSMakeRange(0, [prepareString length])];
        
        [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:14.0],NSForegroundColorAttributeName:WMMarketPriceColor} range:NSMakeRange(0, [prepareString length])];
        
        [attrString addAttributes:@{NSForegroundColorAttributeName:WMRedColor} range:[attrString.string rangeOfString:info.prepareInfo.prepareStatusMessage]];
        
        info.prepareAttrString = attrString;
    }
    
    NSDictionary *secondKillDict = [goodBasicDict dictionaryForKey:@"special_info"];
    
    if (secondKillDict) {
        
        info.secondKillInfo = [WMGoodDetailSecondKillInfo returnGoodDetailSecondKillInfoWithDict:secondKillDict];
    }
    
    info.goodID = [goodBasicDict sea_stringForKey:@"goods_id"];
    
    info.goodBuyCount = [goodBasicDict sea_stringForKey:@"buy_count"];
    
    info.productID = [goodBasicDict sea_stringForKey:@"product_id"];
    
    info.goodBNCode = [goodBasicDict sea_stringForKey:@"goods_bn"];
    
    info.productBNCode = [goodBasicDict sea_stringForKey:@"product_bn"];
    
    info.goodQRCode = [goodBasicDict sea_stringForKey:@"qrcode_image_id"];
    
    info.goodIntro = [goodBasicDict sea_stringForKey:@"intro"];
    
    WMGoodDetailTabInfo *introTabInfo = [WMGoodDetailTabInfo new];
    
    introTabInfo.tabName = @"图文详情";
    
    introTabInfo.tabContent = info.goodIntro;
    
    introTabInfo.type = GoodGraphicDetailTypeWeb;
    
    [info.goodMenuBarInfosArr addObject:introTabInfo];
    
    if (info.goodDetailParamsArr.count) {
        
        WMGoodDetailTabInfo *paramsTabInfo = [WMGoodDetailTabInfo new];
        
        paramsTabInfo.tabName = @"规格参数";
        
        paramsTabInfo.type = GoodGraphicDetailTypeParam;
        
        [info.goodMenuBarInfosArr addObject:paramsTabInfo];
    }
    
    if (info.settingInfo.goodDetailShowConsume) {
        
        WMGoodDetailTabInfo *sellLongTabInfo = [WMGoodDetailTabInfo new];
        
        sellLongTabInfo.tabName = @"销售记录";
        
        sellLongTabInfo.type = GoodGraphicDetailTypeSellLog;
        
        [info.goodMenuBarInfosArr addObject:sellLongTabInfo];
    }
    
    [info.goodMenuBarInfosArr addObjectsFromArray:[WMGoodDetailTabInfo returnGoodTabInfoArrWithDictArr:[dict arrayForKey:@"async_request_list"]]];
    
    info.goodName = [goodBasicDict sea_stringForKey:@"title"];
    
    info.goodTypeName = [goodBasicDict sea_stringForKey:@"type_name"];
    
    info.goodCatName = [goodBasicDict sea_stringForKey:@"cat_name"];
    
    info.shareURL = [goodBasicDict sea_stringForKey:@"share_url"];
    
    NSDictionary *priceListDict = [goodBasicDict dictionaryForKey:@"price_list"];
    
    NSDictionary *marketPriceDict = [priceListDict dictionaryForKey:@"mktprice"];
    
    
    info.goodMarketPrice = [marketPriceDict sea_stringForKey:@"format"];
    
    info.goodMarketName = [marketPriceDict sea_stringForKey:@"name"];
    
   NSDictionary *fxPriceDict = [priceListDict dictionaryForKey:@"fxprice"];
    info.goodFxPrice = [fxPriceDict sea_stringForKey:@"format"];
    info.goodFxName = [fxPriceDict sea_stringForKey:@"name"];
    
    NSDictionary *showPriceDict = [priceListDict dictionaryForKey:@"show"];
    
    info.goodShowPrice = [showPriceDict sea_stringForKey:@"format"];
    
    info.goodShowPriceName = [showPriceDict sea_stringForKey:@"name"];
    
    NSDictionary *savePriceDict = [priceListDict dictionaryForKey:@"saveprice"];
    
    info.goodSavePrice = [savePriceDict sea_stringForKey:@"price"];
    
    info.goodSavePriceName = [savePriceDict sea_stringForKey:@"name"];
    
    NSDictionary *minPriceDict = [priceListDict dictionaryForKey:@"minprice"];
    
    info.goodMinPrice = [minPriceDict sea_stringForKey:@"format"];
    
    info.goodMinPriceName = [minPriceDict sea_stringForKey:@"name"];
    
    info.goodSavePriceUnit = [savePriceDict sea_stringForKey:@"unit"];
    
    info.goodStore = [goodBasicDict sea_stringForKey:@"store_title"];
    
    info.goodRealStore = [goodBasicDict sea_stringForKey:@"store"];
    
    if (isGift) {
        
        info.type = GoodPromotionTypeGift;
        
        NSDictionary *giftDict = [goodBasicDict dictionaryForKey:@"gift"];
        
        WMGoodDetailGiftInfo *giftInfo = [WMGoodDetailGiftInfo returnGoodDetailGiftInfoWithDict:giftDict];
        
        info.giftMessageInfo = giftInfo;
        
        info.goodLismitCout = giftInfo.exchangeMax.integerValue;
    }
    else{
        
        if (info.secondKillInfo) {
            
            info.goodLismitCout = [[secondKillDict sea_stringForKey:@"limit"] integerValue];
        }
        else{
            
            info.goodLismitCout = [goodBasicDict sea_stringForKey:@"store"].integerValue;
        }
    }
    
    info.goodIsFav = [[goodBasicDict numberForKey:@"is_fav"] boolValue];
        
    info.selectSpecProductImage = [goodBasicDict sea_stringForKey:@"image_default_id"];
        
    info.buttonPageList = [dict arrayForKey:@"btn_page_list"];
        
    return info;
}

/**返回商品详情信息每组行数
 */
- (NSInteger)returnGoodDetailInfoSectionRowCountWithSection:(NSInteger)section{
    
    switch (self.type) {
            
        case GoodPromotionTypeNothing:
        case GoodPromotionTypeSecondKill:
        case GoodPromotionTypeGift:
        {
            switch (section) {
                case GoodSectionTypeSecondKillLimit:
                {
                    if (self.type == GoodPromotionTypeSecondKill) {
                        
                        return 1;
                    }
                    else{
                        
                        return 0;
                    }
                }
                    break;
                case GoodSectionTypeSale:
                {
                    if (self.type == GoodPromotionTypeGift) {
                        
                        return 1;
                    }
                    
                    return self.goodBuyCount.integerValue == 0 ? 0 : 1;
                }
                    break;
                case GoodSectionTypeStore:
                {
                    if (self.type == GoodPromotionTypeGift) {
                        
                        return 1;
                    }
                    
                    return [NSString isEmpty:self.goodStore] ? 0 : 1;
                }
                    break;
                case GoodSectionTypePromotion:
                {
                    if (self.promotionInfo) {
                        
                        if (self.promotionInfo.isDropDownShow) {
                            
                            return self.promotionInfo.promotionContentInfosArr.count + 1;
                        }
                        else{
                            
                            return 1;
                        }
                    }
                    else{
                        
                        return 0;
                    }
                }
                    break;
                case GoodSectionTypeComment:
                {
                    if (self.settingInfo.goodDetailShowComment) {
                        
                        return 1;
                    }
                    else{
                        
                        return 0;
                    }
                }
                    break;
                case GoodSectionTypeAdvice:
                {
                    if (self.settingInfo.goodDetailShowAdvice) {
                        
                        return 1;
                    }
                    else{
                        
                        return 0;
                    }
                }
                    break;
                case GoodSectionTypeSpecInfo:
                {
                    if (self.goodPropsArr.count) {
                        
                        return 2;
                    }
                    else{
                        
                        return 1;
                    }
                }
                    break;
                case GoodSectionTypeBrief:
                {
                    if (self.goodBrief) {
                        
                        return 1;
                    }
                    else{
                        
                        return 0;
                    }
                }
                    break;
                case GoodSectionTypeTag:
                {
                    if (self.goodTagsArr.count) {
                        
                        return 1;
                    }
                    else{
                        
                        return 0;
                    }
                }
                    break;
                case GoodSectionTypeBrand:
                {
                    if (self.goodBrandInfo) {
                        
                        return 1;
                    }
                    else{
                        
                        return 0;
                    }
                }
                    break;
                case GoodSectionTypeLinkAdjGood:
                {
                    if (self.goodAdjGroupsArr.count || self.goodSimilarGoodsArr.count) {
                        
                        return 1;
                    }
                    else{
                        
                        return 0;
                    }
                }
                    break;
                case GoodSectionTypeLoadMore:
                {
                    return 1;
                }
                    break;
                default:
                {
                    return 0;
                }
                    break;
            }
        }
            break;
        case GoodPromotionTypePrepare:
        {
            switch (section) {
                case PrepareGoodSectionTypeStatus:
                {
                    return 1;
                }
                    break;
                case PrepareGoodSectionTypeComment:
                {
                    if (self.settingInfo.goodDetailShowComment) {
                        
                        return 1;
                    }
                    else{
                        
                        return 0;
                    }
                }
                    break;
                case PrepareGoodSectionTypeAdvice:
                {
                    if (self.settingInfo.goodDetailShowAdvice) {
                        
                        return 1;
                    }
                    else{
                        
                        return 0;
                    }
                }
                    break;
                case PrepareGoodSectionTypeSpecInfo:
                {
                    if (self.goodPropsArr.count) {
                        
                        return 2;
                    }
                    else{
                        
                        return 1;
                    }
                }
                    break;
                case PrepareGoodSectionTypeBrief:
                {
                    if (self.goodBrief) {
                        
                        return 1;
                    }
                    else{
                        
                        return 0;
                    }
                }
                    break;
                case PrepareGoodSectionTypeTag:
                {
                    if (self.goodTagsArr.count) {
                        
                        return 1;
                    }
                    else{
                        
                        return 0;
                    }
                }
                    break;
                case PrepareGoodSectionTypeBrand:
                {
                    if (self.goodBrandInfo) {
                        
                        return 1;
                    }
                    else{
                        
                        return 0;
                    }
                }
                    break;
                case PrepareGoodSectionTypeLinkGood:
                {
                    if (self.goodSimilarGoodsArr.count) {
                        
                        return 1;
                    }
                    else{
                        
                        return 0;
                    }
                }
                    break;
                case PrepareGoodSectionTypeLoadMore:
                {
                    return 1;
                }
                    break;
                default:
                {
                    return CGFLOAT_MIN;
                }
                    break;
            }
        }
            break;
        default:
        {
            return CGFLOAT_MIN;
        }
            break;
    }
}
/**返回商品详情信息每行高度
 */
- (CGFloat)returnGoodDetailInfoRowHeightWithIndexPath:(NSIndexPath *)indexPath menuBarSelectIndex:(NSInteger)menuBarSelectIndex{
    
    switch (self.type) {
        case GoodPromotionTypeNothing:
        case GoodPromotionTypeSecondKill:
        case GoodPromotionTypeGift:
        {
            switch (indexPath.section) {
                case GoodSectionTypeSecondKillLimit:
                {
                    if (self.type == GoodPromotionTypeSecondKill) {
                        
                        return WMSaleStoreCountTableViewCellHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case GoodSectionTypeSale:
                {
                    if (self.type == GoodPromotionTypeGift) {
                        
                        return WMSaleStoreCountTableViewCellHeight;
                    }
                    else{
                        
                        return self.goodBuyCount.integerValue == 0 ? CGFLOAT_MIN : WMSaleStoreCountTableViewCellHeight;
                    }
                }
                    break;
                case GoodSectionTypeStore:
                {
                    if (self.type == GoodPromotionTypeGift) {
                        
                        return WMSaleStoreCountTableViewCellHeight;
                    }
                    else{
                        
                        return [NSString isEmpty:self.goodStore] ? CGFLOAT_MIN : WMSaleStoreCountTableViewCellHeight;
                    }
                }
                    break;
                case GoodSectionTypePromotion:
                {
                    if (self.promotionInfo) {
                        
                        if (self.promotionInfo.isDropDownShow) {
                            
                            if (indexPath.row) {
                                
                                WMPromotionContentInfo *contentInfo = [self.promotionInfo.promotionContentInfosArr objectAtIndex:indexPath.row - 1];
                                
                                CGFloat tagWidth = [contentInfo.contentTag stringSizeWithFont:[UIFont fontWithName:MainFontName size:14.0] contraintWith:WMTagCalculateMaxWidth].width + 20.0;
                                
                                return MAX(WMPromotionContentMinHeight, [contentInfo.contentName stringSizeWithFont:[UIFont fontWithName:MainFontName size:14.0] contraintWith:_width_ - tagWidth - WMPromotionExtraWidth].height) + WMPromotionContentTableViewCellHeight - WMPromotionContentMinHeight;
                            }
                            else{
                                
                                return WMPromotionUpTableViewCellHeight;
                            }
                        }
                        else{
                            
                            return self.promotionInfo.promotionContentHeight;
                        }
                    }
                    else{
                        
                        CGFLOAT_MIN;
                    }
                }
                    break;
                case GoodSectionTypeComment:
                {
                    if (self.settingInfo.goodDetailShowComment) {
                        
                        return WMGoodCommentTableViewCellHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case GoodSectionTypeAdvice:
                {
                    if (self.settingInfo.goodDetailShowAdvice) {
                        
                        return WMGoodAdviceTableViewCellHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case GoodSectionTypeSpecInfo:
                {
                    CGFloat selectSpecHeight = MAX(WMGoodShowInfoTableViewCellHeight, [self.specInfoAttrString boundsWithConstraintWidth:_width_ - WMSelectSpecInfoTableViewCellExtraWidth].height + WMGoodShowInfoTableViewCellHeight - 21.0);
                    
                    if (self.goodPropsArr.count) {
                        
                        return indexPath.row ? selectSpecHeight : WMGoodShowInfoTableViewCellHeight;
                    }
                    else{
                        
                        return selectSpecHeight;
                    }
                }
                    break;
                case GoodSectionTypeBrief:
                {
                    if (self.goodBrief) {
                        
                        return MAX(WMGoodTextMinHeight, [self.goodBrief boundsWithConstraintWidth:_width_ - WMGoodTextExtraWidth].height) + WMGoodPureTextTableViewCellHeight - WMGoodTextMinHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case GoodSectionTypeTag:
                {
                    if (self.goodTagsArr.count) {
                        
                        return [WMGoodDetailOperation returnTagContentHeightWithMaxWidth:_width_ - WMGoodTagExtraWidth titlesArr:self.goodTagsArr extraWidth:WMGoodTagContentExtraWidth tagCellHeight:25.0];
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case GoodSectionTypeBrand:
                {
                    if (self.goodBrandInfo) {
                        
                        return WMGoodBrandTableViewCellHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case GoodSectionTypeLinkAdjGood:
                {
                    CGFloat collectViewHeight = [WMGoodDetailOperation returnGoodCollectionViewCellHeight];
                    
                    if (self.goodSimilarGoodsArr.count && self.goodAdjGroupsArr.count) {
                        
                        if (menuBarSelectIndex) {
                            
                            return self.goodSimilarGoodsArr.count > 3 ? collectViewHeight + WMGoodLinkExtraHeight : collectViewHeight;
                        }
                        else{
                            
                            return [WMGoodDetailOperation returnTagContentHeightWithMaxWidth:_width_ titlesArr:self.goodAdjGroupsNameArr extraWidth:WMTagContentExtraWidth tagCellHeight:28.0] + collectViewHeight + WMGoodAdjExtraHeight;
                        }
                    }
                    else if (self.goodSimilarGoodsArr.count || self.goodAdjGroupsArr.count){
                        
                        if (self.goodSimilarGoodsArr.count) {
                            
                            return self.goodSimilarGoodsArr.count > 3 ? collectViewHeight + WMGoodLinkExtraHeight : collectViewHeight;
                        }
                        else{
                                                        
                            return [WMGoodDetailOperation returnTagContentHeightWithMaxWidth:_width_ titlesArr:self.goodAdjGroupsNameArr extraWidth:WMTagContentExtraWidth tagCellHeight:28.0] + collectViewHeight + WMGoodAdjExtraHeight;
                        }
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case GoodSectionTypeLoadMore:
                {
                    return WMUpLoadMoreTableViewCellHeight;
                }
                    break;
                default:
                {
                    return CGFLOAT_MIN;
                }
                    break;
            }
        }
            break;
        case GoodPromotionTypePrepare:
        {
            switch (indexPath.section) {
                case PrepareGoodSectionTypeStatus:
                {
                    return MAX(WMGoodTextMinHeight, [self.prepareAttrString boundsWithConstraintWidth:_width_ - WMGoodTextExtraWidth].height) + WMGoodPureTextTableViewCellHeight - WMGoodTextMinHeight;
                }
                    break;
                case PrepareGoodSectionTypeComment:
                {
                    if (self.settingInfo.goodDetailShowComment) {
                        
                        return WMGoodCommentTableViewCellHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case PrepareGoodSectionTypeAdvice:
                {
                    if (self.settingInfo.goodDetailShowAdvice) {
                        
                        return WMGoodAdviceTableViewCellHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case PrepareGoodSectionTypeSpecInfo:
                {
                    return WMGoodShowInfoTableViewCellHeight;
                }
                    break;
                case PrepareGoodSectionTypeBrief:
                {
                    if (self.goodBrief) {
                        
                        return MAX(WMGoodTextMinHeight, [self.goodBrief boundsWithConstraintWidth:_width_ - WMGoodTextExtraWidth].height) + WMGoodPureTextTableViewCellHeight - WMGoodTextMinHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case PrepareGoodSectionTypeTag:
                {
                    if (self.goodTagsArr.count) {
                        
                        return [WMGoodDetailOperation returnTagContentHeightWithMaxWidth:_width_ - WMGoodTagExtraWidth titlesArr:self.goodTagsArr extraWidth:WMGoodTagContentExtraWidth tagCellHeight:25.0];
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case PrepareGoodSectionTypeBrand:
                {
                    if (self.goodBrandInfo) {
                        
                        return WMGoodBrandTableViewCellHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case PrepareGoodSectionTypeLinkGood:
                {
                    CGFloat collectViewHeight = [WMGoodDetailOperation returnGoodCollectionViewCellHeight];
                    
                    if (self.goodSimilarGoodsArr.count) {
                        
                        return self.goodSimilarGoodsArr.count > 3 ? collectViewHeight + WMGoodLinkExtraHeight : collectViewHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case PrepareGoodSectionTypeLoadMore:
                {
                    return WMUpLoadMoreTableViewCellHeight;
                }
                    break;
                default:
                {
                    return CGFLOAT_MIN;
                }
                    break;
            }
        }
            break;
        default:
        {
            return CGFLOAT_MIN;
        }
            break;
    }
    
    return CGFLOAT_MIN;
}

/**返回商品详情页头部视图高度
 */
- (CGFloat)returnGoodDetailInfoHeaderViewHeightWithSection:(NSInteger)section{
    
    CGFloat sectionHeight = 10.0;
    
    switch (self.type)
    {
        case GoodPromotionTypeNothing:
        case GoodPromotionTypeSecondKill:
        case GoodPromotionTypeGift:
        {
            switch (section)
            {
                case GoodSectionTypeSecondKillLimit:
                {
                    if (self.type == GoodPromotionTypeSecondKill) {
                        
                        return _separatorLineWidth_;
                    }
                    
                    return CGFLOAT_MIN;
                }
                    break;
                case GoodSectionTypeSale:
                {
                    if (self.type == GoodPromotionTypeGift) {
                        
                        return _separatorLineWidth_;
                    }
                    else{
                        
                        if (self.goodBuyCount.integerValue == 0) {
                            
                            return CGFLOAT_MIN;
                        }
                        else{
                            
                            return _separatorLineWidth_;
                        }
                    }
                }
                    break;
                case GoodSectionTypeStore:
                {
                    return CGFLOAT_MIN;
                }
                    break;
                case GoodSectionTypePromotion:
                case GoodSectionTypeComment:
                case GoodSectionTypeAdvice:
                {
                    return CGFLOAT_MIN;
                }
                    break;
                case GoodSectionTypeSpecInfo:
                {
                    return sectionHeight;
                }
                    break;
                case GoodSectionTypeBrief:
                {
                    if (self.goodBrief) {
                        
                        return sectionHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case GoodSectionTypeBrand:
                {
                    if (self.goodBrandInfo) {
                        
                        return sectionHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case GoodSectionTypeTag:
                {
                    if (self.goodTagsArr.count) {
                        
                        return sectionHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case GoodSectionTypeLinkAdjGood:
                {
                    if (self.goodSimilarGoodsArr.count || self.goodAdjGroupsArr.count){
                        
                        return 65.0;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case GoodSectionTypeLoadMore:
                {
                    return sectionHeight;
                }
                    break;
                default:
                {
                    return CGFLOAT_MIN;
                }
                    break;
            }
        }
            break;
        case GoodPromotionTypePrepare:
        {
            switch (section) {
                case PrepareGoodSectionTypeStatus:
                case PrepareGoodSectionTypeComment:
                case PrepareGoodSectionTypeAdvice:
                {
                    return CGFLOAT_MIN;
                }
                    break;
                case PrepareGoodSectionTypeSpecInfo:
                {
                    return sectionHeight;
                }
                    break;
                case PrepareGoodSectionTypeBrief:
                {
                    if (self.goodBrief) {
                        
                        return sectionHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case PrepareGoodSectionTypeBrand:
                {
                    if (self.goodBrandInfo) {
                        
                        return sectionHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case PrepareGoodSectionTypeTag:
                {
                    if (self.goodTagsArr.count) {
                        
                        return sectionHeight;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case PrepareGoodSectionTypeLoadMore:
                {
                    return sectionHeight;
                }
                    break;
                case PrepareGoodSectionTypeLinkGood:
                {
                    if (self.goodSimilarGoodsArr.count) {
                        
                        return 65.0;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                default:
                {
                    return CGFLOAT_MIN;
                }
                    break;
            }
        }
            break;
        default:
        {
            return CGFLOAT_MIN;
        }
            break;
    }
}
/**返回商品详情页尾部视图高度
 */
- (CGFloat)returnGoodDetailInfoFooterViewHeightWithSection:(NSInteger)section{
    
    switch (self.type) {
        case GoodPromotionTypeNothing:
        case GoodPromotionTypeSecondKill:
        case GoodPromotionTypeGift:
        {
            switch (section) {
                case GoodSectionTypeSecondKillLimit:
                {                    
                    return CGFLOAT_MIN;
                }
                    break;
                case GoodSectionTypeSale:
                {
                    if (self.type == GoodPromotionTypeGift) {
                        
                        return _separatorLineWidth_;
                    }
                    
                    if (![NSString isEmpty:self.goodStore]) {
                        
                        return _separatorLineWidth_;
                    }
                    
                    return CGFLOAT_MIN;
                }
                    break;
                case GoodSectionTypeStore:
                {
                    return _separatorLineWidth_;
                }
                    break;
                case GoodSectionTypeComment:
                {
                    if (self.settingInfo.goodDetailShowComment) {
                        
                        return _separatorLineWidth_;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                case GoodSectionTypePromotion:
                {
                    if (self.promotionInfo) {
                        
                        return _separatorLineWidth_;
                    }
                    else{
                        
                        return CGFLOAT_MIN;
                    }
                }
                    break;
                default:
                {
                    return CGFLOAT_MIN;
                }
                    break;
            }
        }
            break;
        case GoodPromotionTypePrepare:
        {
            switch (section) {
                case PrepareGoodSectionTypeStatus:
                {
                    return _separatorLineWidth_;
                }
                    break;
                case PrepareGoodSectionTypeComment:
                {
                    if (self.promotionInfo.isDropDownShow) {
                        
                        return CGFLOAT_MIN;
                    }
                    else{
                        
                        return _separatorLineWidth_;
                    }
                }
                    break;
                default:
                {
                    return CGFLOAT_MIN;
                }
                    break;
            }
        }
            break;
        default:
        {
            return CGFLOAT_MIN;
        }
            break;
    }
}
/**更改商品购买数量规格显示
 */
+ (NSAttributedString *)changeGoodBuyQuantityWithNewQuantity:(NSInteger)quantity specInfosArr:(NSArray *)specInfosArr goodUnit:(NSString *)unit
{
    NSMutableString *contentString = [NSMutableString new];
    
    if (specInfosArr.count) {
        
        for (WMGoodDetailSpecInfo *specInfo in specInfosArr) {
            
            for (WMGoodDetailSpecValueInfo *valueInfo in specInfo.specValueInfosArr) {
                
                if (valueInfo.valueSelect) {
                    
                    [contentString appendString:[NSString stringWithFormat:@"%@、",valueInfo.valueSpecName]];
                    
                    break;
                }
            }
        }
    }
    
    [contentString appendString:[NSString stringWithFormat:@"%ld%@",(long)quantity,unit]];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    
    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, contentString.length)];
    
    return attrString;
}

/**更新数据
 */
- (void)updataGoodDetailInfoWithDetailInfo:(WMGoodDetailInfo *)info{
    
    self.type = info.type;
    
    self.settingInfo = info.settingInfo;
    
    self.goodBuyQuantity = 1;
    
    self.pointInfo = info.pointInfo;
    
    self.adviceCount = info.adviceCount;
    
    self.shareURL = info.shareURL;
    
    self.goodMenuBarInfosArr = info.goodMenuBarInfosArr;
    
    self.goodAdjGroupsArr = info.goodAdjGroupsArr;
    
    self.goodAdjGroupsNameArr = info.goodAdjGroupsNameArr;
    
    self.goodDetailParamsArr = info.goodDetailParamsArr;
    
    self.goodPropsArr = info.goodPropsArr;
    
    self.goodTagsArr = info.goodTagsArr;
    
    self.goodSpecInfosArr = info.goodSpecInfosArr;
    
    self.goodImagesArr = info.goodImagesArr;
    
    self.goodSimilarGoodsArr = info.goodSimilarGoodsArr;
    
    self.goodBrandInfo = info.goodBrandInfo;
    
    self.promotionInfo = info.promotionInfo;
    
    self.prepareInfo = info.prepareInfo;
    
    self.prepareAttrString = info.prepareAttrString;
    
    self.secondKillInfo = info.secondKillInfo;
    
    self.giftMessageInfo = info.giftMessageInfo;
    
    self.goodID = info.goodID;
    
    self.goodBuyCount = info.goodBuyCount;
    
    self.productID = info.productID;
    
    self.goodBNCode = info.goodBNCode;
    
    self.goodQRCode = info.goodQRCode;
    
    self.goodIntro = info.goodIntro;
    
    self.goodUnit = info.goodUnit;
    
    self.goodName = info.goodName;
    
    self.productBNCode = info.productBNCode;
    
    self.goodBrief = info.goodBrief;
    
    self.goodTypeName = info.goodTypeName;
    
    self.goodCatName = info.goodCatName;
    
    self.goodShowPrice = info.goodShowPrice;
    
    self.goodShowPriceName = info.goodShowPriceName;
    
    self.goodMinPrice = info.goodMinPrice;
    
    self.goodMinPriceName = info.goodMinPriceName;
    
    self.goodMarketName = info.goodMarketName;
    
    self.goodMarketPrice = info.goodMarketPrice;
    
    self.goodSavePrice = info.goodSavePrice;
    
    self.goodSavePriceName = info.goodSavePriceName;
    
    self.goodSavePriceUnit = info.goodSavePriceUnit;
    
    self.selectSpecProductImage = info.selectSpecProductImage;
    
    self.marketAble = info.marketAble;
        
    self.buttonPageList = info.buttonPageList;
    
    self.goodStore = info.goodStore;
    
    self.goodLismitCout = info.goodLismitCout;
    
    self.specInfoAttrString = info.specInfoAttrString;
    
    self.goodIsFav = info.goodIsFav;
    
}















@end
