//
//  MeViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeViewController.h"
#import "PersonalDataView.h"
#import "MeCollectionViewCell.h"
#import "PersonDataManagementVc.h"
#import "PostManagementVc.h"
#import "DraftBoxViewController.h"
#import "StoreInfoViewController.h"
#import "MeManager.h"
#import "StoreOneViewController.h"
#import "StoreTwoViewController.h"
#import "StoreThreeViewController.h"
#import "OrderHomePageViewController.h"
#import "MeCollectionVc.h"
#import "ShoppingCartViewController.h"
#import "ReadingHistoryVc.h"
#import "HelpCenterViewController.h"
#import "KungfuApplyCheckListViewController.h"
#import "KfCertificateCheckViewController.h"
#import "BalanceManagementVc.h"

#import "MyAchievementViewController.h"
#import "EMConversationsViewController.h"
#import "BalanceViewController.h"
#import "StoreListViewController.h"
#import "MyRiteViewController.h"

#import "WengenWebViewController.h"

#import "DefinedHost.h"
#import "DataManager.h"

#import "StatementViewController.h"
#import "StoreInformationModel.h"
#import "BusinessLicenseVc.h"
#import "LegalPersonViewController.h"
#import "OrganizationViewController.h"
#import "TaxInformationVc.h"

static int CollectionViewALineCellCount = 4;

@interface MeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIButton *messageBtn;
@property (nonatomic, strong) PersonalDataView *personView;

@property (nonatomic, strong) UIScrollView *bgScrollerView;

@property (nonatomic, strong) UIView *whiteView1;//板块1
@property (nonatomic, strong) UIView *whiteView2;//板块2
@property (nonatomic, strong) UILabel *moduleTitle1;
@property (nonatomic, strong) UILabel *moduleTitle2;
@property (nonatomic, strong) UICollectionView *collectionViewOne;
@property (nonatomic, strong) UICollectionView *collectionViewTwo;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionViewFlowLayout *layoutTwo;

@property (nonatomic, strong) NSString *stepStr;
@property (nonatomic, strong) NSDictionary *dataDic;//执照信息
@property (nonatomic, strong) NSString  *statusStr;
@property (nonatomic, strong) NSString *checkMessage;

@property (nonatomic, strong) NSArray *collectionViewOneDataArray;
@property (nonatomic, strong) NSArray *collectionViewOneImageArray;
@property (nonatomic, strong) NSArray *collectionViewTwoDataArray;
@property (nonatomic, strong) NSArray *collectionViewTwoImageArray;
@property (nonatomic, strong) StoreInformationModel *model;
@end

@implementation MeViewController

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setStatusBarWhiteTextColor];
    [self getUserDataSuccess:nil failure:nil showHUD:NO];
    [self getUserStoreOpenInformation];
//    [self getUserBalance];
    [self setupUnreadMessageCount];
    
    [[DataManager shareInstance] getOrderAndCartCount];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hideNavigationBar = YES;
    self.view.backgroundColor = [UIColor colorForHex:@"F7F7F7"];
    
    [self initUI];
    
    [self.navigationController setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserData) name:@"MeViewControllerDidReloadUserDataNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserStoreOpenInformation) name:@"MeViewControllerDidReloadUserStoreOpenInformationDataNotfication" object:nil];
}

- (void)initUI {
    
    [self.view addSubview:self.bgScrollerView];
    [self.bgScrollerView addSubview:self.bgView];
    
    self.bgView.userInteractionEnabled = YES;
    [self.bgView addSubview:self.messageBtn];
    [self.bgScrollerView addSubview:self.personView];
   
    [self.bgScrollerView addSubview:self.whiteView1];
    [self.bgScrollerView addSubview:self.whiteView2];
    
    [self.whiteView1 addSubview:self.moduleTitle1];
    [self.whiteView2 addSubview:self.moduleTitle2];
    [self.whiteView1 addSubview:self.collectionViewOne];
    [self.whiteView2 addSubview:self.collectionViewTwo];
    
    [self.bgScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-kBottomSafeHeight);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(202 + kStatusBarHeight);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatueBar_Height+20);
        make.right.mas_equalTo(-18);
        make.size.mas_equalTo(20);
    }];
    
    [self.whiteView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kWidth - 30);
        make.height.mas_equalTo(140);
        make.top.mas_equalTo(self.personView.mas_bottom).mas_offset(10);
    }];
    
    [self.moduleTitle1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(19);
        make.size.mas_equalTo(CGSizeMake(100, 17));
    }];
    
    [self.collectionViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.moduleTitle1.mas_bottom).offset(26);
    }];
    
    [self.whiteView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.whiteView1);
        make.height.mas_equalTo(300);
        make.top.mas_equalTo(self.whiteView1.mas_bottom).offset(10);
    }];
    
    [self.moduleTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(19);
        make.size.mas_equalTo(CGSizeMake(100, 17));
    }];
    
    [self.collectionViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(248);
        make.top.mas_equalTo(self.moduleTitle2.mas_bottom).offset(26);
    }];
    
    self.bgScrollerView.contentSize = CGSizeMake(0, 780 + kBottomSafeHeight);
    
//    [self.messageBtn setHidden:YES];
}

- (void)setupUnreadMessageCount {
    NSArray *conversations = [[[EMClient sharedClient] chatManager] getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    if (unreadCount > 0) {
        [self.messageBtn setImage:[UIImage imageNamed:@"me_message_icon_unread"] forState:(UIControlStateNormal)];
    } else {
        [self.messageBtn setImage:[UIImage imageNamed:@"xiaoxi"] forState:(UIControlStateNormal)];
    }
    
    
}

#pragma mark - request
- (void)getUserData {
    [self getUserDataSuccess:nil failure:nil showHUD:YES];
}

- (void)getUserDataSuccess:(void (^)(void))success failure:(void (^)(void))failure showHUD:(BOOL)showHUD{
    MBProgressHUD *hud;
    if (showHUD){
        hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    }
    WEAKSELF
    [[MeManager sharedInstance] getUserDataSuccess:^(id  _Nonnull responseObject) {
        if (success) success();
        NSDictionary *dic = responseObject;
        if (dic && [dic isKindOfClass:[NSDictionary class]]){
            NSMutableDictionary *userDic =  [[NSMutableDictionary alloc]initWithDictionary:dic];
            [userDic setObject:[SLAppInfoModel sharedInstance].accessToken forKey:kToken];
            
            NSDictionary *allDic = [[NSDictionary alloc]initWithDictionary:userDic];
            NSLog(@"%@",allDic);
            
            [[SLAppInfoModel sharedInstance] modelWithDictionary:allDic];
            [[SLAppInfoModel sharedInstance] saveCurrentUserData];
            
            weakSelf.personView.dicData = dic;
            for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
                if ([controller isKindOfClass:[PersonDataManagementVc class]]) {
                    [(PersonDataManagementVc *)controller setDicData:weakSelf.personView.dicData];
                    break;
                }
            }
        }
    } failure:^(NSString * _Nullable errorReason) {
        if (failure) failure();
    } finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        [hud hideAnimated: YES];
    }];
}

//查询余额
//- (void)getUserBalance {
//    [[MeManager sharedInstance] getUserBalanceSuccess:^(id  _Nonnull responseObject) {
//        NSDictionary *dict = responseObject;
//        if ([dict isKindOfClass:[NSDictionary class]] && [dict objectForKey:@"balance"]){
//            self->_personView.balanceNumber = [dict objectForKey:@"balance"];//[NSString stringWithFormat:@"%@",[dict objectForKey:@"balance"]];
//        } else {
//            self->_personView.balanceNumber = @(0);
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetUserBalance" object:nil];
//    } failure:^(NSString * _Nonnull errorReason) {
//        NSLog(@"getUserBalance-errorReason:%@",errorReason);
//    } finish:nil];
//}

#pragma mark - event
- (void)messageAction
{
    EMConversationsViewController *conversationsVC = [[EMConversationsViewController alloc] init];
    conversationsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationsVC animated:YES];
}



#pragma mark - 获取用户开店详情
- (void)getUserStoreOpenInformationSuccess:(void (^)(void))success failure:(void (^)(void))failure{
    [[MeManager sharedInstance] postUserStoreInformationSuccess:nil failure:nil finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        if ([ModelTool checkResponseObject:responseObject]) {
            self.dataDic = [responseObject objectForKey:@"data"];
            self.model = [StoreInformationModel mj_objectWithKeyValues:self.dataDic];
            self.stepStr = self.model.step;
            self.statusStr = self.model.status;
            self.checkMessage = self.model.checkMessage;
            if (success) success();
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[StoreOneViewController class]] ||
                    [controller isKindOfClass:[BusinessLicenseVc class]] ||
                    [controller isKindOfClass:[LegalPersonViewController class]] ||
                    [controller isKindOfClass:[OrganizationViewController class]] ||
                    [controller isKindOfClass:[TaxInformationVc class]] ||
                    [controller isKindOfClass:[StoreInfoViewController class]] ||
                    [controller isKindOfClass:[StoreTwoViewController class]] ||
                    [controller isKindOfClass:[StoreThreeViewController class]] ) {
                    if ([[controller class] instancesRespondToSelector:@selector(model)]) {
                        [controller setValue:self.model forKey:@"model"];
                    }
                    if ([[controller class] instancesRespondToSelector:@selector(stepStr)]) {
                        [controller setValue:self.stepStr forKey:@"stepStr"];
                    }
                    if ([[controller class] instancesRespondToSelector:@selector(dataDic)]){
                        [controller setValue:self.dataDic forKey:@"dataDic"];
                    }
                }
            }
            
            NSLog(@"MeViewController dataDic:%@", self.dataDic);
        } else {
            if (failure) failure();
        }
    }];
}
- (void)getUserStoreOpenInformation {
    [self getUserStoreOpenInformationSuccess:nil failure:nil];
}

- (void)gotoUserStoreOpenInformation{
    if ([self.stepStr integerValue]< 5) {
        StoreOneViewController *oneVc = [[StoreOneViewController alloc]init];
        oneVc.stepStr = self.stepStr;
        oneVc.dataDic = self.dataDic;
        oneVc.model = self.model;
        oneVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:oneVc animated:YES];
    }else if ([self.stepStr isEqualToString:@"5"]){
        StoreTwoViewController *twoVc = [[StoreTwoViewController alloc]init];
        twoVc.stepStr = self.stepStr;
        twoVc.dataDic = self.dataDic;
        twoVc.model = self.model;
        twoVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:twoVc animated:YES];
    }else if ([self.stepStr isEqualToString:@"6"]){
        StoreThreeViewController *threeVc = [[StoreThreeViewController alloc]init];
        threeVc.stepStr = self.stepStr;
        threeVc.dataDic = self.dataDic;
        threeVc.model = self.model;
        threeVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:threeVc animated:YES];
    }else if([self.stepStr isEqualToString:@"7"] && [self.statusStr isEqualToString:@"4"]){
        StoreThreeViewController *threeVc = [[StoreThreeViewController alloc]init];
        threeVc.stepStr = self.stepStr;
        threeVc.dataDic = self.dataDic;
        threeVc.statusStr = self.statusStr;
        threeVc.model = self.model;
        threeVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:threeVc animated:YES];
    }else if ([self.stepStr isEqualToString:@"7"] && [self.statusStr isEqualToString:@"3"]) { //店铺被拒绝
        StoreOneViewController *oneVc = [[StoreOneViewController alloc]init];
        oneVc.stepStr = self.stepStr;
        oneVc.statusStr = self.statusStr;
        oneVc.checkStr = self.checkMessage;
        oneVc.model = self.model;
        oneVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:oneVc animated:YES];
        
    }else if ([self.stepStr isEqualToString:@"7"] && [self.statusStr isEqualToString:@"1"]) {
        [ShaolinProgressHUD singleTextHud:NSLocalizedString(@"恭喜您,店铺审核通过!", nil) view:self.view afterDelay:TipSeconds];
    }else if ([self.stepStr isEqualToString:@"7"] && [self.statusStr isEqualToString:@"2"]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"店铺已禁用!") view:self.view afterDelay:TipSeconds];
    }
}

#pragma mark - delegate && datasource

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    view.layer.zPosition = 0.0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.collectionViewOne) {
        return self.collectionViewOneDataArray.count;
    }
    return self.collectionViewTwoDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeCollectionViewCell" forIndexPath:indexPath];
    if (collectionView == self.collectionViewOne) {
        cell.logoView.image = [UIImage imageNamed:self.collectionViewOneImageArray[indexPath.row]];
        cell.nameLabel.text = self.collectionViewOneDataArray[indexPath.row];
    } else {
        cell.logoView.image = [UIImage imageNamed:self.collectionViewTwoImageArray[indexPath.row]];
        cell.nameLabel.text = self.collectionViewTwoDataArray[indexPath.row];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = @"";
    if (collectionView == self.collectionViewOne) {
        title = self.collectionViewOneDataArray[indexPath.row];
    } else if (collectionView == self.collectionViewTwo){
        title = self.collectionViewTwoDataArray[indexPath.row];
    }
    
    NSString *vcClassName = [self getViewCollectionClassName:title];
    if (vcClassName.length){
        
        Class vcClass = NSClassFromString(vcClassName);
        UIViewController *vc;
        
        if ([vcClassName isEqualToString:@"WengenWebViewController"]) {
            vc = [[WengenWebViewController alloc]initWithUrl:URL_H5_Invitation title:SLLocalizedString(@"邀请好友")];
            [((RootViewController *)vc) setNavigationBarStyle:NavigationBarYellowTintColorStyle];
        }else if ([vcClassName isEqualToString:@"KungfuApplyCheckListViewController"]) {
            KungfuApplyCheckListViewController *checkListVC = [[KungfuApplyCheckListViewController alloc]init];
            [checkListVC setIsNavBarRed:YES];
            vc = checkListVC;
        } else {
            vc = [[vcClass alloc] init];
        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    if ([title isEqualToString:SLLocalizedString(@"店铺入驻")]) {
        [self gotoUserStoreOpenInformation];
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat width = CGRectGetWidth(collectionView.frame);
    CGSize cellSize = ((UICollectionViewFlowLayout *)collectionViewLayout).itemSize;
    CGFloat spacing = (width - cellSize.width*CollectionViewALineCellCount)/(CollectionViewALineCellCount - 1);
    return spacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.collectionViewTwo) {
        return SLChange(25);
    }
    return 0;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.collectionViewOne) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}


#pragma mark - getter
- (PersonalDataView *)personView
{
    WEAKSELF
    if (!_personView) {
        //        _personView = [[PersonalDataView alloc]initWithFrame:CGRectMake(0, StatueBar_Height+SLChange(56), kWidth, SLChange(109))];
        
        _personView = [[PersonalDataView alloc]initWithFrame:CGRectMake(0, StatueBar_Height + 68 , kWidth, 175)];
        
        _personView.itemDidClick = ^(NSInteger index) {
            NSLog(@"%ld",index);
            if (index == 0) {
                
                OrderHomePageViewController *orderVC = [[OrderHomePageViewController alloc]init];
                orderVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:orderVC animated:YES];
                
            }else if (index ==1){
                StatementViewController *vc = [[StatementViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:NO];
                
//                BalanceViewController * vc = [BalanceViewController new];
//                vc.hidesBottomBarWhenPushed = YES;
//
//                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                ShoppingCartViewController *shoppingCartVC = [[ShoppingCartViewController alloc]init];
                
                shoppingCartVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:shoppingCartVC animated:YES];
            }
        };
        _personView.personDataClick = ^(NSDictionary * _Nonnull dic) {
            PersonDataManagementVc *vC = [[PersonDataManagementVc alloc]init];
            vC.dicData = dic;
            vC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vC animated:YES];
        };
        _personView.backgroundColor = [UIColor clearColor];
    }
    return _personView;
}

- (UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
        //        _bgView.image = [UIImage imageNamed:@"me_bg"];
        [_bgView setBackgroundColor:kMainYellow];
    }
    return _bgView;
}

- (UIScrollView *)bgScrollerView {
    if (!_bgScrollerView) {
        _bgScrollerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _bgScrollerView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)){
            _bgScrollerView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            _bgScrollerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _bgScrollerView;
}

- (UIButton *)messageBtn
{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //        [_messageBtn setImage:[UIImage imageNamed:@"me_message_icon"] forState:(UIControlStateNormal)];
        [_messageBtn setImage:[UIImage imageNamed:@"xiaoxi"] forState:(UIControlStateNormal)];
        
        [_messageBtn addTarget:self action:@selector(messageAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _messageBtn;
}

- (UIView *)whiteView1
{
    if (!_whiteView1) {
        _whiteView1 = [[UIView alloc] init];
        _whiteView1.cornerRadius = 10;
        _whiteView1.backgroundColor = UIColor.whiteColor;
    }
    return _whiteView1;
}

- (UIView *)whiteView2
{
    if (!_whiteView2) {
        _whiteView2 = [[UIView alloc] init];
        _whiteView2.cornerRadius = 10;
        _whiteView2.backgroundColor = UIColor.whiteColor;
    }
    return _whiteView2;
}

- (UILabel *)moduleTitle1 {
    if (!_moduleTitle1) {
        _moduleTitle1 = [UILabel new];
        _moduleTitle1.font = kMediumFont(16);
        _moduleTitle1.textColor = [UIColor hexColor:@"4c4c4c"];
        _moduleTitle1.text = SLLocalizedString(@"我的少林");
    }
    return _moduleTitle1;
}

- (UILabel *)moduleTitle2 {
    if (!_moduleTitle2) {
        _moduleTitle2 = [UILabel new];
        _moduleTitle2.font = kMediumFont(16);
        _moduleTitle2.textColor = [UIColor hexColor:@"4c4c4c"];
        _moduleTitle2.text = SLLocalizedString(@"个人中心");
    }
    return _moduleTitle2;
}

- (UICollectionView *)collectionViewOne
{
    if (!_collectionViewOne) {
        
        _collectionViewOne = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionViewOne.dataSource = self;
        _collectionViewOne.delegate = self;
        _collectionViewOne.backgroundColor = [UIColor clearColor];
        _collectionViewOne.scrollEnabled = NO;
        [_collectionViewOne registerClass:[MeCollectionViewCell class] forCellWithReuseIdentifier:@"MeCollectionViewCell"];
    }
    return _collectionViewOne;
}

- (UICollectionView *)collectionViewTwo
{
    if (!_collectionViewTwo) {
        
        _collectionViewTwo = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layoutTwo];
        _collectionViewTwo.dataSource = self;
        _collectionViewTwo.delegate = self;
        _collectionViewTwo.backgroundColor = [UIColor clearColor];
        _collectionViewTwo.scrollEnabled = NO;
        [_collectionViewTwo registerClass:[MeCollectionViewCell class] forCellWithReuseIdentifier:@"MeCollectionViewCell"];
    }
    return _collectionViewTwo;
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.minimumLineSpacing = .001;
        _layout.minimumInteritemSpacing = .001;
        _layout.itemSize = CGSizeMake((kScreenWidth-30)/4, 50);
    }
    return _layout;
}

- (UICollectionViewFlowLayout *)layoutTwo
{
    if (!_layoutTwo) {
        _layoutTwo = [UICollectionViewFlowLayout new];
        _layoutTwo.minimumLineSpacing = .001;
        _layoutTwo.minimumInteritemSpacing = .001;
        _layoutTwo.itemSize = CGSizeMake((kScreenWidth-30)/4, 50);
    }
    return _layoutTwo;
}

- (NSString *)getViewCollectionClassName:(NSString *)title{
    if ([title isEqualToString:SLLocalizedString(@"我的证书")]){
        return @"KfCertificateCheckViewController";
    } else if ([title isEqualToString:SLLocalizedString(@"我的教程")]){
        return @"MeClassViewController";
    } else if ([title isEqualToString:SLLocalizedString(@"我的活动")]){
        return @"MeActivityXLPageViewController";
    } else if ([title isEqualToString:SLLocalizedString(@"我的成就")]){
        return @"MyAchievementViewController";
    } else if ([title isEqualToString:SLLocalizedString(@"补考凭证")]){
        return @"MeVoucherViewController";
    } else if ([title isEqualToString:SLLocalizedString(@"报名信息")]){
        return @"KungfuApplyCheckListViewController";
    } else if ([title isEqualToString:SLLocalizedString(@"发文管理")]){
        return @"PostManagementVc";
    } else if ([title isEqualToString:SLLocalizedString(@"我的草稿")]){
        return @"DraftBoxViewController";
    } else if ([title isEqualToString:SLLocalizedString(@"阅读历史")]){
        return @"ReadingHistoryVc";
    } else if ([title isEqualToString:SLLocalizedString(@"我的收藏")]){
        return @"MeCollectionVc";
    } else if ([title isEqualToString:SLLocalizedString(@"店铺关注")]){
        return @"StoreListViewController";
    } else if ([title isEqualToString:SLLocalizedString(@"帮助中心")]){
        return @"HelpCenterViewController";
    } else if ([title isEqualToString:SLLocalizedString(@"功德资糧")]){
        return @"MyRiteViewController";
    } else if ([title isEqualToString:SLLocalizedString(@"邀约")]){
        return @"WengenWebViewController";
    }
    return @"";
}

- (NSArray *)collectionViewOneDataArray {
    return @[
        SLLocalizedString(@"我的证书"),
        SLLocalizedString(@"我的教程"),
        SLLocalizedString(@"我的活动"),
        SLLocalizedString(@"我的成就"),
    ];
}

- (NSArray *)collectionViewOneImageArray {
    return @[@"new_me_certificate_icon",
             @"new_me_tutorial_icon",
             @"new_me_activity_icon",
             @"new_my_achieveIcon"];
}

- (NSArray *)collectionViewTwoDataArray {
    return @[
        SLLocalizedString(@"报名信息"),
        SLLocalizedString(@"发文管理"),
        SLLocalizedString(@"我的草稿"),
        SLLocalizedString(@"阅读历史"),
        SLLocalizedString(@"功德资糧"),
        SLLocalizedString(@"店铺关注"),
        SLLocalizedString(@"店铺入驻"),
        //        SLLocalizedString(@"补考凭证"),
        SLLocalizedString(@"我的收藏"),
        SLLocalizedString(@"邀约"),
        SLLocalizedString(@"帮助中心"),
    ];
}

- (NSArray *)collectionViewTwoImageArray {
    return @[
        @"new_me_submitted_name",
        @"new_me_postmanagement_icon",
        @"new_me_draft_icon",
        @"new_me_history_icon",
        @"new_me_rite_icon",
        @"new_me_guanzhu_store_icon",
        @"new_me_store_icon",
        //        @"me_voucher_icon",
        @"new_me_star_icon",
        @"new_me_invitation_icon",
        @"new_me_help_icon",
    ];
}

@end
