//
//  OrderDetailsNewModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/12/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderDetailsNewModel.h"

@implementation OrderDetailsNewModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"goods" : @"OrderDetailsGoodsModel",
             @"clubs" : @"OrderClubsInfoModel",
    };
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"orderId" : @"id",
    };
}


@end

@implementation OrderAddressModel

@end

@implementation OrderClubsInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"orderClubsInfoModelId" : @"id",
             @"im" : @[@"im", @"imName"]
    };
}

@end

@implementation OrderDetailsGoodsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"orderDetailsGoodsModelId" : @"id",
             @"orderId" : @"id"
    };
}

@end
