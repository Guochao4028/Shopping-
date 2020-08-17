//
//  UIButton+Block.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ActionBlock)(UIButton *button);
@interface UIButton (Block)
@property (nonatomic, copy, readonly) ActionBlock actionBlock;
- (void)handleControlEvent:(UIControlEvents)controlEvent block:(ActionBlock)block;
@end

NS_ASSUME_NONNULL_END
