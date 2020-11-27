//
//  OrderAfterSalesItmeTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/16.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderAfterSalesItmeTableViewCell.h"

#import "OrderListModel.h"

#import "OrderStoreModel.h"

#import "OrderGoodsModel.h"

#import "NSString+Tool.h"

@interface OrderAfterSalesItmeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *instructionsLabelH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *instructionsViewH;

@property (weak, nonatomic) IBOutlet UIButton *jumpButton;
@property (weak, nonatomic) IBOutlet UILabel *instructionsTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jumpButtonW;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteButtonW;

- (IBAction)deleteAction:(UIButton *)sender;

- (IBAction)jumpAction:(UIButton *)sender;
- (IBAction)cancelAction:(UIButton *)sender;

@end

@implementation OrderAfterSalesItmeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.goodsImageView.layer.cornerRadius = SLChange(4);
    
    
    [self modifiedButton: self.cancelButton borderColor:KTextGray_96 cornerRadius:15];
    [self.cancelButton setHidden:YES];
    [self.deleteButton setHidden:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - methods
///装饰button
-(void)modifiedButton:(UIButton *)sender borderColor:(UIColor *)color cornerRadius:(CGFloat)radius{
    sender.layer.borderWidth = 1;
    sender.layer.borderColor = color.CGColor;
    sender.layer.cornerRadius = SLChange(radius);
    [sender.layer setMasksToBounds:YES];
    
}

#pragma mark - setter / getter

-(void)setListModel:(OrderListModel *)listModel{
    _listModel = listModel;
    
    NSArray *orderStoreArray = listModel.order_goods;
    
    OrderStoreModel *storeModel = [orderStoreArray firstObject];
    
    NSArray *orderGoodsArray = storeModel.goods;
    
    OrderGoodsModel *goodsModel = [orderGoodsArray firstObject];
    
    [self.storeNameLabel setText:goodsModel.club_name];
    NSString * goodsImageStr = goodsModel.goods_image[0];
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsImageStr] placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    [self.goodsNameLabel setText:goodsModel.goods_name];
    
    [self.numberLabel setText:goodsModel.num];
    
    [self.storeNameLabel setText:goodsModel.club_name];
    
    [self.orderNoLabel setText:[NSString stringWithFormat:SLLocalizedString(@"服务单号：%@"), goodsModel.order_no]];
    
    NSString *refund_status = goodsModel.refund_status;
    
    if ([refund_status isEqualToString:@"1"]) {
        [self.jumpButton setTitle:SLLocalizedString(@"售后审核中") forState:UIControlStateNormal];
        
        [self.jumpButton setTitleColor:kMainYellow forState:UIControlStateNormal];
        
        [self.instructionsTitleLabel setText:SLLocalizedString(@"审核中")];
        if ([goodsModel.type isEqualToString:@"2"] == YES) {
            [self.instructionsLabel setText:SLLocalizedString(@"已收到您的退货申请，卖家审核中，谢谢您的支持")];
        }else if ([goodsModel.type isEqualToString:@"1"] == YES){
            [self.instructionsLabel setText:SLLocalizedString(@"已收到您的退款申请，卖家审核中，谢谢您的支持")];
        }else{
            [self.instructionsLabel setText:SLLocalizedString(@"已收到您的退货申请，卖家审核中，谢谢您的支持")];
        }
        
        
        [self modifiedButton:self.jumpButton borderColor:kMainYellow cornerRadius:15];
        
        self.jumpButtonW.constant = 90;
        
        [self.cancelButton setHidden:NO];
        
    }else if ([refund_status isEqualToString:@"2"]) {
        
        if ([goodsModel.type isEqualToString:@"2"] == YES) {
            //退货退款
            [self.jumpButton setTitle:SLLocalizedString(@"填写退货信息") forState:UIControlStateNormal];
            [self.jumpButton setTitleColor:kMainYellow forState:UIControlStateNormal];
            [self.instructionsTitleLabel setText:SLLocalizedString(@"审核成功")];
            [self.instructionsLabel setText:SLLocalizedString(@"已收到您的退货申请，卖家审核成功，需要您寄出物品并填写物流单号")];
            [self modifiedButton:self.jumpButton borderColor:kMainYellow cornerRadius:15];
            self.jumpButtonW.constant = 110;
            [self.cancelButton setHidden:NO];
        }else if ([goodsModel.type isEqualToString:@"1"] == YES) {
            //仅退款
            [self.jumpButton setTitle:SLLocalizedString(@"退款中") forState:UIControlStateNormal];
            
            [self.jumpButton setTitleColor:kMainYellow forState:UIControlStateNormal];
            [self.instructionsTitleLabel setText:SLLocalizedString(@"审核成功")];
            [self.instructionsLabel setText:SLLocalizedString(@"商家审核成功，正在为您退款")];
            [self modifiedButton:self.jumpButton borderColor:kMainYellow cornerRadius:15];
            self.jumpButtonW.constant = 90;
            [self.cancelButton setHidden:YES];
            
        }else{
            [self.jumpButton setTitle:SLLocalizedString(@"填写退货信息") forState:UIControlStateNormal];
            [self.jumpButton setTitleColor:kMainYellow forState:UIControlStateNormal];
            [self.instructionsTitleLabel setText:SLLocalizedString(@"审核成功")];
            [self.instructionsLabel setText:SLLocalizedString(@"已收到您的退货申请，卖家审核成功，需要您寄出物品并填写物流单号")];
            [self modifiedButton:self.jumpButton borderColor:kMainYellow cornerRadius:15];
            self.jumpButtonW.constant = 110;
            [self.cancelButton setHidden:NO];
        }
        
    }else if ([refund_status isEqualToString:@"3"]){
        [self.instructionsTitleLabel setText:SLLocalizedString(@"审核失败")];
        
        [self.jumpButton setTitle:SLLocalizedString(@"审核失败") forState:UIControlStateNormal];
        
        [self.jumpButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        
        [self.instructionsLabel setText:goodsModel.remark];
        [self modifiedButton:self.jumpButton borderColor:KTextGray_999 cornerRadius:15];
        self.jumpButtonW.constant = 90;
        
        [self.cancelButton setHidden:YES];
        
    }else if ([refund_status isEqualToString:@"6"]){
        
        [self.instructionsTitleLabel setText:SLLocalizedString(@"完成")];
        
        [self.jumpButton setTitle:SLLocalizedString(@"已完成") forState:UIControlStateNormal];
        
        [self.jumpButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        
        [self.instructionsLabel setText:SLLocalizedString(@"服务已完成，感谢您对少林的支持")];
        [self modifiedButton:self.jumpButton borderColor:KTextGray_999 cornerRadius:15];
        self.jumpButtonW.constant = 90;
        [self.cancelButton setHidden:YES];
    }else if ([refund_status isEqualToString:@"4"]){
        
        [self.instructionsTitleLabel setText:SLLocalizedString(@"已撤销")];
        
        [self.jumpButton setTitle:SLLocalizedString(@"已撤销") forState:UIControlStateNormal];
        
        [self.jumpButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        
        [self.instructionsLabel setText:SLLocalizedString(@"您提交的售后申请已撤销")];
        [self modifiedButton:self.jumpButton borderColor:KTextGray_999 cornerRadius:15];
        self.jumpButtonW.constant = 90;
        [self.cancelButton setHidden:YES];
    }else if ([refund_status isEqualToString:@"5"]){
        
        [self.jumpButton setTitle:SLLocalizedString(@"退货中") forState:UIControlStateNormal];
        [self.jumpButton setTitleColor:kMainYellow forState:UIControlStateNormal];
        [self.instructionsTitleLabel setText:SLLocalizedString(@"退货")];
        [self.instructionsLabel setText:SLLocalizedString(@"您已寄出物品，等待商家验收")];
        [self modifiedButton:self.jumpButton borderColor:kMainYellow cornerRadius:15];
        self.jumpButtonW.constant = 90;
        [self.cancelButton setHidden:YES];
    }else if ([refund_status isEqualToString:@"7"]){
        
        //仅退款
        [self.jumpButton setTitle:SLLocalizedString(@"退款中") forState:UIControlStateNormal];
                   
        [self.jumpButton setTitleColor:kMainYellow forState:UIControlStateNormal];
        [self.instructionsTitleLabel setText:SLLocalizedString(@"退款中")];
        [self.instructionsLabel setText:SLLocalizedString(@"商家已收到您寄出的物品，等待商家退款")];
        [self modifiedButton:self.jumpButton borderColor:kMainYellow cornerRadius:15];
        self.jumpButtonW.constant = 90;
        [self.cancelButton setHidden:YES];
    }
    
    [self.deleteButton setHidden:!self.cancelButton.hidden];
    
    if (self.deleteButton.hidden == YES) {
        self.deleteButtonW.constant = 0;
    }else{
        self.deleteButtonW.constant = 40;
    }
    
//    CGFloat heitg = [UILabel getLabelHeightWithText:self.instructionsLabel.text width:self.instructionsLabel.mj_w font:self.instructionsLabel.font];
//
      
    CGSize size = [NSString sizeWithFont:kRegular(13) maxSize:CGSizeMake(ScreenWidth - 32 -117-18, MAXFLOAT) string:self.instructionsLabel.text];
    
    self.instructionsLabelH.constant = size.height+1;
    
    self.instructionsViewH.constant =  size.height +1+30 ;
    
    
}

- (IBAction)jumpAction:(UIButton *)sender {
    NSArray *orderStoreArray = self.listModel.order_goods;
    OrderStoreModel *storeModel = [orderStoreArray firstObject];
    NSArray *orderGoodsArray = storeModel.goods;
    OrderGoodsModel *goodsModel = [orderGoodsArray firstObject];
    
    NSString *refund_status = goodsModel.refund_status;
    if ([refund_status isEqualToString:@"2"]){
        
        if ([goodsModel.type isEqualToString:@"2"] == YES) {
            //退货退款
            if ([self.delegate respondsToSelector:@selector(orderAfterSalesItmeTableViewCell:fillReturnInformation:)] == YES) {
                [self.delegate orderAfterSalesItmeTableViewCell:self fillReturnInformation:self.listModel];
            }
        }else if ([goodsModel.type isEqualToString:@"1"] == YES) {
            //仅退款
            if ([self.delegate respondsToSelector:@selector(orderAfterSalesItmeTableViewCell:checkSchedule:)] == YES) {
                [self.delegate orderAfterSalesItmeTableViewCell:self checkSchedule:self.listModel];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(orderAfterSalesItmeTableViewCell:checkSchedule:)] == YES) {
                [self.delegate orderAfterSalesItmeTableViewCell:self checkSchedule:self.listModel];
            }
        }
        
        
        
        
    }else{
        if ([self.delegate respondsToSelector:@selector(orderAfterSalesItmeTableViewCell:checkSchedule:)] == YES) {
            [self.delegate orderAfterSalesItmeTableViewCell:self checkSchedule:self.listModel];
        }
    }
    
}

- (IBAction)cancelAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(orderAfterSalesItmeTableViewCell:cancelApplication:)] == YES) {
        [self.delegate orderAfterSalesItmeTableViewCell:self cancelApplication:self.listModel];
    }
}

- (IBAction)deleteAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(orderAfterSalesItmeTableViewCell:deleteApplication:)] == YES) {
        [self.delegate orderAfterSalesItmeTableViewCell:self deleteApplication:self.listModel];
    }
}



@end
