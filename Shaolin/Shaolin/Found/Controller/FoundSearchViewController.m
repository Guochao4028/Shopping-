//
//  FoundSearchViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "FoundSearchViewController.h"
#import "NSString+Tool.h"

@interface FoundSearchViewController ()<UITextFieldDelegate>
@property(nonatomic,strong) UITextField *textField;
@end

@implementation FoundSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    
}
-(void)setupUI
{
      self.navigationController.navigationBar.hidden =YES;
    
   
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    view.userInteractionEnabled = YES;
    view.layer.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = SLChange(15);
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(56));
         make.width.mas_equalTo(SLChange(300));
        make.top.mas_equalTo(StatueBar_Height+SLChange(7));
        make.height.mas_equalTo(SLChange(30));
    }];
     UIButton *leftBtn = [[UIButton alloc]init];
               
    [leftBtn setImage:[UIImage imageNamed:@"left"] forState:(UIControlStateNormal)];
           //    [self.left setTitle:@"" forState:(UIControlStateNormal)];
           //    self.left.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    //           leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 45);
    [leftBtn addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:leftBtn];
        
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.mas_equalTo(SLChange(16));
                make.width.mas_equalTo(SLChange(15));
               make.centerY.mas_equalTo(view);
               make.height.mas_equalTo(SLChange(22));
           }];
    UIButton *searchBtn = [[UIButton alloc]init];
    [view addSubview:searchBtn];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:(UIControlStateNormal)];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.size.mas_equalTo(SLChange(12.5));
           make.left.mas_equalTo(SLChange(16));
           make.centerY.mas_equalTo(view);
       }];
    
    [view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(searchBtn.mas_right).offset(SLChange(14));
        make.centerY.mas_equalTo(view);
        make.width.mas_equalTo(SLChange(200));
        make.height.mas_equalTo(SLChange(16.5));
    }];
    
    UIButton *search = [[UIButton alloc]init];
    [view addSubview:search];
    [search addTarget:self action:@selector(searchAction) forControlEvents:(UIControlEventTouchUpInside)];
    search.titleLabel.font = kRegular(12);
    [search setTitleColor:[UIColor colorForHex:@"333333"] forState:(UIControlStateNormal)];
    [search setTitle:SLLocalizedString(@"搜索") forState:(UIControlStateNormal)];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(24));
        make.right.mas_equalTo(view.mas_right).offset(-SLChange(16));
         make.centerY.mas_equalTo(view);
        make.height.mas_equalTo(SLChange(16.5));
    }];
    
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor colorForHex:@"DDDDDD"];
    [view addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.mas_equalTo(search.mas_left).offset(-SLChange(13.5));
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(SLChange(11.5));
         make.centerY.mas_equalTo(view);
    }];
    UIView *v1 = [[UIView alloc]init];
       v1.backgroundColor = RGBA(237, 237, 237, 1);
       [self.view addSubview:v1];
       [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.mas_equalTo(0);
           make.right.mas_equalTo(0);
           make.height.mas_equalTo(1);
            make.top.mas_equalTo(view.mas_bottom).offset(SLChange(7));
       }];
}
-(void)leftAction
{
    
   
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([NSString isContainsEmoji:string]) {
        return NO;
    }
    return YES;
}

-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];

               [_textField setTextColor:[UIColor blackColor]];
               _textField.font = kMediumFont(12);
              
               _textField.leftViewMode = UITextFieldViewModeAlways;
               _textField.placeholder = SLLocalizedString(@"输入要搜索的内容");
               _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
               _textField.returnKeyType = UIReturnKeySearch;
               _textField.delegate = self;
                [_textField setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
              [_textField setValue:kRegular(12) forKeyPath:@"placeholderLabel.font"];
    }
    return _textField;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
