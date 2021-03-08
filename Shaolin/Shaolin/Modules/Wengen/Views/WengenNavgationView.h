//
//  WengenNavgationView.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WengenNavgationViewDelegate <NSObject>

@optional

- (void)tapBack;

@end

@interface WengenNavgationView : UIView

@property(nonatomic, copy)NSString *titleStr;

@property(nonatomic, weak)id<WengenNavgationViewDelegate> delegate;

@property(nonatomic, copy)NSString *rightStr;

@property(nonatomic, assign)BOOL isEditor;

- (void)rightTarget:(nullable id)target action:(SEL)action;

//记录右按钮点击状态
@property(nonatomic, assign)BOOL isRight;


@end

NS_ASSUME_NONNULL_END
