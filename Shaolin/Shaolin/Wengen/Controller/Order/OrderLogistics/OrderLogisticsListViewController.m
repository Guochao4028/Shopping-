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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)initUI{
    
    [self.titleLabe setText:SLLocalizedString(@"查看物流")];
    [self.view addSubview:self.promptTitleLabel];
    [self.view addSubview:self.tableView];
    
}

-(void)initData{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getOrderInfo:@{@"order_id":self.orderId} Callback:^(NSObject *object) {
        [hud hideAnimated:YES];
        
        if([object isKindOfClass:[NSArray class]] == YES){
            NSArray *tmpArray = (NSArray *)object;
            NSString *status = @"9";
            for (OrderDetailsModel *model in tmpArray) {
                int statusInt = [model.status intValue];
                int temStatusInt = [status intValue];
                if(temStatusInt > statusInt){
                    status = model.status;
                }
                
                if (statusInt > 2) {
                    self.orderStatus = model.status;
                }
            }
            
            [self assembleData:tmpArray];
            
            [self.tableView reloadData];
        }
    }];
}

-(void)assembleData:(NSArray *)dataArray{
    
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

#pragma mark - UITableViewDelegate && UITableViewDataSource

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 245;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderLogisticsTableViewCell *logisticsCell = [tableView dequeueReusableCellWithIdentifier:@"OrderLogisticsTableViewCell"];
    
    [logisticsCell setGoodsModel:self.dataArray[indexPath.row]];
    
    WEAKSELF
    
    [logisticsCell setLookLogisticsBlock:^(OrderDetailsModel * _Nonnull goodsModel) {
        [weakSelf jumpLogidstivcs:goodsModel];
    }];
    logisticsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return logisticsCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)jumpLogidstivcs:(OrderDetailsModel * _Nonnull) goodsModel{
    
    
    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
    
    NSString *urlStr =  URL_H5_OrderTrack(goodsModel.allOrderNoStr, appInfoModel.access_token);

    WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:SLLocalizedString(@"查看物流")];
    [self.navigationController pushViewController:webVC animated:YES];
    
}




#pragma mark - setter / getter

-(UILabel *)promptTitleLabel{
    
    if (_promptTitleLabel == nil) {
        _promptTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, ScreenWidth - 16, 50)];
        
        [_promptTitleLabel setFont:kRegular(14)];
        [_promptTitleLabel setTextColor:kMainYellow];
        [_promptTitleLabel setBackgroundColor:[UIColor colorForHex:@"F9F9F9"]];
    }
    return _promptTitleLabel;

}

-(UITableView *)tableView{
    
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
