//
//  RiteSecondLevelListViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/8/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteSecondLevelListViewController.h"
#import "XLPageViewController.h"
#import "ActivityManager.h"
#import "UIColor+LGFGradient.h"
#import "RiteSecondLevelModel.h"
#import "RiteThreeLevelModel.h"
#import "RiteThreeLevelListViewController.h"
#import "RiteSecondLevelListViewCell.h"

@interface RiteSecondLevelListViewController () <XLPageViewControllerDelegate, XLPageViewControllerDataSrouce>
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) UIImageView *formBackImageView;//水墨风背景
@property (nonatomic, strong) UIImageView *formLotusImageView;//莲花
@property (nonatomic, strong) XLPageViewControllerConfig *config;
@property (nonatomic, strong) XLPageViewController *pageViewController;
@end

@implementation RiteSecondLevelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.formBackImageView];
    self.view.clipsToBounds = YES;
    [self initPageViewController];
    
    [self buildData];
    
    if ([self.pujaType isEqualToString:@"4"]){
        self.titleLabe.text = SLLocalizedString(@"功德");
    } else if ([self.pujaType isEqualToString:@"3"]){
        self.titleLabe.text = SLLocalizedString(@"佛事");
    } else if ([self.pujaType isEqualToString:@"2"]){
        self.titleLabe.text = SLLocalizedString(@"法会");
    } else if ([self.pujaType isEqualToString:@"1"]){
        self.titleLabe.text = SLLocalizedString(@"水陆法会");
    }
    [self.formBackImageView addSubview:self.formLotusImageView];
    [self.formBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.formLotusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.formBackImageView);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(185);
        make.height.mas_equalTo(145);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)initPageViewController {
    XLPageViewControllerConfig *config = [XLPageViewControllerConfig defaultConfig];
    config.titleSpace = 0;
    config.titleViewHeight = 44;
    config.titleNormalColor = KTextGray_333;
    config.titleSelectedColor = UIColor.whiteColor;
    
    config.backgroundNormalColor = KTextGray_FA;
    config.backgroundSelectedColor = [UIColor lgf_GradientFromColor:[UIColor colorForHex:@"E2CBA6"] toColor:kMainYellow height:50];//kMainYellow;
    config.titleViewInset = UIEdgeInsetsMake(0, 0, 0, 0);
    config.shadowLineColor = [UIColor whiteColor];
    config.shadowLineWidth = 20;
    config.shadowLineHeight = 1;
    config.titleNormalFont = kRegular(15);
    config.titleSelectedFont = kRegular(15);
    config.titleColorTransition = NO;
    self.config = config;
    
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:config];
    self.pageViewController.view.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self.pageViewController registerClass:[RiteSecondLevelListViewCell class] forTitleViewCellWithReuseIdentifier:@"RiteSecondLevelListViewCell"];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

- (void)buildData {
    [self initPageViewController];
    NSString *code = self.pujaCode ? self.pujaCode : @"";
    NSString *type = self.pujaType ? self.pujaType : @"";
    NSDictionary *params = @{
        @"code" : code,
        @"type" : type,
    };
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [ActivityManager getRiteReservationList:params success:nil failure:nil finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        [hud hideAnimated:YES];
        self.datas = @[];
        if ([ModelTool checkResponseObject:responseObject]){
            NSArray *datas = responseObject[DATAS];
            self.datas = [RiteSecondLevelModel mj_objectArrayWithKeyValuesArray:datas];
            if (self.datas.count){
                self.config.titleWidth = CGRectGetWidth(self.view.frame)/self.datas.count;
                if (self.datas.count > 1){
                    self.config.backgroundSelectedColor = [UIColor lgf_GradientFromColor:[UIColor colorForHex:@"E2CBA6"] toColor:kMainYellow height:50];
                    self.config.titleSelectedColor = UIColor.whiteColor;
                    self.config.shadowLineColor = [UIColor whiteColor];
                } else {
                    self.config.backgroundSelectedColor = KTextGray_FA;
                    self.config.titleSelectedColor = kMainYellow;
                    self.config.shadowLineColor = kMainYellow;
                }
            } else {
                self.config.titleWidth = 0;
            }
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        }
        [self.pageViewController reloadData];
        self.pageViewController.selectedIndex = 0;
    }];
}

#pragma mark TableViewDelegate&DataSource
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    RiteThreeLevelListViewController *vc = [[RiteThreeLevelListViewController alloc] init];
    vc.pujaType = self.pujaType;
    vc.pujaCode = self.pujaCode;
    RiteSecondLevelModel *model = self.datas[index];
    vc.riteSecondLevelModel = model;
    return vc;
}

- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    RiteSecondLevelModel *model = self.datas[index];
    return model.buddhismName;
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.datas.count;
}

- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
    RiteSecondLevelModel *model = self.datas[index];
    NSLog(@"切换到了：%@", model.buddhismName);
}

- (void)pageViewController:(XLPageViewController *)pageViewController refreshAtIndex:(NSInteger)index{
    RiteThreeLevelListViewController *vc = (RiteThreeLevelListViewController *)[pageViewController viewControllerForIndex:index];
    if (![vc isKindOfClass:[RiteThreeLevelListViewController class]]) return;
    [vc refreshAndScrollToTop];
}

- (__kindof XLPageTitleCell *)pageViewController:(XLPageViewController *)pageViewController titleViewCellForItemAtIndex:(NSInteger)index {
    RiteSecondLevelListViewCell *cell = [pageViewController dequeueReusableTitleViewCellWithIdentifier:@"RiteSecondLevelListViewCell" forIndex:index];
    cell.vLineView.hidden = (self.datas.count - 1 == index);
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIImageView *)formBackImageView{
    if (!_formBackImageView){
        _formBackImageView = [[UIImageView alloc] init];
        _formBackImageView.clipsToBounds = YES;
        _formBackImageView.contentMode = UIViewContentModeScaleAspectFill;
        _formBackImageView.image = [UIImage imageNamed:@"riteFormBackImage"];
    }
    return _formBackImageView;
}

- (UIImageView *)formLotusImageView{
    if (!_formLotusImageView){
        _formLotusImageView = [[UIImageView alloc] init];
        _formLotusImageView.contentMode = UIViewContentModeScaleAspectFit;
        _formLotusImageView.image = [UIImage imageNamed:@"riteFormLotusImage"];
        
    }
    return _formLotusImageView;
}
@end
