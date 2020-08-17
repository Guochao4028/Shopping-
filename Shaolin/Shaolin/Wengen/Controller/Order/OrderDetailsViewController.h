//
//  OrderDetailsViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailsViewController : UIViewController

@property(nonatomic, assign)OrderDetailsType orderDetailsType;

@property(nonatomic, copy)NSString *orderId;

@property(nonatomic, copy)NSString *orderPrice;

@end

NS_ASSUME_NONNULL_END
