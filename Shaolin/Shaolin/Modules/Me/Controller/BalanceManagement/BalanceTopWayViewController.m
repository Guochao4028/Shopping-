//
//  BalanceTopWayViewController.m
//  Shaolin
//
//  Created by edz on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "BalanceTopWayViewController.h"

@interface BalanceTopWayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIButton *weixinBtn;
@property(nonatomic,strong) UIButton *alipayBtn;
@property(nonatomic,strong) NSString *payType;
@property(nonatomic,strong) UIButton *payButton;
@end

@implementation BalanceTopWayViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = SLLocalizedString(@"充值方式");
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = RGBA(251, 251, 251, 1);
    [self setUI];
}
- (void)setUI {
    [self.view addSubview:self.payButton];
    
    NSString *priceStr = [NSString stringWithFormat:SLLocalizedString(@"立即支付（ ¥%@元 ）"),self.priceStr];
    NSMutableAttributedString *missionAttributed = [[NSMutableAttributedString alloc]initWithString:priceStr];
    
    [missionAttributed addAttribute:NSFontAttributeName value:kRegular(17) range:NSMakeRange(0, 7)];
    [missionAttributed addAttribute:NSFontAttributeName value:kBoldFont(20) range:NSMakeRange(7, self.priceStr.length)];
    [missionAttributed addAttribute:NSFontAttributeName value:kRegular(17) range:NSMakeRange(7+self.priceStr.length, 2)];
    //    [self.payButton setAttributedTitle:missionAttributed forState:(UIControlStateNormal)];
    UILabel *labelPrice = [[UILabel alloc]init];
    labelPrice.textAlignment = NSTextAlignmentCenter;
    labelPrice.textColor = UIColor.whiteColor;
    [self.payButton addSubview:labelPrice];
    [labelPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.centerX.centerY.mas_equalTo(self.payButton);
        make.height.mas_equalTo(SLChange(20));
    }];
    labelPrice.attributedText = missionAttributed;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(8))];
    view.backgroundColor = RGBA(251, 251, 251, 1);
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0)];
    
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSArray *titleArr = @[SLLocalizedString(@"微信充值"),SLLocalizedString(@"支付宝充值")];
    cell.textLabel.text = titleArr[indexPath.section];
    cell.textLabel.font = kRegular(15);
    cell.textLabel.textColor = KTextGray_12;
    NSArray *imageArr = @[@"winxin",@"zhifubao"];
    cell.imageView.image = [UIImage imageNamed:imageArr[indexPath.section]];
    if (indexPath.section ==0 ) {
        [cell.contentView addSubview:self.weixinBtn];
    }else {
        [cell.contentView addSubview:self.alipayBtn];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.payType = @"1";
        [_weixinBtn setImage:[UIImage imageNamed:@"balancePaySelect"] forState:(UIControlStateNormal)];
        [_alipayBtn setImage:[UIImage imageNamed:@"balancePayNormal"] forState:(UIControlStateNormal)];
    }else {
        self.payType = @"2";
        [_weixinBtn setImage:[UIImage imageNamed:@"balancePayNormal"] forState:(UIControlStateNormal)];
        [_alipayBtn setImage:[UIImage imageNamed:@"balancePaySelect"] forState:(UIControlStateNormal)];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  SLChange(60);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SLChange(8);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(136)) style:(UITableViewStyleGrouped)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
-(UIButton *)weixinBtn
{
    if (!_weixinBtn) {
        _weixinBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-SLChange(36), SLChange(21), SLChange(18), SLChange(18))];
        [_weixinBtn setImage:[UIImage imageNamed:@"balancePayNormal"] forState:(UIControlStateNormal)];
        //        [_weixinBtn setImage:[UIImage imageNamed:@"balancePaySelect"] forState:(UIControlStateSelected)];
        _weixinBtn.tag =101;
        
        [_weixinBtn addTarget:self action:@selector(choosePayAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _weixinBtn;
}
-(UIButton *)alipayBtn
{
    if (!_alipayBtn) {
        _alipayBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-SLChange(36), SLChange(21), SLChange(18), SLChange(18))];
        [_alipayBtn setImage:[UIImage imageNamed:@"balancePayNormal"] forState:(UIControlStateNormal)];
        
        _alipayBtn.tag =102;
        
        [_alipayBtn addTarget:self action:@selector(choosePayAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _alipayBtn;
}
-(void)choosePayAction:(UIButton *)button
{
    NSInteger i = button.tag;
    if (i == 101) {
        self.payType = @"1";
        [_weixinBtn setImage:[UIImage imageNamed:@"balancePaySelect"] forState:(UIControlStateNormal)];
        [_alipayBtn setImage:[UIImage imageNamed:@"balancePayNormal"] forState:(UIControlStateNormal)];
    }else
    {
        self.payType = @"2";
        [_weixinBtn setImage:[UIImage imageNamed:@"balancePayNormal"] forState:(UIControlStateNormal)];
        [_alipayBtn setImage:[UIImage imageNamed:@"balancePaySelect"] forState:(UIControlStateNormal)];
    }
}
-(UIButton *)payButton {
    if (!_payButton) {
        _payButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kHeight-SLChange(50)-NavBar_Height-BottomMargin_X, kWidth, SLChange(50)+BottomMargin_X)];
        [_payButton setBackgroundImage:[UIImage imageNamed:@"balancePush"] forState:(UIControlStateNormal)];
        [_payButton addTarget:self action:@selector(payAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _payButton;
}
- (void)payAction {
    if (self.payType.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择充值方式") view:self.view afterDelay:TipSeconds];
        return;
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
