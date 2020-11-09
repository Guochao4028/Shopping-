//
//  ReadingTextCell.m
//  Shaolin
//
//  Created by edz on 2020/4/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ReadingTextCell.h"

@implementation ReadingTextCell
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
    
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.titleL];
    [self.contentView addSubview:self.nameLabel];
//    [self.contentView addSubview:self.deleteBtn];
}
-(void)setMePostManagerModel:(FoundModel *)model indexpath:(NSIndexPath *)indexPath
{
    if (model.coverurlList.count < 1) {
           self.imageV.image = [UIImage imageNamed:@"shaolinlogo"];
          }else
          {
              [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.coverurlList[0][@"route"]]] placeholderImage:[UIImage imageNamed:@"default_small"]];
          }
       NSDate *date= [self nsstringConversionNSDate:model.returnTime];
       NSString *timeStr = [NSString stringWithFormat:@"%@",[self compaareCurrentTime:date]];
       self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",model.author,timeStr];
       self.titleL.text = [NSString stringWithFormat:@"%@",model.title];
}

-(void)layoutSubviews
{
   [super layoutSubviews];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
          make.width.mas_equalTo(SLChange(145));
          make.left.mas_equalTo(SLChange(15.5));
          make.height.mas_equalTo(SLChange(74));
          make.top.mas_equalTo(SLChange(16.5));
    }];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(SLChange(181));
           make.left.mas_equalTo(self.imageV.mas_right).offset(SLChange(19));
           make.height.mas_equalTo(SLChange(45));
           make.top.mas_equalTo(SLChange(21.5));
    }];
   
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageV.mas_right).offset(SLChange(19));
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(SLChange(8));
        make.width.mas_equalTo(SLChange(175));
        make.height.mas_equalTo(SLChange(11.5));
    }];

//    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(SLChange(19));
//        make.left.mas_equalTo(-SLChange(12));
//        make.centerY.mas_equalTo(self.contentView);
//    }];
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


-(UILabelLeftTopAlign *)titleL
{
    if (!_titleL) {
        _titleL = [[UILabelLeftTopAlign alloc]init];
        _titleL.font = kRegular(14);
        _titleL.numberOfLines = 0;
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.textColor = [UIColor colorForHex:@"333333"];
        _titleL.text = @"";
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
    }
    return _imageV;
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
-(UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc]init];
        [_deleteBtn setImage:[UIImage imageNamed:@"me_postmanagement_normal"] forState:(UIControlStateNormal)];
         [_deleteBtn setImage:[UIImage imageNamed:@"me_postmanagement_select"] forState:(UIControlStateSelected)];
    }
    return _deleteBtn;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
-(NSString *)compaareCurrentTime:(NSDate *)compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];

    timeInterval = -timeInterval;

    long temp = 0;

    NSString *result;

    if (timeInterval < 60) {

        result = [NSString stringWithFormat:SLLocalizedString(@"刚刚")];

    }

    else if((temp = timeInterval/60) <60){

        result = [NSString stringWithFormat:SLLocalizedString(@"%ld分前"),temp];

    }



    else if((temp = temp/60) <24){

        result = [NSString stringWithFormat:SLLocalizedString(@"%ld小前"),temp];

    }



    else if((temp = temp/24) <30){

        result = [NSString stringWithFormat:SLLocalizedString(@"%ld天前"),temp];

    }



    else if((temp = temp/30) <12){

        result = [NSString stringWithFormat:SLLocalizedString(@"%ld月前"),temp];

    }

    else{

        temp = temp/12;

        result = [NSString stringWithFormat:SLLocalizedString(@"%ld年前"),temp];

    }



    return  result;
  
}
-(NSDate *)nsstringConversionNSDate:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    return datestr;
}
@end
