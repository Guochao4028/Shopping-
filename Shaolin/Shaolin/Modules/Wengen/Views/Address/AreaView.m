//
//  AreaView.m
//  Shihanbainian
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 Codeliu. All rights reserved.
//

#import "AreaView.h"
#import "AddressInfoModel.h"

#import "IndexView.h"
#import "IndexItemView.h"

@interface AreaView ()<IndexViewDelegate, IndexViewDataSource>

@property(nonatomic, strong)UIView *indexesView;

@property(nonatomic, strong)IndexView *indexView;

@property(nonatomic, weak)UITableView *currTableView;


@end

@implementation AreaView
{
    UIView *blackBaseView;
    CGFloat btn1Height;
    CGFloat btn2Height;
    CGFloat btn3Height;
    CGFloat btn4Height;
}
CG_INLINE CGRect CGRectMakes(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    float secretNum = [[UIScreen mainScreen] bounds].size.width / ScreenWidth;
    rect.origin.x = x*secretNum; rect.origin.y = y*secretNum;
    rect.size.width = width*secretNum; rect.size.height = height*secretNum;
    
    return rect;
}

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define HTFont(s) [UIFont fontWithName:@"Helvetica-Light" size:s / 2 * MULPITLE]
#define MULPITLE [[UIScreen mainScreen] bounds].size.width / 375

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = NO;
        _countriesArray = [[NSMutableArray alloc]init];
        _provinceArray = [[NSMutableArray alloc]init];
        _cityArray = [[NSMutableArray alloc]init];
        _regionsArray = [[NSMutableArray alloc]init];
        
        [self creatBaseUI];
    }
    return self;
}


- (void)creatBaseUI
{
    blackBaseView = [[UIView alloc]initWithFrame:self.bounds];
    blackBaseView.backgroundColor = [UIColor blackColor];
    blackBaseView.alpha = 0;
    [self addSubview:blackBaseView];
    
    _areaWhiteBaseView = [[UIView alloc]initWithFrame:CGRectMakes(0, ScreenHeight, ScreenWidth, 554)];
    _areaWhiteBaseView.backgroundColor = [UIColor whiteColor];
    CGFloat radius = 12; // 圆角大小
    if (@available(iOS 11.0, *)) {
        _areaWhiteBaseView.layer.cornerRadius = radius;
        _areaWhiteBaseView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    } else {
        [self layoutIfNeeded];
        UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight; // 圆角位置，左上、右上
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        maskLayer.fillColor = [UIColor whiteColor].CGColor;
        _areaWhiteBaseView.layer.mask = maskLayer;
    }
    
    [self addSubview:_areaWhiteBaseView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMakes(0, 0, ScreenWidth, 50)];
    titleLabel.text = SLLocalizedString(@"所在地区");
    titleLabel.textColor = RGBCOLOR(0, 0, 34);
    titleLabel.font = HTFont(34);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_areaWhiteBaseView addSubview:titleLabel];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 20 - 16, (CGRectGetHeight(titleLabel.frame) - 16)/2, 16, 16)];
    [closeButton setImage:[UIImage imageNamed:@"enrollment_clear"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(tapHidenGes) forControlEvents:UIControlEventTouchUpInside];
    [_areaWhiteBaseView addSubview:closeButton];
    
    for (int i = 0; i < 4; i++) {
        UIButton *areaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        areaBtn.frame = CGRectMakes(80 * i, 50, 80, 30);
        [areaBtn setTitleColor:RGBCOLOR(34, 34, 34) forState:UIControlStateNormal];
        areaBtn.tag = 100 + i;
        [areaBtn setTitle:@"" forState:UIControlStateNormal];
        [areaBtn addTarget:self action:@selector(areaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        areaBtn.userInteractionEnabled = NO;
        [_areaWhiteBaseView addSubview:areaBtn];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMakes(80 * i + 10, 78, 60, 2)];
        lineView.backgroundColor = kMainYellow;
        [_areaWhiteBaseView addSubview:lineView];
        lineView.tag = 300 + i;
        lineView.hidden = YES;
        if (i == 0) {
            areaBtn.userInteractionEnabled = YES;
            [areaBtn setTitle:SLLocalizedString(@"请选择") forState:UIControlStateNormal];
            [areaBtn setTitleColor:RGBCOLOR(0, 0, 34) forState:UIControlStateNormal];
            lineView.hidden = NO;
        }
    }
    
    _areaScrollView = [[UIScrollView alloc]initWithFrame:CGRectMakes(0, 80, ScreenWidth, 499)];
    _areaScrollView.delegate = self;
    _areaScrollView.contentSize = CGSizeMake(ScreenWidth, 300 * MULPITLE);
    _areaScrollView.pagingEnabled = YES;
    _areaScrollView.showsVerticalScrollIndicator = NO;
    _areaScrollView.showsHorizontalScrollIndicator = NO;
    [_areaWhiteBaseView addSubview:_areaScrollView];
    
    for (int i = 0; i < 4; i++) {
        UITableView *area_tableView = [[UITableView alloc]initWithFrame:CGRectMakes(ScreenWidth  * i, 0, ScreenWidth, 499) style:UITableViewStylePlain];
        area_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        area_tableView.delegate = self;
        area_tableView.dataSource = self;
        area_tableView.tag = 200 + i;
        [_areaScrollView addSubview:area_tableView];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHidenGes)];
    [blackBaseView addGestureRecognizer:tap];
}
#pragma mark - tapHidenGes
- (void)tapHidenGes
{
    [self hidenAreaView];
}
#pragma mark - areaBtnAction
- (void)areaBtnAction:(UIButton *)btn
{
    for (UIView *view in _areaWhiteBaseView.subviews) {
        if (view.tag >= 300) {
            view.hidden = YES;
        }
    }
    UIView *lineView = [_areaWhiteBaseView viewWithTag:300 + btn.tag - 100];
    lineView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.areaScrollView.contentOffset = CGPointMake(ScreenWidth * (btn.tag - 100), 0);
    }];
}

- (void)setCountriesArray:(NSMutableArray *)countriesArray{
    _countriesArray = countriesArray;
    
    UITableView *tableView = [_areaScrollView viewWithTag:200];
    
    if ([[countriesArray objectAtIndex:0] isKindOfClass:[NSDictionary class]] == YES) {
        if (countriesArray.count > 1) {
            
             [_areaScrollView addSubview:self.indexesView];
            
            [self.indexesView addSubview:self.indexView];
            
            
            
        }
    }
    
    self.currTableView = tableView;
    [tableView reloadData];
}

- (void)setProvinceArray:(NSMutableArray *)provinceArray
{
    _provinceArray = provinceArray;
    UITableView *tableView = [self.areaScrollView viewWithTag:201];
    [tableView reloadData];
    self.areaScrollView.contentSize = CGSizeMake(ScreenWidth *2, 300 * MULPITLE);
    [UIView animateWithDuration:0.5 animations:^{
        self.areaScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    }];
}
- (void)setCityArray:(NSMutableArray *)cityArray
{
    _cityArray = cityArray;
    UITableView *tableView = [self.areaScrollView viewWithTag:202];
    [tableView reloadData];
    self.areaScrollView.contentSize = CGSizeMake(ScreenWidth * 3, 300 * MULPITLE);
    [UIView animateWithDuration:0.5 animations:^{
        self.areaScrollView.contentOffset = CGPointMake(ScreenWidth * 2, 0);
    }];
}
- (void)setRegionsArray:(NSMutableArray *)regionsArray
{
    _regionsArray = regionsArray;
    UITableView *tableView = [self.areaScrollView viewWithTag:203];
    [tableView reloadData];
    self.areaScrollView.contentSize = CGSizeMake(ScreenWidth * 4, 300 * MULPITLE);
    [UIView animateWithDuration:0.5 animations:^{
        self.areaScrollView.contentOffset = CGPointMake(ScreenWidth * 3, 0);
    }];
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 200) {
        
        if ([[_countriesArray firstObject] isKindOfClass:[NSDictionary class]] == YES) {
            
            return _countriesArray.count;
            
        }else{
            return 1;
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag - 200) {
        case 0:
        {
            if ([_countriesArray count] > 0) {
                if ([_countriesArray[section] isKindOfClass:[NSDictionary class]] == YES) {
                    NSDictionary *dic = _countriesArray[section];
                    
                    NSArray *array = dic[@"subArray"];
                    
                    return array.count;
                }else{
                    
                    return _countriesArray.count;
                }
            }
            
        }
            break;
        case 1:
        {
            return _provinceArray.count;
        }
            break;
        case 2:
        {
            return _cityArray.count;
        }
            break;
        case 3:
        {
            return _regionsArray.count;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44 * MULPITLE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"area_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"area_cell"];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//
    UIImageView *selectedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hook"]];
    [selectedImageView setFrame:CGRectMake(0, 0, 12, 9)];

    selectedImageView.centerY = cell.centerY;

    [cell.selectedBackgroundView addSubview:selectedImageView];
//    cell.selectedBackgroundView.backgroundColor = kMainYellow;//RGBCOLOR(255,238,238);
    cell.textLabel.highlightedTextColor = KTextGray_333;
    
//    if(cell.isSelected){
//        [cell.imageView setImage:[UIImage imageNamed:@"hook"]];
//    }else{
//        [cell.imageView setImage:[UIImage imageNamed:@""]];
//    }
    
    
    switch (tableView.tag - 200) {
        case 0:
        {
            if ([_countriesArray[indexPath.section] isKindOfClass:[NSDictionary class]] == YES) {
                NSDictionary *dic = _countriesArray[indexPath.section];
                NSArray *array = dic[@"subArray"];
                AddressInfoModel *addressAreaModel = array[indexPath.row];
                cell.textLabel.text = addressAreaModel.cname;
                cell.textLabel.font = HTFont(28);
                cell.textLabel.textColor = KTextGray_333;
            }else{
                AddressInfoModel *addressAreaModel = _countriesArray[indexPath.row];
                
                NSString *cname = addressAreaModel.cname;
                cell.textLabel.text = cname;
                cell.textLabel.font = HTFont(28);
                cell.textLabel.textColor = KTextGray_333;
            }
            
            
        }
            break;
        case 1:
        {
            AddressInfoModel *addressAreaModel = _provinceArray[indexPath.row];
            
            NSString *cname = addressAreaModel.cname;
            cell.textLabel.text = cname;
            cell.textLabel.font = HTFont(28);
            cell.textLabel.textColor = KTextGray_333;
        }
            break;
        case 2:
        {
            AddressInfoModel *addressAreaModel = _cityArray[indexPath.row];
            cell.textLabel.text = addressAreaModel.cname;
            cell.textLabel.font = HTFont(28);
            cell.textLabel.textColor = KTextGray_333;
        }
            break;
        case 3:
        {
            AddressInfoModel *addressAreaModel = _regionsArray[indexPath.row];
            cell.textLabel.text = addressAreaModel.cname;
            cell.textLabel.font = HTFont(28);
            cell.textLabel.textColor = KTextGray_333;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *btn1 = [_areaWhiteBaseView viewWithTag:100];
    UIButton *btn2 = [_areaWhiteBaseView viewWithTag:101];
    UIButton *btn3 = [_areaWhiteBaseView viewWithTag:102];
    UIButton *btn4 = [_areaWhiteBaseView viewWithTag:103];
    for (UIView *view in _areaWhiteBaseView.subviews) {
        if (view.tag >= 300) {
            view.hidden = YES;
        }
    }
    
    UIView *lineView1 = [_areaWhiteBaseView viewWithTag:300];
    UIView *lineView2 = [_areaWhiteBaseView viewWithTag:301];
    UIView *lineView3 = [_areaWhiteBaseView viewWithTag:302];
    UIView *lineView4 = [_areaWhiteBaseView viewWithTag:303];
    switch (tableView.tag - 200) {
        case 0:{
            AddressInfoModel *addressAreaModel;
            
            if ([_countriesArray[indexPath.section] isKindOfClass:[NSDictionary class]] == YES) {
                 NSDictionary *dic = _countriesArray[indexPath.section];
                NSArray *array = dic[@"subArray"];
                addressAreaModel =  array[indexPath.row];
            }else{
                addressAreaModel = _countriesArray[indexPath.section];
            }
            
            btn1Height = [AreaView getLabelWidth:addressAreaModel.cname font:30 height:30] + 20;
            [btn1 setTitle:addressAreaModel.cname forState:UIControlStateNormal];
            [btn1 setTitleColor:RGBCOLOR(34, 34, 34) forState:UIControlStateNormal];
            btn1.frame = CGRectMakes(0, 50, btn1Height, 30);
            btn2.frame = CGRectMakes(btn1Height, 50, 80, 30);
            btn1.userInteractionEnabled = YES;
            btn2.userInteractionEnabled = YES;
            btn3.userInteractionEnabled = NO;
            btn4.userInteractionEnabled = NO;
            [btn3 setHidden:YES];
            [btn4 setHidden:YES];;
            
            
            [btn2 setTitle:SLLocalizedString(@"请选择") forState:UIControlStateNormal];
            [btn2 setTitleColor:RGBCOLOR(0, 0, 34) forState:UIControlStateNormal];
            [btn3 setTitle:@"" forState:UIControlStateNormal];
            
            lineView2.hidden = NO;
            lineView1.frame = CGRectMakes(10, 78, btn1Height - 20, 2);
            lineView2.frame = CGRectMakes(btn1Height + 10, 78, 80 - 20, 2);
            if ([self.address_delegate respondsToSelector:@selector(selectIndex:selectID:selectLoction:)]) {
                [self.address_delegate selectIndex:1 selectID:addressAreaModel.addressId selectLoction:indexPath];
            }
        }
            break;
        case 1:{
            AddressInfoModel *addressAreaModel = _provinceArray[indexPath.row];
            btn2Height = [AreaView getLabelWidth:addressAreaModel.cname font:30 height:30] + 20;
            
            [btn2 setTitle:addressAreaModel.cname forState:UIControlStateNormal];
            [btn2 setTitleColor:RGBCOLOR(34, 34, 34) forState:UIControlStateNormal];
            [btn3 setHidden:NO];
            [btn4 setHidden:YES];
            [btn3 setTitle:SLLocalizedString(@"请选择") forState:UIControlStateNormal];
            [btn3 setTitleColor:RGBCOLOR(0, 0, 34) forState:UIControlStateNormal];
            lineView3.hidden = NO;
            lineView2.frame = CGRectMakes(btn1Height + 10, 78, btn2Height - 20, 2);
            lineView3.frame = CGRectMakes(btn1Height + btn2Height + 10, 78, 80 - 20, 2);
            btn3.userInteractionEnabled = YES;
            btn2.frame = CGRectMakes(btn1Height, 50, btn2Height, 30);
            btn3.frame = CGRectMakes(btn1Height + btn2Height, 50, 80, 30);
            
            if ([self.address_delegate respondsToSelector:@selector(selectIndex:selectID:selectLoction:)]) {
                [self.address_delegate selectIndex:2 selectID:addressAreaModel.addressId selectLoction:indexPath];
            }
        }
            break;
        case 2:
        {
            AddressInfoModel *addressAreaModel = _cityArray[indexPath.row];
            btn3Height = [AreaView getLabelWidth:addressAreaModel.cname font:30 height:30] + 20;
            [btn3 setTitle:addressAreaModel.cname forState:UIControlStateNormal];
            //
            [btn3 setTitleColor:RGBCOLOR(34, 34, 34) forState:UIControlStateNormal];
            [btn3 setHidden:NO];
            lineView3.hidden = NO;
            lineView3.frame = CGRectMakes(btn1Height + btn2Height + 10, 78, 80 - 20, 2);
            btn3.frame = CGRectMakes(btn1Height + btn2Height, 50, btn3Height, 30);
            NSArray *subChildernArray = [addressAreaModel.childern lastObject];
            
            if ([subChildernArray count]) {
                [btn4 setTitle:SLLocalizedString(@"请选择") forState:UIControlStateNormal];
                [btn4 setTitleColor:RGBCOLOR(0, 0, 34) forState:UIControlStateNormal];
                [btn4 setHidden:NO];
                lineView4.frame = CGRectMakes(btn2Height + btn1Height + btn3Height + 10, 78, 60, 2);
                btn4.userInteractionEnabled = YES;
                btn4.frame = CGRectMakes(btn2Height + btn1Height + btn3Height, 50, 80, 30);
            }
            
            if ([self.address_delegate respondsToSelector:@selector(selectIndex:selectID:selectLoction:)]) {
                [self.address_delegate selectIndex:3 selectID:addressAreaModel.addressId selectLoction:indexPath];
            }
        }
            break;
        case 3:
        {
            AddressInfoModel *addressAreaModel = _regionsArray[indexPath.row];
            btn4Height = [AreaView getLabelWidth:addressAreaModel.cname font:30 height:30] + 20;
            [btn4 setTitle:addressAreaModel.cname forState:UIControlStateNormal];
            [btn4 setTitleColor:RGBCOLOR(34, 34, 34) forState:UIControlStateNormal];
            lineView4.hidden = NO;
            
            lineView4.frame = CGRectMakes(btn1Height + btn3Height + btn2Height  + 10, 78, btn3Height - 20, 2);
            btn4.frame = CGRectMakes(btn1Height + btn3Height + btn2Height, 50, btn4Height, 30);
            if ([self.address_delegate respondsToSelector:@selector(selectIndex:selectID:selectLoction:)]) {
                [self.address_delegate selectIndex:0 selectID:addressAreaModel.addressId selectLoction:indexPath];
            }
            [self hidenAreaView];
        }
            break;
        default:
            break;
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag - 200 == 0) {
        //        if (section == 0) {
        //            return 0.01;
        //        }
        
        if ([_countriesArray[section] isKindOfClass:[NSDictionary class]] == YES) {
            return 30;
        }else{
            return 0.01;
        }
        
        
    }else{
        return 0.01;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 30)];
    
    if ([[self.countriesArray objectAtIndex:section] isKindOfClass:[NSDictionary class]] == YES) {
        NSDictionary *dic = [self.countriesArray objectAtIndex:section];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30,5, 100,20)];
        label.text = dic[@"firstLetter"];
        label.textColor= [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        
        [titleView addSubview:label];
        [view addSubview:titleView];
        
        if (tableView.tag - 200 == 0) {
            return view;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
    
    
    
}

//#pragma mark - UIScrollViewDelegate
//隐藏 选择按钮下面的线
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//    for (UIView *view in _areaWhiteBaseView.subviews) {
//        if (view.tag >= 300) {
//            view.hidden = YES;
//        }
//    }
//    if (scrollView == _areaScrollView) {
//        UIView *lineView = [_areaWhiteBaseView viewWithTag:300 + scrollView.contentOffset.x / ScreenWidth];
//
//        lineView.hidden = NO;
//    }
//}

#pragma mark - IndexViewDataSource & Delegate

- (NSInteger)numberOfItemViewForSectionIndexView:(IndexView *)sectionIndexView
{
    return self.countriesArray.count;
}

- (IndexItemView *)sectionIndexView:(IndexView *)sectionIndexView itemViewForSection:(NSInteger)section
{
    IndexItemView *itemView = [[IndexItemView alloc] init];
    NSDictionary *dic = [self.countriesArray objectAtIndex:section];
    itemView.titleLabel.text =dic[@"firstLetter"];
    itemView.titleLabel.font = [UIFont systemFontOfSize:12];
    return itemView;
}

- (NSString *)sectionIndexView:(IndexView *)sectionIndexView
               titleForSection:(NSInteger)section
{
    NSDictionary *dic = [self.countriesArray objectAtIndex:section];
    
    return dic[@"firstLetter"];
}

- (void)sectionIndexView:(IndexView *)sectionIndexView didSelectSection:(NSInteger)section
{
    NSLog(@"%ld", self.countriesArray.count);
    
    [self.currTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - showAreaView
- (void)showAreaView
{
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self->blackBaseView.alpha = 0.6;
        self.areaWhiteBaseView.frame = CGRectMakes(0, ScreenHeight - 554, ScreenWidth, 554);
    }];
}

#pragma mark - hidenAreaView
- (void)hidenAreaView{
    UIButton *btn1 = [_areaWhiteBaseView viewWithTag:100];
    UIButton *btn2 = [_areaWhiteBaseView viewWithTag:101];
    UIButton *btn3 = [_areaWhiteBaseView viewWithTag:102];
    UIButton *btn4 = [_areaWhiteBaseView viewWithTag:103];
    [UIView animateWithDuration:0.25 animations:^{
        self->blackBaseView.alpha = 0;
        self.areaWhiteBaseView.frame = CGRectMakes(0, ScreenHeight, ScreenWidth, 554);
        
    }completion:^(BOOL finished) {
        self.hidden = YES;
        
        NSMutableString *addressStr = [NSMutableString string];
        
        NSString *countriesStr = btn1.titleLabel.text;
        if (countriesStr != nil && [countriesStr isEqualToString:SLLocalizedString(@"请选择")] == NO) {
            [addressStr appendString:countriesStr];
        }
        
        NSString *provinceStr = btn2.titleLabel.text;
        if (provinceStr != nil && [provinceStr isEqualToString:SLLocalizedString(@"请选择")] == NO) {
            [addressStr appendString:[NSString stringWithFormat:@" %@", provinceStr]];
        }
        
        
        NSString *cityStr = btn3.titleLabel.text;
        if (cityStr != nil && [cityStr isEqualToString:SLLocalizedString(@"请选择")] == NO) {
            [addressStr appendString:[NSString stringWithFormat:@" %@", cityStr]];
        }
        
        NSString *regionsStr = btn4.titleLabel.text;
        if (regionsStr != nil && [regionsStr isEqualToString:SLLocalizedString(@"请选择")] == NO) {
            [addressStr appendString:[NSString stringWithFormat:@" %@", regionsStr]];
        }
        
        if ([self.address_delegate respondsToSelector:@selector(getSelectAddressInfor:)]) {
            
            [self.address_delegate getSelectAddressInfor:addressStr];
        }
    }];
}


+ (CGFloat)getLabelWidth:(NSString *)textStr font:(CGFloat)fontSize height:(CGFloat)labelHeight{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5 * MULPITLE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: HTFont(fontSize),NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [textStr boundingRectWithSize:CGSizeMake(1000, labelHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return size.width;
}

- (UIView *)indexesView{
    
    if (_indexesView == nil) {
        _indexesView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth - 25), 0, 20, 390)];
        
         [_indexesView setBackgroundColor:[UIColor colorWithRed:(238/255.0) green:(238/255.0) blue:(238/255.0) alpha:1]];
        
        _indexesView.layer.cornerRadius = 10;
    }
    return _indexesView;

}

- (IndexView *)indexView{
    
    if (_indexView == nil) {
        _indexView  = [[IndexView alloc]initWithFrame:CGRectMake(0, 10, 20, 370)];
        
        [_indexView setDelegate:self];
        [_indexView setDataSource:self];
        
        [_indexView reloadItemViews];
    }
    return _indexView;

}


@end
