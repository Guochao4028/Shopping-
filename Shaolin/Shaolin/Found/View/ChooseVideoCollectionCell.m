//
//  ChooseVideoCollectionCell.m
//  Shaolin
//
//  Created by edz on 2020/3/16.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ChooseVideoCollectionCell.h"
#import <TZImageManager.h>

@implementation ChooseVideoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self.contentView addSubview:self.imageV];
    [self.imageV addSubview:self.timeLabel];
    [self.contentView addSubview:self.selectView];
    [self.contentView addSubview:self.localIcon];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo((kWidth-3)/4);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(40));
        make.height.mas_equalTo(SLChange(15));
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo((kWidth-3)/4);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    [self.localIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}


#pragma mark - set
-(void)setAssetModel:(SLAssetModel *)assetModel {
    _assetModel = assetModel;
    
    self.timeLabel.text = assetModel.tzAssetModel.timeLength;
    
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
    option.networkAccessAllowed = NO;
    
   [[PHCachingImageManager defaultManager] requestAVAssetForVideo:assetModel.tzAssetModel.asset options:option resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
       
       self->_assetModel.isICloudAsset = [[info objectForKey: PHImageResultIsInCloudKey] boolValue];
   }];
    
    [[TZImageManager manager] getPhotoWithAsset:assetModel.tzAssetModel.asset photoWidth:self.width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        
        self->_imageV.image = photo;
        self->_assetModel.videoImage = photo;
    } progressHandler:nil networkAccessAllowed:YES];
}


#pragma mark - get

-(UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.clipsToBounds = YES;
    }
    return _imageV;
}

-(UIImageView *)localIcon
{
    if (!_localIcon) {
        _localIcon = [[UIImageView alloc]init];
        _localIcon.hidden = YES;
        _localIcon.image = [UIImage imageNamed:@"upload_icon"];
    }
    return _localIcon;
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = kRegular(11);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
    }
    return _timeLabel;
}

-(UIView *)selectView
{
    if (!_selectView) {
        _selectView = [[UIView alloc]init];
        _selectView.layer.borderColor = [UIColor whiteColor].CGColor;
        _selectView.layer.borderWidth = 2;
        _selectView.backgroundColor = [UIColor clearColor];
    }
    return _selectView;
}
@end
