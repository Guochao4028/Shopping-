//
//  OrderInvoicePopupView.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderInvoicePopupView.h"
#import "MutableCopyCatetory.h"

#import "OrderInvoiceSelectedTableCell.h"

@interface OrderInvoicePopupView ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)UIView *titleView;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic, weak)UILabel *titleLabel;


@end

@implementation OrderInvoicePopupView

#pragma mark - methods


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self =[super initWithFrame:frame]) {
//        @{@"title":SLLocalizedString(@"商品无货"), @"isSelect":@"0"},
        [self initUI];
        [self initData];
    }
    
    return self;
}

- (void)initUI{
    [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.tableView];
}

- (void)initData{
    self.cellArr = [self.cellArr mutableArrayDeeoCopy];
    [self.tableView reloadData];
}

- (void)disappear{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma mark - Action
- (void)closeAction{
    [self disappear];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArr.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderInvoiceSelectedTableCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"OrderInvoiceSelectedTableCell"];
    [itemCell setModel:self.cellArr[indexPath.row]];

    itemCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return itemCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dic = self.cellArr[indexPath.row];
    
    NSString *title = dic[@"title"];
    
    if(dic[@"is_electronic"] != nil || dic[@"is_VAT"] != nil){
        BOOL is_electronic = [dic[@"is_electronic"] boolValue];
        BOOL is_VAT = [dic[@"is_VAT"] boolValue];
        

        
//        if ([title isEqualToString:SLLocalizedString(@"电子发票")]) {
//            if (is_electronic == NO) {
//                return;
//            }
//        }
//        if ([title isEqualToString:SLLocalizedString(@"增值税专用发票")]) {
//            if (is_VAT == NO) {
//                return;
//            }
//        }
        
        if ([title isEqualToString:SLLocalizedString(@"纸质发票")]) {
            if (is_electronic == NO) {
                return;
            }
        }
        if ([title isEqualToString:SLLocalizedString(@"增值税专用发票")]) {
            if (is_VAT == NO) {
                return;
            }
        }
    }
    for (int i = 0; i < self.cellArr.count; i++) {
        NSMutableDictionary *tempDic = self.cellArr[i];
        [tempDic setValue:@"0" forKey:@"isSelect"];
    }
    
    [dic setValue:@"1" forKey:@"isSelect"];
    
    if ([title isEqualToString:SLLocalizedString(@"增值税专用发票")]) {
        if ([dic[@"optional"] boolValue] == NO) {
            [ShaolinProgressHUD singleTextAutoHideHud:@"请先填写增票资质"];
            return;
        }
    }
    
    [self.tableView reloadData];
    
    if (self.selectedBlock) {
        self.selectedBlock(dic[@"title"]);
        [self disappear];
    }
}




#pragma mark - getter / setter

- (UIView *)contentView{
    
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 500, ScreenWidth, 500)];
        [_contentView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        _contentView.layer.cornerRadius = SLChange(12.5);
    }
    return _contentView;
}

- (UIView *)titleView{
    if (_titleView == nil) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - 68)/2, 15, 68, 24)];
        [titleLabel setFont:kMediumFont(17)];
        [titleLabel setText:@""];
        [titleLabel setTextColor:KTextGray_333];
        self.titleLabel = titleLabel;
        [_titleView addSubview:titleLabel];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(ScreenWidth - 48, 0, 48, 52)];
        [closeButton setImage:[UIImage imageNamed:@"forget_close"] forState:UIControlStateNormal];
        
        [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_titleView addSubview:closeButton];
        
    }
    return _titleView;

}

- (UITableView *)tableView{
    if (_tableView == nil) {
        
        CGFloat y = CGRectGetMaxY(self.titleView.frame);
        
        CGFloat height = CGRectGetHeight(self.contentView.bounds) - ( CGRectGetHeight(self.titleView.frame));
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, height) style:UITableViewStyleGrouped];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderInvoiceSelectedTableCell class])bundle:nil] forCellReuseIdentifier:@"OrderInvoiceSelectedTableCell"];
    }
    return _tableView;
}


- (void)setCellArr:(NSArray *)cellArr{
    _cellArr = [cellArr mutableArrayDeeoCopy];
    [self.tableView reloadData];
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self.titleLabel setText:titleStr];
}

@end
