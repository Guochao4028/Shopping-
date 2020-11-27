//
//  PostPureTextCell.m
//  Shaolin
//
//  Created by edz on 2020/4/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PostPureTextCell.h"

@implementation PostPureTextCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView
{
      [self.contentView addSubview:self.titleLabe];
      [self.contentView addSubview:self.contentLabel];
      [self.contentView addSubview:self.statusLabel];
      [self.contentView addSubview:self.timeLabel];
      [self.contentView addSubview:self.refusedBtn];
      [self.titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(13);
//            make.height.mas_equalTo(14.5);
    //        make.width.mas_equalTo(SLChange(214));
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.titleLabe);
            make.top.mas_equalTo(self.titleLabe.mas_bottom).offset(5);
            make.height.mas_greaterThanOrEqualTo(15);
    //        make.width.mas_equalTo(kWidth-SLChange(31));
        }];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabe);
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(7);
            make.height.mas_equalTo(11);
            make.width.mas_equalTo(37);
            make.bottom.mas_equalTo(-14);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.statusLabel.mas_right).offset(11);
            make.centerY.mas_equalTo(self.statusLabel);
            make.height.mas_equalTo(11);
        }];
        [self.refusedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeLabel.mas_right).offset(11);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(64);
            make.centerY.mas_equalTo(self.statusLabel);
        }];
    
}
-(void)setMePostManagerModel:(MePostManagerModel *)f indexpath:(NSIndexPath *)indexPath
{
     f.cellHeight = 100;
     self.titleLabe.text = f.title;
   
    self.indexPath = indexPath;
    if ([f.state isEqualToString:@"2"] || [f.state isEqualToString:@"6"]) {
        self.refusedBtn.hidden = YES;
      
        if ([f.state isEqualToString:@"2"]) {
             self.statusLabel.text = SLLocalizedString(@"审核中");
        }else{
            self.statusLabel.text = SLLocalizedString(@"已发布");
        }
    }else if([f.state isEqualToString:@"4"])
    {
         self.refusedBtn.hidden = NO;
        
        self.statusLabel.text = SLLocalizedString(@"已拒绝");
        [self.refusedBtn setTitle:SLLocalizedString(@"查看拒绝原因") forState:(UIControlStateNormal)];

    }else if([f.state isEqualToString:@"5"])
    {
         self.refusedBtn.hidden = NO;
        
        self.statusLabel.text = SLLocalizedString(@"已下架");
        [self.refusedBtn setTitle:SLLocalizedString(@"查看下架原因") forState:(UIControlStateNormal)];
    }else
    {
        self.refusedBtn.hidden = YES;
       
        self.statusLabel.text = @"";
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                       make.left.mas_equalTo(SLChange(15));
                  }];
    }
    NSDate *date= [self nsstringConversionNSDate:f.returnTime];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[self compaareCurrentTime:date]];

    if(f.abstracts.length == 0 ) {
         self.contentLabel.text = @"";
    }else {
         self.contentLabel.text = [NSString stringWithFormat:@"%@",f.abstracts];
    }
   
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
  
    
    for (UIControl *control in self.subviews) {
        if (![control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            continue;
        }
          
        for (UIView *subView in control.subviews) {
            if (![subView isKindOfClass: [UIImageView class]]) {
                continue;
            }
              
            UIImageView *imageView = (UIImageView *)subView;
            if (self.selected) {
                imageView.image = [UIImage imageNamed:@"me_postmanagement_select_yellow"]; // 选中时的图片
            } else {
                imageView.image = [UIImage imageNamed:@"me_postmanagement_normal"];   // 未选中时的图片
            }
        }
    }
    
}

-(UILabel *)titleLabe
{
    if (!_titleLabe) {
        _titleLabe = [[UILabel alloc] init];
        _titleLabe.textColor = [UIColor colorForHex:@"000000"];
        _titleLabe.numberOfLines = 2;
        _titleLabe.font = kRegular(14);
        _titleLabe.textAlignment = NSTextAlignmentLeft;
        _titleLabe.text = @"asdasdaa";
    }
    return _titleLabe;
}
-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = KTextGray_999;
        _contentLabel.font = kRegular(11);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 2;
        _contentLabel.text = @"";
    }
    return _contentLabel;
}
-(UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = kMainYellow;
        _statusLabel.font = kRegular(11);
        _statusLabel.text = @"";
    }
    return _statusLabel;
}
-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = KTextGray_999;
        _timeLabel.font = kRegular(11);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.text = @"";
    }
    return _timeLabel;
}
-(UIButton *)refusedBtn
{
    if (!_refusedBtn) {
        _refusedBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_refusedBtn setBackgroundImage:[UIImage imageNamed:@"me_postmanagement_look"] forState:(UIControlStateNormal)];
        [_refusedBtn setTitle:SLLocalizedString(@"查看拒绝原因") forState:(UIControlStateNormal)];
        [_refusedBtn setTitleColor:kMainYellow forState:(UIControlStateNormal)];
        _refusedBtn.titleLabel.font = kRegular(9);
        [_refusedBtn addTarget:self action:@selector(refuseAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _refusedBtn;
}

#pragma mark - 查看拒绝原因
-(void)refuseAction
{
    if (self.lookRefusedTextAction) {
        self.lookRefusedTextAction(self.indexPath);
    }
}

//处理选中背景色问题
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (!self.editing) {
        return;
    }
    [super setSelected:selected animated:animated];
    
    if (self.editing) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];

    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
