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

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setModel:(FieldModel *)model{
    _model = model;
    self.textLabel.text = model.name;
    
    if (model.image.length > 0) {
        self.pictureView.image = [UIImage imageNamed:model.image];
    } else {
        if (model.name.length > 2) {
            self.topLabel.text = [model.name substringWithRange:NSMakeRange(2, 1)];
        } else if (model.name.length == 2){
            self.topLabel.text = [model.name substringWithRange:NSMakeRange(1, 1)];
        } else {
            self.topLabel.text = model.name;
        }
    }
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
    
    self.topLabel.layer.cornerRadius = PictureViewSize.width/2.0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(0, PictureViewSize.height + TextLabelTopGap, self.contentView.width, TextLabelHeight);
}

- (void)configCellOfSelected:(BOOL)selected {
    [super configCellOfSelected:selected];
    self.topLabel.backgroundColor = selected ? self.config.titleSelectedColor : [UIColor colorForHex:@"EEEEEE"];
    self.topLabel.textColor = selected ? [UIColor whiteColor] : self.config.titleSelectedColor;
}
#pragma mark -
- (UIImageView *)pictureView{
    if (!_pictureView){
        _pictureView = [[UIImageView alloc] init];
        _pictureView.clipsToBounds = YES;
        _pictureView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pictureView;
}

- (UILabel *)topLabel{
    if (!_topLabel){
        _topLabel = [[UILabel alloc] init];
        _topLabel.clipsToBounds = YES;
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _topLabel;
}
@end
