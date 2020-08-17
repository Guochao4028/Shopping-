//
//  PureTextTableViewCell.m
//  Shaolin
//
//  Created by edz on 2020/4/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PureTextTableViewCell.h"

@implementation PureTextTableViewCell
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
    
    
    
    NSString * optionStr = [NSString stringWithFormat:@"%@",f.title];
    CGRect anserRect = [optionStr boundingRectWithSize:CGSizeMake(kWidth-SLChange(32), 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleL.font} context:nil];
    CGFloat cHeight = anserRect.size.height;
    
    f.cellHeight =  36 + cHeight;
    

    self.titleL.text = [NSString stringWithFormat:@"%@",f.title];
//    CGFloat width = [UILabel getWidthWithTitle:self.titleL.text font:self.titleL.font];
//
//    if ( width < kWidth-SLChange(32)) {
//           [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
//              make.height.mas_equalTo(SLChange(16));
//           }];
//
//
//           f.cellHeight =  SLChange(76);
//       }else
//       {
//           f.cellHeight =  SLChange(105);
//
//       }
    NSDate * date= [self nsstringConversionNSDate:f.returnTime];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[self compaareCurrentTime:date]];
    
    NSString *strCount = f.clicks;
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

//    CGSize nameSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
//
//    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(nameSize.width+5);
//    }];
}
-(void)setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleL];
    [self.contentView addSubview:self.nameLabel];
//    [self.contentView addSubview:self.lookLabel];
//  
//    [self.contentView addSubview:self.timeLabel];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.right.mas_equalTo(-SLChange(16));
        make.top.mas_equalTo(SLChange(5));
    }];
    

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.height.mas_equalTo(SLChange(18.5));
        make.left.right.mas_equalTo(self.titleL);
        make.top.mas_equalTo(self.titleL.mas_bottom).mas_offset(5);
    }];
//    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(SLChange(16));
//        make.right.mas_equalTo(-SLChange(16));
//        make.top.mas_equalTo(SLChange(18));
//    }];
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.titleL);
//        make.top.mas_equalTo(self.titleL.mas_bottom).offset(SLChange(15));
//        make.height.mas_equalTo(SLChange(16.5));
//    }];
//       [self.lookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                 make.left.mas_equalTo(self.nameLabel.mas_right).offset(SLChange(10));
//                 make.centerY.mas_equalTo(self.nameLabel);
//                 make.width.mas_equalTo(SLChange(68));
//                 make.height.mas_equalTo(SLChange(16.5));
//             }];
//       [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//           make.left.mas_equalTo(self.lookLabel.mas_right).offset(SLChange(10));
//           make.centerY.mas_equalTo(self.nameLabel);
//           make.width.mas_equalTo(SLChange(52));
//           make.height.mas_equalTo(SLChange(16.5));
//       }];
}
-(UILabelLeftTopAlign *)titleL
{
    if (!_titleL) {
        _titleL = [[UILabelLeftTopAlign alloc]init];
        _titleL.font = kRegular(16);
        _titleL.numberOfLines = 0;
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.textColor = [UIColor colorForHex:@"333333"];
        _titleL.text = @"";
    }
    return _titleL;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
           _nameLabel = [[UILabel alloc]init];
           _nameLabel.font = kRegular(12);
           _nameLabel.numberOfLines = 1;
           _nameLabel.textAlignment = NSTextAlignmentLeft;
           _nameLabel.textColor = [UIColor colorForHex:@"999999"];
           _nameLabel.text = @"";
       }
       return _nameLabel;
}
//-(UILabel *)lookLabel
//{
//    if (!_lookLabel) {
//           _lookLabel = [[UILabel alloc]init];
//           _lookLabel.font = kRegular(12);
//           _lookLabel.numberOfLines = 1;
//           _lookLabel.textAlignment = NSTextAlignmentLeft;
//           _lookLabel.textColor = [UIColor colorForHex:@"999999"];
//           _lookLabel.text = @"";
//       }
//       return _lookLabel;
//}
//
//-(UILabel *)timeLabel
//{
//    if (!_timeLabel) {
//           _timeLabel = [[UILabel alloc]init];
//           _timeLabel.font = kRegular(12);
//           _timeLabel.numberOfLines = 1;
//           _timeLabel.textAlignment = NSTextAlignmentLeft;
//           _timeLabel.textColor = [UIColor colorForHex:@"999999"];
//           _timeLabel.text = @"";
//       }
//       return _timeLabel;
//}

- (UIImage *)getShowImage{
    return nil;
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
