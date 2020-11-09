//
//  StickCell.m
//  Shaolin
//
//  Created by edz on 2020/3/5.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StickCell.h"

@implementation StickCell
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
//    这里的30是tableView的左右边距
//    CGRect anserRect = [optionStr boundingRectWithSize:CGSizeMake(kWidth - 30 - 20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kRegular(16)} context:nil];
//    CGFloat cHeight = anserRect.size.height;
//
//    f.cellHeight =  36 + cHeight;
    
//    self.titleL.height = f.cellHeight;
    self.titleL.text = [NSString stringWithFormat:@"%@",f.title];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",f.author];
}


-(void)setupView
{
    [self.contentView addSubview:self.titleL];
    [self.contentView addSubview:self.stickLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(5);
    }];
    
    [self.stickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleL);
        make.top.mas_equalTo(self.titleL.mas_bottom).mas_offset(2);
        make.size.mas_equalTo(CGSizeMake(26, 18.5));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(78, 18.5));
        make.left.mas_equalTo(self.stickLabel.mas_right).offset(10);
        make.top.mas_equalTo(self.stickLabel);
        make.bottom.mas_equalTo(-5);
    }];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCellPosition:(CellPosition)cellPosition{
    [super setCellPosition:cellPosition];
    if (cellPosition == CellPosition_Top || cellPosition == CellPosition_OnlyOne){
        [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
        }];
    } else {
        [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
        }];
    }
    
    if (cellPosition == CellPosition_Bottom || cellPosition == CellPosition_OnlyOne){
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-15);
        }];
    } else {
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
        }];
    }
}
-(UILabel *)titleL
{
    if (!_titleL) {
        _titleL = [[UILabelLeftTopAlign alloc]init];
        _titleL.font = kRegular(16);
        _titleL.textColor = [UIColor colorForHex:@"333333"];
        _titleL.text = NSLocalizedString(@"千百年来头一回,少林功夫终于有了评定标准", nil);
        _titleL.numberOfLines = 2;
    }
    return _titleL;
}
-(UILabel *)stickLabel
{
    if (!_stickLabel) {
        _stickLabel = [[UILabel alloc]init];
        _stickLabel.font = kRegular(13);
        _stickLabel.textColor = [UIColor colorForHex:@"AE8453"];
        _stickLabel.text = SLLocalizedString(@"置顶");
    }
    return _stickLabel;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = kRegular(13);
        _nameLabel.textColor = [UIColor colorForHex:@"999999"];
        _nameLabel.text = SLLocalizedString(@"少林官网新闻");
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}
//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//
//
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
