//
//  SearchViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SearchViewController.h"

#import "SearchNavgationView.h"

#import "WengenSearchResultViewController.h"

#import "SMAlert.h"

@interface SearchViewController ()<SearchNavgationViewDelegate>

@property(nonatomic, strong)SearchNavgationView *navgationView;

@property (nonatomic, strong) UIView *searchHistoryView;

@property (nonatomic, strong) NSMutableArray *historyArray;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    
     [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.historyArray = nil;
    
    [self.searchHistoryView removeFromSuperview];
       self.searchHistoryView = [self setViewWithOriginY:CGRectGetMaxY(self.navgationView.frame) title:SLLocalizedString(@"搜索历史") textArr:self.historyArray];
       [self.view addSubview:self.searchHistoryView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navgationView becomeFirstResponder];
}



-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.navgationView];
    [self.view addSubview:self.searchHistoryView];
}

- (UIView *)setViewWithOriginY:(CGFloat)riginY title:(NSString *)title textArr:(NSMutableArray *)textArr {
    UIView *view = [[UIView alloc] init];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(15), SLChange(11), SLChange(16))];
    if (textArr.count == 0) {
         image.image = [UIImage imageNamed:@""];
    }else {
         image.image = [UIImage imageNamed:@"rot_search"];
    }
    
    [view addSubview:image];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(SLChange(35), SLChange(15), kWidth - SLChange(95), SLChange(16))];
    titleL.text = title;
    titleL.font = [UIFont systemFontOfSize:16];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleL];
    
    if ([title isEqualToString:SLLocalizedString(@"搜索历史")]) {
        image.frame = CGRectMake(SLChange(11), SLChange(15), SLChange(16), SLChange(16));
         image.image = [UIImage imageNamed:@"history_search"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kWidth - 45, 10, 28, 30);
        [btn setImage:[UIImage imageNamed:@"sort_recycle"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearnSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    CGFloat y = SLChange(15) + SLChange(40);
    CGFloat letfWidth = SLChange(15);
    for (int i = 0; i < textArr.count; i++) {
        NSString *text = [self subTextString:textArr[i] len:6];
        CGFloat width = [self getWidthWithStr:text] + SLChange(35);
        if (letfWidth + width + SLChange(15) > kWidth) {
            if (y >= SLChange(130) && [title isEqualToString:SLLocalizedString(@"搜索历史")]) {
                [self removeTestDataWithTextArr:textArr index:i];
                break;
            }
            y += SLChange(40);
            letfWidth = SLChange(15);
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(letfWidth, y, width, SLChange(35))];
        label.userInteractionEnabled = YES;
        label.font = [UIFont systemFontOfSize:15];
        label.text = text;
        label.backgroundColor = RGBA(243, 243, 243, 1);
        label.layer.cornerRadius = SLChange(35)/2;
        label.layer.borderWidth = 1;
        label.layer.borderColor = RGBA(243, 243, 243, 1).CGColor;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorForHex:@"333333"];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTag:)]];
        [view addSubview:label];
        letfWidth += width + SLChange(10);
    }
    view.frame = CGRectMake(0, riginY, kWidth, y + SLChange(40));
    return view;
}

- (void)tapTag:(UITapGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;
//    label.text
    
    WengenSearchResultViewController *resultVC = [[WengenSearchResultViewController alloc]init];
       resultVC.storeId = self.storeId;
       resultVC.searchStr = label.text;
       [self.navigationController pushViewController:resultVC animated:YES];
}

- (void)clearnSearchHistory:(UIButton *)sender{
    
    [self.navgationView resignFirstResponder];
    
    [SMAlert setConfirmBtBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:kMediumFont(15)];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"确定删除全部历史记录？");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        
        [self.searchHistoryView removeFromSuperview];
        self.searchHistoryView = [self setNoHistoryView];
        [self.historyArray removeAllObjects];
        [NSKeyedArchiver archiveRootObject:self.historyArray toFile:KGoodsHistorySearchPath];
        [self.view addSubview:self.searchHistoryView];
       
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
   
}

- (CGFloat)getWidthWithStr:(NSString *)text{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(kWidth, SLChange(40)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.width;
    if (width > 73.6) {
        width = 83;
        return width;
    }else {
        return width;
    }
    
}

- (void)removeTestDataWithTextArr:(NSMutableArray *)testArr index:(int)index
{
    NSRange range = {index, testArr.count - index - 1};
    [testArr removeObjectsInRange:range];
    [NSKeyedArchiver archiveRootObject:testArr toFile:KGoodsHistorySearchPath];
}

-(NSString*)subTextString:(NSString*)str len:(NSInteger)len{
    if(str.length<=len)return str;
    int count=0;
    NSMutableString *sb = [NSMutableString string];
    
    for (int i=0; i<str.length; i++) {
        NSRange range = NSMakeRange(i, 1) ;
        NSString *aStr = [str substringWithRange:range];
        count += [aStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>1?2:1;
        [sb appendString:aStr];
        if(count >= len*2) {
            return (i==str.length-1)?[sb copy]:[NSString stringWithFormat:@"%@...",[sb copy]];
            
        }
    }
    return str;
}

- (UIView *)setNoHistoryView {
    UIView *historyView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navgationView.frame), kWidth, SLChange(80))];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SLChange(11), SLChange(10), SLChange(16), SLChange(16))];
    image.image = [UIImage imageNamed:@"history_search"];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(SLChange(35), SLChange(10), kWidth - SLChange(50), SLChange(16))];
    titleL.text = SLLocalizedString(@"搜索历史");
    titleL.font = [UIFont systemFontOfSize:16];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    
    UILabel *notextL = [[UILabel alloc] initWithFrame:CGRectMake(SLChange(35), CGRectGetMaxY(titleL.frame) + SLChange(20), SLChange(100), SLChange(20))];
    notextL.text = SLLocalizedString(@"无搜索历史");
    notextL.font = [UIFont systemFontOfSize:15];
    notextL.textColor = RGBA(113, 113, 113, 1);
    notextL.textAlignment = NSTextAlignmentLeft;
    [historyView addSubview:image];
    [historyView addSubview:titleL];
    [historyView addSubview:notextL];
    return historyView;
}

#pragma mark - SearchNavgationViewDelegate
-(void)tapBack{
    [self.navgationView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchNavgationView:(SearchNavgationView *)navgationView searchWord:(NSString *)text{
    if (text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"搜索内容不能为空") view:self.view afterDelay:TipSeconds];
        return;
    }
    if ([self.historyArray containsObject:text]) {
           [self.historyArray removeObject:text];
       }
    [self.historyArray insertObject:text atIndex:0];
    [NSKeyedArchiver archiveRootObject:self.historyArray toFile:KGoodsHistorySearchPath];
    
    WengenSearchResultViewController *resultVC = [[WengenSearchResultViewController alloc]init];
    resultVC.storeId = self.storeId;
    resultVC.searchStr = text;
    [self.navigationController pushViewController:resultVC animated:YES];
    
    [self.searchHistoryView removeFromSuperview];
    self.searchHistoryView = [self setViewWithOriginY:CGRectGetMaxY(self.navgationView.frame) title:SLLocalizedString(@"搜索历史") textArr:self.historyArray];
    [self.view addSubview:self.searchHistoryView];
    
}


#pragma mark - getter / setter

-(SearchNavgationView *)navgationView{
    
    if (_navgationView == nil) {
        //状态栏高度
        CGFloat barHeight ;
        /** 判断版本
         获取状态栏高度
         */
        if (@available(iOS 13.0, *)) {
            barHeight = [[[[[UIApplication sharedApplication] keyWindow] windowScene] statusBarManager] statusBarFrame].size.height;
        } else {
            barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        }
        _navgationView = [[SearchNavgationView alloc]initWithFrame:CGRectMake(0, barHeight, ScreenWidth, 44)];
        [_navgationView setDelegate:self];
    }
    return _navgationView;

}

- (UIView *)searchHistoryView
{
    if (!_searchHistoryView) {
        if (self.historyArray.count > 0) {
            self.searchHistoryView = [self setViewWithOriginY:CGRectGetMaxY(self.navgationView.frame) title:SLLocalizedString(@"搜索历史") textArr:self.historyArray];
        } else {
            self.searchHistoryView = [self setNoHistoryView];
        }
    }
    return _searchHistoryView;
}

-(NSMutableArray *)historyArray{
    if (!_historyArray) {
           _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KGoodsHistorySearchPath];
           if (!_historyArray) {
               self.historyArray = [NSMutableArray array];
           }
       }
       return _historyArray;
}

@end
