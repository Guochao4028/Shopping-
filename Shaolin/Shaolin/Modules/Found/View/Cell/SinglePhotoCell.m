//
//  SinglePhotoCell.m
//  Shaolin
//
//  Created by edz on 2020/3/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SinglePhotoCell.h"
#import "DefinedURLs.h"



@implementation SinglePhotoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setFoundModel:(FoundModel *)f indexpath:(NSIndexPath *)indexPath
{
    _model = f;
    
    //    [self.titleL setNumberOfLines:2];
    [self.detailsLabel setHidden:YES];
    
    //    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.width.mas_equalTo(kWidth-SLChange(157));
    //        make.left.mas_equalTo(SLChange(11));
    //        make.height.mas_equalTo(SLChange(60));
    //        make.top.mas_equalTo(SLChange(18));
    //    }];
    
    f.cellHeight = SLChange(105);
    self.titleL.text = [NSString stringWithFormat:@"%@",f.title];
    NSString *urlStr;
    if (f.coverUrlList.count < 1) {
    }else
    {
        for (NSDictionary *dic in f.coverUrlList) {
            urlStr = [dic objectForKey:@"route"];
        }
    }
    
    if ([f.kind isEqualToString:@"3"]) {
        self.plaayerBtn.hidden = NO;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlStr,Video_First_Photo]] placeholderImage:[UIImage imageNamed:@"default_big"]];
        [self.detailsLabel setHidden:NO];
        //        [self.titleL setNumberOfLines:1];
        //        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.width.mas_equalTo(kWidth-SLChange(157));
        //            make.left.mas_equalTo(SLChange(11));
        //            make.height.mas_equalTo(SLChange(21));
        //            make.top.mas_equalTo(SLChange(18));
        //        }];
        [self.detailsLabel setText:f.abstracts];
    }else
    {
        self.plaayerBtn.hidden = YES;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlStr]] placeholderImage:[UIImage imageNamed:@"default_big"]];
    }
    NSDate *date= [self nsstringConversionNSDate:f.returnTime];
    NSString *timeStr = @"";//[NSString stringWithFormat:@"%@",[self compaareCurrentTime:date]];
    
    NSString *strCount = f.click;
    if (strCount.integerValue <= 0) {
        strCount = [NSString stringWithFormat:@"0"];
    }else if(strCount.integerValue < 10000){
        strCount = [NSString stringWithFormat:@"%@", strCount];
    }else{
        double d = strCount.doubleValue;
        double num = d / 10000;
        strCount = [NSString stringWithFormat:SLLocalizedString(@"%.1f万"), num];
    }
    self.nameLabel.text = [NSString stringWithFormat:SLLocalizedString(@"%@  %@人浏览  %@  "),f.author,strCount,timeStr];
    //
    //    CGSize nameSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    //
    //    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.width.mas_equalTo(nameSize.width+5);
    //    }];
//    self.imageV.image = [UIImage imageNamed:@"default_big"];
}


- (void)setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleL];
//    [self.contentView addSubview:self.detailsLabel];
    [self.contentView addSubview:self.imageV];
    [self.imageV addSubview:self.plaayerBtn];
    [self.contentView addSubview:self.nameLabel];
    //    [self.contentView addSubview:self.lookLabel];
    //
    //    [self.contentView addSubview:self.timeLabel];
    
    if ([self.model.kind isEqualToString:@"3"]) {
        self.detailsLabel.hidden = NO;
    } else {
        self.detailsLabel.hidden = YES;
    }
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(self.imageV.mas_left).mas_offset(-7);
        make.top.mas_equalTo(15);
    }];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.titleL);
        make.size.mas_equalTo(CGSizeMake(109, 75));
        make.bottom.mas_equalTo(-15);
    }];
    
//    [self.detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.titleL);
//        make.height.mas_equalTo(SLChange(15));
//        make.top.mas_equalTo(self.titleL.mas_bottom).mas_offset(3);
//    }];
    
    
    [self.plaayerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.imageV);
        make.size.mas_equalTo(CGSizeMake(29, 29));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleL);
//        make.top.mas_equalTo(self.detailsLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.imageV.mas_left);
        make.height.mas_equalTo(17);
        make.bottom.mas_equalTo(self.imageV);
//        make.bottom.mas_equalTo(self.contentView).mas_equalTo(-18);
    }];
//    [self.lookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//              make.left.mas_equalTo(self.nameLabel.mas_right).offset(SLChange(10));
//              make.centerY.mas_equalTo(self.nameLabel);
//              make.width.mas_equalTo(SLChange(70));
//              make.height.mas_equalTo(SLChange(16.5));
//          }];
//    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.lookLabel.mas_right).offset(SLChange(10));
//        make.centerY.mas_equalTo(self.nameLabel);
//        make.width.mas_equalTo(SLChange(52));
//        make.height.mas_equalTo(SLChange(16.5));
//    }];
}

- (UIImage *)getShowImage{
    return self.imageV.image;
}
- (UIButton *)plaayerBtn
{
    if (!_plaayerBtn) {
        _plaayerBtn = [[UIButton alloc]init];
        [_plaayerBtn setImage:[UIImage imageNamed:@"found_video_play"] forState:(UIControlStateNormal)];
        _plaayerBtn.userInteractionEnabled = NO;
    }
    return _plaayerBtn;
}
- (UILabelLeftTopAlign *)titleL
{
    if (!_titleL) {
        _titleL = [[UILabelLeftTopAlign alloc]init];
        _titleL.font = kRegular(16);
        _titleL.numberOfLines = 2;
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.textColor = KTextGray_333;
        _titleL.text = @"";
    }
    return _titleL;
}
- (UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.backgroundColor = [UIColor clearColor];
        _imageV.layer.cornerRadius = 4;
        _imageV.userInteractionEnabled = YES;
        _imageV.clipsToBounds = YES;
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageV;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = kRegular(12);
        _nameLabel.numberOfLines = 1;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = KTextGray_999;
        _nameLabel.text = @"";
    }
    return _nameLabel;
}
//- (UILabel *)lookLabel
//{
//    if (!_lookLabel) {
//           _lookLabel = [[UILabel alloc]init];
//           _lookLabel.font = kRegular(12);
//           _lookLabel.numberOfLines = 1;
//           _lookLabel.textAlignment = NSTextAlignmentLeft;
//           _lookLabel.textColor = KTextGray_999;
//           _lookLabel.text = @"";
//       }
//       return _lookLabel;
//}
//
//- (UILabel *)timeLabel
//{
//    if (!_timeLabel) {
//           _timeLabel = [[UILabel alloc]init];
//           _timeLabel.font = kRegular(12);
//           _timeLabel.numberOfLines = 1;
//           _timeLabel.textAlignment = NSTextAlignmentLeft;
//           _timeLabel.textColor = KTextGray_999;
//           _timeLabel.text = @"";
//          
//       }
//       return _timeLabel;
//}

- (UILabel *)detailsLabel{
    
    if (_detailsLabel == nil) {
        _detailsLabel = [[UILabel alloc]init];
        
        _detailsLabel.font = kRegular(13);
        _detailsLabel.numberOfLines = 1;
        _detailsLabel.textAlignment = NSTextAlignmentLeft;
        _detailsLabel.textColor = KTextGray_999;
        _detailsLabel.text = @"";
    }
    return _detailsLabel;
    
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
