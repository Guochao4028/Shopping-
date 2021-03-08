//
//  ZFTableViewCell.m
//  ZFPlayer
//
//  Created by 紫枫 on 2018/4/3.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFTableViewCell.h"
#import "UIImageView+ZFCache.h"
#import "DefinedURLs.h"

//#define ZFTableViewCell_ColorTest

@interface ZFTableViewCell ()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *fullMaskView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIImageView *praiseImageView;
@property (nonatomic, strong) UIImageView *shareImageView;
@property (nonatomic, strong) UIImageView *collectionImageView;
@property (nonatomic, weak) id<ZFTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIView *effectView;

@end

@implementation ZFTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bgImgView];
        [self.bgImgView addSubview:self.effectView];
        [self.contentView addSubview:self.coverImageView];
        [self.coverImageView addSubview:self.playBtn];
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nickNameLabel];
        
        [self.contentView addSubview:self.praiseBtn];
        [self.contentView addSubview:self.shareBnt];
        [self.contentView addSubview:self.collectionBtn];
        
        [self.praiseBtn addSubview:self.praiseImageView];
        [self.praiseBtn addSubview:self.praiseLabel];
        
        [self.shareBnt addSubview:self.shareImageView];
        [self.shareBnt addSubview:self.shareLabel];
        
        [self.collectionBtn addSubview:self.collectionImageView];
        [self.collectionBtn addSubview:self.collectionLabel];
        
        [self.contentView addSubview:self.abstractsLabel];
        [self.contentView addSubview:self.fullMaskView];

        self.contentView.backgroundColor =  [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        

    }
    return self;
}

- (void)setLayout:(ZFTableViewCellLayout *)layout {
    _layout = layout;
    self.headImageView.layer.cornerRadius = CGRectGetHeight(layout.headerRect)/2;
    
    self.nickNameLabel.frame = layout.nickNameRect;
    self.abstractsLabel.frame = layout.abstractsRect;
    self.coverImageView.frame = layout.videoRect;
    self.bgImgView.frame = layout.videoRect;
    self.effectView.frame = self.bgImgView.bounds;
    self.playBtn.frame = layout.playBtnRect;
    self.fullMaskView.frame = layout.maskViewRect;
    
    if (layout.data.praise && layout.data.praiseState && layout.data.collection && layout.data.collection){
        self.headImageView.frame = layout.headerRect;
        self.praiseBtn.frame = layout.praiseRect;
        self.shareBnt.frame = layout.shareRect;
        self.collectionBtn.frame = layout.collectionRect;
        
        self.praiseImageView.frame = CGRectMake((self.praiseBtn.width - 25)/2, 0, 25, 25);
        self.praiseLabel.frame = CGRectMake(0, self.praiseImageView.maxY + 5, self.praiseBtn.width, 18.5);
        
        self.shareImageView.frame = CGRectMake((self.shareBnt.width - 25)/2, 0, 25, 20);
        self.shareLabel.frame = CGRectMake(0, self.shareImageView.maxY + 5, self.shareBnt.width, 18.5);
        
        self.collectionImageView.frame = CGRectMake((self.collectionBtn.width - 25)/2, 0, 25, 25);
        self.collectionLabel.frame = CGRectMake(0, self.collectionImageView.maxY + 5, self.collectionBtn.width, 18.5);
    }
    [self.headImageView setImageWithURLString:layout.data.headUrl placeholder:[UIImage imageNamed:@"shaolinlogo"]];
    NSString *coverImageStr = [NSString stringWithFormat:@"%@%@",layout.data.coverUrl,Video_First_Photo];
    [self.coverImageView setImageWithURLString:coverImageStr placeholder:[UIImage imageNamed:@"loading_bgView"]];
    [self.bgImgView setImageWithURLString:coverImageStr placeholder:[UIImage imageNamed:@"loading_bgView"]];
    self.nickNameLabel.text = [NSString stringWithFormat:@"@%@", layout.data.author];
    self.abstractsLabel.text = layout.data.title;
    
    self.nickNameLabel.text = layout.data.author ? layout.data.author : @"";
    self.abstractsLabel.text = layout.data.title ? layout.data.title : @"";

    self.praiseLabel.text = layout.data.praise ? [NSString stringWithFormat:@"%@",layout.data.praise] : @"";
    self.collectionLabel.text = layout.data.collection ? [NSString stringWithFormat:@"%@",layout.data.collection] : @"";
    self.shareLabel.text = layout.data.forward ? [NSString stringWithFormat:@"%@",layout.data.forward] : @"";
    
    [self setCollectionBtnSelected:[layout.data.collectionState boolValue]];
    [self setPraiseBtnSelected:[layout.data.praiseState boolValue]];
    
    NSArray *restyleButtons = @[self.shareBnt, self.collectionBtn, self.praiseBtn];
    for (UIButton *button in restyleButtons){
        [self restyleButton:button];
    }
}

- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath {
    self.delegate = delegate;
    self.indexPath = indexPath;
}

- (void)setNormalMode {
    self.fullMaskView.hidden = YES;
    self.nickNameLabel.textColor = [UIColor blackColor];
    self.contentView.backgroundColor =  [UIColor blackColor];
}

- (void)setPraiseBtnSelected:(BOOL)selected {
    self.praiseBtn.selected = selected;
    if (selected){
        self.praiseImageView.image = [UIImage imageNamed:@"praise_select_yellow"];
    } else {
        self.praiseImageView.image = [UIImage imageNamed:@"video_praise_normal"];
    }
}

- (void)setShareBtnSelected:(BOOL)selected {
    self.shareBnt.selected = selected;
    if (selected){
        self.shareImageView.image = [UIImage imageNamed:@"shared_select_yellow"];
    } else {
        self.shareImageView.image = [UIImage imageNamed:@"video_share_normal"];
    }
}

- (void)setCollectionBtnSelected:(BOOL)selected {
    self.collectionBtn.selected = selected;
    if (selected){
        self.collectionImageView.image = [UIImage imageNamed:@"focus_select_yellow"];
    } else {
        self.collectionImageView.image = [UIImage imageNamed:@"video_focus_normal"];
    }
}

- (void)showMaskView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.fullMaskView.alpha = 0.8;
       
    }];
   
}

- (void)hideMaskView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.fullMaskView.alpha = 0;
       
    }];
}

- (void)restyleButton:(UIButton *)button{
    CGFloat spacing = 5;
    CGSize imageSize = button.imageView.frame.size;
    CGSize titleSize = button.titleLabel.frame.size;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:button.titleLabel.font forKey:NSFontAttributeName];
    CGSize textSize = [button.titleLabel.text sizeWithAttributes:attributes];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    
    CGFloat totalHeight = imageSize.height + titleSize.height;
    button.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height + spacing), 0.0, 0.0, - titleSize.width);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height + spacing), 0);
}

- (void)playBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_playTheVideoAtIndexPath:)]) {
        [self.delegate zf_playTheVideoAtIndexPath:self.indexPath];
    }
}

#pragma mark - getter

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIView *)fullMaskView {
    if (!_fullMaskView) {
        _fullMaskView = [UIView new];
        _fullMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _fullMaskView.userInteractionEnabled = NO;
        _fullMaskView.hidden = YES;
    }
    return _fullMaskView;
}


- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [UILabel new];
        _nickNameLabel.textColor = UIColor.whiteColor;
        _nickNameLabel.font = kMediumFont(16);
#ifdef ZFTableViewCell_ColorTest
        _nickNameLabel.backgroundColor = [UIColor greenColor];
#endif
    }
    return _nickNameLabel;
}

- (UILabel *)abstractsLabel{
    if (!_abstractsLabel) {
        _abstractsLabel = [UILabelLeftTopAlign new];
        _abstractsLabel.textColor = UIColor.whiteColor;
        _abstractsLabel.font = kRegular(15);
#ifdef ZFTableViewCell_ColorTest
        _abstractsLabel.backgroundColor = [UIColor redColor];
#endif
    }
    return _abstractsLabel;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.clipsToBounds = YES;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
#ifdef ZFTableViewCell_ColorTest
        _headImageView.backgroundColor = [UIColor blueColor];
#endif
    }
    return _headImageView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
//        _coverImageView.backgroundColor = [UIColor blackColor];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.userInteractionEnabled = YES;
//        _bgImgView.backgroundColor = [UIColor blackColor];
    }
    return _bgImgView;
}

- (UIView *)effectView {
    if (!_effectView) {
        if (@available(iOS 8.0, *)) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        } else {
            UIToolbar *effectView = [[UIToolbar alloc] init];
            effectView.barStyle = UIBarStyleBlackTranslucent;
            _effectView = effectView;
        }
        _effectView.backgroundColor = [UIColor blackColor];
    }
    return _effectView;
}
- (UIButton *)praiseBtn
{
    if (!_praiseBtn) {
        _praiseBtn  =[[ UIButton alloc]init];
       
//        [_praiseBtn setImage:[UIImage imageNamed:@"video_praise_normal"] forState:(UIControlStateNormal)];
//        [_praiseBtn setImage:[UIImage imageNamed:@"praise_select_yellow"] forState:(UIControlStateSelected)];
//        _praiseBtn.titleLabel.font = kRegular(13);
//        [_praiseBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _praiseBtn;
}
- (UIButton *)collectionBtn
{
    if (!_collectionBtn) {
        _collectionBtn  =[[ UIButton alloc]init];
//        [_collectionBtn setTitle:@" 10" forState:(UIControlStateNormal)];
//        [_collectionBtn setImage:[UIImage imageNamed:@"video_focus_normal"] forState:(UIControlStateNormal)];
//        [_collectionBtn setImage:[UIImage imageNamed:@"focus_select_yellow"] forState:(UIControlStateSelected)];
//        _collectionBtn.titleLabel.font = kRegular(13);
//        [_collectionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_collectionBtn addTarget:self action:@selector(collectionAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _collectionBtn;
}
- (void)collectionAction:(UIButton *)button
{
    UITableView *table = (UITableView *)self.superview;
    NSInteger numOfSelectedCell = [table indexPathForCell:self].row;
   
    [self.delegate foucsActionButton:self IndexPath:numOfSelectedCell IndexPathRow:self.indexPath];
}
- (void)praiseAction:(UIButton *)button
{
    
   
       UITableView *table = (UITableView *)self.superview;
        NSInteger numOfSelectedCell = [table indexPathForCell:self].row;
        [self.delegate prasieActionButton:self IndexPath:numOfSelectedCell IndexPathRow:self.indexPath];
    
}
- (void)shareAction:(UIButton *)button
{
     UITableView *table = (UITableView *)self.superview;
          NSInteger numOfSelectedCell = [table indexPathForCell:self].row;
        [self.delegate shareActionButton:self IndexPath:numOfSelectedCell IndexPathRow:self.indexPath];
    
    
}
- (UIButton *)shareBnt
{
    if (!_shareBnt) {
        _shareBnt  =[[ UIButton alloc]init];
//        [_shareBnt setTitle:@" 1" forState:(UIControlStateNormal)];
//        [_shareBnt setImage:[UIImage imageNamed:@"video_share_normal"] forState:(UIControlStateNormal)];
//        _shareBnt.titleLabel.font = kRegular(13);
//        [_shareBnt setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        [_shareBnt addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _shareBnt;
}

- (UIImage *)getShowImage{
    return self.coverImageView.image;
}


- (UIImageView *)praiseImageView{
    if (!_praiseImageView){
        _praiseImageView = [[UIImageView alloc] init];
        _praiseImageView.image = [UIImage imageNamed:@"video_praise_normal"];
        _praiseImageView.contentMode = UIViewContentModeScaleAspectFit;
        _praiseImageView.clipsToBounds = YES;
    }
    return _praiseImageView;
}

- (UIImageView *)shareImageView{
    if (!_shareImageView){
        _shareImageView = [[UIImageView alloc] init];
        _shareImageView.image = [UIImage imageNamed:@"video_share_normal"];
        _shareImageView.contentMode = UIViewContentModeScaleAspectFit;
        _shareImageView.clipsToBounds = YES;
    }
    return _shareImageView;
}

- (UIImageView *)collectionImageView{
    if (!_collectionImageView){
        _collectionImageView = [[UIImageView alloc] init];
        _collectionImageView.image = [UIImage imageNamed:@"video_focus_normal"];
        _collectionImageView.contentMode = UIViewContentModeScaleAspectFit;
        _collectionImageView.clipsToBounds = YES;
    }
    return _collectionImageView;
}

- (UILabel *)praiseLabel{
    if (!_praiseLabel){
        _praiseLabel = [[UILabel alloc] init];
        _praiseLabel.font = kRegular(13);
        _praiseLabel.textColor = UIColor.whiteColor;
        _praiseLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _praiseLabel;
}

- (UILabel *)shareLabel{
    if (!_shareLabel){
        _shareLabel = [[UILabel alloc] init];
        _shareLabel.font = kRegular(13);
        _shareLabel.textColor = UIColor.whiteColor;
        _shareLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _shareLabel;
}

- (UILabel *)collectionLabel{
    if (!_collectionLabel){
        _collectionLabel = [[UILabel alloc] init];
        _collectionLabel.font = kRegular(13);
        _collectionLabel.textColor = UIColor.whiteColor;
        _collectionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _collectionLabel;
}




@end
