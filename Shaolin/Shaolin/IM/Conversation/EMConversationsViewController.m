//
//  EMConversationsViewController.m
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 2019/1/8.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EMConversationsViewController.h"
#import "EMConversationHelper.h"
#import "EMConversationCell.h"

@interface EMConversationsViewController()<EMChatManagerDelegate, EMGroupManagerDelegate, EMConversationsDelegate>

@property (nonatomic) BOOL isViewAppear;
@property (nonatomic) BOOL isNeedReload;
@property (nonatomic) BOOL isNeedReloadSorted;

@end

@implementation EMConversationsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupSubviews];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMConversationHelper shared] addDelegate:self];
    [self _loadAllConversationsFromDBWithIsShowHud:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    self.navigationController.navigationBar.barTintColor = RGBA(132, 50, 42, 1);
//    self.navigationController.navigationBar.hidden = NO;

    [self wr_setNavBarBarTintColor:[UIColor hexColor:@"8E2B25"]];
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarBackgroundAlpha:1];
    
    self.isViewAppear = YES;
    if (self.isNeedReloadSorted) {
        self.isNeedReloadSorted = NO;
        [self _loadAllConversationsFromDBWithIsShowHud:NO];
        
    } else if (self.isNeedReload) {
        self.isNeedReload = NO;
        [self.tableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

    self.isViewAppear = NO;
    self.isNeedReload = NO;
    self.isNeedReloadSorted = NO;
}

- (void)dealloc
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMConversationHelper shared] removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Subviews
- (void)_setupSubviews
{
    self.titleLabe.text = SLLocalizedString(@"消息");
    self.titleLabe.textColor = [UIColor whiteColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:(UIControlStateNormal)];
    
    self.showRefreshHeader = YES;
    self.tableView.rowHeight = 60;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"EMConversationCell";
    EMConversationCell *cell = (EMConversationCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[EMConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSInteger row = indexPath.row;
    EMConversationModel *model = [self.dataArray objectAtIndex:row];
    
    cell.model = model;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    EMConversationModel *model = [self.dataArray objectAtIndex:row];
    [[NSNotificationCenter defaultCenter] postNotificationName:CHAT_PUSHVIEWCONTROLLER object:model];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //在iOS8.0上，必须加上这个方法才能出发左划操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger row = indexPath.row;
        EMConversationModel *model = [self.dataArray objectAtIndex:row];
        EMConversation *conversation = model.emModel;
        [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:YES completion:nil];
        [self.dataArray removeObjectAtIndex:row];
        [self.tableView reloadData];
    }
}

#pragma mark - EMChatManagerDelegate

- (void)messagesDidRecall:(NSArray *)aMessages {
    [self _loadAllConversationsFromDBWithIsShowHud:NO];
}

- (void)conversationListDidUpdate:(NSArray *)aConversationList
{
    if (!self.isViewAppear) {
        self.isNeedReloadSorted = YES;
    } else {
        [self _loadAllConversationsFromDBWithIsShowHud:NO];
    }
}

- (void)messagesDidReceive:(NSArray *)aMessages
{
    if (self.isViewAppear) {
        if (!self.isNeedReload) {
            self.isNeedReload = YES;
            [self performSelector:@selector(_reSortedConversationModelsAndReloadView) withObject:nil afterDelay:0.8];
        }
    } else {
        self.isNeedReload = YES;
    }
}

#pragma mark - EMGroupManagerDelegate

- (void)didLeaveGroup:(EMGroup *)aGroup
               reason:(EMGroupLeaveReason)aReason
{
    [[EMClient sharedClient].chatManager deleteConversation:aGroup.groupId isDeleteMessages:NO completion:nil];
}


#pragma mark - EMConversationsDelegate

- (void)didConversationUnreadCountToZero:(EMConversationModel *)aConversation
{
    NSInteger index = [self.dataArray indexOfObject:aConversation];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)didResortConversationsLatestMessage
{
    [self _reSortedConversationModelsAndReloadView];
}

#pragma mark - Data

- (void)_reSortedConversationModelsAndReloadView
{
    NSArray *sorted = [self.dataArray sortedArrayUsingComparator:^(EMConversationModel *obj1, EMConversationModel *obj2) {
        EMMessage *message1 = [obj1.emModel latestMessage];
        EMMessage *message2 = [obj2.emModel latestMessage];
        if(message1.timestamp > message2.timestamp) {
            return(NSComparisonResult)NSOrderedAscending;
        } else {
            return(NSComparisonResult)NSOrderedDescending;
        }}];

    NSMutableArray *conversationModels = [NSMutableArray array];
    for (EMConversationModel *model in sorted) {
        if (!model.emModel.latestMessage) {
            [EMClient.sharedClient.chatManager deleteConversation:model.emModel.conversationId
                                                 isDeleteMessages:NO
                                                       completion:nil];
            continue;
        }
        [conversationModels addObject:model];
    }
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:conversationModels];
    [self.tableView reloadData];
    
    self.isNeedReload = NO;
}

- (void)_loadAllConversationsFromDBWithIsShowHud:(BOOL)aIsShowHUD
{
    MBProgressHUD *hud;
    if (aIsShowHUD) {
        hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"加载会话列表...")];
    }
    
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
        NSArray *sorted = [conversations sortedArrayUsingComparator:^(EMConversation *obj1, EMConversation *obj2) {
            EMMessage *message1 = [obj1 latestMessage];
            EMMessage *message2 = [obj2 latestMessage];
            if(message1.timestamp > message2.timestamp) {
                return(NSComparisonResult)NSOrderedAscending;
            } else {
                return(NSComparisonResult)NSOrderedDescending;
            }}];
        
        [weakself.dataArray removeAllObjects];
        
        NSArray *models = [EMConversationHelper modelsFromEMConversations:sorted];
        [weakself.dataArray addObjectsFromArray:models];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (aIsShowHUD) {
                [hud hideAnimated:YES];
            }
            
            [weakself tableViewDidFinishTriggerHeader:YES reload:NO];
            [weakself.tableView reloadData];
            weakself.isNeedReload = NO;
        });
    });
}

- (void)tableViewDidTriggerHeaderRefresh
{
    [self _loadAllConversationsFromDBWithIsShowHud:NO];
}

@end
