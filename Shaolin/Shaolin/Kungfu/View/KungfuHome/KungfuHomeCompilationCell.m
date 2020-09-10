//
//  KungfuHomeCompilationCell.m
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuHomeCompilationCell.h"
#import "KungfuHomeCompilationSubCell.h"
#import "UIView+Extension.h"

static NSString *const subCellId = @"CompilationSubCell";
static NSString *const moreCellId = @"tableCell";

@interface KungfuHomeCompilationCell() <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *redBgView;
@property (weak, nonatomic) IBOutlet UILabel *bigTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *whiteBgView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (nonatomic, strong) UITableView   * classTableView;

@end

@implementation KungfuHomeCompilationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.whiteBgView addSubview:self.classTableView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)updateCellUI {
//    
//    
//}

- (IBAction)moreBtnHandle:(UIButton *)sender {
    WEAKSELF
    if (self.moreHandle) {
        NSString * filterType;
        if (weakSelf.tag == 0) {
            filterType = @"is_new";
        } else if (weakSelf.tag == 1) {
            filterType = @"is_delicate";
        }
        self.moreHandle(filterType);
    }
}

#pragma mark - delegate && dataSources

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.classList.count > 3) {
        return 4;
    }
    return self.classList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < 3) {
        KungfuHomeCompilationSubCell * cell = [tableView dequeueReusableCellWithIdentifier:subCellId];
        cell.cellModel = self.classList[indexPath.row];
        
        if (indexPath.row == 3 || indexPath.row == self.classList.count - 1) {
            cell.bottomCellLine.hidden = YES;
        } else {
            cell.bottomCellLine.hidden = NO;
        }
        
        
        return cell;
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moreCellId];
    cell.textLabel.font = kRegular(15);
    cell.backgroundColor = UIColor.clearColor;
    cell.textLabel.textColor = [UIColor hexColor:@"333333"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = SLLocalizedString(@"查看更多");

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 2) {
        if (self.moreHandle) {
            NSString * filterType;
            if (self.tag == 0) {
                filterType = @"is_new";
            } else if (self.tag == 1) {
                filterType = @"is_delicate";
            }
            self.moreHandle(filterType);
        }
    } else {
        ClassListModel *cellModel = self.classList[indexPath.row];
        if (self.selectHandle) {
            self.selectHandle(cellModel.classId);
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 2) {
        return 45;
    }
    
    return 83;
}


-(UITableView *)classTableView {
    if (!_classTableView) {
        _classTableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _classTableView.delegate = self;
        _classTableView.dataSource = self;
        _classTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _classTableView.backgroundColor = UIColor.clearColor;
        
        [_classTableView registerNib:[UINib nibWithNibName:NSStringFromClass([KungfuHomeCompilationSubCell class]) bundle:nil] forCellReuseIdentifier:subCellId];
        
        [_classTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:moreCellId];
        
    }
    return _classTableView;
}


-(void)setClassList:(NSArray *)classList {
    _classList = classList;
    
    if (self.tag == 0) {
        self.bigTitleLabel.text = SLLocalizedString(@"新手必学");
        self.contentLabel.text = SLLocalizedString(@"新人都在学这些教程");
    } else {
        self.bigTitleLabel.text = SLLocalizedString(@"进阶教程");
        self.contentLabel.text = SLLocalizedString(@"基础扎实后进阶学习的教程");
    }
    
    CGFloat moreHeight = 0;
    CGFloat classCount = classList.count;
    if (classCount > 3) {
        classCount = 3;
        moreHeight = 45;
//        self.moreBtn.hidden = NO;
    } else {
//        self.moreBtn.hidden = YES;
    }
    
    self.classTableView.frame = CGRectMake(0, 10, self.whiteBgView.width, classCount * 83 + moreHeight);

    
    [self.classTableView reloadData];
}

@end
