//
//  GoodsInfo.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsInfoModel.h"

#import "GoodsSpecificationModel.h"

@implementation GoodsInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"goodsid" : @"id",
             @"img_data" : @[@"img_data", @"imgDataList"],
             @"attrStr" : @"attrDetail.attrStr",
             @"attr" : @"attrDetail.attr.attrList",
             @"templateId" : @"template"
             };
}


@end
