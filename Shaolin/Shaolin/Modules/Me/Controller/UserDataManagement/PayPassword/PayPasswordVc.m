//
//  PayPasswordVc.m
//  Shaolin
//
//  Created by ws on 2020/5/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PayPasswordVc.h"

#import "PayPasswordSetupVc.h"
#import "PayPasswordChangeVc.h"

#import "MeManager.h"

@interface PayPasswordVc ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;


@end

@implementation PayPasswordVc

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = SLLocalizedString(@"支付密码");
    self.view.backgroundColor = RGBA(250, 250, 250, 1);
 
    [self layoutView];

}

#pragma mark - 编辑

- (void)layoutView
{
   
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];

}

#pragma mark - delegate && dataSources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellIdentifier = @"cellID";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if (!cell)
     {
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         cell.textLabel.font = kRegular(16);
         cell.textLabel.textColor = [UIColor blackColor];
         
         UIImageView * arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_arrow"]];
         cell.accessoryView = arrow;
     }

    NSArray *arr = @[SLLocalizedString(@"设置支付密码"),SLLocalizedString(@"修改支付密码"),SLLocalizedString(@"忘记支付密码")];
    cell.textLabel.text =arr[indexPath.section];
     
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
//        [[MeManager sharedInstance] queryPayPassWordStatusSuccess:^(id _Nonnull responseObject) {
//            NSNumber *number = responseObject;
//            if ([number isKindOfClass:[NSNumber class]] && [number boolValue] == NO){
//                PayPasswordSetupVc * v = [PayPasswordSetupVc new];
//                [self.navigationController pushViewController:v animated:YES];
//            } else {
//                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"您已设置支付密码") view:self.view afterDelay:TipSeconds];
//            }
//        } failure:nil finish:nil];
    }
    
    if (indexPath.section == 1) {
        PayPasswordChangeVc * v = [PayPasswordChangeVc new];
        [self.navigationController pushViewController:v animated:YES];
    }
    
    if (indexPath.section == 2) {
        PayPasswordSetupVc * v = [PayPasswordSetupVc new];
        v.controllerType = PayPasswordForget;
        [self.navigationController pushViewController:v animated:YES];
    }
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    return v;
}


@end
