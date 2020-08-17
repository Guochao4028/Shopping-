//
//  ChangePhoneViewController.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ChangePhoneViewType) {
    ChangePhoneViewType_oldPhone,
    ChangePhoneViewType_newPhone,
};

@interface ChangePhoneViewController : RootViewController
@property (nonatomic) ChangePhoneViewType type;
@property (nonatomic, copy) void(^changePhoneSuccess)(void);
@end

NS_ASSUME_NONNULL_END
