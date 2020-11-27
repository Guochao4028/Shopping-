//
//  ShoppingCartListModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ShoppingCartListModel.h"
#import "GoodsStoreInfoModel.h"
#import "ShoppingCartGoodsModel.h"

@implementation ShoppingCartListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"club" : @"GoodsStoreInfoModel",
             @"goods":@"ShoppingCartGoodsModel"
             
    };
}


@end
