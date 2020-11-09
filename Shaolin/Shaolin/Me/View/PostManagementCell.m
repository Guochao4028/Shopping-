//
//  PostManagementCell.m
//  Shaolin
//
//  Created by edz on 2020/3/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PostManagementCell.h"

@interface PostManagementCell()
@property(nonatomic,strong) NSArray *imageArr;
@end
@implementation PostManagementCell
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
    
    [self.contentView addSubview:self.imageOne];
    [self.contentView addSubview:self.imageTwo];
    [self.imageTwo addSubview:self.moreBtn];
    [self.contentView addSubview:self.bigImage];
    [self.bigImage addSubview:self.plaayerBtn];
    [self.titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(15));
        make.right.mas_equalTo(self.bigImage.mas_left).mas_offset(-SLChange(15));//-SLChange(15)
        make.top.mas_equalTo(SLChange(14));
        //        make.height.mas_equalTo(SLChange(14));
        make.width.mas_equalTo(SLChange(214));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(15));
        make.top.mas_equalTo(self.titleLabe.mas_bottom).offset(SLChange(11));
        make.height.mas_equalTo(SLChange(33));
        make.width.mas_equalTo(SLChange(214));
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(11.5));
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(SLChange(7));
        make.height.mas_equalTo(SLChange(11));
        make.width.mas_equalTo(SLChange(37));
        make.bottom.mas_equalTo(-SLChange(14));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.statusLabel.mas_right).offset(SLChange(11));
        make.centerY.mas_equalTo(self.statusLabel);
        make.height.mas_equalTo(SLChange(11));
        make.width.mas_equalTo(SLChange(41));
    }];
    [self.refusedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_right).offset(SLChange(11));
        make.height.mas_equalTo(SLChange(18));
        make.width.mas_equalTo(SLChange(64));
        make.centerY.mas_equalTo(self.statusLabel);
    }];
    
    
    
    [self.imageTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-SLChange(15));
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(SLChange(68));
        make.width.mas_equalTo(SLChange(53));
    }];
    [self.imageOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.imageTwo.mas_left);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(SLChange(68));
        make.width.mas_equalTo(SLChange(53));
    }];
    [self.bigImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-SLChange(15));
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(SLChange(68));
        make.width.mas_equalTo(SLChange(106));
    }];
    [self.plaayerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.bigImage);
        make.size.mas_equalTo(SLChange(29));
    }];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.centerY.mas_equalTo(self.imageTwo);
        //        make.height.mas_equalTo(SLChange(4));
        //        make.width.mas_equalTo(SLChange(20));
        make.edges.mas_equalTo(0);
    }];
}
-(void)setMePostManagerModel:(MePostManagerModel *)f indexpath:(NSIndexPath *)indexPath
{
    
    f.cellHeight = SLChange(106);
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
    
    if (f.abstracts.length == 0) {
        self.contentLabel.text = @"";
    }else
    {
        self.contentLabel.text = [NSString stringWithFormat:@"%@",f.abstracts];
    }
    
    
    if ([f.kind isEqualToString:@"2"]) {
        self.plaayerBtn.hidden = YES;
        self.imageArr = @[];
        // array = [f.coverurl componentsSeparatedByString:@","];
        self.imageArr = f.coverurlList;
        if (self.imageArr.count ==1) {
            self.imageOne.hidden = YES;
            self.imageTwo.hidden = YES;
            self.bigImage.hidden = NO;
            NSString *urlStr;
            for (NSDictionary *dic in f.coverurlList) {
                urlStr = [dic objectForKey:@"route"];
            }
            [self.bigImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlStr]] placeholderImage:[UIImage imageNamed:@"default_small"]];
        }else if (self.imageArr.count==2)
        {
            self.moreBtn.hidden = YES;
            self.imageOne.hidden = NO;
            self.imageTwo.hidden = NO;
            self.bigImage.hidden = YES;
            [self.imageOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageArr[0][@"route"]]] placeholderImage:[UIImage imageNamed:@"default_small"]];
            [self.imageTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageArr[1][@"route"]]] placeholderImage:[UIImage imageNamed:@"default_small"]];
        }else
        {
            self.moreBtn.hidden = NO;
            self.imageOne.hidden = NO;
            self.imageTwo.hidden = NO;
            self.bigImage.hidden = YES;
            [self.imageOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageArr[0][@"route"]]] placeholderImage:[UIImage imageNamed:@"default_small"]];
            [self.imageTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageArr[1][@"route"]]] placeholderImage:[UIImage imageNamed:@"default_small"]];
        }
    }else
    {
        self.plaayerBtn.hidden = NO;
        self.imageOne.hidden = YES;
        self.imageTwo.hidden = YES;
        self.bigImage.hidden = NO;
        NSString *urlStr;
        for (NSDictionary *dic in f.coverurlList) {
            urlStr = [dic objectForKey:@"route"];
        }
        [self.bigImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlStr,Video_First_Photo]] placeholderImage:[UIImage imageNamed:@"default_big"]];
    }
    NSDate *date= [self nsstringConversionNSDate:f.returnTime];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[self compaareCurrentTime:date]];
    
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
                imageView.image = [UIImage imageNamed:@"me_postmanagement_select"]; // 选中时的图片
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
        _titleLabe.font = kRegular(14);
        _titleLabe.textAlignment = NSTextAlignmentLeft;
        _titleLabe.numberOfLines = 2;
        _titleLabe.text = @"asdasdaa";
    }
    return _titleLabe;
}
-(UILabelLeftTopAlign *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabelLeftTopAlign alloc] init];
        _contentLabel.textColor = [UIColor colorForHex:@"999999"];
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
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.text = SLLocalizedString(@"审核中");
    }
    return _statusLabel;
}
-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorForHex:@"999999"];
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

-(UIImageView *)imageOne
{
    if (!_imageOne) {
        _imageOne = [[UIImageView alloc]init];
        _imageOne.backgroundColor = [UIColor clearColor];
    }
    return _imageOne;
}

-(UIImageView *)imageTwo
{
    if (!_imageTwo) {
        _imageTwo = [[UIImageView alloc]init];
        _imageTwo.backgroundColor = [UIColor colorForHex:@"000000"];//[UIColor clearColor];
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoBigImageView:)];
        [_imageTwo addGestureRecognizer:myTap];
    }
    return _imageTwo;
}
//-(void)oneBigImageView:(UITapGestureRecognizer *)tap
//{
//    NSDictionary *dicc = @{@"selectImage":self.imageArr};
//      [[NSNotificationCenter defaultCenter]postNotificationName:@"SelectLookOneImage" object:nil userInfo:dicc];
//    WMPhotoBrowser *browser = [WMPhotoBrowser new];
//       browser.dataSource = @[@"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160426/14616659617000.jpg",@"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160307/14573358906810.JPEG",@"http://weixintest.ihk.cn/ihkwx_upload/userPhoto/18565061404-1448440129479.jpg",@"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160519/14636417292422.jpg"].mutableCopy;
//       browser.deleteNeeded = NO;
//        browser.currentPhotoIndex= 2;

//    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
//
//    // 2.1 设置图片源(UIImageView)数组
//    photoBroseView.imagesURL = self.imageArr;
//    // 2.2 设置初始化图片下标（即当前点击第几张图片）
//    photoBroseView.currentIndex = 0;
//
//    // 3.显示(浏览)
//    [photoBroseView show];
//}
-(void)twoBigImageView:(UITapGestureRecognizer *)tap
{
    //    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
    //
    //    // 2.1 设置图片源(UIImageView)数组
    //    photoBroseView.imagesURL = self.imageArr;
    //    // 2.2 设置初始化图片下标（即当前点击第几张图片）
    //    photoBroseView.currentIndex = 1;
    //
    //    // 3.显示(浏览)
    //    [photoBroseView show];
}
-(UIImageView *)bigImage
{
    if (!_bigImage) {
        _bigImage = [[UIImageView alloc]init];
        _bigImage.backgroundColor = [UIColor clearColor];
        _bigImage.contentMode = UIViewContentModeScaleAspectFill;
        _bigImage.clipsToBounds = YES;
    }
    return _bigImage;
}
-(UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_moreBtn setImage:[UIImage imageNamed:@"me_postmanagement_moreImage"] forState:(UIControlStateNormal)];
        [_moreBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    }
    return _moreBtn;
}
-(UIButton *)plaayerBtn
{
    if (!_plaayerBtn) {
        _plaayerBtn = [[UIButton alloc]init];
        [_plaayerBtn setImage:[UIImage imageNamed:@"found_video_play"] forState:(UIControlStateNormal)];
        [_plaayerBtn addTarget:self action:@selector(playerAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _plaayerBtn;
}
-(void)playerAction:(UIButton *)btn
{
    
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
