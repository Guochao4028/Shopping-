//
//  BusinessFooterView.h
//  Shaolin
//
//  Created by edz on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PhotoDataClick)(void);
@interface BusinessFooterView : UIView
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *alertLabel;
@property(nonatomic,strong) UIImageView *photoView;
@property(nonatomic,strong) UIButton *photoBtn;
@property(nonatomic, strong) UIImageView *photoCameraImage;
@property(nonatomic,strong) UIButton *nextBtn;
@property (nonatomic , copy) PhotoDataClick bankPhotoClick;
@property (nonatomic , copy) PhotoDataClick nextClick;
@end

NS_ASSUME_NONNULL_END
