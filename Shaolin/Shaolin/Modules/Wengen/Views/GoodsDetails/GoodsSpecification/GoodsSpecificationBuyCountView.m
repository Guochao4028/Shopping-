//
//  GoodsSpecificationBuyCountView.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsSpecificationBuyCountView.h"

#import "ShoppingCartNumberCountView.h"

#import "ShoppingCartGoodsModel.h"

#import "GoodsInfoModel.h"

#import "GoodsSpecificationModel.h"

@interface GoodsSpecificationBuyCountView ()<UITextFieldDelegate>

@end

@implementation GoodsSpecificationBuyCountView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark - methods
-(void)initUI{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.titleLabel];
    [self addSubview:self.countView];
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

#pragma mark - settet / getter

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, 30, 20)];
        _titleLabel.text = SLLocalizedString(@"数量");
        _titleLabel.textColor = KTextGray_333;
        _titleLabel.font = kMediumFont(14);
        
    }
    return _titleLabel;
}

-(ShoppingCartNumberCountView *)countView{
    
    if (_countView == nil) {
        CGFloat x =  CGRectGetWidth(self.frame) - 16 - 127;
        _countView = [[ShoppingCartNumberCountView alloc]initWithFrame:CGRectMake(x, 26, 127, 30)];
        [_countView setCheckType:CheckInventoryGoodsType];
    }
    return _countView;
    
}

-(void)setModel:(GoodsInfoModel *)model{
    _model = model;
    ShoppingCartGoodsModel *cartGoodModel = [[ShoppingCartGoodsModel alloc]init];
    
    cartGoodModel.goods_id = model.goodsid;
    cartGoodModel.num = self.goodsNumber == nil?@"1":self.goodsNumber ;
    cartGoodModel.stock = model.stock;
    
    
//    if (model.attr.count > 0) {
//
//        GoodsSpecificationModel *item;
//        for (int i = 0; i < model.attr.count; i++) {
//            GoodsSpecificationModel *temp =  model.attr[i];
//            if (temp.isSeleced == YES) {
//                item = temp;
//                break;
//            }
//        }
//
//        NSArray *tempArray =  item.nextAttr;
//        GoodsSpecificationModel *nextItem;
//        if (tempArray.count > 0) {
//
//            for (int i = 0; i < tempArray.count; i++) {
//                GoodsSpecificationModel *temp =  tempArray[i];
//                if (temp.isSeleced == YES) {
//                    nextItem = temp;
//                    break;
//                }
//            }
//        }
//        cartGoodModel.goods_attr_pid = item.specificationId;
//        cartGoodModel.attr_p_value = item.value;
//        cartGoodModel.attr_p_name = item.name;
//
//        cartGoodModel.goods_attr_id = nextItem.specificationId;
//        cartGoodModel.attr_name = nextItem.name;
//        cartGoodModel.attr_value = nextItem.value;
//    }
    
    cartGoodModel.goods_attr_id = model.goodsSpecificationId;
    [self.countView setCheckType:CheckInventoryGoodsType];
    [self.countView setGoodsModel:cartGoodModel];
}

-(void)setCarGoodsModel:(ShoppingCartGoodsModel *)carGoodsModel{
    _carGoodsModel = carGoodsModel;
    [self.countView setCheckType:CheckInventoryCartType];
    [self.countView setGoodsModel:carGoodsModel];
}

-(void)refreshUI{
    [self.countView refreshUI];
}



@end
