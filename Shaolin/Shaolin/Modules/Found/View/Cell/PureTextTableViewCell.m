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

-(void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleL];
    [self.contentView addSubview:self.nameLabel];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(15);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleL);
        make.top.mas_equalTo(self.titleL.mas_bottom).mas_offset(5);
        make.bottom.mas_equalTo(-15);
    }];
}

-(void)setFoundModel:(FoundModel *)f indexpath:(NSIndexPath *)indexPath {
    
    self.titleL.text = [NSString stringWithFormat:@"%@",f.title];
    
    NSDate * date= [self nsstringConversionNSDate:f.returnTime];
    NSString * timeStr = @"";//[NSString stringWithFormat:@"%@",[self compaareCurrentTime:date]];
    
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
}

- (UILabelLeftTopAlign *)titleL {
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

- (UILabel *)nameLabel {
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
