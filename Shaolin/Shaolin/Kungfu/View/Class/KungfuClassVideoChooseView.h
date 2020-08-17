//
//  KungfuClassVideoChooseView.h
//  Shaolin
//
//  Created by ws on 2020/7/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    VideoPlayEndTry = 0, // 试看
    VideoPlayEndCenter, // 显示 重新观看和观看下一节  这两个按钮
    VideoPlayEndLast,   // 只显示重新观看的按钮
} VideoPlayEndType;

@interface KungfuClassVideoChooseView : UIView

+ (KungfuClassVideoChooseView *) loadXib;

@property (nonatomic, copy) void(^ buyHandleBlock)(void);
@property (nonatomic, copy) void(^ replyHandleBlock)(void);
@property (nonatomic, copy) void(^ backHandleBlock)(void);
@property (nonatomic, copy) void(^ nextHandleBlock)(void);

@property (assign, nonatomic) VideoPlayEndType endViewType;


@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@end

NS_ASSUME_NONNULL_END
