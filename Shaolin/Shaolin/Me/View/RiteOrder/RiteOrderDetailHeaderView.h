//
//  RiteOrderDetailHeaderView.h
//  Shaolin
//
//  Created by 郭超 on 2020/7/31.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderDetailsModel;

@interface RiteOrderDetailHeaderView : UIView

@property(nonatomic, strong)OrderDetailsModel *detailsModel;

@property (nonatomic , copy) void (^ timeOutHandle)(void);
@property (nonatomic , copy) void (^ payHandle)(void);



@end

NS_ASSUME_NONNULL_END
