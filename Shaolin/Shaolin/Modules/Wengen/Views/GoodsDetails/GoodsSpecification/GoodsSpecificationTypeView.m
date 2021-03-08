//
//  GoodsSpecificationTypeView.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsSpecificationTypeView.h"

#import "GoodsSpecificationTypeCollectionCell.h"

#import "GoodsSpecificationModel.h"

#import "NSString+Size.h"
#import "GoodsAttrBasisModel.h"

static NSString *const kGoodsSpecificationTypeCollectionCellIdentifier = @"GoodsSpecificationTypeCollectionCell";

@interface GoodsSpecificationTypeView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong)UILabel *titleLabel;

@property(nonatomic, strong)UICollectionView *collectionView;

@property(nonatomic, assign)CGFloat tagHeight;

@end

@implementation GoodsSpecificationTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

+(instancetype)goodsSpecificationTypeViewInit{
    GoodsSpecificationTypeView *typeView = [[GoodsSpecificationTypeView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    return typeView;
}

#pragma mark - methods
- (void)initUI{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
}

//计算Collection高度
- (CGFloat)calculateCollectionHeight:(NSArray *)dataArray{
    CGFloat heigth = 0;
    
    heigth = [self.collectionView.collectionViewLayout collectionViewContentSize].height;
    
//    NSInteger count = dataArray.count;
//    CGFloat rowH = 42;
//    NSInteger rowNumber = ceilf(count/3.0);
//
//    heigth = rowH * rowNumber + 10;
    
    heigth += 10;
    
    return heigth;
}

///刷新数据
- (void)reloadData{
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (ScreenWidth - 32  - 80) / 3;
    GoodsAttrBasisModel *basisModel = self.dataArray[indexPath.row];
    CGFloat labelWidth = [basisModel.name textSizeWithFont:kRegular(13)
                        constrainedToSize:CGSizeMake(CGFLOAT_MAX, 30)
                        lineBreakMode:NSLineBreakByWordWrapping].width +32;
    if(basisModel.name.length <= 11 &&basisModel.name.length>5){
        labelWidth = (ScreenWidth - 32 - 35 ) / 2;
    }
//    else if (basisModel.name.length > 11){
//        labelWidth = (ScreenWidth - 32);
//    }
//    NSLog(@"basisModel.name > %@", basisModel.name);
//    NSLog(@"width > %f", width);
//    NSLog(@"labelWidth > %f", labelWidth);

    width = labelWidth > width ? labelWidth : width;
    
   width = width > ScreenWidth - 32 ? ScreenWidth - 32 : width;
    
    return CGSizeMake(width, 30);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodsSpecificationTypeCollectionCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kGoodsSpecificationTypeCollectionCellIdentifier forIndexPath:indexPath];

    cell.model = self.dataArray[indexPath.row];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.typeViewSelectedBlcok != nil) {
//        self.typeViewSelectedBlcok(self, indexPath.row);
//    }
    
    GoodsAttrBasisModel *model = self.dataArray[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(goodsSpecificationTypeView:selectedModel:allDataArray:)]) {
        [self.delegate goodsSpecificationTypeView:self selectedModel:model allDataArray:self.dataArray];
    }
}



#pragma mark - setter / getter

- (UILabel *)titleLabel{
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, ScreenWidth - 31, 20)];
        _titleLabel.textColor = KTextGray_333;
        _titleLabel.font = kMediumFont(14);
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView{
    
    if (_collectionView == nil) {
        
        CGFloat y = CGRectGetMaxY(self.titleLabel.frame) + 12;
        
        JYEqualCellSpaceFlowLayout *flowLayout = [[JYEqualCellSpaceFlowLayout alloc] initWithType:AlignWithLeft betweenOfCell:35];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 35;
        
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(16, y, ScreenWidth - 32, 0) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsSpecificationTypeCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:kGoodsSpecificationTypeCollectionCellIdentifier];
        
        [_collectionView setBackgroundColor: [UIColor whiteColor]];
        
    }
    return _collectionView;

}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self.titleLabel setText:titleStr];
}

- (void)setDataArray:(NSArray *)dataArray{
    
    _dataArray = dataArray;
    
    CGFloat heigth = [self calculateCollectionHeight:dataArray];
    
    self.collectionView.mj_h = heigth;
    
    self.tagHeight = 30 + heigth;
    
    [self.collectionView reloadData];
}


- (CGFloat)height{
    return self.tagHeight;
}

@end
