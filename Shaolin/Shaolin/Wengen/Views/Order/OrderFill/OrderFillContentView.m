//
//  OrderFillContentView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillContentView.h"

#import "OrderFillContentTableHeadView.h"

#import "OrderFillContentTableFooterView.h"

#import "OrderFillContentStoreInfoView.h"

#import "OrderFillGoodsTableCell.h"

#import "GoodsStoreInfoModel.h"

#import "ShoppingCartGoodsModel.h"

#import "AddressListModel.h"

#import "UILabel+Size.h"

#import "OrderFillGoodsItemFooterView.h"

static NSString *const kOrderFillGoodsTableCellIdentifier = @"OrderFillGoodsTableCell";

@interface OrderFillContentView ()<UITableViewDelegate, UITableViewDataSource, OrderFillGoodsTableCellDelegate>

@property(nonatomic, strong)OrderFillContentTableHeadView *tabelHeadView;
@property(nonatomic, strong)OrderFillContentTableFooterView *tabelFooterView;

@property(nonatomic, strong)UITableView *tabelView;

@end

@implementation OrderFillContentView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

#pragma mark - methods

-(void)initUI{
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.tabelView];
}

#pragma mark - action

-(void)invoiceViewAction{
    
    if ([self.delegate respondsToSelector:@selector(orderFillContentView:tapInvoiceView:)] == YES) {
        [self.delegate orderFillContentView:self tapInvoiceView:YES];
    }
    
}

-(void)headViewTapAction{
    if ([self.delegate respondsToSelector:@selector(orderFillContentView:tapAddressView:)] == YES) {
        [self.delegate orderFillContentView:self tapAddressView:YES];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 90;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *hIdentifier = @"hIdentifier";
    
    UITableViewHeaderFooterView *view= [tableView dequeueReusableHeaderFooterViewWithIdentifier:hIdentifier];
    OrderFillContentStoreInfoView *headView;
    if(view == nil){
        view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        headView = [[OrderFillContentStoreInfoView alloc]initWithFrame:view.bounds];
        [view.contentView addSubview:headView];
    }
    
    NSDictionary *dic = [self.dataArray objectAtIndex:section];
    GoodsStoreInfoModel *stroeInfo = dic[@"stroeInfo"];
    [headView setInfoModel:stroeInfo];
    
    return view;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor colorForHex:@"FAFAFA"];
//    return view;
    
    
    
    UITableViewHeaderFooterView *view= [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerView"];
    OrderFillGoodsItemFooterView *footerView;
    if(view == nil){
        view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
        footerView = [[OrderFillGoodsItemFooterView alloc]initWithFrame:view.bounds];
        [view.contentView addSubview:footerView];
    }
    
    
    [footerView setGoodsDic:[self.dataArray objectAtIndex:section]];
    
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = [self.dataArray objectAtIndex:section];
    NSArray *goodsArray = dic[@"goods"];
    return goodsArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    OrderFillGoodsTableCell *orderFillGoodsCell = [tableView dequeueReusableCellWithIdentifier:kOrderFillGoodsTableCellIdentifier];
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *goodsArray = dic[@"goods"];
    ShoppingCartGoodsModel *goodsModel = [goodsArray objectAtIndex:indexPath.row];
    
    orderFillGoodsCell.cartGoodsModel = goodsModel;
    
    [orderFillGoodsCell setDelegate:self];
    
    return orderFillGoodsCell;
}

#pragma mark - OrderFillGoodsTableCellDelegate
-(void)orderFillGoodsTableCell:(OrderFillGoodsTableCell *)cellView calculateCount:(NSInteger)count model:(ShoppingCartGoodsModel *)model{
    if ([self.delegate respondsToSelector:@selector(orderFillContentView:calculateCount:model:)] == YES) {
        [self.delegate orderFillContentView:self calculateCount:count model:model];
    }
}


#pragma mark - getter / setter
-(UITableView *)tabelView{
    
    if (_tabelView == nil) {
        _tabelView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
        
        [_tabelView setDelegate:self];
        [_tabelView setDataSource:self];
        [_tabelView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderFillGoodsTableCell class])bundle:nil] forCellReuseIdentifier:kOrderFillGoodsTableCellIdentifier];
        [_tabelView setTableFooterView:self.tabelFooterView];
    }
    return _tabelView;

}

-(OrderFillContentTableHeadView *)tabelHeadView{
    if (_tabelHeadView == nil) {
        _tabelHeadView = [[OrderFillContentTableHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 104)];
        [_tabelHeadView orderFillContentTableHeadTarget:self action:@selector(headViewTapAction)];
    }
    return _tabelHeadView;
}

-(OrderFillContentTableFooterView *)tabelFooterView{
    
    if (_tabelFooterView == nil) {
        _tabelFooterView = [[OrderFillContentTableFooterView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 117)];
        [_tabelFooterView invoiceTarget:self action:@selector(invoiceViewAction)];
    }
    return _tabelFooterView;

}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.tabelView reloadData];
}

-(void)setAddressListModel:(AddressListModel *)addressListModel{
    _addressListModel = addressListModel;
    self.tabelHeadView.mj_h = 82 +[UILabel  getLabelHeightWithText:addressListModel.address width:(ScreenWidth - 40) font:kMediumFont(16)] +1;
    [self.tabelHeadView setAddressListModel:addressListModel];
    [self.tabelView setTableHeaderView:self.tabelHeadView];
    [self.tabelView reloadData];
}

-(void)setGoodsAmountTotal:(NSString *)goodsAmountTotal{
    [self.tabelFooterView setGoodsAmountTotal:goodsAmountTotal];
}

-(void)setFreightTotal:(NSString *)freightTotal{
    
    [self.tabelFooterView setFreightTotal:freightTotal];
}

-(void)setInvoiceContent:(NSString *)invoiceContent{
    [self.tabelFooterView setInvoiceContent:invoiceContent];
}


@end
