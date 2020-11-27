//
//  KfCertificateCheckViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KfCertificateCheckViewController.h"
#import "KfCertificateBigImgViewController.h"

#import "KungfuManager.h"
#import "KfCertificateCell.h"
#import "KfReceiveCerView.h"
#import "CertificateModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SMAlert.h"
#import "DefinedHost.h"
#import "WengenWebViewController.h"

static NSString *const cerCellId = @"KfCertificateCell";

@interface KfCertificateCheckViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) KfReceiveCerView * receiveView;
@property(nonatomic,strong) UIView * alphaView;

@property(nonatomic,strong) NSArray * cerList;

@end

@implementation KfCertificateCheckViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationBarWhiteTintColor boolValue]){
        [self setNavigationBarWhiteTintColor];
    } else {
        //[self setNavigationBarYellowTintColor];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabe.text = SLLocalizedString(@"证书查询");
    self.view.backgroundColor = [UIColor whiteColor];// KTextGray_FA;

    [self layoutView];
    [self loadData];
}

- (void)loadData{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    [[KungfuManager sharedInstance] getCertificateAndCallback:^(NSArray *result) {
        self.cerList = result;
        [self.tableView reloadData];
        
        [hud hideAnimated:YES];
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}

-(void)layoutView
{
    WEAKSELF
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - NavBar_Height) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    MJRefreshNormalHeader *headerView = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    self.tableView.mj_header = headerView;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KfCertificateCell class]) bundle:nil] forCellReuseIdentifier:cerCellId];
    
    //self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    

    UIWindow * window = [ShaolinProgressHUD frontWindow];
    [window addSubview:self.alphaView];
    [window addSubview:self.receiveView];
    
    self.receiveView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 380);
}

#pragma mark - event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideReciveView];
}

- (void) tapAction {
    [self hideReciveView];
}


- (void) showReciveView:(CertificateModel *)model {
    self.receiveView.model = model;
    [UIView animateWithDuration:0.3 animations:^{
        self.alphaView.alpha = 0.5;
        self.receiveView.frame = CGRectMake(0, kScreenHeight - 370, kScreenWidth, 380);
        [self.receiveView bringSubviewToFront:self.view];
    }];
}


-(void)checkLogistics:(CertificateModel *)model{
    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
    
    NSString *urlStr = URL_H5_CertificateTrack(model.certificateId, appInfoModel.access_token);
    
    WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:SLLocalizedString(@"查看物流")];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void) hideReciveView {
    [self.receiveView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.alphaView.alpha = 0.0;
        self.receiveView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 380);
    }];
}

- (void) showAlert{
    [SMAlert setConfirmBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setConfirmBtTitleColor:kMainYellow];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 130)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 21)];
    [title setFont:kRegular(15)];
    [title setTextColor:KTextGray_333];
    title.text = SLLocalizedString(@"领取证书");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    
    UILabel *neirongLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(title.frame)+20, 270, 60)];
    [neirongLabel setFont:kRegular(16)];
    [neirongLabel setTextColor:KTextGray_333];
    neirongLabel.text = SLLocalizedString(@"您的实物证书已经申请领取，请耐心等待");
    neirongLabel.numberOfLines = 2;
    [customView addSubview:neirongLabel];
    
    [SMAlert showCustomView:customView confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        [self loadData];
    }]];

}

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !self.cerList.count;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"暂无证书");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: KTextGray_999};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - delegate && dataSources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cerList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    KfCertificateCell * cell = [tableView dequeueReusableCellWithIdentifier:cerCellId];
    CertificateModel *model = self.cerList[indexPath.section];
    cell.cellModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.detailHandle = ^{
        KfCertificateBigImgViewController * vc = [KfCertificateBigImgViewController new];
        vc.certificateUrl = model.certificateUrl;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    cell.receiveHandle = ^(NSInteger status) {
        if (status == 0) {
            [weakSelf showReciveView:model];
        }else if(status == 2){
            [weakSelf checkLogistics:model];
        }
    };
     
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CertificateModel *model = self.cerList[indexPath.section];
    KfCertificateBigImgViewController * vc = [KfCertificateBigImgViewController new];
    vc.certificateUrl = model.certificateUrl;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 223;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return v;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 15)];
    
    return v;
}


#pragma mark - getter && setter

-(KfReceiveCerView *)receiveView {
    WEAKSELF
    if (!_receiveView) {
        _receiveView = [[[NSBundle mainBundle] loadNibNamed:@"KfReceiveCerView" owner:self options:nil] objectAtIndex:0];
        _receiveView.closeHandle = ^{
            [weakSelf hideReciveView];
        };
        WEAKSELF
        _receiveView.chooseHandle = ^(NSDictionary * _Nonnull params) {
            [weakSelf.view endEditing:YES];
            MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
            [[KungfuManager sharedInstance] getApplicationCertificate:params callback:^(Message *message) {
                [hud hideAnimated:YES];
                [weakSelf showAlert];
                if (message.isSuccess){
                    [weakSelf loadData];
                }
            }];
            [weakSelf hideReciveView];
        };
        
    }
    return _receiveView;
}


-(UIView *)alphaView {
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _alphaView.backgroundColor = UIColor.blackColor;
        _alphaView.alpha = 0;
        
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_alphaView addGestureRecognizer:tapGesturRecognizer];
    }
    return _alphaView;
}


#pragma mark - 移除加在 window上的控件
- (void)removeSubViews{

    [_receiveView removeFromSuperview];
    [_alphaView removeFromSuperview];
    
    _receiveView = nil;
    _alphaView = nil;
}

- (void)dealloc{
    [self removeSubViews];
}

@end
