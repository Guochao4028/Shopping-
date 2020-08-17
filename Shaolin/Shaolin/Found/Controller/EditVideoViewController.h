//
//  EditVideoViewController.h
//  Shaolin
//
//  Created by edz on 2020/3/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAssetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EditVideoViewController : RootViewController

@property (nonatomic, strong) SLAssetModel * slAssetModel;
@property (nonatomic, strong) AVURLAsset * urlAsset;

//@property(nonatomic,strong) NSURL * urlArr;
//@property(nonatomic,strong) UIImage *imageViewStr;
//@property(nonatomic,strong) NSString * assetUrlStr;
@end

NS_ASSUME_NONNULL_END
