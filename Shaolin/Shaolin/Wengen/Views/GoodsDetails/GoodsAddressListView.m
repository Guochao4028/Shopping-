//
//  GoodsAddressListView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsAddressListView.h"

#import "GoodsAddressListTableCell.h"

#import "AddressListModel.h"

static NSString *const kGoodsAddressListTableCellIdentifier = @"GoodsAddressListTableCell";

@interface GoodsAddressListView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UIView *contentView;

@property(nonatomic, strong)UILabel *titleLabel;

@property(nonatomic, strong)UIButton *closeButton;

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIButton *addressButton;

@end

@implementation GoodsAddressListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.closeButton];
    
    [self.contentView addSubview:self.tableView];
    
    [self.contentView addSubview:self.addressButton];
    
    
}


#pragma mark - action

-(void)closeTarget:(nullable id)target action:(SEL)action{
    [self.closeButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)createAddressTarget:(nullable id)target action:(SEL)action{
    [self.addressButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 0;
    tableViewH = 44;
    return tableViewH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    GoodsAddressListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsAddressListTableCellIdentifier];
    
    [cell setModel:self.dataArray[indexPath.row]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for (AddressListModel *model in self.dataArray) {
        model.isSelected = NO;
    }
    
    AddressListModel *model = self.dataArray[indexPath.row];
    model.isSelected = YES;
    
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(tapAddress:)] == YES) {
        [self.delegate tapAddress:indexPath.row];
        [self removeFromSuperview];
    }
}

#pragma mark - getter / setter

-(UIView *)contentView{
    
    if (_contentView == nil) {
        CGFloat heigth = 500 + TabBarButtom_H;
        CGFloat y = self.height - heigth;
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, y, self.width, heigth)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        
        _contentView.layer.cornerRadius = SLChange(12);
    }
    return _contentView;

}

-(UILabel *)titleLabel{
    
    if (_titleLabel == nil) {
        CGFloat x = (self.width - 51)/2;
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 15, 51, 24)];
        
        [_titleLabel setFont:kRegular(17)];
        [_titleLabel setTextColor:[UIColor colorForHex:@"333333"]];
        [_titleLabel setText:SLLocalizedString(@"配送至")];
    }
    return _titleLabel;
}

-(UIButton *)closeButton{
    
    if (_closeButton == nil) {
        
        CGFloat x = self.width - 50;
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setFrame:CGRectMake(x, 0, 50, 50)];
        [_closeButton setImage:[UIImage imageNamed:@"goodsClose"] forState:UIControlStateNormal];
        
    }
    return _closeButton;

}

-(UITableView *)tableView{
    
    if (_tableView == nil) {
        
        CGFloat y = CGRectGetMaxY(self.closeButton.frame);
        CGFloat heigth = CGRectGetHeight(self.contentView.bounds) - 70 - y;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, self.width, heigth)];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
        if(@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsAddressListTableCell class])bundle:nil] forCellReuseIdentifier:kGoodsAddressListTableCellIdentifier];
    }
    return _tableView;

}

-(UIButton *)addressButton{
    
    if (_addressButton == nil) {
        _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat y = CGRectGetMaxY(self.tableView.frame);
        CGFloat x = (self.width - 250)/2;
        [_addressButton setFrame:CGRectMake(x, y, 250, 40)];
        [_addressButton setBackgroundColor:kMainYellow];
        [_addressButton setTitle:SLLocalizedString(@"新增收货地址") forState:UIControlStateNormal];
        [_addressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _addressButton.layer.cornerRadius = SLChange(20);
        
        
    }
    return _addressButton;

}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
}



@end
