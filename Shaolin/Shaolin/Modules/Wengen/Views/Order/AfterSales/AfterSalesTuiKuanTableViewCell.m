//
//  AfterSalesTuiKuanTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AfterSalesTuiKuanTableViewCell.h"
#import "GoodsStoreInfoModel.h"

#import "OrderDetailsNewModel.h"

@interface AfterSalesTuiKuanTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingFeeLabel;
@end

@implementation AfterSalesTuiKuanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OrderDetailsGoodsModel *)model{
    _model = model;
    
    NSString *fee = self.model.shippingFee;
       
       if (!IsNilOrNull(fee)) {
           [self.shippingFeeLabel setText:[NSString stringWithFormat:@"¥%@", fee]];
       }

//    [self.nameLabel setText:model.name];
//    [self.phoneNumberLabel setText:model.phone];
//    [self.addressLabel setText:[NSString stringWithFormat:SLLocalizedString(@"地址：%@"),model.address_info]];
}


- (void)setStoreInfoModel:(GoodsStoreInfoModel *)storeInfoModel {
    _storeInfoModel = storeInfoModel;
    
    if (IsNilOrNull(storeInfoModel)) {
        return;
    }
    [self.nameLabel setText:storeInfoModel.name];
    [self.phoneNumberLabel setText:storeInfoModel.phone];
    [self.addressLabel setText:[NSString stringWithFormat:SLLocalizedString(@"地址：%@"),storeInfoModel.address]];
    
    NSString *fee = self.model.shippingFee;
    
    if (IsNilOrNull(fee)) {
        [self.shippingFeeLabel setText:fee];
    }
    
}



@end
