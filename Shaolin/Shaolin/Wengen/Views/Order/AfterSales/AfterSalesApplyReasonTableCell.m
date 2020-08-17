//
//  AfterSalesApplyReasonTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AfterSalesApplyReasonTableCell.h"

#import "SelectPotoCollectionCell.h"

#import "PotoCollectionCell.h"

#import "OrderDetailsModel.h"

@interface AfterSalesApplyReasonTableCell ()<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, PotoCollectionCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *reasonView;

@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;
@property (weak, nonatomic) IBOutlet UIView *yidaohuoView;
@property (weak, nonatomic) IBOutlet UIImageView *yidaohuoImageView;
@property (weak, nonatomic) IBOutlet UIView *weidaohuoView;
@property (weak, nonatomic) IBOutlet UIImageView *weidaohuoImageView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *yidaohuoLabel;

@property (weak, nonatomic) IBOutlet UILabel *weidaohuoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewH;

@property(nonatomic, copy)NSString *cause;

@end

@implementation AfterSalesApplyReasonTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.reasonView.layer.cornerRadius = 4;
    
    [self.reasonTextView setDelegate:self];
    
    UITapGestureRecognizer *yidaohuoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yifahuoAction)];
    
    [self.yidaohuoView addGestureRecognizer:yidaohuoTap];
    
    UITapGestureRecognizer *weidaohuoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weidaohuoAction)];
       
    [self.weidaohuoView addGestureRecognizer:weidaohuoTap];
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SelectPotoCollectionCell class])bundle:nil] forCellWithReuseIdentifier:@"SelectPotoCollectionCell"];
    
    
     [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PotoCollectionCell class])bundle:nil] forCellWithReuseIdentifier:@"PotoCollectionCell"];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - action
-(void)yifahuoAction{
    [self.yidaohuoImageView setImage:[UIImage imageNamed:@"xuan"]];
    
    [self.weidaohuoImageView setImage:[UIImage imageNamed:@"weixuan"]];
    
    self.goods_status = @"1";
}

-(void)weidaohuoAction{
    [self.yidaohuoImageView setImage:[UIImage imageNamed:@"weixuan"]];
       
    [self.weidaohuoImageView setImage:[UIImage imageNamed:@"xuan"]];
    self.goods_status = @"0";
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:SLLocalizedString(@"请描述申请售后服务的具体原因……")]){
        textView.text = @"";
        textView.textColor = [UIColor hexColor:@"333333"];
        self.cause = @"";
        
        if (self.block != nil) {
            self.block(YES);
        }
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text length] < 1){
        textView.text = SLLocalizedString(@"请描述申请售后服务的具体原因……");
        textView.textColor = [UIColor hexColor:@"979797"];
        if (self.block != nil) {
            self.block(NO);
        }
    }else{
        self.cause = textView.text;
        if (self.block != nil) {
            self.block(YES);
        }
    }
}

#pragma mark - UICollectionViewDelegate &&  UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.potoArray.count == 9 ? 9: self.potoArray.count + 1 ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (ScreenWidth - 32 - 18 *3)/4;
    return CGSizeMake(width, 83);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.potoArray.count < 9) {
        
        if (indexPath.row >= self.potoArray.count) {
            SelectPotoCollectionCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectPotoCollectionCell" forIndexPath:indexPath];
            
            return cell;
        }else{
            PotoCollectionCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"PotoCollectionCell" forIndexPath:indexPath];
            
            [cell setDelegate:self];
            
            cell.location = indexPath.row;
            
            cell.imageUrl = self.potoArray[indexPath.row];
            
            return cell;
        }
        
    }else{
        PotoCollectionCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"PotoCollectionCell" forIndexPath:indexPath];
        
        [cell setDelegate:self];
        
        cell.location = indexPath.row;
        
        cell.imageUrl = self.potoArray[indexPath.row];
        
        return cell;
    }
    
    
    
    //    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.potoArray.count < 9) {
        if (indexPath.row >= self.potoArray.count) {
           if([self.delegate respondsToSelector:@selector(applyReasonTableCell:tapSelectPoto:)]){
               [self.delegate applyReasonTableCell:self tapSelectPoto:YES];
           }
        }
    }
}

#pragma mark - PotoCollectionCellDelegate
-(void)potoCollectionCell:(PotoCollectionCell *)cell tapDeletePoto:(BOOL)istap location:(NSInteger)loction{
    if ([self.delegate respondsToSelector:@selector(applyReasonTableCell:tapDeleteLocation:)] == YES) {
        [self.delegate applyReasonTableCell:self tapDeleteLocation:loction];
    }
}

#pragma mark - setter / getter

-(void)setAfterType:(AfterSalesDetailsType)afterType {
    _afterType = afterType;
    
    if (afterType == AfterSalesDetailsTuiQianType) {
        self.yidaohuoView.userInteractionEnabled = NO;
        [self.yidaohuoView setHidden:YES];
        [self.yidaohuoImageView setHidden:YES];
        [self.yidaohuoLabel setHidden:YES];
        
        [self weidaohuoAction];
    } else {
        self.weidaohuoView.userInteractionEnabled = NO;
        [self.weidaohuoView setHidden:YES];
        [self.weidaohuoImageView setHidden:YES];
        [self.weidaohuoLabel setHidden:YES];
        
        [self yifahuoAction];
    }
}

-(void)setModel:(OrderDetailsModel *)model{
    NSString *statusStr = model.status;
   if ([statusStr isEqualToString:@"2"] == YES  || [statusStr isEqualToString:@"3"] == YES) {
//       self.yidaohuoView.userInteractionEnabled = NO;
//       [self.yidaohuoImageView setHidden:YES];
//       [self.yidaohuoLabel setHidden:YES];
//       
//       [self weidaohuoAction];
    }
}

-(void)setPotoArray:(NSArray *)potoArray{
    _potoArray = potoArray;
    CGFloat collectionViewH = 0;
//    if ([self.potoArray count] == 0) {
//        collectionViewH = 85;
//    }else if ([self.potoArray count] <= 4 && [self.potoArray count] < 8){
//        collectionViewH = 85 *2;
//    }else{
//        collectionViewH = 85 *3;
//    }
    
    
    if ([self.potoArray count] == 0) {
        collectionViewH = 85;
    }else if ([self.potoArray count] < 4){
        collectionViewH = 85;
    }else if([self.potoArray count] >= 4 &&[self.potoArray count] < 8){
        collectionViewH = 85 *2 +10;
    }else{
       collectionViewH = 85 *3+(10*2);
    }
    
    
    self.collectionViewH.constant = collectionViewH;
    [self.collectionView reloadData];
}

-(NSString *)reason{
    return self.cause;
}


@end
