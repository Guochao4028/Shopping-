//
//  SLPlayerControlView.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLPlayerControlView.h"

@implementation SLPlayerControlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/// 单击手势事件
- (void)gestureSingleTapped:(ZFPlayerGestureControl *)gestureControl {
    [super gestureSingleTapped:gestureControl];
    if (!self.player) return;
    if (self.player.isFullScreen) {
        [self.landScapeControlView playOrPause];
    } else {
        [self.portraitControlView playOrPause];
    }
}

/// 双击手势事件
- (void)gestureDoubleTapped:(ZFPlayerGestureControl *)gestureControl {
    
}

@end
