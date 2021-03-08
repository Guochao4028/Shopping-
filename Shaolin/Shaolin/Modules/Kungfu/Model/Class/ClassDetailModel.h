//
//  ClassDetailModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/5/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ClassGoodsModel;

@interface ClassDetailHistoryModel : NSObject



@property (nonatomic, copy) NSString *historyId;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *attrId;
@property (nonatomic, copy) NSString *lookTime;

@end

@interface ClassDetailModel : NSObject
@property (nonatomic, copy) NSString *subjectId;
///1 免费 2 会员 3 付费
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *classDetailId;
@property (nonatomic, copy) NSString *classDetailName;
@property (nonatomic, copy) NSString *levelName;
@property (nonatomic, copy) NSString *oldPrice;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *lookLevelName;
@property (nonatomic, copy) NSString *lookLevel;

@property (nonatomic, copy) NSString *desc2;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *buy;//是否购买
/**是否收藏*/
@property (nonatomic, copy) NSString *collect;
@property (nonatomic, strong) NSArray < ClassGoodsModel *> *goodsNext;
@property (nonatomic, copy) NSArray *imgData;
@property (nonatomic, copy) NSString *cover;


@property (nonatomic, copy) NSString *appStoreId;

///简介
@property(nonatomic, copy)NSString *intro;

@property (nonatomic, strong) ClassDetailHistoryModel *history;

- (BOOL) isFreeClass;
- (BOOL) isVIPClass;
- (BOOL) isPayClass;
@end


/*
 "pay_type": 1,1 免费 2 会员 3 付费 <number>
 "id": 53,... <number>
 "level_name": "一段",... <string>
 "name": "罗汉拳",教程名称 <string>
 "old_price": "0.00",价格 <string>
 "video_url": "",视频 <string>
 "weight": "10",时长 <string>
 "level": 1,级别 <number>
 "desc2": "不知道",建议 <string>
 "desc": "没有建议",简介 <string>
 -"goods_next": [...<array>
 -{
 "id": 457,... <number>
 "name": "罗汉拳第一节",教程名称 <string>
 "video": "https://static.oss.cdn.oss.gaoshier.cn/other/88614123-23af-4135-9c57-51e6b2d66835.mp4",... <string>
 "update_time": "2020-05-20",更新时间 <string>
 "value": "",观看时间 <string>
 "image": "https://static.oss.cdn.oss.gaoshier.cn/other/88614123-23af-4135-9c57-51e6b2d66835.mp4?x-oss-process=video/snapshot,t_10000,m_fast"... <string>
 }
 ],
 -"img_data": [轮播图第一张为视频封面<array>
 "https://static.oss.cdn.oss.gaoshier.cn/image/bfc3bc7a-0037-43ca-85f8-4d8cac760226.png"
 ],
 "collect": 1... <number>
 
 */
NS_ASSUME_NONNULL_END
