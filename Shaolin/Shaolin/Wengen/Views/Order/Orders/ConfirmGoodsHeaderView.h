//
//  ConfirmGoodsHeaderView.h
//  Shaolin
//
//  Created by EDZ on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmGoodsHeaderView : UIView


@property (strong, nonatomic) IBOutlet UILabel *labelTitle;


//210
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConst;

//10
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConst;



@property (strong, nonatomic) IBOutlet UIView *starsViewBg;

@property (strong, nonatomic) IBOutlet UIImageView *image;

@property (strong, nonatomic) IBOutlet UILabel *labelSuccessful;

@property (strong, nonatomic) IBOutlet UIButton *btnStore;


@end

NS_ASSUME_NONNULL_END
