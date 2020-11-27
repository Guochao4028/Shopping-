//
//  GoodsVideoView.m
//  Shaolin
//
//  Created by 郭超 on 2020/11/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsVideoView.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"


@interface GoodsVideoView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *carousel;

@property(nonatomic, strong)UILabel *pageLabel;

@property (strong, nonatomic) UIImageView *videoCoverImageView;// 视频封面
@property (strong, nonatomic) UIButton *playButton;// 播放按钮
@property (strong, nonatomic) ZFPlayerController *player;
@property (strong, nonatomic) ZFPlayerControlView *controlView;

@property(nonatomic, assign)CGFloat viewWidth;
@property(nonatomic, assign)CGFloat viewHeigth;


@end

@implementation GoodsVideoView

-(instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    [self addSubview:self.carousel];
    
}

#pragma mark - action
- (void)playClick:(UIButton *)button {
    
    [self.controlView resetControlView];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.videoCoverImageView];
    self.player.controlView = self.controlView;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self endEditing:YES];
//        [self setNeedsStatusBarAppearanceUpdate];
    };
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player enterFullScreen:NO animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.player.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.player stop];
        });
    };
    NSString *URLString = [self.videoUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSString *proxyURLString = [KTVHTTPCache proxyURLStringWithOriginalURLString:URLString];
    playerManager.assetURL = [NSURL URLWithString:URLString];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat x = scrollView.contentOffset.x;
    NSInteger currentPage = x / self.viewWidth;
    if ([self.delegate respondsToSelector:@selector(carousel:didScrollToIndex:)]) {
        [self.delegate carousel:self didScrollToIndex:currentPage];
    }
    
    if (self.player != nil){
        
        if (self.player.currentPlayerManager.playState == ZFPlayerPlayStatePaused) {
            if (currentPage == 0) {
                [self.player.currentPlayerManager play];
            }
        }else {
            
            [self.player.currentPlayerManager pause];
        }
    }
}

#pragma mark - setter / getter

- (UIScrollView *)carousel {
    
    if (_carousel == nil) {
        
        _carousel = [[UIScrollView alloc] init];
        _carousel.backgroundColor = [UIColor clearColor];
        
        _carousel.delegate = self;
        
        _carousel.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeigth);
        
        _carousel.contentOffset = CGPointMake(0, 0);
        _carousel.pagingEnabled  = YES;
        _carousel.showsVerticalScrollIndicator = NO;
        _carousel.showsHorizontalScrollIndicator = NO;
    }
    
    return _carousel;
}

-(CGFloat)viewWidth{
    return CGRectGetWidth(self.bounds);
}

-(CGFloat)viewHeigth{
    return CGRectGetHeight(self.bounds);
}

- (UIImageView *)videoCoverImageView {
    
    if (_videoCoverImageView == nil) {
        
        _videoCoverImageView = [[UIImageView alloc] init];
        _videoCoverImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _videoCoverImageView.backgroundColor = [UIColor blackColor];
        
        _videoCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _videoCoverImageView.layer.masksToBounds = YES;
        _videoCoverImageView.userInteractionEnabled = YES;
    }
    
    return _videoCoverImageView;
}

- (UIButton *)playButton {
    
    if (_playButton == nil) {
        
        _playButton = [[UIButton alloc] init];
        _playButton.frame = CGRectMake(0, 0, 60, 60);
        _playButton.center = self.videoCoverImageView.center;
        _playButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    self.carousel.contentSize = CGSizeMake(dataArray.count * self.viewWidth, self.viewHeigth);
    
    for (int i = 0; i < dataArray.count; i ++) {
        
        if (i == 0) {
            
            [self.videoCoverImageView sd_setImageWithURL:dataArray[0]];// 取第一张图作为视频配图
            [self.videoCoverImageView addSubview:self.playButton];
            [self.carousel addSubview:self.videoCoverImageView];
        }else {
            if ([self.carousel viewWithTag:8888+i]) {
                UIView *imageView = [self.carousel viewWithTag:8888+i];
                [imageView removeFromSuperview];
            }else{
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                [imageView sd_setImageWithURL:dataArray[i] placeholderImage:[UIImage imageNamed:@"default_banner"]];
                imageView.layer.masksToBounds = YES;
                [imageView setTag:8888 +i];
                [self.carousel addSubview:imageView];
            }
        }
    }
}

- (ZFPlayerControlView *)controlView {
    
    if (_controlView == nil) {
        
        _controlView = [ZFPlayerControlView new];
        [_controlView showTitle:@"商品详情" coverURLString:self.dataArray[0] fullScreenMode:ZFFullScreenModePortrait];
        _controlView.customDisablePanMovingDirection = YES;
    }
    
    return _controlView;
}


@end
