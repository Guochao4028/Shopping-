//
//  WengenEnterModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "WengenEnterModel.h"

@implementation WengenEnterModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"enterId" : @"id",
             @"imageUrl": @"img_url"
             };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"son" : @"WengenEnterModel"};
}



@end
