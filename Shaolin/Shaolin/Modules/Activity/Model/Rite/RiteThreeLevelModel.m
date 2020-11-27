//
//  RiteThreeLevelModel.m
//  Shaolin
//
//  Created by 王精明 on 2020/8/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteThreeLevelModel.h"

@implementation RiteThreeLevelModel

+ (instancetype)testModel{
    RiteThreeLevelModel *model = [[RiteThreeLevelModel alloc] init];
    model.buddhismTypeImg = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1597405750629&di=38af7f7d2036bdfb83353e3a2c3c286a&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F6%2F537ea15ed93fa.jpg";
    model.buddhismTypeName = @"延生（单堂）";
    model.buddhismTypeIntroduction = @"延生堂是摆放消灾条的，主要是为了达到祈求长生和消灾的福";
    return model;
}
@end
