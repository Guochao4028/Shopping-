//
//  KungfuHomeHotClassCell.m
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuHomeHotClassCell.h"
#import "HotClassModel.h"
#import "KungfuCurriculumCell.h"
#import "SubjectModel.h"
#import "KungfuClassListViewController.h"
#import "SLRouteManager.h"

@interface KungfuHomeHotClassCell()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end


@implementation KungfuHomeHotClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self.contentView addSubview:self.tableView];
//        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(0);
//        }];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.tagView = [[KungfuHomeHotTagView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
        self.contentView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.tagView];

    }
    return self;
}

- (void)setHotSearchArr:(NSArray *)hotSearchArr
{
    _hotSearchArr = hotSearchArr;

    /** 注意cell的subView的重复创建！（内部已经做了处理了......） */
    [self.tagView setTagWithTagArray:hotSearchArr];

}

//- (void)setSubjectList:(NSArray *)subjectList{
//    _subjectList = subjectList;
//    [self.tableView reloadData];
//}
//#pragma mark - tableView delegate && dataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    return self.subjectList.count;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (tableView == self.tableView) {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 1)];
//        view.backgroundColor = UIColor.whiteColor;
//        return view;
//    }else {
//        return [UIView new];
//    }
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (tableView == self.tableView) {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 1)];
//        view.backgroundColor =  UIColor.whiteColor;
//        return view;
//    }
//    return [UIView new];
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    KungfuCurriculumCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KungfuCurriculumCell class])];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.model = self.subjectList[indexPath.row];
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    SubjectModel * subject = self.subjectList[indexPath.row];
//
//    KungfuClassListViewController * vc = [KungfuClassListViewController new];
//    vc.subjectModel = subject;
//    vc.hidesBottomBarWhenPushed = YES;
//
//    UINavigationController *nav = [SLRouteManager findCurrentShowingNavigationController];
//    [nav pushViewController:vc animated:YES];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    //设计图343*150
//    CGFloat imgWidth = (kScreenWidth-32);
//    CGFloat imgHeight = imgWidth*150/343;
//
//    return imgHeight;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0 && tableView == self.tableView) {
//         return 10;
//    }else {
//         return 0.01;
//    }
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//
//    return 0;
//}
#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[KungfuCurriculumCell class] forCellReuseIdentifier:NSStringFromClass([KungfuCurriculumCell class])];
        
    }
    return _tableView;
}


@end
