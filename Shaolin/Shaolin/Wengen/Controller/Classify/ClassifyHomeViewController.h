//
//  ClassifyHomeViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"



NS_ASSUME_NONNULL_BEGIN

@interface ClassifyHomeViewController : RootViewController

//标题组
@property (nonatomic, strong) NSArray *titles;
//当前位置
@property(nonatomic, assign)NSInteger loction;
//分类数组
@property(nonatomic, assign)NSArray *allGoodsCateList;
@end

NS_ASSUME_NONNULL_END
