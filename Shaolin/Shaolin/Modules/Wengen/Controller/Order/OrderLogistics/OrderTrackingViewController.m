//
//  OrderTrackingViewController.m
//  Shaolin
//
//  Created by edz on 2020/5/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderTrackingViewController.h"
#import "OrderTrackingTableViewCell.h"
#import "OrderDetailsModel.h"
#import "DataManager.h"
@interface OrderTrackingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UILabel *titleNumberLabel;//运单
@property(nonatomic,strong) UILabel *numberLabel;//编号
@property(nonatomic,strong) UILabel *personLabel;//国内承运人
@property(nonatomic,strong) UILabel *personName;
@property(nonatomic,strong) UIButton *coPyButton;
@property(nonatomic, strong)OrderDetailsModel *model;

@end

@implementation OrderTrackingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideNavigationBarShadow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = SLLocalizedString(@"订单跟踪");
   self.coPyButton.hidden = YES;
    [self layoutView];
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
   [self initData];
}
- (void)initData{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    WEAKSELF
    [[DataManager shareInstance]getOrderInfoNew:@{@"orderId":self.orderId} Callback:^(NSObject *object) {
        [hud hideAnimated:YES];
        NSLog(@"%@",object);
//        self.model = (OrderDetailsModel *)object;
        NSMutableArray *array = (NSMutableArray *)object;
        if (array.count == 0) {
            
        }else {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (dic in array) {
                    self.model = [OrderDetailsModel mj_objectWithKeyValues:dic];
            }
            if (self.model.logistics_no.length == 0) {
                    self.coPyButton.hidden = YES;
            }else {
                    self.numberLabel.text = [NSString stringWithFormat:@"%@",self.model.logistics_no];
                    self.personName.text = [NSString stringWithFormat:@"%@",self.model.logistics_name];
                    self.coPyButton.hidden = NO;
                    CGFloat width = [UILabel getWidthWithTitle:self.numberLabel.text font:self.numberLabel.font];
                    [weakSelf.numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.width.mas_equalTo(width+5);
                    }];
            }
                [self.tableView reloadData];
                self.tableView.hidden = NO;
        }
       
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model.logistics_no.length == 0) {
        return 1;
    }else if ([self.model.status isEqualToString:@"4"] || [self.model.status isEqualToString:@"5"]) {
        return 3;
    }else {
        return 2;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifierStr = [NSString stringWithFormat:@"identifier_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    OrderTrackingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
           cell = [[OrderTrackingTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifierStr];
       }
    if (self.model.logistics_no.length == 0) {
        cell.nameLabel.text = SLLocalizedString(@"已下单");
        cell.contentLabel.text = SLLocalizedString(@"您提交了订单，耐心等候发货时间，非常感\n谢您的支持！");
        cell.lineView.hidden = YES;
        cell.iconImage.image = [UIImage imageNamed:@"hasorder"];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@",self.model.create_time];
       }else if ([self.model.status isEqualToString:@"4"] || [self.model.status isEqualToString:@"5"])
       {
           NSArray *arrContent = @[SLLocalizedString(@"您的订单已完成，非常感谢您对少林的支持，\n欢迎再次光临！"),SLLocalizedString(@"您的订单已发货，请留察物流信息，非常感\n谢您的支持！"),SLLocalizedString(@"您提交了订单，耐心等候发货时间，非常感\n谢您的支持！")];
           cell.contentLabel.text = arrContent[indexPath.row];
           NSArray *arrTitle = @[SLLocalizedString(@"已完成"),SLLocalizedString(@"已发货"),SLLocalizedString(@"已下单")];
           cell.nameLabel.text = arrTitle[indexPath.row];
           NSArray *imageArr = @[@"hasdone",@"hasdelivery",@"hasorder"];
           cell.iconImage.image = [UIImage imageNamed:imageArr[indexPath.row]];
           if (indexPath.row == 2) {
               cell.lineView.hidden =YES;
           }else {
               cell.lineView.hidden =NO;
           }
           NSArray *arrTimeStr = @[self.model.receipt_time,self.model.send_time,self.model.create_time];
           cell.timeLabel.text = [NSString stringWithFormat:@"%@",arrTimeStr[indexPath.row]];
           
       }else {
           NSArray *arrContent = @[SLLocalizedString(@"您的订单已发货，请留察物流信息，非常感\n谢您的支持！"),SLLocalizedString(@"您提交了订单，耐心等候发货时间，非常感\n谢您的支持！")];
            cell.contentLabel.text = arrContent[indexPath.row];
          NSArray *arrTitle = @[SLLocalizedString(@"已发货"),SLLocalizedString(@"已下单")];
          cell.nameLabel.text = arrTitle[indexPath.row];
           NSArray *imageArr = @[@"hasdelivery",@"hasorder"];
            cell.iconImage.image = [UIImage imageNamed:imageArr[indexPath.row]];
           if (indexPath.row == 1) {
               cell.lineView.hidden =YES;
           }else {
               cell.lineView.hidden =NO;
           }
           NSArray *arrTimeStr = @[self.model.send_time,self.model.create_time];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@",arrTimeStr[indexPath.row]];
       }
//       cell.activityModel = self.arrAy[indexPath.row];
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SLChange(122);
}
- (void)layoutView {
    [self.view addSubview:self.titleNumberLabel];
    [self.view addSubview:self.numberLabel];
    [self.view addSubview:self.personLabel];
    [self.view addSubview:self.personName];
    [self.view addSubview:self.coPyButton];
    
    [self.titleNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(70));
        make.height.mas_equalTo(SLChange(21));
        make.left.mas_equalTo(SLChange(16));
        make.top.mas_equalTo(SLChange(15));
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(SLChange(90));
           make.height.mas_equalTo(SLChange(21));
           make.left.mas_equalTo(self.titleNumberLabel.mas_right).offset(SLChange(2));
           make.top.mas_equalTo(SLChange(15));
       }];
    [self.coPyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(45));
        make.height.mas_equalTo(SLChange(20));
        make.left.mas_equalTo(self.numberLabel.mas_right).offset(SLChange(12));
        make.top.mas_equalTo(SLChange(15));
    }];
    [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(70));
        make.height.mas_equalTo(SLChange(21));
        make.left.mas_equalTo(SLChange(16));
        make.top.mas_equalTo(self.titleNumberLabel.mas_bottom).offset(SLChange(10));
    }];
    [self.personName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(SLChange(21));
        make.left.mas_equalTo(self.personLabel.mas_right).offset(SLChange(2));
         make.top.mas_equalTo(self.titleNumberLabel.mas_bottom).offset(SLChange(10));
    }];
    
    UIView *viewLine = [[UIView alloc]init];
    viewLine.backgroundColor = RGBA(252, 250, 251, 1);
    [self.view addSubview:viewLine];
    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
         make.height.mas_equalTo(SLChange(10));
         make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.personLabel.mas_bottom).offset(SLChange(15));
    }];
}
- (UILabel *)titleNumberLabel {
    if (!_titleNumberLabel) {
        _titleNumberLabel = [[UILabel alloc]init];
        _titleNumberLabel.text = SLLocalizedString(@"物流单号:");
        _titleNumberLabel.font = kRegular(15);
        _titleNumberLabel.textColor = KTextGray_333;
    }
    return _titleNumberLabel;
}
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.text = @"";
        _numberLabel.font = kMediumFont(15);
        _numberLabel.textAlignment = NSTextAlignmentLeft;
        _numberLabel.textColor = KTextGray_333;
    }
    return _numberLabel;
}
- (UIButton *)coPyButton {
    if (!_coPyButton) {
        _coPyButton = [[UIButton alloc]init];
        _coPyButton.layer.cornerRadius = SLChange(10);
        _coPyButton.layer.masksToBounds = YES;
        [_coPyButton setTitle:SLLocalizedString(@"复制") forState:(UIControlStateNormal)];
        [_coPyButton setTitleColor:KTextGray_333 forState:(UIControlStateNormal)];
        _coPyButton.titleLabel.font = kRegular(14);
        [_coPyButton addTarget:self action:@selector(coPyAction) forControlEvents:(UIControlEventTouchUpInside)];
        _coPyButton.backgroundColor = RGBA(242, 242, 242, 1);
    }
    return _coPyButton;
}
- (UILabel *)personLabel {
    if (!_personLabel) {
        _personLabel = [[UILabel alloc]init];
        _personLabel.text = SLLocalizedString(@"物流公司:");
        _personLabel.font = kRegular(15);
        _personLabel.textColor = KTextGray_333;
    }
    return _personLabel;
}
- (UILabel *)personName {
    if (!_personName) {
        _personName = [[UILabel alloc]init];
        _personName.text = @"";
        _personName.font = kRegular(15);
        _personName.textColor = KTextGray_333;
    }
    return _personName;
}
#pragma mark - 复制功能
- (void)coPyAction {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
     pboard.string = self.numberLabel.text;
    [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"复制成功") view:self.view afterDelay:TipSeconds];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SLChange(108), kWidth, kHeight-SLChange(92)) style:(UITableViewStylePlain)];
       _tableView.delegate = self;
        _tableView.dataSource = self;
         [_tableView registerClass:[OrderTrackingTableViewCell class] forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
                   _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                   _tableView.estimatedRowHeight = 0;
                   _tableView.estimatedSectionHeaderHeight = 0;
                   _tableView.estimatedSectionFooterHeight = 0;
               } else {
                   self.automaticallyAdjustsScrollViewInsets = NO;
               }
               self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       
    }
    return _tableView;
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
