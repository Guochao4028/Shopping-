//
//  GoodsAddressListTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsAddressListTableCell.h"

#import "AddressListModel.h"

@interface GoodsAddressListTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addressIconImageView;


@end

@implementation GoodsAddressListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - getter / setter
-(void)setModel:(AddressListModel *)model{
    _model = model;
    
    NSString *str;
    if ([model.country_s isEqualToString:SLLocalizedString(@"中国")] == NO) {
        str  = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",model.country_s, model.province_s, model.city_s, model.re_s, model.address];
    }else{
       str = [NSString stringWithFormat:@"%@ %@ %@ %@", model.province_s, model.city_s, model.re_s, model.address];
    }
    
    [self.addressLabel setText:str];
    
    BOOL isSelect = model.isSelected;
    
    if (isSelect == YES) {
        [self.addressIconImageView setImage:[UIImage imageNamed:@"hook"]];
    }else{
        [self.addressIconImageView setImage:[UIImage imageNamed:@"positioning"]];
    }
    
    
}

@end
