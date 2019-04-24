//
//  WMGoodDetailOperation.m
//  WanShoes
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailOperation.h"
#import "WMGoodSimilarInfo.h"
#import "WMUserOperation.h"
#import "WMGoodDetailSellLogInfo.h"
#import "WMGoodDetailInfo.h"
#import "WMGoodDetailPromotionInfo.h"
#import "WMShopContactInfo.h"
#import "XTableCellConfigEx.h"

@implementation WMGoodDetailOperation
#pragma mark - new
/**获取商品详情 参数
 *@param 货品ID productID
 *@param 是否为积分兑换赠品 isGift
 */
+ (NSDictionary *)returnGoodDetailParamWithProductID:(NSString *)productID isGift:(BOOL)isGift{
    
    if (isGift) {
        
        return @{WMHttpMethod:@"b2c.product.index",@"product_id":productID,@"type":@"gift"};
    }
    else{
        
        return @{WMHttpMethod:@"b2c.product.index",@"product_id":productID,@"type":@"product"};
    }
}
/**获取商品详情 结果
 *@return WMGoodDetailInfo
 */
+ (id)returnGoodDetailInfoWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return [WMGoodDetailInfo returnGoodDetailInfoWithDict:[dict dictionaryForKey:WMHttpData]];
    }
    else{
        
        return [dict sea_stringForKey:@"msg"];
    }
    
    return nil;
}

/**获取商品相似商品 参数
 *@param 商品ID goodID
 */
+ (NSDictionary *)returnGoodSimilarGoodParamWithGoodID:(NSString *)goodID{
    
    return @{@"goods_id":goodID,WMHttpMethod:@"b2c.product.goodsLink"};
}

/**返回商品相似商品 结果
 */
+ (NSArray *)returnGoodSimilarArrWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
    
        NSDictionary *goodsLinkDict = [[dict dictionaryForKey:WMHttpData] dictionaryForKey:@"page_goodslink"];
        
        NSArray *similarInfosArr = [WMGoodSimilarInfo createViewModelArryWithArry:[goodsLinkDict arrayForKey:@"link"]];
        
        NSDictionary *productIDDict = [goodsLinkDict dictionaryForKey:@"products"];
        
        for (WMGoodSimilarInfo *info in similarInfosArr) {
            
            info.similarProductID = [productIDDict sea_stringForKey:info.similarGoodsId];
        }
        
        return similarInfosArr;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}

/**获取货品的信息 参数--选择某个规格后之后调用
 *@param 货品ID productID
 *@param 是否为赠品 isGift
 */
+ (NSDictionary *)returnProductInfoWithProductID:(NSString *)productID isGift:(BOOL)isGift{
    
    if (isGift) {
        
        return @{WMHttpMethod:@"b2c.product.basic",@"product_id":productID,@"type":@"gift"};
    }
    else{
        
        return @{WMHttpMethod:@"b2c.product.basic",@"product_id":productID,@"type":@"product"};
    }
}

/**获取商品的销售记录 参数
 *@param 商品ID goodID
 *@param 页码 page
 */
+ (NSDictionary *)returnGoodSellLogWithGoodID:(NSString *)goodID page:(NSInteger)page{
    
    return @{WMHttpMethod:@"b2c.product.goodsSellLoglist",@"goods_id":goodID,@"page":[NSNumber numberWithInteger:page]};
}

/**返回商品的销售记录 结果
 *@return 销售记录数组--sellLog 是否展示购买价--showPrice 总数--total
 */
+ (NSDictionary *)returnGoodSellLogWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        NSDictionary *dataDict = [dict dictionaryForKey:WMHttpData];
        
        NSInteger total = [WMUserOperation totalSizeFromDictionary:dataDict];
        
        NSNumber *showPrice = [NSNumber numberWithBool:[[dataDict sea_stringForKey:@"selllog_member_price"] isEqualToString:@"true"]];
        
        NSArray *sellLogInfosArr = [WMGoodDetailSellLogInfo returnSellLogInfosArrWithDictsArr:[[dataDict dictionaryForKey:@"sellLogList"] arrayForKey:@"data"]];
        
        return @{@"sellLog":sellLogInfosArr,@"showPrice":showPrice,@"total":[NSNumber numberWithInteger:total]};
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}

/**计算标签高度
 *@param 最大宽度 maxWidth
 *@param 内容数组,元素是NSString titlesArr
 *@param 额外宽度 extraWidth
 *@param cell的高度 cellHeight
 */
+ (CGFloat)returnTagContentHeightWithMaxWidth:(CGFloat)maxWidth titlesArr:(NSArray *)titlesArr extraWidth:(CGFloat)extraWidth tagCellHeight:(CGFloat)tagCellHeight{
    
    if (titlesArr == nil || titlesArr.count == 0) {
        
        return 0.0;
    }
    
    CGFloat sectionTopInset = 10.0;
    
    CGFloat sectionBottomInset = 10.0;
    
    CGFloat defaultHeight = tagCellHeight;
    
    CGFloat lineSpace = 10.0;
    
    CGFloat sumWidth = 0.0;
    
    NSInteger rowCount = 0;
    
    UIFont *font = [UIFont systemFontOfSize:15.0];
    
    for (NSString *title in titlesArr) {
        
        CGFloat contentWidth = [title stringSizeWithFont:font contraintWith:maxWidth].width + extraWidth;
        
        sumWidth += contentWidth;
        
        if (sumWidth > maxWidth) {
            
            sumWidth = contentWidth;
            
            rowCount ++;
        }
    }
    
//    if (rowCount == 0) {
    
    rowCount += 1;
//    }
//    
//    NSString *lastTitle = [titlesArr lastObject];
//    
//    if (sumWidth + [lastTitle stringSizeWithFont:font contraintWith:maxWidth].width + extraWidth > maxWidth) {
//        
//        rowCount += 1;
//    }
    
    return rowCount * defaultHeight + (rowCount - 1) * lineSpace + sectionBottomInset + sectionTopInset;
}

/**商品详情配置类--秒杀商品和普通商品
 */
+ (NSArray *)returnSecondKillCommonGoodTableConfigWithTableView:(UITableView *)tableView{
    
    NSMutableArray *configsArr = [NSMutableArray new];
    
    XTableCellConfigEx *secondKillLimitConfig = [XTableCellConfigEx cellConfigWithClassName:[WMSaleStoreCountTableViewCell class] heightOfCell:WMSaleStoreCountTableViewCellHeight tableView:tableView isNib:YES];

    [configsArr addObject:@[secondKillLimitConfig]];
    
    XTableCellConfigEx *saleConfig = [XTableCellConfigEx cellConfigWithClassName:[WMSaleStoreCountTableViewCell class] heightOfCell:WMSaleStoreCountTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[saleConfig]];
    
    XTableCellConfigEx *storeConfig = [XTableCellConfigEx cellConfigWithClassName:[WMSaleStoreCountTableViewCell class] heightOfCell:WMSaleStoreCountTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[storeConfig]];
    
    XTableCellConfigEx *promotionDropConfig = [XTableCellConfigEx cellConfigWithClassName:[WMPromotionDropTableViewCell class] heightOfCell:WMPromotionDropTableViewCellHeight tableView:tableView isNib:YES];
    
    XTableCellConfigEx *promotionUpConfig = [XTableCellConfigEx cellConfigWithClassName:[WMPromotionUpTableViewCell class] heightOfCell:WMPromotionUpTableViewCellHeight tableView:tableView isNib:YES];
    
    XTableCellConfigEx *promotionContentConfig = [XTableCellConfigEx cellConfigWithClassName:[WMPromotionContentTableViewCell class] heightOfCell:WMPromotionContentTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[promotionDropConfig,promotionUpConfig,promotionContentConfig]];
    
    XTableCellConfigEx *commentConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodCommentTableViewCell class] heightOfCell:WMGoodCommentTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[commentConfig]];
    
    XTableCellConfigEx *adviceConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodAdviceTableViewCell class] heightOfCell:WMGoodAdviceTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[adviceConfig]];
    
    XTableCellConfigEx *extraInfoConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodShowInfoTableViewCell class] heightOfCell:WMGoodShowInfoTableViewCellHeight tableView:tableView isNib:YES];

    XTableCellConfigEx *specInfoConfig = [XTableCellConfigEx cellConfigWithClassName:[WMSelectSpecInfoTableViewCell class] heightOfCell:WMSelectSpecInfoTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[extraInfoConfig,specInfoConfig]];
    
    XTableCellConfigEx *textConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodPureTextTableViewCell class] heightOfCell:WMGoodPureTextTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[textConfig]];
    
    XTableCellConfigEx *tagConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodTagTableViewCell class] heightOfCell:WMGoodTagTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[tagConfig]];
    
    XTableCellConfigEx *brandConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodBrandTableViewCell class] heightOfCell:WMGoodBrandTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[brandConfig]];
    
    XTableCellConfigEx *goodLinkConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodLinkTableViewCell class] heightOfCell:WMGoodLinkTableViewCellHeight tableView:tableView isNib:YES];
    
    XTableCellConfigEx *goodAdjConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodAdjTableViewCell class] heightOfCell:WMGoodAdjTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[goodLinkConfig,goodAdjConfig]];
    
    XTableCellConfigEx *loadMoreConfig = [XTableCellConfigEx cellConfigWithClassName:[WMUpLoadMoreTableViewCell class] heightOfCell:WMUpLoadMoreTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[loadMoreConfig]];

    return configsArr;
}

/**商品详情配置类--预售商品
 */
+ (NSArray *)returnPrepareGoodTableConfigWithTableView:(UITableView *)tableView{
    
    NSMutableArray *configsArr = [NSMutableArray new];

    XTableCellConfigEx *prepareTextConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodPureTextTableViewCell class] heightOfCell:WMGoodPureTextTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[prepareTextConfig]];
    
    XTableCellConfigEx *commentConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodCommentTableViewCell class] heightOfCell:WMGoodCommentTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[commentConfig]];
    
    XTableCellConfigEx *adviceConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodAdviceTableViewCell class] heightOfCell:WMGoodAdviceTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[adviceConfig]];
    
    XTableCellConfigEx *extraInfoConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodShowInfoTableViewCell class] heightOfCell:WMGoodShowInfoTableViewCellHeight tableView:tableView isNib:YES];
    
    XTableCellConfigEx *specInfoConfig = [XTableCellConfigEx cellConfigWithClassName:[WMSelectSpecInfoTableViewCell class] heightOfCell:WMSelectSpecInfoTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[extraInfoConfig,specInfoConfig]];
    
    XTableCellConfigEx *briefTextConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodPureTextTableViewCell class] heightOfCell:WMGoodPureTextTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[briefTextConfig]];
    
    XTableCellConfigEx *tagConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodTagTableViewCell class] heightOfCell:WMGoodTagTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[tagConfig]];
    
    XTableCellConfigEx *brandConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodBrandTableViewCell class] heightOfCell:WMGoodBrandTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[brandConfig]];
    
    XTableCellConfigEx *goodLinkConfig = [XTableCellConfigEx cellConfigWithClassName:[WMGoodLinkTableViewCell class] heightOfCell:WMGoodLinkTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[goodLinkConfig]];
    
    XTableCellConfigEx *loadMoreConfig = [XTableCellConfigEx cellConfigWithClassName:[WMUpLoadMoreTableViewCell class] heightOfCell:WMUpLoadMoreTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[loadMoreConfig]];
    
    return configsArr;
}

/**返回商品详情的促销信息行数
 */
+ (NSInteger)returnGoodPromotionRowCountWith:(WMGoodDetailPromotionInfo *)promotionInfo{
    
    if (promotionInfo) {
        
        NSInteger rowCount = 0;
        
        if (promotionInfo.goodPromotionInfo) {
            
            rowCount += promotionInfo.goodPromotionInfo.promotionContentArr.count;
        }
        
        if (promotionInfo.orderPromotionInfo) {
            
            rowCount += promotionInfo.orderPromotionInfo.promotionContentArr.count;
        }
        
        if (promotionInfo.giftPromotionInfo) {
            
            rowCount += 1;
        }
        
        return promotionInfo.isDropDownShow ? rowCount : 1;
    }
    else{
        
        return 0;
    }
}
/**返回单个商品集合视图的高度
 */
+ (CGFloat)returnGoodCollectionViewCellHeight{
    
    CGFloat sectionInset = 5.0;
    
    CGFloat imageMargin = 4.0;
    
    CGFloat topMargin = 8.0;
    
    CGFloat cellWidth = (_width_ - sectionInset * 4) / 3.0;
    
    CGFloat cellHeight = topMargin + (cellWidth - imageMargin * 2) + 80;
    
    return cellHeight;
}

/**提交商品缺货登记 参数
 *@param 商品ID goodID
 *@param 货品ID productID
 *@param 电话 cellPhone
 *@param 邮箱 email
 */
+ (NSDictionary *)returnGoodCommitNotifyWithGoodID:(NSString *)goodID productID:(NSString *)productID cellPhone:(NSString *)cellPhone email:(NSString *)email{
    
    if ([NSString isEmpty:email]) {
        
        return @{WMHttpMethod:@"b2c.product.toNotify",@"goods_id":goodID,@"product_id":productID,@"cellphone":cellPhone};
    }
    else{
        
        return @{WMHttpMethod:@"b2c.product.toNotify",@"goods_id":goodID,@"product_id":productID,@"email":email};
    }
}
/**提交商品缺货登记 结果
 */
+ (BOOL)returnGoodCommitNotifyWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *codeString = [dict sea_stringForKey:@"code"];
    
    if ([codeString isEqualToString:WMHttpSuccess]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}

/**记录商品访问量 参数
 *@param 商品ID goodID
 */
+ (NSDictionary *)returnRecordGoodVisitParamWithGoodID:(NSString *)goodID{
    
    return @{WMHttpMethod:@"b2c.product.cron",@"goods_id":goodID};
}

/**获取商家的联系信息
 */
+ (NSDictionary *)returnShopContactInfoParam{

    return @{WMHttpMethod:@"b2c.activity.shopinfo",@"default":@"default"};
}
/**返回商家的联系信息
 */
+ (NSDictionary *)returnShopContactInfo:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *rspString = [dict sea_stringForKey:@"code"];
    
    if ([rspString isEqualToString:WMHttpSuccess]) {
        
        NSDictionary *dictValue = [dict dictionaryForKey:WMHttpData];
        
         [[WMShopContactInfo shareInstance] getShopContactInfo:dictValue];
        
        return dictValue;
    }
    else{
    
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return nil;
}

+ (CNMutableContact *)getContactIsExist:(BOOL)isExist contact:(CNMutableContact *)contact{

    WMShopContactInfo *info = [WMShopContactInfo shareInstance];
    
    NSString *contactName = [AppDelegate instance].isLogin ? info.upLineContactName : info.contactName;
    
    if (!isExist) {
        contact.nickname = contactName;
    }
    
    NSString *telePhone = [AppDelegate instance].isLogin ? info.upLineTelePhone : info.telePhone;
    
    NSString *localPhone = [AppDelegate instance].isLogin ? info.upLineLocalPhone : info.localPhone;

    CNLabeledValue *phoneNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:[NSString isEmpty:telePhone] ? @"" : telePhone]];
    
    CNLabeledValue *telePhoneNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:[NSString isEmpty:localPhone] ? @"" : localPhone]];
    
    if (!isExist) {
        
        contact.phoneNumbers = @[phoneNumber,telePhoneNumber];
        
    }else{
        
        if ([contact.phoneNumbers count] > 0) {
            
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] initWithArray:contact.phoneNumbers];
            
            [phoneNumbers addObject:phoneNumber];
            
            [phoneNumbers addObject:telePhoneNumber];
            
            contact.phoneNumbers = phoneNumbers;
            
        }else{
            
            contact.phoneNumbers = @[phoneNumber,telePhoneNumber];
        }
    }
    
    NSString *qqMail = [AppDelegate instance].isLogin ? info.upLineQQMail : info.qqMail;
    
    CNLabeledValue *mail = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:[NSString isEmpty:qqMail] ? @"" : qqMail];
    
    if (!isExist) {
        
        contact.emailAddresses = @[mail];
        
    }else{
        
        if ([contact.emailAddresses count] > 0) {
            
            NSMutableArray *emails = [[NSMutableArray alloc] initWithArray:contact.emailAddresses];
            
            [emails addObject:mail];
            
            contact.emailAddresses = emails;
            
        }else{
            
            contact.emailAddresses = @[mail];
        }
    }
    
    CNMutablePostalAddress *address = [[CNMutablePostalAddress alloc] init];
    
    address.state = @"广东省";
    
    address.city = @"广州市";
    
    NSString *zipCode = [AppDelegate instance].isLogin ? info.upLineZipCode : info.zipCode;
    
    address.postalCode = [NSString isEmpty:zipCode] ? @"" : zipCode;
    
    NSString *addressString = [AppDelegate instance].isLogin ? info.upLineAddress : info.address;
    
    address.street = [NSString isEmpty:addressString] ? @"" : addressString;
    
    CNLabeledValue *addressLabel = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:address];
    
    if (!isExist) {
        
        contact.postalAddresses = @[addressLabel];
        
    }else{
        
        if ([contact.postalAddresses count] > 0) {
            
            NSMutableArray *addresses = [[NSMutableArray alloc] initWithArray:contact.postalAddresses];
            
            [addresses addObject:addressLabel];
            
            contact.postalAddresses = addresses;
            
        }else{
            
            contact.postalAddresses = @[addressLabel];
        }
    }
    
    return contact;
}

+ (ABRecordRef)getAddressBookRecord{

    ABRecordRef displayedPerson = ABPersonCreate();
    
    ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    
    CFMutableDictionaryRef addr = CFDictionaryCreateMutable(NULL, 1, NULL, NULL);
    
    CFMutableDictionaryRef zipcode = CFDictionaryCreateMutable(NULL, 1, NULL, NULL);
    
    CFMutableDictionaryRef city = CFDictionaryCreateMutable(NULL, 1, NULL, NULL);

    CFMutableDictionaryRef country = CFDictionaryCreateMutable(NULL, 1, NULL, NULL);
    
    WMShopContactInfo *info = [WMShopContactInfo shareInstance];
    
    NSString *contactName = [AppDelegate instance].isLogin ? info.upLineContactName : info.contactName;
    
    if(![NSString isEmpty:contactName])
    {
        ABRecordSetValue(displayedPerson, kABPersonFirstNameProperty, CFBridgingRetain(contactName), nil);
    }
    
    NSString *qqMail = [AppDelegate instance].isLogin ? info.upLineQQMail : info.qqMail;
    
    if (![NSString isEmpty:qqMail]) {
        
        ABRecordSetValue(displayedPerson, kABPersonEmailProperty, CFBridgingRetain(qqMail), nil);
    }
    
    NSString *address = [AppDelegate instance].isLogin ? info.upLineAddress : info.address;
    
    if(![NSString isEmpty:address])
    {
        CFDictionaryAddValue(addr, kABPersonAddressStateKey, CFBridgingRetain(address));
        
        ABMultiValueAddValueAndLabel(multiValue, addr, kABHomeLabel, NULL);
        
        ABRecordSetValue(displayedPerson, kABPersonAddressProperty, multiValue, nil);
    }
    
    NSString *zipCode = [AppDelegate instance].isLogin ? info.upLineZipCode : info.zipCode;
    
    if (![NSString isEmpty:zipCode]) {
        
        CFDictionaryAddValue(zipcode, kABPersonAddressZIPKey, CFBridgingRetain(zipCode));
        
        ABMultiValueAddValueAndLabel(multiValue, zipcode, kABHomeLabel, NULL);
        
        ABRecordSetValue(displayedPerson, kABPersonAddressProperty, multiValue, nil);
    }
    
    CFDictionaryAddValue(city, kABPersonAddressCityKey, CFBridgingRetain(@"广州市"));
    
    ABMultiValueAddValueAndLabel(multiValue, city, kABHomeLabel, NULL);
    
    ABRecordSetValue(displayedPerson, kABPersonAddressProperty, multiValue, nil);
    
    CFDictionaryAddValue(country, kABPersonAddressCountryKey, CFBridgingRetain(@"广东省"));
    
    ABMultiValueAddValueAndLabel(multiValue, country, kABHomeLabel, NULL);
    
    ABRecordSetValue(displayedPerson, kABPersonAddressProperty, multiValue, nil);
    
    CFRelease(multiValue);
    
    CFRelease(addr);
    
    multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    NSString *telePhone = [AppDelegate instance].isLogin ? info.upLineTelePhone : info.telePhone;
    
    if(![NSString isEmpty:telePhone])
    {
        ABMultiValueAddValueAndLabel(multiValue, CFBridgingRetain(telePhone), kABPersonPhoneMainLabel, NULL);
        
        ABRecordSetValue(displayedPerson, kABPersonPhoneProperty, multiValue, nil);
    }
    
    CFRelease(multiValue);
    
    return displayedPerson;
}

/**通过BN 获取商品的productId 参数
 *@param BN 商品BN
 */
+ (NSDictionary*)productIdFromBNParam:(NSString*) BN
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.product.bnParams", WMHttpMethod, BN, @"bn", nil];
}

/**通过BN 获取商品的productId 结果
 *@return 商品 BN
 */
+ (NSString*)productIdFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        return [[[dic dictionaryForKey:WMHttpData] dictionaryForKey:@"goods"] sea_stringForKey:@"product_id"];;
    }
    else
    {
        [AppDelegate needLoginFromDictionary:dic];
    }
    return nil;
}


@end
