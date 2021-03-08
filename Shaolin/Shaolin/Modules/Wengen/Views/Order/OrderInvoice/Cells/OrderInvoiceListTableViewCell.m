//
//  OrderInvoiceListTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2021/1/19.
//  Copyright © 2021 syqaxldy. All rights reserved.
//

#import "OrderInvoiceListTableViewCell.h"
#import "OrderDetailsNewModel.h"
#import "NTVTextAlignLabel.h"
#import "OrderDetailsNewModel.h"
#import "NSString+Tool.h"
#import "NSString+Size.h"



@interface OrderInvoiceListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet NTVTextAlignLabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *invoiceStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *fristButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
- (IBAction)fristButtonAction:(UIButton *)sender;
- (IBAction)secondButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *numberCasesLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsPriceLabelW;

@end

@implementation OrderInvoiceListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self modifiedButton:self.secondButton borderColor:KTextGray_97 cornerRadius:15];
    
    [self modifiedButton:self.fristButton borderColor:kMainYellow cornerRadius:15];
    
    self.goodsImageView.layer.cornerRadius = SLChange(4);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - action

- (IBAction)secondButtonAction:(UIButton *)sender {
    NSString *titleStr = sender.titleLabel.text;
    if([titleStr isEqualToString:@"查看发票"]){
        if ([self.delegate respondsToSelector:@selector(orderInvoiceListTableViewCell:checkInvoice:)]) {
            [self.delegate orderInvoiceListTableViewCell:self checkInvoice:self.model];
        }
    }
    
}

- (IBAction)fristButtonAction:(UIButton *)sender {
 
    NSString *titleStr = sender.titleLabel.text;
    if ([titleStr isEqualToString:@"修改发票"]) {
        if ([self.delegate respondsToSelector:@selector(orderInvoiceListTableViewCell:changeInvoice:)]) {
            [self.delegate orderInvoiceListTableViewCell:self changeInvoice:self.model];
        }
    }
    
    if([titleStr isEqualToString:@"换开"]){
        if ([self.delegate respondsToSelector:@selector(orderInvoiceListTableViewCell:switcherInvoice:)]) {
            [self.delegate orderInvoiceListTableViewCell:self switcherInvoice:self.model];
        }
    }
    
    if([titleStr isEqualToString:@"重开发票"]){
        if ([self.delegate respondsToSelector:@selector(orderInvoiceListTableViewCell:againInvoice:)]) {
            [self.delegate orderInvoiceListTableViewCell:self againInvoice:self.model];
        }
    }
}
#pragma mark - private
///装饰button
- (void)modifiedButton:(UIButton *)sender borderColor:(UIColor *)color cornerRadius:(CGFloat)radius{
    sender.layer.borderWidth = 1;
    sender.layer.borderColor = color.CGColor;
    sender.layer.cornerRadius = sender.height/2;
    [sender.layer setMasksToBounds:YES];
}

#pragma mark - setter
-(void)setGoodsArray:(NSArray *)goodsArray{
    _goodsArray = goodsArray;
    
    [self.fristButton setEnabled:YES];
    
    double totalGoodsPrice = 0.0;
    
    NSMutableArray *goodsNamesArray = [NSMutableArray array];
    
    for (OrderDetailsGoodsModel *goodsModel in goodsArray) {
        double price = [goodsModel.goodsPrice doubleValue];
        NSInteger num = [goodsModel.goodsNum integerValue];
        totalGoodsPrice += (price * num);
        [goodsNamesArray addObject:goodsModel.goodsName];
    }
    
    self.goodsNameLabel.ntvTextAlignment = NTVTextAlignmentLeftTop;
    [self.goodsNameLabel setText:[goodsNamesArray componentsJoinedByString:@"，"]];
    
    NSString *goodsPriceStr = [[[NSString stringWithFormat:@"%f", totalGoodsPrice] formattedPrice] formattingPriceString];
    
    [self.goodsPriceLabel setText:goodsPriceStr];
    
    
    OrderDetailsGoodsModel *goodsModel = [goodsArray firstObject];
    
    NSURL *imageUrl = [NSURL URLWithString:goodsModel.goodsImages[0]];
    
    [self.goodsImageView sd_setImageWithURL:imageUrl];
    
    [self.numberCasesLabel setText:[NSString stringWithFormat:@"共%ld件", [goodsArray count]]];
    //发票是否换开
    BOOL isBarter = [goodsModel.isBarter boolValue];
    //是否是国外
    BOOL isForeign = [goodsModel.isForeign boolValue];
    
    //发票状态
    NSInteger invoiceStatus = [goodsModel.invoiceStatus integerValue];
    //1 待开票 2 已开票 3拒绝
    if (invoiceStatus == 1) {
        [self.fristButton setTitle:@"修改发票" forState:UIControlStateNormal];
        [self.invoiceStatusLabel setText:@"待开票"];
    }else if(invoiceStatus == 2){
        if (isBarter == NO && isForeign == NO) {
            [self.fristButton setTitle:@"换开" forState:UIControlStateNormal];
        }else{
            [self.fristButton setTitle:@"换开" forState:UIControlStateNormal];
            
            [self.fristButton setTitleColor:KTextGray_999 forState:UIControlStateNormal];
            
            [self modifiedButton:self.fristButton borderColor:KTextGray_97 cornerRadius:15];
            
            [self.fristButton setEnabled:NO];
        }
        [self.invoiceStatusLabel setText:@"已开票"];
    }else if(invoiceStatus == 3){
        
        [self.fristButton setTitle:@"重开发票" forState:UIControlStateNormal];
        
        [self.invoiceStatusLabel setText:@"拒绝"];
        
    }
    
    [self.orderNumberLabel setText:self.model.orderSn];
    [self.orderTimeLabel setText:self.model.createTime];
    
    self.goodsPriceLabelW.constant = [NSString sizeWithText:goodsPriceStr font:kMediumFont(16) maxSize:CGSizeMake(CGFLOAT_MAX, 22.5)].width + 1;
    
}




@end
