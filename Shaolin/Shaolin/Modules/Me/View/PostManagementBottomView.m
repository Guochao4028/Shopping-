//
//  PostManagementBottomView.m
//  Shaolin
//
//  Created by edz on 2020/3/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PostManagementBottomView.h"

@implementation PostManagementBottomView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.allBtn];
        
        [self addSubview:self.deleteBtn];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(14));
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(SLChange(19));
        make.width.mas_equalTo(SLChange(60));
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(34);
    }];
}
- (UIButton *)allBtn{
    if (!_allBtn) {
        _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allBtn.frame = CGRectMake(SLChange(14), SLChange(10.5), SLChange(19), SLChange(19));
        _allBtn.titleLabel.font = kMediumFont(13);
        [_allBtn setImage:[UIImage imageNamed:@"me_postmanagement_normal"] forState:(UIControlStateNormal)];
        [_allBtn setImage:[UIImage imageNamed:@"me_postmanagement_select_yellow"] forState:(UIControlStateSelected)];
        [_allBtn setTitle:SLLocalizedString(@"  全选") forState:UIControlStateNormal];
        [_allBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    }
    return _allBtn;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.titleLabel.font = kMediumFont(15);
        [_deleteBtn setTitle:SLLocalizedString(@"删除") forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteBtn.backgroundColor = kMainYellow;
        _deleteBtn.layer.cornerRadius = 17;
        _deleteBtn.layer.masksToBounds = YES;
    }
    return _deleteBtn;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
