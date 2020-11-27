//
//  AddressListView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AddressListView.h"

#import "AddressListTableViewCell.h"

static NSString *const kAddressListTableViewCellIdentifier = @"AddressListTableViewCell";

@interface AddressListView ()<UITableViewDelegate, UITableViewDataSource, AddressListTableViewCellDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIButton *createButton;

@end

@implementation AddressListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    [self addSubview:self.createButton];
    [self addSubview:self.tableView];
    
}


#pragma mark - action
-(void)tapButtonAction{
    if ([self.delegate respondsToSelector:@selector(addressListView:tap:)] == YES) {
        [self.delegate addressListView:self tap:YES];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = KTextGray_FA;
    return view;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 0;
    tableViewH = 68;
    return tableViewH;
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
     
    AddressListTableViewCell *addressListCell = [tableViews dequeueReusableCellWithIdentifier:kAddressListTableViewCellIdentifier];
    addressListCell.model = self.dataArray[indexPath.row];
    [addressListCell setDelegate:self];
    return addressListCell;
}

#pragma mark -  AddressListTableViewCellDelegate
-(void)addressListCell:(AddressListTableViewCell *)cell tap:(AddressListModel *)model{
    if ([self.delegate respondsToSelector:@selector(addressListView:isModify:)] == YES) {
        [self.delegate addressListView:self isModify:model];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressListModel *model = self.dataArray[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(addressListView:isTap:)] == YES) {
        
        [self.delegate addressListView:self isTap:model];
    }
}


#pragma mark - getter / setter

-(UITableView *)tableView{
    
    if (_tableView == nil) {
        CGFloat temHeigth = CGRectGetHeight(self.bounds) - CGRectGetMinY(self.createButton.frame);
        CGFloat heigth = CGRectGetHeight(self.bounds) - temHeigth;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, heigth)];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
              
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
        if(@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddressListTableViewCell class])bundle:nil] forCellReuseIdentifier:kAddressListTableViewCellIdentifier];
        
    }
    return _tableView;

}

-(UIButton *)createButton{
   if (_createButton == nil) {
        _createButton = [UIButton buttonWithType:UIButtonTypeCustom];

       CGFloat x = (ScreenWidth - 250)/2;
       CGFloat y = CGRectGetHeight(self.bounds) - (40 +28);
       
       [_createButton setFrame:CGRectMake(x, y, 250, 40)];
       _createButton.layer.cornerRadius = SLChange(18);
       [_createButton setBackgroundColor:kMainYellow];
       [_createButton setTitle:SLLocalizedString(@"新建收货地址") forState:UIControlStateNormal];
       [_createButton setImage:[UIImage imageNamed:@"baiJia"] forState:UIControlStateNormal];
       [_createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       
       [_createButton addTarget:self action:@selector(tapButtonAction) forControlEvents:UIControlEventTouchUpInside];
       [_createButton.titleLabel setFont:kRegular(15)];
        
    }
    return _createButton;
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

@end
