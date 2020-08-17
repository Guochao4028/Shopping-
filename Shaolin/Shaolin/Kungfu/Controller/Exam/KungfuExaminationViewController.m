//
//  KungfuExaminationViewController.m
//  Shaolin
//
//  Created by syqaxldy on 2020/4/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuExaminationViewController.h"
#import "SDCycleScrollView.h"
#import "KungfuExaminationCell.h"
#import "KungfuExaminationInstitutionCell.h"
#import "KfExaminationChildVc.h"
#import "KungfuAllScoreViewController.h"
#import "KfCertificateCheckViewController.h"
#import "KungfuWebViewController.h"
#import "KungfuExaminationNoticeViewController.h"
#import "KfExamViewController.h"
#import "KungfuManager.h"
#import "SMAlert.h"
#import "ExamDetailModel.h"
#import "InstitutionModel.h"
#import "WengenBannerModel.h"
#import "DefinedHost.h"

@interface KungfuExaminationViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionViewTwo;
@property (nonatomic, strong) UICollectionViewFlowLayout *layoutTwo;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *sdcScrollView;
@property (nonatomic, copy) NSArray *imagesURLs;
@property (nonatomic, strong) UILabel *titleLabe;
@property (nonatomic, strong) NSArray *institutionListArray;

@property (nonatomic, strong) NSArray * bannerList;
@end

@implementation KungfuExaminationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self.view addSubview:self.tableView];
    [self requestData];
    [self requestBanner];
}

- (void) tapInstitution {
    
    [[SLAppInfoModel sharedInstance] postPageChangeNotification:KNotificationKungfuPageChange index:@"5"];
}

- (void)setUI {
    UIView *scrollBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(164))];
    scrollBgView.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
    scrollBgView.userInteractionEnabled = YES;
    [scrollBgView addSubview:self.sdcScrollView];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, SLChange(154), kWidth, SLChange(10))];
    v.backgroundColor = RGBA(250, 250, 250, 1);
    [scrollBgView addSubview:v];
    self.tableView.tableHeaderView = scrollBgView;
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, SLChange(10))];
    footerView.backgroundColor = RGBA(250, 250, 250, 1);
    self.tableView.tableFooterView = footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
              cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
          }
    if (indexPath.row == 0) {
       UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(12), kWidth-SLChange(30), SLChange(22))];
             label.textColor = [UIColor colorForHex:@"333333"];
             label.font = kMediumFont(16);
        label.text = SLLocalizedString(@"考试");
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:self.collectionView];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SLChange(338), kWidth, SLChange(10))];
           view.backgroundColor = RGBA(250, 250, 250, 1);
         [cell.contentView addSubview:view];
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, SLChange(43), kWidth, SLChange(5))];
        view2.backgroundColor = RGBA(253, 252, 253, 1);
        [cell.contentView addSubview:view2];
        
    }else {
          UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(12), kWidth-SLChange(30), SLChange(22))];
          label.textColor = [UIColor colorForHex:@"333333"];
          label.font = kMediumFont(16);
          label.text = SLLocalizedString(@"机构");
          [cell.contentView addSubview:label];
          [cell.contentView addSubview:self.collectionViewTwo];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SLChange(273), kWidth, SLChange(5))];
          view.backgroundColor = RGBA(250, 250, 250, 1);
        [cell.contentView addSubview:view];
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, SLChange(43), kWidth, SLChange(5))];
        view2.backgroundColor = RGBA(253, 252, 253, 1);
        [cell.contentView addSubview:view2];
        UIButton *button  = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-SLChange(25), SLChange(16), SLChange(8), SLChange(15))];
        [button setImage:[UIImage imageNamed:@"goodsRight"] forState:(UIControlStateNormal)];
        [cell.contentView addSubview:button];
//        UIButton * tapBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height)];
        
        UIButton * tapBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, cell.contentView.height)];
        [tapBtn addTarget:self action:@selector(tapInstitution) forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell.contentView addSubview:tapBtn];
    }
   
  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return SLChange(348);
    }else {
        return SLChange(278);
    }
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-48-Height_TabBar) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    }
    return _tableView;
}
- (SDCycleScrollView *)sdcScrollView {
    if (!_sdcScrollView) {
        _sdcScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(SLChange(16), SLChange(12), kWidth-SLChange(32), SLChange(130)) delegate:self placeholderImage:[UIImage imageNamed:@"default_banner"]];
        _sdcScrollView.delegate = self;
        _sdcScrollView.layer.cornerRadius =4;
        _sdcScrollView.layer.masksToBounds = YES;
        _sdcScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _sdcScrollView;
}

- (void)reloadCollectionViewTwo{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionViewTwo reloadData];
    });
}
#pragma mark - request
- (void)requestData{
    [self downloadInstitutionList];
}

- (void)requestBanner {
    [[DataManager shareInstance]getBanner:@{@"module":@"2", @"fieldId":@"1"} Callback:^(NSArray *result) {
            
        self.bannerList = [NSArray arrayWithArray:result];
        
        NSMutableArray *temList = [NSMutableArray array];
        for (WengenBannerModel *banner in self.bannerList) {
            [temList addObject:banner.imgUrl];
        }
        
        self.sdcScrollView.imageURLStringsGroup = temList;
        
    }];
}

- (void)downloadInstitutionList {
    NSDictionary *params = @{};
    WEAKSELF
    [[KungfuManager sharedInstance] getInstitutionListWithDic:params ListAndCallback:^(NSArray *result) {
        weakSelf.institutionListArray = result;
        [weakSelf reloadCollectionViewTwo];
    }];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    WengenBannerModel *banner = self.bannerList[index];
    // banner事件
    [[SLAppInfoModel sharedInstance] bannerEventResponseWithBannerModel:banner];
}

- (void) showAlertWithInfoString:(NSString *)text{
    [SMAlert setConfirmBtBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    title.numberOfLines = 2;
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = text;
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
    }] cancleButton:nil];
}

#pragma mark - Getter and Setter
- (NSArray *)institutionListArray{
    if (!_institutionListArray){
        _institutionListArray = @[];
    }
    return _institutionListArray;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
    if (collectionView == self.collectionView) {
        return 6;
    }else {
         return self.institutionListArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    if (collectionView == self.collectionView) {
         KungfuExaminationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KungfuExaminationCell" forIndexPath:indexPath];
            
          NSArray *arr=@[@"kungfu_test",@"kungfu_theorytest",@"kungfu_testnotice",@"kungfu_Registrationquery",@"kungfu_resultsquery",@"kungfu_certificate"];

                cell.imageIcon.image = [UIImage imageNamed:arr[indexPath.row]];
                 NSArray *arrTitle = @[SLLocalizedString(@"考试报名"),SLLocalizedString(@"理论考试"),SLLocalizedString(@"考试通知"),SLLocalizedString(@"报名查询"),SLLocalizedString(@"成绩查询"),SLLocalizedString(@"证书查询")];
                    cell.nameLabel.text = arrTitle[indexPath.row];
      
                 return cell;
    }else {
         KungfuExaminationInstitutionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KungfuExaminationInstitutionCell" forIndexPath:indexPath];
        cell.model = self.institutionListArray[indexPath.row];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {
        if (indexPath.row == 0) {
            [[SLAppInfoModel sharedInstance] postPageChangeNotification:KNotificationKungfuPageChange index:@"2" params:@{@"params":SLLocalizedString(@"考试")}];
        }else if (indexPath.row == 1) {
            
            [[KungfuManager sharedInstance] getStartExaminationAndCallback:^(NSDictionary *result) {
              
                if ([ModelTool checkResponseObject:result]){

                    ExamDetailModel * model = [ExamDetailModel mj_objectWithKeyValues:result[@"data"]];
                    KfExamViewController * vc  = [[KfExamViewController alloc]init];
                    vc.detailModel = model;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:NO];
                }else{
                    NSString * msg = result[@"msg"];
                    [self showAlertWithInfoString:NotNilAndNull(msg)?msg:@""];
                }
            }];
            
        }else if (indexPath.row == 2) {
            KungfuExaminationNoticeViewController *vc = [KungfuExaminationNoticeViewController new];
//            KungfuWebViewController * vc = [[KungfuWebViewController alloc] initWithUrl:URL_H5_ExamNotice([SLAppInfoModel sharedInstance].access_token) type:KfWebView_examNoti];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:NO];
        }else if (indexPath.row == 3) {
            [[SLAppInfoModel sharedInstance] postPageChangeNotification:KNotificationKungfuPageChange index:@"4"];
        }else if (indexPath.row == 4) {
            KungfuAllScoreViewController * vc = [KungfuAllScoreViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 5) {
            KfCertificateCheckViewController * vc = [KfCertificateCheckViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        InstitutionModel * model = self.institutionListArray[indexPath.section];

        KungfuWebViewController *vc = [[KungfuWebViewController alloc] initWithUrl:URL_H5_MechanismDetail(model.mechanismCode, [SLAppInfoModel sharedInstance].access_token) type:KfWebView_mechanismDetail];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.collectionView) {
           return SLChange(6.5);
       }else {
           return 0.01;
       }
    //Item之间的最小间隔
   
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.collectionView) {
         return SLChange(15);
    }else {
         return  SLChange(11);
    }
   
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(collectionView == self.collectionViewTwo){
        return UIEdgeInsetsMake(0, SLChange(16), 0, SLChange(16));
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SLChange(16), SLChange(48), kWidth-SLChange(32), SLChange(275)) collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = RGBA(252, 251, 252, 1);
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[KungfuExaminationCell class] forCellWithReuseIdentifier:@"KungfuExaminationCell"];
    }
    return _collectionView;
}
-(UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.itemSize = CGSizeMake(SLChange(110), SLChange(130));
//            _layout.sectionInset = UIEdgeInsetsMake(SLChange(32) ,0 , 0,0);
    }
    return _layout;
   
}
-(UICollectionView *)collectionViewTwo
{
    if (!_collectionViewTwo) {
        _collectionViewTwo = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SLChange(56), kWidth, SLChange(207)) collectionViewLayout:self.layoutTwo];
        _collectionViewTwo.dataSource = self;
        _collectionViewTwo.delegate = self;
        _collectionViewTwo.backgroundColor = RGBA(252, 251, 252, 1);
//                _collectionViewTwo.scrollEnabled = YES;
        _collectionViewTwo.scrollsToTop = NO;
        _collectionViewTwo.showsVerticalScrollIndicator = YES;
        _collectionViewTwo.showsHorizontalScrollIndicator = NO;
        [_collectionViewTwo registerClass:[KungfuExaminationInstitutionCell class] forCellWithReuseIdentifier:@"KungfuExaminationInstitutionCell"];
    }
    return _collectionViewTwo;
}
-(UICollectionViewFlowLayout *)layoutTwo
{
    if (!_layoutTwo) {
        _layoutTwo = [UICollectionViewFlowLayout new];
        [_layoutTwo setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _layoutTwo.minimumLineSpacing = 0;
        _layoutTwo.minimumInteritemSpacing = 0;
        _layoutTwo.itemSize = CGSizeMake(SLChange(140), SLChange(207));
    }
    return _layoutTwo;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
