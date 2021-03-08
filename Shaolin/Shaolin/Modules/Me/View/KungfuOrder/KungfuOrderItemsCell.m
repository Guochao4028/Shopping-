//
//  KungfuOrderItemsCell.m
//  Shaolin
//
//  Created by ws on 2020/5/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuOrderItemsCell.h"
#import "OrderListModel.h"
#import "OrderStoreModel.h"
#import "OrderGoodsModel.h"
#import "OrdeItemImageCollectionViewCell.h"

@interface KungfuOrderItemsCell() <UICollectionViewDelegate,UICollectionViewDataSource>


//服务订单号
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;

/******已完成****/
@property (weak, nonatomic) IBOutlet UIView *completeView;
//查看发票
@property (weak, nonatomic) IBOutlet UIButton *completeCheckInvoiceButton;
//去支付
@property (weak, nonatomic) IBOutlet UIButton *obligationPayButton;
@property (weak, nonatomic) IBOutlet UIView *obligationView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIButton *playVideoBtn;
@property(nonatomic, strong)NSMutableArray *goodsImagesArray;
@property(nonatomic, strong)NSMutableArray *goodsArray;

@end

@implementation KungfuOrderItemsCell


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self.orderModel.amount isEqualToString:@"1"]) {
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
    }else{
//        ([self.orderModel.num_type isEqualToString:@"2"]) {
        self.priceLabel.textAlignment = NSTextAlignmentRight;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.obligationView setHidden:YES];
    [self.completeView setHidden:YES];
     
      
    [self.instructionsLabel setHidden:YES];
    [self.deleteButton setHidden:YES];
    [self.cancelLabel setHidden:YES];

    
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
    
//    OrderGoodsModel *goodsItem = self.goodsArray[indexPath.row];
    
    if ([self.orderModel.type intValue] == 2) {
        // 教程
        cell.playIcon.hidden = NO;
    } else {
        cell.playIcon.hidden = YES;
    }
    
    return cell;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if(!self.userInteractionEnabled || self.hidden || self.alpha<=0.01){
        return nil;
    }
    
    UIView *v = [super hitTest:point withEvent:event];

    if ([v isKindOfClass:[UICollectionView class]] ||
        [v.superview isKindOfClass:[OrdeItemImageCollectionViewCell class]] ||
        [v isKindOfClass:[OrdeItemImageCollectionViewCell class]]) {
        return self;
    }
    return v;
}

///更新布局
- (void)updateLayout:(OrderListModel *)listModel{
   
    [self.orderNoLabel setText:[NSString stringWithFormat:SLLocalizedString(@"订单编号：%@"), listModel.orderCarSn]];
//    NSArray *orderStoreArray = listModel.order_goods;
//
//    OrderStoreModel *storeModel = [orderStoreArray firstObject];
//
//    NSArray *orderGoodsArray = storeModel.goods;
//
//    OrderGoodsModel *goodsModel = [orderGoodsArray firstObject];
    

    NSString *status = listModel.status;

    if ([status isEqualToString:@"1"] == YES) {
        [self obligationLayout];
    }else if ([status isEqualToString:@"6"] == YES|| [status isEqualToString:@"7"] == YES) {
        [self cancelLayout];
    }else if ([status isEqualToString:@"4"] == YES ||[status isEqualToString:@"5"] == YES) {
        [self completeLayout];
    }
    
    NSInteger numTotal = [listModel.amount integerValue];
    self.goodsImagesArray = [listModel.goodsImages mutableCopy];
//    [self.goodsArray addObject:goodsItem];

//    for ( OrderStoreModel *storeItem  in orderStoreArray) {
//        for (OrderGoodsModel *goodsItem in storeItem.goods) {
//            numTotal += goodsItem.num.integerValue;
//            if ([goodsItem.goods_image count]>0) {
//                [self.goodsImagesArray addObject:goodsItem.goods_image[0]];
//                [self.goodsArray addObject:goodsItem];
//            }
//        }
//    }
    
    [self.collectionView reloadData];
    
    [self.numberLabel setText:[NSString stringWithFormat:SLLocalizedString(@"共%ld件"), (long)numTotal]];
    
    
    BOOL is_invoice = [listModel.isInvoice boolValue];
          NSString *buttonTitle = SLLocalizedString(@"查看发票");
          if (is_invoice == NO) {
              buttonTitle = SLLocalizedString(@"补开发票");
          }
       
       
       float goodsMoney = [listModel.money floatValue];
       
       if (goodsMoney == 0) {
           [self.completeCheckInvoiceButton setHidden:YES];
            
       }else{
           [self.completeCheckInvoiceButton setHidden:NO];
           [self.completeCheckInvoiceButton setTitle:buttonTitle forState:UIControlStateNormal];
       }
    
    
}

///待付款
- (void)obligationLayout{
    [self.instructionsLabel setHidden:NO];
    [self.instructionsLabel setText:SLLocalizedString(@"等待付款")];
    [self.deleteButton setHidden:YES];
    [self.cancelLabel setHidden:YES];
    [self.obligationView setHidden:NO];
    [self.completeView setHidden:YES];
}

///已取消
- (void)cancelLayout{
    [self.instructionsLabel setHidden:YES];
    [self.deleteButton setHidden:NO];
    [self.cancelLabel setHidden:NO];
    [self.obligationView setHidden:YES];
    [self.completeView setHidden:YES];
}

///已完成
- (void)completeLayout{
    [self.instructionsLabel setHidden:YES];
    [self.deleteButton setHidden:NO];
    [self.cancelLabel setHidden:YES];
    [self.obligationView setHidden:YES];
    [self.completeView setHidden:NO];
}


#pragma mark - setter / getter
- (void)setOrderModel:(OrderListModel *)orderModel {
    _orderModel = orderModel;
    
    [self.goodsImagesArray removeAllObjects];
    [self.priceLabel setText:orderModel.money];
    [self updateLayout:orderModel];
}

- (NSMutableArray *)goodsImagesArray{
    if (_goodsImagesArray == nil) {
        _goodsImagesArray = [NSMutableArray array];
    }
    return _goodsImagesArray;
}

- (NSMutableArray *)goodsArray {
    if (_goodsArray == nil) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}

- (IBAction)deleteHandle:(UIButton *)sender {
    if (self.deleteHandle) {
        self.deleteHandle();
    }
}

- (IBAction)payHandle:(UIButton *)sender {
    if (self.payHandle) {
        self.payHandle();
    }
}


- (IBAction)playVideoHandle:(UIButton *)sender {
    if (self.playVideo) {
        self.playVideo();
    }
}

- (IBAction)checkInvoiceHandle:(UIButton *)sender {
    
    
     NSString *title = sender.titleLabel.text;
      if ([title isEqualToString:SLLocalizedString(@"补开发票")]) {
          if (self.repairInvoice) {
              self.repairInvoice();
          }
      }else{
          if (self.checkInvoice) {
              self.checkInvoice();
          }
      }
//    if (self.checkInvoice) {
//        self.checkInvoice();
//    }
}


@end
