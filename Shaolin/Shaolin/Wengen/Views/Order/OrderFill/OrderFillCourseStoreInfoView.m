//
//  OrderFillCourseStoreInfoView.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillCourseStoreInfoView.h"

@interface OrderFillCourseStoreInfoView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;


@end


@implementation OrderFillCourseStoreInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderFillCourseStoreInfoView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
}

/// 重写系统方法
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

@end
