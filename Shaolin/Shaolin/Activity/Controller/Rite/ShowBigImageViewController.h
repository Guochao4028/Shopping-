//
//  ShowBigImageViewController.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  专门用来显示网络大图VC

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShowBigImageViewController : RootViewController
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *placeholderImage;//默认：空

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *cancelButton;

// 底部saveButton 点击事件默认为将图片保存到本地，设置了bottomButtonClickBlock，则调用bottomButtonClickBlock
@property (nonatomic, copy) void (^saveButtonClickBlock)(void);
// 底部calcelButton 点击事件为空，设置了cancelButtonClickBlock，则调用cancelButtonClickBlock
@property (nonatomic, copy) void (^cancelButtonClickBlock)(void);
/**
 隐藏底部按钮
 默认是no 不隐藏
 yes 隐藏
 */
@property(nonatomic, assign)BOOL isHiddenBottom;
@end

NS_ASSUME_NONNULL_END
