//
//  UIView+Identifier.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Identifier)
@property (nonatomic, copy) NSString *identifier;

- (UIView *)viewWithIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
