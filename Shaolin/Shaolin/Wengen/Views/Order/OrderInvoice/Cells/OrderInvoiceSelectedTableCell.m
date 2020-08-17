//
//  OrderInvoiceSelectedTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderInvoiceSelectedTableCell.h"

@interface OrderInvoiceSelectedTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageVeiw;

@end

@implementation OrderInvoiceSelectedTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(NSDictionary *)model{
    _model = model;
    NSString *isSelectStr = model[@"isSelect"];
       BOOL isSelect = [isSelectStr boolValue];
       if (isSelect == YES) {
           [self.selectedImageVeiw setImage:[UIImage imageNamed:@"xuan"]];
       }else{
           [self.selectedImageVeiw setImage:[UIImage imageNamed:@"weixuan"]];
       }
       
       [self.titleLabel setText:model[@"title"]];
    
}

@end
