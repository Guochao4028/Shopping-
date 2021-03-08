//
//  BillingDetailsPopupView.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "BillingDetailsPopupView.h"
#import "UIView+AutoLayout.h"
#import "GCPickTimeView.h"
#import "MutableCopyCatetory.h"
#import "PopupChooseClassificationCollectionCell.h"

@interface BillingDetailsPopupView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UIView *contentView;

@property (nonatomic, strong)UIView *titleView;

@property (nonatomic, strong)UIButton *determineButton;

@property (nonatomic, strong)UIButton *closeButton;

@property (nonatomic, strong)UILabel *titleLable;
//分类展示
@property (nonatomic, strong)UICollectionView *collectionView;
//时间选择器
@property (nonatomic, strong)GCPickTimeView *pickTimeView;
//分类数据
@property (nonatomic, strong)NSArray *dataArray;


@end

@implementation BillingDetailsPopupView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initUI];
        [self initData];
    }
    return self;
}

#pragma mark - methods

- (void)initData{
    self.dataArray = @[
    @{@"title":SLLocalizedString(@"全部"), @"isSelected":@"1"},
    @{@"title":SLLocalizedString(@"商品"), @"isSelected":@"0"},
    @{@"title":SLLocalizedString(@"教程"), @"isSelected":@"0"},
    @{@"title":SLLocalizedString(@"活动报名"), @"isSelected":@"0"},
    @{@"title":SLLocalizedString(@"退款"), @"isSelected":@"0"},
//    @{@"title":SLLocalizedString(@"充值"), @"isSelected":@"0"},
    @{@"title":SLLocalizedString(@"功德佛事"), @"isSelected":@"0"},
    
    ];
    
    self.dataArray = [self.dataArray mutableArrayDeeoCopy];
}

/// 初始化UI
- (void)initUI{
    
    [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleView];
    
    [self.titleView addSubview:self.closeButton];
    [self.titleView addSubview:self.titleLable];
    
    
    [self.contentView addSubview:self.determineButton];
    
    [self p_Autolayout];
    
}

- (void)disappear{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)determineButtonClick:(UIButton *)button{
    NSString *string = @"";
    if (self.popType == PopupViewChooseTimeType){
        string = [self.pickTimeView getTimeString];
    } else {
        for (NSDictionary *dict in self.dataArray){
            NSString *isSelected = [dict objectForKey:@"isSelected"];
            if ([isSelected isEqualToString:@"1"]){
                string = [dict objectForKey:@"title"];
            }
        }
    }
    if (self.billingDetailsSelectStrBlick){
        if ([string isEqualToString:SLLocalizedString(@"全部")]) {
            string = @"";
        }
        self.billingDetailsSelectStrBlick(string);
    }
    [self disappear];
}

#pragma mark -  private

- (void)p_Autolayout{
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kBottomSafeHeight];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.contentView autoSetDimension:ALDimensionHeight toSize:335];
    
    self.contentView.layer.masksToBounds = YES;
    [self.contentView.layer setCornerRadius:12];
    
    [self.titleView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.titleView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.titleView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.titleView autoSetDimension:ALDimensionHeight toSize:56];
    
    [self.closeButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.closeButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.closeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.closeButton autoSetDimension:ALDimensionWidth toSize:56];
    
    [self.titleLable autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.titleLable autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [self.determineButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.determineButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.determineButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.determineButton autoSetDimension:ALDimensionHeight toSize:50];
}



#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   PopupChooseClassificationCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PopupChooseClassificationCollectionCell" forIndexPath:indexPath];
          
    [cell setModel:self.dataArray[indexPath.row]];
          
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    for (NSMutableDictionary *dic in self.dataArray) {
        [dic setValue:@"0" forKey:@"isSelected"];
    }
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    [dic setValue:@"1" forKey:@"isSelected"];
    [self.collectionView reloadData];
    
}

#pragma mark - getter / setter
- (void)setSelectStr:(NSString *)selectStr{
    if (self.popType == PopupViewChooseTimeType){
        [self.pickTimeView setCurrentTimeString:selectStr];
    } else {
        for (NSMutableDictionary *dic in self.dataArray) {
            [dic setValue:@"0" forKey:@"isSelected"];
            NSString *title = [dic objectForKey:@"title"];
            if ([title isEqualToString:selectStr] || ([title isEqualToString:SLLocalizedString(@"全部")] && selectStr.length == 0)){
                [dic setValue:@"1" forKey:@"isSelected"];
            }
        }
        [self.collectionView reloadData];
    }
}

- (UIView *)contentView{
    
    if (_contentView == nil) {
        _contentView = [UIView newAutoLayoutView];
         [_contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return _contentView;

}

- (UIView *)titleView{
    
    if (_titleView == nil) {
        _titleView = [UIView newAutoLayoutView];
        [_titleView setBackgroundColor:[UIColor whiteColor]];
        
    }
    return _titleView;

}

- (UIButton *)determineButton{
    
    if (_determineButton == nil) {
        _determineButton = [UIButton newAutoLayoutView];
        
        [_determineButton setBackgroundColor:kMainYellow];
        
        [_determineButton setTitle:SLLocalizedString(@"确定") forState:UIControlStateNormal];
        [_determineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_determineButton.titleLabel setFont:kRegular(16)];
        [_determineButton addTarget:self action:@selector(determineButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determineButton;

}


- (UIButton *)closeButton{
    
    if (_closeButton == nil) {
        _closeButton = [UIButton newAutoLayoutView];
        [_closeButton setImage:[UIImage imageNamed:@"goodsClose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(disappear) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UILabel *)titleLable{
    
    if (_titleLable == nil) {
        _titleLable = [UILabel newAutoLayoutView];
        [_titleLable setFont:kRegular(17)];
        [_titleLable setTextColor:KTextGray_12];
    }
    return _titleLable;
}

- (GCPickTimeView *)pickTimeView{
    
    if (_pickTimeView == nil) {
        _pickTimeView = [[GCPickTimeView alloc]initForAutoLayout];
    }
    return _pickTimeView;
}

- (UICollectionView *)collectionView{
    
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 12;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        CGFloat width = (ScreenWidth - (36 + 24)) / 3;
        flowLayout.itemSize = CGSizeMake(width, 60);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PopupChooseClassificationCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:@"PopupChooseClassificationCollectionCell"];
    }
    return _collectionView;

}


- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self.titleLable setText:titleStr];
}

- (void)setPopType:(PopupViewType)popType{
    _popType = popType;
    switch (popType) {
        case PopupViewChooseTimeType:{
            [self.contentView addSubview:self.pickTimeView];
            [self.pickTimeView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleView];
            [self.pickTimeView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
            [self.pickTimeView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
            [self.pickTimeView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.determineButton];
        }
            break;
        case PopupViewChooseClassificationType:{
            [self.contentView addSubview:self.collectionView];
            [self.collectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleView];
            [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:18];
            [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:18];
            [self.collectionView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.determineButton];
            
        }
            break;
        default:
            break;
    }
}


@end
