//
//  MeCollectionVc.m
//  Shaolin
//
//  Created by edz on 2020/4/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeCollectionVc.h"
#import "XLPageViewController.h"
#import "MeCourseVc.h"
#import "MeCollectionTextVc.h"
#import "MeCollectionVideoVc.h"
@interface MeCollectionVc ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>
@property(nonatomic,strong) XLPageViewController *pageViewController;
@property(nonatomic,strong)  XLPageViewControllerConfig *config;
@property (nonatomic, strong) NSArray *enabledTitles;
@property(nonatomic,assign) NSInteger  selectEdit;
@property(nonatomic,assign) NSInteger  recordIndex;

@end

@implementation MeCollectionVc
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self setNavigationBarYellowTintColor];
}
- (void)viewWillDisappear:(BOOL)animated
{
     [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildData];
    [self setupUI];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buttonNormal) name:@"NormalCollectionButton" object:nil];
}
- (void)buttonNormal {
    [self.rightBtn setSelected:NO];
}
- (void)setupUI{
       self.titleLabe.text = SLLocalizedString(@"我的收藏");
       self.titleLabe.textColor = [UIColor whiteColor];
       [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:(UIControlStateNormal)];
      
       [self.rightBtn setTitle:SLLocalizedString(@"编辑") forState:(UIControlStateNormal)];
       [self.rightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
       [self.rightBtn setTitle:SLLocalizedString(@"完成") forState:(UIControlStateSelected)];
       [self.rightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
       [self.rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:(UIControlEventTouchUpInside)];
       self.rightBtn.titleLabel.font =kRegular(15);
}
- (void)rightAction:(UIButton *)button {
    
    button.selected = !button.selected;
    if (button.selected) {
        self.recordIndex = self.selectEdit;
        if (self.selectEdit == 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionEditCourseSelect" object:button];
        }else if(self.selectEdit == 1){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionEditTextSelect" object:button];
        }else {
             [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionEditVideoSelect" object:button];
        }
    }else {
        if (self.selectEdit == 0) {
                  [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionEditCourseNormal" object:nil];
        }else if(self.selectEdit ==1){
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionEditTextNormal" object:nil];
        }else {
             [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionEditVideoNormal" object:nil];
        }
    }
}
- (void)buildData {
    self.enabledTitles = @[SLLocalizedString(@"教程"),SLLocalizedString(@"文章"),SLLocalizedString(@"视频")];
    self.config = [XLPageViewControllerConfig defaultConfig];
      
    self.config.titleWidth = kWidth/3;
    self.config.titleSpace = 0;
    self.config.titleViewHeight = 48;
    self.config.titleViewInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.config.titleNormalFont = kRegular(14);
    self.config.titleSelectedFont = kRegular(15);
    
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
#pragma mark TableViewDelegate&DataSource
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    self.selectEdit = index;
    if (index == 0) {
        MeCourseVc *vc = [[MeCourseVc alloc] init];
        return vc;
    }else if(index == 1){
        MeCollectionTextVc *vc = [[MeCollectionTextVc alloc] init];
        return vc;
    }else {
        MeCollectionVideoVc *vc = [[MeCollectionVideoVc alloc]init];
        return vc;
    }
}
- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
     NSLog(@"%ld",index);
    self.selectEdit = index;
    if (self.recordIndex != self.selectEdit) {
        [self.rightBtn setSelected:NO];
         [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionEditCourseNormal" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionEditTextNormal" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionEditVideoNormal" object:nil];
    }
    
}


 
 

@end
