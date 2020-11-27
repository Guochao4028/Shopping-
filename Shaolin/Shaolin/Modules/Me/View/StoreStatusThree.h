//
//  StoreStatusThree.h
//  Shaolin
//
//  Created by edz on 2020/4/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreStatusThree : UIView
@property(nonatomic,strong) UILabel *statusLabel;
@property(nonatomic,copy) void (^determineTextAction)();
@end

NS_ASSUME_NONNULL_END
