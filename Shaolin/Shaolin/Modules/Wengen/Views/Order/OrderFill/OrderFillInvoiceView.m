//
//  OrderFillInvoiceView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillInvoiceView.h"

#import "OrderFillInvoiceTabelHeadView.h"

#import "OrderFillInvoiceTabelFooterView.h"

#import "OrderFillInvoiceRiseView.h"

#import "OrderFillInvoiceTableCell.h"

#import "OrderFillInvoiceFirstPageView.h"

#import "SMAlert.h"

#import "OrderFillIncreasedTicketQualificationTableCell.h"

#import "ReceiveTicketsTableCell.h"

#import "OrderFillInvoiceEmailTableViewCell.h"

#import "NSString+Tool.h"


static NSString *const kOrderFillInvoiceTableCellIdentifier = @"OrderFillInvoiceTableCell";

static NSString *const kOrderFillIncreasedTicketQualificationTableCellIdentifier = @"OrderFillIncreasedTicketQualificationTableCell";

static NSString *const kReceiveTicketsTableCellIdentifier = @"ReceiveTicketsTableCell";



@interface OrderFillInvoiceView ()<UITableViewDelegate, UITableViewDataSource, OrderFillInvoiceTabelHeadViewDelegate, OrderFillInvoiceFirstPageViewDelegate>

@property(nonatomic, strong)OrderFillInvoiceFirstPageView *firstPage;

@property(nonatomic, strong)UIView *contentView;

@property(nonatomic, strong)UIView *titleView;

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIButton *determineButton;

@property(nonatomic, strong)OrderFillInvoiceTabelHeadView *tableHeadView;

@property(nonatomic, strong)OrderFillInvoiceTabelFooterView *tabelFooterView;

//记录是否开发票
@property(nonatomic, assign)BOOL isInvoices;
//记录是否个人或者单位
@property(nonatomic, assign)BOOL isPersonal;
//记录发票类型  yes 专用发票。no 普通发票
@property(nonatomic, assign)BOOL isSpecial;
//记录是否要显示邮箱  yes 显示。no 不显示
//只有电子发票才显示邮箱，纸质发票不显示
@property(nonatomic, assign)BOOL isViewEmail;

@end

@implementation OrderFillInvoiceView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self. isPersonal = YES;
        self.isSpecial = NO;
        [self initUI];
    }
    return self;
}

#pragma mark - methods
-(void)initUI{
    [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    
    [self addSubview:self.firstPage];
    
    [self addSubview:self.contentView];
    
    [self.contentView setHidden:YES];
    
    //    self.contentView.mj_x = ScreenWidth;
    
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.determineButton];
    
    typeof(self)weakSelf = self;
    
    [self.tabelFooterView setSelectedBlock:^(BOOL isInvoices) {
        weakSelf.isInvoices = isInvoices;
        
        if (isInvoices == NO) {
            [weakSelf slideDirection:NO withCurrentView:weakSelf.contentView withLastView:weakSelf.firstPage completion:^(BOOL finished) {
                
                weakSelf.firstPage.isDaw = NO;
                
            }];
        }
        
        [weakSelf.tableView reloadData];
    }];
    
    [self.tableHeadView setQualificationsModel:self.qualificationsModel];
    
    [self.tableHeadView setConfigurationDic:self.configurationDic];
    
    self.isInvoices = self.tabelFooterView.isInvoice;
    
    [self.tableView reloadData];
    
    
}

-(void)disappear{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        //        [self removeFromSuperview];
        [self endEditing:YES];
        [self setHidden:YES];
    }];
    
}

#pragma mark 进场动画
/*  进场动画 */
- (void)slideDirection:(BOOL)isLeft withCurrentView:(UIView *)currentView withLastView:(UIView *)lastView completion:(void (^ __nullable)(BOOL finished))completion {
    CGFloat offset = self.frame.size.width;
    CGAffineTransform leftTransform = CGAffineTransformMakeTranslation(-offset, 0);
    CGAffineTransform rightTransform = CGAffineTransformMakeTranslation(offset, 0);
    CGAffineTransform currentTransform,lastTransform;
    if (isLeft) {
        currentTransform = leftTransform;
        lastTransform = rightTransform;
    } else {
        lastTransform = leftTransform;
        currentTransform = rightTransform;
    }
    
    lastView.transform = lastTransform;
    lastView.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        currentView.transform = currentTransform;
        lastView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

#pragma mark - action
-(void)closeAction{
    [self disappear];
}

-(void)invoiceInformation{
    NSString *invoiceStr = @"电子普通发票：\n\
    (1) 电子普通票是税局认可的有效收付款\n\
    凭证，其法律效力、基本用途及使用规定同 \n\
    纸质发票，如需纸质发票可自行下载打印；\n\
    (2) 用户可点击“我的订单-查看发票”查询和下载。\n\
    (3) 请按照税法规定使用发票。\
    \n\
    第三方卖家销售的商品/服务的发票由卖家\n\
    自行出具、提供，发票类型和内容由卖家根\n\
    据实际商品、服务情况决定。\n\
    ";
    
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 32, 300)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(customView.bounds), 44)];
    [titleLabel setFont:kMediumFont(17)];
    [titleLabel setText:SLLocalizedString(@"发票须知")];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:KTextGray_333];
    [customView addSubview:titleLabel];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 44, CGRectGetWidth(customView.bounds), CGRectGetHeight(customView.bounds)-44)];
    [textView setText:invoiceStr];
    [textView setFont:kRegular(15)];
    [textView setEditable:NO];
    [customView addSubview:textView];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:nil] cancleButton:nil];
    
}

-(void)determineAction{
    
    [self endEditing:YES];
    
    NSString *invoiceShape = self.tableHeadView.invoiceShape;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:invoiceShape forKey:@"is_paper"];
    
    if (self.isInvoices == YES) {
        
        if (self.isSpecial == NO) {
            
            OrderFillInvoiceTableCell *invoiceTableCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            NSString *personalStr = invoiceTableCell.personalStr;
            NSString *unitNameStr = invoiceTableCell.unitNameStr;
            NSString *unitNumberStr = invoiceTableCell.unitNumberStr;
            
            if (self.isPersonal) {
                if (personalStr.length > 0) {
                    if (personalStr) {
                        [param setValue:personalStr forKey:@"personal"];
                    }
                    [param setValue:@"1" forKey:@"type"];
                }else{
                    [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写个人名称") view:self afterDelay:TipSeconds];
                    return;
                }
            }else{
                
                if (unitNameStr.length > 0 && unitNumberStr.length > 0) {
                    if (unitNameStr) {
                        [param setValue:unitNameStr forKey:@"unitName"];
                    }
                    
                    if (unitNumberStr) {
                        [param setValue:unitNumberStr forKey:@"unitNumber"];
                    }
                    [param setValue:@"2" forKey:@"type"];
                }else{
                    NSString *str;
                    if (unitNameStr.length == 0) {
                        str = @"请填写单位名称";
                    }else if (unitNumberStr.length == 0){
                        str = @"请填写纳税人识别号";
                    }
                    
                    [ShaolinProgressHUD singleTextHud:str view:self afterDelay:TipSeconds];
                    return;
                }
                
            }
            
            [param setValue:@"UnSpecial" forKey:@"invoiceType"];
            
            
            if (self.isViewEmail) {
                
                
                OrderFillInvoiceEmailTableViewCell *invoiceEmailTableCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                
                NSString *emailStr = invoiceEmailTableCell.emailStr;
                if (emailStr.length) {
                    if ([emailStr validationEmail]) {
                        [param setValue:emailStr forKey:@"email"];
                    }else{
                        [ShaolinProgressHUD singleTextAutoHideHud:@"请填写正确的邮箱"];
                        return;
                    }
                    
                }
            }
            
            if ([self.delegate respondsToSelector:@selector(orderFillInvoiceView:tapDetermine:)] == YES) {
                [self.delegate orderFillInvoiceView:self tapDetermine:param];
            }
            [self disappear];
        }else{
            
            ReceiveTicketsTableCell *invoiceTableCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            
            NSString *nameStr = invoiceTableCell.name;
            NSString *phoneStr = invoiceTableCell.phone;
            NSString *addressStr = invoiceTableCell.address;
            
            
            if (nameStr.length > 0 && phoneStr.length > 0&& addressStr.length > 0) {
                [param setValue:nameStr forKey:@"nameStr"];
                [param setValue:phoneStr forKey:@"phoneStr"];
                [param setValue:addressStr forKey:@"addressStr"];
                
            }else{
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写发票信息") view:self afterDelay:TipSeconds];
                return;
            }
            
            [param setValue:@"Special" forKey:@"invoiceType"];
            
            
            if ([self.delegate respondsToSelector:@selector(orderFillInvoiceView:tapDetermine:)] == YES) {
                [self.delegate orderFillInvoiceView:self tapDetermine:param];
            }
            [self disappear];
            
            
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(orderFillInvoiceView:tapDetermine:)] == YES) {
            [self.delegate orderFillInvoiceView:self tapDetermine:param];
        }
        [self disappear];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isInvoices == YES) {
        if (self.isSpecial == NO) {
            if (self.isViewEmail) {
                if (section == 0) {
                    return 80;
                }else{
                    return 21;
                }
            }
            return 80;
        }else{
            return 40;
        }
    }
    return 0.01;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.isInvoices == YES) {
        
        //因为默认电子发票 所有 这里先设置为yes
        self.isViewEmail = YES;
        
        if (self.isSpecial == NO) {
            //普通发票
            
            if (self.isViewEmail) {
                //电子发票
                
                static NSString *invoiceTitleIdentifier = @"p_InvoiceTitleAndEmailHeader";
                
                UITableViewHeaderFooterView *view = [self p_InvoiceTitleAndEmailHeader:[tableView dequeueReusableHeaderFooterViewWithIdentifier:invoiceTitleIdentifier] inSection:section isPersonal:self.isPersonal];
                
                return view;
                
            }else{
                //纸质 发票抬头
                static NSString *invoiceTitleIdentifier = @"p_InvoiceTitleHeader";
                
                UITableViewHeaderFooterView *view = [self p_InvoiceTitleHeader:[tableView dequeueReusableHeaderFooterViewWithIdentifier:invoiceTitleIdentifier] inSection:section isPersonal:self.isPersonal];
                
                return view;
            }
            
            
        }else{
            //增值税发票
            static NSString *headerIdentifier = @"p_vatSpecialInvoiceHeader";
            
            UITableViewHeaderFooterView *view = [self p_vatSpecialInvoiceHeader:[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier] inSection:section];
            
            return view;
        }
    }
    
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isInvoices == YES) {
        if (self.isSpecial == NO) {
            if (self.isViewEmail) {
                return 2;
            }
            return 1;
        }else{
            return 2;
        }
    }
    return  0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isInvoices == YES) {
        return 1;
        
    }
    return  0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 0;
    
    if (self.isSpecial == NO) {
        
        if (self.isViewEmail) {
            if (indexPath.section == 0) {
                if (self.isPersonal == YES) {
                    rowHeight = 44;
                }else{
                    rowHeight =  75;
                }
            }else{
                rowHeight = 44;
            }
        }else{
            if (self.isPersonal == YES) {
                rowHeight = 44;
            }else{
                rowHeight =  75;
            }
        }
        
    }else{
        if (indexPath.section == 0) {
            rowHeight = 178;
        }else{
            rowHeight = 112;
        }
    }
    
    return rowHeight;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isSpecial == NO) {
        
        if (self.isViewEmail) {
            
            if (indexPath.section ==  0) {
                OrderFillInvoiceTableCell *invoiceTableCell = [tableView dequeueReusableCellWithIdentifier:kOrderFillInvoiceTableCellIdentifier];
                
                invoiceTableCell.isPersonal = self.isPersonal;
                invoiceTableCell.tabelView = tableView;
                
                return invoiceTableCell;
                
            }else{
                OrderFillInvoiceEmailTableViewCell *invoiceEmailCell = [tableView dequeueReusableCellWithIdentifier:@"OrderFillInvoiceEmailTableViewCell"];
                
                return invoiceEmailCell;
            }
            
        }else{
            OrderFillInvoiceTableCell *invoiceTableCell = [tableView dequeueReusableCellWithIdentifier:kOrderFillInvoiceTableCellIdentifier];
            
            invoiceTableCell.isPersonal = self.isPersonal;
            invoiceTableCell.tabelView = tableView;
            
            return invoiceTableCell;
        }
        
        
    }else{
        if (indexPath.section == 0) {
            OrderFillIncreasedTicketQualificationTableCell *invoiceInfoTableCell = [tableView dequeueReusableCellWithIdentifier:kOrderFillIncreasedTicketQualificationTableCellIdentifier];
            
            [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderFillIncreasedTicketQualificationTableCell class])bundle:nil] forCellReuseIdentifier:kOrderFillIncreasedTicketQualificationTableCellIdentifier];
            
            invoiceInfoTableCell.model = self.qualificationsModel;
            return invoiceInfoTableCell;
        }else{
            ReceiveTicketsTableCell *receiveTicketsCell = [tableView dequeueReusableCellWithIdentifier:kReceiveTicketsTableCellIdentifier];
            receiveTicketsCell.model = self.addressListModel;
            
            return receiveTicketsCell;
        }
    }
    
    
}

#pragma mark - OrderFillInvoiceTabelHeadViewDelegate
//发票类型选择
-(void)orderFillInvoiceTabelHeadView:(OrderFillInvoiceTabelHeadView *)view tapView:(BOOL)istap{
    self.isSpecial = istap;
    [self.tableView reloadData];
}
//发票形式选择
-(void)orderFillInvoiceTabelHeadView:(OrderFillInvoiceTabelHeadView *)view tapViewChangeProformaInvoice:(NSString *)invoiceShape{
    NSInteger invoiceShapeInteger = [invoiceShape integerValue];
    if (invoiceShapeInteger == 2) {
        self.isViewEmail = YES;
    }else{
        self.isViewEmail = NO;
    }
    [self.tableView reloadData];
}

#pragma mark - OrderFillInvoiceFirstPageViewDelegate
//点击关闭
-(void)orderFillInvoiceFirstPageView:(OrderFillInvoiceFirstPageView *)view clooseView:(BOOL)isCloose{
    [self disappear];
}


//点击确定
-(void)orderFillInvoiceFirstPageView:(OrderFillInvoiceFirstPageView *)view determine:(BOOL)isDetermine{
    if (self.isInvoices == NO) {
        if ([self.delegate respondsToSelector:@selector(orderFillInvoiceView:tapNotDevelopmentTicket:)]) {
            [self.delegate orderFillInvoiceView:self tapNotDevelopmentTicket:self.isInvoices];
        }
    }
    [self disappear];
}


//不开发票
-(void)orderFillInvoiceFirstPageView:(OrderFillInvoiceFirstPageView *)view noDraw:(BOOL)isDetermine{
    self.isInvoices = NO;
}

//开发票
-(void)orderFillInvoiceFirstPageView:(OrderFillInvoiceFirstPageView *)view draw:(BOOL)isDetermine{
    self.isInvoices = YES;
    self.tabelFooterView.isInvoice = self.isInvoices;
    [self.tableView reloadData];
    [self slideDirection:YES withCurrentView:view withLastView:self.contentView completion:^(BOOL finished) {
        
    }];
}


#pragma mark - 私有方法
#pragma mark - 增值税表头
-(UITableViewHeaderFooterView *)p_vatSpecialInvoiceHeader:(UITableViewHeaderFooterView *)view inSection:(NSInteger)section{
    
    UILabel *titleLabel;
    UILabel *subTitleLabel;
    if(view == nil){
        view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 77, 21)];
        [titleLabel setFont:kMediumFont(15)];
        [titleLabel setTextColor:KTextGray_333];
        
        subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+10, 0, 172, 17)];
        [subTitleLabel setFont:kRegular(12)];
        [subTitleLabel setTextColor:KTextGray_999];
        
        [view.contentView addSubview:titleLabel];
        [view.contentView addSubview:subTitleLabel];
    }
    
    if (section == 0) {
        [titleLabel setText:SLLocalizedString(@"增票资质")];
        titleLabel.mj_y = 10;
        [subTitleLabel setHidden:YES];
    }else{
        [titleLabel setText:SLLocalizedString(@"收票人信息")];
        [subTitleLabel setHidden:NO];
        [subTitleLabel setText:SLLocalizedString(@"（该信息可与收货人信息不同）")];
    }
    return view;
}

#pragma mark - 发票抬头
-(UITableViewHeaderFooterView *)p_InvoiceTitleHeader:(UITableViewHeaderFooterView *)view inSection:(NSInteger)section isPersonal:(BOOL)isPersonal{
    
    OrderFillInvoiceRiseView *headView;
    if(view == nil){
        view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
        headView = [[OrderFillInvoiceRiseView alloc]initWithFrame:view.bounds];
        [view.contentView addSubview:headView];
    }
    typeof(self)weakSelf = self;
    [headView setRiseViewSelectedBlock:^(BOOL isPersonal) {
        weakSelf.isPersonal = isPersonal;
        [weakSelf.tableView reloadData];
        
    }];
    headView.isPersonal = isPersonal;
    
    return  view;
}

#pragma mark - 电子发票 在 发票抬头的基础上就邮箱
-(UITableViewHeaderFooterView *)p_InvoiceTitleAndEmailHeader:(UITableViewHeaderFooterView *)view inSection:(NSInteger)section isPersonal:(BOOL)isPersonal{
    
    if (section == 0) {
        view = [self p_InvoiceTitleHeader:view inSection:section isPersonal:isPersonal];
    }else{
        UILabel *titleLabel;
        if(view == nil){
            view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 21)];
            titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 77, 21)];
            [titleLabel setFont:kMediumFont(15)];
            [titleLabel setTextColor:KTextGray_333];
            [view.contentView addSubview:titleLabel];
        }
        
        [titleLabel setText:SLLocalizedString(@"收票人信息")];
    }
    
    return  view;
}

#pragma mark - getter / setter

-(UIView *)contentView{
    
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 162, ScreenWidth, ScreenHeight - 162)];
        [_contentView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        _contentView.layer.cornerRadius = SLChange(12.5);
    }
    return _contentView;
}

-(OrderFillInvoiceFirstPageView *)firstPage{
    if (_firstPage== nil) {
        _firstPage = [[OrderFillInvoiceFirstPageView alloc]initWithFrame:CGRectMake(0, 162, ScreenWidth, ScreenHeight - 162)];
        [_firstPage setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        _firstPage.layer.cornerRadius = SLChange(12.5);
        [_firstPage setDelegate:self];
    }
    return _firstPage;
}

-(UIView *)titleView{
    
    if (_titleView == nil) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 56)];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, 35, 24)];
        [titleLabel setFont:kMediumFont(17)];
        [titleLabel setText:SLLocalizedString(@"发票")];
        [titleLabel setTextColor:KTextGray_333];
        [_titleView addSubview:titleLabel];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(ScreenWidth - 48, 0, 48, 52)];
        [closeButton setImage:[UIImage imageNamed:@"goodsClose"] forState:UIControlStateNormal];
        
        [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_titleView addSubview:closeButton];
        
        //        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [titleButton setFrame:CGRectMake(ScreenWidth - 48 - 58, 0, 58, 52)];
        //        [titleButton setTitle:SLLocalizedString(@"发票须知") forState:UIControlStateNormal];
        //        [titleButton setTitleColor:KTextGray_999 forState:UIControlStateNormal];
        //        [titleButton addTarget:self action:@selector(invoiceInformation) forControlEvents:UIControlEventTouchUpInside];
        //        [titleButton.titleLabel setFont:kRegular(14)];
        //        [_titleView addSubview:titleButton];
    }
    return _titleView;
    
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        
        CGFloat y = CGRectGetMaxY(self.titleView.frame);
        
        CGFloat height = CGRectGetHeight(self.contentView.bounds) - ( CGRectGetHeight(self.titleView.frame) + CGRectGetHeight(self.determineButton.frame)+20);
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, height) style:UITableViewStyleGrouped];
        [_tableView setTableHeaderView:self.tableHeadView];
        [_tableView setTableFooterView:self.tabelFooterView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderFillInvoiceTableCell class])bundle:nil] forCellReuseIdentifier:kOrderFillInvoiceTableCellIdentifier];
        
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderFillIncreasedTicketQualificationTableCell class])bundle:nil] forCellReuseIdentifier:kOrderFillIncreasedTicketQualificationTableCellIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReceiveTicketsTableCell class])bundle:nil] forCellReuseIdentifier:kReceiveTicketsTableCellIdentifier];
        
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderFillInvoiceEmailTableViewCell class])bundle:nil] forCellReuseIdentifier:@"OrderFillInvoiceEmailTableViewCell"];
    }
    return _tableView;
}

-(UIButton *)determineButton{
    
    if (_determineButton == nil) {
        _determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat y = CGRectGetMaxY(self.contentView.bounds) - 40 - 20;
        CGFloat width = CGRectGetWidth(self.contentView.bounds) - 32;
        [_determineButton setFrame:CGRectMake(16, y, width, 40)];
        [_determineButton setBackgroundColor:kMainYellow];
        [_determineButton setTitle:SLLocalizedString(@"确定") forState:UIControlStateNormal];
        [_determineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_determineButton.titleLabel setFont:kRegular(15)];
        _determineButton.layer.cornerRadius = SLChange(20);
        [_determineButton addTarget:self action:@selector(determineAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determineButton;
    
}

-(OrderFillInvoiceTabelHeadView *)tableHeadView{
    
    if (_tableHeadView == nil) {
        _tableHeadView = [[OrderFillInvoiceTabelHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
        [_tableHeadView setDelegate:self];
    }
    return _tableHeadView;
    
}

-(OrderFillInvoiceTabelFooterView *)tabelFooterView{
    if (_tabelFooterView == nil) {
        _tabelFooterView = [[OrderFillInvoiceTabelFooterView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 124)];
    }
    return _tabelFooterView;
}

-(void)setQualificationsModel:(InvoiceQualificationsModel *)qualificationsModel{
    _qualificationsModel = qualificationsModel;
}



@end
