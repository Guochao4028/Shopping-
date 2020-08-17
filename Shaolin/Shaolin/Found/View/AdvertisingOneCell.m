//
//  AdvertisingOneCell.m
//  Shaolin
//
//  Created by edz on 2020/3/5.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AdvertisingOneCell.h"

@implementation AdvertisingOneCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setFoundModel:(FoundModel *)f indexpath:(NSIndexPath *)indexPath
{
    
    self.titleL.text = f.title;
    NSString *urlStr;
    for (NSDictionary *dic in f.coverurlList) {
        urlStr = [dic objectForKey:@"route"];
    }
    if ([f.kind isEqualToString:@"3"]) {
        self.plaayerBtn.hidden =NO;
        self.imageV.tag = 100;//设置为100可以被ZFPlayer找到，并将播放器加到imageV上
        self.imageV.userInteractionEnabled = YES;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlStr,Video_First_Photo]] placeholderImage:[UIImage imageNamed:@"default_big"]];
    }else
    {
        
        self.plaayerBtn.hidden = YES;
        self.imageV.tag = 1001;//设置为1001可以避免被ZFPlayer找到，并将播放器加到imageV上
        self.imageV.userInteractionEnabled = NO;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlStr]] placeholderImage:[UIImage imageNamed:@"default_big"]];
    }
    
    self.userNameLabel.text = f.author;
    CGFloat width = [UILabel getWidthWithTitle:self.titleL.text font:self.titleL.font];
    
    if ( width < kWidth-SLChange(32)) {
        [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(SLChange(16));
        }];
        
        
        f.cellHeight =  SLChange(321);
    }else
    {
        f.cellHeight =  SLChange(350);
        
    }
    self.indexPath = indexPath;
}



-(void)setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.titleL];
    [self.contentView addSubview:self.imageV];
    [self.imageV addSubview:self.plaayerBtn];
    [self.contentView addSubview:self.grayView];
    [self.grayView addSubview:self.lookBtn];
    [self.grayView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.adLogoBtn];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.closeBtn];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.right.mas_equalTo(-SLChange(16));
        make.height.mas_equalTo(SLChange(45));
        make.top.mas_equalTo(SLChange(15));
    }];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleL);
        make.height.mas_equalTo(SLChange(195));
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(SLChange(10));
    }];
    [self.plaayerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.imageV);
        make.size.mas_equalTo(SLChange(29));
    }];
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleL);
        make.height.mas_equalTo(SLChange(38));
        make.top.mas_equalTo(self.imageV.mas_bottom);
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);//SLChange(10)
        make.right.mas_equalTo(self.lookBtn.mas_left).mas_equalTo(-SLChange(10));
        make.centerY.mas_equalTo(self.grayView);
        make.height.mas_equalTo(SLChange(25));
    }];
    [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);//-SLChange(10)
        make.centerY.mas_equalTo(self.grayView);
        make.width.mas_equalTo(SLChange(70));
        make.height.mas_equalTo(SLChange(25));
    }];
    
    [self.adLogoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.grayView.mas_bottom).offset(SLChange(10));
        make.left.mas_equalTo(self.titleL);
        make.width.mas_equalTo(SLChange(30));
        make.height.mas_equalTo(SLChange(20));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.adLogoBtn.mas_right).offset(SLChange(5));
        make.centerY.mas_equalTo(self.adLogoBtn);
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(SLChange(16.5));
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.adLogoBtn);
        make.right.mas_equalTo(-SLChange(16));
        make.width.mas_equalTo(SLChange(20));
        make.height.mas_equalTo(SLChange(15));
    }];
}
-(UILabelLeftTopAlign *)titleL
{
    if (!_titleL) {
        _titleL = [[UILabelLeftTopAlign alloc]init];
        _titleL.font = kRegular(16);
        _titleL.numberOfLines = 0;
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.textColor = [UIColor colorForHex:@"333333"];
        _titleL.text = SLLocalizedString(@"少林寺专属茶宠，小和尚精品茶宠，可养茶，可泡茶");
    }
    return _titleL;
}
-(UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.backgroundColor = [UIColor clearColor];
        _imageV.userInteractionEnabled = YES;
        _imageV.clipsToBounds = YES;
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapGestureRecognizer:)];
        [_imageV addGestureRecognizer:tap];
    }
    return _imageV;
}
-(UIView *)grayView
{
    if (!_grayView) {
        _grayView = [[UIView alloc]init];
        _grayView.backgroundColor = RGBA(252, 250, 250, 1);
        _grayView.userInteractionEnabled = YES;
    }
    return _grayView;
}

-(UIButton *)lookBtn
{
    if (!_lookBtn) {
        _lookBtn = [[UIButton alloc]init];
        
        _lookBtn.layer.borderWidth = 1;
        _lookBtn.layer.borderColor = [UIColor colorForHex:@"C43E37"].CGColor;
        _lookBtn.layer.masksToBounds = YES;
        _lookBtn.layer.cornerRadius = 4;
        [_lookBtn setTitle:SLLocalizedString(@"查看详情") forState:(UIControlStateNormal)];
        [_lookBtn setTitleColor:[UIColor colorForHex:@"C43E37"] forState:(UIControlStateNormal)];
        _lookBtn.titleLabel.font = kRegular(13);
        _lookBtn.userInteractionEnabled = NO;
        //        [_lookBtn addTarget:self action:@selector(playerAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _lookBtn;
}
-(UIButton *)adLogoBtn
{
    if (!_adLogoBtn) {
        _adLogoBtn = [[UIButton alloc]init];
        [_adLogoBtn setImage:[UIImage imageNamed:@"found_advertising"] forState:(UIControlStateNormal)];
    }
    return _adLogoBtn;
}
-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = kRegular(12);
        _timeLabel.numberOfLines = 1;
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor colorForHex:@"999999"];
        _timeLabel.text = SLLocalizedString(@"30分钟前");
    }
    return _timeLabel;
}
-(UILabel *)userNameLabel
{
    if (!_userNameLabel){
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = kRegular(13);
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        _userNameLabel.textColor = [UIColor colorForHex:@"999999"];
    }
    return _userNameLabel;
}
-(UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setImage:[UIImage imageNamed:@"found_close"] forState:(UIControlStateNormal)];
        _closeBtn.hidden = YES;
    }
    return _closeBtn;
}
-(UIButton *)plaayerBtn
{
    if (!_plaayerBtn) {
        _plaayerBtn = [[UIButton alloc]init];
        [_plaayerBtn setImage:[UIImage imageNamed:@"found_video_play"] forState:(UIControlStateNormal)];
        [_plaayerBtn addTarget:self action:@selector(playerAction:) forControlEvents:(UIControlEventTouchUpInside)];
//        _plaayerBtn.userInteractionEnabled = NO;
    }
    return _plaayerBtn;
}


-(void)playerAction:(UIButton *)btn
{
    
    NSDictionary *dic = @{@"indexPath":self.indexPath};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"VideoPlayerAction" object:nil userInfo:dic];
}

- (void)imageViewTapGestureRecognizer:(UITapGestureRecognizer *)tap {
    //点击图片也能播放视频
//    UIView *imageView = tap.view;
//    if (imageView.tag == 100){
//        NSDictionary *dic = @{@"indexPath":self.indexPath};
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"VideoPlayerAction" object:nil userInfo:dic];
//    }
}

- (UIImage *)getShowImage{
    return self.imageV.image;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
