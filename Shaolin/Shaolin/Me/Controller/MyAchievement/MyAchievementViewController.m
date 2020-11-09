//
//  MyAchievementViewController.m
//  Shaolin
//
//  Created by ws on 2020/6/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MyAchievementViewController.h"


#import "ScoreListModel.h"
#import "KungfuManager.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MyAchievementCell.h"



@interface MyAchievementViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSDictionary * scoreDic;

//@property(nonatomic, assign) NSInteger rowsNumber;
@end

@implementation MyAchievementViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBarRedTintColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabe.text = SLLocalizedString(@"我的成就");
    self.view.backgroundColor = RGBA(250, 250, 250, 1);
    [self layoutView];
    
    [[KungfuManager sharedInstance] getLevelAchievementsAndCallback:^(NSDictionary *result) {
           
        self.scoreDic = result;
        
//        if (IsNilOrNull(self.scoreDic) || self.scoreDic.allKeys.count == 0) {
//            self.rowsNumber = 0;
//        } else {
//            if ([self.scoreDic.allValues containsObject:@"level"]) {
//                NSString * levelStr = self.scoreDic[@"level"];
//                if (![levelStr isEqualToString:@"0%"]) {
//                    self.rowsNumber += 1;
//                }
//            }
//            if ([self.scoreDic.allValues containsObject:@"curriculum"]) {
//                NSString * curriculumStr = self.scoreDic[@"curriculum"];
//                if (![curriculumStr isEqualToString:@"0%"]) {
//                    self.rowsNumber += 1;
//                }
//            }
//        }
        
        [self.tableView reloadData];
    }];
}


-(void)layoutView
{
    
    self.titleLabe.textColor = [UIColor whiteColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:(UIControlStateNormal)];
   
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, kWidth, kHeight - 15) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColor.clearColor;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyAchievementCell class]) bundle:nil] forCellReuseIdentifier:@"MyAchievementCell"];
    
    //self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];

}


#pragma mark - DZNEmptyDataSetDelegate && dataSource
//- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
//    return !self.rowsNumber;
//}
//
//
//-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return -50;
//}
//
//
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = SLLocalizedString(@"您还没有成就");
//
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
//                                 NSForegroundColorAttributeName: [UIColor hexColor:@"999999"]};
//
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}
//
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIImage imageNamed:@"categorize_nogoods"];
//}

#pragma mark - delegate && dataSources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    WEAKSELF
    MyAchievementCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyAchievementCell"];
    
    NSString * levelStr = NotNilAndNull(self.scoreDic[@"level"])?self.scoreDic[@"level"]:@"";
    NSString * curriculumStr = NotNilAndNull(self.scoreDic[@"curriculum"])?self.scoreDic[@"curriculum"]:@"";
    
    NSString * bottomString = @"";
    
    if (indexPath.section == 0 && self.scoreDic) {
        cell.myAchieveLabel.text = SLLocalizedString(@"教程成就");
//        if ([curriculumStr isEqualToString:@"0%"]) {
//            bottomString = SLLocalizedString(@"您当前暂无学习教程");
//        } else {
            bottomString = [NSString stringWithFormat:SLLocalizedString(@"您已学的教程已超过全球%@的学员"),curriculumStr];
//        }
    } else {
        if (self.scoreDic) {
            cell.myAchieveLabel.text = SLLocalizedString(@"位阶成就");
//            if ([levelStr isEqualToString:@"0%"]) {
//                bottomString = SLLocalizedString(@"您当前暂无考取位阶");
//            } else {
                bottomString = [NSString stringWithFormat:SLLocalizedString(@"您已考的位阶已超过全球%@的学员"),levelStr];
//            }
        }
    }
    cell.bottomLabel.text = bottomString;
//    ScoreListModel *model = self.scoreList[indexPath.row];
//    cell.cellModel = model;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.checkHandle = ^{
//
//    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return v;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    return v;
}

@end
