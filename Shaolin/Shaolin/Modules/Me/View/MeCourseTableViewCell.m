//
//  MeCourseTableViewCell.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeCourseTableViewCell.h"
#import "MeCouresModel.h"

@interface MeCourseTableViewCell()
@property (nonatomic, strong) UIImageView *courseVideoImageView;
@property (nonatomic, strong) UILabel *courseTitleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UIButton *priseBtn;
@end

@implementation MeCourseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
//    self.contentView.backgroundColor = [UIColor clearColor];
//    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.courseVideoImageView];
    [self.contentView addSubview:self.courseTitleLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.priseBtn];
    
    [self.courseVideoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(110, 110));
    }];
    
    
    
    [self.courseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.courseVideoImageView.mas_right).mas_offset(19.5);
        make.top.mas_equalTo(self.courseVideoImageView).mas_offset(13);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(15);
    }];
    
    [self.priseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.courseTitleLabel);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.courseTitleLabel);
        make.top.mas_equalTo(self.courseTitleLabel.mas_bottom).mas_offset(15);
//        make.height.mas_equalTo(SLChange(32));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.courseTitleLabel);
        make.top.mas_equalTo(self.descLabel.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(12);
    }];
    
}

- (void)priseButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    if (self.priseButtonAction) self.priseButtonAction();
}

#pragma mark - test
- (void)testUI{
    self.courseTitleLabel.text = SLLocalizedString(@"少林弓步冲拳教程");
    self.descLabel.text = SLLocalizedString(@"少林小通臂拳具有完整的技术 和理论体系。它以武术技艺...");
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", @"265.66"];
    [self.courseVideoImageView sd_setImageWithURL:[NSURL URLWithString:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1142166796,2385197542&fm=26&gp=0.jpg"] placeholderImage:nil];
    self.timeLabel.text = @"53:06";
    self.priseBtn.selected = YES;
}

#pragma mark - getter、setter
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *imageView = (UIImageView *)v;
                    if (self.selected) {
                        imageView.image = [UIImage imageNamed:@"me_postmanagement_select_yellow"]; // 选中时的图片
                    } else {
                        imageView.image = [UIImage imageNamed:@"me_postmanagement_normal"];   // 未选中时的图片
                    }
                }
            }
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.editing) {
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

- (void)setModel:(MeCouresModel *)model{
    _model = model;
    
    if (IsNilOrNull(model)) {
        return;
    }
    
    self.courseTitleLabel.text = model.name;
    
    
//    self.descLabel.text = [self filterHTML:[self filterHTML:model.intro]];
    self.descLabel.text = model.goods_value;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.old_price];
    [self.courseVideoImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"default_small"]];
    NSInteger weight = [model.weight integerValue];
    NSInteger hour = weight/60;
    NSInteger minute = weight%60;
    self.timeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld", hour, minute];
    self.priseBtn.selected = YES;
    
}


- (NSString *)filterHTML:(NSString *)html{
    NSDictionary *dic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSData *data = [html dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *attriStr = [[NSAttributedString alloc] initWithData:data options:dic documentAttributes:nil error:nil];
    NSString *str = attriStr.string;
    //str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return str;
    
}
//- (NSAttributedString *)converattrStringWith:(NSString *)string {
//
//    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
//    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
//    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
//    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
//    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
//    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
//
//    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//
//    return attrStr;
//}



- (UIImageView *)courseVideoImageView{
    if (!_courseVideoImageView){
        _courseVideoImageView = [[UIImageView alloc] init];
        _courseVideoImageView.userInteractionEnabled = YES;
        _courseVideoImageView.cornerRadius = 4;
        _courseVideoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _courseVideoImageView.clipsToBounds = YES;
        UIButton *playBtn = [[UIButton alloc]init];
        [playBtn setImage:[UIImage imageNamed:@"history_play"] forState:UIControlStateNormal];
        playBtn.userInteractionEnabled = NO;
        [_courseVideoImageView addSubview:playBtn];
        [_courseVideoImageView addSubview:self.timeView];
        
        [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_courseVideoImageView);
            make.size.mas_equalTo(CGSizeMake(SLChange(22), SLChange(22)));
        }];
        [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SLChange(5));
            make.bottom.mas_equalTo(-SLChange(5));
            make.height.mas_equalTo(SLChange(15));
//            make.size.mas_equalTo(CGSizeMake(SLChange(49.5), SLChange(15)));
        }];
    }
    return _courseVideoImageView;
}

- (UILabel *)courseTitleLabel {
    if (!_courseTitleLabel) {
        _courseTitleLabel = [[UILabel alloc] init];
        _courseTitleLabel.font = kRegular(15);
        _courseTitleLabel.textColor = KTextGray_333;
    }
    return _courseTitleLabel;
}

- (UILabel *)descLabel{
    if (!_descLabel){
        _descLabel = [[UILabelLeftTopAlign alloc] init];
        _descLabel.font = kRegular(13);
        _descLabel.textColor = KTextGray_999;
        _descLabel.numberOfLines = 2;
    }
    return _descLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel){
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = kRegular(15);
        _priceLabel.textColor = kMainYellow;
    }
    return _priceLabel;
}

- (UIView *)timeView{
    if (!_timeView){
        _timeView = [[UIView alloc] init];
        _timeView.backgroundColor = RGBA(238, 238, 243, 1);
        _timeView.layer.cornerRadius = 4;
        _timeView.clipsToBounds = YES;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"history_time"];
        
        [_timeView addSubview:self.timeLabel];
        [_timeView addSubview: imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_timeView);
            make.left.mas_equalTo(SLChange(5));
            make.size.mas_equalTo(CGSizeMake(SLChange(10), SLChange(10)));
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).mas_offset(SLChange(5));
            make.centerY.mas_equalTo(imageView);
            make.right.mas_equalTo(-SLChange(5));
        }];
    }
    return _timeView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = kRegular(10);
        _timeLabel.textColor = KTextGray_999;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UIButton *)priseBtn {
    if (!_priseBtn) {
        _priseBtn = [[UIButton alloc]init];
        [_priseBtn setImage:[UIImage imageNamed:@"focus_normal"] forState:UIControlStateNormal];
        [_priseBtn setImage:[UIImage imageNamed:@"focus_select_yellow"] forState:UIControlStateSelected];
        [_priseBtn addTarget:self action:@selector(priseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priseBtn;
}

@end
