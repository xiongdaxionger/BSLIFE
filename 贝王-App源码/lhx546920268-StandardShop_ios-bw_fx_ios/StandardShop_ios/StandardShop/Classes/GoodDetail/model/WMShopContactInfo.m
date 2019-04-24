//
//  WMShopContactInfo.m
//  StandardShop
//
//  Created by Hank on 16/11/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShopContactInfo.h"

@implementation WMShopContactInfo
- (instancetype)init{

    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearLogInUpLine) name:WMUserDidLogoutNotification object:nil];
    }
    
    return self;
}
- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clearLogInUpLine{

    self.upLineShopName = nil;
}

///单例
+ (instancetype)shareInstance
{
    static WMShopContactInfo *info = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        info = [[WMShopContactInfo alloc] init];
        
    });
    
    return info;
}

/**初始化
 */
- (void)getShopContactInfo:(NSDictionary *)dict{

    if ([AppDelegate instance].isLogin) {
        
        self.upLineShopName = [dict sea_stringForKey:@"owner"];
        
        self.upLineContactName = [dict sea_stringForKey:@"contact"];
        
        self.upLineLocalPhone = [dict sea_stringForKey:@"telephone"];
        
        self.upLineTelePhone = [dict sea_stringForKey:@"mobile"];
        
        self.upLineQQMail = [dict sea_stringForKey:@"email"];
        
        self.upLineQQNumber = [dict sea_stringForKey:@"qq"];
        
        NSString *addressString = [dict sea_stringForKey:@"address"];
        
        if ([addressString rangeOfString:@"main"].location != NSNotFound) {
            
            NSString *address = [[addressString componentsSeparatedByString:@":"] objectAtIndex:1];
            
            self.upLineAddress = address;
        }
        else{
            
            self.upLineAddress = addressString;
        }
        
        self.upLineZipCode = [dict sea_stringForKey:@"zip_code"];
        
        NSMutableString *string = [NSMutableString new];
        
        if (![NSString isEmpty:self.upLineShopName]) {
            
            [string appendString:[NSString stringWithFormat:@"上线:%@\n",self.upLineShopName]];
        }
        
        if (![NSString isEmpty:self.upLineContactName]) {
            
            [string appendString:[NSString stringWithFormat:@"联系人:%@\n",self.upLineContactName]];
        }
        
        if (![NSString isEmpty:self.upLineLocalPhone]) {
            
            [string appendString:[NSString stringWithFormat:@"固定电话:%@\n",self.upLineLocalPhone]];
        }
        
        if (![NSString isEmpty:self.upLineTelePhone]) {
            
            [string appendString:[NSString stringWithFormat:@"手机:%@\n",self.upLineTelePhone]];
        }
        
        if (![NSString isEmpty:self.upLineQQMail]) {
            
            [string appendString:[NSString stringWithFormat:@"QQ邮箱:%@\n",self.upLineQQMail]];
        }
        
        if (![NSString isEmpty:self.upLineQQNumber]) {
            
            [string appendString:[NSString stringWithFormat:@"QQ号码:%@\n",self.upLineQQNumber]];
        }
        
        if (![NSString isEmpty:self.upLineAddress]) {
            
            [string appendString:[NSString stringWithFormat:@"地址:%@\n",self.upLineAddress]];
        }
        
        if (![NSString isEmpty:self.upLineZipCode]) {
            
            [string appendString:[NSString stringWithFormat:@"邮编:%@",self.upLineZipCode]];
        }
        
        NSMutableParagraphStyle *paragarphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragarphStyle setLineSpacing:8];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragarphStyle range:NSMakeRange(0, [string length])];
        
        [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:MainFontName size:15.0] range:NSMakeRange(0, [string length])];
        
        self.upLineAttrString = attrString;

    }
    else{
    
        self.shopName = [dict sea_stringForKey:@"owner"];
        
        self.contactName = [dict sea_stringForKey:@"contact"];
        
        self.localPhone = [dict sea_stringForKey:@"telephone"];
        
        self.telePhone = [dict sea_stringForKey:@"mobile"];
        
        self.qqMail = [dict sea_stringForKey:@"email"];
        
        self.qqNumber = [dict sea_stringForKey:@"qq"];
        
        self.address = [dict sea_stringForKey:@"address"];
        
        self.zipCode = [dict sea_stringForKey:@"zip_code"];
        
        NSMutableString *string = [NSMutableString new];
        
        if (![NSString isEmpty:self.shopName]) {
            
            [string appendString:[NSString stringWithFormat:@"上线:%@\n",self.shopName]];
        }
        
        if (![NSString isEmpty:self.contactName]) {
            
            [string appendString:[NSString stringWithFormat:@"联系人:%@\n",self.contactName]];
        }
        
        if (![NSString isEmpty:self.localPhone]) {
            
            [string appendString:[NSString stringWithFormat:@"固定电话:%@\n",self.localPhone]];
        }
        
        if (![NSString isEmpty:self.telePhone]) {
            
            [string appendString:[NSString stringWithFormat:@"手机:%@\n",self.telePhone]];
        }
        
        if (![NSString isEmpty:self.qqMail]) {
            
            [string appendString:[NSString stringWithFormat:@"QQ邮箱:%@\n",self.qqMail]];
        }
        
        if (![NSString isEmpty:self.qqNumber]) {
            
            [string appendString:[NSString stringWithFormat:@"QQ号码:%@\n",self.qqNumber]];
        }
        
        if (![NSString isEmpty:self.address]) {
            
            [string appendString:[NSString stringWithFormat:@"地址:%@\n",self.address]];
        }
        
        if (![NSString isEmpty:self.zipCode]) {
            
            [string appendString:[NSString stringWithFormat:@"邮编:%@",self.zipCode]];
        }
        
        NSMutableParagraphStyle *paragarphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragarphStyle setLineSpacing:8];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragarphStyle range:NSMakeRange(0, [string length])];
        
        [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:MainFontName size:15.0] range:NSMakeRange(0, [string length])];
        
        self.attrString = attrString;
    }
}


























@end
