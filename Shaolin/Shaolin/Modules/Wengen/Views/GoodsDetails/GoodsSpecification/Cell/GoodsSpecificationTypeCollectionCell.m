//
//  GoodsSpecificationTypeCollectionCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsSpecificationTypeCollectionCell.h"

#import "GoodsAttrBasisModel.h"

@interface GoodsSpecificationTypeCollectionCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;


@end

@implementation GoodsSpecificationTypeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bgView setBackgroundColor:KTextGray_F3];
    
    self.bgView.layer.cornerRadius = 15;
    [self.bgView.layer setMasksToBounds:YES];
}

#pragma mark - getter / setter

- (void)setModel:(GoodsAttrBasisModel *)model{
    _model = model;
    
    BOOL isSelected = model.isSeleced;
    if (isSelected == YES) {
        [self.bgView setBackgroundColor:[UIColor whiteColor]];
        [self.tagLabel setTextColor:kMainYellow];
        self.bgView.layer.borderColor = kMainYellow.CGColor;
        self.bgView.layer.borderWidth = 1;
        [self.bgView.layer setMasksToBounds:YES];
    }else{
        [self.tagLabel setTextColor:KTextGray_333];
        [self.bgView setBackgroundColor:KTextGray_F3];
        
        self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
        self.bgView.layer.borderWidth = 0;
        [self.bgView.layer setMasksToBounds:YES];

    }
    
    if(model.isOptional == YES){
        [self.bgView setBackgroundColor:[UIColor purpleColor]];
    }
    
    [self.tagLabel setText:model.name];
    
}

@end
