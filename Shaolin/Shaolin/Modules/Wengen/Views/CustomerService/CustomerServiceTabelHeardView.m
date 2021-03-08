//
//  CustomerServiceTabelHeardView.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "CustomerServiceTabelHeardView.h"

#import "CustomerServiceHeardTableCell.h"


@interface CustomerServiceTabelHeardView ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//默认 256
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *problemListViewH;



@end

@implementation CustomerServiceTabelHeardView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle] loadNibNamed:@"CustomerServiceTabelHeardView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods
- (void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
     [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomerServiceHeardTableCell class])bundle:nil] forCellReuseIdentifier:@"CustomerServiceHeardTableCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.problemListViewH.constant = 0;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerServiceHeardTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerServiceHeardTableCell"];
    
    [cell setModel:[self.dataArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(customerServiceTabelHeardView:tapCell:)]) {
        [self.delegate customerServiceTabelHeardView:self tapCell:[self.dataArray objectAtIndex:indexPath.row]];
    }
}


#pragma mark - setter / getter
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    if ([dataArray count]) {
        self.problemListViewH.constant = 256;
    }
    [self.tableView reloadData];
}


@end
