//
//  KungfuWebViewController.h
//  Shaolin
//
//  Created by ws on 2020/5/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    KfWebView_activityDetail = 1,   // 活动详情
    KfWebView_mechanismDetail,      // 机构详情
    KfWebView_applyDetail,          // 报名详情
    KfWebView_examNoti,           // 考试通知
    KfWebView_rite,           // 法会
} KfWebViewType;


@interface KungfuWebViewController : RootViewController


@property (nonatomic, strong) NSString * titleStr;

-(instancetype)initWithUrl:(NSString*)url type:(KfWebViewType)type;
- (void)hideWebViewScrollIndicator;
@end

NS_ASSUME_NONNULL_END
