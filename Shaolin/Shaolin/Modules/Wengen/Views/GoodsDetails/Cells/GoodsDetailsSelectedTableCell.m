//
//  GoodsDetailsSelectedTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsDetailsSelectedTableCell.h"

#import "AddressListModel.h"

#import "GoodsInfoModel.h"

#import "NSString+Tool.h"


@interface GoodsDetailsSelectedTableCell ()
@property (weak, nonatomic) IBOutlet UIView *specificaationView;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *specificaationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@end

@implementation GoodsDetailsSelectedTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *specificaationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSpecificaation)];
    [self.specificaationView addGestureRecognizer:specificaationTap];
    
    
    UITapGestureRecognizer *addressViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAddressView)];
       [self.addressView addGestureRecognizer:addressViewTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

#pragma mark - action
- (void)tapSpecificaation{
    if ([self.delegate respondsToSelector:@selector(goodsSelectedCell:tapSpecification:)]) {
        [self.delegate goodsSelectedCell:self tapSpecification:YES];
    }
}

- (void)tapAddressView{
    if ([self.delegate respondsToSelector:@selector(goodsSelectedCell:tapAddress:)]) {
        [self.delegate goodsSelectedCell:self tapAddress:YES];
    }
}

#pragma mark - getter / setter

- (void)setModel:(GoodsInfoModel *)model{
    _model = model;
    
//    if (model.attr.count == 0) {
//         [self.specificaationView setHidden:YES];
//    }else{
//        [self.specificaationView setHidden:NO];
//
//    }
}

- (void)setAddressArray:(NSArray *)addressArray{
    id model = [addressArray firstObject];
    
    if ([model isKindOfClass:[NSString class]]) {
        
        NSString *str = (NSString *)model;
        
        [self.addressLabel setText:str];
        
    }else if([model isKindOfClass:[AddressListModel class]]){
        AddressListModel *tem = (AddressListModel *)model;
        
        [self.addressLabel setText:tem.address];
    }
}

- (void)setAddressModel:(AddressListModel *)addressModel{
    _addressModel = addressModel;
    if (addressModel == nil) {
        [self.addressLabel setText:SLLocalizedString(@"选择收货地址")];
    }else{
        NSString *str;
           if ([addressModel.countryS isEqualToString:SLLocalizedString(@"中国")] == NO) {
               str  = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",addressModel.countryS, addressModel.provinceS, addressModel.cityS, addressModel.reS, addressModel.address];
           }else{
              str = [NSString stringWithFormat:@"%@ %@ %@ %@", addressModel.provinceS, addressModel.cityS, addressModel.reS, addressModel.address];
           }
           
           [self.addressLabel setText:str];
        
    }
}

- (void)setSpecificaationStr:(NSString *)specificaationStr{
    _specificaationStr = specificaationStr;
    if (specificaationStr.length > 0) {
        [self.specificaationLabel setText:specificaationStr];
    }else{
        [self.specificaationLabel setText:SLLocalizedString(@"请选择规格")];
    }
}

- (void)setFeeStr:(NSString *)feeStr{
    _feeStr = feeStr;
    float feeFloat = [feeStr floatValue];
    if ([feeStr isEqualToString:@"0"] == YES ||feeFloat == 0) {
        [self.feeLabel setText:SLLocalizedString(@"免运费")];
    }else{
        
        [self.feeLabel setText:[NSString stringWithFormat:SLLocalizedString(@"%@元"),[feeStr formattedPrice]]];
    }
    
    if (feeStr == nil) {
         [self.feeLabel setText:SLLocalizedString(@"免运费")];
    }
}

@end
