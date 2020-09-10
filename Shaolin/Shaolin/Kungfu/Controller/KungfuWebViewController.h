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
    KfWebView_rite,                 // 法会
    KfWebView_oldRite,              // 本期法会回顾
} KfWebViewType;


@interface KungfuWebViewController : RootViewController
/*!是否铺满父视图(主要针对刘海屏底部的安全区)，默认NO*/
@property (nonatomic) BOOL fillToView;
@property (nonatomic, strong) NSString * titleStr;

/*!返回是否由调用类处理改ScriptMessage，需要注意flag类型，不要所有的js都拦截*/
@property (nonatomic, copy) BOOL (^receiveScriptMessageBlock)(NSDictionary *messageDict);
-(instancetype)initWithUrl:(NSString*)url type:(KfWebViewType)type;
- (void)hideWebViewScrollIndicator;
@end

NS_ASSUME_NONNULL_END
