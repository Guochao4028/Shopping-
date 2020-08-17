//
//  SLShareView.h
//  Shaolin
//
//  Created by edz on 2020/4/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedModel.h"

@interface SLShareView : UIView
@property (nonatomic, strong) SharedModel *model;
@property (nonatomic, copy) void(^shareFinish)(void);
@end


