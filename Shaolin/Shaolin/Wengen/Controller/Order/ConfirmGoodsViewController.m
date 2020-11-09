//
//  ConfirmGoodsViewController.m
//  Shaolin
//
//  Created by EDZ on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ConfirmGoodsViewController.h"
#import "ConfirmGoodsHeaderView.h"
#import "ConfirmGoodsTableViewCell.h"
#import "OrderDetailsModel.h"
#import "XHStarRateView.h"
#import "StoreViewController.h"
#import "OrderStoreModel.h"
#import "DataManager.h"
@interface ConfirmGoodsViewController ()<UITableViewDataSource,UITableViewDelegate,XHStarRateViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

/// 提交按钮
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConst;

// 所有数据
@property (nonatomic, strong) NSMutableArray *arrayData;

@end

static NSString * const confirmGoodsIdentifier                  = @"ConfirmGoodsCell";

@implementation ConfirmGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.isConfirmGoods == NO) {
        self.titleLabe.text = SLLocalizedString(@"确认收货成功");
    }else{
        self.titleLabe.text = SLLocalizedString(@"待评星");
    }
    
    if (BottomMargin_X) {
        self.bottomConst.constant = 45;
    }else{
        self.bottomConst.constant = 5;
    }
    
    self.arrayData = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.mTableView registerNib:[UINib nibWithNibName:@"ConfirmGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:confirmGoodsIdentifier];
    [self loadRequest];
}

// 获取订单数据接口  显示商品和门店
- (void)loadRequest{
    //   拿商户id club_id 匹配店铺 添加在一起  生成一个店铺
    [[DataManager shareInstance]getOrderInfoNew:@{@"order_id":self.order_sn} Callback:^(NSObject *object) {
        
        NSArray *array = (NSArray *)object;
        self.arrayData = (NSMutableArray *)[ModelTool assembleData:array];
        [self.mTableView reloadData];
    }];
}

/// 提交
- (IBAction)submitAction:(id)sender {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (OrderStoreModel *storeModel in self.arrayData) { // 店铺
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:storeModel.currentScore forKey:@"star"];
        [dic setValue:@"2" forKey:@"type"];
        [dic setValue:storeModel.storeId forKey:@"id"];
        [arr addObject:dic];
        for (OrderDetailsModel *model in storeModel.goods) { //商品
            NSMutableDictionary * modelDic = [NSMutableDictionary dictionary];
            [modelDic setValue:model.currentScore forKey:@"star"];
            [modelDic setValue:@"1" forKey:@"type"];
            [modelDic setValue:model.goods_id forKey:@"id"];
            [arr addObject:modelDic];
        }
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:arr forKey:@"message"];
    [param setValue:self.order_sn forKey:@"order_sn"];
    
    [[DataManager shareInstance]addEvaluate:param Callback:^(Message *message) {
        if (message.isSuccess) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"您的评星已经提交成功") view:self.view afterDelay:TipSeconds];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrayData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OrderStoreModel *storeModel = self.arrayData[section];
    return storeModel.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ConfirmGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:confirmGoodsIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    OrderStoreModel *storeModel = self.arrayData[indexPath.section];
    OrderDetailsModel *model = storeModel.goods[indexPath.row];
    
    cell.labelMoney.text = [NSString stringWithFormat:@"￥%@",model.money];
    cell.labelTitle.text = model.goods_name;
    if (model.goods_image.count > 0) {
        [cell.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.goods_image[0]]]];
    }
    
    XHStarRateView *starRateViewCell = [[XHStarRateView alloc] initWithFrame:cell.starsViewBg.bounds numberOfStars:5 rateStyle:WholeStar isAnination:YES delegate:self];
    starRateViewCell.indexPath = indexPath;
    starRateViewCell.currentScore = model.currentScore.integerValue;
    starRateViewCell.tag = 1000 + indexPath.row;
    [cell.starsViewBg addSubview:starRateViewCell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.isConfirmGoods == NO) {
            return 305;
        }else{
            return 82;
        }
    }else{
        return 92;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    ConfirmGoodsHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"ConfirmGoodsHeaderView" owner:nil options:nil] lastObject];
    headerView.btnStore.tag = 200 + section;
    [headerView.btnStore addTarget:self action:@selector(btnStoreAction:) forControlEvents:UIControlEventTouchUpInside];
    
    OrderStoreModel *storeModel = self.arrayData[section];
    headerView.labelTitle.text = storeModel.name;
    
    XHStarRateView *starRateViewHeader = [[XHStarRateView alloc] initWithFrame:headerView.starsViewBg.bounds numberOfStars:5 rateStyle:WholeStar isAnination:YES delegate:self];
    starRateViewHeader.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    starRateViewHeader.currentScore = storeModel.currentScore.integerValue;
    starRateViewHeader.tag = 100 + section;
    [headerView.starsViewBg addSubview:starRateViewHeader];
    
    if (section == 0) {
        CGFloat floatHeight;
        CGFloat heightConst;
        if (self.isConfirmGoods == NO) { // 确认收货显示图片
            floatHeight = 305;
            heightConst = 210;
            headerView.image.hidden = NO;
            headerView.labelSuccessful.hidden = NO;
            headerView.viewHeightConst.constant = 10;
        }else{ // 待评星
            floatHeight = 82;
            heightConst = 0;
            headerView.image.hidden = YES;
            headerView.labelSuccessful.hidden = YES;
            headerView.viewHeightConst.constant = 0;
        }
        headerView.frame = CGRectMake(0, 0, kScreenWidth, floatHeight);
        headerView.heightConst.constant = heightConst;
        return headerView;
    }else{
        headerView.frame = CGRectMake(0, 0, kScreenWidth, 92);
        headerView.heightConst.constant = 0;
        headerView.viewHeightConst.constant = 10;
        headerView.image.hidden = YES;
        headerView.labelSuccessful.hidden = YES;
        return headerView;
    }
}

// header btn 店铺
- (void)btnStoreAction:(UIButton *)btn{
    NSInteger indexTag = btn.tag - 200;
    
    OrderStoreModel *storeModel = self.arrayData[indexTag];
    StoreViewController *storeVC = [[StoreViewController alloc]init];
    storeVC.storeId = storeModel.storeId;
    [self.navigationController pushViewController:storeVC animated:YES];
}

-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore{
    
    NSString *string = [NSString stringWithFormat:@"%.0f",currentScore];
    
    NSInteger indexTag = starRateView.tag;
    
    NSIndexPath *indexPath = starRateView.indexPath;
    
    NSLog(@"tag-->%ld----  %f",indexTag,currentScore);
    
    if (indexTag >= 1000) { // cell 0
        OrderStoreModel *storeModel = self.arrayData[indexPath.section];
        OrderDetailsModel *model = storeModel.goods[indexPath.row];
        model.currentScore = string;
    }else{ // header 0
        OrderStoreModel *storeModel = self.arrayData[indexPath.section];
        storeModel.currentScore = string;
    }
    
    
//    判断评星是否都选中
    bool isStar = NO;
    for (OrderStoreModel *storeModel in self.arrayData) { // 店铺
        if (storeModel.currentScore.integerValue == 0) {
            isStar = YES;
        }
        for (OrderDetailsModel *model in storeModel.goods) { //商品
            if (model.currentScore.integerValue == 0) {
                isStar = YES;
            }
        }
      }
    
    if (isStar == YES) { // 按钮不可点
        self.btnSubmit.userInteractionEnabled = NO;
        [self.btnSubmit setBackgroundColor:kUIColorFromHex(0x8E2B25)];
        self.btnSubmit.alpha = 0.6;
    }else{
        self.btnSubmit.userInteractionEnabled = YES;
        [self.btnSubmit setBackgroundColor:kUIColorFromHex(0x8E2B25)];
        self.btnSubmit.alpha = 1;
    }
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
