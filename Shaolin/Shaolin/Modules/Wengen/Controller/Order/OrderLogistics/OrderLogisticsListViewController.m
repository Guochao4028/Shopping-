//
//  OrderLogisticsListViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderLogisticsListViewController.h"

#import "OrderDetailsModel.h"

#import "OrderStoreModel.h"

#import "OrderLogisticsTableViewCell.h"

#import "WengenWebViewController.h"

#import "OrderDetailsNewModel.h"

#import "DefinedHost.h"
#import "DataManager.h"

@interface OrderLogisticsListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UILabel *promptTitleLabel;

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSArray *dataArray;
///记录订单状态
@property(nonatomic, strong)NSString *orderStatus;


@end

@implementation OrderLogisticsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)initUI{
    
    [self.titleLabe setText:SLLocalizedString(@"查看物流")];
    [self.view addSubview:self.promptTitleLabel];
    [self.view addSubview:self.tableView];
    
}

- (void)initData{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getOrderInfo:@{@"id":self.orderId} Callback:^(NSObject *object) {
        [hud hideAnimated:YES];
        
        if ([object isKindOfClass:[OrderDetailsNewModel class]]) {
            OrderDetailsNewModel *detailsModel = (OrderDetailsNewModel *)object;
            //处理数据
            [self processData:detailsModel];
            [self.tableView reloadData];
        }
        
//        if([object isKindOfClass:[NSArray class]] == YES){
//            NSArray *tmpArray = (NSArray *)object;
//            NSString *status = @"9";
//            for (OrderDetailsModel *model in tmpArray) {
//                int statusInt = [model.status intValue];
//                int temStatusInt = [status intValue];
//                if(temStatusInt > statusInt){
//                    status = model.status;
//                }
//
//                if (statusInt > 2) {
//                    self.orderStatus = model.status;
//                }
//            }
//
//            [self assembleData:tmpArray];
//
//            [self.tableView reloadData];
//        }
    }];
}

- (void)assembleData:(NSArray *)dataArray{
    
    float goodsPricef = 0.0;
    
    float shipping_fee = 0.0;
    
    for (OrderDetailsModel *model in dataArray) {
        float singleGoodsPrice = [model.final_price floatValue] *[model.num integerValue];
        goodsPricef +=singleGoodsPrice;
        
        float singleGoodsFee = [model.shipping_fee floatValue];
        shipping_fee += singleGoodsFee;
    }
    // 过滤 快递单号
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //循环 取出店铺 及 店铺所有商品
    for (OrderDetailsModel *detailsModel in dataArray ) {
        [dic setValue:detailsModel.logistics_no forKey:detailsModel.logistics_no];
    }
    //是否是统一快递单号
    BOOL isUnifiedNumber;
    //数组数为一，就是统一快递单号
    if ([[dic allValues] count] == 1) {
        isUnifiedNumber = YES;
    }else{
        isUnifiedNumber = NO;
    }
    
    [self.promptTitleLabel setText:[NSString stringWithFormat:SLLocalizedString(@"%ld个包裹已发出"), [[dic allValues] count]]];
    
    
    NSMutableArray *goodsListArray = [NSMutableArray array];
    
    if (isUnifiedNumber == NO) {
        
        for (NSString *numberStr in [dic allValues]) {
            NSMutableArray *itemArray = [NSMutableArray array];
            
            for (OrderDetailsModel *goodsModel in dataArray) {
                if ([goodsModel.logistics_no isEqualToString:numberStr] == YES) {
                    [itemArray addObject:goodsModel];
                }
            }
            
            OrderDetailsModel *goodsModel;
            //商品图片
            NSMutableArray *goodsImagesArray = [NSMutableArray array];
             //订单号数组
            NSMutableArray *tempOrderIdArray = [NSMutableArray array];
            for (OrderDetailsModel *detailsModel in itemArray) {
                NSArray *imageArray = detailsModel.goods_image;
                goodsModel = detailsModel;
                //存商品图片
                [goodsImagesArray addObject:[imageArray firstObject]];
                //存订单号
                [tempOrderIdArray addObject:goodsModel.order_no];
            }
            
       
            
            goodsModel.goods_image = goodsImagesArray;
             //处理订单号
            NSString *orderIdsStr = [tempOrderIdArray componentsJoinedByString:@","];
            //保存订单号
            goodsModel.allOrderNoStr = orderIdsStr;
            
            [goodsListArray addObject:goodsModel];
        }
        
    }else{
        OrderDetailsModel *goodsModel;
        //商品图片
        NSMutableArray *goodsImagesArray = [NSMutableArray array];
        //订单号数组
         NSMutableArray *tempOrderIdArray = [NSMutableArray array];
        for (OrderDetailsModel *detailsModel in dataArray) {
            NSArray *imageArray = detailsModel.goods_image;
            goodsModel = detailsModel;
             //存商品图片
            [goodsImagesArray addObject:[imageArray firstObject]];
            
            //存订单号
            [tempOrderIdArray addObject:goodsModel.order_no];
        }
        
        //处理订单号
        NSString *orderIdsStr = [tempOrderIdArray componentsJoinedByString:@","];
        //保存订单号
        goodsModel.allOrderNoStr = orderIdsStr;
        goodsModel.goods_image = goodsImagesArray;
        
        [goodsListArray addObject:goodsModel];
        
    }
    
    self.dataArray = [NSArray arrayWithArray:goodsListArray];
 
}

- (void)processData:(OrderDetailsNewModel *)model{
    
    NSDictionary *dic = [self isUnifiedNumber:model];
    /**
     packetDic 存放 快递公司 和 快递单号
     格式 @{ 快递公司 ：[快递单号 (数组)] }
     */
    NSDictionary *packetDic = dic[@"packet"];
//    BOOL isUnifiedNumber = [dic[@"isUnifiedNumber"] boolValue];
//    //是否是统一快递单号
//    if (isUnifiedNumber == YES) {
//        //是统一快递单号
//        self.dataArray = [self dealUnderTrackingNumberGoods:packetDic baseModel:model];
//    }else{
//        //不是统一快递单号
//       self.dataArray = [self dealUnderTrackingNumberGoods:packetDic baseModel:model];
//
//    }
    
    // 拼接数据 不管是否是 统一快递单号 都可以用这个方法来解析
    self.dataArray = [self dealUnderTrackingNumberGoods:packetDic baseModel:model];
    
    [self.promptTitleLabel setText:[NSString stringWithFormat:SLLocalizedString(@"%ld个包裹已发出"), [ self.dataArray count]]];
}

#pragma mark - 判断是否是统一快递单号
-(NSDictionary *)isUnifiedNumber:(OrderDetailsNewModel *)model{
    
    BOOL isUnifiedNumber = YES;
    
    // 过滤 快递单号
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //暂存快递公式名称
    NSString *courierCompanyStr;
    //1,取出所有的快递公司
    for (OrderDetailsGoodsModel *goodsModel in model.goods) {
        if (![courierCompanyStr isEqualToString:goodsModel.logisticsName]) {
            [dic setValue:@"" forKey:goodsModel.logisticsName];
            courierCompanyStr = goodsModel.logisticsName;
        }
    }
    
    //2,取出所有的快递公式 对应的快递单号
    for (NSString *logisticsName in [dic allKeys]) {
        //暂存 统一快递公司下的所有的快递单号
        NSMutableArray *logisticsNoArray = [NSMutableArray array];
        for (OrderDetailsGoodsModel *goodsModel in model.goods) {
            if ([logisticsName isEqualToString:goodsModel.logisticsName]) {
                
                [logisticsNoArray addObject:goodsModel.logisticsNo];
            }
        }
        NSSet *set = [NSSet setWithArray:logisticsNoArray];
        [dic setValue:[set allObjects] forKey:logisticsName];
    }
    
    /**
     [dic allKeys] 存储的是快递公司的名称。
     不为1，代表不是一个快递公式 直接返回no
     为1，判断 value 对应的单号数组 是否为1 ，不为1返回no
     */
    if ([[dic allKeys] count] == 1) {
        NSArray *logisticsNoArray = [dic objectForKey:courierCompanyStr];
        if ([logisticsNoArray count] != 1) {
            isUnifiedNumber = NO;
        }
    }else{
        isUnifiedNumber = NO;
    }
    
    return  @{@"packet":dic, @"isUnifiedNumber":@(isUnifiedNumber)};
}

#pragma mark - 处理 不是统一快递单号 下的商品

-(NSArray *)dealUnderTrackingNumberGoods:(NSDictionary *)packetDic baseModel:(OrderDetailsNewModel *)model{
    
    NSMutableArray *goodsListArray = [NSMutableArray array];
    
    for (NSString *logisticsName in [packetDic allKeys]) {
        NSArray *logisticsNoArray = [packetDic objectForKey:logisticsName];
        
        for (NSString *logisticsNo in logisticsNoArray) {
            //暂存所有在 统一 快递单号 下的商品
            NSMutableArray *itemArray = [NSMutableArray array];
            // 遍历所有的商品 并 存储
            for (OrderDetailsGoodsModel *goodsModel in model.goods) {
                if ([goodsModel.logisticsNo isEqualToString:logisticsNo] == YES) {
                    [itemArray addObject:goodsModel];
                }
            }
            
            //暂存数据  整合商品
            OrderDetailsNewModel *tempNewModel = [[OrderDetailsNewModel alloc]init];
            //商品图片
            NSMutableArray *goodsImagesArray = [NSMutableArray array];
             //订单号数组
            NSMutableArray *tempOrderIdArray = [NSMutableArray array];
            
            for (OrderDetailsGoodsModel *goodsModel in model.goods) {
                
                if ([goodsModel.logisticsNo isEqualToString:logisticsNo] == YES) {
                    //存商品图片
                    [goodsImagesArray addObject:[goodsModel.goodsImages firstObject]];
                    //存订单号
                    [tempOrderIdArray addObject:goodsModel.orderId];
                    
                    tempNewModel.status = model.status;
                }
                
            }
            
            tempNewModel.goodsImages  = goodsImagesArray;
             //处理订单号
            NSString *orderIdsStr = [tempOrderIdArray componentsJoinedByString:@","];
            //保存订单号
            tempNewModel.allOrderNoStr = orderIdsStr;
            
            tempNewModel.logisticsNo = logisticsNo;
            tempNewModel.logisticsName = logisticsName;
            
            tempNewModel.orderSn = model.orderSn;
            
            
            
            [goodsListArray addObject:tempNewModel];
            
        }
    }
    
    return goodsListArray;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 245;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderLogisticsTableViewCell *logisticsCell = [tableView dequeueReusableCellWithIdentifier:@"OrderLogisticsTableViewCell"];
    
    [logisticsCell setGoodsModel:self.dataArray[indexPath.row]];
    
    WEAKSELF
    
    [logisticsCell setLookLogisticsBlock:^(OrderDetailsNewModel * _Nonnull goodsModel) {
        [weakSelf jumpLogidstivcs:goodsModel];
    }];
    logisticsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return logisticsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)jumpLogidstivcs:(OrderDetailsNewModel * _Nonnull) goodsModel{
    
    
    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
    
    NSArray  *array = [goodsModel.allOrderNoStr componentsSeparatedByString:@","];
    
    NSString *urlStr =  URL_H5_OrderTrack([array firstObject], appInfoModel.accessToken);

    WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:SLLocalizedString(@"订单跟踪")];
    [self.navigationController pushViewController:webVC animated:YES];
    
}




#pragma mark - setter / getter

- (UILabel *)promptTitleLabel{
    
    if (_promptTitleLabel == nil) {
        _promptTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, ScreenWidth - 16, 50)];
        
        [_promptTitleLabel setFont:kRegular(14)];
        [_promptTitleLabel setTextColor:kMainYellow];
        [_promptTitleLabel setBackgroundColor:[UIColor colorForHex:@"F9F9F9"]];
    }
    return _promptTitleLabel;

}

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        CGFloat y = CGRectGetMaxY(self.promptTitleLabel.frame);
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight - NavBar_Height - y)];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
//        [_tableView registerClass:[OrderLogisticsTableViewCell class] forCellReuseIdentifier:@"OrderLogisticsTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderLogisticsTableViewCell class])bundle:nil] forCellReuseIdentifier:@"OrderLogisticsTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
    }
    return _tableView;

}



@end
