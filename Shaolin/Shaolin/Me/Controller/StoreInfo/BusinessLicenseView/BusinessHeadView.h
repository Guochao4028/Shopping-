//
//  BusinessHeadView.h
//  Shaolin
//
//  Created by edz on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PhotoDataClick)(void);
@interface BusinessHeadView : UIView
@property(nonatomic,strong) UILabel *alertLabel;
@property(nonatomic,strong) UIImageView *photoView;
@property(nonatomic,strong) UIButton *photoBtn;
@property(nonatomic,strong) UIImageView *photoCameraImage;
@property(nonatomic,strong) UIView *vieW;
@property(nonatomic,strong) UILabel *viewLabel;
@property (nonatomic , copy) PhotoDataClick businessPhotoClick;
@end


