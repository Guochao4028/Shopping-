//
//  SLAppInfoModel.m
//  Shaolin
//
//  Created by edz on 2020/3/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLAppInfoModel.h"
#include <objc/runtime.h>
#include <sys/utsname.h>
#import "WengenBannerModel.h"
#import "FoundModel.h"

#import "KungfuWebViewController.h"
#import "FoundDetailsViewController.h"
#import "GoodsDetailsViewController.h"
#import "KungfuClassDetailViewController.h"
#import "ClassifyHomeViewController.h"
#import "FoundVideoListVc.h"
#import "RiteSecondLevelListViewController.h"
#import "NSDate+BRPickerView.h"
#import "NSDate+LGFDate.h"

#import "WengenGoodsModel.h"
#import "DefinedHost.h"
#import "ADManager.h"
#import <SDWebImage/SDImageCache.h>

@implementation SLAppInfoModel
//全局变量
static SLAppInfoModel *currentUser = nil;
//单例方法
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentUser = [super allocWithZone:zone];
    });
    return currentUser;
}
- (id)copyWithZone:(NSZone *)zone
{
    return currentUser;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return currentUser;
}

- (SLAppInfoModel *)getCurrentUserInfo {
    if (!currentUser.id) {
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        NSData *userData = [standardDefaults objectForKey:@"currentUser"];
        if (userData) {
            @try {
                currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
            @finally {
                NSLog(@"finally");
            }
        }
    }
    
    return currentUser;
}

- (void)saveCurrentUserData {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
    [standardDefaults setObject:userData forKey:@"currentUser"];
    [standardDefaults synchronize];
}

- (void)setNil {
//    currentUser = nil;
//    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
//    [standardDefaults removeObjectForKey:@"currentUser"];
//    [standardDefaults synchronize];
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = [defs dictionaryRepresentation];
    for(id key in dict) {
        if ([key isEqualToString:@"currentUser"]) {
            [defs removeObjectForKey:key];
        }
    }
    [defs synchronize];
    
    [self setCurrentUserNil];
    
    // 退出登录同时清空taoken刷新时间
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTokenRefreshIn];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTokenExpiresIn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)modelWithDictionary:(NSDictionary*)jsonDic {
    NSArray *keys = [jsonDic allKeys];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (NSString *key in keys) {
        if ([self checkStringNull:[jsonDic objectForKey:key]]) {
            
            [dic setObject:@"" forKey:key];
        } else {
            [dic setObject:[NSString stringWithFormat:@"%@",[jsonDic objectForKey:key]] forKey:key];
        }
    }
    [currentUser setValuesForKeysWithDictionary:dic];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    NSLog(@"Undefined Key:%@ in %@", key, [self class]);
}

- (void)setCurrentUserNil {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
        NSString *capital = [[propertyName substringToIndex:1] uppercaseString];
        NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:", capital, [propertyName substringFromIndex:1]];
        
        SEL sel = NSSelectorFromString(setterSelStr);
        
        [self performSelectorOnMainThread:sel
                               withObject:nil
                            waitUntilDone:[NSThread isMainThread]];
    }
    
}

#pragma mark 数据持久化
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        
        if (propertyValue) {
            [aCoder encodeObject:propertyValue forKey:propertyName];
        }
    }
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super init];
    if (self) {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char* char_f = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            
            NSString *capital = [[propertyName substringToIndex:1] uppercaseString];
            NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:", capital, [propertyName substringFromIndex:1]];
            
            SEL sel = NSSelectorFromString(setterSelStr);
            
            [self performSelectorOnMainThread:sel
                                   withObject:[aCoder decodeObjectForKey:propertyName]
                                waitUntilDone:[NSThread isMainThread]];
        }
    }
    return self;
}
- (BOOL)checkStringNull:(NSString *)str {
    if ([str isEqual:[NSNull null]] || str == nil) {
        return YES;
    } else {
        if ([str isKindOfClass:[NSString class]]) {
            if ([str isEqualToString:@"null"] || [str isEqualToString:@"(null)"]) {
                return YES;
            }
        }
        return NO;
    }
}

#pragma mark - 轮播图和广告的点击响应
- (void)bannerEventResponseWithBannerModel:(WengenBannerModel *)bannerModel {
    /*
    contentUrl 说明
    type 1为外链 2为内链
    type为1时 直接取 contentUrl 进行跳转就好 比如 www.baidu.com
    type为2时 解析  contentUrl  对象
    contentUrl 参数说明
        type --1 列表  2详情
        module -- 1:发现 2:段品制 3:文创 4:活动
        field --栏目id
        valud --数据id
    如果type 为1时 valud没有值  直接取 field 获取相对应的列表
    如果type 为2是 要根据 valud 获取相对应模块的内容详情
    */
    if ([bannerModel.type intValue] == 1) {
        // 外链
        NSString * urlString = bannerModel.contentUrl;
        if ([urlString hasPrefix:@"www"]){
            urlString = [urlString stringByReplacingOccurrencesOfString:@"www" withString:@"https://www"];
        } else if ([urlString hasPrefix:@"http:"]){
            urlString = [urlString stringByReplacingOccurrencesOfString:@"http:" withString:@"https:"];
        }
        KungfuWebViewController * webVC = [[KungfuWebViewController alloc] initWithUrl:urlString type:0];
        if (bannerModel.bannerName.length){
            webVC.titleStr = bannerModel.bannerName;
        }
        [self pushController:webVC];
        
    }
    if ([bannerModel.type intValue] == 2) {

        BannerSubModel * subM = [self getBannerSubModelWithContent:bannerModel.contentUrl];
        
        [self bannerAndAdvertSelectHandleWithModel:subM];
    }
}



- (void)advertEventResponseWithFoundModel:(FoundModel *)foundModel
{
    WengenBannerModel *bannerModel = [[WengenBannerModel alloc] init];
    bannerModel.type = foundModel.classIf;
    bannerModel.contentUrl = foundModel.content;
    bannerModel.bannerName = foundModel.title;
    [[SLAppInfoModel sharedInstance] bannerEventResponseWithBannerModel:bannerModel];
}


// 广告、Banner为内链时的操作
- (void) bannerAndAdvertSelectHandleWithModel:(BannerSubModel *)subM
{
    // 内链
    int type = [subM.type intValue];
    int module = [subM.module intValue];
    int kind = [subM.kind intValue];
    NSString * fieldId = subM.fieldId;
    NSString * valud = subM.valud;
    // 1:水陆法会 2 普通法会 3 全年佛事 4 建寺安僧
    NSString * riteType = subM.pujaType;
    
    switch (module) {
        case 1:{
            // 发现
            if (type == 1) {
                [self postPageChangeNotification:KNotificationFoundPageChange index:fieldId];
            }
            if (type == 2) {
                
                if (kind == 3) {
                    // 视频
                    FoundVideoListVc *vc = [[FoundVideoListVc alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.fieldId = fieldId;
                    vc.videoId = valud;
                    vc.tabbarStr = @"Found";
                    vc.typeStr = @"1";
                    [self pushController:vc];
                } else {
                    FoundDetailsViewController *vc = [FoundDetailsViewController new];
                    vc.idStr = valud;
                    vc.tabbarStr = @"Found";
                    vc.typeStr = @"1";
                    vc.stateStr =  @"";
                    [self pushController:vc];
                }
            }
        }
            break;
        case 2:{
            // 段品制
            if (type == 1) {
                // 列表
                [self postPageChangeNotification:KNotificationKungfuPageChange index:fieldId];
            }
            if (type == 2) {
                // 详情
                [self kungfuPushDetailWithFieldId:fieldId valud:valud];
            }
        }
            break;
        case 3:{
            // 文创
            if (type == 1) {
               // 这里的逻辑直接写在 WengenViewController 中 ，因为一个valud无法处理
            }
            if (type == 2) {
                GoodsDetailsViewController *goodsDetailsVC = [GoodsDetailsViewController new];
                WengenGoodsModel *goodsModel = [WengenGoodsModel new];
                goodsModel.goodsId = valud;
                goodsDetailsVC.goodsModel = goodsModel;
                [self pushController:goodsDetailsVC];
            }
        }
            break;
        case 4:{
            // 活动
            if (type == 1) {
                [self postPageChangeNotification:KNotificationActivityPageChange index:fieldId];
            }
            if (type == 2) {
                if ([fieldId isEqualToString:@"-1"]) {
                    // 法会详情
                    [self pushRiteViewControllerWithRiteType:riteType riteId:valud];
                } else {
                    if (kind == 3) {
                        // 视频
                        FoundVideoListVc *vc = [[FoundVideoListVc alloc]init];
                        vc.hidesBottomBarWhenPushed = YES;
                        vc.fieldId = fieldId;
                        vc.videoId = valud;
                        vc.tabbarStr = @"Activity";
                        vc.typeStr = @"2";
                        [self pushController:vc];
                    } else {
                        FoundDetailsViewController *vc = [FoundDetailsViewController new];
                        vc.idStr = valud;
                        vc.tabbarStr = @"Activity";
                        vc.typeStr = @"2";
                        vc.stateStr =  @"";
                        [self pushController:vc];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}


- (void) kungfuPushDetailWithFieldId:(NSString *)fieldId valud:(NSString *)valud
{
    UIViewController * vc ;
    switch ([fieldId intValue]) {
        case 0:
            break;
        case 1:
            break;
        case 2:{
            NSString * url = URL_H5_EventRegistration(valud,self.accessToken);
            KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:url type:KfWebView_activityDetail];
            vc = webVC;
        }
            break;
        case 3:{
            KungfuClassDetailViewController * detailVc = [KungfuClassDetailViewController new];
            detailVc.classId = valud;
            vc = detailVc;
        }
            break;
        case 4:
            break;
        case 5:{
            NSString * url = URL_H5_MechanismDetail(valud,self.accessToken);
            KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:url type:KfWebView_mechanismDetail];
            vc = webVC;
        }
            break;
        case 6:
            break;
        default:
            break;
    }
    [self pushController:vc];
}


//获取广告相关信息
- (BannerSubModel *)getBannerSubModelWithContent:(NSString *)content
{
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
    options:NSJSONReadingMutableContainers error:&err];
    
    BannerSubModel * subM = [BannerSubModel mj_objectWithKeyValues:dic];
    return subM;
}

- (void) postPageChangeNotification:(NSString *)notiName index:(NSString * )indexStr
{
    [self postPageChangeNotification:notiName index:indexStr params:nil];
}

- (void) postPageChangeNotification:(NSString *)notiName index:(NSString * )indexStr params:(NSDictionary * _Nullable)params{
    NSMutableDictionary * dic = [@{@"index":indexStr} mutableCopy];
    if (params && params.count){
        [dic addEntriesFromDictionary:params];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:dic];
}

// 跳转
- (void) pushController:(UIViewController *)controller {
    
    controller.hidesBottomBarWhenPushed = YES;
    
    UITabBarController *tabBarVc = ( UITabBarController *)WINDOWSVIEW.rootViewController;
    UINavigationController *Nav = [tabBarVc selectedViewController];
    [Nav pushViewController:controller animated:YES];
}


- (NSString *)deviceString {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}

- (void)pushRiteViewControllerWithRiteType:(NSString *)riteType riteId:(NSString *)riteId {
    //1:水陆法会 2 普通法会 3 全年佛事 4 建寺安僧
    if ([riteType isEqualToString:@"3"] || [riteType isEqualToString:@"4"]) {
        [self pushRiteLongViewController:riteType];
    } else {
        KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_RiteDetail(riteId, [SLAppInfoModel sharedInstance].accessToken) type:KfWebView_rite];
        webVC.fillToView = YES;
        [self pushController:webVC];
    }
}

- (void)pushRiteLongViewController:(NSString *)pujaType{
    RiteSecondLevelListViewController *vc = [RiteSecondLevelListViewController new];
    vc.pujaType = pujaType;
    vc.pujaCode = @"";
    vc.hidesBottomBarWhenPushed = YES;
    [self pushController:vc];
}

- (void)clearAppCache:(void (^_Nullable)(void))completion {
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    [ADManager clearDiskCache];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SDImageCache sharedImageCache] clearWithCacheType:SDImageCacheTypeAll completion:^{
            [hud hideAnimated:YES];
            [ShaolinProgressHUD singleTextAutoHideHud:@"清除成功！"];
            
            if (completion) completion();
        }];
    });
    
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
}

- (float)getAppCacheSize {
    float sdImageCacheSize = [[SDImageCache sharedImageCache] totalDiskSize]/(1024.0*1024.0);
    float adCacheSize = [ADManager getDiskCacheSize];
    
    return sdImageCacheSize + adCacheSize;
}

@end
