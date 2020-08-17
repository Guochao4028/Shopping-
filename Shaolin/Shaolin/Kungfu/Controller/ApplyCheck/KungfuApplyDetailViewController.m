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

@interface KungfuApplyDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ApplyListModel * detailModel;

@property (nonatomic, strong) NSArray * titleList;
@property (nonatomic, strong) NSMutableArray * contentList;

@property (nonatomic, strong) UIImageView * headImgv;
@property (nonatomic, strong) UIView * tableFooterView;

@end

@implementation KungfuApplyDetailViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initUI];
    [self requestApplyDetailInfo];
}


-(void) initUI
{
    self.titleLabe.text = SLLocalizedString(@"报名详情");
    self.view.backgroundColor = [UIColor hexColor:@"FAFAFA"];
    self.tableView.hidden = YES;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headImgv];
    
    [self.headImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.right.mas_equalTo(-41);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
}

- (void)activityDetail
{
    NSString * url = URL_H5_EventRegistration(self.detailModel.activityId,[SLAppInfoModel sharedInstance].access_token);
    KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:url type:KfWebView_activityDetail];
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void) requestApplyDetailInfo {
    MBProgressHUD * hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"加载中")];
    
    [[KungfuManager sharedInstance] getApplicationsDetailWithDic:@{@"accuratenumber":self.applyId} AndCallback:^(NSDictionary *result) {
        
        self.detailModel = [ApplyListModel mj_objectWithKeyValues:result];
        
        [hud hideAnimated:YES];
    }];
}

#pragma mark - scrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    self.headImgv.top = 16 - offsetY ;
//    NSLog(@"%@", [NSString stringWithFormat:@"%.2f",offsetY]);
}


#pragma mark - delegate && dataSources

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.contentList) {
        return 0;
    }
    return self.titleList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    KungfuApplyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"KungfuApplyDetailCell%ld",indexPath.row]];
    
    if (cell == nil) {
        cell = [KungfuApplyDetailCell xibRegistrationCell];
    }
    
    NSString * titleStr = self.titleList[indexPath.row];
    
    if (indexPath.row < self.contentList.count) {
        NSString * contentStr = self.contentList[indexPath.row];
        if (NotNilAndNull(contentStr)) {
            cell.applyContentLabel.text = [NSString stringWithFormat:@"%@%@",titleStr,contentStr];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.rowHeight;
}


#pragma mark - setter && getter
-(UITableView *)tableView
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

-(void)setDetailModel:(ApplyListModel *)detailModel {
    if (IsNilOrNull(detailModel)) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"报名详情获取失败") view:self.view afterDelay:TipSeconds];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    _detailModel = detailModel;
    
    [self.contentList addObject:[self getNotNilString:detailModel.realname]];
    [self.contentList addObject:[self getNotNilString:detailModel.beforeName]];
    [self.contentList addObject:[self getNotNilString:detailModel.gender]];
    [self.contentList addObject:[self getNotNilString:detailModel.nationality]];
    [self.contentList addObject:[self getNotNilString:detailModel.nation]];
    [self.contentList addObject:[self getNotNilString:detailModel.idCard]];
    [self.contentList addObject:[self getNotNilString:detailModel.bormtime]];
    [self.contentList addObject:[self getNotNilString:detailModel.passportNumber]];
    [self.contentList addObject:[self getNotNilString:detailModel.levelId]];
    [self.contentList addObject:[self getNotNilString:detailModel.levelName]];
    [self.contentList addObject:[self getNotNilString:detailModel.education]];
    [self.contentList addObject:[self getNotNilString:detailModel.title]];
    [self.contentList addObject:[self getNotNilString:detailModel.post]];
    [self.contentList addObject:[self getNotNilString:detailModel.mailbox]];
    [self.contentList addObject:[self getNotNilString:detailModel.wechat]];
    [self.contentList addObject:[self getNotNilString:detailModel.mailingAddress]];
    [self.contentList addObject:[self getTimeString:detailModel.writeExamStartTime endTime:detailModel.writeExamEndTime]];
    [self.contentList addObject:[self getTimeString:detailModel.skillExamStartTime endTime:detailModel.skillExamEndTime]];
    [self.contentList addObject:[self getNotNilString:detailModel.examaddress]];
    
    //身高、体重、鞋码、练武年限
    [self.contentList addObject:[self getNotNilString:detailModel.height]];
     [self.contentList addObject:[self getNotNilString:detailModel.weight]];
    [self.contentList addObject:[self getNotNilString:detailModel.shoeSize]];
    [self.contentList addObject:[self getNotNilString:detailModel.martialArtsYears]];
    
    
   NSInteger valueType = [detailModel.valueType integerValue];
    
    NSString *str;
    
    if (valueType == 1 || valueType == 0) {
        str = @"姓名";
    }else  if(valueType == 2){
        str = @"曾用名";
    }
[self.contentList addObject:[self getNotNilString:[NSString stringWithFormat:@" %@", str]]];
    
    NSString * headUrl = NotNilAndNull(detailModel.photosurl)?detailModel.photosurl:@"";
    [self.headImgv sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    self.tableView.hidden = NO;
    
    [self.tableView reloadData];
}

-(NSString *)getNotNilString:(NSString *)text {
    return NotNilAndNull(text)?text:@"";
}


-(NSString *)getTimeString:(NSString *)startTime endTime:(NSString *)endTime
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

-(NSArray *)titleList {
    if (!_titleList) {
        _titleList = @[
             @"姓      名："
            ,@"曾  用 名："
            ,@"性      别："
            ,@"国      籍："
            ,@"民      族："
            ,@"身份证号："
            ,@"出生年月："
            ,@"护  照 号："
            ,@"现段位编号："
        ,@"申报段位："
        ,@"学      历："
        ,@"职      称："
        ,@"职      务："
        ,@"邮      箱："
        ,@"微      信："
        ,@"通讯地址："
        ,@"理论考试时间："
        ,@"技能考试时间："
        ,@"考试地点："
        ,@"身      高："
        ,@"体      重："
        ,@"鞋      码："
        ,@"练武年限："
        ,@"证书显示名:"];

    }
    return _titleList;
}


-(NSMutableArray *)contentList {
    if (!_contentList) {
        _contentList = [NSMutableArray new];
    }
    return _contentList;
}

-(UIImageView *)headImgv {
    if (!_headImgv) {
        _headImgv = [[UIImageView alloc] init];
//        _headImgv.image = [UIImage imageNamed:@"default_small"];
        _headImgv.contentMode = UIViewContentModeScaleAspectFill;
        _headImgv.clipsToBounds = YES;
        _headImgv.layer.cornerRadius = 4;
    }
    return _headImgv;
}

-(UIView *)tableFooterView {
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(41,10,80,21);
        label.text = SLLocalizedString(@"活动详情：");
        label.textColor = [UIColor hexColor:@"333333"];
        label.font = kRegular(15);
        
        [_tableFooterView addSubview:label];
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(label.right, 6, 85, 28)];
        [button setTitle:SLLocalizedString(@"查看详情") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor hexColor:@"8E2B25"] forState:UIControlStateNormal];
        button.titleLabel.font = kRegular(15);
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = [UIColor hexColor:@"8E2B25"].CGColor;
        button.layer.cornerRadius = 14;
        [button addTarget:self action:@selector(activityDetail) forControlEvents:UIControlEventTouchUpInside];
        
        [_tableFooterView addSubview:button];
    }
    return _tableFooterView;
}

#pragma mark - device
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
