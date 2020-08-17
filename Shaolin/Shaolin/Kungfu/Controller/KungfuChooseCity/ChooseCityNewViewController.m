//
//  ChooseCityNewViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ChooseCityNewViewController.h"

#import "HotCityTableViewCell.h"

#import "CitySelectedTableViewCell.h"

#import "AreaView.h"

#import "AddressInfoModel.h"

#import "HotCityModel.h"



@interface ChooseCityNewViewController ()<UITableViewDataSource,UITableViewDelegate, HotCityTableViewCellDelegate, AreaSelectDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)AreaView *areaView;

@property(nonatomic, assign)NSInteger areaIndex;

@property(nonatomic, strong)NSArray *dataList;

@property(nonatomic, strong)NSIndexPath *countriesIndexPath;
@property(nonatomic, strong)NSIndexPath *provinceIndexPath;
@property(nonatomic, strong)NSIndexPath *cityIndexPath;
@property(nonatomic, strong)NSIndexPath *regionsIndexPath;

//判断是否是国内
@property(nonatomic, assign)BOOL isDomestic;

@end

@implementation ChooseCityNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleLabe.text = SLLocalizedString(@"切换城市");
    
    [self.view addSubview:self.tableView];
    self.areaIndex = 0;
    ModelTool *dataModel = [ModelTool shareInstance];
    self.dataList = dataModel.addressArray;
    
    
}


- (void)requestAllAreaName{
    
    if (self.isDomestic == YES) {
        switch (self.areaIndex) {
            case 0:
            {
                [self.areaView showAreaView];
                
                NSLog(@"self.dataList[0] : %@", self.dataList[0]);
                
                NSDictionary *dic = [self.dataList firstObject];
                
                NSArray *array = dic[@"subArray"];
                
                AddressInfoModel *model = [array firstObject];
                
                [self.areaView setCountriesArray:[NSMutableArray arrayWithArray:model.childern]];
                
            }
                break;
            case 1:{
                
                NSDictionary *dic = self.dataList[0];
                NSArray *array = dic[@"subArray"];
                AddressInfoModel *model = array[0];
                
                NSInteger row = self.countriesIndexPath.row;
                
                AddressInfoModel *provinceModel = model.childern[row];
                NSArray *a = [provinceModel.childern lastObject];
                if (provinceModel.childern.count > 0) {
                    [self.areaView setProvinceArray:[NSMutableArray arrayWithArray:a]];
                }else{
                    [self.areaView hidenAreaView];
                }
            }
                
                break;
            case 2:{
                [self.areaView hidenAreaView];
            }
                break;
            case 3:{
                [self.areaView hidenAreaView];
            }
                break;
            default:
                break;
        }
    }else{
        
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
                [self.areaView hidenAreaView];
            }
                break;
            default:
                break;
        }
        
    }
}

#pragma mark - AreaSelectDelegate
- (void)selectIndex:(NSInteger)index selectID:(NSString *)areaID selectLoction:(NSIndexPath *)loction{
    self.areaIndex = index;
    if (index == 1) {
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
    
    if (self.isDomestic == YES) {
        
        if (self.countriesIndexPath != nil) {
            
            NSDictionary *dic = self.dataList[0];
            NSArray *array = dic[@"subArray"];
            AddressInfoModel *temModel = array[0];
            model = temModel.childern[self.countriesIndexPath.row];
            
            //        self.country_id = model.addressId;
            //        self.country_s = model.cname;
            
        }
        
        if (self.provinceIndexPath != nil) {
            
            
            NSArray *regionsArray = [model.childern lastObject];
            model = regionsArray[self.provinceIndexPath.row];
            //        self.province_id = model.addressId;
            //        self.province_s = model.cname;
        }
        
        
    }else{
        if (self.countriesIndexPath != nil) {
            NSInteger section = self.countriesIndexPath.section;
            NSInteger row = self.countriesIndexPath.row;
            NSDictionary *dic = self.dataList[section];
            NSArray *array = dic[@"subArray"];
            model = array[row];
            
            //        self.country_id = model.addressId;
            //        self.country_s = model.cname;
            
        }
        
        if (self.provinceIndexPath != nil) {
            model = model.childern[self.provinceIndexPath.row];
            //        self.province_id = model.addressId;
            //        self.province_s = model.cname;
        }
        
        if (self.cityIndexPath != nil) {
            NSArray *cityArray = [model.childern lastObject];
            model = cityArray[self.cityIndexPath.row];
            //        self.city_id = model.addressId;
            //        self.city_s = model.cname;
        }
        
        if (self.regionsIndexPath != nil) {
            NSArray *regionsArray = [model.childern lastObject];
            model = regionsArray[self.regionsIndexPath.row];
            //        self.area_id = model.addressId;
        }
        
        //    [self.temCell setAddressStr:addressInfor];
        
        
        NSLog(@"model : %@",model);
    }
    
    
    [self.areaView removeFromSuperview];
    self.areaView = nil;
    
    if (model.addressId.length > 0 && model.cname.length > 0) {
        HotCityModel *cityModel = [[HotCityModel alloc] init];
           
           cityModel.popularCode = model.addressId;
           cityModel.popularName = model.cname;
           
           if (self.selectString) {
               self.selectString(cityModel);
               [self.navigationController popViewControllerAnimated:YES];
           }
    }
    
    
   
    
    
    
}


#pragma mark --UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ( section == 0){
        return 1;
    }else{
        return 2;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *HeaderIdentifier = @"header";
    UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if( headerView == nil)
    {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
        [headerView setBackgroundColor:[UIColor clearColor]];
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 35)];
        [titleLabel setFont:kRegular(13)];
        titleLabel.tag = 1;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        [headerView.contentView addSubview:titleLabel];
    }
    headerView.contentView.backgroundColor = [UIColor colorForHex:@"ffffff"];
    UILabel *label = (UILabel *)[headerView viewWithTag:1];
    NSString *titleStr;
    if (section == 0) {
        titleStr = SLLocalizedString(@"热门城市");
    }else{
        titleStr = SLLocalizedString(@"选择地区");
    }
    
    [label setText:titleStr];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
       
        return ceil([self.hotCityArray count]/3.0) *52;
    }else{
        return 60;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        HotCityTableViewCell *hotCityCell = [tableView dequeueReusableCellWithIdentifier:@"HotCityTableViewCell"];
        [hotCityCell setDelegate:self];
        [hotCityCell setDataArray:self.hotCityArray];
        cell = hotCityCell;
    }else{
        
        CitySelectedTableViewCell *citySelectedCell = [tableView dequeueReusableCellWithIdentifier:@"CitySelectedTableViewCell"];
        NSString *titleStr;
        if (indexPath.row == 0) {
            titleStr = SLLocalizedString(@"国内");
        }else{
            titleStr = SLLocalizedString(@"海外");
        }
        
        [citySelectedCell setTitleStr:titleStr];
        cell = citySelectedCell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSLog(@"国内");
            self.areaIndex = 0;
            self.isDomestic = YES;
            [self requestAllAreaName];
            self.countriesIndexPath = nil;
            self.provinceIndexPath = nil;
            self.cityIndexPath = nil;
            self.regionsIndexPath = nil;
            
        }else{
            NSLog(@"海外");
            self.areaIndex = 0;
            self.isDomestic = NO;
            [self requestAllAreaName];
            self.countriesIndexPath = nil;
            self.provinceIndexPath = nil;
            self.cityIndexPath = nil;
            self.regionsIndexPath = nil;
        }
    }
}



#pragma mark - HotCityTableViewCellDelegate
-(void)hotCityTableViewCell:(HotCityTableViewCell *)cell tapItem:(HotCityModel *)model{
    if (self.selectString) {
        self.selectString(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - getter / setter

-(UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavBar_Height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HotCityTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"HotCityTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CitySelectedTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"CitySelectedTableViewCell"];
    }
    return _tableView;
    
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


@end
