//
//  WJMTagViewConfig.m
//  Shaolin
//
//  Created by 王精明 on 2020/11/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "WJMTagViewConfig.h"

@implementation WJMTagViewConfig

- (instancetype)init{
    self = [super init];
    if (self){
        self.aotuLayout = YES;
        self.viewHeight = 24;
        self.groupCount = 3;
        self.space = 10;
        self.groupInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        self.groupSpace = 10;
    }
    return self;
}

+ (instancetype)defaultConfig{
    WJMTagViewConfig *config = [[self alloc] init];
    [config setDefaultData];
    return config;
}

- (void)setDefaultData{
    self.imageSize = 18;
    self.titleStyle = WJMTagViewLabelStyleAutoHeight;
    self.selectImage = [UIImage imageNamed:@"riteRadioSelected_Yellow"];
    self.normalImage = [UIImage imageNamed:@"riteRadioNormal"];
    
    self.normalFont = kRegular(15);
    self.selectFont = kRegular(15);

    self.normalTextColor = KTextGray_333;
    self.selectTextColor = kMainYellow;
    
}
@end
