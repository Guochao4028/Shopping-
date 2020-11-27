//
//  KungfuClassInfoView.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/16.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KungfuClassInfoView : UIView

@property(nonatomic, copy)NSString *classContentStr;

@property(nonatomic, copy)NSString *classNameStr;

@property (nonatomic, copy) void(^ shutDownBlock)(void);

@end

NS_ASSUME_NONNULL_END
