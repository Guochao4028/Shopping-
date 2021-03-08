//
//  RiteModel.h
//  Shaolin
//
//  Created by ws on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiteModel : NSObject

@property (nonatomic, copy) NSString * startTime;
@property (nonatomic, copy) NSString * endTime;
@property (nonatomic, copy) NSString * lunarTime;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * introduction;
@property (nonatomic, copy) NSString * thumbnailUrl;

/// 1:水陆法会 2 普通法会 3 全年佛事 4 建寺安僧
@property (nonatomic, copy) NSString * type;

@property (nonatomic, assign) BOOL isThroughoutYear;



@end

NS_ASSUME_NONNULL_END
