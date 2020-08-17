//
//  CustomerServicViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "CustomerServicViewController.h"
#import "UIView+AutoLayout.h"
#import "CustomerServiceInputView.h"
#import "CustomerServiceTabelHeardView.h"
#import "CustomerServieListModel.h"
#import "CustomerServieItemMessageModel.h"

#import "CustomerServiceMessageTableCell.h"

#import "EMChatViewController.h"

#import "NSString+Tool.h"

#import "GoodsStoreInfoModel.h"

@interface CustomerServicViewController ()<CustomerServiceTabelHeardViewDelegate, UITableViewDelegate, UITableViewDataSource, CustomerServiceMessageTableCellDelegate>

@property(nonatomic, strong)UITableView *tabelView;

@property(nonatomic, strong)CustomerServiceInputView *inputView;

@property(nonatomic, strong)CustomerServiceTabelHeardView *tableHeardView;

@property(nonatomic, strong)NSMutableArray *dataArray;

@property(nonatomic, strong)NSArray *currentProblemArray;

@end

@implementation CustomerServicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
}

#pragma mark - methods
-(void)initUI{
    [self.titleLabe setText:SLLocalizedString(@"在线客服")];
    [self.view setBackgroundColor:BackgroundColor_White];
    [self.view addSubview:self.tabelView];
    [self.view addSubview:self.inputView];
    
    WEAKSELF
    
    [self.inputView setInputWordBlock:^(NSString * _Nonnull word) {
        
        [[DataManager shareInstance]getAhqList:@{@"question":word} Callback:^(NSArray *result) {
            
            if ([result count] == 1) {
                CustomerServieListModel *listModel = [result firstObject];
                [weakSelf sendMessage:listModel.answer messageType:MessageTypeOther
                                    isTimeHidden:YES extensionData:nil isHasMessage:YES];
            }else if([result count] == 0){
                [weakSelf sendMessage:SLLocalizedString(@"没有找到您的问题，若以下没有您想问的，可以直接在输入框进行提问或者可以转接人工客服为您服务：")
                        messageType:MessageTypeOther
                isTimeHidden:YES extensionData:weakSelf.currentProblemArray isHasMessage:NO];
            }else{
                [weakSelf sendMessage:SLLocalizedString(@"您是否遇到以下问题了呢？可点击以下进行查看，若以下没有您想问的，可以直接在输入框进行提问哦：")
                          messageType:MessageTypeOther
                isTimeHidden:YES extensionData:result isHasMessage:YES];
            }
            
        }];
        
        [weakSelf sendMessage:word messageType:MessageTypeMe isTimeHidden:YES extensionData:nil isHasMessage:YES];
    }];
}

-(void)initData{
    //加载数据  headView上加载数据
    [[DataManager shareInstance]getAhqList:@{} Callback:^(NSArray *result) {
        
        self.currentProblemArray = result;
        
        [self.tableHeardView setDataArray:result];
        
        [self sendMessage:[NSString stringWithFormat:SLLocalizedString(@"%@！购物遇到问题，输入问题向我提问吧～"), [NSString currentTimeSayHello]] messageType:MessageTypeOther isTimeHidden:NO extensionData:nil isHasMessage:YES];
    }];
}

-(void)sendMessage:(NSString *)word messageType:(MessageType)type isTimeHidden:(BOOL)isHidden extensionData:(NSArray *)list isHasMessage:(BOOL)isHas{
    
    CustomerServieItemMessageModel *messageModel = [[CustomerServieItemMessageModel alloc]init];
    messageModel.text = word;
    messageModel.type = type;
    messageModel.timeHidden = isHidden;
    
    if (isHidden == NO) {
        messageModel.time = [NSString currentTime];
    }
    
    if (list != nil) {
        messageModel.extensionDic = @{@"dataArray":list};
    }
    messageModel.isHasMessage = isHas;
    
    [self.dataArray addObject:messageModel];
    
    [self.tabelView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.dataArray.count > 0) {
               NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tabelView numberOfRowsInSection:0] -1) inSection:0];
               [self.tabelView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
    });
}

#pragma mark - CustomerServiceTabelHeardViewDelegate
-(void)customerServiceTabelHeardView:(CustomerServiceTabelHeardView *)heardView tapCell:(CustomerServieListModel *)model{
    [self sendMessage:model.answer messageType:MessageTypeOther isTimeHidden:YES extensionData:nil isHasMessage:YES];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

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
    view.backgroundColor = [UIColor colorForHex:@"FAFAFA"];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat tableViewH = 100;
    
    CustomerServieItemMessageModel *message = self.dataArray[indexPath.row];
    
    if (message.cellHeigth == 0) { // 高度为0时，手动调用方法，计算高度。
           [self tableView:tableView cellForRowAtIndexPath:indexPath];
       }
    
       return message.cellHeigth;
    
//    return tableViewH;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CustomerServiceMessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerServiceMessageTableCell"];
    
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell setDelegate:self];
    
    return cell;
}


#pragma mark - CustomerServiceMessageTableCellDelegate

-(void)customerServiceMessageTableCell:(CustomerServiceMessageTableCell *)cell tapCell:(CustomerServieListModel *)model{
    [self sendMessage:model.answer messageType:MessageTypeOther isTimeHidden:YES extensionData:nil isHasMessage:YES];
}

-(void)customerServiceMessageTableCell:(CustomerServiceMessageTableCell *)cell tapContactArtificial:(BOOL)isTap{
    
    NSString *im =  self.storeModel.im;
    if (im.length == 0) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"获取店铺信息失败")];
        return;
    }
    NSString *im_id = [SLAppInfoModel sharedInstance].iM_id;
    if(im_id.length == 0){
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"获取聊天服务信息失败")];
        return;
    }

    
    EMChatViewController *chatVC = [[EMChatViewController alloc] initWithConversationId:im type:EMConversationTypeChat createIfNotExist:YES];
       [self.navigationController pushViewController:chatVC animated:YES];
}


#pragma mark - setter / getter
-(UITableView *)tabelView{
    
    if (_tabelView == nil) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 45 - NavBar_Height - kBottomSafeHeight) style:UITableViewStylePlain];
        
        _tabelView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        [_tabelView setTableHeaderView:self.tableHeardView];
        
        [_tabelView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomerServiceMessageTableCell class])bundle:nil] forCellReuseIdentifier:@"CustomerServiceMessageTableCell"];
        
        [_tabelView setDelegate:self];
        [_tabelView setDataSource:self];
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        _tabelView.estimatedRowHeight = 0;
//        _tabelView.estimatedSectionFooterHeight = 0;
//        _tabelView.estimatedSectionHeaderHeight = 0;
    }
    return _tabelView;

}

-(CustomerServiceInputView *)inputView{
    
    if (_inputView == nil) {
        _inputView = [[CustomerServiceInputView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 45 - NavBar_Height - kBottomSafeHeight, ScreenWidth, 45 )];
    }
    return _inputView;

}


-(CustomerServiceTabelHeardView *)tableHeardView{
    
    if (_tableHeardView == nil) {
        _tableHeardView = [[CustomerServiceTabelHeardView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 358)];
        [_tableHeardView setDelegate:self];
    }
    return _tableHeardView;

}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;

}
@end
