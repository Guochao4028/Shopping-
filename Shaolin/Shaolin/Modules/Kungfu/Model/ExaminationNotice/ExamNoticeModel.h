//
//  ExamNoticeModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/10/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExamNoticeModel : NSObject
///活动编号
@property(nonatomic, copy)NSString *activityCode;
///活动名称
@property(nonatomic, copy)NSString *activityName;
///内容
@property(nonatomic, copy)NSString *content;
///是否已读 0未读 1已读
@property(nonatomic, copy)NSString *ifRead;
///标题
@property(nonatomic, copy)NSString *title;
///id
@property(nonatomic, copy)NSString *examNoticeModelID;

@property(nonatomic, assign)BOOL isSelected;


@end

NS_ASSUME_NONNULL_END
