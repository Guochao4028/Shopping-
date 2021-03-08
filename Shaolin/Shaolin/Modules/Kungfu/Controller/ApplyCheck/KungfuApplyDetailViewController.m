//
//  KungfuApplyDetailViewController.m
//  Shaolin
//
//  Created by ws on 2020/6/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuApplyDetailViewController.h"
#import "KungfuWebViewController.h"
#import "KungfuApplyDetailCell.h"

#import "ApplyListModel.h"

#import "KungfuManager.h"
#import "DefinedHost.h"

#import "NSString+Tool.h"

@interface KungfuApplyDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ApplyListModel * detailModel;

@property (nonatomic, strong) NSArray * titleList;
//@property (nonatomic, strong) NSMutableArray * titleList;


@property (nonatomic, strong) NSMutableArray * contentList;

@property (nonatomic, strong) UIImageView * headImgv;
@property (nonatomic, strong) UIView * tableFooterView;

@end

@implementation KungfuApplyDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initUI];
    [self requestApplyDetailInfo];
}


- (void) initUI
{
    self.titleLabe.text = SLLocalizedString(@"报名详情");
    self.view.backgroundColor = KTextGray_FA;
    self.tableView.hidden = YES;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headImgv];
    
    [self.headImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.right.mas_equalTo(-41);
        make.size.mas_equalTo(CGSizeMake(90, 126));
    }];
}

- (void)activityDetail
{
    NSString * url = URL_H5_EventRegistration(self.detailModel.activityCode,[SLAppInfoModel sharedInstance].accessToken);
    KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:url type:KfWebView_activityDetail];
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void) requestApplyDetailInfo {
    
//    if (self.applyId) {
//        MBProgressHUD * hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"加载中")];
//
//        [[KungfuManager sharedInstance] getApplicationsDetailWithDic:@{@"accuratenumber":self.applyId} AndCallback:^(NSDictionary *result) {
//
//            self.detailModel = [ApplyListModel mj_objectWithKeyValues:result];
//
//            [hud hideAnimated:YES];
//        }];
//    }else{
//        self.detailModel = self.model;
        [self setDetailModel:self.model];
//    }
    
    
}

#pragma mark - scrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    self.headImgv.top = 16 - offsetY ;
//    NSLog(@"%@", [NSString stringWithFormat:@"%.2f",offsetY]);
}


#pragma mark - delegate && dataSources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.contentList) {
        return 0;
    }
    return self.titleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    KungfuApplyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"KungfuApplyDetailCell%ld",indexPath.row]];
    
    if (cell == nil) {
        cell = [KungfuApplyDetailCell xibRegistrationCell];
    }
    
    NSString * titleStr = self.titleList[indexPath.row];
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
        cell.contentRightCon.constant = 132;
    } else {
        cell.contentRightCon.constant = 5;
    }
    
    if (indexPath.row < self.contentList.count) {
        NSString * contentStr = self.contentList[indexPath.row];
        if (NotNilAndNull(contentStr)) {
            cell.applyContentLabel.text = [NSString stringWithFormat:@"%@",contentStr];
        }
        
        if([titleStr containsString:@"曾用名(法名)"]){
            
            NSRange range = [titleStr rangeOfString:@"("];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
            
            NSString *tem = [titleStr substringFromIndex:range.location];
            
           
            [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:RegularFont size:15] range:NSMakeRange(0, range.location-1)];
            
            [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:RegularFont size:12] range:NSMakeRange(range.location, tem.length)];
            
            cell.applyTitleLabel.attributedText = attrStr;
            
        }else{
            cell.applyTitleLabel.text = titleStr;
        }
    }
    
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.rowHeight;
}


#pragma mark - setter && getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, kWidth, kHeight - NavBar_Height - 15) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        
        _tableView.tableFooterView = self.tableFooterView;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}

- (void)setDetailModel:(ApplyListModel *)detailModel {
    if (IsNilOrNull(detailModel)) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"报名详情获取失败") view:self.view afterDelay:TipSeconds];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    _detailModel = detailModel;
    
    NSInteger activityTypeIdIngteger = detailModel.activityTypeId;
    
    if (activityTypeIdIngteger == 4) {
        // 考试
        [self examLoadingData:detailModel];
    }else{
        //活动
        [self activityLoadingData:detailModel];
    }
    
    
}

//加载考试数据
- (void)examLoadingData:(ApplyListModel *)detailModel {
    
    
    self.titleList = @[
        @"姓名："
        ,@"曾用名(法名)："
        ,@"证书显示名："
        ,@"国籍："
        ,@"性别："
        ,@"出生年月："
        ,@"身份证号："
        ,@"护照号："
        ,@"民族："
        ,@"学历："
        ,@"职称："
        ,@"职务："
        ,@"现位阶："
        ,@"申报段品阶："
        ,@"举办机构："
        ,@"微信："
        ,@"邮箱："
        ,@"电话："
        ,@"通讯地址："
        ,@"身高(cm)："
        ,@"体重(kg)："
        ,@"鞋码(码)："
        ,@"练武年限(年)："
        ,@"报名时间："
        ,@"培训时间："
        ,@"考试时间："
        ,@"考试地点："
        ,@"签到时间："
    ];
    
    //姓名
    [self.contentList addObject:[self getNotNilString:detailModel.realName]];
    //曾  用 名：
    [self.contentList addObject:[self getNotNilString:detailModel.beforeName]];
    //证书显示名:
    NSInteger valueType = [self.detailModel.valueType integerValue];
    NSString *str;
    if (valueType == 1 || valueType == 0) {
        str = detailModel.realName;//@"姓名";
    }else  if(valueType == 2){
        str = detailModel.beforeName;//@"曾用名";
    }
    [self.contentList addObject:[NSString stringWithFormat:@"%@", str]];
    //国      籍：
    [self.contentList addObject:[self getNotNilString:detailModel.nationality]];
    //性      别：
    [self.contentList addObject:[self getNotNilString:detailModel.gender]];
    //出生年月：
    [self.contentList addObject:[self getNotNilString:detailModel.bormTime]];
    //身份证号：
    [self.contentList addObject:[self getNotNilString:detailModel.idCard]];
    
    //护  照 号：
    [self.contentList addObject:[self getNotNilString:detailModel.passportNumber]];
    
    
//民      族：
    [self.contentList addObject:[self getNotNilString:detailModel.nation]];
    //学      历：
    [self.contentList addObject:[self getNotNilString:detailModel.education]];
    //职      称：
    [self.contentList addObject:[self getNotNilString:detailModel.title]];
    //职      务：
    [self.contentList addObject:[self getNotNilString:detailModel.post]];
    //现位阶：
    [self.contentList addObject:[self getNotNilString:detailModel.levelName]];
    //申报位阶：
    [self.contentList addObject:[self getNotNilString:detailModel.intervalName]];
    //举办机构：
    [self.contentList addObject:[self getNotNilString:detailModel.mechanismName]];
    //微      信：
    [self.contentList addObject:[self getNotNilString:detailModel.wechat]];
    //邮      箱：
    [self.contentList addObject:[self getNotNilString:detailModel.mailbox]];
    //电      话：
    [self.contentList addObject:[self getNotNilString:detailModel.telephone]];
    //通讯地址：
    [self.contentList addObject:[self getNotNilString:detailModel.mailingAddress]];
//    //护  照 号：
//    [self.contentList addObject:[self getNotNilString:detailModel.passportNumber]];
    //身高(cm)：
    [self.contentList addObject:[self getNotNilString:detailModel.height]];
    //体重(kg)：
    [self.contentList addObject:[self getNotNilString:detailModel.weight]];
    //鞋码(码)
    [self.contentList addObject:[self getNotNilString:detailModel.shoeSize]];
    //练武年限(年)：
    [self.contentList addObject:[self getNotNilString:detailModel.martialArtsYears]];
    //报名时间：
    [self.contentList addObject:[self getNotNilString:detailModel.applyDetailTime]];
    //培训时间：
    [self.contentList addObject:[self getNotNilString:detailModel.trainingTime]];
    //考试时间：
    [self.contentList addObject:[self getNotNilString:detailModel.skillExamTime]];
    //考试地点：
    [self.contentList addObject:[self getNotNilString:detailModel.examAddress]];
    //签到时间：
    [self.contentList addObject:[self getNotNilString:detailModel.signInTime]];
    
    [self baggingHeadDataAndReloadData:detailModel];
}


//加载活动数据
- (void)activityLoadingData:(ApplyListModel *)detailModel {
    
    
    self.titleList = @[
        @"姓名："
        ,@"曾用名(法名)："
        ,@"国籍："
        ,@"性别："
        ,@"出生年月："
        ,@"身份证号："
        
        ,@"护照号："
        
        ,@"民族："
        ,@"学历："
        ,@"职称："
        ,@"职务："
        ,@"现位阶："
        ,@"申报段品阶："
        ,@"举办机构："
        ,@"微信："
        ,@"邮箱："
        ,@"电话："
        ,@"通讯地址："
//        ,@"护照号："
        ,@"报名时间："
        ,@"活动时间："
        ,@"活动地点："
        ,@"签到时间："
    ];
    
    //姓名
    [self.contentList addObject:[self getNotNilString:detailModel.realName]];
    //曾  用 名：
    [self.contentList addObject:[self getNotNilString:detailModel.beforeName]];
    //国      籍：
    [self.contentList addObject:[self getNotNilString:detailModel.nationality]];
    //性      别：
    [self.contentList addObject:[self getNotNilString:detailModel.gender]];
    //出生年月：
    [self.contentList addObject:[self getNotNilString:detailModel.bormTime]];
    //身份证号：
    [self.contentList addObject:[self getNotNilString:detailModel.idCard]];
    
    //护  照 号：
    [self.contentList addObject:[self getNotNilString:detailModel.passportNumber]];
    
    
//民      族：
    [self.contentList addObject:[self getNotNilString:detailModel.nation]];
    //学      历：
    [self.contentList addObject:[self getNotNilString:detailModel.education]];
    //职      称：
    [self.contentList addObject:[self getNotNilString:detailModel.title]];
    //职      务：
    [self.contentList addObject:[self getNotNilString:detailModel.post]];
    //现位阶：
    [self.contentList addObject:[self getNotNilString:detailModel.levelName]];
    //申报位阶：
    [self.contentList addObject:[self getNotNilString:detailModel.intervalName]];
    //举办机构：
    [self.contentList addObject:[self getNotNilString:detailModel.mechanismName]];
    //微      信：
    [self.contentList addObject:[self getNotNilString:detailModel.wechat]];
    //邮      箱：
    [self.contentList addObject:[self getNotNilString:detailModel.mailbox]];
    //电      话：
    [self.contentList addObject:[self getNotNilString:detailModel.telephone]];
    //通讯地址：
    [self.contentList addObject:[self getNotNilString:detailModel.mailingAddress]];
//    //护  照 号：
//    [self.contentList addObject:[self getNotNilString:detailModel.passportNumber]];
    //报名时间:
    [self.contentList addObject:[self getNotNilString:detailModel.applyDetailTime]];
    //活动时间：
    [self.contentList addObject:[self getNotNilString:detailModel.activityTime]];
    //活动地点：
    [self.contentList addObject:[self getNotNilString:detailModel.examAddress]];
    //签到时间：
    [self.contentList addObject:[self getNotNilString:detailModel.signInTime]];
    
    
   
    [self baggingHeadDataAndReloadData:detailModel];
    
}

/// 拼接所有的数据
/// @param title title table title 的显示
/// @param dataStr table cell 显示
- (void)mergeDataWithTitle:(NSString *)title dataStr:(NSString *)dataStr{
    
//    if ([self determinesWhetherStringLengthIsValid:dataStr]) {
//        [self.titleList addObject:title];
//        [self.contentList addObject:dataStr];
//    }
}

//头像数据刷新列表
- (void)baggingHeadDataAndReloadData:(ApplyListModel *)detailModel{
    //头像
    NSString * headUrl = NotNilAndNull(detailModel.photosUrl)?detailModel.photosUrl:@"";
    [self.headImgv sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

//判断字符串长度是否有效
- (BOOL)determinesWhetherStringLengthIsValid:(NSString *)text{
    BOOL flag = NO;
    NSString *temStr = [self getNotNilString:text];
    if (temStr.length > 0) {
        flag = YES;
    }
    return flag;
}

- (NSString *)getNotNilString:(NSString *)text {
    return NotNilAndNull(text)?text:@"";
}

- (NSString *)getTimeString:(NSString *)startTime endTime:(NSString *)endTime
{
    
    NSString * result = @"";
    
    NSString * startTimeStr = [self getNotNilString:startTime];
    startTimeStr = [[startTimeStr componentsSeparatedByString:@" "] firstObject];
    startTimeStr = [startTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    result = startTimeStr;
    
    if (endTime.length > 0) {
        NSString * endTimeStr = [self getNotNilString:endTime];
        endTimeStr = [[endTimeStr componentsSeparatedByString:@" "] firstObject];
        endTimeStr = [endTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        
        result = [NSString stringWithFormat:@"%@-%@", startTimeStr, endTimeStr];
    }
    
    return result;
}

//- (NSMutableArray *)titleList {
//    if (!_titleList) {
//        _titleList = [NSMutableArray array];
//    }
//    return _titleList;
//}

- (NSArray *)titleList{
    
    if (_titleList == nil) {
    }
    return _titleList;

}




- (NSMutableArray *)contentList {
    if (!_contentList) {
        _contentList = [NSMutableArray new];
    }
    return _contentList;
}

- (UIImageView *)headImgv {
    if (!_headImgv) {
        _headImgv = [[UIImageView alloc] init];
//        _headImgv.image = [UIImage imageNamed:@"default_small"];
        _headImgv.contentMode = UIViewContentModeScaleAspectFill;
        _headImgv.clipsToBounds = YES;
        _headImgv.layer.cornerRadius = 4;
    }
    return _headImgv;
}

- (UIView *)tableFooterView {
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(31,10,80,21);
        label.text = SLLocalizedString(@"活动详情：");
        label.textColor = KTextGray_333;
        label.font = kRegular(15);
        
        [_tableFooterView addSubview:label];
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(130, 6, 85, 28)];
        [button setTitle:SLLocalizedString(@"查看详情") forState:UIControlStateNormal];
        [button setTitleColor:kMainYellow forState:UIControlStateNormal];
        button.titleLabel.font = kRegular(15);
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = kMainYellow.CGColor;
        button.layer.cornerRadius = 14;
        [button addTarget:self action:@selector(activityDetail) forControlEvents:UIControlEventTouchUpInside];
        
        [_tableFooterView addSubview:button];
    }
    return _tableFooterView;
}
@end
