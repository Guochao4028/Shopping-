//
//  KfExamResultsViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KfExamResultsViewController.h"

@interface KfExamResultsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *resultImgv;

@property (weak, nonatomic) IBOutlet UILabel *topTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *countNumLabel;

@property (weak, nonatomic) IBOutlet UIView *countNumBgView;

@end

@implementation KfExamResultsViewController

- (void)dealloc {
    NSLog(@"考试界面释放了");
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topTextLabel.text = [NSString stringWithFormat:SLLocalizedString(@"您的理论考试成绩为%@分"),self.scoreString];
    
    if (self.isPass) {
        self.resultImgv.image = [UIImage imageNamed:@"kungfu_hege"];
        self.bottomTextLabel.text = SLLocalizedString(@"成绩合格");
        self.countNumLabel.text = @"";
        self.countNumBgView.hidden = YES;
    } else {
        self.resultImgv.image = [UIImage imageNamed:@"kungfu_buhege"];
        self.bottomTextLabel.text = SLLocalizedString(@"成绩不合格");
        self.countNumLabel.text = [NSString stringWithFormat:SLLocalizedString(@"您还有%d次考试机会"),self.countNum];
        self.countNumBgView.hidden = NO;
    }
}

- (void)leftAction
{
     [self.navigationController popToRootViewControllerAnimated:YES];
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
