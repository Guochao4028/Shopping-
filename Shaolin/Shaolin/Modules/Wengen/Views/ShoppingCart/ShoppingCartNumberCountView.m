//
//  ShoppingCartNumberCountView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ShoppingCartNumberCountView.h"

#import "UIView+AutoLayout.h"

#import "ShoppingCartGoodsModel.h"

@interface ShoppingCartNumberCountView ()

//加
@property (nonatomic, strong) UIButton    *addButton;
//减
@property (nonatomic, strong) UIButton    *subButton;
//数字
//@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UITextField *numberTextField;

@property(nonatomic, assign)CGFloat width;

@property(nonatomic, assign)NumericalValidationType type;

@end

@implementation ShoppingCartNumberCountView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self initData];
    [self initUI];
}

#pragma mark - methods

- (void)initData{
    self.currentCountNumber = 0;
    self.totalNum = 0;
}

- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.subButton];
    //    [self addSubview:self.numberLabel];
    [self addSubview:self.numberTextField];
    [self addSubview:self.addButton];
    
    [self.addButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.addButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.addButton autoSetDimension:ALDimensionWidth toSize:30];
    [self.addButton autoSetDimension:ALDimensionHeight toSize:20];
    
    //    [self.numberLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.addButton withOffset:-7.5];
    //    [self.numberLabel autoSetDimension:ALDimensionWidth toSize:35];
    //    [self.numberLabel autoSetDimension:ALDimensionHeight toSize:20];
    //    [self.numberLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    //
    //
    //    [self.subButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.numberLabel withOffset:-7.5];
    //    [self.subButton autoSetDimension:ALDimensionWidth toSize:30];
    //    [self.subButton autoSetDimension:ALDimensionHeight toSize:20];
    //    [self.subButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    
    
    
    [self.numberTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.addButton withOffset:-7.5];
    [self.numberTextField autoSetDimension:ALDimensionWidth toSize:35];
    [self.numberTextField autoSetDimension:ALDimensionHeight toSize:20];
    [self.numberTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    
    
    [self.subButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.numberTextField withOffset:-7.5];
    [self.subButton autoSetDimension:ALDimensionWidth toSize:35];
    [self.subButton autoSetDimension:ALDimensionHeight toSize:20];
    [self.subButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    
    
    //    self.numberLabel.layer.masksToBounds = YES;
    //
    //    self.numberLabel.layer.cornerRadius = SLChange(4);
    
    
    self.numberTextField.layer.masksToBounds = YES;
    
    self.numberTextField.layer.cornerRadius = SLChange(4);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tepAction)];
    [self addGestureRecognizer:tap];
    
}

#pragma mark - action

- (void)tepAction{
    
}



- (void)addAction{
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    
    [self.numberTextField resignFirstResponder];
    //    NSString *text = self.numberLabel.text;
    NSString *text = self.numberTextField.text;
    
    NSInteger integerValue = ([text integerValue] +1);
    text = [NSString stringWithFormat:@"%ld",integerValue];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
//    if (self.checkType == CheckInventoryGoodsType) {
//        [dic setValue:self.goodsModel.goodsId forKey:@"goodsId"];
//
//        if(self.goodsModel.goodsAttrId != nil && self.goodsModel.goodsAttrId.length > 0){
//            [dic setValue:self.goodsModel.goodsAttrId forKey:@"attrId"];
//        }
        //        }else if(self.goodsModel.goods_attr_pid != nil && self.goodsModel.goods_attr_pid.length > 0){
        //            [dic setValue:self.goodsModel.goods_attr_pid forKey:@"goods_attr_id"];
        //        }
        
//    }else if(self.checkType == CheckInventoryCartType){
//        [dic setValue:self.goodsModel.cartid forKey:@"cartId"];
//        if(self.goodsModel.goodsAttrId != nil && self.goodsModel.goodsAttrId.length > 0){
//            [dic setValue:self.goodsModel.goodsAttrId forKey:@"attrId"];
//        }
//    }
        if (self.goodsModel.cartid != nil && self.goodsModel.cartid.length > 0) {
            [dic setValue:self.goodsModel.cartid forKey:@"cartId"];
        }
        
        if (self.goodsModel.goodsId != nil && self.goodsModel.goodsId.length > 0) {
            [dic setValue:self.goodsModel.goodsId forKey:@"goodsId"];
        }
        
        if(self.goodsModel.goodsAttrId != nil && self.goodsModel.goodsAttrId.length > 0){
            [dic setValue:self.goodsModel.goodsAttrId forKey:@"attrId"];
        }
    
    
    
    [dic setValue:text forKey:@"num"];
    [dic setValue:@"1" forKey:@"type"];
    
    [ModelTool calculateCountingChamber:integerValue numericalValidationType:NumericalValidationAddType param:dic check:self.checkType callBack:^(NSInteger currentCountNumber, BOOL isSuccess, Message *message) {
        [hud hideAnimated:YES];
        
        if (isSuccess == YES) {
            self.addButton.enabled = YES;
            self.subButton.enabled = YES;
            self.currentCountNumber = currentCountNumber;
            self.numberTextField.text = [NSString stringWithFormat:@"%@",text];
            //            self.numberLabel.text = [NSString stringWithFormat:@"%@",text];
            if (self.numberChangeBlock) {
                self.numberChangeBlock(currentCountNumber);
            }
        }else{
            self.addButton.enabled = NO;
        }
    }];
    
    //    [ModelTool calculateCountingChamber:integerValue numericalValidationType:NumericalValidationAddType param:dic  callBack:^(NSInteger currentCountNumber, BOOL isSuccess) {
    //
    //        if (isSuccess == YES) {
    //            self.addButton.enabled = YES;
    //            self.subButton.enabled = YES;
    //            self.currentCountNumber = currentCountNumber;
    //            self.numberLabel.text = [NSString stringWithFormat:@"%@",text];
    //            if (self.numberChangeBlock) {
    //                self.numberChangeBlock(currentCountNumber);
    //            }
    //        }else{
    //            self.addButton.enabled = NO;
    //        }
    //
    //    }];
    
    //    [[DataManager shareInstance]incrCarNum:dic Callback:^(Message *message) {
    //
    //        if (message.isSuccess) {
    //            self.addButton.enabled = YES;
    //            self.subButton.enabled = YES;
    //            self.currentCountNumber = text.integerValue;
    //            self.numberLabel.text = [NSString stringWithFormat:@"%@",text];
    //            if (self.numberChangeBlock) {
    //                self.numberChangeBlock(text.integerValue);
    //            }
    //        }else{
    //            self.addButton.enabled = NO;
    //        }
    //
    //    }];
    
    //    if (text.integerValue>self.totalNum&&self.totalNum!=0) {
    //
    //        self.currentCountNumber = self.totalNum;
    //        self.numberLabel.text = [NSString stringWithFormat:@"%@",@(self.totalNum)];
    //        changeNum = self.totalNum;
    //
    //        self.addButton.enabled = NO;
    //
    //    } else if (text.integerValue<1){
    //
    //        self.numberLabel.text = @"1";
    //        changeNum = 1;
    //
    //    } else {
    //
    //        self.addButton.enabled = YES;
    //        self.subButton.enabled = YES;
    //        self.currentCountNumber = text.integerValue;
    //        changeNum = self.currentCountNumber;
    //        self.numberLabel.text = [NSString stringWithFormat:@"%@",text];
    //    }
    //
    //    if (self.numberChangeBlock) {
    //        self.numberChangeBlock(changeNum);
    //    }
    
}

- (void)subAction{
    
    //    NSString *text = self.numberLabel.text;
    //    NSInteger changeNum = 0;
    //    NSInteger integerValue = ([text integerValue] -1);
    //    text = [NSString stringWithFormat:@"%ld",integerValue];
    //
    //    if (text.integerValue <= 1) {
    //
    //        self.numberLabel.text = @"1";
    //        changeNum = 1;
    //        self.subButton.enabled = NO;
    //
    //    }else{
    //        self.currentCountNumber = text.integerValue;
    //        changeNum = self.currentCountNumber;
    //        self.numberLabel.text = [NSString stringWithFormat:@"%@",text];
    //        self.subButton.enabled = YES;
    //
    //    }
    //
    //    if (self.numberChangeBlock) {
    //        self.numberChangeBlock(changeNum);
    //    }
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    //        NSString *text = self.numberLabel.text;
    [self.numberTextField resignFirstResponder];
    
    NSString *text = self.numberTextField.text;
    
    __block NSInteger changeNum = 0;
    NSInteger integerValue = ([text integerValue] -1);
    text = [NSString stringWithFormat:@"%ld",integerValue];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
//    if (self.checkType == CheckInventoryGoodsType) {
//        [dic setValue:self.goodsModel.goodsId forKey:@"goodsId"];
//
//        if(self.goodsModel.goodsAttrId != nil && self.goodsModel.goodsAttrId.length > 0){
//            [dic setValue:self.goodsModel.goodsAttrId forKey:@"goods_attr_id"];
//        }
//        //            else if(self.goodsModel.goods_attr_pid != nil && self.goodsModel.goods_attr_pid.length > 0){
//        //                [dic setValue:self.goodsModel.goods_attr_pid forKey:@"goods_attr_id"];
//        //            }
//
//
//    }else if(self.checkType == CheckInventoryCartType){
//        [dic setValue:self.goodsModel.cartid forKey:@"id"];
//    }
    
    if (self.goodsModel.cartid != nil && self.goodsModel.cartid.length > 0) {
        [dic setValue:self.goodsModel.cartid forKey:@"cartId"];
    }
    
    if (self.goodsModel.goodsId != nil && self.goodsModel.goodsId.length > 0) {
        [dic setValue:self.goodsModel.goodsId forKey:@"goodsId"];
    }
    
    if(self.goodsModel.goodsAttrId != nil && self.goodsModel.goodsAttrId.length > 0){
        [dic setValue:self.goodsModel.goodsAttrId forKey:@"attrId"];
    }
    
    [dic setValue:text forKey:@"num"];
    [dic setValue:@"2" forKey:@"type"];
    
    
    [ModelTool calculateCountingChamber:integerValue numericalValidationType:NumericalValidationSubType param:dic check:self.checkType callBack:^(NSInteger currentCountNumber, BOOL isSuccess, Message *message) {
        
        [hud hideAnimated:YES];
        
        if (isSuccess) {
            self.addButton.enabled = YES;
            self.subButton.enabled = YES;
            self.currentCountNumber = currentCountNumber;
            //            self.numberLabel.text = [NSString stringWithFormat:@"%@",text];
            self.numberTextField.text = [NSString stringWithFormat:@"%@",text];
            
            if (text.integerValue <= 1) {
                
                //                self.numberLabel.text = @"1";
                
                self.numberTextField.text = @"1";
                changeNum = 1;
                self.subButton.enabled = NO;
                
            }else{
                self.currentCountNumber = text.integerValue;
                changeNum = self.currentCountNumber;
                //                self.numberLabel.text = [NSString stringWithFormat:@"%@",text];
                self.numberTextField.text = [NSString stringWithFormat:@"%@",text];
                self.subButton.enabled = YES;
                
            }
            if (self.numberChangeBlock) {
                self.numberChangeBlock(changeNum);
            }
        }
        
        
    }];
    
    
    //        [[DataManager shareInstance]decrCarNum:dic Callback:^(Message *message) {
    //
    //            if (message.isSuccess) {
    //                self.addButton.enabled = YES;
    //                self.subButton.enabled = YES;
    //                self.currentCountNumber = text.integerValue;
    //    //            changeNum = self.currentCountNumber;
    //                self.numberLabel.text = [NSString stringWithFormat:@"%@",text];
    //
    //                if (text.integerValue <= 1) {
    //
    //                    self.numberLabel.text = @"1";
    //                    changeNum = 1;
    //                    self.subButton.enabled = NO;
    //
    //                }else{
    //                    self.currentCountNumber = text.integerValue;
    //                    changeNum = self.currentCountNumber;
    //                    self.numberLabel.text = [NSString stringWithFormat:@"%@",text];
    //                    self.subButton.enabled = YES;
    //
    //                }
    //                if (self.numberChangeBlock) {
    //                       self.numberChangeBlock(changeNum);
    //                   }
    //            }
    //        }];
}

#pragma mark - setter / getter

- (UIButton *)subButton{
    
    if (_subButton == nil) {
        //        _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _subButton = [UIButton newAutoLayoutView];
        
//        _subButton.frame = CGRectMake(0, 0, 20, 20);
        
        [_subButton setImage:[UIImage imageNamed:@"subNormal"] forState:UIControlStateNormal];
        
        [_subButton setImage:[UIImage imageNamed:@"subNo"] forState:UIControlStateDisabled];
        
        [_subButton.imageView setContentMode: UIViewContentModeScaleAspectFit];
        
        _subButton.tag = 0;
        [_subButton addTarget:self action:@selector(subAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _subButton;
    
}

//- (UILabel *)numberLabel{
//
//    if (_numberLabel == nil) {
////        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.subButton.frame)+7.5, 0, 20*1.5, 20)];
//
//        _numberLabel = [UILabel newAutoLayoutView];
//        _numberLabel.text=[NSString stringWithFormat:@"%@",@(1)];
//
//        _numberLabel.backgroundColor = [UIColor whiteColor];
//        _numberLabel.textColor = [UIColor blackColor];
//        _numberLabel.adjustsFontSizeToFitWidth = YES;
//
//        _numberLabel.textAlignment=NSTextAlignmentCenter;
//        _numberLabel.font= kMediumFont(14);
//        [_numberLabel setBackgroundColor:KTextGray_F3];
//
//
//
//    }
//    return _numberLabel;
//
//}


- (UITextField *)numberTextField{
    
    if (_numberTextField == nil) {
        //        _numberTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.subButton.frame)+7.5, 0, 20*1.5, 20)];
        
        _numberTextField = [UITextField newAutoLayoutView];
        
        [_numberTextField setKeyboardType:UIKeyboardTypeNumberPad];
        
        _numberTextField.text=[NSString stringWithFormat:@"%@",@(1)];
        _numberTextField.backgroundColor = [UIColor whiteColor];
        _numberTextField.textColor = [UIColor blackColor];
        _numberTextField.adjustsFontSizeToFitWidth = YES;
        _numberTextField.textAlignment=NSTextAlignmentCenter;
        _numberTextField.font= kMediumFont(14);
        
        [_numberTextField setBackgroundColor:KTextGray_F3];
        //        [_numberTextField setEnabled:NO];
        
        [_numberTextField addDoneOnKeyboardWithTarget:self action:@selector(customDone)];
        
    }
    return _numberTextField;
    
}

- (UIButton *)addButton{
    
    if (_addButton == nil) {
        //        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton = [UIButton newAutoLayoutView];
        
        //        _addButton.frame = CGRectMake(CGRectGetMaxX(_numberLabel.frame) +7.5, 0, 20,20);
        
        
        [_addButton setImage:[UIImage imageNamed:@"addNormal"] forState:UIControlStateNormal];
        
        [_addButton setImage:[UIImage imageNamed:@"addNo"] forState:UIControlStateDisabled];
        
        [_addButton.imageView setContentMode: UIViewContentModeScaleAspectFit];
        _addButton.tag = 1;
        
        [_addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
    
}

- (void)setGoodsModel:(ShoppingCartGoodsModel *)goodsModel{
    _goodsModel = goodsModel;
    
    //    [self.numberLabel setText:[NSString stringWithFormat:@"%@", goodsModel.num]];
    [self.numberTextField setText:[NSString stringWithFormat:@"%@", goodsModel.num]];
    
    NSInteger num = [goodsModel.num integerValue];
    
    [self.addButton setEnabled:YES];
    
    if (num > 1) {
        [self.subButton setEnabled:YES];
    }else{
        [self.subButton setEnabled:NO];
    }
    
    self.totalNum = [goodsModel.stock integerValue];
}

- (void)customDone{
    
    NSString *text = self.numberTextField.text;
    __block NSInteger changeNum = 0;
    NSInteger integerValue = ([text integerValue]);
    text = [NSString stringWithFormat:@"%ld",integerValue];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
//    if (self.checkType == CheckInventoryGoodsType) {
//        [dic setValue:self.goodsModel.goodsId forKey:@"goods_id"];
//
//        if(self.goodsModel.goodsAttrId != nil && self.goodsModel.goodsAttrId.length > 0){
//            [dic setValue:self.goodsModel.goodsAttrId forKey:@"goods_attr_id"];
//        }
//        //        else if(self.goodsModel.goods_attr_pid != nil && self.goodsModel.goods_attr_pid.length > 0){
//        //            [dic setValue:self.goodsModel.goods_attr_pid forKey:@"goods_attr_id"];
//        //        }
//
//
//    }else if(self.checkType == CheckInventoryCartType){
//        [dic setValue:self.goodsModel.cartid forKey:@"id"];
//    }
//
    
    if (self.goodsModel.cartid != nil && self.goodsModel.cartid.length > 0) {
        [dic setValue:self.goodsModel.cartid forKey:@"cartId"];
    }
    
    if (self.goodsModel.goodsId != nil && self.goodsModel.goodsId.length > 0) {
        [dic setValue:self.goodsModel.goodsId forKey:@"goodsId"];
    }
    
    if(self.goodsModel.goodsAttrId != nil && self.goodsModel.goodsAttrId.length > 0){
        [dic setValue:self.goodsModel.goodsAttrId forKey:@"attrId"];
    }
    
    
    [dic setValue:text forKey:@"num"];
    
    if (integerValue > self.currentCountNumber) {
        self.type = NumericalValidationAddType;
        
        [dic setValue:@"1" forKey:@"type"];
    }else{
        self.type = NumericalValidationSubType;
        [dic setValue:@"2" forKey:@"type"];

    }
    
    
    
    [ModelTool calculateCountingChamber:integerValue numericalValidationType:self.type param:dic check:self.checkType callBack:^(NSInteger currentCountNumber, BOOL isSuccess, Message *message) {
        
        if (isSuccess) {
            self.addButton.enabled = YES;
            self.subButton.enabled = YES;
            self.currentCountNumber = currentCountNumber;
            self.numberTextField.text = [NSString stringWithFormat:@"%@",text];
            
            if (text.integerValue <= 1) {
                
                self.numberTextField.text = @"1";
                changeNum = 1;
                self.subButton.enabled = NO;
                
            }else{
                self.currentCountNumber = text.integerValue;
                changeNum = self.currentCountNumber;
                //                self.numberLabel.text = [NSString stringWithFormat:@"%@",text];
                self.numberTextField.text = [NSString stringWithFormat:@"%@",text];
                self.subButton.enabled = YES;
                
            }
            if (self.numberChangeBlock) {
                self.numberChangeBlock(changeNum);
                [self.numberTextField resignFirstResponder];
            }
        }else{
            self.addButton.enabled = NO;
            self.subButton.enabled = YES;
            self.isModifyStock = YES;
            if (message.extension != nil) {
                self.numberTextField.text = [NSString stringWithFormat:@"%@",message.extension];
                NSString *text = self.numberTextField.text;
                self.currentCountNumber = text.integerValue;
                changeNum = self.currentCountNumber;
                if (self.numberChangeBlock) {
                    self.numberChangeBlock(changeNum);
                    
                }
            }
            [self.numberTextField resignFirstResponder];
            
        }
    }];
}

- (void)refreshUI{
    
    self.subButton.enabled = NO;
    self.addButton.enabled = YES;
    [self.numberTextField setText:@"1"];
    [self initData];
    
}



@end
