//
//  SLRiteFilterView.m
//  Shaolin
//
//  Created by ws on 2020/7/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLRiteFilterView.h"
#import "SLRiteFilterTypeCell.h"

#define SLDateRangeViewHeight 168

static NSString * const typeCellId = @"SLRiteFilterTypeCell";

@interface SLRiteFilterView() <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bgClearView;
@property (nonatomic, strong) UIView *bgWhiteView;
@property (nonatomic, strong) UIView *bgBlackView;

@property (nonatomic, strong) UITableView *typeTable;

@property (nonatomic, strong) NSArray *typeList;


@end

@implementation SLRiteFilterView

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
    
    [self.bgWhiteView addSubview:self.typeTable];

    self.hidden = YES;
}

#pragma mark - method

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if ([self.typeTable.layer containsPoint:point]) {
//        return self.typeTable;
//    }
//
//    return self.bgClearView;
//}

-(void)tap:(UIGestureRecognizer *)gestureRecognizer{
//    CGPoint point = [gestureRecognizer locationInView:self];
//    if (![self.typeTable.layer containsPoint:point]) {
        [self dismiss];
//    }
//    if(self.click) self.click(point);
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqual:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}



-(void)showWithPickerOrigin:(CGPoint)origin {
    
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.bgClearView.frame = self.bounds;
    self.bgBlackView.frame = CGRectMake(origin.x, origin.y + 10, self.width, kScreenHeight - origin.y);
    self.bgWhiteView.frame = CGRectMake(origin.x, origin.y, self.width, 0);
    self.typeTable.frame = CGRectMake(0, 0, self.width, 0);
    [self.typeTable reloadData];
    
    [[self rootWindow] addSubview:self];
    
    self.hidden = NO;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.bgBlackView.alpha = 0.6;
        self.bgWhiteView.frame = CGRectMake(origin.x, origin.y, self.width, SLDateRangeViewHeight);
        self.typeTable.frame = CGRectMake(0, 0, self.width, 152);
    }];
    
}

-(void)dismiss {
    
    [UIView animateWithDuration:0.1 animations:^{
        self.bgBlackView.alpha = 0.0;
        self.bgWhiteView.height = 0.0;
        self.typeTable.height = 0.0;
    } completion:^(BOOL finished) {
        if (finished) self.hidden = YES;
    }];
}

#pragma mark - delegate && datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLRiteFilterTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:typeCellId];
    
    NSArray * list = @[@"全部",@"近期",@"往期"];
    cell.typeLabel.text = list[indexPath.row];
    
    if ([cell.typeLabel.text isEqualToString:self.typeName]) {
        cell.typeLabel.textColor = WENGEN_RED;
        cell.typeLabel.font = kMediumFont(16);
        cell.chooseIcon.hidden = NO;
    } else {
        cell.typeLabel.textColor = [UIColor hexColor:@"333333"];
        cell.typeLabel.font = kRegular(16);
        cell.chooseIcon.hidden = YES;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * list = @[@"全部",@"近期",@"往期"];
    NSString * typeName = list[indexPath.row];
    self.typeName = typeName;
    if (self.typeFilterHandle) {
        self.typeFilterHandle(typeName);
        [self dismiss];
    };
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .001;
}

#pragma mark - getter
- (UITableView *)typeTable {
    if (!_typeTable) {
        _typeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) style:UITableViewStylePlain];
        _typeTable.dataSource = self;
        _typeTable.delegate = self;
        _typeTable.showsVerticalScrollIndicator = NO;
        _typeTable.showsHorizontalScrollIndicator = NO;
        _typeTable.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
        _typeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _typeTable.separatorColor = [UIColor hexColor:@"e5e5e5"];
//        _typeTable.layer.cornerRadius = 4.0f;
        _typeTable.bounces = NO;
        _typeTable.userInteractionEnabled = YES;
        
        [_typeTable registerNib:[UINib nibWithNibName:NSStringFromClass([SLRiteFilterTypeCell class]) bundle:nil] forCellReuseIdentifier:typeCellId];
        
    }
    return _typeTable;
}

-(UIView *)bgWhiteView {
    if (!_bgWhiteView) {
        _bgWhiteView = [UIView new];
        _bgWhiteView.backgroundColor = UIColor.whiteColor;
        
        CGRect bounds = CGRectMake(0, 0, ScreenWidth, SLDateRangeViewHeight);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = bounds;
        maskLayer.path = maskPath.CGPath;
        [_bgWhiteView.layer addSublayer:maskLayer];
        _bgWhiteView.layer.mask = maskLayer;
        _bgWhiteView.layer.masksToBounds = YES;
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
