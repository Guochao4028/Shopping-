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
    NSString *title = model[@"title"];
       BOOL isSelect = [isSelectStr boolValue];
       if (isSelect == YES) {
           [self.selectedImageVeiw setImage:[UIImage imageNamed:@"xuan"]];
       }else{
           [self.selectedImageVeiw setImage:[UIImage imageNamed:@"weixuan"]];
       }
       
       [self.titleLabel setText:title];
    
    if(model[@"is_electronic"] != nil || model[@"is_VAT"] != nil){
        BOOL is_electronic = [model[@"is_electronic"] boolValue];
        BOOL is_VAT = [model[@"is_VAT"] boolValue];
        
//        if ([title isEqualToString:SLLocalizedString(@"电子发票")]) {
//            if (is_electronic == NO) {
//                [self.titleLabel setTextColor:KTextGray_999];
//            }
//        }
//        if ([title isEqualToString:SLLocalizedString(@"增值税专用发票")]) {
//            if (is_VAT == NO) {
//                [self.titleLabel setTextColor:KTextGray_999];
//            }
//        }
        
        
        if ([title isEqualToString:SLLocalizedString(@"纸质发票")]) {
            if (is_electronic == NO) {
                [self.titleLabel setTextColor:KTextGray_999];
            }
        }
        if ([title isEqualToString:SLLocalizedString(@"增值税专用发票")]) {
            if (is_VAT == NO) {
                [self.titleLabel setTextColor:KTextGray_999];
            }
        }
        
        
    }
    
    
    
}

@end
