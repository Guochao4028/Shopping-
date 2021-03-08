//
//  CustomerServiceMessageTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "CustomerServiceMessageTableCell.h"
#import "CustomerServieItemMessageModel.h"
#import "CustomerServiceHeardTableCell.h"
#import "CustomerServieListModel.h"

@interface CustomerServiceMessageTableCell ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myHeardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *otherHeardImageView;

@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *promptBanView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong)NSArray *dataArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promptBanH;
@property (weak, nonatomic) IBOutlet UIButton *artificialButton;

- (IBAction)artificialButtonAction:(UIButton *)sender;

@end

@implementation CustomerServiceMessageTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.promptBanView.layer setCornerRadius:7.5];
    [self.promptBanView setHidden:YES];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomerServiceHeardTableCell class])bundle:nil] forCellReuseIdentifier:@"CustomerServiceHeardTableCell"];
    
    [self.artificialButton setHidden:YES];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat rowH = 45.5;
    if(indexPath.row == 0){
        rowH = 104;
    }
    
    return rowH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerServiceHeardTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerServiceHeardTableCell"];
    
    [cell setModel:[self.dataArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomerServieListModel *listModel =  [self.dataArray objectAtIndex:indexPath.row];
    if (listModel.answer) {
        if ([self.delegate respondsToSelector:@selector(customerServiceMessageTableCell:tapCell:)]) {
            [self.delegate customerServiceMessageTableCell:self tapCell:listModel];
        }
    }
}


#pragma mark - setter / getter

- (void)setModel:(CustomerServieItemMessageModel *)model{
    _model = model;
    
    MessageType type = model.type;
    
    [self.artificialButton setHidden:YES];
    
    if (type == MessageTypeMe) {
        [self.otherHeardImageView setHidden:YES];
        [self.myHeardImageView setHidden:NO];
        [self.promptBanView setHidden:YES];
        [self.artificialButton setHidden:YES];
        
        SLAppInfoModel *infoModel = [SLAppInfoModel sharedInstance];
        [self.myHeardImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.headUrl]];
        
        
        [self settingShowLabel:self.messageLabel showIcon:self.myHeardImageView hiddenLabel:self.otherLabel hiddentIcon:self.otherHeardImageView];
        
    }else{
        [self.otherHeardImageView setHidden:NO];
        [self.myHeardImageView setHidden:YES];
        
        [self settingShowLabel:self.otherLabel showIcon:self.otherHeardImageView hiddenLabel:self.messageLabel hiddentIcon:self.myHeardImageView];
        
        
        if(model.isHasMessage == YES){
            if (model.extensionDic != nil) {
                [self.otherLabel setHidden:YES];
                [self.promptBanView setHidden:NO];
                
                NSMutableArray *tempArray = [NSMutableArray array];
                CustomerServieListModel *listModel = [[CustomerServieListModel alloc]init];
                listModel.question = model.text;
                [tempArray addObject:listModel];
                
                [tempArray addObjectsFromArray:model.extensionDic[@"dataArray"]];
                
                self.dataArray = tempArray;
                [self.tableView reloadData];
                
                model.cellHeigth = 21 +30 + 104 +(tempArray.count * 40.5);
                
                self.promptBanH.constant = 104 +(tempArray.count * 40.5);
                
                               
                [self.artificialButton setHidden:YES];
            }else{
                [self.otherLabel setHidden:NO];
               [self.promptBanView setHidden:YES];
                              
                [self.artificialButton setHidden:YES];
            }
            
        }else{
            [self.otherLabel setHidden:YES];
            [self.promptBanView setHidden:NO];
            [self.artificialButton setHidden:NO];
            
            NSMutableArray *tempArray = [NSMutableArray array];
           CustomerServieListModel *listModel = [[CustomerServieListModel alloc]init];
           listModel.question = model.text;
           [tempArray addObject:listModel];
           
           [tempArray addObjectsFromArray:model.extensionDic[@"dataArray"]];
           
           self.dataArray = tempArray;
           [self.tableView reloadData];
                           
            model.cellHeigth = 21 +30 + 104 +(tempArray.count * 40.5) + 10 +30;
            
            self.promptBanH.constant = 104 +(tempArray.count * 40.5);
            
        }
        
        
    }
    
    
    [self.timeLabel setHidden:model.timeHidden];
    [self.timeLabel setText:model.time];
    
}

#pragma mark - 计算 和 重新布局

- (void)settingShowLabel:(UILabel *)showLabel
                showIcon:(UIImageView *)showIcon
            hiddenLabel:(UILabel *) hiddenLabel
             hiddentIcon:(UIImageView *)hiddenIcon
{
    showLabel.hidden =NO;
    showIcon.hidden =NO;
    hiddenLabel.hidden = YES;
    hiddenIcon.hidden = YES;
    
    [showLabel setText:[NSString stringWithFormat:@"%@", self.model.text]];
    // 强制刷新一次
    [self layoutIfNeeded];
    CGFloat messageBtnY =CGRectGetMaxY(showLabel.frame);
    CGFloat meIconY = CGRectGetMaxY(showIcon.frame);
    self.model.cellHeigth = MAX(meIconY,messageBtnY) +10;
}

- (IBAction)artificialButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(customerServiceMessageTableCell:tapContactArtificial:)]) {
        [self.delegate customerServiceMessageTableCell:self tapContactArtificial:YES];
    }
    
}


@end
