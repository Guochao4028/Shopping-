//
//  CustomerServiceInputView.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^InputViewWordBlock)(NSString *word);

@interface CustomerServiceInputView : UIView

@property(nonatomic, copy)InputViewWordBlock inputWordBlock;

@end

NS_ASSUME_NONNULL_END
