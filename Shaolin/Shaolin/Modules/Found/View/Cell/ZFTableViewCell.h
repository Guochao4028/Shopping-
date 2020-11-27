//
//  ZFTableViewCell.h
//  ZFPlayer
//
//  Created by 紫枫 on 2018/4/3.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFTableData.h"
#import "ZFTableViewCellLayout.h"

@class ZFTableViewCell;

@protocol ZFTableViewCellDelegate <NSObject>

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath;
- (void)prasieActionButton:(ZFTableViewCell *)cell IndexPath:(NSInteger)indexPath IndexPathRow:(NSIndexPath *)row;//点赞
- (void)foucsActionButton:(ZFTableViewCell *)cell IndexPath:(NSInteger)indexPath IndexPathRow:(NSIndexPath *)row;//f收藏
- (void)shareActionButton:(ZFTableViewCell *)cell IndexPath:(NSInteger)indexPath IndexPathRow:(NSIndexPath *)row;//分享
@end

@interface ZFTableViewCell : UITableViewCell

@property (nonatomic, strong) ZFTableViewCellLayout *layout;

@property (nonatomic, copy) void(^playCallback)(void);
@property(nonatomic,strong) UIButton *praiseBtn; //点赞
@property(nonatomic,strong) UIButton *shareBnt;//分享
@property (nonatomic,strong) UIButton *collectionBtn;//收藏
@property (nonatomic, strong) UILabel *praiseLabel;
@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) UILabel *collectionLabel;

@property (nonatomic, strong) UILabel *abstractsLabel;//摘要
- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath;

- (void)showMaskView;

- (void)hideMaskView;

- (void)setNormalMode;

- (void)setPraiseBtnSelected:(BOOL)selected;
- (void)setShareBtnSelected:(BOOL)selected;
- (void)setCollectionBtnSelected:(BOOL)selected;


- (UIImage *)getShowImage;
@end
