//
//  AppDelegate.h
//  Shaolin
//
//  Created by edz on 2020/2/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIApplication <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow * window;
@property (nonatomic, assign) BOOL allowOrentitaionRotation;

@property (nonatomic, assign) UITouchPhase touchPhase;

@end

