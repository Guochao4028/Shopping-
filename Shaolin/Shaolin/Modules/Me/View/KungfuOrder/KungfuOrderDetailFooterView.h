//
//  KungfuOrderDetailFooterView.h
//  Shaolin
//
//  Created by ws on 2020/6/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class OrderDetailsNewModel;
@interface KungfuOrderDetailFooterView : UIView

@property(nonatomic, strong) OrderDetailsNewModel *detailsModel;

+(instancetype)loadXib;

@property (nonatomic , copy) void (^ deleteOrderHandle)(void);
@property (nonatomic , copy) void (^ cancelOrderHandle)(void);
@property (nonatomic , copy) void (^ buyAgainHandle)(void);
@property (nonatomic , copy) void (^ payOrderHandle)(void);
@property (nonatomic , copy) void (^ checkInvoiceHandle)(void);
@property (nonatomic , copy) void (^ playVideoHandle)(void);
@property (nonatomic , copy) void (^ repairInvoice)(void);
@end

NS_ASSUME_NONNULL_END
