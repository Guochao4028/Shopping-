//
//  OrderStoreModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderStoreModel : NSObject




@property(nonatomic, copy)NSString *storeId;
@property(nonatomic, copy)NSString *order_id;
@property(nonatomic, copy)NSString *name;
///是否自营
@property(nonatomic, copy)NSString *is_self;

@property(nonatomic, copy)NSArray *goods;

//评分存储 评星分数
@property(nonatomic, copy)NSString *currentScore;

//是否是统一快递号
@property(nonatomic, assign)BOOL isUnifiedNumber;

//是否底部显示
@property(nonatomic, assign)BOOL isBottomDisplay;


@end

NS_ASSUME_NONNULL_END
