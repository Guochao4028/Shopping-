//
//  SLForgetAndRegistView.h
//  Shaolin
//
//  Created by edz on 2020/3/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLForgetAndRegistView : UIView
- (void)showView;
@property (nonatomic, copy) NSString *text;
//设置文本字数
@property (nonatomic, assign) NSInteger wordNumber;
//文本输入时的字数实时判断，如果checkResult为NO，显示错误信息
@property (nonatomic, copy) void (^CheckTextNumberBlock)(BOOL checkResult);
@property (nonatomic, copy) void (^closeViewBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title;
//失去焦点的方法
- (void)resignTextFirstResponder;


@end

NS_ASSUME_NONNULL_END
