//
//  GoodsDetailsView.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsInfoModel, GoodsStoreInfoModel, AddressListModel;

@interface GoodsDetailsView : UIView

@property(nonatomic, strong)GoodsInfoModel *infoModel;

@property(nonatomic, strong)GoodsStoreInfoModel *storeInfoModel;

@property(nonatomic, copy)NSString *feeStr;

@property(nonatomic, copy)NSString *specificaationStr;

@property(nonatomic, strong)AddressListModel *addressModel;

@property(nonatomic, copy)void(^goodsSpecificationBlock)(BOOL istap);

@property(nonatomic, copy)void(^goodsAddressBlock)(BOOL istap);

@property(nonatomic, copy)void(^goodsStoreInfoCellBlock)(BOOL istap);


@property(nonatomic, copy)void(^goodsStoreInfoCellOnlineCustomerServiceBlock)(BOOL istap);




@end

NS_ASSUME_NONNULL_END
