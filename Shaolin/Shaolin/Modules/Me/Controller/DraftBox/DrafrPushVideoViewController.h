//
//  DrafrPushVideoViewController.h
//  Shaolin
//
//  Created by syqaxldy on 2020/4/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"
#import "MePostManagerModel.h"
#import "SLAssetModel.h"


@interface DrafrPushVideoViewController : RootViewController

@property (nonatomic, strong) MePostManagerModel *model;

// 如果slAssetModel不为空，说明是本地视频
@property (nonatomic, strong) SLAssetModel * slAssetModel;

@property (nonatomic, strong) NSURL * videoUrl;
@property (nonatomic, strong) UIImage * videoImage;


///是不是本地视频
//@property (nonatomic, assign) BOOL  isLocal;

//@property (nonatomic, strong) NSString * type;

//@property (nonatomic, strong) NSString * videoStr;

//@property (nonatomic,strong) NSString *imgUrl;
//@property(nonatomic,strong) NSString * assetUrlStr;

@end


