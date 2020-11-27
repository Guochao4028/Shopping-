//
//  StorePhoneView.h
//  Shaolin
//
//  Created by edz on 2020/4/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StorePhoneView : UIView
@property(nonatomic,copy) void (^determineTextAction)(NSString *phoneStr,NSString *codeStr);
@end

NS_ASSUME_NONNULL_END
