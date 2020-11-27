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
#import "XLPageViewControllerConfig.h"
#import <Photos/Photos.h>
#import "FoundModel.h"
#import "NewWriteTextViewController.h"
#import "AppDelegate+AppService.h"
#import "SLRouteManager.h"
#import "FieldModel.h"
#import "XLPagePictureAndTextTitleCell.h"

@interface FoundViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce,UINavigationControllerDelegate>
@property(nonatomic,strong) XLPageViewController *pageViewController;
@property(nonatomic,strong) FoundAddView *foundAddView;
@property(nonatomic,strong) NSArray <FieldModel *> *dataArr;

@property (nonatomic, strong) NSArray *disabledTitles;
@end

@implementation FoundViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIButton *leftButton = [self leftBtn];
    leftButton.titleLabel.font = kMediumFont(20);
    [leftButton setTitle:SLLocalizedString(@"发现") forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [leftButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    UIButton *rightButton = [self rightBtn];
    [rightButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    
    [ModelTool getUserData:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundPageSelectChange:) name:KNotificationFoundPageChange object:nil];
    
//    [self setupSearchView];  // 上方的搜索框的
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
    config.titleViewStyle = XLPageTitleViewStylePictureAndText;
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:config];
    
//    self.pageViewController.view.frame = CGRectMake(0, 0, kWidth, kHeight - 10 - TabbarHeight);
    [self.pageViewController registerClass:[XLPagePictureAndTextTitleCell class] forTitleViewCellWithReuseIdentifier:@"XLPagePictureAndTextTitleCell"];
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
            NSMutableArray *dataArray = [@[] mutableCopy];
//            NSDictionary *dicccc = @{@"name":SLLocalizedString(@"推荐"),
//                                     @"id":@"0",
//                                     @"image":@"",
//            };
//            [dataArray addObject:dicccc];
            NSArray *arr =[[responseObject objectForKey:@"data"] objectForKey:@"data"];
            [dataArray addObjectsFromArray:arr];
            
            self.dataArr = [FieldModel mj_objectArrayWithKeyValuesArray:dataArray];
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
    FieldModel *model = self.dataArr[index];
    vc.identifier = index;
    vc.selectPage = [model.fieldId intValue];
    return vc;
}

- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    FieldModel *model = self.dataArr[index];
    return model.name;
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.dataArr.count;
}

- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
    NSDictionary *dicc = @{
        @"identifier":[NSString stringWithFormat:@"%ld", index]
    };
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Found_ReloadCurrentPage" object:nil userInfo:dicc];
    FieldModel *model = self.dataArr[index];
    NSLog(@"切换到了：%@", model.name);
}

- (void)pageViewController:(XLPageViewController *)pageViewController refreshAtIndex:(NSInteger)index{
    RecommendViewController *vc = (RecommendViewController *)[pageViewController viewControllerForIndex:index];
    if (![vc isKindOfClass:[RecommendViewController class]]) return;
    [vc refreshAndScrollToTop];
}

- (__kindof XLPageTitleCell *)pageViewController:(XLPageViewController *)pageViewController titleViewCellForItemAtIndex:(NSInteger)index {
    XLPagePictureAndTextTitleCell *cell = [pageViewController dequeueReusableTitleViewCellWithIdentifier:NSStringFromClass([XLPagePictureAndTextTitleCell class]) forIndex:index];
    FieldModel *model = self.dataArr[index];
    cell.model = model;
    return cell;
}

- (void)searchDidSelectHandle{
    
    AllSearchViewController *searVC = [[AllSearchViewController alloc]init];
    searVC.tabbarStr = @"Found";
    searVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searVC animated:YES];
}

- (void)rightAction
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
        [SLRouteManager pushRealNameAuthenticationState:strongBlock.navigationController showAlert:YES isReloadData:YES finish:^(SLRouteRealNameAuthenticationState state) {
            if (state == RealNameAuthenticationStateSuccess){
                if (i == 1) {
                    NewWriteTextViewController *writeVC = [[NewWriteTextViewController alloc]init];
                    writeVC.hidesBottomBarWhenPushed = YES;
                    [strongBlock.navigationController pushViewController:writeVC animated:YES];
                }
                else {
                    ChooseVideoViewController *writeVC = [[ChooseVideoViewController alloc]init];
                    writeVC.hidesBottomBarWhenPushed = YES;
                    [strongBlock.navigationController pushViewController:writeVC animated:YES];
                }
            }
        }];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_foundAddView];
}

#pragma mark - getter
- (UIView *)titleCenterView{
//    return self.searchBar;
    return self.searchView;
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
