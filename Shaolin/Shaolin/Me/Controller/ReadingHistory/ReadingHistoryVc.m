//
//  ReadingHistoryVc.m
//  Shaolin
//
//  Created by edz on 2020/4/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ReadingHistoryVc.h"
#import "XLPageViewController.h"
#import "ReadingTextViewController.h"
#import "ReadingVideoVc.h"
@interface ReadingHistoryVc ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>
@property(nonatomic,strong) XLPageViewController *pageViewController;
@property(nonatomic,strong)  XLPageViewControllerConfig *config;
@property (nonatomic, strong) NSArray *enabledTitles;
@property(nonatomic,assign) NSInteger  selectEdit;
@property(nonatomic,assign) NSInteger  recordIndex;
@end

@implementation ReadingHistoryVc
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self wr_setNavBarBarTintColor:[UIColor hexColor:@"8E2B25"]];
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarBackgroundAlpha:1];
//    self.navigationController.navigationBar.barTintColor = RGBA(132, 50, 42, 1);
//    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
     [super viewWillDisappear:animated];
//     self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self buildData];
    [self setUI];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buttonNormal) name:@"NormalButton" object:nil];
}
- (void)buttonNormal {
    [self.rightBtn setSelected:NO];
}
-(void)setUI{
       self.titleLabe.text = SLLocalizedString(@"阅读历史");
       self.titleLabe.textColor = [UIColor whiteColor];
       [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:(UIControlStateNormal)];
       [self.rightBtn setTitle:SLLocalizedString(@"编辑") forState:(UIControlStateNormal)];
       [self.rightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
       [self.rightBtn setTitle:SLLocalizedString(@"完成") forState:(UIControlStateSelected)];
       [self.rightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
       [self.rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:(UIControlEventTouchUpInside)];
       self.rightBtn.titleLabel.font =kRegular(15);
}
- (void)buildData {
    self.enabledTitles = @[SLLocalizedString(@"文章"),SLLocalizedString(@"视频")];
    self.config = [XLPageViewControllerConfig defaultConfig];
    self.config.titleWidth = kWidth/4;
    self.config.titleSpace = 0;
    self.config.titleViewHeight = 48;
    self.config.titleViewInset = UIEdgeInsetsMake(0, kWidth/4, 0, kWidth/4);
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:self.config];
    self.pageViewController.view.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self.pageViewController reloadData];
    self.pageViewController.selectedIndex = 0;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}
- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    return self.enabledTitles[index];
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.enabledTitles.count;
}
- (void)rightAction:(UIButton *)button {
    
    button.selected = !button.selected;
    if (button.selected) {
        self.recordIndex = self.selectEdit;
        if (self.selectEdit == 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"selectEditTextSelect" object:nil];
        }else {
             [[NSNotificationCenter defaultCenter]postNotificationName:@"selectEditVideoSelect" object:nil];
        }
    }else {
        if (self.selectEdit == 0) {
                   [[NSNotificationCenter defaultCenter]postNotificationName:@"selectEditTextNormal" object:nil];
               }else {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectEditVideoNormal" object:nil];
        }
    }
}
#pragma mark TableViewDelegate&DataSource
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    NSLog(@"%ld",index);
    self.selectEdit = index;
    if (index == 0) {
        ReadingTextViewController *vc = [[ReadingTextViewController alloc] init];
        return vc;
    }else {
        ReadingVideoVc *vc = [[ReadingVideoVc alloc] init];
        return vc;
    }
}
- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
     NSLog(@"%ld",index);
    self.selectEdit = index;
    if (self.recordIndex != self.selectEdit) {
        [self.rightBtn setSelected:NO];
       
    }
    if (index == 0) {
         [[NSNotificationCenter defaultCenter]postNotificationName:@"selectEditVideoNormal" object:nil];
    }else {
         [[NSNotificationCenter defaultCenter]postNotificationName:@"selectEditTextNormal" object:nil];
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
