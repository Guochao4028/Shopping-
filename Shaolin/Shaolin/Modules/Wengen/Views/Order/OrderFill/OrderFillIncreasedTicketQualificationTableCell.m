//
//  OrderFillIncreasedTicketQualificationTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillIncreasedTicketQualificationTableCell.h"
#import "InvoiceQualificationsModel.h"


@interface OrderFillIncreasedTicketQualificationTableCell ()
//公司名称
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
//纳税人示别码
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
//注册地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//注册电话
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//开户行
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
//银行账户
@property (weak, nonatomic) IBOutlet UILabel *bankSnLabel;


@end

@implementation OrderFillIncreasedTicketQualificationTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(InvoiceQualificationsModel *)model{
    //公司名称
    [self.companyNameLabel setText:model.companyName];
    //纳税人示别码
    [self.numberLabel setText:model.number];
    //注册地址
    [self.addressLabel setText:model.address];
    //注册电话
    [self.phoneLabel setText:model.phone];
    //开户行
    [self.bankLabel setText:model.bank];
    //银行账户
    [self.bankSnLabel setText:model.bankSn];
    
}

@end
