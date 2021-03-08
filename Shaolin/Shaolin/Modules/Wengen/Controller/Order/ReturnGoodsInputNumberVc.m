//
//  ReturnGoodsInputNumberVc.m
//  Shaolin
//
//  Created by ws on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ReturnGoodsInputNumberVc.h"
#import "ReturnGoodsCell.h"
#import "ReturnGoodsInputCell.h"
#import "UIImage+YYWebImage.h"

#import "OrderRefundInfoModel.h"
#import "OrderHomePageViewController.h"
#import "LogisticsViewController.h"
#import "DataManager.h"

static NSString *const goodsCellId = @"ReturnGoodsCell";
static NSString *const inputCellId = @"ReturnGoodsInputCell";

@interface ReturnGoodsInputNumberVc ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView   * tableView;
@property (nonatomic, weak) UIView          * navLine;//导航栏横线
@property (nonatomic, strong) UIButton      * submitBtn;

@property (nonatomic, copy) NSString      * logistics_no;
@property (nonatomic, copy) NSString      * logistics_name;

@end

@implementation ReturnGoodsInputNumberVc

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    self.navLine.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
//    self.navLine.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabe.text = SLLocalizedString(@"填写退货物流单号");
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self layoutView];
}


- (void) layoutView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 50) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = KTextGray_FA;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReturnGoodsCell class]) bundle:nil] forCellReuseIdentifier:goodsCellId];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReturnGoodsInputCell class]) bundle:nil] forCellReuseIdentifier:inputCellId];
    
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tableViewGesture];
    
    
    [self.view addSubview:self.submitBtn];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(SLChange(50));
        make.left.right.mas_equalTo(self.view);
    }];
}

#pragma mark - event

- (void)submitHandle {
    NSLog(@"提交");
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.model.refundInfoId forKey:@"id"];
    [dic setValue:self.logistics_no forKey:@"logisticsNo"];
    [dic setValue:self.logistics_name forKey:@"logisticsName"];

    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]sendRefundGoods:dic Callback:^(Message *message) {
        
        [hud hideAnimated:YES];
        
        if (message.isSuccess) {
            
            UIViewController * popVc = nil;
            for (UIViewController * vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[OrderHomePageViewController class]]) {
                    popVc = vc;
                }
            }
            
            if (popVc) {
                [self.navigationController popToViewController:popVc animated:YES];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }else{
            [ShaolinProgressHUD singleTextHud:message.reason view:WINDOWSVIEW afterDelay:TipSeconds];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)commentTableViewTouchInSide{
    [self.view endEditing:YES];
}



#pragma mark - delegate && dataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ReturnGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsCellId forIndexPath:indexPath];
        
        [cell setModel:self.model];
        
        return cell;
    } else {
        ReturnGoodsInputCell * cell = [tableView dequeueReusableCellWithIdentifier:inputCellId forIndexPath:indexPath];
        
        
        NSArray * titleArray = @[SLLocalizedString(@"物流公司:"),SLLocalizedString(@"物流单号:")];
        NSArray * placeholderArray = @[SLLocalizedString(@"请选择物流公司"),SLLocalizedString(@"请填写物流单号")];
        
        cell.inputTF.placeholder = placeholderArray[indexPath.row];
        cell.cellTitleLabel.text = titleArray[indexPath.row];
        if (indexPath.row == 0){
            if (self.logistics_name){
                cell.inputTF.text = self.logistics_name;
            } else {
                cell.inputTF.text = @"";
            }
            cell.inputTF.userInteractionEnabled = NO;
        } else {
            cell.inputTF.userInteractionEnabled = YES;
        }
        cell.inputBlock = ^(NSString * _Nonnull string) {
            if (indexPath.row == 0) {
                self.logistics_name = string;
            } else {
                self.logistics_no = string;
            }
        };

        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0){
        LogisticsViewController *vc = [[LogisticsViewController alloc] init];
        WEAKSELF
        [vc setSelectedLogisticsName:^(NSString * _Nonnull name) {
            weakSelf.logistics_name = name;
            [weakSelf.tableView reloadData];
        }];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 52;
    }
    return tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    return v;
}


#pragma mark - setter && getter

- (UIView *)navLine
{
    if (!_navLine) {
        UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
        _navLine = backgroundView.subviews.firstObject;
    }
    return _navLine;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
        [_submitBtn setTitle:SLLocalizedString(@"提交") forState:UIControlStateNormal];
        [_submitBtn setBackgroundImage:[UIImage yy_imageWithColor:kMainYellow] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (void)setModel:(OrderRefundInfoModel *)model{
    _model=  model;
    [self.tableView reloadData];
}

@end
