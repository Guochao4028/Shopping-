//
//  GoodsVideoView.h
//  Shaolin
//
//  Created by 郭超 on 2020/11/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GoodsVideoViewDelegate;

@interface GoodsVideoView : UIView

///数据
@property(nonatomic, strong)NSArray *dataArray;
///视频URL
@property(nonatomic, copy)NSString *videoUrl;

@property (nonatomic, weak) id<GoodsVideoViewDelegate> delegate;

@end

@protocol GoodsVideoViewDelegate <NSObject>

- (void)carousel:(GoodsVideoView *)view didScrollToIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
