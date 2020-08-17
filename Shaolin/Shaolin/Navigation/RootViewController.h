//
//  RootViewController.h
//  Shaolin
//
//  Created by edz on 2020/3/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UIViewController
@property(nonatomic,strong) UIButton *leftBtn;
@property(nonatomic,strong) UIButton *rightBtn;
@property(nonatomic,strong) UILabel *titleLabe;

- (void)leftAction;


- (UIWindow *)rootWindow;

@end


