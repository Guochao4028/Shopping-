//
//  ZFTableData.h
//  ZFPlayer
//
//  Created by 紫枫 on 2018/4/24.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@interface ZFTableData : NSObject
@property(nonatomic,copy) NSString *author;//作者名字
@property(nonatomic,strong) NSNumber *clicks;//点击量
@property(nonatomic,copy) NSString *coverurl;//视频url
@property(nonatomic,copy) NSString *headurl;//头像url
@property(nonatomic,strong) NSNumber *praises;//点赞数量
@property(nonatomic,strong) NSNumber *collections;//收藏数量
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *useraccount;
@property(nonatomic,copy) NSString *createtype;
@property(nonatomic,copy) NSString *fieldId;
@property(nonatomic,copy) NSString *forwards;//转发梳理
@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *abstracts;
@property(nonatomic,strong) NSNumber *praise;//是否点赞
@property(nonatomic,strong) NSNumber *collection;//是否收藏
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, assign) NSInteger agree_num;
@property (nonatomic, assign) NSInteger share_num;
@property (nonatomic, assign) NSInteger post_num;

@property (nonatomic, assign) CGFloat thumbnail_width;
@property (nonatomic, assign) CGFloat thumbnail_height;
@property (nonatomic, assign) CGFloat video_duration;
@property (nonatomic, assign) CGFloat video_width;
@property (nonatomic, assign) CGFloat video_height;
@property (nonatomic, copy) NSString *thumbnail_url;
@property (nonatomic, copy) NSString *video_url;

@end
