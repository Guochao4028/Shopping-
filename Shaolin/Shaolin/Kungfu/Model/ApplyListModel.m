//
//  ApplyListModel.m
//  Shaolin
//
//  Created by ws on 2020/5/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ApplyListModel.h"

@implementation ApplyListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"applyId" : @"id",
             @"realName" : @[@"realName", @"realname"],
             @"photosUrl" : @[@"photosUrl", @"photosurl"],
             @"examAddress" : @[@"examAddress", @"examaddress"],
             };
}

@end
