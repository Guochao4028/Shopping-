//
//  KfScoreDetailViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KfScoreDetailViewController.h"
#import "ScoreDetailModel.h"
#import "KungfuManager.h"
#import "YBImageBrowser.h"
#import "EMImageBrowser.h"

@interface KfScoreDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollerView;
@property (weak, nonatomic) IBOutlet UIView *scrollerChildView;

@property (weak, nonatomic) IBOutlet UIButton *scoreTitleBtn;
@property (weak, nonatomic) IBOutlet UILabel *scoreTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardIdNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuratenumberLabel;


// theory 理论
@property (weak, nonatomic) IBOutlet UIButton *theoryBtn;
@property (weak, nonatomic) IBOutlet UILabel *theoryNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *theoryScoreLabel;
@property (weak, nonatomic) IBOutlet UIView *theoryBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *theoryBgVIewHeightCon;
@property (weak, nonatomic) IBOutlet UILabel *hittoryLabel;

// practice 实践
@property (weak, nonatomic) IBOutlet UIButton *practiceBtn;
@property (weak, nonatomic) IBOutlet UILabel *practiceNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *practiceScoreLabel;
@property (weak, nonatomic) IBOutlet UIView *practiceBgView;

@property (weak, nonatomic) IBOutlet UIButton *rewardBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rewardImgv;
@property (weak, nonatomic) IBOutlet UIView *resultBgView;

@property (weak, nonatomic) IBOutlet UILabel *noImgLabel;

@property (strong, nonatomic) ScoreDetailModel *scoreDetailModel;
@end

@implementation KfScoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabe.text = SLLocalizedString(@"成绩查询");
    self.bgScrollerView.showsVerticalScrollIndicator = NO;
    self.bgScrollerView.showsHorizontalScrollIndicator = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhotoBrowser)];
    self.rewardImgv.userInteractionEnabled = YES;
    [self.rewardImgv addGestureRecognizer:tap];
    
    [self setShadowWithView:self.theoryBgView];
    [self setShadowWithView:self.resultBgView];
    [self setShadowWithView:self.practiceBgView];
    
    
    [self setCorneradioWithButton:self.theoryBtn];
    [self setCorneradioWithButton:self.rewardBtn];
    [self setCorneradioWithButton:self.practiceBtn];
}

- (void) setCorneradioWithButton:(UIButton *)button {
    CGRect maskFrame = CGRectMake(0, 0, button.width, button.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskFrame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4,4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = maskFrame;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}

- (void) setShadowWithView:(UIView *)view {
    view.layer.shadowColor = [UIColor hexColor:@"c1c1c1"].CGColor;
    
    view.layer.shadowOffset = CGSizeZero;
    view.layer.shadowOpacity = 0.3f;
    view.layer.masksToBounds = NO;
}


- (void)setAccuratenumber:(NSString *)accuratenumber{
    _accuratenumber = accuratenumber;
    
    [self requestData];
}

- (void)reloadViews{
    if (!self.scoreDetailModel) return;
    
    self.scoreTitleLabel.text = [NSString stringWithFormat:@"%@",self.scoreDetailModel.activityname];
    
    [self.scoreTitleBtn setTitle:[NSString stringWithFormat:@" %@",self.scoreDetailModel.activityname] forState:UIControlStateNormal];
    
    if ([self.scoreDetailModel.type isEqualToString:@"1"]){
        self.cardIdNumberLabel.text = SLLocalizedString(@"身份证号：");
    } else {
        self.cardIdNumberLabel.text = SLLocalizedString(@"护照编号：");
    }
    [self setNewText:self.scoreDetailModel.name label:self.nameLabel];
    [self setNewText:self.scoreDetailModel.idCard label:self.cardIdNumberLabel];
    [self setNewText:self.scoreDetailModel.accuratenumber label:self.accuratenumberLabel];
    
    [self setNewText:self.scoreDetailModel.theoryScore label:self.theoryNumberLabel];
    [self setNewText:[self generateResultText:self.scoreDetailModel.theoryResult] label:self.theoryScoreLabel];
    
    if ([self.scoreDetailModel.theoryResult intValue] == 0) {
        // 不合格
        self.theoryBgVIewHeightCon.constant = 143;
        if ([self.scoreDetailModel.count isEqualToString:@"1"]){
            self.hittoryLabel.text = [NSString stringWithFormat:SLLocalizedString(@"(前一次理论成绩分数分别为：%@)"), self.scoreDetailModel.hittory];
        } else if ([self.scoreDetailModel.count isEqualToString:@"2"]){
            self.hittoryLabel.text = [NSString stringWithFormat:SLLocalizedString(@"(前两次理论成绩分数分别为：%@)"), self.scoreDetailModel.hittory];
        } else {
            self.hittoryLabel.text = @"";
            self.theoryBgVIewHeightCon.constant = 120;
        }
    } else {
        self.hittoryLabel.text = @"";
        self.theoryBgVIewHeightCon.constant = 120;
    }
    
    
    if (IsNilOrNull(self.scoreDetailModel.skillsScore) || self.scoreDetailModel.skillsScore.length == 0 || [self.scoreDetailModel.skillsScore isEqualToString:@"0"]) {
        self.practiceNumberLabel.text = SLLocalizedString(@"分       数：暂无成绩");
        self.practiceScoreLabel.text = SLLocalizedString(@"是否合格：等待考试");
    } else {
        [self setNewText:self.scoreDetailModel.skillsScore label:self.practiceNumberLabel];
        [self setNewText:[self generateResultText:self.scoreDetailModel.skillsResult] label:self.practiceScoreLabel];
    }
    
    
    if (IsNilOrNull(self.scoreDetailModel.certificateurl) || self.scoreDetailModel.certificateurl.length == 0) {
        self.rewardImgv.userInteractionEnabled = NO;
        self.noImgLabel.hidden = NO;
    } else {
        self.rewardImgv.userInteractionEnabled = YES;
        [self.rewardImgv sd_setImageWithURL:[NSURL URLWithString:self.scoreDetailModel.certificateurl] placeholderImage:nil];
        self.noImgLabel.hidden = YES;
    }
    
}

- (void)setNewText:(NSString *)text label:(UILabel *)label{
    NSArray *array = [label.text componentsSeparatedByString:@"："];
    if (array.count > 1){
        label.text = [NSString stringWithFormat:@"%@：%@", array.firstObject, text];
    } else {
        label.text = text;
    }
}

- (NSString *)generateResultText:(NSString *)text{
    if ([text isEqualToString:@"0"]) return SLLocalizedString(@"不合格");
    if ([text isEqualToString:@"1"]) return SLLocalizedString(@"合格");
    return text;
}

- (void)showPhotoBrowser {
    YBIBImageData *data = [YBIBImageData new];
    data.imageURL = [NSURL URLWithString:self.scoreDetailModel.certificateurl];
    data.projectiveView = self.rewardImgv;
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = @[data];
    browser.currentPage = 0;
    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    [browser show];
}
#pragma mark -
- (NSArray *)getProperties:(ScoreDetailModel *)model {
    u_int count;
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++){
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

- (void)checkScoreDetailModel:(ScoreDetailModel *)model{
    if (!model) return;
    NSDictionary *defDict = @{
        @"theoryScore":@"0",
        @"theoryResult":@"0",
        @"skillsScore":@"0",
        @"skillsResult":@"0",
    };
    NSArray *propertyNameStrArray = [self getProperties:model];
    for (NSString *propertyNameStr in propertyNameStrArray){
        NSString *value = [model valueForKey:propertyNameStr];
        if ([value isKindOfClass:[NSString class]] && !value){
            value = @""; 
        }
        if ([defDict objectForKey:propertyNameStr] && value.length == 0){
            value = defDict[propertyNameStr];
        }
        [model setValue:value forKey:propertyNameStr];
    }
}

- (void)requestData{
    if (self.accuratenumber && self.accuratenumber.length){
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
        [[KungfuManager sharedInstance] getScoreDetailWithParams:@{@"accuratenumber":self.accuratenumber} callbacl:^(NSObject *object) {
            if ([object isKindOfClass:[ScoreDetailModel class]]){
                self.scoreDetailModel = (ScoreDetailModel *)object;
                [self checkScoreDetailModel:self.scoreDetailModel];
            } else {
                self.scoreDetailModel = nil;
            }
            [self reloadViews];
            [hud hideAnimated:YES];
            self.bgScrollerView.contentSize = CGSizeMake(0, kHeight + 10);
        }];
    } else {
        self.scoreDetailModel = nil;
        [self reloadViews];
    }
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
