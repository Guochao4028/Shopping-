//
//  RiteFormModel.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteFormModel.h"

@implementation RiteFormModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data" : @"RiteFormSecondModel"};
}
@end


@implementation RiteFormSecondModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data" : @"RiteFormThirdModel"};
}
@end

@implementation RiteFormThirdModel

@end
