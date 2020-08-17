//
//  WengenEnterModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 分类入口model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WengenEnterModel : NSObject

@property(nonatomic, copy)NSString *imageUrl;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *enterId;
@property(nonatomic, strong)NSArray *son;
/**
 1,2
 */
@property(nonatomic, copy)NSString *status;

@property(nonatomic, assign)BOOL isSelected;

@end

NS_ASSUME_NONNULL_END


/**
   "id": 434,
           "name": "禅具",
           "img_url": "/uploads/20180613/f943875fe5411e9de6f80061b4d5acfb.png"
 */
