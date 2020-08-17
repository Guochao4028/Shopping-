//
//  RiteOrderDetailPriceCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/31.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteOrderDetailPriceCell.h"

#import "OrderDetailsModel.h"

@interface RiteOrderDetailPriceCell ()

@property (weak, nonatomic) IBOutlet UILabel *allGoodsPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *needPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *needTitleLabel;

@end

@implementation RiteOrderDetailPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(OrderDetailsModel *)model{
    _model = model;
    
    NSString *money = [NSString stringWithFormat:@"￥%@", NotNilAndNull(model.money)?model.money:@""];
    
    self.allGoodsPriceLabel.text = money;
    self.needPriceLabel.text = [NSString stringWithFormat:@"￥%@", NotNilAndNull(model.money)?model.money:@""];
    
    
    
     ///1：待付款，2：待发货，3：待收货，4：已收货，5：完成，6：取消 7：支付超时'
       NSInteger status = [model.status integerValue];
       
       switch (status) {
           case 2:
           case 3:
           case 4:
           case 5:{
               self.needTitleLabel.text = @"已付款：";
           }
               break;
               
           default:{
               self.needTitleLabel.text = @"需付款：";
           }
               break;
       }
    
    
}

@end
