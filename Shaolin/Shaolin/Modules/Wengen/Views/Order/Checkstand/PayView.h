//
//  PayView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PayViewBlock)(NSString *password);

typedef void(^PayViewGoneBlock)(BOOL isGone);

@interface PayView : UIView


@property(nonatomic, copy)NSString *priceStr;

@property(nonatomic, copy)NSString *subtitleStr;

@property(nonatomic, copy)PayViewBlock inputPassword;
@property(nonatomic, copy)PayViewGoneBlock goneBlock;

- (void)gone;

@end

NS_ASSUME_NONNULL_END
