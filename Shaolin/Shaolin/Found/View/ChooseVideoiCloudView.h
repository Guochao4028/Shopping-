//
//  ChooseVideoiCloudView.h
//  Shaolin
//
//  Created by ws on 2020/7/16.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseVideoiCloudView : UIView

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *downProgressView;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;


@property (nonatomic,copy) void (^downloadBlock)(void);

@end

NS_ASSUME_NONNULL_END
