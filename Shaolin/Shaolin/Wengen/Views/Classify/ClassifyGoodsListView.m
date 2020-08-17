//
//  ClassifyGoodsListView.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 分类商品列表

#import "ClassifyGoodsListView.h"

#import "ClassifyGoodsCollectionCell.h"

static NSString *const kClassifyGoodsCollectionCellIdentifier = @"ClassifyGoodsCollectionCell";


@interface ClassifyGoodsListView ()<UICollectionViewDelegate, UICollectionViewDataSource>

//@property(nonatomic, strong)UICollectionView *collectionView;

@property(nonatomic, strong)UIView *notGoodsView;

@end

@implementation ClassifyGoodsListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initUI];
    }
    return self;
}

#pragma mark - methods
-(void)initUI{
    [self addSubview:self.collectionView];
    [self addSubview:self.notGoodsView];
    [self.notGoodsView setHidden:YES];
    
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ClassifyGoodsCollectionCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kClassifyGoodsCollectionCellIdentifier forIndexPath:indexPath];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WengenGoodsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(tapGoodsItem:)] == YES) {
        [self.delegate tapGoodsItem:model];
    }
    
}


#pragma mark - setter / gettter
-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        CGFloat collectionWidth = CGRectGetWidth(self.bounds);
        
       UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 12;
        layout.minimumInteritemSpacing = 0;
        CGFloat width = (collectionWidth - 32 - 12)/2;
        CGFloat higth = 273;
        layout.itemSize = CGSizeMake(width, higth);
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassifyGoodsCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:kClassifyGoodsCollectionCellIdentifier];
        
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //刷新
            if ([self.delegate respondsToSelector:@selector(refresh:)] == YES) {
                [self.delegate refresh:self.collectionView];
            }
        }];
        self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            // 上拉加载
//            [self loadNowMoreAction:self.searchStr];
            if ([self.delegate respondsToSelector:@selector(loadData:)] == YES) {
                [self.delegate loadData:self.collectionView];
            }
        }];
        
        
    }
    return _collectionView;
}

-(UIView *)notGoodsView{
    
    if (_notGoodsView == nil) {
        _notGoodsView = [[UIView alloc]initWithFrame:self.bounds];
        [_notGoodsView setBackgroundColor:[UIColor whiteColor]];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth - 184)/2, (110), 184, 110)];
        [_notGoodsView addSubview:view];
        
        UIImage *imageData;
        NSString *strName;
        if (self.isCategorize == YES) {
            imageData = [UIImage imageNamed:@"nosearch"];
            strName = SLLocalizedString(@"抱歉，暂无此商品");
        }else{
            imageData = [UIImage imageNamed:@"categorize_nogoods"];
            strName = SLLocalizedString(@"该分类暂无商品");
        }
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((184 - 54)/2, 0, 54, 54)];
        [image setImage:imageData];
        [view addSubview:image];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame) + 24, 184, 28)];
        label.textAlignment = NSTextAlignmentCenter;
        [label setTextColor:[UIColor colorForHex:@"999999"]];
        [label setFont:kRegular(20)];
        [label setText:strName];
        [view addSubview:label];
    }
    return _notGoodsView;

}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    if ([dataArray count] > 0) {
        [self.notGoodsView setHidden:YES];
        [self.collectionView reloadData];
    }else{
        [self.notGoodsView setHidden:NO];
    }
}

@end
