//
//  SLDateRangeView.m
//  Shaolin
//
//  Created by ws on 2020/7/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLDateRangeView.h"
#import "PGPickerView.h"

#define SLDateRangeViewHeight 208

@interface SLDateRangeView() <PGPickerViewDelegate, PGPickerViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bgClearView;
@property (nonatomic, strong) UIView *bgWhiteView;
@property (nonatomic, strong) UIView *bgBlackView;
@property (nonatomic, strong) PGPickerView *pickerView;
@property (nonatomic, strong) UILabel *centerLineLabel;
@property (nonatomic, strong) UIButton *chooseBtn;

//@property (nonatomic, strong) NSArray *startYears;
@property (nonatomic, strong) NSArray *startMonths;
//@property (nonatomic, strong) NSArray *endYears;
@property (nonatomic, strong) NSArray *endMonths;


@property (nonatomic, assign) NSInteger startYearRow;
@property (nonatomic, assign) NSInteger startMonthRow;
@property (nonatomic, assign) NSInteger endYearRow;
@property (nonatomic, assign) NSInteger endMonthRow;

@end

@implementation SLDateRangeView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void) initUI {
    [self addSubview:self.bgClearView];
    
    [self.bgClearView addSubview:self.bgBlackView];
    [self.bgClearView addSubview:self.bgWhiteView];
    
    [self.bgWhiteView addSubview:self.pickerView];
    [self.bgWhiteView addSubview:self.chooseBtn];
    [self.bgWhiteView addSubview:self.centerLineLabel];
    
//    self.bgWhiteView.height = 0.0;
//    self.pickerView.height = 0.0;
//    self.centerLineLabel.height = 0.0;
    self.hidden = YES;
}

#pragma mark - method

-(void)chooseTime {
    if (self.finishBlock) {
        
        self.startYear = self.startYears[self.startYearRow];
        self.startMonth = self.startMonths[self.startMonthRow];
        self.endYear = self.endYears[self.endYearRow];
        self.endMonth = self.endMonths[self.endMonthRow];
        
        self.finishBlock(self.startYear, self.startMonth, self.endYear, self.endMonth);
        
        [self dismiss];
    }
}

-(void)tap:(UIGestureRecognizer *)gestureRecognizer{
//    CGPoint point = [gestureRecognizer locationInView:self];
//    if(self.click) self.click(point);
    [self dismiss];
//    if (self.finishBlock) {
//
//        self.startYear = self.startYears[self.startYearRow];
//        self.startMonth = self.startMonths[self.startMonthRow];
//        self.endYear = self.endYears[self.endYearRow];
//        self.endMonth = self.endMonths[self.endMonthRow];
//
//        self.finishBlock(self.startYear, self.startMonth, self.endYear, self.endMonth);
//
//        [self dismiss];
//    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)showWithPickerOrigin:(CGPoint)origin
                  startYear:(NSString *)startYear
                 startMonth:(NSString *)startMonth
                    endYear:(NSString *)endYear
                   endMonth:(NSString *)endMonth {
    
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.bgClearView.frame = self.bounds;
    self.bgBlackView.frame = CGRectMake(origin.x, origin.y + 10, self.width, kScreenHeight - origin.y);
    self.bgWhiteView.frame = CGRectMake(origin.x, origin.y, self.width, 0);
    self.pickerView.frame = CGRectMake(0, 0, self.width, 0);
    self.chooseBtn.frame = CGRectMake(0, 158, self.width, 50);
    self.centerLineLabel.frame = CGRectMake(kScreenWidth/2 - 8, (76 - 5), 16, 10);

    // 如果调换过的话，要滚动到新位置
    if (![startYear isEqualToString:self.startYear]) {
        if ([self.startYears indexOfObject:startYear] != NSNotFound) {
            NSInteger index =[self.startYears indexOfObject:startYear];
            self.startYear = startYear;
            [self.pickerView selectRow:index inComponent:0 animated:NO];
        }
    }
    
    if (![startMonth isEqualToString:self.startMonth]) {
        if ([self.startMonths indexOfObject:startMonth] != NSNotFound) {
            NSInteger index =[self.startMonths indexOfObject:startMonth] ;
            [self.pickerView selectRow:index inComponent:1 animated:NO];
        }
    }
    
    if (![endYear isEqualToString:self.endYear]) {
        if ([self.endYears indexOfObject:endYear] != NSNotFound) {
            NSInteger index =[self.endYears indexOfObject:endYear] ;
            [self.pickerView selectRow:index inComponent:2 animated:NO];
        }
    }
    
    if (![endMonth isEqualToString:self.endMonth]) {
        if ([self.endMonths indexOfObject:endMonth] != NSNotFound) {
            NSInteger index =[self.endMonths indexOfObject:endMonth] ;
            [self.pickerView selectRow:index inComponent:3 animated:NO];
        }
    }
    
    
    [[self rootWindow] addSubview:self];
    
    self.hidden = NO;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.bgBlackView.alpha = 0.6;
        self.bgWhiteView.frame = CGRectMake(origin.x, origin.y, self.width, SLDateRangeViewHeight);
        self.pickerView.frame = CGRectMake(0, 0, self.width, 158);
//        self.chooseBtn.frame = CGRectMake(0, 158, self.width, 50);
        self.chooseBtn.alpha = 1;
    }];
}


-(void)dismiss {
    
    [UIView animateWithDuration:0.1 animations:^{
        self.bgBlackView.alpha = 0.0;
        self.chooseBtn.alpha = 0.0;
        self.bgWhiteView.height = 0.0;
        self.pickerView.height = 0.0;
    } completion:^(BOOL finished) {
        if (finished) self.hidden = YES;
    }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(PGPickerView *)pickerView {
    return 4;
}

- (NSInteger)pickerView:(PGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.startYears.count;
    }
    if (component == 1) {
        return self.startMonths.count;
    }
    if (component == 2) {
        return self.endYears.count;
    }
    
    return self.endMonths.count;
}
#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(PGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [NSString stringWithFormat:@"%@年",self.startYears[row]];
    }
    if (component == 1) {
        return [NSString stringWithFormat:@"%@月",self.startMonths[row]];
    }
    if (component == 2) {
        return [NSString stringWithFormat:@"%@年",self.endYears[row]];
    }
    
    return [NSString stringWithFormat:@"%@月",self.endMonths[row]];
}

- (void)pickerView:(PGPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"row = %ld component = %ld", row, component);
    if (component == 0) {
        self.startYearRow = row;
    } else if (component == 1) {
        self.startMonthRow = row;
    } else if (component == 2) {
        self.endYearRow = row;
    } else if (component == 3) {
        self.endMonthRow = row;
    }
    
    self.startYear = self.startYears[self.startYearRow];
    self.startMonth = self.startMonths[self.startMonthRow];
    self.endYear = self.endYears[self.endYearRow];
    self.endMonth = self.endMonths[self.endMonthRow];
    
//    if (self.changeBlock) {
//        self.changeBlock(self.startYear, self.startMonth, self.endYear, self.endMonth);
//    }
}


#pragma mark - getter
-(PGPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[PGPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.type = PGPickerViewLineTypelineSegment;
        
        _pickerView.rowHeight = 50;
//        _pickerView.isHiddenMiddleText = false;
        _pickerView.lineBackgroundColor = [UIColor hexColor:@"EEEEEE"];
        _pickerView.textColorOfSelectedRow = kMainYellow;
        _pickerView.textColorOfOtherRow = [UIColor hexColor:@"333333"];
        
        _pickerView.textFontOfSelectedRow = kMediumFont(16);
        _pickerView.textFontOfOtherRow = kRegular(16);
    }
    return _pickerView;
}

-(UILabel *)centerLineLabel {
    if (!_centerLineLabel) {
        _centerLineLabel = [UILabel new];
        _centerLineLabel.textColor = kMainYellow;
        _centerLineLabel.font = kMediumFont(16);
        _centerLineLabel.text = @"-";
    }
    return _centerLineLabel;
}

-(UIView *)bgWhiteView {
    if (!_bgWhiteView) {
        _bgWhiteView = [UIView new];
        _bgWhiteView.backgroundColor = UIColor.whiteColor;
        
//        CGRect bounds = CGRectMake(0, 0, ScreenWidth, SLDateRangeViewHeight);
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = bounds;
//        maskLayer.path = maskPath.CGPath;
//        [_bgWhiteView.layer addSublayer:maskLayer];
//        _bgWhiteView.layer.mask = maskLayer;
//        _bgWhiteView.layer.masksToBounds = YES;
    }
    return _bgWhiteView;
}

-(UIView *)bgBlackView {
    if (!_bgBlackView) {
        _bgBlackView = [UIView new];
        _bgBlackView.backgroundColor = UIColor.blackColor;
        _bgBlackView.alpha = 0.0;
    }
    return _bgBlackView;;
}

-(UIView *)bgClearView {
    if (!_bgClearView) {
        _bgClearView = [UIView new];
        _bgClearView.backgroundColor = UIColor.clearColor;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapGesture.delegate = self;
        [_bgClearView addGestureRecognizer:tapGesture];
    }
    return _bgClearView;;
}

//当前时间的时间戳
-(long int)cNowTimestamp{
    NSDate *newDate = [NSDate date];
    long int timeSp = (long)[newDate timeIntervalSince1970];
    return timeSp;
}

//时间戳——字符串时间
-(NSString *)cStringFromTimestamp:(NSString *)timestamp{
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

//当前月份
-(NSString *)cMontFromTimestamp:(NSString *)timestamp{
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

//年份范围
-(NSMutableArray *)yearArrayAction{
    NSString *yearStr = [self cStringFromTimestamp:[NSString stringWithFormat:@"%ld",[self cNowTimestamp]]];
    NSInteger endYearInt = [yearStr integerValue];
    NSMutableArray *tempArry = [[NSMutableArray alloc] init];
    for (int i = 1979; i <= endYearInt ; i ++) {
        [tempArry addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return tempArry;
}

-(NSArray *)startYears {
    if (!_startYears) {
        _startYears = [self yearArrayAction];
    }
    return _startYears;
}

-(NSArray *)startMonths {
    if (!_startMonths) {
        _startMonths = [self months];
    }
    return _startMonths;
}

-(NSArray *)endYears {
    if (!_endYears) {
        _endYears = [self yearArrayAction];
    }
    return _endYears;
}

-(NSArray *)endMonths {
    if (!_endMonths) {
        _endMonths = [self months];
    }
    return _endMonths;
}

-(UIButton *)chooseBtn {
    if (!_chooseBtn) {
        _chooseBtn = [UIButton new];
        [_chooseBtn setTitle:@"确定" forState:UIControlStateNormal];
        _chooseBtn.backgroundColor = kMainYellow;
        _chooseBtn.titleLabel.font = kRegular(16);
        _chooseBtn.alpha = 0.0;
        [_chooseBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_chooseBtn addTarget:self action:@selector(chooseTime) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn;
}

-(NSArray *)months {
    return @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
}

- (UIWindow *)rootWindow {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
    return nil;
}

@end
