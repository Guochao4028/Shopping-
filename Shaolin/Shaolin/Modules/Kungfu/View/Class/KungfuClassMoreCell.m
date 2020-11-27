//
//  KungfuClassMoreCell.m
//  Shaolin
//
//  Created by ws on 2020/5/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuClassMoreCell.h"
//#import "KungfuHomemLatestEventsCollectionCell.h"
#import "KungfuManager.h"
#import "KungfuClassMoreCollectionViewCell.h"

static NSString *const collectionCellId = @"KungfuHomemLatestEventsCollectionCell";

@interface KungfuClassMoreCell() <UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionView *collectionView;


@end

@implementation KungfuClassMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setClassListArray:(NSArray *)classListArray{
    _classListArray = classListArray;
    [self.collectionView reloadData];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
    return self.classListArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    KungfuClassMoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellId forIndexPath:indexPath];
    cell.model = self.classListArray[indexPath.row];
    
//    KungfuHomemLatestEventsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellId forIndexPath:indexPath];
//
////    NSArray *arr=@[@"kungfu_allClass",@"kungfu_huodong",@"kungfu_kaoshi",@"kungfu_baoming"];
//
////    cell.imageIcon.image = [UIImage imageNamed:arr[indexPath.row]];
////    NSArray *arrTitle = @[SLLocalizedString(@"全部教程"),SLLocalizedString(@"活动报名"),SLLocalizedString(@"理论考试"),SLLocalizedString(@"报名查询")];
////    cell.nameLabel.text = arrTitle[indexPath.row];
//
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassListModel *model = self.classListArray[indexPath.row];
    if (self.cellSelectBlock) {
        self.cellSelectBlock(model);
    }
}

//设置每个item的UIEdgeInsets
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//
//}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        flowLayout.minimumLineSpacing = 10;// 根据需要编写
        
        flowLayout.itemSize = CGSizeMake(150, 150);
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, kWidth, 150) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[KungfuClassMoreCollectionViewCell class] forCellWithReuseIdentifier:collectionCellId];
//        [_collectionView registerNib:[UINib nibWithNibName:collectionCellId bundle:nil] forCellWithReuseIdentifier:collectionCellId];
        
    }
    return _collectionView;
}


@end
