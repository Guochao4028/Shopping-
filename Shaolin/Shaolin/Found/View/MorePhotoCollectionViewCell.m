//
//  MorePhotoCollectionViewCell.m
//  Shaolin
//
//  Created by edz on 2020/3/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MorePhotoCollectionViewCell.h"
@implementation MorePhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)configCellUrl:(NSArray *)urlArray indexPath:(NSIndexPath *)indexPath
{

   

    [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlArray[indexPath.row][@"route"]]] placeholderImage:[UIImage imageNamed:@"default_big"]];
   

    if (urlArray.count >3) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            _numLabel.hidden = YES;
            _numLabel.text = @"";
            _addLabel.text = @"";
            
        }else {
            _numLabel.hidden = NO;
             _numLabel.text = [NSString stringWithFormat:@"%ld",urlArray.count-3];
             _addLabel.text = @"+";
        }
       
    }
 
}
-(void)setUI
{
    [self.contentView addSubview: self.imageV];
    [self.imageV addSubview:self.numLabel];
    [self.imageV addSubview:self.addLabel];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(109));
        make.height.mas_equalTo(SLChange(76));
        make.top.left.mas_equalTo(0);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(53));
        make.height.mas_equalTo(SLChange(21));
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self.imageV);
    }];
    [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(SLChange(53));
           make.height.mas_equalTo(SLChange(18));
           make.right.mas_equalTo(self.imageV.mas_right);
           make.centerY.mas_equalTo(self.numLabel);
       }];
}
-(UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.backgroundColor = [UIColor clearColor];
        _imageV.clipsToBounds = YES;
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.image = [UIImage imageNamed:@"default_big"];
    }
    return _imageV;
}
-(UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]init];
        _numLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
        _numLabel.font = kMediumFont(18);
        _numLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numLabel;
}
-(UILabel *)addLabel
{
    if (!_addLabel) {
        _addLabel = [[UILabel alloc]init];
        _addLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
        _addLabel.font = kMediumFont(16);
        _addLabel.text = @"";
        _addLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _addLabel;
}
@end
