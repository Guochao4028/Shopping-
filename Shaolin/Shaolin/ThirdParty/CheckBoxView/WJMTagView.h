//
//  WJMTagView.h
//  Shaolin
//
//  Created by 王精明 on 2020/11/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WJMTagViewConfig;

@interface WJMTagView : UIView
@property (nonatomic, strong) WJMTagViewConfig *config;

@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL disenable;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END
