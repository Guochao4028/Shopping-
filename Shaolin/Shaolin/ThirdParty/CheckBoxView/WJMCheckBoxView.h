//
//  WJMCheckBoxView.h
//  Lottery
//
//  Created by wangjingming on 2020/3/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Identifier.h"
#import "WJMTagLabel.h"

NS_ASSUME_NONNULL_BEGIN
@class WJMCheckBoxView;

@interface WJMCheckboxBtn : UIControl
//label与imageView的间隔 default:0
@property (nonatomic) CGFloat gap;
@property (nonatomic, strong) WJMTagLabel *titleLabel;
+ (instancetype)radioBtnStyleWithTitle:(NSString *)title identifier:(NSString *)identifier;
+ (instancetype)tickBtnStyleWithTitle:(NSString *)title identifier:(NSString *)identifier;

- (instancetype)initRadioBtnStyleWithTitle:(NSString *)title identifier:(NSString *)identifier;
- (instancetype)initTickBtnStyleWithTitle:(NSString *)title identifier:(NSString *)identifier;
@end


@protocol WJMCheckBoxViewDelegate <NSObject>
@optional
- (void)checkboxView:(WJMCheckBoxView *)checkboxView didSelectItemAtIdentifier:(NSString *)identifier;
- (void)checkboxView:(WJMCheckBoxView *)checkboxView didDeselectItemAtIdentifier:(NSString *)identifier;
@end

@interface WJMCheckBoxView : UIView
/*!default [btns count];*/
@property (nonatomic) NSUInteger maximumValue;
@property (nonatomic, weak) id<WJMCheckBoxViewDelegate>delegate;
/*! 如果实现block，则不会进入代理方法, identifier为button的identifier, WJMCheckBoxView的identifier需要自己获取*/
@property (nonatomic, copy) void(^didSelectItemAtIdentifier)(NSString *identifier);
@property (nonatomic, copy) void(^didDeselectItemAtIdentifier)(NSString *identifier);
- (instancetype)initCheckboxBtnBtns:(NSArray <WJMCheckboxBtn *>*)btns;

- (void)selectCheckBoxBtn:(NSString *)identifier;
- (void)selectCheckBoxSingleBtn:(NSString *)identifier;
- (NSArray <NSString *> *)getSelectCheckBoxBtnIdentifier;
@end

NS_ASSUME_NONNULL_END
