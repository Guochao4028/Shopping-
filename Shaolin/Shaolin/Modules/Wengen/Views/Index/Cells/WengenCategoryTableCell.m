//
//  WengenCategoryTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 分类入口cell

#import "WengenCategoryTableCell.h"

#import "GCCollectionViewFlowLayout.h"

#import "ItemCollectionViewCell.h"

#import "WengenEnterModel.h"

#import "NSString+Tool.h"

static NSString *const kItemCollectionViewCellIdentifier = @"ItemCollectionViewCell";

@interface WengenCategoryTableCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(strong, nonatomic)UICollectionView *collectionView;

@property(nonatomic, assign)CGFloat heigth;

@end

@implementation WengenCategoryTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [self initUI];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initUI{
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.collectionView];
    
//    CGRectMake(33, 20, totalWidth, self.heigth)
    CGFloat totalWidth = ScreenWidth - 66;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(33);
        make.bottom.mas_equalTo(15);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(totalWidth);
    }];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    /**
     32 是两边的边距 ，|-16-16-|
     (ScreenWidth - (4 * 56) - 32) 间距
     */
    
    
//    CGFloat width = ScreenWidth  - 73 - (30 *3);
    
    return CGSizeMake(56, 74);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ItemCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kItemCollectionViewCellIdentifier forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
//    cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_mall_icon%ld",indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.loction = indexPath.row;
    if([self.delegate respondsToSelector:@selector(cell:selectItem:)] == YES){
        [self.delegate cell:self selectItem:self.dataArray[indexPath.row]];
    }
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
//    NSInteger count = dataArray.count;
//    
//    if (count > 4) {
//        self.heigth = 191;
//    }else if (count > 0 && count <= 4){
//        self.heigth = 96;
//    }else{
//        self.heigth = 0;
//    }

    
    [self initUI];
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        CGFloat totalWidth = ScreenWidth - 66;
        
//        GCCollectionViewFlowLayout *layout = [[GCCollectionViewFlowLayout alloc]init];
//        layout.row = 2;
//        layout.column = 4;
//        layout.rowSpacing = 15;
//
//        layout.pageWidth = totalWidth;
//
//        layout.columnSpacing = (totalWidth - (56 *4))/3;
//
////        layout.minimumInteritemSpacing = 10;
//        /**
//         32 是两边的边距 ，|-16-16-|
//         30 是3*10，10是 间距
//         */
//        layout.size = CGSizeMake(56, 74);
//
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = 56;
        CGFloat higth = 74;
        layout.itemSize = CGSizeMake(width, higth);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = (totalWidth - (56 *4))/4;
//
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ItemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kItemCollectionViewCellIdentifier];
        
    }
    return _collectionView;
}


@end

