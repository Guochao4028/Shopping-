//
//  KungfuOrderDetailHeaderView.h
//  Shaolin
//
//  Created by ws on 2020/5/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderDetailsModel;
@interface KungfuOrderDetailHeaderView : UIView

@property(nonatomic, strong)OrderDetailsModel *detailsModel;

@property (nonatomic , copy) void (^ timeOutHandle)(void);
@property (nonatomic , copy) void (^ payHandle)(void);

+(instancetype)loadXib;

@end

NS_ASSUME_NONNULL_END
