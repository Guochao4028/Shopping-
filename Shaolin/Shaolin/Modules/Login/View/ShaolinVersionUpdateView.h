//
//  ShaolinVersionUpdateView.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class VersionUpdateModel;
@interface ShaolinVersionUpdateView : UIView
/*! 立即更新*/
@property (nonatomic, copy) void (^upgradeNowBlock)(void);
/*! 下次再说*/
@property (nonatomic, copy) void (^nextTimeBlock)(void);
/*! 关闭按钮*/
@property (nonatomic, copy) void (^closeBlock)(void);

@property (nonatomic, strong) VersionUpdateModel *model;

- (void)testUI;
@end

NS_ASSUME_NONNULL_END
