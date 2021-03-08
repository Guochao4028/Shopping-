//
//  MePostManagerModel.m
//  Shaolin
//
//  Created by edz on 2020/4/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MePostManagerModel.h"
#import "PostPureTextCell.h"
#import "PostManagementCell.h"
@implementation MePostManagerModel
- (NSString *)cellIdentifier
{
    if ([self.kind isEqualToString:@"1"]) {
        return NSStringFromClass([PostPureTextCell class]);
    }else
    {
        return NSStringFromClass([PostManagementCell class]);
    }
}
@end
