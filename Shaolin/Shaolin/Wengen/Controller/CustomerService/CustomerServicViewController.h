//
//  CustomerServicViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class GoodsStoreInfoModel;
@interface CustomerServicViewController : RootViewController{
    NSString *_servicType;
}
//@property(nonatomic, strong)GoodsStoreInfoModel *storeModel;

@property(nonatomic, copy)NSString *imID;
/**
 自助问题列表类型
 1，商品
 2，法会
 不传默认是 1
 */
@property(nonatomic, copy)NSString *servicType;

@end

NS_ASSUME_NONNULL_END
