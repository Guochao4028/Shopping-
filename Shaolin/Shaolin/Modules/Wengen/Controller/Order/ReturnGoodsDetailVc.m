//
//  ReturnGoodsDetailVc.m
//  Shaolin
//
//  Created by ws on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ReturnGoodsDetailVc.h"
#import "ReturnGoodsDetailHeader.h"
#import "ReturnGoodsDetailFooter.h"
#import "ReturnGoodsDetailCellTableViewCell.h"

#import "ReturnGoodsInputNumberVc.h"

#import "OrderRefundInfoModel.h"

#import "GoodsStoreInfoModel.h"
#import "SMAlert.h"
#import "DataManager.h"

static NSString *const returnGoodsCellId = @"ReturnGoodsDetailCellTableViewCell";

@interface ReturnGoodsDetailVc () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView   * tableView;
@property (nonatomic, weak) UIView          * navLine;//导航栏横线
@property (nonatomic, strong) ReturnGoodsDetailHeader  * headerView;
@property (nonatomic, strong) ReturnGoodsDetailFooter  * footerView;
@property(nonatomic, strong)  OrderRefundInfoModel *model;
@property(nonatomic, strong)GoodsStoreInfoModel *storeInfoModel;


@end

@implementation ReturnGoodsDetailVc

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navLine.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    self.navLine.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabe.text = SLLocalizedString(@"退货详情");
    self.view.backgroundColor = KTextGray_FA;
    [self initData];
    [self layoutView];
}

-(void)initData{
    [[DataManager shareInstance]getRefundInfo:@{@"id":self.orderNo} Callback:^(NSObject *object) {
           
           if([object isKindOfClass:[OrderRefundInfoModel class]] == YES){
               NSLog(@"%@", object);
               self.model = (OrderRefundInfoModel *)object;
               [self.footerView setModel:self.model];
               
               [[DataManager shareInstance]getStoreInfo:@{@"id":self.storeId} Callback:^(NSObject *object) {
                   
                  self.storeInfoModel = (GoodsStoreInfoModel *)object;
                   [self.tableView reloadData];
                   
               }];
               
               
              }
       }];
}


- (void) layoutView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - NavBar_Height) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReturnGoodsDetailCellTableViewCell class]) bundle:nil] forCellReuseIdentifier:returnGoodsCellId];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
//    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - delegate && dataSources
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
     ReturnGoodsDetailCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:returnGoodsCellId forIndexPath:indexPath];
    [cell setStoreInfoModel:self.storeInfoModel];
    cell.unDoHandle = ^{
        [SMAlert setConfirmBtBackgroundColor:kMainYellow];
        [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
        [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
        [SMAlert setCancleBtTitleColor:KTextGray_333];
        [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300-40, 100)];
        [title setFont:kMediumFont(15)];
        [title setTextColor:[UIColor darkGrayColor]];
        title.text = SLLocalizedString(@"您的售后订单撤销申请只能提交一次，确定要提交撤销申请吗？");
        [title setNumberOfLines:0];
        [title setTextAlignment:NSTextAlignmentLeft];
        [customView addSubview:title];
        [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
          
            [[DataManager shareInstance]cannelRefund:@{@"id":self.model.order_no} Callback:^(Message *message) {
                
                if (message.isSuccess) {
                    [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"撤销成功") view:self.view afterDelay:TipSeconds];
                    [self initData];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
                }
                
            }];
        }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
    };
     
    cell.inputHandle = ^{
        
        ReturnGoodsInputNumberVc * v = [ReturnGoodsInputNumberVc new];
        
        v.model = self.model;
        
        [weakSelf.navigationController pushViewController:v animated:YES];
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    return v;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    return v;
}


#pragma mark - setter && getter

-(ReturnGoodsDetailHeader *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"ReturnGoodsDetailHeader" owner:self options:nil] objectAtIndex:0];
    }
    return _headerView;
}

-(ReturnGoodsDetailFooter *)footerView {
    if (!_footerView) {
        _footerView = [[[NSBundle mainBundle] loadNibNamed:@"ReturnGoodsDetailFooter" owner:self options:nil] objectAtIndex:0];
    }
    return _footerView;
}

- (UIView *)navLine
{
    if (!_navLine) {
        UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
        _navLine = backgroundView.subviews.firstObject;
    }
    return _navLine;
}
@end
