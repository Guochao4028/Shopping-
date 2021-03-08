//
//  OrderInvoiceInputTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/10/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderInvoiceInputTableViewCell.h"

@interface OrderInvoiceInputTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@end

@implementation OrderInvoiceInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModelDic:(NSDictionary *)modelDic{
    _modelDic = modelDic;
    NSString *titleStr = modelDic[@"title"];
    NSString *placeholderStr = modelDic[@"placeholder"];
    [self.titleLabel setText:titleStr];
    [self.contentTextField setPlaceholder:placeholderStr];
    
}

@end
