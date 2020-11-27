//
//  HotCityTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "HotCityTableViewCell.h"
#import "HotCityCollectionViewCell.h"

@interface HotCityTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HotCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView setBackgroundColor:KTextGray_FA];
    [self setBackgroundColor:KTextGray_FA];
    // Initialization code
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HotCityCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"HotCityCollectionViewCell"];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = ((ScreenWidth - 32)-16 - 10) /3;
    
    return CGSizeMake(width, 40);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotCityCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotCityCollectionViewCell" forIndexPath:indexPath];

    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(hotCityTableViewCell:tapItem:)]){
        [self.delegate hotCityTableViewCell:self tapItem:self.dataArray[indexPath.row]];
    }
}

-(void)setDataArray:(NSArray *)dataArray{
    
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
}



@end
