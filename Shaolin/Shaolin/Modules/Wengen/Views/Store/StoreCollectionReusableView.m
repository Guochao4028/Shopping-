//
//  StoreCollectionReusableView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreCollectionReusableView.h"

#import "StoreMenuView.h"

@interface StoreCollectionReusableView ()

@property(nonatomic, strong)StoreMenuView *menuView;

//记录下次选价格是升序还是降序 1，升序，2，降序
@property(nonatomic, assign)NSInteger recordJiaGe;

@end

@implementation StoreCollectionReusableView

- (id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        self.recordJiaGe = 1;
        
        [self initUI];
    }
    return self;
    
}

- (void)initUI{
    
    [self addSubview:self.menuView];
}


#pragma mark - action
- (void)tuijian{
    NSLog(@"%s", __func__);
    [self.menuView.tuijianButton setTitleColor:kMainYellow forState:UIControlStateNormal];
    
    [self.menuView.xiaoliangButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    [self.menuView.qiehuanButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    [self.menuView.zhijianButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    [self.menuView.jiageLabel setTextColor:KTextGray_333];
    
    [self.menuView.jiageImageView setImage:[UIImage imageNamed:@"normal"]];
    self.recordJiaGe = 1;
    
    if ([self.delegagte respondsToSelector:@selector(collectionReusableView:tapAction:)] == YES) {
        [self.delegagte collectionReusableView:self tapAction:StoreListSortingTuiJianType];
    }
}

- (void)xiaoliang{
    NSLog(@"%s", __func__);
    [self.menuView.tuijianButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    [self.menuView.xiaoliangButton setTitleColor:kMainYellow forState:UIControlStateNormal];
    
    [self.menuView.qiehuanButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    [self.menuView.zhijianButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    [self.menuView.jiageLabel setTextColor:KTextGray_333];
    
    [self.menuView.jiageImageView setImage:[UIImage imageNamed:@"normal"]];
    self.recordJiaGe = 1;
    
    if ([self.delegagte respondsToSelector:@selector(collectionReusableView:tapAction:)] == YES) {
        [self.delegagte collectionReusableView:self tapAction:StoreListSortingXiaoLiangType];
    }
}

- (void)jiage{
    NSLog(@"%s", __func__);
    [self.menuView.tuijianButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    [self.menuView.xiaoliangButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    [self.menuView.qiehuanButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    [self.menuView.zhijianButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    [self.menuView.jiageLabel setTextColor:kMainYellow];
    
    if (self.recordJiaGe == 1) {
        [self.menuView.jiageImageView setImage:[UIImage imageNamed:@"ascending"]];
        self.recordJiaGe = 2;
        
        if ([self.delegagte respondsToSelector:@selector(collectionReusableView:tapAction:)] == YES) {
            [self.delegagte collectionReusableView:self tapAction:StoreListSortingJiaGeAscType];
        }
    }else{
        [self.menuView.jiageImageView setImage:[UIImage imageNamed:@"descending"]];
        self.recordJiaGe = 1;
        
        if ([self.delegagte respondsToSelector:@selector(collectionReusableView:tapAction:)] == YES) {
            [self.delegagte collectionReusableView:self tapAction:StoreListSortingJiaGeDescType];
        }
    }
    
    
}

- (void)zhijian{
    NSLog(@"%s", __func__);
    [self.menuView.tuijianButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    [self.menuView.xiaoliangButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    [self.menuView.qiehuanButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    [self.menuView.zhijianButton setTitleColor:kMainYellow forState:UIControlStateNormal];
    
    [self.menuView.jiageLabel setTextColor:KTextGray_333];
    
    [self.menuView.jiageImageView setImage:[UIImage imageNamed:@"normal"]];
    self.recordJiaGe = 1;
    
    if ([self.delegagte respondsToSelector:@selector(collectionReusableView:tapAction:)] == YES) {
        [self.delegagte collectionReusableView:self tapAction:StoreListSortingOnlyHaveType];
    }
}

- (void)qiehuan{
    [self.menuView.qiehuanButton setSelected:!self.menuView.qiehuanButton.isSelected];
    
    if ([self.delegagte respondsToSelector:@selector(collectionReusableView:tapGrid:)] == YES) {
        [self.delegagte collectionReusableView:self tapGrid:self.menuView.qiehuanButton.isSelected];
    }
    
}

#pragma mark - getter

- (StoreMenuView *)menuView{
    
    if (_menuView == nil) {
        _menuView = [[StoreMenuView alloc]initWithFrame:self.bounds];
        [_menuView tuijianTarget:self action:@selector(tuijian)];
        [_menuView xiaoliangTarget:self action:@selector(xiaoliang)];
        [_menuView jiageTarget:self action:@selector(jiage)];
        [_menuView zhijianTarget:self action:@selector(zhijian)];
        [_menuView qiehuanTarget:self action:@selector(qiehuan)];
    }
    
    return _menuView;
}

- (void)setIsHasDefault:(BOOL)isHasDefault{
    
    _isHasDefault = isHasDefault;
    
    if (isHasDefault == YES) {
        [self.menuView.tuijianButton setTitleColor:kMainYellow forState:UIControlStateNormal];
        
        [self.menuView.xiaoliangButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        
        [self.menuView.qiehuanButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        
        [self.menuView.zhijianButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        
        [self.menuView.jiageLabel setTextColor:KTextGray_333];
        
        [self.menuView.jiageImageView setImage:[UIImage imageNamed:@"normal"]];
        self.recordJiaGe = 1;
    }
    
}



@end
