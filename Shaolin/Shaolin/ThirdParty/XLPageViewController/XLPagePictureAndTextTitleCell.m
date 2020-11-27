//
//  XLPagePictureAndTextTitleCell.m
//  Shaolin
//
//  Created by 王精明 on 2020/11/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "XLPagePictureAndTextTitleCell.h"
#import "FieldModel.h"

static CGSize const PictureViewSize = {46, 46};
static CGFloat const TextLabelHeight = 21;
static CGFloat const TextLabelTopGap = 13;

static CGFloat const TextLabelBottomGap = 18;

@interface XLPagePictureAndTextTitleCell()
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel *topLabel;
@end


@implementation XLPagePictureAndTextTitleCell

+ (CGSize)cellSize {
    return CGSizeMake(92, 92);
}

+ (CGFloat)pictureViewHeight{
    return PictureViewSize.height + TextLabelTopGap/2;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setModel:(FieldModel *)model{
    _model = model;
    self.textLabel.text = model.name;
    [self reloadPictureView:NO];
}

- (void)setUI{
    [self.contentView addSubview:self.topLabel];
    [self.contentView addSubview:self.pictureView];
    
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(PictureViewSize);
    }];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.pictureView);
    }];
//    self.topLabel.layer.cornerRadius = PictureViewSize.width/2.0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(0, PictureViewSize.height + TextLabelTopGap, self.contentView.width, TextLabelHeight);
}

- (void)configCellOfSelected:(BOOL)selected {
    [super configCellOfSelected:selected];
//    self.topLabel.backgroundColor = selected ? self.config.titleSelectedColor : KTextGray_EEE;
//    self.topLabel.textColor = selected ? [UIColor whiteColor] : self.config.titleSelectedColor;
    [self reloadPictureView:selected];
}

- (void)reloadPictureView:(BOOL)isSelected{
//    if (self.model.showImg.length > 0) {
    if (isSelected){
        [self setPictureViewImage:self.model.checkedImg placeholderImage:@"default_select"];
    } else {
        [self setPictureViewImage:self.model.showImg placeholderImage:@"default_normal"];
    }
//    }
//    else {
//        if (self.model.name.length > 2) {
//            self.topLabel.text = [self.model.name substringWithRange:NSMakeRange(2, 1)];
//        } else if (self.model.name.length == 2){
//            self.topLabel.text = [self.model.name substringWithRange:NSMakeRange(1, 1)];
//        } else {
//            self.topLabel.text = self.model.name;
//        }
//    }
}

- (void)setPictureViewImage:(NSString *)imageString placeholderImage:(NSString *)placeholderImage{
    if (placeholderImage.length == 0) placeholderImage = @"default_small";
    if ([imageString hasPrefix:@"http"]){
        [self.pictureView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:placeholderImage]];
    } else {
        self.pictureView.image = [UIImage imageNamed:imageString];
    }
}
#pragma mark -
- (UIImageView *)pictureView{
    if (!_pictureView){
        _pictureView = [[UIImageView alloc] init];
        _pictureView.clipsToBounds = YES;
        _pictureView.backgroundColor = [UIColor clearColor];
        _pictureView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pictureView;
}

- (UILabel *)topLabel{
    if (!_topLabel){
        _topLabel = [[UILabel alloc] init];
        _topLabel.clipsToBounds = YES;
        _topLabel.backgroundColor = [UIColor clearColor];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _topLabel;
}
@end
