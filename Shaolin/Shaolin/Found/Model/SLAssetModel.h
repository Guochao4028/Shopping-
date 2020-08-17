//
//  SLAssetModel.h
//  Shaolin
//
//  Created by ws on 2020/7/16.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLAssetModel.h"
#import <TZAssetModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLAssetModel : NSObject

@property (nonatomic, assign) BOOL isICloudAsset;
@property (nonatomic, strong) AVAsset * videoAsset;
@property (nonatomic, strong) UIImage * videoImage;

@property (nonatomic, strong) TZAssetModel * tzAssetModel;


@end

NS_ASSUME_NONNULL_END
