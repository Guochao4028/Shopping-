//
//  WengenBannerModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
// banner model

#import "WengenBannerModel.h"

@implementation WengenBannerModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"bannerId" : @"id",
             @"imgUrl": @"route"
             };
}

@end
