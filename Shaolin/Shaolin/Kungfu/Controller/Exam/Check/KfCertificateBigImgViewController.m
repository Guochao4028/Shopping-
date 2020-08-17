//
//  KfCertificateBigImgViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KfCertificateBigImgViewController.h"
#import "YBIBPhotoAlbumManager.h"
#import "YBIBToastView.h"

@interface KfCertificateBigImgViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *bigImgScrollView;
@property (nonatomic, strong) UIImageView *bigImgView;


@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) UIView * footerViewLine;
@property (nonatomic, strong) UIButton * submitBtn;
@end

@implementation KfCertificateBigImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabe.text = SLLocalizedString(@"证书查询");
    [self setUI];
}

- (void)setUI{
    //cerImg.jpg
    [self.view addSubview:self.bigImgScrollView];
    [self.bigImgScrollView addSubview:self.bigImgView];
    
    [self.view addSubview:self.footerView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.bigImgScrollView.frame = self.view.bounds;
    CGFloat w = CGRectGetWidth(self.bigImgScrollView.frame)/4.0*3;
    CGFloat h = CGRectGetHeight(self.bigImgScrollView.frame)/4.0*3;
    self.bigImgView.frame = CGRectMake((CGRectGetWidth(self.bigImgScrollView.frame) - w)/2, 30, w, h);
}

#pragma mark - method

- (void) saveHandle {
    [YBIBPhotoAlbumManager getPhotoAlbumAuthorizationSuccess:^{
        UIImageWriteToSavedPhotosAlbum(self.bigImgView.image, self, @selector(UIImageWriteToSavedPhotosAlbum_completedWithImage:error:context:), NULL);
    } failed:^{
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"温馨提示") message:SLLocalizedString(@"请在设置中允许访问相册功能") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:SLLocalizedString(@"确定") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alertVc addAction:cancelBtn];
        [alertVc addAction :sureBtn];
        [self presentViewController:alertVc animated:YES completion:nil];
    }];
}

- (void)longGestureRecognizer:(UILongPressGestureRecognizer *)gesture{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"保存图片") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self saveHandle];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)UIImageWriteToSavedPhotosAlbum_completedWithImage:(UIImage *)image error:(NSError *)error context:(void *)context {
    if (error) {
       [self.view ybib_showHookToast:SLLocalizedString(@"保存失败")];
    } else {
        [self.view ybib_showHookToast:SLLocalizedString(@"已保存到系统相册")];
    }
}
#pragma mark - scrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.bigImgView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    //把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
    NSLog(@"scale is %f",scale);
    [self.bigImgScrollView setZoomScale:scale animated:NO];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGRect imageViewFrame = self.bigImgView.frame;
    CGFloat width = imageViewFrame.size.width,
    sWidth = scrollView.bounds.size.width;
    if (width > sWidth) {
        imageViewFrame.origin.x = 0;
    } else {
        imageViewFrame.origin.x = (sWidth - width) / 2.0;
    }
    self.bigImgView.frame = imageViewFrame;
}

#pragma mark - setter && getter
- (void)setCertificateUrl:(NSString *)certificateUrl{
    _certificateUrl = certificateUrl;
    [self.bigImgView sd_setImageWithURL:[NSURL URLWithString:self.certificateUrl] placeholderImage:[UIImage imageNamed:@"default_big"]];
}

- (UIScrollView *)bigImgScrollView{
    if (!_bigImgScrollView){
        _bigImgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _bigImgScrollView.delegate = self;
        _bigImgScrollView.minimumZoomScale = 1;
        _bigImgScrollView.maximumZoomScale = 2;
        _bigImgScrollView.showsHorizontalScrollIndicator = NO;
        _bigImgScrollView.showsVerticalScrollIndicator = NO;
        [_bigImgScrollView setZoomScale:_bigImgScrollView.minimumZoomScale animated:YES];
    }
    return _bigImgScrollView;
}

- (UIImageView *)bigImgView{
    if (!_bigImgView){
        _bigImgView = [[UIImageView alloc] init];
        _bigImgView.userInteractionEnabled = YES;
        _bigImgView.contentMode = UIViewContentModeScaleAspectFit;
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureRecognizer:)];
        [_bigImgView addGestureRecognizer:longGesture];
    }
    return _bigImgView;
}


-(UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50 - NavBar_Height, kScreenWidth - 32, 50)];
        _footerView.backgroundColor = UIColor.whiteColor;
        [_footerView addSubview:self.footerViewLine];
        [_footerView addSubview:self.submitBtn];
    }
    return _footerView;
}

-(UIView *)footerViewLine {
    if (!_footerViewLine) {
        _footerViewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
        _footerViewLine.backgroundColor = [UIColor hexColor:@"E5E5E5"];
    }
    return _footerViewLine;
}

-(UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(63, 5, kScreenWidth - 126, 40)];
        _submitBtn.layer.cornerRadius = 20;
        _submitBtn.backgroundColor = [UIColor hexColor:@"8E2B25"];
        [_submitBtn setTitle:SLLocalizedString(@"保存证书") forState:UIControlStateNormal];
        _submitBtn.titleLabel.textColor = UIColor.whiteColor;
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_submitBtn addTarget:self action:@selector(saveHandle) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _submitBtn;
}
@end
