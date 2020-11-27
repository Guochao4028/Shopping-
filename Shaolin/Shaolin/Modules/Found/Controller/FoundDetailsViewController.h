//
//  FoundDetailsViewController.h
//  Shaolin
//
//  Created by edz on 2020/3/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  文章详情

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FoundDetailsViewController : RootViewController
@property(nonatomic,strong) NSString *idStr;
@property(nonatomic,strong) NSString *stateStr;
@property(nonatomic,copy) NSString *tabbarStr;
@property (nonatomic,copy) NSString *typeStr;
@property(nonatomic, strong) UIImage *showImage;
@property (nonatomic) BOOL isInteractive;// 是否能交互，点赞分享等，默认YES
@end

NS_ASSUME_NONNULL_END
