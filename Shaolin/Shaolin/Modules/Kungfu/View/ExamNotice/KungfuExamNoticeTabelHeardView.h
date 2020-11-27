//
//  KungfuExamNoticeTabelHeardView.h
//  Shaolin
//
//  Created by 郭超 on 2020/9/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class  ExamNoticeModel;

@interface KungfuExamNoticeTabelHeardView : UIView

@property(nonatomic, copy)NSString *titleStr;

@property(nonatomic, strong)ExamNoticeModel *model;

@property(nonatomic)NSInteger section;

@property(nonatomic, copy)void(^examNoticeTabletActionBclok)(NSInteger section);

@end

NS_ASSUME_NONNULL_END
