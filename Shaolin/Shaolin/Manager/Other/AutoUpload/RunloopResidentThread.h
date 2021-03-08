//
//  RunloopResidentThread.h
//  Shaolin
//
//  Created by 王精明 on 2021/1/18.
//  Copyright © 2021 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ThumbFollowShareModel;
@interface RunloopResidentThread : NSObject
+ (instancetype)sharedInstance;

- (void)postThumbFollowShareData;
@end

NS_ASSUME_NONNULL_END
