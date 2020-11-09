//
//  KfClassContainerCell.m
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//
//  这个cell里放一个tableView，tableview的cell是单节教程

#import "KfClassContainerCell.h"
#import "KungfuClassSubCell.h"
#import "ZFTableData.h"
#import "ClassDetailModel.h"
#import "ClassGoodsModel.h"

static NSString *const classSubCellId = @"KungfuClassSubCell";

@interface KfClassContainerCell()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView   * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation KfClassContainerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.bounces = NO;
        self.tableView.scrollsToTop = NO;
        
        self.tableView.estimatedRowHeight = 64;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KungfuClassSubCell class]) bundle:nil] forCellReuseIdentifier:classSubCellId];
        
        //self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.tableView];
        
        self.dataSource = @[].mutableCopy;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    self.tableView.frame = CGRectMake(0, 0, kWidth, CGRectGetHeight(self.frame));
}

-(void)setCurrentClassIndex:(NSInteger)currentClassIndex {
    _currentClassIndex = currentClassIndex;
    
    if (_currentClassIndex != 999) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentClassIndex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    
    [self.tableView reloadData];
}

- (void)setModel:(ClassDetailModel *)model{
    _model = model;
    [self.dataSource removeAllObjects];
    if (model){
        [self.dataSource addObjectsFromArray:model.goods_next];
        [self.tableView reloadData];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return NO;
}

#pragma mark - delegate && dataSources

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KungfuClassSubCell * cell = [tableView dequeueReusableCellWithIdentifier:classSubCellId forIndexPath:indexPath];
    ClassGoodsModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.detailModel = self.model;
    
    if (self.currentClassIndex == indexPath.row) {
        cell.isPlaying = YES;
    } else {
        cell.isPlaying = NO;
    }

//    if ([self.model.history.attr_id isEqualToString:model.classGoodsId]) {
//        // 是后台保存的播放记录
//        cell.isPlaying = YES;
//    } else {
//        cell.isPlaying = NO;
//    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (self.currentClassIndex == indexPath.row) {
//        //正在播放时不做操作
//        return;
//    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationClassVideoPlay object:@{@"index":[NSString stringWithFormat:@"%ld",indexPath.row]}];
    if (self.cellSelectBlock) {
        self.cellSelectBlock(indexPath.row);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.rowHeight;
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
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return v;
}

@end
