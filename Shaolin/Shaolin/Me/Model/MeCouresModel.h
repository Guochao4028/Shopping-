//
//  MeCouresModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/6/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeCouresModel : NSObject
@property (nonatomic, copy) NSString *star;
@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *old_price;
/**简介*/
@property (nonatomic, copy) NSString *intro;
/**图片*/
@property (nonatomic, copy) NSString *cover;
/**教程名称*/
@property (nonatomic, copy) NSString *name;
/**教程ID*/
@property (nonatomic, copy) NSString *couresId;
@end

NS_ASSUME_NONNULL_END
