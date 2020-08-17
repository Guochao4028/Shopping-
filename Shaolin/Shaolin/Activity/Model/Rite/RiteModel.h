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

@property (nonatomic, copy) NSString * startDate;
@property (nonatomic, copy) NSString * endDate;
@property (nonatomic, copy) NSString * lunarTime;
@property (nonatomic, copy) NSString * pujaName;
@property (nonatomic, copy) NSString * pujaCode;
@property (nonatomic, copy) NSString * pujaIntroduction;
@property (nonatomic, copy) NSString * thumbnailUrl;

/// 1:水路法会 2 普通法会 3 全年佛事 4 建寺安僧
@property (nonatomic, copy) NSString * pujaType;

@property (nonatomic, assign) BOOL isThroughoutYear;



@end

NS_ASSUME_NONNULL_END
