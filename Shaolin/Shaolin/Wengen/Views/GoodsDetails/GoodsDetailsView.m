//
//  GoodsDetailsView.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsDetailsView.h"

#import "GoodsDetailsBannerTableCell.h"

#import "GoodsDetailsInfoTableViewCell.h"

#import "GoodsDetailsSelectedTableCell.h"

#import "GoodsDetailsStoreInfoTableCell.h"

#import "GoodsInfoModel.h"

#import <WebKit/WebKit.h>

#import "GoodsDetailsHeardView.h"
#import "EMChatViewController.h"

#import "NSString+Size.h"

#import "GoodsDetailsSpecificationTableCell.h"



static NSString *const kGoodsDetailsBannerTableCellIdentifier = @"GoodsDetailsBannerTableCell";

static NSString *const kGoodsDetailsInfoTableViewCellIdentifier = @"GoodsDetailsInfoTableViewCell";

static NSString *const kGoodsDetailsSelectedTableCellIdentifier = @"GoodsDetailsSelectedTableCell";

static NSString *const kGoodsDetailsStoreInfoTableCellIdentifier = @"GoodsDetailsStoreInfoTableCell";


static NSString *const kGoodsDetailsSpecificationTableCellIdentifier = @"GoodsDetailsSpecificationTableCell";




@interface GoodsDetailsView ()<UITableViewDelegate, UITableViewDataSource, GoodsDetailsSelectedTableCellDelegate, WKUIDelegate, WKNavigationDelegate, GoodsDetailsStoreInfoTableCellDelegate, GoodsDetailsSpecificationTableCellDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)WKWebView *webView;
//记录webview 的高度
@property(nonatomic, assign)CGFloat boxHeight;
//是否加载webview数据
@property(nonatomic, assign)BOOL isLoadingWebView;
//记录要刷新的item位置
@property(nonatomic, strong)NSIndexPath *indexPath;

@property(nonatomic, strong)GoodsDetailsHeardView *heardView;

@end

@implementation GoodsDetailsView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.isLoadingWebView = YES;
        [self initUI];
    }
    return self;
}

#pragma mark - methods

-(void)initUI{
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:self.tableView];
}

- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    return string;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray *goods_value = self.infoModel.goods_value;
    if (goods_value.count > 0) {
        return 5;
    }else{
        return 4;
    }
   
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 2) {
        return 34;
    }
    return 10;
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
    
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 34)];
        view.backgroundColor = [UIColor colorForHex:@"FAFAFA"];
        
        CGFloat contentViewX = (ScreenWidth - 108) / 2;
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(contentViewX, 6, 108, 22)];
        
        UILabel *horizontalLLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 9, 24, 0.5)];
        [horizontalLLine setBackgroundColor:[UIColor colorForHex:@"DDDDDD"]];
        [contentView addSubview:horizontalLLine];
        
        UILabel *verticalLLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(horizontalLLine.frame) + 5, 6, 0.5, 6)];
        [verticalLLine setBackgroundColor:[UIColor colorForHex:@"DDDDDD"]];
        [contentView addSubview:verticalLLine];
        
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(verticalLLine.frame) + 8.5, 1, 27, 18.5)];
        [titleLabel setText:SLLocalizedString(@"详情")];
        [titleLabel setTextColor:[UIColor colorForHex:@"333333"]];
        [titleLabel setFont:kRegular(13)];
        [contentView addSubview:titleLabel];
        
        
        UILabel *verticalRLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 8.5, 6, 0.5, 6)];
        [verticalRLine setBackgroundColor:[UIColor colorForHex:@"DDDDDD"]];
        [contentView addSubview:verticalRLine];
        
        
        UILabel *horizontalRLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(verticalRLine.frame)+5, 9, 24, 0.5)];
        [horizontalRLine setBackgroundColor:[UIColor colorForHex:@"DDDDDD"]];
        [contentView addSubview:horizontalRLine];
        
        [view addSubview:contentView];
        return view;
    }else{
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorForHex:@"FAFAFA"];
        return view;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 0;
    NSArray *goods_value = self.infoModel.goods_value;
    if ([goods_value count] > 0) {
        switch (indexPath.section) {
               case 0:{
                   
                   if (indexPath.row == 0) {
                       //banner
                       tableViewH = ScreenWidth;
                   }else{
                       //商品信息
                       CGSize nameSize = [self.infoModel.name sizeWithFont:kMediumFont(16) maxSize:CGSizeMake(ScreenWidth - 28, CGFLOAT_MAX)];
                       
                       tableViewH = nameSize.height +102;
                       
                       //                tableViewH = 123;
                   }
               }
                   break;
               case 1:{
                   //选择规格
                   tableViewH = 132;
               }
                   break;
               case 2:{
                   //店铺信息
                   tableViewH = 179;
               }
                   break;
               case 3:{
                   //商品详情图
                   if (self.infoModel.isGoodsSpecificationSpread == NO) {
                       
                      NSInteger goods_valueCount = [goods_value count];
                       if (goods_valueCount <=  8) {
                           CGFloat tempH = (30 * [goods_value count])+44;
                           
                           CGFloat finalH = (30 * 8)+44;
                           
                           tableViewH = MIN(tempH, finalH);
                       }else{
                           tableViewH =  (30 * 8) /2 +44+54 ;
                       }
                       
                   }else{
                       tableViewH = (30 * [goods_value count]) +44+54 ;
                   }
                   
               }
                   break;
               case 4:{
                   //商品详情图
                   tableViewH = 64 + self.boxHeight;
               }
                   break;
               default:
                   break;
           }
    }else{
        switch (indexPath.section) {
               case 0:{
                   
                   if (indexPath.row == 0) {
                       //banner
                       tableViewH = ScreenWidth;
                   }else{
                       //商品信息
                       CGSize nameSize = [self.infoModel.name sizeWithFont:kMediumFont(16) maxSize:CGSizeMake(ScreenWidth - 28, CGFLOAT_MAX)];
                       
                       tableViewH = nameSize.height +102;
                       
                       //                tableViewH = 123;
                   }
               }
                   break;
               case 1:{
                   //选择规格
                   tableViewH = 132;
               }
                   break;
               case 2:{
                   //店铺信息
                   tableViewH = 179;
               }
                   break;
             
               case 3:{
                   //商品详情图
                   tableViewH = 64 + self.boxHeight;
               }
                   break;
               default:
                   break;
           }
    }
    
    return tableViewH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    NSArray *goods_value = self.infoModel.goods_value;
    if ([goods_value count] > 0) {
        switch (indexPath.section) {
                case 0:{
                    
                    if (indexPath.row == 0) {
                        //banner
                        GoodsDetailsBannerTableCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:kGoodsDetailsBannerTableCellIdentifier];
                        
                        bannerCell.model = self.infoModel;
                        cell = bannerCell;
                    }
                    else{
                        //商品信息
                        GoodsDetailsInfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:kGoodsDetailsInfoTableViewCellIdentifier];
                        infoCell.infoModel = self.infoModel;
                        cell = infoCell;
                    }
                }
                    break;
                case 1:{
                    //选择规格
                    GoodsDetailsSelectedTableCell *selectedCell = [tableView dequeueReusableCellWithIdentifier:kGoodsDetailsSelectedTableCellIdentifier];
                    [selectedCell setModel:self.infoModel];
                    [selectedCell setDelegate:self];
                    [selectedCell setAddressModel:self.addressModel];
                    [selectedCell setFeeStr:self.feeStr];
                    [selectedCell setSpecificaationStr:self.specificaationStr];
                    cell = selectedCell;
                }
                    break;
                case 2:{
                    //店铺信息
                    GoodsDetailsStoreInfoTableCell *storeInfoCell = [tableView dequeueReusableCellWithIdentifier:kGoodsDetailsStoreInfoTableCellIdentifier];
                    storeInfoCell.model = self.storeInfoModel;
                    [storeInfoCell setDelegate:self];
                    storeInfoCell.btnService.tag = indexPath.row + 100;
                    [storeInfoCell.btnService addTarget:self action:@selector(btnServiceAction:) forControlEvents:UIControlEventTouchUpInside];
                    cell = storeInfoCell;
                }
                    break;
                case 3:{
                    //商品规格
                    GoodsDetailsSpecificationTableCell *specificationCell = [tableView dequeueReusableCellWithIdentifier:kGoodsDetailsSpecificationTableCellIdentifier];
                    [specificationCell setDelegate:self];
                    specificationCell.model = self.infoModel;
                    specificationCell.indexPath = indexPath;
                    cell = specificationCell;
                }
                    break;
                
                case 4:{
                    //商品详情
                    //            tableViewH = 1152;
                    
                    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                    
                    for (UIView *itemView in [cell.contentView subviews]) {
                        [itemView removeFromSuperview];
                    }
                    [cell.contentView addSubview:self.heardView];
                    [cell.contentView addSubview:self.webView];
                    
                    if (self.isLoadingWebView == YES && self.infoModel != nil) {
                        NSString *htmlStr = [self htmlEntityDecode:self.infoModel.intro];
                        
                        NSString *htmlTxt = [NSString stringWithFormat:@"<html> \n"
                                             "<head> \n"
                                             "<style type=\"text/css\">"
                                             "body {"
                                             "font-size:17pt;"
                                             "text-align: center;"
                                             "}"
                                             "p {"
                                             "text-align:left;"
                                             "}"
                                             "img {"
                                             "margin-left:10%%;"
                                             "transform: translate(-10%%)"
                                             "}"
                                             
                                             "</style>"
                                             "</head> \n"
                                             "<body>"
                                             "<meta content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;\" name=\"viewport\" />"
                                             "<script type='text/javascript'>"
                                             "window.onload = function(){\n"
                                             "var $img = document.getElementsByTagName('img');\n"
                                             "for(var p in  $img){\n"
                                             "$img[p].style.width = '95%%';\n"
                                             "$img[p].style.height ='auto'\n"
                                             "}\n"
                                             "}"
                                             "</script>%@"
                                             "<div id=\"testDiv\" style = \"height:100px; width:100px\"></div>"
                                             "</body>"
                                             "</html>", htmlStr];
                        
                        [self.webView loadHTMLString:htmlTxt baseURL:nil];
                        [self.webView setUIDelegate:self];
                        self.webView.navigationDelegate = self;
                        self.isLoadingWebView = NO;
                        self.indexPath = indexPath;
                    }
                }
                    break;
                default:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                    break;
            }
    }else{
        switch (indexPath.section) {
                case 0:{
                    
                    if (indexPath.row == 0) {
                        //banner
                        GoodsDetailsBannerTableCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:kGoodsDetailsBannerTableCellIdentifier];
                        
                        bannerCell.model = self.infoModel;
                        cell = bannerCell;
                    }
                    else{
                        //商品信息
                        GoodsDetailsInfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:kGoodsDetailsInfoTableViewCellIdentifier];
                        infoCell.infoModel = self.infoModel;
                        cell = infoCell;
                    }
                }
                    
                    break;
                case 1:{
                    //选择规格
                    GoodsDetailsSelectedTableCell *selectedCell = [tableView dequeueReusableCellWithIdentifier:kGoodsDetailsSelectedTableCellIdentifier];
                    [selectedCell setModel:self.infoModel];
                    [selectedCell setDelegate:self];
                    [selectedCell setAddressModel:self.addressModel];
                    [selectedCell setFeeStr:self.feeStr];
                    [selectedCell setSpecificaationStr:self.specificaationStr];
                    cell = selectedCell;
                }
                    break;
                case 2:{
                    //店铺信息
                    GoodsDetailsStoreInfoTableCell *storeInfoCell = [tableView dequeueReusableCellWithIdentifier:kGoodsDetailsStoreInfoTableCellIdentifier];
                    storeInfoCell.model = self.storeInfoModel;
                    [storeInfoCell setDelegate:self];
                    storeInfoCell.btnService.tag = indexPath.row + 100;
                    [storeInfoCell.btnService addTarget:self action:@selector(btnServiceAction:) forControlEvents:UIControlEventTouchUpInside];
                    cell = storeInfoCell;
                }
                    break;
                case 3:{
                    //商品详情
                    //            tableViewH = 1152;
                    
                    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                    
                    for (UIView *itemView in [cell.contentView subviews]) {
                        [itemView removeFromSuperview];
                    }
                    [cell.contentView addSubview:self.heardView];
                    [cell.contentView addSubview:self.webView];
                    
                    if (self.isLoadingWebView == YES && self.infoModel != nil) {
                        NSString *htmlStr = [self htmlEntityDecode:self.infoModel.intro];
                        
                        NSString *htmlTxt = [NSString stringWithFormat:@"<html> \n"
                                             "<head> \n"
                                             "<style type=\"text/css\">"
                                             "body {"
                                             "font-size:17pt;"
                                             "text-align: center;"
                                             "}"
                                             "p {"
                                             "text-align:left;"
                                             "}"
                                             "img {"
                                             "margin-left:10%%;"
                                             "transform: translate(-10%%)"
                                             "}"
                                             
                                             "</style>"
                                             "</head> \n"
                                             "<body>"
                                             "<meta content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;\" name=\"viewport\" />"
                                             "<script type='text/javascript'>"
                                             "window.onload = function(){\n"
                                             "var $img = document.getElementsByTagName('img');\n"
                                             "for(var p in  $img){\n"
                                             "$img[p].style.width = '95%%';\n"
                                             "$img[p].style.height ='auto'\n"
                                             "}\n"
                                             "}"
                                             "</script>%@"
                                             "<div id=\"testDiv\" style = \"height:100px; width:100px\"></div>"
                                             "</body>"
                                             "</html>", htmlStr];
                        
                        [self.webView loadHTMLString:htmlTxt baseURL:nil];
                        [self.webView setUIDelegate:self];
                        self.webView.navigationDelegate = self;
                        self.isLoadingWebView = NO;
                        self.indexPath = indexPath;
                    }
                }
                    break;
                default:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                    break;
            }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)btnServiceAction:(UIButton *)btn{
//    NSInteger tag = btn.tag - 100;
//    EMChatViewController *chatVC = [[EMChatViewController alloc] initWithConversationId:@"2" type:EMConversationTypeChat createIfNotExist:YES];
//    [[CommonAPI currentDisplayViewController].navigationController pushViewController:chatVC animated:YES];
    if (self.goodsStoreInfoCellOnlineCustomerServiceBlock) {
        self.goodsStoreInfoCellOnlineCustomerServiceBlock(YES);
    }
}

#pragma mark - GoodsDetailsSelectedTableCellDelegate
-(void)goodsSelectedCell:(GoodsDetailsSelectedTableCell *)cell tapSpecification:(BOOL)istap{
    if (self.goodsSpecificationBlock != nil) {
        self.goodsSpecificationBlock(istap);
    }
}

-(void)goodsSelectedCell:(GoodsDetailsSelectedTableCell *)cell tapAddress:(BOOL)istap{
    if (self.goodsAddressBlock != nil) {
        self.goodsAddressBlock(istap);
    }
}

#pragma mark -  GoodsDetailsStoreInfoTableCellDelegate

-(void)goodsStoreInfoCell:(GoodsDetailsStoreInfoTableCell *)cell tapStroeNameView:(BOOL)istap{
    if (self.goodsStoreInfoCellBlock != nil) {
        self.goodsStoreInfoCellBlock(istap);
    }
}



-(void)goodsStoreInfoCell:(GoodsDetailsStoreInfoTableCell *)cell tapOnlineView:(BOOL)istap{
    if (self.goodsStoreInfoCellOnlineCustomerServiceBlock != nil) {
        self.goodsStoreInfoCellOnlineCustomerServiceBlock(istap);
    }
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    if (webView == self.webView) {
        [webView evaluateJavaScript:@"document.getElementById(\"testDiv\").offsetTop"completionHandler:^(id _Nullable result,NSError * _Nullable error) {
               //获取页面高度，并重置webview的frame
               CGFloat lastHeight  = [result doubleValue] + 50;
               webView.frame = CGRectMake(0, 64, ScreenWidth, lastHeight);
               self.boxHeight = lastHeight;
               [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
           }];
    }
    
}

#pragma mark - GoodsDetailsSpecificationTableCellDelegate
-(void)goodsDetailsSpecificationTableCell:(GoodsDetailsSpecificationTableCell *)cell tapAction:(GoodsInfoModel *)model loction:(NSIndexPath *)indexPath{
    
    
    
    
    model.isGoodsSpecificationSpread = !model.isGoodsSpecificationSpread;
    self.infoModel.isGoodsSpecificationSpread = model.isGoodsSpecificationSpread;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - setter / getter

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        
        [_tableView registerClass:[GoodsDetailsBannerTableCell class] forCellReuseIdentifier:kGoodsDetailsBannerTableCellIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsDetailsInfoTableViewCell class])bundle:nil] forCellReuseIdentifier:kGoodsDetailsInfoTableViewCellIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsDetailsSelectedTableCell class])bundle:nil] forCellReuseIdentifier:kGoodsDetailsSelectedTableCellIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsDetailsStoreInfoTableCell class])bundle:nil] forCellReuseIdentifier:kGoodsDetailsStoreInfoTableCellIdentifier];
        
        
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsDetailsSpecificationTableCell class])bundle:nil] forCellReuseIdentifier:kGoodsDetailsSpecificationTableCellIdentifier];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
        
        if(@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

-(WKWebView *)webView{
    
    if (_webView == nil) {
        //        _webView = [[WKWebView alloc]initWithFrame:CGRectZero];
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        //初始化偏好设置属性：preferences
        config.preferences = [WKPreferences new];
        //The minimum font size in points default is 0;
        config.preferences.minimumFontSize = 10;
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 1135) configuration:config];
        [_webView setAllowsLinkPreview:NO];
        //        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [_webView setUserInteractionEnabled:NO];
        [_webView setUIDelegate:self];
        
        _webView.navigationDelegate = self;
        
    }
    return _webView;
    
}

-(GoodsDetailsHeardView *)heardView{
    if (_heardView == nil) {
        _heardView = [[GoodsDetailsHeardView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    }
    return _heardView;
}

-(void)setInfoModel:(GoodsInfoModel *)infoModel{
    _infoModel = infoModel;
    [self.tableView reloadData];
}

-(void)setStoreInfoModel:(GoodsStoreInfoModel *)storeInfoModel{
    _storeInfoModel = storeInfoModel;
    [self.tableView reloadData];
}

-(void)setAddressModel:(AddressListModel *)addressModel{
    _addressModel = addressModel;
    [self.tableView reloadData];
}

-(void)setFeeStr:(NSString *)feeStr{
    _feeStr = feeStr;
    [self.tableView reloadData];
}

-(void)setSpecificaationStr:(NSString *)specificaationStr{
    _specificaationStr = specificaationStr;
    [self.tableView reloadData];
}




@end
