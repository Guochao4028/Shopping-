//
//  SelectedGoodsModel.h
//  Shaolin
//
//  Created by 郭超 on 2021/1/27.
//  Copyright © 2021 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaveBuyCarModel : NSObject

///商品id
@property(nonatomic, copy)NSString *goodsId;
///商品规格
@property(nonatomic, copy)NSString *goodsAttrId;

@property(nonatomic, copy, readonly)NSString *userID;



@end

NS_ASSUME_NONNULL_END
