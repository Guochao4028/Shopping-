//
//  GCPickTimeView.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GCPickTimeView.h"
#import "UIView+AutoLayout.h"

@interface GCPickTimeView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic, strong)UIPickerView *fullPickView;
@property(nonatomic, assign)NSInteger yearRange;
@property(nonatomic, assign)NSInteger startYear;
@property(nonatomic, assign)NSInteger selectedYear;
@property(nonatomic, assign)NSInteger selectedMonth;
@property(nonatomic, strong)NSDate *curDate;
@property(nonatomic, assign)NSInteger currentYear;
@property(nonatomic, assign)NSInteger currentMonth;

@end

@implementation GCPickTimeView

- (instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)initData{
    NSDateComponents *comps = [self p_DefaultTimeTrocessing:[NSDate date]];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    self.startYear = 2020;
    self.yearRange = year - self.startYear + 1;
    self.selectedYear = year;
    self.selectedMonth = month;
    
    self.currentYear = year;//当前年
    self.currentMonth = month;//当前月
    
}

- (void)initUI{
    [self addSubview:self.fullPickView];
    
    [self p_Autolayout];
    
    [self reloadFullPickView];
}

- (void)reloadFullPickView{
    [self.fullPickView selectRow:self.currentYear-self.startYear inComponent:0 animated:true];
    [self.fullPickView selectRow:self.currentMonth-1 inComponent:1 animated:true];
    [self.fullPickView reloadAllComponents];
}
#pragma mark - private
//时间处理
- (NSDateComponents *)p_DefaultTimeTrocessing:(NSDate *)date{
    //获取当前时间
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar0 components:unitFlags fromDate:date];
    return comps;
}

- (void)p_Autolayout{
    [self.fullPickView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.fullPickView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.fullPickView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.fullPickView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
}





#pragma mark - UIPickerViewDataSource && UIPickerViewDelegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return self.yearRange;
        }
            break;
        case 1:
        {
            return 12;
        }
            break;
            
        default:
            break;
    }
    return 0;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label
    = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth*component/6.0, 0,ScreenWidth/6.0, 30)];
    label.font = kRegular(16);
    label.tag = component * 100 + row;
    label.textAlignment = NSTextAlignmentCenter;
    
    switch (component) {
        case 0:
        {
            label.frame=CGRectMake(5, 0,ScreenWidth/3.0, 30);
            label.text=[NSString stringWithFormat:SLLocalizedString(@"%ld年"),(long)(self.startYear + row)];
            if (row > self.currentYear-self.startYear){//以后年
                label.textColor = [UIColor lightGrayColor];
            }else {
                label.textColor = [UIColor blackColor];
            }
            [label setTextAlignment:NSTextAlignmentRight];
        }
            break;
        case 1:
        {
            label.frame=CGRectMake(ScreenWidth/3.0, 0, ScreenWidth/4.0, 30);
            label.text=[NSString stringWithFormat:SLLocalizedString(@"%ld月"),(long)row+1];
            if (self.selectedYear > self.currentYear) {//以后年
               label.textColor = [UIColor lightGrayColor];
            }else if (self.selectedYear == self.currentYear){// 现在年
                if (row > self.currentMonth-1) {//以后月
                    label.textColor = [UIColor lightGrayColor];
                }else {
                    label.textColor = [UIColor blackColor];
                }
            }else {//以前年
                   label.textColor = [UIColor blackColor];
            }
            [label setTextAlignment:NSTextAlignmentLeft];
            
        }
            break;

        default:
            break;
    }
    return label;
}
// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            self.selectedYear = self.startYear + row;
            [self.fullPickView reloadComponent:1];
            if (self.selectedYear >self.currentYear){//选择的是以后年份和当前年份时
                self.selectedYear = self.currentYear;
                self.selectedMonth = self.currentMonth;
                [self.fullPickView selectRow:self.currentYear - self.startYear inComponent:0 animated:true];
                [self.fullPickView selectRow:self.currentMonth-1 inComponent:1 animated:true];
            }
             [self.fullPickView reloadComponent:1];
        }
            break;
        case 1:
        {
            self.selectedMonth=row+1;
            if (self.selectedYear == self.currentYear){
                if (self.selectedMonth > self.currentMonth){
                    self.selectedMonth = self.currentMonth;
                    [self.fullPickView selectRow:self.currentMonth-1 inComponent:1 animated:true];
                }
            }
            [self.fullPickView reloadComponent:1];
        }
            break;
        
        default:
            break;
    }
    if (self.didFinishGCPickTimeView){
        NSString *string = [NSString stringWithFormat:@"%ld-%.2ld",(long)self.selectedYear,(long)self.selectedMonth];
        self.didFinishGCPickTimeView(string);
    }
}




#pragma mark - getter / setter

- (void)setCurrentTimeString:(NSString *)currentTimeString {
    NSArray *array = [currentTimeString componentsSeparatedByString:@"-"];
    if (array.count == 2){
        NSInteger year = [[array firstObject] integerValue];
        NSInteger month = [[array lastObject] integerValue];
        self.selectedYear = year;
        self.selectedMonth = month;
        
//        self.currentYear = year;//当前年
//        self.currentMonth = month;//当前月
       NSInteger row = self.yearRange - (self.currentYear - self.selectedYear);
        
        [self.fullPickView selectRow:row-1 inComponent:0 animated:true];
        [self.fullPickView selectRow:self.selectedMonth - 1 inComponent:1 animated:true];
        [self.fullPickView reloadAllComponents];
        
//        [self reloadFullPickView];
    }
}

- (NSString *)getTimeString {
    NSString *string = [NSString stringWithFormat:@"%ld-%.2ld",(long)self.selectedYear,(long)self.selectedMonth];
    return string;
}

- (UIPickerView *)fullPickView{
    if (_fullPickView == nil) {
        _fullPickView = [UIPickerView newAutoLayoutView];
        [_fullPickView setDelegate:self];
        [_fullPickView setDataSource:self];
        _fullPickView.autoresizingMask =UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _fullPickView.showsSelectionIndicator = YES;
    }
    return _fullPickView;
}

@end
