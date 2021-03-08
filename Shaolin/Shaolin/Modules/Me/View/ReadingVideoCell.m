//
//  ReadingVideoCell.m
//  Shaolin
//
//  Created by edz on 2020/4/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ReadingVideoCell.h"
#import "DefinedURLs.h"

@implementation ReadingVideoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}
- (void)setModel:(FoundModel *)model {
    _model = model;
    self.nameLabel.text = model.title;
    if (self.isCollect) {
        NSString *time = [NSString stringWithFormat:@"%@",[model.collectionTime substringToIndex:10]];
        NSString *timeStr = [time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        self.timeLabel.text = [NSString stringWithFormat:SLLocalizedString(@"收藏于%@"),timeStr];
    } else {
        NSString *time = [NSString stringWithFormat:@"%@",[model.returnTime substringToIndex:10]];
        NSString *timeStr = [time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        self.timeLabel.text = [NSString stringWithFormat:SLLocalizedString(@"阅读于%@"),timeStr];
    }
    
    
    if (model.coverUrlList == nil || model.coverUrlList.count == 0) {
        self.imageV.image = [UIImage imageNamed:@"default_big"];
    }else {
        //        [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", model.coverurlList[0][@"route"], Video_First_Photo]]];
        NSString *imageName = [NSString stringWithFormat:@"%@%@", model.coverUrlList[0][@"route"], Video_First_Photo];
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"default_big"]];
        //https://static.oss.cdn.oss.gaoshier.cn/other/3a417838-6889-42cd-af46-40ace83b100e.mp4?x-oss-process=video/snapshot,t_3000,m_fast,ar_auto
        if (model.videoTimeStr.length){
            [self.timeBtn setTitle:[NSString stringWithFormat:@" %@", model.videoTimeStr] forState:UIControlStateNormal];
        } else {
            WEAKSELF
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                NSString *videoTimeStr = [weakSelf getVideoTimeByUrlString:model.coverUrlList[0][@"route"]];
                if (model.hash == weakSelf.model.hash){
                    model.videoTimeStr = videoTimeStr;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.timeBtn setTitle:[NSString stringWithFormat:@" %@", videoTimeStr] forState:UIControlStateNormal];
                    });
                }
            });
        }
    }
    if ([model.collectionState isEqualToString:@"1"]) {
        [self.priseBtn setSelected:YES];
    }else {
        [self.priseBtn setSelected:NO];
    }
}

- (NSString *)getVideoTimeByUrlString:(NSString*)urlString {
    NSURL*videoUrl = [NSURL URLWithString:urlString];
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:videoUrl];
    
    CMTime time = [avUrl duration];
    
    int seconds = ceil(time.value/time.timescale);
    
    NSString *str_minute = [NSString stringWithFormat:@"%.2d",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%.2d",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    
    return format_time;
    
}

- (void)setupView {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.imageV];
    [self.imageV addSubview:self.playBtn];
    [self.imageV addSubview:self.timeBtn];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.imageV addSubview:self.priseBtn];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
    }];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(123);
        make.top.mas_equalTo(0);
    }];
    
    [self.priseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(22);
        make.right.mas_equalTo(-6);
        make.top.mas_equalTo(0);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SLChange(22));
        make.centerX.centerY.mas_equalTo(self.imageV);
    }];
    
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-6);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(SLChange(50));
        make.height.mas_equalTo(15);
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(11));
        make.top.mas_equalTo(self.imageV.mas_bottom).mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(kWidth-SLChange(140));
        //        make.height.mas_equalTo(SLChange(33));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-SLChange(11));
        make.top.bottom.mas_equalTo(self.nameLabel);
        make.width.mas_equalTo(SLChange(80));
        //           make.height.mas_equalTo(SLChange(33));
    }];
    
}


- (void)priseBtnClick:(UIButton *)button{
    button.selected = !button.selected;
    if (self.priseBtnClickBlock){
        self.priseBtnClickBlock(button.isSelected);
    }
}

- (UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.backgroundColor = [UIColor clearColor];
        _imageV.userInteractionEnabled = YES;
        _imageV.clipsToBounds = YES;
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageV;
}

- (UIButton *)priseBtn {
    if (!_priseBtn) {
        _priseBtn = [[UIButton alloc]init];
        [_priseBtn setImage:[UIImage imageNamed:@"focus_normal"] forState:(UIControlStateNormal)];
        [_priseBtn setImage:[UIImage imageNamed:@"focus_select_yellow"] forState:(UIControlStateSelected)];
        [_priseBtn setBackgroundImage:[UIImage imageNamed:@"priseBgView"] forState:(UIControlStateNormal)];
        [_priseBtn addTarget:self action:@selector(priseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_priseBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    }
    return _priseBtn;
}
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc]init];
        [_playBtn setImage:[UIImage imageNamed:@"history_play"] forState:(UIControlStateNormal)];
        _playBtn.userInteractionEnabled = NO;
    }
    return _playBtn;
}
- (UIButton *)timeBtn {
    if (!_timeBtn) {
        _timeBtn = [[UIButton alloc]init];
        [_timeBtn setImage:[UIImage imageNamed:@"history_time"] forState:(UIControlStateNormal)];
        [_timeBtn setTitleColor:KTextGray_999 forState:(UIControlStateNormal)];
        _timeBtn.titleLabel.font = kRegular(10);
        _timeBtn.backgroundColor = RGBA(229, 225, 233, 1);
        _timeBtn.layer.cornerRadius =4;
        _timeBtn.clipsToBounds = YES;
        _timeBtn.userInteractionEnabled = NO;
    }
    return _timeBtn;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView  = [[UIView alloc]init];
        _bgView.backgroundColor = RGBA(244, 240, 241, 1);
        _bgView.cornerRadius = 4;
    }
    return _bgView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = kRegular(13);
        _nameLabel.numberOfLines = 1;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = KTextGray_333;
        _nameLabel.text = @"";
    }
    return _nameLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = kRegular(9);
        _timeLabel.numberOfLines = 1;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = KTextGray_999;
        _timeLabel.text = @"";
    }
    return _timeLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//处理选中背景色问题
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.editing) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
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
}

@end
