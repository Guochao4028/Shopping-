//
//  GoodsDetailsSpecificationTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsDetailsSpecificationTableCell.h"
#import "SpecificationParameterTableViewCell.h"
#import "GoodsInfoModel.h"

@interface GoodsDetailsSpecificationTableCell ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong)NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *directionImageView;

@property (weak, nonatomic) IBOutlet UIView *instructionsView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *instructionsViewH;

@end

@implementation GoodsDetailsSpecificationTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SpecificationParameterTableViewCell class])bundle:nil] forCellReuseIdentifier:@"SpecificationParameterTableViewCell"];
    
    [self.instructionsView.layer setCornerRadius:12];
    [self.instructionsView.layer setBorderWidth:1];
    [self.instructionsView.layer setBorderColor:KTextGray_96.CGColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.instructionsView addGestureRecognizer:tap];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - action
-(void)tapAction{
    
    if([self.delegate respondsToSelector:@selector(goodsDetailsSpecificationTableCell:tapAction:loction:)]){
        [self.delegate goodsDetailsSpecificationTableCell:self tapAction:self.model loction:self.indexPath];
    }
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.dataArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 30;
    return tableViewH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    SpecificationParameterTableViewCell *parameterCell = [tableView dequeueReusableCellWithIdentifier:@"SpecificationParameterTableViewCell"];

    [parameterCell setModel:self.dataArray[indexPath.row]];
   

    cell = parameterCell;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - setter / getter

-(void)setModel:(GoodsInfoModel *)model{
    _model = model;
    self.dataArray = model.goods_value;
    [self.tableView reloadData];
    
    NSInteger goods_valueCount = [model.goods_value count];
    if (goods_valueCount <=  8) {
        
        [self.instructionsLabel setHidden:YES];
        [self.directionImageView setHidden:YES];
        [self.instructionsView setHidden:YES];
        
        self.instructionsViewH.constant = 0;
    }else{
        self.instructionsViewH.constant = 54;
        [self.instructionsView setHidden:NO];
        [self.instructionsLabel setHidden:NO];
        [self.directionImageView setHidden:NO];
         if (model.isGoodsSpecificationSpread) {
               [self.instructionsLabel setText:SLLocalizedString(@"收起")];
               
               [self.directionImageView setImage:[UIImage imageNamed:@"upT"]];
           }else{
               [self.instructionsLabel setText:SLLocalizedString(@"展开")];
               
               [self.directionImageView setImage:[UIImage imageNamed:@"downT"]];
           }
    }
    
   
    
}

@end
