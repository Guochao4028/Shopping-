//
//  RootNavigationController.h
//  MiAiApp
//
//  Created by ws on 2017/5/18.
//  Copyright © 2017年 ws. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 导航控制器基类
 */
@interface RootNavigationController : UINavigationController

@property(nonatomic,assign) BOOL isSystemSlidBack;//是否开启系统右滑返回

/*!
 *  返回到指定的类视图
 *
 *  @param ClassName 类名
 *  @param animated  是否动画
 */
-(BOOL)popToAppointViewController:(NSString *)ClassName animated:(BOOL)animated;


@end
