//
//  OrderFillContentStoreInfoView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillContentStoreInfoView.h"
#import "GoodsStoreInfoModel.h"

@interface OrderFillContentStoreInfoView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *proprietaryImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proprietaryImageViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proprietaryGayW;

@end

@implementation OrderFillContentStoreInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderFillContentStoreInfoView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

// 初始化UI
- (void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
}

/// 重写系统方法
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}


#pragma mark - setter / getter

- (void)setInfoModel:(GoodsStoreInfoModel *)infoModel{
    _infoModel = infoModel;
    if (infoModel.name != nil && infoModel.name.length > 0) {
        [self.storeNameLabel setText:infoModel.name];
    }else{
       [self.storeNameLabel setText:SLLocalizedString(@"段品制教程")];
    }
    
    
    BOOL is_self = [infoModel.is_self boolValue];
    if (is_self) {
        [self.proprietaryImageView setHidden:NO];
        self.proprietaryImageViewW.constant = 35;
        self.proprietaryGayW.constant = 5;
    }else{
        [self.proprietaryImageView setHidden:YES];
        self.proprietaryImageViewW.constant = 0;
        self.proprietaryGayW.constant = 0;
    }
    
}

@end
