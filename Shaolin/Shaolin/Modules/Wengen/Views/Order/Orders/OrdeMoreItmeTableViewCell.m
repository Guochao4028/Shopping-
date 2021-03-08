//
//  OrdeMoreItmeTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrdeMoreItmeTableViewCell.h"

#import "OrderListModel.h"

#import "OrderStoreModel.h"

#import "OrderGoodsModel.h"

#import "OrdeItemImageCollectionViewCell.h"

#import "NSString+Tool.h"

@interface OrdeMoreItmeTableViewCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

//服务订单号
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *completeImageView;



/******待付款****/
@property (weak, nonatomic) IBOutlet UIView *obligationView;
//修改订单
@property (weak, nonatomic) IBOutlet UIButton *obligationChangeOrdersButton;
//查看发票
@property (weak, nonatomic) IBOutlet UIButton *obligationCheckInvoiceButton;
//去支付
@property (weak, nonatomic) IBOutlet UIButton *obligationPayButton;


/******待收货****/
@property (weak, nonatomic) IBOutlet UIView *receivingView;
//查看发票
@property (weak, nonatomic) IBOutlet UIButton *receivingCheckInvoiceButton;
//查看物流
@property (weak, nonatomic) IBOutlet UIButton *receivingCheckLogisticsButton;
//确认收货
@property (weak, nonatomic) IBOutlet UIButton *receivingConfirmCoodsButton;

/******待发货****/
@property (weak, nonatomic) IBOutlet UIView * waitingSendGoodsView;
//查看发票
@property (weak, nonatomic) IBOutlet UIButton *waitingSendGoodsCheckInvoiceButton;



/******已取消****/
@property (weak, nonatomic) IBOutlet UIView *cancelView;
//再次购买
@property (weak, nonatomic) IBOutlet UIButton *cancelAgainBuyButton;

/******已完成****/
@property (weak, nonatomic) IBOutlet UIView *completeView;

//申请售后
@property (weak, nonatomic) IBOutlet UIButton *completeAfterSaleButton;

//查看发票
@property (weak, nonatomic) IBOutlet UIButton *completeCheckInvoiceButton;

//查看物流
@property (weak, nonatomic) IBOutlet UIButton *completeCheckLogisticsButton;

//再次购买
@property (weak, nonatomic) IBOutlet UIButton *completeAgainBuyButton;

//待评星
@property (weak, nonatomic) IBOutlet UIButton *reviewStarButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completeOperationViewW;

@property (weak, nonatomic) IBOutlet UIView *completeCheckInvoiceView;

/****** ACTION ****/

//查看物流 action
- (IBAction)checkLogisticsAction:(UIButton *)sender;

//查看发票 action
- (IBAction)checkInvoiceAction:(UIButton *)sender;
//修改订单 action
- (IBAction)changeOrdersAction:(UIButton *)sender;
//去支付 action
- (IBAction)payAction:(UIButton *)sender;
//确认收货 action
- (IBAction)confirmCoodsAction:(UIButton *)sender;
//再次购买 action
- (IBAction)againBuyAction:(UIButton *)sender;

//申请售后 action
- (IBAction)afterSaleAction:(UIButton *)sender;

//跳转到店铺
//- (IBAction)goStoreAction:(UIButton *)sender;

//删除订单
- (IBAction)delOrderAction:(UIButton *)sender;


//待评星
- (IBAction)reviewStarAction:(UIButton *)sender;

@property(nonatomic, strong)NSMutableArray *goodsImagesArray;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


@end

@implementation OrdeMoreItmeTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self.listModel.amount isEqualToString:@"1"]) {
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        self.priceLabel.textAlignment = NSTextAlignmentRight;
    }
//   if ([self.listModel.num_type isEqualToString:@"2"]) {
//        self.priceLabel.textAlignment = NSTextAlignmentRight;
//    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.obligationView setHidden:YES];
      [self.receivingView setHidden:YES];
      [self.cancelView setHidden:YES];
      [self.completeView setHidden:YES];
     [self.waitingSendGoodsView setHidden:YES];
      
      [self.instructionsLabel setHidden:YES];
      [self.deleteButton setHidden:YES];
      [self.cancelLabel setHidden:YES];
      [self.completeImageView setHidden:YES];
      
      [self modifiedButton:self.reviewStarButton borderColor:KTextGray_96 cornerRadius:15];
    
    
    [self modifiedButton:self.obligationChangeOrdersButton borderColor:KTextGray_96 cornerRadius:15];
      
      [self modifiedButton:self.obligationCheckInvoiceButton borderColor:KTextGray_96 cornerRadius:15];
      
      [self modifiedButton:self.obligationPayButton borderColor:kMainYellow cornerRadius:15];
    
    
      
      [self modifiedButton:self.receivingCheckInvoiceButton borderColor:KTextGray_96 cornerRadius:15];
      
      [self modifiedButton:self.receivingCheckLogisticsButton borderColor:KTextGray_96 cornerRadius:15];
      
      [self modifiedButton:self.receivingConfirmCoodsButton borderColor:kMainYellow cornerRadius:15];
      
      [self modifiedButton:self.cancelAgainBuyButton borderColor:kMainYellow cornerRadius:15];
      
      [self modifiedButton:self.completeAfterSaleButton borderColor:KTextGray_96 cornerRadius:15];
      
      [self modifiedButton:self.completeCheckInvoiceButton borderColor:KTextGray_96 cornerRadius:15];
      
      [self modifiedButton:self.completeAgainBuyButton borderColor:kMainYellow cornerRadius:15];
    
    [self modifiedButton:self.waitingSendGoodsCheckInvoiceButton borderColor:KTextGray_96 cornerRadius:15];
    
    [self modifiedButton:self.completeCheckLogisticsButton borderColor:KTextGray_96 cornerRadius:15];

    
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([OrdeItemImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"OrdeItemImageCollectionViewCell"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsImagesArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(110, 110);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OrdeItemImageCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"OrdeItemImageCollectionViewCell" forIndexPath:indexPath];

    cell.imageStr = self.goodsImagesArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(ordeMoreItmeTableViewCell:tapCell:)] == YES) {
        [self.delegate ordeMoreItmeTableViewCell:self tapCell:self.listModel];
    }
}


///更新布局
- (void)updateLayout:(OrderListModel *)listModel{
    
    [self.obligationCheckInvoiceButton setHidden:YES];
    
    self.completeOperationViewW.constant = (ScreenWidth - 32);
    
    [self.orderNoLabel setText:[NSString stringWithFormat:SLLocalizedString(@"订单编号：%@"), listModel.orderCarSn]];
    
    
    NSString *status = listModel.status;
    
    if ([status isEqualToString:@"1"] == YES) {
        [self obligationLayout];
    }else if ([status isEqualToString:@"2"] == YES){
        [self.instructionsLabel setText:SLLocalizedString(@"等待发货")];
        [self waitingSendGoodsLayout];
    }else if ([status isEqualToString:@"3"] == YES) {
        [self.instructionsLabel setText:SLLocalizedString(@"已发货")];
        [self receivingLayout];
    }else if ([status isEqualToString:@"6"] == YES|| [status isEqualToString:@"7"] == YES) {
        [self.cancelLabel setText:SLLocalizedString(@"已取消")];
        [self cancelLayout];
    }else if ([status isEqualToString:@"4"] == YES ||[status isEqualToString:@"5"] == YES) {
        [self completeLayout];
        [self.cancelLabel setText:SLLocalizedString(@"已完成")];
        NSString *evaluate_status = listModel.evaluateStatus;
        //收货
        //是否评星  未评星显示，已评星隐藏
        if([evaluate_status isEqualToString:@"0"] == YES){
            [self.reviewStarButton setHidden:NO];
        }else{
            [self.reviewStarButton setHidden:YES];
        }
    }
    
    //    NSInteger numTotal = 0;
    //    for ( OrderStoreModel *storeItem  in orderStoreArray) {
    //        for (OrderGoodsModel *goodsItem in storeItem.goods) {
    //            numTotal += goodsItem.num.integerValue;
    //            if ([goodsItem.goods_image count]>0) {
    //                [self.goodsImagesArray addObject:goodsItem.goods_image[0]];
    //            }
    //        }
    //    }
    
    NSInteger numTotal = [listModel.amount integerValue];
    self.goodsImagesArray  = [listModel.goodsImages mutableCopy];
    //
    
    [self.collectionView reloadData];
    
    [self.numberLabel setText:[NSString stringWithFormat:SLLocalizedString(@"共%ld件"), (long)numTotal]];
    
    
    
    
    BOOL is_invoice = [listModel.isInvoice boolValue];
    NSString *buttonTitle = SLLocalizedString(@"查看发票");
    if (is_invoice == NO) {
        buttonTitle = SLLocalizedString(@"补开发票");
    }
    
    float goodsMoney = [listModel.money floatValue];
    
    if (goodsMoney == 0) {
        [self.receivingCheckInvoiceButton setHidden:YES];
        [self.waitingSendGoodsCheckInvoiceButton setHidden:YES];
        [self.completeCheckInvoiceButton setHidden:YES];
        [self.completeCheckInvoiceView setHidden:YES];
        self.completeOperationViewW.constant = self.completeOperationViewW.constant  - (self.completeOperationViewW.constant  / 4);
    }else{
        [self.receivingCheckInvoiceButton setHidden:NO];
        [self.waitingSendGoodsCheckInvoiceButton setHidden:NO];
        [self.completeCheckInvoiceButton setHidden:NO];
        
        [self.receivingCheckInvoiceButton setTitle:buttonTitle forState:UIControlStateNormal];
        [self.waitingSendGoodsCheckInvoiceButton setTitle:buttonTitle forState:UIControlStateNormal];
        [self.completeCheckInvoiceButton setTitle:buttonTitle forState:UIControlStateNormal];
        
        [self.completeCheckInvoiceView setHidden:NO];
        
        [self.completeCheckInvoiceButton setHidden:NO];
        
        //           self.completeOperationViewW.constant = self.completeOperationViewW.constant  - (self.completeOperationViewW.constant  / 4);
        
//        if ([listModel.isForeign isEqualToString:@"1"] && [buttonTitle isEqualToString:SLLocalizedString(@"补开发票")]) {
//            [self.receivingCheckInvoiceButton setHidden:YES];
//            [self.waitingSendGoodsCheckInvoiceButton setHidden:YES];
//            [self.completeCheckInvoiceButton setHidden:YES];
//            
//            
//            [self.completeCheckInvoiceView setHidden:YES];
//            self.completeOperationViewW.constant = self.completeOperationViewW.constant  - (self.completeOperationViewW.constant  / 4);
//        }
    }
    
}


///装饰button
- (void)modifiedButton:(UIButton *)sender borderColor:(UIColor *)color cornerRadius:(CGFloat)radius{
    sender.layer.borderWidth = 1;
    sender.layer.borderColor = color.CGColor;
//    sender.layer.cornerRadius = SLChange(radius);
    sender.layer.cornerRadius = sender.height/2;
    [sender.layer setMasksToBounds:YES];

}

///待付款
- (void)obligationLayout{
    [self.instructionsLabel setHidden:NO];
    [self.instructionsLabel setText:SLLocalizedString(@"等待付款")];
    [self.deleteButton setHidden:YES];
    [self.cancelLabel setHidden:YES];
    [self.completeImageView setHidden:YES];
    [self.obligationView setHidden:NO];
    [self.receivingView setHidden:YES];
    [self.cancelView setHidden:YES];
    [self.completeView setHidden:YES];
    [self.waitingSendGoodsView setHidden:YES];
}

///待收货
- (void)receivingLayout{
    [self.instructionsLabel setHidden:NO];
    
    [self.deleteButton setHidden:YES];
    [self.cancelLabel setHidden:YES];
    [self.completeImageView setHidden:YES];
    [self.obligationView setHidden:YES];
    [self.receivingView setHidden:NO];
    [self.cancelView setHidden:YES];
    [self.completeView setHidden:YES];
    [self.waitingSendGoodsView setHidden:YES];
}

///待发货
- (void)waitingSendGoodsLayout{
    [self.instructionsLabel setHidden:NO];
    
    [self.deleteButton setHidden:YES];
    [self.cancelLabel setHidden:YES];
    [self.completeImageView setHidden:YES];
    [self.obligationView setHidden:YES];
    [self.receivingView setHidden:YES];
    [self.cancelView setHidden:YES];
    [self.completeView setHidden:YES];
    [self.waitingSendGoodsView setHidden:NO];
}

///已取消
- (void)cancelLayout{
    [self.instructionsLabel setHidden:YES];
    [self.deleteButton setHidden:NO];
    [self.cancelLabel setHidden:NO];
    [self.completeImageView setHidden:YES];
    [self.obligationView setHidden:YES];
    [self.receivingView setHidden:YES];
    [self.cancelView setHidden:NO];
    [self.completeView setHidden:YES];
    [self.waitingSendGoodsView setHidden:YES];
}

///已完成
- (void)completeLayout{
    [self.instructionsLabel setHidden:YES];
    [self.deleteButton setHidden:NO];
//    [self.cancelLabel setHidden:YES];
[self.cancelLabel setHidden:NO];
//    [self.completeImageView setHidden:NO];
    [self.obligationView setHidden:YES];
    [self.receivingView setHidden:YES];
    [self.cancelView setHidden:YES];
    [self.completeView setHidden:NO];
     [self.waitingSendGoodsView setHidden:YES];
}

#pragma mark - action
//修改订单
- (IBAction)changeOrdersAction:(UIButton *)sender{
    NSLog(@"%s",__func__);
    
    if ([self.delegate respondsToSelector:@selector(ordeMoreItmeTableViewCell:changeOrders:)] == YES) {
        [self.delegate ordeMoreItmeTableViewCell:self changeOrders:self.listModel];
    }
    
    
}

//查看发票
- (IBAction)checkInvoiceAction:(UIButton *)sender {
    NSLog(@"%s",__func__);
    
    NSString*title = sender.titleLabel.text;
    
    if ([title isEqualToString:SLLocalizedString(@"补开发票")]) {
        
        if ([self.delegate respondsToSelector:@selector(ordeMoreItmeTableViewCell:repairInvoice:)] == YES) {
            [self.delegate ordeMoreItmeTableViewCell:self repairInvoice:self.listModel];
        }
        
    }else{
        if ([self.delegate respondsToSelector:@selector(ordeMoreItmeTableViewCell:lookInvoice:)] == YES) {
            [self.delegate ordeMoreItmeTableViewCell:self lookInvoice:self.listModel];
        }
    }
    
    

}

//去支付
- (IBAction)payAction:(UIButton *)sender{
    NSLog(@"%s",__func__);
    
    if ([self.delegate respondsToSelector:@selector(ordeMoreItmeTableViewCell:pay:)] == YES) {
        [self.delegate ordeMoreItmeTableViewCell:self pay:self.listModel];
    }

}

//查看物流
- (IBAction)checkLogisticsAction:(UIButton *)sender{
    NSLog(@"%s",__func__);
     if ([self.delegate respondsToSelector:@selector(ordeMoreItmeTableViewCell:lookLogistics:)] == YES) {
            [self.delegate ordeMoreItmeTableViewCell:self lookLogistics:self.listModel];
        }
}

//确认收货
- (IBAction)confirmCoodsAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(ordeMoreItmeTableViewCell:confirmReceipt:)] == YES) {
        [self.delegate ordeMoreItmeTableViewCell:self confirmReceipt:self.listModel];
    }

}

//再次购买
- (IBAction)againBuyAction:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(ordeMoreItmeTableViewCell:againBuy:)] == YES) {
        [self.delegate ordeMoreItmeTableViewCell:self againBuy:self.listModel];
    }
    
}

//申请售后
- (IBAction)afterSaleAction:(UIButton *)sender{
    NSLog(@"%s",__func__);
    if([self.delegate respondsToSelector:@selector(ordeMoreItmeTableViewCell:afterSales:)] == YES){
        [self.delegate ordeMoreItmeTableViewCell:self afterSales:self.listModel];
    }

}

//跳转到店铺
//- (IBAction)goStoreAction:(UIButton *)sender {
//
//    if([self.delegate respondsToSelector:@selector(ordeItmeTableViewCell:jumpStorePage:)] == YES){
//        [self.delegate ordeItmeTableViewCell:self jumpStorePage:self.listModel];
//    }
//}

//删除订单
- (IBAction)delOrderAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(ordeMoreItmeTableViewCell:delOrder:)] == YES) {
        [self.delegate ordeMoreItmeTableViewCell:self delOrder:self.listModel];
    }
}

//待评星
- (IBAction)reviewStarAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(ordeMoreItmeTableViewCell:reviewStar:)] == YES) {
        [self.delegate ordeMoreItmeTableViewCell:self reviewStar:self.listModel];
    }
}



#pragma mark - setter / getter

- (void)setListModel:(OrderListModel *)listModel{
    _listModel = listModel;
    [self.goodsImagesArray removeAllObjects];
    
   NSString *moneyStr = [NSString stringWithFormat:@"¥%@", listModel.money];
    
//    [self.priceLabel setText:[NSString stringWithFormat:@"¥%@", listModel.money]];
    [self.priceLabel setAttributedText:[moneyStr moneyStringWithFormatting:MoneyStringFormattingMoneyAllFormattingType]];
    
    
    
    [self updateLayout:listModel];
}

- (NSMutableArray *)goodsImagesArray{
    if (_goodsImagesArray == nil) {
        _goodsImagesArray = [NSMutableArray array];
    }
    return _goodsImagesArray;
}

@end
