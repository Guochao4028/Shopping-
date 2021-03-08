//
//  GoodsSpecificationView.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsSpecificationView.h"

#import "GoodsSpecificationHeardView.h"
#import "GoodsSpecificationBuyCountView.h"
#import "GoodsSpecificationFooterView.h"
#import "GoodsSpecificationTypeView.h"
#import "GoodsSpecificationModel.h"
#import "ShoppingCartGoodsModel.h"
#import "GoodsInfoModel.h"
#import "ShoppingCartNumberCountView.h"
#import "DataManager.h"
#import "GoodsAttrBasisModel.h"
#import "NSString+Tool.h"

@interface GoodsSpecificationView ()<UITextFieldDelegate, GoodsSpecificationTypeViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UIView *contentView;

//装载所有的view
@property(nonatomic, strong)UIScrollView *backgroundView;

@property(nonatomic, strong)GoodsSpecificationHeardView *heardView;

@property(nonatomic, strong)GoodsSpecificationFooterView *footerView;

@property(nonatomic, strong)UITableView *tabelView;

@property(nonatomic, strong)GoodsSpecificationTypeView *typeView;

@property(nonatomic, strong)GoodsSpecificationTypeView *nextTypeView;

@property(nonatomic, strong)GoodsSpecificationBuyCountView *buyCountView;

//保存一级规格
@property(nonatomic, strong)GoodsSpecificationModel *selecedTypeModel;

//保存二级规格
@property(nonatomic, strong)GoodsSpecificationModel *selecedNextTypeModel;

//库存
@property(nonatomic, assign)NSInteger stock;

@property(nonatomic, assign)NSInteger inventory;

@property(nonatomic, copy)NSString *currentPrice;
@property(nonatomic, copy)NSString *oldPrice;
//存储所有商品规格view
@property(nonatomic, strong)NSMutableArray *viewArray;
//存储选择的规格id
@property(nonatomic, strong)NSMutableArray *idsArray;
//存储选择的规格名称
@property(nonatomic, strong)NSMutableArray *namesArray;
//存储选择的规格标题
@property(nonatomic, strong)NSMutableArray *titleArray;
//规格所对应的商品信息数组
@property(nonatomic, strong)NSArray *goodsStoreInfoModelArray;
//存储当前规格商品信息
@property(nonatomic, strong)GoodsSpecificationModel *currentSpecificationModel;

//记录全部商品都有库存
@property(nonatomic, assign)BOOL isAllStock;

//记录当前规格是否有库存
@property(nonatomic, assign)BOOL isCurrentStock;

@property(nonatomic, strong)NSMutableArray *viewsDataArray;

//记录当前规格图片
@property(nonatomic, copy)NSString *attrGoodsImageStr;





@end

@implementation GoodsSpecificationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initData];
        [self initUI];
    }
    return self;
}

#pragma mark - methods

- (void)initData{
    self.inventory = 1;
    self.isAllStock = YES;
    self.isCurrentStock = YES;
}

- (void)initUI{
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    
    [self addSubview:self.contentView];
    
//    [self.contentView addSubview: self.backgroundView];
    
    [self.contentView addSubview:self.heardView];
    
    [self.contentView addSubview:self.tabelView];
    
//    [self.contentView addSubview:self.buyCountView];
//
    [self.contentView addSubview:self.footerView];
    
    
    __weak typeof(self)weakSelf = self;
    
    self.heardView.goodsSpecificationHeardBclok = ^{
            [weakSelf disappear];
        
    };
    
    [self.buyCountView.countView setNumberChangeBlock:^(NSInteger count) {
        weakSelf.inventory = count;
        if (weakSelf.buyCountView.countView.isModifyStock == YES) {
            [weakSelf.heardView setStockStr:[NSString stringWithFormat:@"%ld", count]];
        }
        
    }];
    
}

#pragma mark - action
//消失
- (void)disappear{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        NSMutableString *str = [NSMutableString string];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setValue:@(self.inventory) forKey:@"num"];
        
        NSMutableArray *joiningArray = [NSMutableArray array];
           for (int i = 0; i < [self.titleArray count]; i++) {
               
               NSString *str = [NSString stringWithFormat:@"%@：%@",self.titleArray[i], self.namesArray[i]];
               [joiningArray addObject:str];
           }
           
           NSString *namesStr= [joiningArray componentsJoinedByString:@"，"];
        
//        NSString *namesStr= [self.namesArray componentsJoinedByString:@","];
        
        [str appendString:namesStr];
        
        if (namesStr.length > 0) {
            [str appendString:@"，"];
        }
        
        [str appendString:[NSString stringWithFormat:SLLocalizedString(@"%@件"), @(self.inventory)]];
        
        [dic setValue:str forKey:@"attrS"];
        
        [dic setValue:self.model.goodsSpecificationId forKey:@"attrId"];
        
        [dic setValue:namesStr forKey:@"attrName"];
        
        [dic setValue:self.attrGoodsImageStr forKey:@"attrGoodsImage"];
        
        if (self.currentPrice != nil) {
            [dic setValue:self.currentPrice forKey:@"currentPrice"];
        }
        
        if (self.oldPrice != nil) {
            [dic setValue:self.oldPrice forKey:@"oldPrice"];
        }
        
        if (self.isCurrentStock) {
            if ([self.delegate respondsToSelector:@selector(getSpecification:)] == YES) {
                [self.delegate getSpecification:dic];
            }
        }
        
    }];
    
}

//立即购买
- (void)buyAction{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:@(self.inventory) forKey:@"num"];
    
    
    [dic setValue:self.model.goodsSpecificationId forKey:@"attrId"];
    
    NSMutableArray *joiningArray = [NSMutableArray array];
       for (int i = 0; i < [self.titleArray count]; i++) {
           
           NSString *str = [NSString stringWithFormat:@"%@：%@",self.titleArray[i], self.namesArray[i]];
           [joiningArray addObject:str];
       }
       
       NSString *namesStr= [joiningArray componentsJoinedByString:@","];
    
    [dic setValue:namesStr forKey:@"attrName"];;

    [dic setValue:self.attrGoodsImageStr forKey:@"attrGoodsImage"];
    
    
    if (self.currentPrice != nil) {
        [dic setValue:self.currentPrice forKey:@"currentPrice"];
    }
    
    if (self.oldPrice != nil) {
        [dic setValue:self.oldPrice forKey:@"oldPrice"];
    }
    
    if ([self.delegate respondsToSelector:@selector(tapBuy:)] == YES) {
        [self.delegate tapBuy:dic];
        [self disappear];
    }
}

//加入购物车
- (void)addCartAction{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSMutableString *str = [NSMutableString string];
    
    [dic setValue:@(self.inventory) forKey:@"num"];
    
    [dic setValue:self.model.goodsSpecificationId forKey:@"attrId"];
    
    NSString *namesStr= [self.namesArray componentsJoinedByString:@"，"];
    
    [str appendString:namesStr];
    
    [str appendString:[NSString stringWithFormat:SLLocalizedString(@" %@件"), @(self.inventory)]];
    
    
    [dic setValue:str forKey:@"attrS"];
    [dic setValue:namesStr forKey:@"attrName"];
    
    if (self.currentPrice != nil) {
        [dic setValue:self.currentPrice forKey:@"currentPrice"];
    }
    
    if (self.oldPrice != nil) {
        [dic setValue:self.oldPrice forKey:@"oldPrice"];
    }
    
    if ([self.delegate respondsToSelector:@selector(tapAddCart:)] == YES) {
        
        [self.delegate tapAddCart:dic];
//        [self disappear];
    }
}

//确定
- (void)determineAction{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(self.inventory) forKey:@"num"];
    
    if (self.currentSpecificationModel) {
        [dic setValue:self.currentSpecificationModel.specificationId forKey:@"attrId"];
    }
    
    [dic setValue:self.carGoodsModel.cartid forKey:@"cartId"];
    [dic setValue:self.carGoodsModel.goodsId forKey:@"goodsId"];

    if (self.currentPrice != nil) {
        [dic setValue:self.currentPrice forKey:@"currentPrice"];
    }
    if (self.oldPrice != nil) {
        [dic setValue:self.oldPrice forKey:@"oldPrice"];
    }
    
    NSMutableArray *joiningArray = [NSMutableArray array];
    for (int i = 0; i < [self.titleArray count]; i++) {
        
        NSString *str = [NSString stringWithFormat:@"%@：%@",self.titleArray[i], self.namesArray[i]];
        [joiningArray addObject:str];
    }
    
    NSString *namesStr= [joiningArray componentsJoinedByString:@","];
    
    [dic setValue:namesStr forKey:@"attrName"];

    [dic setValue:self.currentPrice forKey:@"currentPrice"];
    
    [dic setValue:[NSString stringWithFormat:@"%ld", self.stock] forKey:@"stock"];
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]changeGoodsAttr:dic Callback:^(Message *message) {
        [hud hideAnimated:YES];
        
        if (message.isSuccess) {
            [self disappear];
            if (self.saveBlock) {
                self.saveBlock(dic);
            }
        }else{
            [ShaolinProgressHUD singleTextHud:message.reason view:WINDOWSVIEW afterDelay:TipSeconds];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self disappear];
}

#pragma mark - GoodsSpecificationViewDelegate
- (void)goodsSpecificationTypeView:(GoodsSpecificationTypeView *)view selectedModel:(GoodsAttrBasisModel *)model allDataArray:(nonnull NSArray *)dataArray{
    for (GoodsAttrBasisModel *model in dataArray) {
        [model setIsSeleced:NO];
    }
    model.isSeleced = YES;
    
    NSInteger inde =[self.viewArray indexOfObject:view];
    
    [self.idsArray setObject:model.attrBasisId atIndexedSubscript:inde];
    
    [self.namesArray setObject:model.name atIndexedSubscript:inde];
    
    NSString *idsStr= [self.idsArray componentsJoinedByString:@","];
    
    
//    if (self.isAllStock == NO) {
//
//        //遍历所有规格组合，与已选规格进行匹配
//        for (GoodsSpecificationModel *model in self.goodsStoreInfoModelArray) {
//            NSArray *attArr = [model.attr_value_id_str componentsSeparatedByString:@","];
//            //总库存
//           NSInteger sunStock = [model.stock integerValue];
//           //已销售数
//           NSInteger hasStock = [model.has_number integerValue];
//           //计算库存数
//           NSInteger chaStock =  sunStock - hasStock;
//            if (chaStock == 0) {
//                //遍历当前规格匹配情况数组
//                for (int i = 0; i<containsArr.count; i++) {
//                    //如果匹配情况为0，则表示这个规格没被选中，可根据这个规格所在顺序，从这个规格的所有情况中找到它，如@[@"1",@"1",@"0"]，标识第三个规格没选，并且其中“2016”这个选项库存为0
//                    if ([[containsArr objectAtIndex:i] isEqualToString:@"0"]) {
////                        GoodsTypeModel *type = _model.itemsList[i];
////                        //记录第三个规格所有选项是否置灰情况
////                        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:type.enableArray];
////                        //遍历未选规格的所有选项
//                        for (int j = 0; j<dataArray.count; j++) {
//
//////                            //找到“2016”这个选项，禁用置灰设为0，不匹配的不做更改
//                            GoodsAttrBasisModel *basisModel = [dataArray objectAtIndex:j];
//                            if ([[attArr objectAtIndex:i] isEqualToString:basisModel.attrBasisId]) {
//                                basisModel.isOptional = YES;
//                            }
//                        }
////                        //重置未选规格的置灰情况数组
////                        type.enableArray = arr;
////                        //刷新规格列表
////                        [self.tableview reloadData];
//                    }
//
//                    NSLog(@"containsArr : %@", containsArr);
//                }
//            }
//        }
//
//
//    }
    
    
    
    
    for (GoodsSpecificationModel *specificationModel in self.goodsStoreInfoModelArray) {
        if([idsStr isEqualToString: specificationModel.attrValueIdStr]==YES){
            self.currentSpecificationModel = specificationModel;
            self.model.goodsSpecificationId = specificationModel.specificationId;
            self.inventory = 1;
            self.goodsNumber = nil;
            [self.buyCountView setGoodsNumber:self.goodsNumber];
            [self.buyCountView setModel:self.model];
            break;
        }
    }
    
    
    [view reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewsDataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id view = self.viewsDataArray[indexPath.row];
    
    if ([view isKindOfClass:[GoodsSpecificationTypeView class]]) {
        GoodsSpecificationTypeView *typeView =self.viewsDataArray[indexPath.row];
        
        return typeView.height+20;
    }else{
        return 50;
    }
    
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    UIView *view = self.viewsDataArray[indexPath.row];
    [cell.contentView addSubview:view];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - getter / setter

- (void)setModel:(GoodsInfoModel *)model{
    _model = model;
    
    [self.heardView setModel:model];
    
    self.attrGoodsImageStr = [self.model.imgDataList firstObject];

    
    
//    CGFloat y = CGRectGetMaxY(self.heardView.frame);
//    CGFloat width = CGRectGetWidth(self.contentView.bounds);
//    CGFloat buyCountViewY = 0.0;
    //取出所有的规格
    NSArray *attr = model.attr;//[model.attr firstObject];
    //解析所有规格商品信息

     self.goodsStoreInfoModelArray = [GoodsSpecificationModel mj_objectArrayWithKeyValuesArray:model.attrStr];
    
    
//    for (GoodsSpecificationModel *infoModel in self.goodsStoreInfoModelArray) {
//        //总库存
//        NSInteger sunStock = [infoModel.stock integerValue];
//        //已销售数
//        NSInteger hasStock = [infoModel.has_number integerValue];
//
//        //计算库存数
//        NSInteger chaStock =  sunStock - hasStock;
//
//        if (chaStock == 0) {
//            self.isAllStock = NO;
//        }
//    }
    
    
    
    if (attr.count > 0) {
        
        for (int i = 0 ; i < attr.count; i++) {
            
            NSDictionary *dataDic = attr[i];
            
           id dataModel =  dataDic[@"name"];
           if([dataModel isKindOfClass:[NSNull class]] == YES){
               return;
           }
            
            GoodsSpecificationTypeView *typeView =  [GoodsSpecificationTypeView goodsSpecificationTypeViewInit];
            
            [typeView setDelegate:self];
            
            NSArray *tmpArray = [GoodsAttrBasisModel mj_objectArrayWithKeyValuesArray:dataDic[@"attrList"]];
            
            NSArray *sortedArray = [tmpArray sortedArrayUsingComparator:^(GoodsAttrBasisModel *model1, GoodsAttrBasisModel *model2) {
                  NSInteger val1 = [model1.name length];
                  
                  NSInteger val2 = [model2.name length];
                  
                  if(val1 < val2){
                      return NSOrderedAscending;
                  }else{
                      return NSOrderedDescending;
                  }
              }];
              
            NSArray *dataArray = sortedArray;
            
            GoodsAttrBasisModel *tem = [dataArray firstObject];
            [tem setIsSeleced:YES];
            
            [typeView setDataArray:dataArray];
            
            NSString *titleStr = dataDic[@"name"];
            [typeView setTitleStr:titleStr];
            
            [self.viewArray addObject:typeView];
            
            [self.idsArray addObject:tem.attrBasisId];
            
            [self.namesArray addObject:tem.name];
            
//            [typeView setFrame:CGRectMake(0, y, width, typeView.height)];
            
            [typeView setFrame:CGRectMake(0, 0, ScreenWidth, typeView.height)];
            
//            [self.contentView addSubview:typeView];
            
//            y = CGRectGetMaxY(typeView.frame) +10;
            
//            buyCountViewY  = y;
            
            [self.titleArray addObject:titleStr];
            
            [self.viewsDataArray addObject:typeView];
        }
        
        if (self.goodsAttrId == nil) {
            
            NSString *idsStr= [self.idsArray componentsJoinedByString:@","];
            
            for (GoodsSpecificationModel *specificationModel in self.goodsStoreInfoModelArray) {
                if([idsStr isEqualToString: specificationModel.attrValueIdStr]==YES){
                    self.currentSpecificationModel = specificationModel;
                    break;
                }
                
            }
                model.goodsSpecificationId = self.currentSpecificationModel.specificationId;
                _model.goodsSpecificationId = self.currentSpecificationModel.specificationId;
           
        }else{
            
            for (GoodsSpecificationModel *specificationModel in self.goodsStoreInfoModelArray) {
                if([self.goodsAttrId isEqualToString: specificationModel.specificationId]==YES){
                    self.currentSpecificationModel = specificationModel;
                    _model.goodsSpecificationId = specificationModel.specificationId;
                    break;
                }
            }
            
            
             NSArray  *array = [self.currentSpecificationModel.attrValueIdStr componentsSeparatedByString:@","];
            
            
            if([array count] == [self.viewArray count]){
                for (int i = 0; i < self.viewArray.count; i++) {
                    NSString *idStr = array[i];
                    GoodsSpecificationTypeView *typeView = self.viewArray[i];
                    NSArray *dataArray = typeView.dataArray;
                    for (GoodsAttrBasisModel *basisModel in dataArray) {
                        if ([basisModel.attrBasisId isEqualToString:idStr] == YES) {
                            basisModel.isSeleced = YES;
                            NSInteger inde =[self.viewArray indexOfObject:typeView];
                            
                            [self.idsArray setObject:basisModel.attrBasisId atIndexedSubscript:inde];
                            
                            [self.namesArray setObject:basisModel.name atIndexedSubscript:inde];
                        }else{
                            basisModel.isSeleced = NO;
                        }
                    }
                    
                    [typeView reloadData];
                }
                
            }
            
        }
        
    }else{
//        buyCountViewY = y;
    }
    
    
//    [self.buyCountView setFrame:CGRectMake(0, buyCountViewY+7.5, width, 50)];
    [self.buyCountView setFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    [self.buyCountView setGoodsNumber:self.goodsNumber];
    [self.buyCountView setModel:model];
    
    [self.viewsDataArray addObject:self.buyCountView];
    [self.tabelView reloadData];
    
    
    
}


- (void)setCarGoodsModel:(ShoppingCartGoodsModel *)carGoodsModel{
    _carGoodsModel = carGoodsModel;
    self.goodsNumber = carGoodsModel.num;
}

- (UIView *)contentView{
    
    if (_contentView == nil) {
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) -200)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        
        _contentView.layer.cornerRadius = 12.5;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
    
}

- (UITableView *)tabelView{
    
    if (_tabelView == nil) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.heardView.frame), ScreenWidth, CGRectGetHeight(self.contentView.bounds) - 136 - 55)];
//        [_tabelView setTableFooterView:self.footerView];
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tabelView setDelegate:self];
        [_tabelView setDataSource:self];
        
        [_tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tabelView;

}

- (UIScrollView *)backgroundView{
    if (_backgroundView == nil) {
        
        _backgroundView = [[UIScrollView alloc]initWithFrame:self.contentView.bounds];
        [_backgroundView setBackgroundColor:[UIColor whiteColor]];
        
        [_backgroundView setContentSize:CGSizeMake(ScreenWidth, ScreenHeight)];
    }
    return _backgroundView;
}

- (GoodsSpecificationHeardView *)heardView{
    
    if (_heardView == nil) {
        _heardView = [[GoodsSpecificationHeardView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), 136)];
    }
    return _heardView;
}

- (GoodsSpecificationFooterView *)footerView{
    
    if (_footerView == nil) {
        CGFloat width = CGRectGetWidth(self.contentView.bounds);
        CGFloat y = CGRectGetHeight(self.contentView.bounds) - 55 - BottomMargin_X;
        _footerView = [[GoodsSpecificationFooterView alloc]initWithFrame:CGRectMake(0, y, width, 55)];
        
        [_footerView addCartTarget:self action:@selector(addCartAction)];
        
        [_footerView buyTarget:self action:@selector(buyAction)];
        
        [_footerView determineTarget:self action:@selector(determineAction)];
        
    }
    return _footerView;
    
}

- (GoodsSpecificationTypeView *)typeView{
    
    if (_typeView == nil) {
        _typeView = [GoodsSpecificationTypeView goodsSpecificationTypeViewInit];
    }
    return _typeView;
    
}

- (GoodsSpecificationTypeView *)nextTypeView{
    
    if (_nextTypeView == nil) {
        _nextTypeView = [GoodsSpecificationTypeView goodsSpecificationTypeViewInit];
    }
    return _nextTypeView;
    
}

- (GoodsSpecificationBuyCountView *)buyCountView{
    
    if (_buyCountView == nil) {
        CGFloat y = CGRectGetMaxY(self.heardView.frame);
        CGFloat width = CGRectGetWidth(self.contentView.bounds);
        _buyCountView = [[GoodsSpecificationBuyCountView alloc]initWithFrame:CGRectMake(0, y, width, 50)];
    }
    return _buyCountView;
    
}

- (void)setIsCart:(BOOL)isCart{
    [self.footerView setIsSingle:isCart];
}

- (NSMutableArray *)viewArray{
    if (_viewArray == nil) {
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
}

- (NSMutableArray *)idsArray{
    if (_idsArray == nil) {
        _idsArray = [NSMutableArray array];
    }
    return _idsArray;
}

- (NSMutableArray *)namesArray{
    if (_namesArray == nil) {
        _namesArray = [NSMutableArray array];
    }
    return _namesArray;
}

- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
           _titleArray = [NSMutableArray array];
       }
       return _titleArray;
}

- (void)setCurrentSpecificationModel:(GoodsSpecificationModel *)currentSpecificationModel{
    
    _currentSpecificationModel = currentSpecificationModel;
    
    [self.heardView setSpecificationModel:currentSpecificationModel];
    
    
    if (currentSpecificationModel.image != nil && currentSpecificationModel.image.length > 0) {
        [self.heardView setPicUrlStr:currentSpecificationModel.image];
        self.attrGoodsImageStr = currentSpecificationModel.image;
    }else{
        [self.heardView setPicUrlStr:@"1"];
        self.attrGoodsImageStr = [self.model.imgDataList firstObject];
    }
    
//    if ([self.model.isDiscount boolValue]) {
//        self.currentPrice = currentSpecificationModel.currentPrice;
//        self.oldPrice = currentSpecificationModel.price;
        self.oldPrice = [currentSpecificationModel.oldPrice formattedPrice];
        self.currentPrice = [currentSpecificationModel.price formattedPrice];
//    }else{
//         self.currentPrice = currentSpecificationModel.price;
//        self.currentPrice = [currentSpecificationModel.oldPrice formattedPrice];

//    }
    
    
//    if (currentSpecificationModel.current_price != nil && currentSpecificationModel.current_price.length > 0) {
//        [self.heardView setPriecStr:currentSpecificationModel.current_price];
//        self.currentPrice = currentSpecificationModel.current_price;
//    }
    
    
    
    if (currentSpecificationModel.stock != nil && currentSpecificationModel.stock.length > 0) {
        //总库存
        NSInteger sunStock = [currentSpecificationModel.stock integerValue];
        //已销售数
        NSInteger hasStock = [currentSpecificationModel.hasNumber integerValue];
        
        //计算库存数
        NSInteger chaStock =  sunStock - hasStock;
        
        self.stock = chaStock;
        
        if (chaStock >= 0) {
             [self.heardView setStockStr:[NSString stringWithFormat:@"%ld",chaStock]];
        }
        if (chaStock == 0) {
            [self.footerView setIsShowInsufficientInventory:YES];
            self.isCurrentStock = NO;
        }else{
            [self.footerView setIsShowInsufficientInventory:NO];
            self.isCurrentStock = YES;
        }
        
    }
}


- (NSMutableArray *)viewsDataArray{
    
    if (_viewsDataArray == nil) {
        _viewsDataArray = [NSMutableArray array];
    }
    return _viewsDataArray;

}

@end
