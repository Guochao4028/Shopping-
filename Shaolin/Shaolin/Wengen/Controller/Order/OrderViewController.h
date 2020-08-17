//
//  OrderViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderViewController : UIViewController

@property(nonatomic, copy)NSString *status;

@property(nonatomic, copy)NSString *is_refund;

@property(nonatomic, assign)BOOL isOrder;

@end

NS_ASSUME_NONNULL_END
