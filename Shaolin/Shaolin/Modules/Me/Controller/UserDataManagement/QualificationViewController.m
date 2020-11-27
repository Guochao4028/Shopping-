//
//  QualificationViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/10.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "QualificationViewController.h"
#import "InvoiceQualificationsModel.h"
#import "MutableCopyCatetory.h"
#import "QualificationTableCell.h"
#import "QualificationColumnTableCell.h"
#import "WengenWebViewController.h"

#import "DefinedHost.h"
#import "DataManager.h"


@interface QualificationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UIView *titleView;

@property(nonatomic, weak)UILabel *titleLabel;

@property(nonatomic, strong)UITableView *tabelView;

@property(nonatomic, strong)InvoiceQualificationsModel *qualificationsModel;

@property(nonatomic, strong)UIButton *button;

@property(nonatomic, strong)NSMutableArray *dataArray;

//条例选择
@property(nonatomic, assign)BOOL isColumn;
//是否有条例
@property(nonatomic, assign)BOOL isHasColumn;
//是否修改
@property(nonatomic, assign)BOOL isModify;

//是否可以编辑
@property(nonatomic, assign)BOOL isCanEditor;



@end

@implementation QualificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initUI];
}

-(void)initData{
    
    self.isHasColumn = NO;
    
    self.isColumn = NO;
    
    self.isModify = NO;
    
    NSArray *bascArray = @[
    
        @{@"title" : SLLocalizedString(@"单位名称"), @"placeholder" : SLLocalizedString(@"请输入单位名称"), @"isEditor" : @"1"},
        @{@"title" : SLLocalizedString(@"纳税人识别号"), @"placeholder" : SLLocalizedString(@"请输入纳税人识别号"), @"isEditor" : @"1"},
        @{@"title" : SLLocalizedString(@"注册地址"), @"placeholder" : SLLocalizedString(@"请输入注册地址"), @"isEditor" : @"1"},
        @{@"title" : SLLocalizedString(@"注册电话"), @"placeholder" : SLLocalizedString(@"请输入注册电话"), @"isEditor" : @"1"},
        @{@"title" : SLLocalizedString(@"开户银行"), @"placeholder" : SLLocalizedString(@"请输入开户银行"), @"isEditor" : @"1"},
        @{@"title" : SLLocalizedString(@"银行账户"), @"placeholder" : SLLocalizedString(@"请输入银行账户"), @"isEditor" : @"1"},
    ];
    
    [self.dataArray addObject:[bascArray mutableArrayDeeoCopy]];
    
    
    NSArray *extensionArray = @[
        @{@"title" : SLLocalizedString(@"我已阅读并同意《增票资质确认书》"), @"isSelected" : @"0"},
    ];
    
     [[DataManager shareInstance]userQualifications:@{} Callback:^(NSObject *object) {
         
       
           self.qualificationsModel = (InvoiceQualificationsModel *)object;
          
           if (self.qualificationsModel == nil) {
               self.isHasColumn = YES;
                [self.dataArray addObject:[extensionArray mutableArrayDeeoCopy]];
               self.qualificationsModel = [[InvoiceQualificationsModel alloc]init];
           }else{
               self.isModify = YES;
               
               self.isCanEditor = NO;
               
                self.isHasColumn = NO;
               
               for (NSMutableDictionary *dic in self.dataArray) {
                   [dic setValue:@"0" forKey:@"isEditor"];
               }
               
               if ([self.qualificationsModel.status isEqualToString:@"1"]) {
                   [self.titleLabel setText:SLLocalizedString(@"已通过审核")];
               }else{
                   [self.titleLabel setText:SLLocalizedString(@"已提交，待审核")];
               }
               
               [self.button setTitle:SLLocalizedString(@"修改") forState:UIControlStateNormal];
               [self.button setBackgroundColor:KMeLightYellow];
               
           }
           
           [self.tabelView reloadData];
           
       }];
}

-(void)initUI{
    [self.view setBackgroundColor:KTextGray_FA];
    [self.titleLabe setText:SLLocalizedString(@"增票资质")];
    
    [self.view addSubview:self.titleView];
    
    [self.view addSubview:self.tabelView];
    
    [self.view addSubview:self.button];
}

-(void)submitAction{
    
    [self.view endEditing:YES];
    
    if (self.isCanEditor == NO) {
        [self.button setBackgroundColor:kMainYellow];
        
        self.isCanEditor = YES;
        for (NSMutableDictionary *dic in self.dataArray) {
            [dic setValue:@"1" forKey:@"isEditor"];
        }
        [self.tabelView reloadData];
        
        return;
    }
    
    NSString *tipMsg = @"";
    if (self.qualificationsModel.company_name.length == 0){
        tipMsg = SLLocalizedString(@"请输入单位名称");
    } else if (self.qualificationsModel.number.length == 0) {
        tipMsg = SLLocalizedString(@"请输入纳税人识别号");
    } else if (self.qualificationsModel.address.length == 0) {
        tipMsg = SLLocalizedString(@"请输入注册地址");
    } else if (self.qualificationsModel.phone.length == 0) {
        tipMsg = SLLocalizedString(@"请输入注册电话");
    } else if (self.qualificationsModel.bank.length == 0) {
        tipMsg = SLLocalizedString(@"请输入开户银行");
    } else if (self.qualificationsModel.bank_sn.length == 0) {
        tipMsg = SLLocalizedString(@"请输入银行账户");
    }
    if (tipMsg.length){
        [ShaolinProgressHUD singleTextAutoHideHud:tipMsg];
        return;
    }
    
    if (self.isHasColumn) {
        if (self.isColumn ) {
            
            NSDictionary *dic = [self.qualificationsModel mj_keyValues];
            
            [[DataManager shareInstance]addQualifications:dic Callback:^(Message *message) {
                
                if (message.isSuccess) {
                    [self.dataArray removeAllObjects];
                    [self initData];
                    [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"添加用户资质成功") view:self.view afterDelay:TipSeconds];
                }else{
                    [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
                }
            }];
            
        }else{
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"请同意增票资质确认书")];
            return;
        }
    }else{
        NSDictionary *dic = [self.qualificationsModel mj_keyValues];
        
        [[DataManager shareInstance]addQualifications:dic Callback:^(Message *message) {
            
            if (message.isSuccess) {
                [self.dataArray removeAllObjects];
                [self initData];
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"修改用户资质成功") view:self.view afterDelay:TipSeconds];
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }
        }];
    }
    
    
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *rowArray = self.dataArray[section];
    
    return rowArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    [view setBackgroundColor:KTextGray_FA];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        QualificationTableCell *invoiceCell = [tableView dequeueReusableCellWithIdentifier:@"QualificationTableCell"];

        NSArray *rowArray = self.dataArray[indexPath.section];
        
        [invoiceCell setIsCanEditor:self.isCanEditor];
        [invoiceCell setModel:rowArray[indexPath.row]];
        [invoiceCell setQualificationsModel:self.qualificationsModel];
        
        cell = invoiceCell;
    }else{
        QualificationColumnTableCell *columnCell = [tableView dequeueReusableCellWithIdentifier:@"QualificationColumnTableCell"];

        NSArray *rowArray = self.dataArray[indexPath.section];
        
        [columnCell setModel:rowArray[indexPath.row]];
        
        [columnCell setConfirmationBlock:^{
            NSLog(@"%s", __func__);
            WengenWebViewController *webVC = [[WengenWebViewController alloc] initWithUrl:URL_H5_InvoiceConfirmation title:SLLocalizedString(@"申请开具增值税专用发票确认书")];
            [self.navigationController pushViewController:webVC animated:YES];
        }];
        
        cell = columnCell;
    }
    
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        NSArray *rowArray = self.dataArray[indexPath.section];
        NSDictionary *model =  rowArray[indexPath.row];
        BOOL isSelected = [model[@"isSelected"] boolValue];
        if (!isSelected) {
            self.isColumn = YES;
        }else{
            self.isColumn = NO;
        }
        [model setValue:[NSString stringWithFormat:@"%d", (!isSelected)] forKey:@"isSelected"];
        [tableView reloadData];
        
    }
}


#pragma mark - getter / setter

-(UIView *)titleView{
    
    if (_titleView == nil) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 44)];
        
        [_titleView setBackgroundColor:kMainYellow];

        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 11.5, 110, 21)];
        
        [titleLabel setText:SLLocalizedString(@"填写资质信息")];
        [titleLabel setFont:kRegular(15)];
        [titleLabel setTextColor:[UIColor whiteColor]];
        self.titleLabel = titleLabel;
        [_titleView addSubview:titleLabel];
    }
    return _titleView;
}


-(UITableView *)tabelView{
    if (_tabelView == nil) {
        CGFloat y = CGRectGetMaxY(self.titleView.frame) +10;
        
        CGFloat h = ScreenHeight - NavBar_Height - CGRectGetMaxY(self.titleView.frame) -10 - 170;
        
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, h)];
        [_tabelView setDelegate:self];
        [_tabelView setDataSource:self];
        [_tabelView registerNib:[UINib nibWithNibName:NSStringFromClass([QualificationTableCell class])bundle:nil] forCellReuseIdentifier:@"QualificationTableCell"];
        [_tabelView registerNib:[UINib nibWithNibName:NSStringFromClass([QualificationColumnTableCell class])bundle:nil] forCellReuseIdentifier:@"QualificationColumnTableCell"];
        
        _tabelView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    }
    return _tabelView;
}


-(UIButton *)button{
    
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:SLLocalizedString(@"下一步") forState:UIControlStateNormal];
        CGFloat y = CGRectGetMaxY(self.tabelView.frame) +56;
        [_button setFrame:CGRectMake(16, y, ScreenWidth - 32, 40)];
        [_button setBackgroundColor:kMainYellow];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_button addTarget:self action:@selector(submitAction) forControlEvents: UIControlEventTouchUpInside];
        
        _button.layer.cornerRadius = 4;

    }
    return _button;

}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;

}


@end