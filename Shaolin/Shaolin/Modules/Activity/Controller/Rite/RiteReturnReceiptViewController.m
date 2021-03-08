//
//  RiteReturnReceiptViewController.m
//  Shaolin
//
//  Created by 王精明 on 2021/2/9.
//  Copyright © 2021 syqaxldy. All rights reserved.
//

#import "RiteReturnReceiptViewController.h"
#import "UIButton+Block.h"
#import "OrderHomePageViewController.h"
#import "UIGestureRecognizer+LGFBlockGestureRecognizer.h"

@interface RiteReturnReceiptViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *successLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *finishButton;
@end

@implementation RiteReturnReceiptViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showNavigationBarShadow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = SLLocalizedString(@"提交成功");
    [self setupUI];
    // Do any additional setup after loading the view.
}

#pragma mark - UI

- (void)setupUI{
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.successLabel];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.finishButton];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(75);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(43, 52));
    }];
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(14);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(24);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.successLabel.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).mas_offset(28.5);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(110, 34));
    }];
    self.finishButton.layer.cornerRadius = 34/2.0;
}

- (void)leftAction {
    [self pushOrderHomePageViewController];
}

- (void)pushOrderHomePageViewController {
    OrderHomePageViewController *orderVC = [[OrderHomePageViewController alloc] init];
    orderVC.disableRightGesture = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

#pragma mark - getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tjcg"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UILabel *)successLabel {
    if (!_successLabel){
        _successLabel = [[UILabel alloc] init];
        _successLabel.font = kRegular(17);
        _successLabel.textColor = KTextGray_333;
        _successLabel.text = SLLocalizedString(@"提交成功");
    }
    return _successLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        NSString *tipStr = SLLocalizedString(@"请联系客堂");
        NSString *phoneStr = @"0371-62745166";
        NSString *string = [NSString stringWithFormat:@"%@\n%@",tipStr, phoneStr];
        NSMutableAttributedString *attstring = [[NSMutableAttributedString alloc] initWithString:string];
        [attstring addAttributes:@{
            NSFontAttributeName: kRegular(13),
            NSForegroundColorAttributeName: KTextGray_666,
        } range:[string rangeOfString:tipStr]];
        
        [attstring addAttributes:@{
            NSFontAttributeName: kRegular(16),
            NSForegroundColorAttributeName: kMainYellow
        } range:[string rangeOfString:phoneStr]];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];//设置距离
        [attstring addAttribute:NSParagraphStyleAttributeName
                            value:paragraphStyle
                            range:NSMakeRange(0, string.length)];
        
        _tipsLabel.attributedText = attstring;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionLGFBlock:^(id  _Nonnull sender) {
            if (phoneStr.length){
                NSString *phone = [NSString stringWithFormat:@"telprompt://%@", phoneStr];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:nil];
            }
        }];
        [_tipsLabel addGestureRecognizer:tap];
    }
    return _tipsLabel;
}

- (UIButton *)finishButton {
    if (!_finishButton){
        _finishButton = [[UIButton alloc] init];
        _finishButton.layer.borderWidth = 0.5;
        _finishButton.layer.borderColor = kMainYellow.CGColor;
        [_finishButton setTitle:SLLocalizedString(@"完成") forState:UIControlStateNormal];
        [_finishButton setTitleColor:kMainYellow forState:UIControlStateNormal];
        _finishButton.clipsToBounds = YES;
        _finishButton.titleLabel.font = kRegular(15);
        WEAKSELF
        [_finishButton handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
            [weakSelf pushOrderHomePageViewController];
        }];
    }
    return _finishButton;
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
