//
//  ClassGoodsModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/5/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassGoodsModel : NSObject

@property (nonatomic, copy) NSString *classGoodsId;
@property (nonatomic, copy) NSString *classGoodsName;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *update_time;
/**观看时长*/
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *image;
/**是否可以试看 0：不能试看  1：可以试看*/
@property (nonatomic, copy) NSString *try_watch;

@property (nonatomic, copy) NSString *video_id;

@end

NS_ASSUME_NONNULL_END
