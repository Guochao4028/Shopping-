//
//  CancelOrdersView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "CancelOrdersView.h"

#import "CancelOrdersItemTableViewCell.h"

#import "OrderDetailsModel.h"


@interface CancelOrdersView ()<UITableViewDelegate, UITableViewDataSource>
//单元格内容
@property(nonatomic,copy)NSString * cellStr;


@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)UIView *titleView;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic, strong)UIButton *determineButton;

@property(nonatomic, weak)UILabel *titleLabel;
@property(nonatomic, weak)UILabel *promptLabel;


@end

@implementation CancelOrdersView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self =[super initWithFrame:frame]) {
        [self initData];
        [self initUI];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame reasonList:(NSArray *)list {
    if (self =[super initWithFrame:frame]) {
        [self initDataWithList:list];
        [self initUI];
    }
    
    return self;
}

#pragma mark - methods
-(void)initDataWithList:(NSArray *)list {
    NSArray *tempArray = list;
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *tempDic in tempArray) {
        NSMutableDictionary *mutabelDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
        
        [array addObject:mutabelDic];
        
    }
    
    self.cellArr = [NSArray arrayWithArray:array];
}
-(void)initData{
    
   NSArray *tempArray = @[
        @{@"title":SLLocalizedString(@"商品无货"), @"isSelect":@"0"},
        @{@"title":SLLocalizedString(@"不想要了"), @"isSelect":@"0"},
        @{@"title":SLLocalizedString(@"商品信息填写错误"), @"isSelect":@"0"},
        @{@"title":SLLocalizedString(@"地址信息填写错误"), @"isSelect":@"0"},
        @{@"title":SLLocalizedString(@"其他"), @"isSelect":@"0"},
    ];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *tempDic in tempArray) {
        NSMutableDictionary *mutabelDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
        
        [array addObject:mutabelDic];
        
    }
    
    self.cellArr = [NSArray arrayWithArray:array];
    
}

-(void)initUI{
    [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.determineButton];
}

-(void)disappear{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma mark - Action
-(void)closeAction{
    [self disappear];
}

-(void)determineAction{
    if (self.selectedBlock) {
        self.selectedBlock(self.cellStr);
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArr.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CancelOrdersItemTableViewCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"CancelOrdersItemTableViewCell"];
    [itemCell setModel:self.cellArr[indexPath.row]];
    
    itemCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return itemCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.determineButton setAlpha:1];
    [self.determineButton setEnabled:YES];
    for (int i = 0; i < self.cellArr.count; i++) {
        NSMutableDictionary *dic = self.cellArr[i];
        [dic setValue:@"0" forKey:@"isSelect"];
    }
    
    NSMutableDictionary *dic = self.cellArr[indexPath.row];
    [dic setValue:@"1" forKey:@"isSelect"];
    
    self.cellStr = dic[@"title"];
    
    [self.tableView reloadData];
}

#pragma mark - getter / setter

-(UIView *)contentView{
    
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 500, ScreenWidth, 500)];
        [_contentView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        _contentView.layer.cornerRadius = SLChange(12.5);
    }
    return _contentView;
}

-(UIView *)titleView{
    if (_titleView == nil) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - 68)/2, 15, 68, 24)];
        [titleLabel setFont:kMediumFont(17)];
        [titleLabel setText:SLLocalizedString(@"取消订单")];
        [titleLabel setTextColor:[UIColor colorForHex:@"333333"]];
        self.titleLabel = titleLabel;
        [_titleView addSubview:titleLabel];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(ScreenWidth - 48, 0, 48, 52)];
        [closeButton setImage:[UIImage imageNamed:@"goodsClose"] forState:UIControlStateNormal];
        
        [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_titleView addSubview:closeButton];
        
        UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(titleLabel.frame)+30, 225, 21)];
        [promptLabel setText:SLLocalizedString(@"请选择取消订单的原因（必选）：")];
        [promptLabel setTextColor:[UIColor colorForHex:@"333333"]];
        [promptLabel setFont:kMediumFont(15)];
        [_titleView addSubview:promptLabel];
        
        self.promptLabel = promptLabel;
        
    }
    return _titleView;

}

-(UIButton *)determineButton{
    
    if (_determineButton == nil) {
        _determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat y = CGRectGetMaxY(self.contentView.bounds) - 40 - 20;
        CGFloat width = CGRectGetWidth(self.contentView.bounds) - 32;
        [_determineButton setFrame:CGRectMake(16, y, width, 40)];
        [_determineButton setBackgroundColor:kMainYellow];
        
        [_determineButton setAlpha:0.56];
        
        [_determineButton setEnabled:NO];
        
        [_determineButton setTitle:SLLocalizedString(@"提交") forState:UIControlStateNormal];
        [_determineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_determineButton.titleLabel setFont:kRegular(15)];
        _determineButton.layer.cornerRadius = SLChange(20);
        [_determineButton addTarget:self action:@selector(determineAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determineButton;

}

-(UITableView *)tableView{
    if (_tableView == nil) {
        
        CGFloat y = CGRectGetMaxY(self.titleView.frame);
        
        CGFloat height = CGRectGetHeight(self.contentView.bounds) - ( CGRectGetHeight(self.titleView.frame) + CGRectGetHeight(self.determineButton.frame)+20);
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, height) style:UITableViewStyleGrouped];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CancelOrdersItemTableViewCell class])bundle:nil] forCellReuseIdentifier:@"CancelOrdersItemTableViewCell"];
    }
    return _tableView;
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self.titleLabel setText:titleStr];
}

-(void)setIsHiddenSubtitle:(BOOL)isHiddenSubtitle{
    _isHiddenSubtitle = isHiddenSubtitle;
    if (_isHiddenSubtitle == YES) {
        [self.promptLabel setHidden:YES];
        self.titleView.mj_h -= 21;
        self.tableView.mj_y = CGRectGetMaxY(self.titleView.frame);
    }
}

-(void)setDetailsModel:(OrderDetailsModel *)detailsModel{
    _detailsModel = detailsModel;
    NSString *status = detailsModel.status;
    if ([status isEqualToString:@"2"] == YES){
        [self.promptLabel setText:@"请选择申请退款的原因（必选）："];
        [self.titleLabel setText:@"申请退款"];
             
       }
}

@end
