//
//  LookVideoViewController.h
//  Shaolin
//
//  Created by edz on 2020/4/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MePostManagerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LookVideoViewController : UIViewController
@property(nonatomic,strong) MePostManagerModel *model;
@property (nonatomic,strong) NSString *videoStr;
@property(nonatomic,strong) NSURL *urlArr;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *imgUrl;
@end

NS_ASSUME_NONNULL_END
