//
//  FoundViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "FoundViewController.h"
#import "RecommendViewController.h"
#import "FoundAddView.h"
#import "AllSearchViewController.h"
#import "ChooseVideoViewController.h"
#import "HomeManager.h"
#import "XLPageViewController.h"
#import <Photos/Photos.h>
#import "FoundModel.h"
#import "NewWriteTextViewController.h"
#import "AppDelegate+AppService.h"

@interface FoundViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce,UINavigationControllerDelegate>
@property(nonatomic,strong) XLPageViewController *pageViewController;
@property(nonatomic,strong) FoundAddView *foundAddView;
@property(nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSArray *enabledTitles;

@property (nonatomic, strong) NSArray *disabledTitles;
@end

@implementation FoundViewController
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [ModelTool getUserData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundPageSelectChange:) name:KNotificationFoundPageChange object:nil];
    
    [self setupSearchView];  // 上方的搜索框的
    [self initPageViewController];
    [self buildData];
    
    
    // 检查版本更新
    [[AppDelegate shareAppDelegate] checkAppVersion:NO completion:nil];
    
    [self.navigationController setDelegate:self];
}


- (void) foundPageSelectChange:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    
    NSInteger index = [dict[@"index"] integerValue];
    
    if (index < self.dataArr.count - 1) {
        self.pageViewController.selectedIndex = index + 1;
    }
}

- (void)initPageViewController {
    XLPageViewControllerConfig *config = [XLPageViewControllerConfig defaultConfig];
    config.titleSpace = SLChange(20);
    config.titleViewInset = UIEdgeInsetsMake(0, SLChange(16), 0, SLChange(16));
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:config];
    
    self.pageViewController.view.frame = CGRectMake(0, NavBar_Height+5, kWidth, kHeight-NavBar_Height-5);
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

- (void)buildData {
    [self initPageViewController];

    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    //初始化数据，配置默认已订阅和为订阅的标题数组
//    [[HomeManager sharedInstance]getHomeSegmentFieldldSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        [hud hideAnimated:NO];
//        if ([FoundModel checkResponseObject:responseObject]) {
//            NSDictionary *dicccc = @{@"name":SLLocalizedString(@"推荐"),
//                                     @"id":@"0"
//            };
//            [self.dataArr addObject:dicccc];
//            NSArray *arr =[[responseObject objectForKey:@"data"] objectForKey:@"data"];
//            [self.dataArr addObjectsFromArray:arr];
//            
//            NSMutableArray *arrTitle = [NSMutableArray array];
//            for (NSDictionary *dic in self.dataArr) {
//                [arrTitle addObject:[dic objectForKey:@"name"]];
//            }
//            self.enabledTitles = [NSMutableArray arrayWithArray:arrTitle];
//        }else
//        {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:MSG] view:self.view afterDelay:TipSeconds];
//        }
//        [self.pageViewController reloadData];
//        self.pageViewController.selectedIndex = 0;
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//        [hud hideAnimated:YES];
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
    
    
    [[HomeManager sharedInstance]getHomeSegmentFieldldSuccess:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        [hud hideAnimated:NO];
        if ([FoundModel checkResponseObject:responseObject]) {
            NSDictionary *dicccc = @{@"name":SLLocalizedString(@"推荐"),
                                     @"id":@"0"
            };
            [self.dataArr addObject:dicccc];
            NSArray *arr =[[responseObject objectForKey:@"data"] objectForKey:@"data"];
            [self.dataArr addObjectsFromArray:arr];
            
            NSMutableArray *arrTitle = [NSMutableArray array];
            for (NSDictionary *dic in self.dataArr) {
                [arrTitle addObject:[dic objectForKey:@"name"]];
            }
            self.enabledTitles = [NSMutableArray arrayWithArray:arrTitle];
        }else
        {
            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:MSG] view:self.view afterDelay:TipSeconds];
        }
        [self.pageViewController reloadData];
        self.pageViewController.selectedIndex = 0;
    }];
    
}
#pragma mark TableViewDelegate&DataSource
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    RecommendViewController *vc = [[RecommendViewController alloc] init];
    NSDictionary *dic = self.dataArr[index];
    vc.identifier = index;
    vc.selectPage = [[dic objectForKey:@"id"] integerValue];
    return vc;
}

- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    return self.enabledTitles[index];
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.enabledTitles.count;
}

- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
    NSDictionary *dic = self.dataArr[index];
    NSLog(@"%@",dic);
    NSDictionary *dicc = @{
        @"identifier":[NSString stringWithFormat:@"%ld", index]
    };
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Found_ReloadCurrentPage" object:nil userInfo:dicc];
    NSLog(@"切换到了：%@",[self enabledTitles][index]);
}

- (void)pageViewController:(XLPageViewController *)pageViewController refreshAtIndex:(NSInteger)index{
    RecommendViewController *vc = (RecommendViewController *)[pageViewController viewControllerForIndex:index];
    if (![vc isKindOfClass:[RecommendViewController class]]) return;
    [vc refreshAndScrollToTop];
}

#pragma mark - 搜索框
-(void)setupSearchView
{

    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    view.userInteractionEnabled = YES;
    view.layer.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = 15;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(56);
        make.right.mas_equalTo(-56);
        make.top.mas_equalTo(StatueBar_Height + 7);
        //        make.height.mas_equalTo(SLChange(30));
        make.height.mas_equalTo(30);
    }];
    
    
    UIButton * topLeftBtn = [[UIButton alloc] init];
    topLeftBtn.userInteractionEnabled = NO;
    [self.view addSubview:topLeftBtn];
    [topLeftBtn setImage:[UIImage imageNamed:@"navigationBar_leftIcon"] forState:UIControlStateNormal];
    [topLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(StatueBar_Height + 7);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(view.mas_left);
    }];
    
    
    UIButton *searchBtn = [[UIButton alloc]init];
    [view addSubview:searchBtn];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:(UIControlStateNormal)];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SLChange(12.5));
        make.left.mas_equalTo(SLChange(16));
        make.centerY.mas_equalTo(view);
    }];
    
    UILabel *searchLabel = [[UILabel alloc]init];
    [view addSubview:searchLabel];
    searchLabel.numberOfLines = 1;
    searchLabel.font = kRegular(12);
    searchLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    searchLabel.text = SLLocalizedString(@"搜索");
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(searchBtn.mas_right).offset(SLChange(14));
        make.right.mas_equalTo(view.mas_right).offset(-SLChange(43));
        make.centerY.mas_equalTo(view);
        make.height.mas_equalTo(SLChange(16.5));
    }];
    
    UIButton *addBtn = [[UIButton alloc]init];
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:(UIControlStateNormal)];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SLChange(17));
        make.right.mas_equalTo(-SLChange(15.5));
        make.centerY.mas_equalTo(view);
    }];
    
    UIView *bottomLineView = [[UIView alloc] init];
    [self.view addSubview:bottomLineView];
    
    bottomLineView.backgroundColor =[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    //    bottomLineView.backgroundColor = [UIColor redColor];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        
        make.bottom.mas_equalTo(-Height_TabBar-1);
        make.height.mas_equalTo(SLChange(1));
    }];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushSearchView:)];
    [view addGestureRecognizer:tapGes];
}
-(void)pushSearchView:(UITapGestureRecognizer *)tagGes
{
    
    AllSearchViewController *searVC = [[AllSearchViewController alloc]init];
    searVC.tabbarStr = @"Found";
    searVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searVC animated:YES];
}


-(void)addAction
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
        NSLog(@"因为系统原因, 无法访问相册");
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝访问相册
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"温馨提示") message:SLLocalizedString(@"请在设置中允许访问相册功能") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:SLLocalizedString(@"确定") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }];
        [sureBtn setValue:[UIColor redColor] forKey:@"titleTextColor"];
        [alertVc addAction:cancelBtn];
        [alertVc addAction :sureBtn];
        [self presentViewController:alertVc animated:YES completion:nil];
        
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许访问相册
        // 放一些使用相册的代码
        [self writeTextAndVideo];
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_async(mainQueue,^{
                    
                    // 放一些使用相册的代码
                    [self writeTextAndVideo];
                    
                    
                });
                
            }
        }];
    }
    
}
-(void)writeTextAndVideo
{
    _foundAddView = [[FoundAddView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    __block FoundViewController *strongBlock = self;
    
    _foundAddView.ChooseBlock = ^(NSInteger i) {
        NSString *strState = [SLAppInfoModel sharedInstance].verifiedState;
        
        if (IsNilOrNull(strState) || [strState isEqualToString:@"0"] || [strState isEqualToString:@"3"]) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"您还没有实名认证，请前往\"我的\"进行实名认证") view:strongBlock.view afterDelay:TipSeconds];
            return;
        }
        
        if ([strState isEqualToString:@"2"]) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"实名认证正在审核中，请耐心等待") view:strongBlock.view afterDelay:TipSeconds];
            return;
        }
        
       
        
        if (i == 1) {
            NewWriteTextViewController *writeVC = [[NewWriteTextViewController alloc]init];
            writeVC.hidesBottomBarWhenPushed = YES;
            [strongBlock.navigationController pushViewController:writeVC animated:YES];
        }else
        {
            
            ChooseVideoViewController *writeVC = [[ChooseVideoViewController alloc]init];
            writeVC.hidesBottomBarWhenPushed = YES;
            [strongBlock.navigationController pushViewController:writeVC animated:YES];
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_foundAddView];
}

#pragma mark - device
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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
