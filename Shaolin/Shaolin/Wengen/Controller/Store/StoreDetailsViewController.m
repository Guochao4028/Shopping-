//
//  StoreDetailsViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreDetailsViewController.h"
#import "TQStarRatingView.h"
#import "GoodsStoreInfoModel.h"
#import "UIImage+ImageDarken.h"

#import "WengenWebViewController.h"
#import "DefinedHost.h"
#import "DataManager.h"

@interface StoreDetailsViewController ()

- (IBAction)backAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *storeHeardBGImageView;

@property (weak, nonatomic) IBOutlet UIView *storeInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *storeHeardImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;

@property (weak, nonatomic) IBOutlet UIView *detailedView;
@property (weak, nonatomic) IBOutlet UILabel *focusNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;

@property (strong, nonatomic) IBOutlet UILabel *starLabel;


@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)focusAction:(UIButton *)sender;

@property(nonatomic, strong)GoodsStoreInfoModel *storeInfoModel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)seeAllGoodsAction:(UIButton *)sender;

- (IBAction)storeInfoAction:(UITapGestureRecognizer *)sender;


@property (weak, nonatomic) IBOutlet UIView *infoBgView;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;


@property (weak, nonatomic) IBOutlet UIImageView *proprietaryImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proprietaryImageViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proprietaryGayW;


@end

@implementation StoreDetailsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBarClearTintColorWhiteStyle];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = SLLocalizedString(@"店铺详情");
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initUI];
}

#pragma mark - methods

-(void)initData{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getStoreInfo:@{@"id":self.storeId} Callback:^(NSObject *object) {
        [hud hideAnimated:YES];
        self.storeInfoModel = (GoodsStoreInfoModel *)object;
        
        BOOL is_self = [self.storeInfoModel.is_self boolValue];
        if (is_self) {
            [self.proprietaryImageView setHidden:NO];
            self.proprietaryImageViewW.constant = 35;
            self.proprietaryGayW.constant = 5;
        }else{
            [self.proprietaryImageView setHidden:YES];
            self.proprietaryImageViewW.constant = 0;
            self.proprietaryGayW.constant = 0;
        }
    }];
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor colorForHex:@"FAFAFA"]];
    
    
    
    self.starLabel.text = @"0";
    
    [self cornerRadius:self.storeInfoView radius:4];
//    [self cornerRadius:self.detailedView radius:4];
    [self cornerRadius:self.focusButton radius:15];
    [self cornerRadius:self.storeHeardImageView radius:7.5];
    [self cornerRadius:self.infoBgView radius:4];
    
    [self setShadowWithView:self.infoBgView];
    [self setShadowWithView:self.lookBtn];
    
    if (@available(iOS 11.0, *)){
               self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
           }else{
               self.automaticallyAdjustsScrollViewInsets = NO;
           }
    
    if (self.isCollect == YES) {
           [self.focusButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
           self.focusButton.layer.borderColor = [UIColor colorForHex:@"999999"].CGColor;
           self.focusButton.layer.borderWidth = 1;
           [self.focusButton setBackgroundColor:[UIColor clearColor]];
           self.focusButton.layer.cornerRadius = SLChange(15);
           [self.focusButton setTitle:SLLocalizedString(@"已关注") forState:UIControlStateNormal];
           [self.focusButton setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
       }else{
          [self.focusButton setImage:[UIImage imageNamed:@"baiGuanzhu"] forState:UIControlStateNormal];
           [self.focusButton setTitle:SLLocalizedString(@"关注") forState:UIControlStateNormal];
           [self.focusButton setBackgroundColor:[UIColor colorForHex:@"BE0B1F"]];
           self.focusButton.layer.borderColor = [UIColor colorForHex:@"BE0B1F"].CGColor;
           self.focusButton.layer.borderWidth = 1;
           self.focusButton.layer.cornerRadius = SLChange(15);
           [self.focusButton setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:UIControlStateNormal];
       }
    
    
}

-(void)cornerRadius:(UIView *)view radius:(CGFloat)cout{
    view.layer.cornerRadius = SLChange(cout);
    view.layer.masksToBounds = YES;
}

- (void) setShadowWithView:(UIView *)view {
    view.layer.shadowColor = [UIColor hexColor:@"939393"].CGColor;
    
    view.layer.shadowOffset = CGSizeZero;
    view.layer.shadowOpacity = 0.3f;
    view.layer.masksToBounds = NO;
}

#pragma mark - action

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)seeAllGoodsAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)storeInfoAction:(UITapGestureRecognizer *)sender {
    

    
     SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
    
    NSString *urlStr = URL_H5_ShopInfo(self.storeId, appInfoModel.access_token);
    
    WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:SLLocalizedString(@"证照信息")];
    webVC.navigationBarStyle = NavigationBarClearTintColor_blackStyle;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)focusAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        //关注
        [[DataManager shareInstance]addCollect:@{@"club_id":self.storeId} Callback:^(Message *message) {
            if (message.isSuccess == YES) {
                [sender setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                sender.layer.borderColor = [UIColor colorForHex:@"999999"].CGColor;
                [sender setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];

                [sender setTitle:SLLocalizedString(@"已关注") forState:UIControlStateNormal];
                sender.layer.borderWidth = 1;
                [sender setBackgroundColor:[UIColor clearColor]];
                sender.layer.cornerRadius = SLChange(15);
            }
        }];
        
    }else{
        //取消关注
        [[DataManager shareInstance]cancelCollect:@{@"club_id":self.storeId} Callback:^(Message *message) {
            if (message.isSuccess == YES) {
                [sender setImage:[UIImage imageNamed:@"baiGuanzhu"] forState:UIControlStateNormal];
                [sender setTitle:SLLocalizedString(@"关注") forState:UIControlStateNormal];
                [sender setBackgroundColor:[UIColor colorForHex:@"BE0B1F"]];
                sender.layer.borderColor = [UIColor colorForHex:@"BE0B1F"].CGColor;
                sender.layer.borderWidth = 1;
                sender.layer.cornerRadius = SLChange(15);
                [sender setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:UIControlStateNormal];
            }
        }];
    }
}

#pragma mark - getter / setter
-(void)setStoreInfoModel:(GoodsStoreInfoModel *)storeInfoModel{
    _storeInfoModel = storeInfoModel;
    
    NSString *logo = storeInfoModel.logo;
    
    [self.storeHeardBGImageView sd_setImageWithURL:[NSURL URLWithString:logo] placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    UIImage *sourceImage = [self.storeHeardBGImageView image];
    
    [self.storeHeardBGImageView setImage:[sourceImage imageDarkenWithLevel:0.4]];
    
    [self.storeHeardImageView sd_setImageWithURL:[NSURL URLWithString:logo] placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    [self.storeNameLabel setText:storeInfoModel.name];
    
    self.starLabel.text = storeInfoModel.star;
    
    
     [self.focusNumberLabel setText:[NSString stringWithFormat:SLLocalizedString(@"%@人关注"), storeInfoModel.countCollet]];
    
    [self.descLabel setText:storeInfoModel.intro];
    [self.addressLabel setText:storeInfoModel.address];
    
    if ([storeInfoModel.start_time containsString:@" "]) {
        NSString * start_time = [storeInfoModel.start_time componentsSeparatedByString:@" "].firstObject;
        [self.timeLabel setText:start_time];
    } else {
        [self.timeLabel setText:SLLocalizedString(@"未知")];
    }
    
    
    
    BOOL isCollect  = [storeInfoModel.collect boolValue];
    if (isCollect == YES) {
        [self.focusButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.focusButton.layer.borderColor = [UIColor colorForHex:@"999999"].CGColor;
        self.focusButton.layer.borderWidth = 1;
        [self.focusButton setBackgroundColor:[UIColor clearColor]];
        self.focusButton.layer.cornerRadius = SLChange(15);
        [self.focusButton setTitle:SLLocalizedString(@"已关注") forState:UIControlStateNormal];
        [self.focusButton setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
    }else{
       [self.focusButton setImage:[UIImage imageNamed:@"baiGuanzhu"] forState:UIControlStateNormal];
        [self.focusButton setTitle:SLLocalizedString(@"关注") forState:UIControlStateNormal];
        [self.focusButton setBackgroundColor:[UIColor colorForHex:@"BE0B1F"]];
        self.focusButton.layer.borderColor = [UIColor colorForHex:@"BE0B1F"].CGColor;
        self.focusButton.layer.borderWidth = 1;
        self.focusButton.layer.cornerRadius = SLChange(15);
        [self.focusButton setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:UIControlStateNormal];
    }
    
//    self.scrollView.contentSize = CGSizeMake(0, kHeight/2 + self.lookBtn.bottom);
}





@end
