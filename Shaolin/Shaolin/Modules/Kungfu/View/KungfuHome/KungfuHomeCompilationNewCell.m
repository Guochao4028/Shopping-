//
//  KungfuHomeCompilationNewCell.m
//  Shaolin
//
//  Created by 王精明 on 2020/11/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuHomeCompilationNewCell.h"
#import "KungfuHomeClassSeriesCell.h"
#import "ClassListModel.h"

@interface KungfuHomeCompilationNewCell() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation KungfuHomeCompilationNewCell
+ (CGSize)cellSize {
    
    // 设计图比例是 168,257
    CGFloat itemWidth = (kScreenWidth - 39)/2;
    CGFloat itemHeight = (itemWidth - 168) + 257;
    
    return CGSizeMake(itemWidth, itemHeight);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.right.bottom.mas_equalTo(0);
        }];
        //不设置NO会出现一个UITableViewCellContentview覆盖在最上层，cell的点击事件无法触发
        self.contentView.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.dataArray.count > 2) {
        return 2;
    }
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KungfuHomeClassSeriesCell *cell = (KungfuHomeClassSeriesCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KungfuHomeClassSeriesCell class]) forIndexPath:indexPath];
    cell.cellModel = self.dataArray[indexPath.row];
    [cell setCellModel:self.dataArray[indexPath.row] tagString:self.tagString];
    cell.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    //阴影偏移
    cell.layer.shadowOffset = CGSizeMake(0, 1.5);
    // 阴影透明度，默认0
    cell.layer.shadowOpacity = 1;
    // 阴影半径，默认3
    cell.layer.shadowRadius = 4;
    
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
////    //设置缓存
    cell.layer.shouldRasterize = YES;
////    //设置抗锯齿边缘
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassListModel *cellModel = self.dataArray[indexPath.row];
    if (self.selectHandle) {
        self.selectHandle(cellModel.classId);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat gap = (collectionView.width - KungfuHomeCompilationNewCell.cellSize.width*2)/3.0;
    return UIEdgeInsetsMake(0, gap, 0, gap);
}
#pragma mark - getter
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
//        _layout.minimumLineSpacing = 7;
//        _layout.minimumInteritemSpacing = 15;
        _layout.itemSize = KungfuHomeCompilationNewCell.cellSize;// CGSizeMake(168, 257);
    }
    return _layout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView){
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[KungfuHomeClassSeriesCell class] forCellWithReuseIdentifier:NSStringFromClass([KungfuHomeClassSeriesCell class])];
    }
    return _collectionView;
}
@end
