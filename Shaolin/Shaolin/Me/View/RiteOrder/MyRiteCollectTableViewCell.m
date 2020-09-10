//
//  MyRiteCollectTableViewCell.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/31.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MyRiteCollectTableViewCell.h"
#import "MyRiteCollectModel.h"
#import "UIButton+Block.h"

@interface MyRiteCollectTableViewCell()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIView *titleBackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIButton *collectButton;
@end

@implementation MyRiteCollectTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.titleBackView];
    [self.titleBackView addSubview:self.titleLabel];
    [self.titleBackView addSubview:self.descriptionLabel];
    
    [self.contentView addSubview:self.collectButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(151, 92));
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.titleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageV.mas_right).mas_equalTo(16);
        make.right.mas_equalTo(self.collectButton.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(self.imageV);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(self.titleBackView);
    }];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(5);
        make.left.width.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.imageV);
        make.right.mas_equalTo(-9);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

- (void)setModel:(MyRiteCollectModel *)model{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"default_big"]];
    self.titleLabel.text = model.name;
    self.descriptionLabel.text = model.introduction;
    self.collectButton.selected = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)imageV{
    if (!_imageV){
        _imageV = [[UIImageView alloc] init];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.layer.cornerRadius = 0;
        _imageV.clipsToBounds = YES;
    }
    return _imageV;
}

- (UIView *)titleBackView{
    if (!_titleBackView){
        _titleBackView = [[UIView alloc] init];
    }
    return _titleBackView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorForHex:@"333333"];
        _titleLabel.font = kRegular(14);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel{
    if (!_descriptionLabel){
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textColor = [UIColor colorForHex:@"999999"];
        _descriptionLabel.font = kRegular(12);
        _descriptionLabel.numberOfLines = 2;
    }
    return _descriptionLabel;
}

- (UIButton *)collectButton{
    if (!_collectButton){
        _collectButton = [[UIButton alloc] init];
        [_collectButton setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"shoucang2"] forState:UIControlStateSelected];
        
        WEAKSELF
        [_collectButton handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
            button.selected = !button.selected;
            if (weakSelf.collectButtonClickBlock) weakSelf.collectButtonClickBlock(button.isSelected);
        }];
    }
    return _collectButton;
}

@end
