//
//  KungfuSignViewController.m
//  Shaolin
//
//  Created by syqaxldy on 2020/4/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuSignViewController.h"
#import "SDCycleScrollView.h"
#import "KungfuApplyCheckListViewController.h"
#import "WengenBannerModel.h"
#import "NSString+Tool.h"
#import "DataManager.h"

#define ALPHANUM_KungfuSignViewController @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface KungfuSignViewController ()<SDCycleScrollViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong) SDCycleScrollView *sdcScrollView;
//@property (nonatomic, copy) NSArray *imagesURLs;
//@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UITextField *textField;
@property (nonatomic, strong) NSArray * bannerList;
@end

@implementation KungfuSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//     [self.view addSubview:self.scrollView];
//     [self.scrollView addSubview:self.sdcScrollView];
    
    [self.view addSubview:self.sdcScrollView];
    [self setupUI];
    [self requestBanner];
}
- (void)setupUI {
    UILabel *lookLabel = [[UILabel alloc]init];
    lookLabel.text = SLLocalizedString(@"查询帮助");
    lookLabel.textColor = kMainYellow;
    lookLabel.font = kRegular(16);
    lookLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lookLabel];
    [lookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(SLChange(22));
        make.top.mas_equalTo(self.sdcScrollView.mas_bottom).offset(SLChange(56));
    }];
    
    UILabel *alertLabel = [[UILabel alloc]init];
    alertLabel.text = SLLocalizedString(@"输入身份证或准考证号就可查询信息\n*确保输入的信息正确");
    alertLabel.font = kRegular(14);
    alertLabel.numberOfLines = 0;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.textColor = [UIColor colorForHex:@"909090"];
    [self.view addSubview:alertLabel];
    [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(kWidth);
           make.centerX.mas_equalTo(self.view);
           make.height.mas_equalTo(SLChange(48));
           make.top.mas_equalTo(lookLabel.mas_bottom).offset(SLChange(32));
       }];
    
    UIImageView *textBgView = [[UIImageView alloc]init];
    textBgView.image = [UIImage imageNamed:@"sign_bgView"];
    textBgView.userInteractionEnabled = YES;
    [self.view addSubview:textBgView];
    [textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(31));
        make.width.mas_equalTo(kWidth - SLChange(62));
        make.height.mas_equalTo(SLChange(53));
        make.top.mas_equalTo(alertLabel.mas_bottom).offset(SLChange(22));
    }];
    [textBgView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(22));
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(SLChange(53));
        make.width.mas_equalTo(kWidth - SLChange(131) );
    }];
    
    UIButton *searchBtn = [[UIButton alloc]init];
    [searchBtn setImage:[UIImage imageNamed:@"sign_search"] forState:(UIControlStateNormal)];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:(UIControlEventTouchUpInside)];
    [textBgView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SLChange(25));
        make.centerY.mas_equalTo(textBgView);
        make.right.mas_equalTo(textBgView.mas_right).offset(-SLChange(22));
    }];
}

- (void)requestBanner {
    [[DataManager shareInstance]getBanner:@{@"module":@"2", @"fieldId":@"4"} Callback:^(NSArray *result) {
            
        self.bannerList = [NSArray arrayWithArray:result];
        
        NSMutableArray *temList = [NSMutableArray array];
        for (WengenBannerModel *banner in self.bannerList) {
            [temList addObject:banner.imgUrl];
        }
        
        self.sdcScrollView.imageURLStringsGroup = temList;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    WengenBannerModel *banner = self.bannerList[index];
    // banner事件
    [[SLAppInfoModel sharedInstance] bannerEventResponseWithBannerModel:banner];
}

#pragma mark - textField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([NSString isContainsEmoji:string]) {
        return NO;
    }
    
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM_KungfuSignViewController] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}
#pragma mark - 搜索报名信息
- (void)searchAction {
    if (self.textField.text.length == 0) {
        return;
    }
    
    KungfuApplyCheckListViewController * vc = [KungfuApplyCheckListViewController new];
    vc.searchText = self.textField.text;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
       
        _textField.textColor = KTextGray_333;
        _textField.secureTextEntry = NO;
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        if (@available(iOS 13.0, *)) {
                _textField.textContentType = UITextContentTypeOneTimeCode;
        }
       
        _textField.font = kRegular(14);
        _textField.delegate = self;
              
    }
    return _textField;
}
//- (UIScrollView *)scrollView {
//    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
//        _scrollView.delegate = self;
//        _scrollView.contentSize = CGSizeMake(kWidth, kHeight);
//    }
//    return _scrollView;
//}
- (SDCycleScrollView *)sdcScrollView {
    if (!_sdcScrollView) {
        _sdcScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(SLChange(16), SLChange(12), kWidth-SLChange(32), SLChange(130)) delegate:self placeholderImage:[UIImage imageNamed:@"default_banner"]];
        _sdcScrollView.delegate = self;
        _sdcScrollView.layer.cornerRadius =4;
        _sdcScrollView.layer.masksToBounds = YES;
        _sdcScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _sdcScrollView;
}
#pragma mark - Getter and Setter

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
