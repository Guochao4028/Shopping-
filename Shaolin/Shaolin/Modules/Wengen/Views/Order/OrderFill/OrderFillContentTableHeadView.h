//
//  OrderFillContentTableHeadView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AddressListModel;

@interface OrderFillContentTableHeadView : UIView

@property(nonatomic, strong)AddressListModel *addressListModel;

- (void)orderFillContentTableHeadTarget:(nullable id)target action:(SEL)action;


@end

NS_ASSUME_NONNULL_END
