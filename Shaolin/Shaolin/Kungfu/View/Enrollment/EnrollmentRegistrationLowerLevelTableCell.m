//
//  EnrollmentRegistrationLowerLevelTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentRegistrationLowerLevelTableCell.h"

#import "EnrollmentRegistrationCollectionViewCell.h"

@interface EnrollmentRegistrationLowerLevelTableCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong)NSArray *dataArray;

@end

@implementation EnrollmentRegistrationLowerLevelTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
     [self.collectionView registerNib:[UINib nibWithNibName:@"EnrollmentRegistrationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"EnrollmentRegistrationCollectionViewCell"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EnrollmentRegistrationCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"EnrollmentRegistrationCollectionViewCell" forIndexPath:indexPath];
    if([[self.dataArray firstObject] isKindOfClass:[NSString class]]){
        [cell setTitleStr:[self.dataArray objectAtIndex:indexPath.row]];
    }else{
        NSString *title = self.model[@"title"];
           
           if ([title isEqualToString:SLLocalizedString(@"申报段品阶：")] == YES) {
               [cell setDataModel:[self.dataArray objectAtIndex:indexPath.row]];
           }else if([title isEqualToString:SLLocalizedString(@"国      籍：")] == YES) {
               [cell setAddressInfoModel:[self.dataArray objectAtIndex:indexPath.row]];
           }else if([title isEqualToString:SLLocalizedString(@"民      族：")] == YES ||[title isEqualToString:SLLocalizedString(@"学      历：")] == YES) {
               [cell setDataInfoModel:[self.dataArray objectAtIndex:indexPath.row]];
           }else{
               [cell setAddressModel:[self.dataArray objectAtIndex:indexPath.row]];
           }
    }
    
//    cell.btnTitle = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(enrollmentRegistrationLowerLevelTableCell:didSelectItemAtIndexPath:currentData:)]) {
        [self.delegate enrollmentRegistrationLowerLevelTableCell:self didSelectItemAtIndexPath:indexPath currentData:self.model];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([[self.dataArray firstObject] isKindOfClass:[NSString class]]){
        CGFloat width = (ScreenWidth - 135)/3;
        return CGSizeMake(width, 30);
    }else{
        NSString *title = self.model[@"title"];
        if ([title isEqualToString:SLLocalizedString(@"申报段品阶：")] == YES) {
            CGFloat width = (ScreenWidth - 135)/3;
            return CGSizeMake(width, 30);
        }else{
            CGFloat width = (ScreenWidth - 45);
            return CGSizeMake(width, 50);
        }
    }
}

#pragma mark - setter / getter

-(void)setModel:(NSDictionary *)model{
    _model = model;
    NSString *title = model[@"title"];
    self.dataArray = model[@"subArray"];
    if ([title isEqualToString:SLLocalizedString(@"国      籍：")] == YES){
        [self.collectionView setScrollEnabled:YES];
    }else{
        [self.collectionView setScrollEnabled:NO];
    }
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

@end
