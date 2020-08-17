//
//  StoreInfoViewController.m
//  Shaolin
//
//  Created by edz on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreInfoViewController.h"
#import "StoreInfowCell.h"
#import "StoreInfoModel.h"
#import "StoreOneViewController.h"
#import "StoreInformationModel.h"

@interface StoreInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation StoreInfoViewController
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.titleLabe.text = SLLocalizedString(@"准备入驻资料");
    self.titleLabe.textColor = [UIColor whiteColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:(UIControlStateNormal)];
    
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self wr_setNavBarBarTintColor:[UIColor hexColor:@"8E2B25"]];
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarBackgroundAlpha:1];
}

- (void)setUI {
   
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:SLLocalizedString(@"准备好了，开始填写入驻信息") forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [button setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:(UIControlStateNormal)];
    button.titleLabel.font = kRegular(15);
    button.backgroundColor = [UIColor colorForHex:@"8E2B25"];
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.right.mas_equalTo(-SLChange(16));
        make.bottom.mas_equalTo(-SLChange(23));
        make.height.mas_equalTo(SLChange(40));
    }];
   
    [self.view addSubview:self.tableView];
    
    NSMutableArray *arr = [NSMutableArray array];
        NSArray *titleArr = @[SLLocalizedString(@"1.主体资质"),SLLocalizedString(@"2.法人身份证"),SLLocalizedString(@"3.品牌授权、类目资质")];
        NSArray *contentArr = @[NSLocalizedString(@"提供营养执照、开户许可证等,文字清晰、漏出国徽,复印件需加盖印章", nil),NSLocalizedString(@"需区分身份证正、反面,需清晰完整", nil),NSLocalizedString(@"由品牌方出具的品牌授权书、对应产品质检报告、经营行业资质,根据您经营的品牌、类目资质信息有所不同", nil)];
        NSArray *imageArr = @[@"store_license",@"store_idCard",@"store_Certificateofauthorization"];
       for (int i =0 ; i<3; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
           [dic setObject:titleArr[i] forKey:@"title"];
            [dic setObject:contentArr[i] forKey:@"content"];
            [dic setObject:imageArr[i] forKey:@"imageStr"];
           
            [arr addObject:dic];
       }
      
      
    self.dataArr = [StoreInfoModel mj_objectArrayWithKeyValuesArray:arr];
    [self.tableView reloadData];
}
- (void)buttonAction {
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"UserStoreOpenInformation"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    StoreOneViewController *writeVc = [[StoreOneViewController alloc]init];
    [self.navigationController pushViewController:writeVc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreInfowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArr[indexPath.row];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreInfoModel *model = self.dataArr[indexPath.row];
    return model.cellHeight;
}
#pragma mark - Getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]
                      initWithFrame:CGRectMake(0, 0, kWidth, kHeight-SLChange(76)-NavBar_Height)
                      style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:[StoreInfowCell class] forCellReuseIdentifier:@"cell"];
//        _tableView.rowHeight = 227;
        _tableView.separatorColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
       
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
