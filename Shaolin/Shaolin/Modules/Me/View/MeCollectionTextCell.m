//
//  MeCollectionTextCell.m
//  Shaolin
//
//  Created by edz on 2020/4/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeCollectionTextCell.h"

@implementation MeCollectionTextCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
      if (self) {
          [self setupView];
      }
      return self;
}

- (void)setupView {
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.titleL];
    [self.contentView addSubview:self.abstractsLabel];
    [self.contentView addSubview:self.priseBtn];
}

- (void)setModel:(FoundModel *)model {
    _model = model;
    if (model.coverurlList.count < 1) {
        self.imageV.image = [UIImage imageNamed:@"default_collection"];
       }else
       {
            [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.coverurlList[0][@"route"]]] placeholderImage:[UIImage imageNamed:@"default_collection"]];

       }
    NSString *str = model.abstracts;//[self filterHTML:model.content];
    self.abstractsLabel.text = [NSString stringWithFormat:@"%@",str];
    self.titleL.text = [NSString stringWithFormat:@"%@",model.title];
    if ([model.collection isEqualToString:@"0"]) {
        [self.priseBtn setSelected:NO];
    }else {
        [self.priseBtn setSelected:YES];
    }
}

- (NSString *)filterHTML:(NSString *)html{
    NSDictionary *dic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSData *data = [html dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *attriStr = [[NSAttributedString alloc] initWithData:data options:dic documentAttributes:nil error:nil];
    NSString *str = attriStr.string;
    //str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return str;
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(115));
        make.left.mas_equalTo(SLChange(15.5));
        make.height.mas_equalTo(SLChange(88));
        make.top.mas_equalTo(SLChange(16));
    }];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-SLChange(190));
        make.left.mas_equalTo(self.imageV.mas_right).offset(SLChange(19));
        make.height.mas_equalTo(SLChange(14));
        make.top.mas_equalTo(SLChange(23));
    }];
    
    [self.priseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SLChange(22));
        make.left.mas_equalTo(self.titleL.mas_right).mas_offset(SLChange(5));
        make.top.mas_equalTo(SLChange(16));
    }];
    
     [self.abstractsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.imageV.mas_right).offset(SLChange(19));
         make.top.mas_equalTo(self.titleL.mas_bottom).offset(SLChange(15));
         make.width.mas_equalTo(SLChange(194));
         make.height.mas_equalTo(SLChange(44));
     }];
}

- (UILabelLeftTopAlign *)titleL {
    if (!_titleL) {
        _titleL = [[UILabelLeftTopAlign alloc]init];
        _titleL.font = kRegular(14);
        _titleL.numberOfLines = 1;
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.textColor = [UIColor colorForHex:@"000000"];
        _titleL.text = @"";
    }
    return _titleL;
}

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.backgroundColor = [UIColor clearColor];
        _imageV.userInteractionEnabled = YES;
        _imageV.clipsToBounds = YES;
        _imageV.cornerRadius = 4;
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageV;
}
- (UIButton *)priseBtn {
    if (!_priseBtn) {
        _priseBtn = [[UIButton alloc]init];
        [_priseBtn setImage:[UIImage imageNamed:@"focus_normal"] forState:(UIControlStateNormal)];
        [_priseBtn setImage:[UIImage imageNamed:@"focus_select_yellow"] forState:(UIControlStateSelected)];
        [_priseBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    }
    return _priseBtn;
}

- (UILabelLeftTopAlign *)abstractsLabel {
    if (!_abstractsLabel) {
           _abstractsLabel = [[UILabelLeftTopAlign alloc]init];
           _abstractsLabel.font = kRegular(11);
           _abstractsLabel.numberOfLines = 0;
           _abstractsLabel.textAlignment = NSTextAlignmentLeft;
           _abstractsLabel.textColor = KTextGray_999;
           _abstractsLabel.text = @"";
       }
       return _abstractsLabel;
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
