//
//  ShowBigImageViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ShowBigImageViewController.h"
#import "YBIBPhotoAlbumManager.h"
#import "YBIBToastView.h"

@interface ShowBigImageViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *bigImgScrollView;
@property (nonatomic, strong) UIImageView *bigImgView;

@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) UIView * footerViewLine;
@end

@implementation ShowBigImageViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.placeholderImage = @"";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    self.titleLabe.text = self.titleString;
}

- (void)setUI{
    //cerImg.jpg
    [self.view addSubview:self.bigImgScrollView];
    [self.bigImgScrollView addSubview:self.bigImgView];
    
    
    [self.view addSubview:self.footerView];
    
    [self.footerView addSubview:self.cancelButton];
    [self.footerView addSubview:self.saveButton];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-(BottomMargin_X + 10));
    }];
    
    [self.footerView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:15 tailSpacing:15];
    [self.footerView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.bottom.mas_equalTo(0);
    }];
    self.saveButton.layer.cornerRadius = 20;
    self.cancelButton.layer.cornerRadius = 20;
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
    if (self.saveButtonClickBlock){
        self.saveButtonClickBlock();
        return;
    }
    [YBIBPhotoAlbumManager getPhotoAlbumAuthorizationSuccess:^{
        UIImageWriteToSavedPhotosAlbum(self.bigImgView.image, self, @selector(UIImageWriteToSavedPhotosAlbum_completedWithImage:error:context:), NULL);
    } failed:^{
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请在设置中允许访问相册功能" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alertVc addAction:cancelBtn];
        [alertVc addAction :sureBtn];
        [self presentViewController:alertVc animated:YES completion:nil];
    }];
}

- (void)cancelHandle{
    if (self.cancelButtonClickBlock){
        self.cancelButtonClickBlock();
    }
}

- (void)longGestureRecognizer:(UILongPressGestureRecognizer *)gesture{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self saveHandle];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)UIImageWriteToSavedPhotosAlbum_completedWithImage:(UIImage *)image error:(NSError *)error context:(void *)context {
    if (error) {
       [self.view ybib_showHookToast:@"保存失败"];
    } else {
        [self.view ybib_showHookToast:@"已保存到系统相册"];
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

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [self.bigImgView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:self.placeholderImage]];
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
        _footerView = [[UIView alloc] initWithFrame:CGRectZero];
        _footerView.backgroundColor = [UIColor clearColor];
    }
    return _footerView;
}

-(UIView *)footerViewLine {
    if (!_footerViewLine) {
        _footerViewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
        _footerViewLine.backgroundColor = KTextGray_E5;
        _footerViewLine.backgroundColor = [UIColor clearColor];
    }
    return _footerViewLine;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectZero];
//        _saveButton.layer.cornerRadius = 20;
        _saveButton.backgroundColor = kMainYellow;
        [_saveButton setTitle:@"保存图片" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_saveButton addTarget:self action:@selector(saveHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
//        _calcelButton.layer.cornerRadius = 20;
        _cancelButton.backgroundColor = [UIColor whiteColor];//KTextGray_333;
        _cancelButton.layer.borderColor = kMainYellow.CGColor;
        _cancelButton.layer.borderWidth = 1;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.textColor = kMainYellow;
        [_cancelButton setTitleColor:kMainYellow forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelButton addTarget:self action:@selector(cancelHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(void)setIsHiddenBottom:(BOOL)isHiddenBottom{
    _isHiddenBottom = isHiddenBottom;
    
    [self.footerView setHidden:isHiddenBottom];
    
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
