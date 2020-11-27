//
//  AboutShaolinViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AboutShaolinViewController.h"
#import "AppDelegate+AppService.h"
#import "KungfuWebViewController.h"
#import "WengenWebViewController.h"
#import "DefinedHost.h"

@interface AboutShaolinViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UILabel *tipsLabel;

@end

@implementation AboutShaolinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI{
    [self.view setBackgroundColor:BackgroundColor_White];
    [self.titleLabe setText:SLLocalizedString(@"关于少林")];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.tipsLabel];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).mas_offset(120);
        make.centerX.mas_equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     static NSString *cellIdentifier = @"cellID";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if (!cell)
     {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
         UIImageView * arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_arrow"]];
         cell.accessoryView = arrow;
     }
    
    
    NSArray *arr = @[SLLocalizedString(@"新版本检测"), SLLocalizedString(@"用户服务协议"), SLLocalizedString(@"隐私政策"), SLLocalizedString(@"邀约")];
    cell.textLabel.font = kRegular(16);
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = arr[indexPath.row];
    if (indexPath.row == 0) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"V %@", VERSION_STR]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
            // 检查版本更新
            [[AppDelegate shareAppDelegate] checkAppVersion:YES completion:^(BOOL hasUpdate) {
                if (hasUpdate == NO) {
                    [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"当前已是最新版本")];
                }else{
                    
                }
            }];
        }
            break;
        case 1:{
            // 用户协议
            KungfuWebViewController * webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_RegisterUrl type:0];
            webVC.titleStr = SLLocalizedString(@"用户服务协议");
            
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 2:{
            // 用户协议
            KungfuWebViewController * webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_PrivacyPolicyUrl type:0];
            webVC.titleStr = SLLocalizedString(@"隐私政策");
            
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 3:{
            
            WengenWebViewController *vc = [[WengenWebViewController alloc]initWithUrl:URL_H5_Invitation title:SLLocalizedString(@"邀请好友")];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
            
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

#pragma mark - getter / setter
-(UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50 * 4)];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:BackgroundColor_White];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;

}

- (UILabel *)tipsLabel{
    if (!_tipsLabel){
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"Shaolinapp.com\n登封市少林文化产业有限公司\n版权所有";
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = kRegular(15);
        _tipsLabel.textColor = KTextGray_999;
    }
    return _tipsLabel;
}
@end
