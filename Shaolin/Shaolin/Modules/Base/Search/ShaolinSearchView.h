//
//  ShaolinSearchView.h
//  Shaolin
//
//  Created by 王精明 on 2020/11/5.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PlaceholderAlignment) {
    PlaceholderAlignmentLeft      = 0,    // Visually left aligned
    PlaceholderAlignmentCenter    = 1,    // Visually centered
    PlaceholderAlignmentRight     = 2,    // Visually right aligned
};

@protocol ShaolinSearchViewDelegate <NSObject>

- (void)shaolinSearchViewDidSelectHandle;

@end

@interface ShaolinSearchView : UIView
@property (nonatomic, strong) id <ShaolinSearchViewDelegate> delegate;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UITextField *tf;
@property (nonatomic) PlaceholderAlignment placeholderAlignment;// Default PlaceholderAlignmentCenter

/// 占位符          default SLLocalizedString(搜索)
@property (nonatomic, strong) NSString *placeholder;
/// 占位符字体   default kRegular(14);
@property (nonatomic, strong) UIFont *placeholderFont;
/// 占位符颜色   default [UIColor colorForHex:@"D1D3DB"];
@property (nonatomic, strong) UIColor *placeholderColor;
@end

NS_ASSUME_NONNULL_END
