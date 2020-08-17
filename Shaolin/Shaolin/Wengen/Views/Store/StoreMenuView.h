//
//  StoreMenuView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreMenuView : UIView

@property (weak, nonatomic) IBOutlet UILabel *jiageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *jiageImageView;
@property (weak, nonatomic) IBOutlet UIButton *zhijianButton;
@property (weak, nonatomic) IBOutlet UIButton *qiehuanButton;
@property (weak, nonatomic) IBOutlet UIButton *tuijianButton;
@property (weak, nonatomic) IBOutlet UIButton *xiaoliangButton;


-(void)tuijianTarget:(nullable id)target action:(SEL)action;
-(void)xiaoliangTarget:(nullable id)target action:(SEL)action;
-(void)jiageTarget:(nullable id)target action:(SEL)action;
-(void)zhijianTarget:(nullable id)target action:(SEL)action;
-(void)qiehuanTarget:(nullable id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
