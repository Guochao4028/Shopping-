//
//  GCPickTimeView.h
//  Shaolin
//
//  Created by 郭超 on 2020/7/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCPickTimeView : UIView
@property (nonatomic, copy) void(^didFinishGCPickTimeView)(NSString *timeStr);

- (void)setCurrentTimeString:(NSString *)currentTimeString;
- (NSString *)getTimeString;
@end

NS_ASSUME_NONNULL_END
