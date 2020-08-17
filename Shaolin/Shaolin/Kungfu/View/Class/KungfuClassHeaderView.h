//
//  KungfuClassHeaderView.h
//  Shaolin
//
//  Created by ws on 2020/5/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFTableData.h"

NS_ASSUME_NONNULL_BEGIN
@class ClassDetailModel;
@interface KungfuClassHeaderView : UIView

@property (nonatomic, strong) ZFTableData *data;
@property (nonatomic, copy) void(^playCallback)(void);

@property (weak, nonatomic) IBOutlet UIImageView *classImgv;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (nonatomic, strong) ClassDetailModel *model;


- (void)showSdcScrollView;
- (void)hideSdcScrollView;
@end

NS_ASSUME_NONNULL_END
