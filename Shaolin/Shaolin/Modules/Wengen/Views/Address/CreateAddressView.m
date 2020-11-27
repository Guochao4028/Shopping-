//
//  CreateAddressView.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "CreateAddressView.h"

#import "CreateAddressTableViewCell.h"

#import "DefaultAddressTableCell.h"

#import "AddressInfoModel.h"

#import "AddressListModel.h"

#import "NSString+Tool.h"

#import "AreaView.h"

#import "MutableCopyCatetory.h"


static NSString *const kCreateAddressTableViewCellIdentifier = @"CreateAddressTableViewCell";

static NSString *const kDefaultAddressTableCellIdentifier = @"DefaultAddressTableCell";

@interface CreateAddressView ()<UITableViewDelegate, UITableViewDataSource, CreateAddressTableViewCellDelegate, AreaSelectDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIButton *saveButton;


@property(nonatomic, strong)NSArray *cellContentArray;

@property(nonatomic, strong)AreaView *areaView;
@property(nonatomic, strong)NSIndexPath *countriesIndexPath;
@property(nonatomic, strong)NSIndexPath *provinceIndexPath;
@property(nonatomic, strong)NSIndexPath *cityIndexPath;
@property(nonatomic, strong)NSIndexPath *regionsIndexPath;
@property(nonatomic, assign)NSInteger areaIndex;
@property(nonatomic, strong)NSArray *dataList;

@property(nonatomic, assign)BOOL isAgainOpen;

@property(nonatomic, strong)CreateAddressTableViewCell *temCell;

@property(nonatomic, copy)NSString *country_s;
@property(nonatomic, copy)NSString *province_s;
@property(nonatomic, copy)NSString *city_s;
@property(nonatomic, copy)NSString *area_s;

@property(nonatomic, copy)NSString *country_id;
@property(nonatomic, copy)NSString *province_id;
@property(nonatomic, copy)NSString *city_id;
@property(nonatomic, copy)NSString *area_id;

@property(nonatomic, assign)BOOL isDefault;



@end

@implementation CreateAddressView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initData];
        [self initUI];
    }
    return self;
}

#pragma mark - methods
-(void)initUI{
    [self addSubview:self.tableView];
    [self addSubview:self.saveButton];
}

-(void)initData{
    NSArray *cellContentArray = @[
        @{@"title":SLLocalizedString(@"收货人"),@"content":SLLocalizedString(@"请填写收货人姓名"), @"isMore":@"0", @"isNumber":@"0", @"txt":@""},
  @{@"title":SLLocalizedString(@"手机号"),@"content":SLLocalizedString(@"请填写收货人手机号"), @"isMore":@"0", @"isNumber":@"1", @"txt":@""},
  @{@"title":SLLocalizedString(@"所在地区"),@"content":SLLocalizedString(@"省市区县、乡镇等"), @"isMore":@"1", @"isNumber":@"0", @"txt":@""},
  @{@"title":SLLocalizedString(@"详细地址"),@"content":SLLocalizedString(@"街道、楼牌号等"), @"isMore":@"0", @"isNumber":@"0", @"txt":@""},
    ];
    
    
    self.cellContentArray = [cellContentArray mutableArrayDeeoCopy];
    
    self.areaIndex = 0;

    ModelTool *dataModel = [ModelTool shareInstance];
    self.dataList = dataModel.addressArray;
}

- (void)requestAllAreaName{
   
    switch (self.areaIndex) {
        case 0:
        {
            [self.areaView showAreaView];
            [self.areaView setCountriesArray:[NSMutableArray arrayWithArray:self.dataList]];
        }
            break;
        case 1:{
            
            NSInteger section = self.countriesIndexPath.section;
            NSInteger row = self.countriesIndexPath.row;
            NSDictionary *dic = self.dataList[section];
            NSArray *array = dic[@"subArray"];
            AddressInfoModel *model = array[row];
            if (model.childern.count > 0) {
                [self.areaView setProvinceArray:[NSMutableArray arrayWithArray:model.childern]];
            }else{
                [self.areaView hidenAreaView];
            }
        }
            
            break;
        case 2:{
            NSInteger section = self.countriesIndexPath.section;
            NSInteger row = self.countriesIndexPath.row;
            NSDictionary *dic = self.dataList[section];
            NSArray *array = dic[@"subArray"];
            AddressInfoModel *model = array[row];
            AddressInfoModel *provinceModel = model.childern[self.provinceIndexPath.row];
            
            NSArray *a = [provinceModel.childern lastObject];
            if (a.count > 0) {
                [self.areaView setCityArray:[NSMutableArray arrayWithArray:a]];
            }else{
                [self.areaView hidenAreaView];
            }
        }
            break;
        case 3:{
            NSInteger section = self.countriesIndexPath.section;
            NSInteger row = self.countriesIndexPath.row;
            NSDictionary *dic = self.dataList[section];
            NSArray *array = dic[@"subArray"];
             AddressInfoModel *model = array[row];
            AddressInfoModel *provinceModel = model.childern[self.provinceIndexPath.row];
            NSArray *provinceArray = [provinceModel.childern lastObject];
            AddressInfoModel *cityModel = provinceArray[self.cityIndexPath.row];
            NSArray *cityArray = [cityModel.childern lastObject];
            if (cityArray.count > 0) {
                [self.areaView setRegionsArray:[NSMutableArray arrayWithArray:cityArray]];
            }else{
                [self.areaView hidenAreaView];
            }
        }
            break;
        default:
            break;
    }

}

#pragma mark - action
-(void)tapSave{
    [self endEditing:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    for (int i = 0; i < rows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        CreateAddressTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField *)view;
                NSString *str = tf.text;
                if (str.length > 0) {
                    
                    if (i == 0) {
                        [dic setValue:str forKey:@"realname"];
                    }else if(i == 1){
                        [dic setValue:str forKey:@"phone"];
                    }else if(i == 3){
                        [dic setValue:str forKey:@"address"];
                    }
                }
            }
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    DefaultAddressTableCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UISwitch class]]) {
            UISwitch *switcha = (UISwitch *)view;
            BOOL isOn = switcha.isOn;
            if (isOn == YES) {
                [dic setValue:@"1" forKey:@"status"];
            }else{
                [dic setValue:@"0" forKey:@"status"];
            }
            
        }
    }

    if (self.country_id != nil) {
       [dic setValue:self.country_id forKey:@"country_id"];
    }
    
    if (self.province_id != nil) {
       [dic setValue:self.province_id forKey:@"province_id"];
    }
    
    if (self.city_id != nil) {
       [dic setValue:self.city_id forKey:@"city_id"];
    }
    
    if (self.area_id != nil) {
       [dic setValue:self.area_id forKey:@"re_id"];
    }
    
    if (self.country_s != nil) {
       [dic setValue:self.country_s forKey:@"country_s"];
    }
    
    if (self.province_s != nil) {
       [dic setValue:self.province_s forKey:@"province_s"];
    }
    
    if (self.city_s != nil) {
          [dic setValue:self.city_s forKey:@"city_s"];
       }
    
    
    NSString *realname = [dic objectForKey:@"realname"];
    if (realname.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写收货人姓名") view:WINDOWSVIEW afterDelay:TipSeconds];
        return;
    }
    
    NSString *phone = [dic objectForKey:@"phone"];
    if (phone.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写收货人手机号") view:WINDOWSVIEW afterDelay:TipSeconds];
        return;
    }
    
    
    if ([NSString validateContactNumber:phone] == NO ) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入正确手机号") view:WINDOWSVIEW afterDelay:TipSeconds];
        return;
    }
    
    NSString *address = [dic objectForKey:@"address"];
    if (address.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写详细地址") view:WINDOWSVIEW afterDelay:TipSeconds];
        return;
    }
    
    if (self.country_id == nil){
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择所在地区") view:WINDOWSVIEW afterDelay:TipSeconds];
        return;
    }
        
    
    
    if ([self.delegate respondsToSelector:@selector(createAddressView:tapSave:)] == YES) {
        [self.delegate createAddressView:self tapSave:dic];
        [self.saveButton setEnabled:NO];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.cellContentArray.count;
    }else{
        return 1;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return 10;
    }
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
    view.backgroundColor = KTextGray_FA;
    return view;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 0;
    if (indexPath.section == 0) {
        tableViewH = 50;
        if (indexPath.row == 3) {
             tableViewH = 82;
        }
        
    }else{
        tableViewH = 73;
    }
    return tableViewH;
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:{
            CreateAddressTableViewCell *createAddressCell = [tableViews dequeueReusableCellWithIdentifier:kCreateAddressTableViewCellIdentifier];
            
            createAddressCell.dataDic = [self.cellContentArray objectAtIndex:indexPath.row];
            [createAddressCell setDelegate:self];
            cell = createAddressCell;
        }
            break;
            
        case 1:{
            
            DefaultAddressTableCell *defaultAddressCell = [tableViews dequeueReusableCellWithIdentifier:kDefaultAddressTableCellIdentifier];
            defaultAddressCell.isOpen = self.isDefault;
            cell = defaultAddressCell;
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    return cell;
}

#pragma mark -  CreateAddressTableViewCellDelegate
-(void)createAddressCell:(CreateAddressTableViewCell *)cell tap:(BOOL)istap{
    [self endEditing:YES];
    self.temCell = cell;
    if (self.isAgainOpen == NO) {
        self.isAgainOpen = YES;
        [self requestAllAreaName];
        
        
    }
    else
        [self.areaView showAreaView];
}
#pragma mark - AreaSelectDelegate
- (void)selectIndex:(NSInteger)index selectID:(NSString *)areaID selectLoction:(NSIndexPath *)loction{
    self.areaIndex = index;
    
   
    
    if (index == 1) {
        
        if (self.countriesIndexPath != loction) {
            self.provinceIndexPath = nil;
            self.cityIndexPath = nil;
            self.regionsIndexPath = nil;
        }
        
        self.countriesIndexPath = loction;
        
        
    }else if (index == 2) {
        self.provinceIndexPath = loction;
    }else if (index == 3) {
        self.cityIndexPath = loction;
    }else{
        self.regionsIndexPath = loction;
    }
    
    if (index > 0) {
        [self requestAllAreaName];
    }
}

- (void)getSelectAddressInfor:(NSString *)addressInfor{
    
    AddressInfoModel *model;
    
//    self.country_id = nil;
//    self.country_s = nil;
//    self.province_id= nil;
//    self.province_s = nil;
//    self.city_id= nil;
//    self.city_s = nil;
//    self.area_id= nil;
//    self.area_s = nil;
    
    
    if (self.countriesIndexPath != nil) {
        NSInteger section = self.countriesIndexPath.section;
        NSInteger row = self.countriesIndexPath.row;
        NSDictionary *dic = self.dataList[section];
        NSArray *array = dic[@"subArray"];
        model = array[row];
        
        if ([model.childern count]) {
            if ([model.cname isEqualToString:@"中国"]) {
                if (self.regionsIndexPath == nil) {
                    return;
                }
            }else{
                if (self.cityIndexPath == nil) {
                    return;
                }
            }
        }
        
        
        
        self.country_id = model.addressId;
        self.country_s = model.cname;
        
        self.province_id= nil;
        self.province_s = nil;
        self.city_id= nil;
        self.city_s = nil;
        self.area_id= nil;
        self.area_s = nil;
       
    }
    
    if (self.provinceIndexPath != nil) {
        model = model.childern[self.provinceIndexPath.row];
        self.province_id = model.addressId;
        self.province_s = model.cname;
    }
    
    if (self.cityIndexPath != nil) {
        NSArray *cityArray = [model.childern lastObject];
        model = cityArray[self.cityIndexPath.row];
        self.city_id = model.addressId;
        self.city_s = model.cname;
    }
    
    if (self.regionsIndexPath != nil) {
        NSArray *regionsArray = [model.childern lastObject];
        model = regionsArray[self.regionsIndexPath.row];
        self.area_id = model.addressId;
        self.area_s = model.cname;
    }
    
    NSMutableString *tempStr = [NSMutableString string];
    
    if (self.country_s) {
        [tempStr appendString:self.country_s];
    }
    
    if(self.province_s){
        [tempStr appendString:[NSString stringWithFormat:@" %@", self.province_s]];
    }
    
    if (self.city_s) {
        [tempStr appendString:[NSString stringWithFormat:@" %@", self.city_s]];
    }
    
    if (self.area_s) {
        [tempStr appendString:[NSString stringWithFormat:@" %@", self.area_s]];
    }
    
  
    
//    [self.temCell setAddressStr:addressInfor];
    [self.temCell setAddressStr:tempStr];
    
    for (NSMutableDictionary *dic in self.cellContentArray) {
        NSString *title = dic[@"title"];
       
        
        if ([title isEqualToString:SLLocalizedString(@"所在地区")]) {
            [dic setValue:tempStr forKey:@"txt"];
            break;
        }

    }

    
    NSLog(@"model : %@",model);
    
}

#pragma mark - getter / setter

-(UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
        if(@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CreateAddressTableViewCell class])bundle:nil] forCellReuseIdentifier:kCreateAddressTableViewCellIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DefaultAddressTableCell class])bundle:nil] forCellReuseIdentifier:kDefaultAddressTableCellIdentifier];
        
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
    }
    return _tableView;
    
}

-(UIButton *)saveButton{
    
    if (_saveButton == nil) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat x = (ScreenWidth - 250)/2;
        CGFloat y = CGRectGetHeight(self.bounds) - (40 +28);
        
        [_saveButton setFrame:CGRectMake(x, y, 250, 40)];
        _saveButton.layer.cornerRadius = SLChange(18);
        [_saveButton setBackgroundColor:kMainYellow];
        [_saveButton setTitle:SLLocalizedString(@"保存") forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_saveButton addTarget:self action:@selector(tapSave) forControlEvents:UIControlEventTouchUpInside];
        [_saveButton.titleLabel setFont:kRegular(15)];
    }
    return _saveButton;

}

-(AreaView *)areaView{
    
    if (_areaView == nil) {
        _areaView = [[AreaView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _areaView.hidden = YES;
        _areaView.address_delegate = self;
        
        [[UIApplication sharedApplication].keyWindow addSubview:_areaView];
    }
    return _areaView;

}

-(void)setAddressListModel:(AddressListModel *)addressListModel{
    _addressListModel = addressListModel;
    
    
    if (addressListModel != nil) {
        NSMutableString *addressStr = [NSMutableString string];
           
           if (addressListModel.country_s != nil) {
              [addressStr appendString:addressListModel.country_s];
           }
           
           if (addressListModel.province_s != nil) {
              [addressStr appendString:[NSString stringWithFormat:@" %@", addressListModel.province_s]];
           }
           
           if (addressListModel.city_s != nil) {
              [addressStr appendString:[NSString stringWithFormat:@" %@",addressListModel.city_s]];
           }
           if (addressListModel.re_s != nil) {
               [addressStr appendString:[NSString stringWithFormat:@" %@",addressListModel.re_s]];
           }
           
           
//           self.cellContentArray = @[
//                 @{@"title":SLLocalizedString(@"收货人"),@"content":SLLocalizedString(@"请填写收货人姓名"), @"isMore":@"0", @"isNumber":@"0", @"txt":addressListModel.realname},
//           @{@"title":SLLocalizedString(@"手机号"),@"content":SLLocalizedString(@"请填写收货人手机号"), @"isMore":@"0", @"isNumber":@"1", @"txt":addressListModel.phone},
//           @{@"title":SLLocalizedString(@"所在地区"),@"content":SLLocalizedString(@"省市区县、乡镇等"), @"isMore":@"1", @"isNumber":@"0", @"txt":addressStr},
//           @{@"title":SLLocalizedString(@"详细地址"),@"content":SLLocalizedString(@"街道、楼牌号等"), @"isMore":@"0", @"isNumber":@"0", @"txt":addressListModel.address},
//             ];
//
        
        for (NSMutableDictionary *dic in self.cellContentArray) {
            NSString *title = dic[@"title"];
            if ([title isEqualToString:SLLocalizedString(@"收货人")]) {
                [dic setValue:addressListModel.realname forKey:@"txt"];
            }
            
            if ([title isEqualToString:SLLocalizedString(@"手机号")]) {
                [dic setValue:addressListModel.phone forKey:@"txt"];
            }
            
            if ([title isEqualToString:SLLocalizedString(@"所在地区")]) {
                [dic setValue:addressStr forKey:@"txt"];
            }
            
            if ([title isEqualToString:SLLocalizedString(@"详细地址")]) {
                [dic setValue:addressListModel.address forKey:@"txt"];
            }
        }
        
        self.country_id = addressListModel.country_id;
        self.province_id = addressListModel.province_id;
        self.city_id = addressListModel.city_id;
        self.area_id = addressListModel.re_id;
        
            
            self.country_s = addressListModel.country_s;
            
            self.province_s = addressListModel.province_s;
            
            self.city_s = addressListModel.city_s;
            
            self.area_s = addressListModel.re_s;
        
        self.isDefault = [addressListModel.status boolValue];
           
           [self.tableView reloadData];
    }
}

-(void)setIsEnabled:(BOOL)isEnabled{
    _isEnabled = isEnabled;
    [self.saveButton setEnabled:isEnabled];
}

@end
