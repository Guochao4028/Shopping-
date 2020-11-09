//
//  QRCodeViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/10/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "QRCodeViewController.h"
#import "SMAlert.h"
#import "UserRightsManager.h"
#import "UIImage+LGFImage.h"
#import "UIButton+Block.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

static NSString *const FocusImageScaleAnimation = @"focusImageScaleAnimation";
@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate, CAAnimationDelegate>
{
    NSTimer *_timer;
    BOOL upOrDown;
    int num;
}

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoDataOutput *sampleBufferOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *focusImageView;
@property (nonatomic, strong) UIImageView *spotImageView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UILabel *tipsLable;
@property (nonatomic, strong) UIButton *flashlightButton;
@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic) UserRightsEnum userCameraRights;
@property (nonatomic) UserRightsEnum userPhotoRights;
@end

@implementation QRCodeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.userCameraRights == UserRightsManager_success){
        [self starScan];
    } else {
        [self openCamera];
    }
//    [UserRightsManager getUserCameraRights:YES success:^{
//        [self initView];
//    } failed:^{
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.hideNavigationBarView == NO && self.hideNavigationBar == NO){
        self.hideNavigationBar = YES;
    }
    [self setUI];
//    [self openCamera];
    [self addTimer];
    [self starScan];
}

- (void)viewDidDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self stopScan];
}
 
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}
 
//添加扫描框
- (void)setUI{
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.imageView];
    [self.imageView addSubview:self.line];
    [self.view addSubview:self.tipsLable];
    [self.view addSubview:self.photoButton];
    [self.view addSubview:self.flashlightButton];
    
    [self.view addSubview:self.focusImageView];
    [self.view addSubview:self.spotImageView];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(21);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT + 32);
        make.size.mas_equalTo(CGSizeMake(13, 21));
    }];
    self.backButton.layer.cornerRadius = 10;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(200);
        make.bottom.mas_equalTo(-200);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_offset(5);
    }];
    
    [self.tipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_equalTo(10);
        make.centerX.mas_equalTo(self.imageView);
    }];
    
    [self.spotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    self.spotImageView.layer.cornerRadius = 10;
    
    [self.focusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    if (self.toolBar & Flashlight){
        [self.flashlightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageView.mas_bottom).mas_equalTo(50);
            make.centerX.mas_equalTo(self.imageView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    if (self.toolBar & Photo) {
        [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-50);
            make.top.mas_equalTo(self.imageView.mas_bottom).mas_equalTo(50);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    self.photoButton.layer.cornerRadius = 25;
    
    
    self.flashlightButton.layer.cornerRadius = 25;
    
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    //初始化扫描配置
    self.preview.frame = self.view.bounds;
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;// AVLayerVideoGravityResize;
    [self.view.layer insertSublayer:self.preview atIndex:0];
}
 
- (void)addTimer{
    num = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.008 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
}

//控制扫描线上下滚动
- (void)timerMethod{
    if (upOrDown == NO) {
        num ++;
    } else {
        num --;
    }
    self.line.y = num;
    if (self.line.maxY > self.imageView.height){
        upOrDown = YES;
    } else if (self.line.y < 0){
        upOrDown = NO;
    }
}

/// 开始扫描
- (void)starScan{
#if !(TARGET_IPHONE_SIMULATOR)
    [self.session startRunning];
    [_timer setFireDate:[NSDate distantPast]];
#endif
}

/// 暂停扫描
- (void)stopScan{
#if !(TARGET_IPHONE_SIMULATOR)
    [self.session stopRunning];
    [_timer setFireDate:[NSDate distantFuture]];
#endif
}

/// 打开相机
- (void)openCamera{
    [UserRightsManager getUserCameraRights:YES success:^(UserRightsEnum userRightsEnum) {
        self.userCameraRights = userRightsEnum;
        if (userRightsEnum == UserRightsManager_success){
            if (!self.device) {
                [SMAlert showAlertWithInfoString:SLLocalizedString(@"未检测到摄像头！") confirmButtonTitle:SLLocalizedString(@"确定") success:nil];
                return;
//                [SMAlert showAlertWithInfoString:SLLocalizedString(@"未检测到摄像头！") confirmButtonTitle:SLLocalizedString(@"确定") success:^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                }];
            }
            //配置输出元数据源需要有相机权限
            [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode]];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

/// 打开相册
- (void)openPhoto{
    [UserRightsManager getUserPhotoRights:YES success:^(UserRightsEnum userRightsEnum) {
        self.userPhotoRights = userRightsEnum;
        if (userRightsEnum == UserRightsManager_success){
            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            imagePicker.allowPickingVideo = NO;
            [imagePicker setBarItemTextColor:[UIColor blackColor]];
            [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
                NSLog(@"%@",photos);
                UIImage *image = photos[0];
                NSArray *QRCodeStringArray = [self getQRCodeStringByImage:image];
                [self handleQRCodeStringArray:QRCodeStringArray handleSuccess:^{
                    
                }];
            }];
            imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:imagePicker animated:YES completion:nil];
        } else {
            
        }
    }];
}

/// 打开闪光灯
- (void)openFlashlight:(BOOL)on{
    [self.input.device lockForConfiguration:nil];
    if (on){
        self.input.device.torchMode = AVCaptureTorchModeOn;
    } else {
        self.input.device.torchMode = AVCaptureTorchModeOff;
    }
    [self.input.device unlockForConfiguration];
}
#pragma mark -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [touches.anyObject locationInView:self.view];
    if ([self.session isRunning]){
        [self focusForDevice:self.device atPoint:point];
    }
}
#pragma mark - 相机相关操作
/// 调整对焦
- (void)focusForDevice:(AVCaptureDevice *)device atPoint:(CGPoint)point{
    [self.preview captureDevicePointOfInterestForPoint:point];
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]){
        if ([device lockForConfiguration:nil]){
            CGPoint focusPoint = [self.preview captureDevicePointOfInterestForPoint:point];//[self transformedViewPointToFocusPoint:point];
            device.focusPointOfInterest = focusPoint;
            device.focusMode = AVCaptureFocusModeAutoFocus;
            [device unlockForConfiguration];
            
            [self reloadFocusImageViewPosition:point];
        }
    }
}
#pragma mark - 处理二维码数据
- (NSArray <NSString *> *) getQRCodeStringByImage:(UIImage *)image {
    NSMutableArray *QRCodeStringArray = [[NSMutableArray alloc] initWithCapacity:0];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    //监测到的结果数组
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    for (int i = 0; i < features.count; i++) {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scannedResult = feature.messageString;
        if ([self checkQRCodeString:scannedResult]){
            [QRCodeStringArray addObject:scannedResult];
        }
    }
    return QRCodeStringArray;
}

- (BOOL)checkQRCodeString:(NSString *)QRCodeString{
    if (QRCodeString && (!self.checkQRCodeString || self.checkQRCodeString(QRCodeString))){
        return YES;
    }
    return NO;
}

- (void)handleQRCodeStringArray:(NSArray *)QRCodeStringArray handleSuccess:(HandleSuccessBlock)handleSuccess{
    if (self.scanSucceeded){
        self.scanSucceeded(QRCodeStringArray, handleSuccess);
    } else if (handleSuccess){
        handleSuccess();
    }
}
#pragma mark - 数据转换（转成屏幕坐标系）
- (CGPoint)pointForCorner:(NSDictionary *)corner {
    CGPoint point;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)corner, &point);
    return point;
}

- (CGPoint)transformedViewPointToFocusPoint:(CGPoint)viewPoint{
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    viewPoint.x = viewPoint.x / width;
    viewPoint.y = viewPoint.y / height;
    return viewPoint;
}

- (NSArray *)transformedCodesFromCodes:(NSArray *)codes {
    NSMutableArray *transformedCodes = [NSMutableArray array];
    [codes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AVMetadataObject *transformedCode = [self.preview transformedMetadataObjectForMetadataObject:obj];
        [transformedCodes addObject:transformedCode];
    }];
    return [transformedCodes copy];
}

- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat x = (height - CGRectGetHeight(rect)) / 2 / height;
    CGFloat y = (width - CGRectGetWidth(rect)) / 2 / width;
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
    return CGRectMake(x, y, w, h);
}

#pragma mark -
- (void)reloadFocusImageViewPosition:(CGPoint)point{
    //TODO:暂时隐藏聚焦标识
    self.focusImageView.hidden = YES;
    self.focusImageView.center = point;
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    moveAnimation.fromValue = [NSNumber numberWithFloat:1.5];
    moveAnimation.toValue = [NSNumber numberWithInt:1];
    moveAnimation.duration = 0.5;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.repeatCount = 1;
    moveAnimation.delegate = self;
    if ([self.focusImageView.layer.animationKeys containsObject:FocusImageScaleAnimation]){
        [self.focusImageView.layer removeAnimationForKey:FocusImageScaleAnimation];
    }
    [self.focusImageView.layer addAnimation:moveAnimation forKey:FocusImageScaleAnimation];
}

- (void)reloadSpotImageViewPositionByMetadataObjects:(NSArray *)metadataObjects{
    NSMutableArray *centerValueArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [metadataObjects count]; i++){
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:i];
        if ([metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            NSString *scannedResult = [metadataObject stringValue];
            if (scannedResult != nil && [self checkQRCodeString:scannedResult]) {
                NSArray<NSDictionary *> *corners = metadataObject.corners;
                NSLog(@"corners:%@", corners);
                
                CGRect bounds = metadataObject.bounds;
                CGFloat centerX = bounds.origin.x + bounds.size.width / 2;
                CGFloat centerY = bounds.origin.y + bounds.size.height / 2;
                [centerValueArray addObject:[NSValue valueWithCGPoint:CGPointMake(centerX, centerY)]];
            }
        }
    }
    self.spotImageView.hidden = !centerValueArray.count;
    if (centerValueArray.count){
        self.spotImageView.center = [centerValueArray.lastObject CGPointValue];
    }
}

- (void)reloadFlashlightButtonState{
    AVCaptureTorchMode torch = self.input.device.torchMode;
    if (torch == AVCaptureTorchModeOn){
        [self.flashlightButton setImage:[UIImage imageNamed:@"shanguangdeng-on"] forState:UIControlStateNormal];
        self.flashlightButton.hidden = NO;
    } else {
        [self.flashlightButton setImage:[UIImage imageNamed:@"shanguangdeng-off"] forState:UIControlStateNormal];
    }
}

#pragma mark - delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if([self.focusImageView.layer animationForKey:FocusImageScaleAnimation] == anim && flag) {
        self.focusImageView.hidden = YES;
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    metadataObjects = [self transformedCodesFromCodes:metadataObjects];
    NSMutableArray *identifiedObjects = [@[] mutableCopy];
    
    NSMutableArray *QRCodeStringArray = [[NSMutableArray alloc] initWithCapacity:0];
    //通过扫描的元数据，获取得到的二维码数组
    for (int i = 0; i < [metadataObjects count]; i++){
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:i];
        if ([metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            NSString *scannedResult = [metadataObject stringValue];
            if ([self checkQRCodeString:scannedResult]){
                [identifiedObjects addObject:metadataObject];
                [QRCodeStringArray addObject:scannedResult];
                
                NSLog(@"已扫描到二维码：%@", scannedResult);
//                [ShaolinProgressHUD singleTextAutoHideHud:scannedResult];
            }
        }
    }
    if (QRCodeStringArray.count){
        // 更新选中圆点位置
//        [self reloadSpotImageViewPositionByMetadataObjects:identifiedObjects];
        [self stopScan];
        WEAKSELF
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            // 处理扫描结果
            [weakSelf handleQRCodeStringArray:QRCodeStringArray handleSuccess:^{
                //结束扫描
                [weakSelf stopScan];
            }];
//        });
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    CGFloat brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    // brightnessValue 值代表光线强度，值越小代表光线越暗
    self.flashlightButton.hidden = brightnessValue > -1;
    [self reloadFlashlightButtonState];
    
//    self.tipsLable.hidden = !self.flashlightButton.hidden;
}
#pragma mark - getter
- (UIButton *)backButton{
    if (!_backButton){
        _backButton = [[UIButton alloc] init];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"leftWhiteArrow"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIImageView *)focusImageView{
    if (!_focusImageView){
        _focusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cameraFocus"]];
        _focusImageView.hidden = YES;
    }
    return _focusImageView;
}

- (UIImageView *)spotImageView{
    if (!_spotImageView){
        _spotImageView = [[UIImageView alloc] init];
        _spotImageView.image = [UIImage imageNamed:@""];
        _spotImageView.hidden = YES;
        
        _spotImageView.backgroundColor = [UIColor whiteColor];
        _spotImageView.layer.borderWidth = 8;
        _spotImageView.layer.borderColor = [UIColor greenColor].CGColor;
    }
    return _spotImageView;
}

- (UIImageView *)imageView{
    if (!_imageView){
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"ty_qrcode_bg"];
        _imageView.backgroundColor = [UIColor clearColor];// [UIColor colorWithWhite:0.1 alpha:0.4];
    }
    return _imageView;
}

- (UIImageView *)line{
    if (!_line){
        _line = [[UIImageView alloc] init];
        _line.image = [UIImage imageNamed:@"qrcode_scan_light_green"];
    }
    return _line;
}

- (UILabel *)tipsLable{
    if (!_tipsLable){
        _tipsLable = [[UILabel alloc] init];
        _tipsLable.text = SLLocalizedString(@"扫描二维码");
        _tipsLable.textAlignment = NSTextAlignmentCenter;
        _tipsLable.textColor = [UIColor whiteColor];
        _tipsLable.font = kRegular(14);
    }
    return _tipsLable;
}

- (UIButton *)photoButton{
    if (!_photoButton){
        _photoButton = [[UIButton alloc] init];
        _photoButton.backgroundColor = [UIColor whiteColor];
        [_photoButton setImage:[UIImage imageNamed:@"icon_picture"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoButton;
}

- (UIButton *)flashlightButton{
    if (!_flashlightButton){
        _flashlightButton = [[UIButton alloc] init];
        _flashlightButton.backgroundColor = [UIColor whiteColor];
        [_flashlightButton setImage:[UIImage imageNamed:@"shanguangdeng-off"] forState:UIControlStateNormal];
        WEAKSELF
        [_flashlightButton handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
            button.selected = !button.selected;
            [weakSelf openFlashlight:button.selected];
            [weakSelf reloadFlashlightButtonState];
        }];
        _flashlightButton.hidden = YES;
    }
    return _flashlightButton;
}

- (AVCaptureDevice *)device{
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //先进行判断是否支持控制对焦,不开启自动对焦功能，很难识别二维码。
        if (_device.isFocusPointOfInterestSupported && [_device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.input.device lockForConfiguration:nil];
            [self.input.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [self.input.device unlockForConfiguration];
        }
    }
    return _device;
}
 
- (AVCaptureDeviceInput *)input{
    if (!_input) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}
 
- (AVCaptureMetadataOutput *)output{
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //TODO:限制扫描区域(上下左右)
//        [_output setRectOfInterest:[self rectOfInterestByScanViewRect:self.imageView.frame]];
    }
    return _output;
}

- (AVCaptureVideoDataOutput *)sampleBufferOutput{
    if (!_sampleBufferOutput){
        _sampleBufferOutput = [[AVCaptureVideoDataOutput alloc] init];;
        [_sampleBufferOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    }
    
    return _sampleBufferOutput;
}

- (AVCaptureSession *)session{
    if (!_session) {
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        if ([_session canAddOutput:self.output]) {
            [_session addOutput:self.output];
        }
        if ([_session canAddOutput:self.sampleBufferOutput]) {
            [_session addOutput:self.sampleBufferOutput];
        }
    }
    return _session;
}
 
- (AVCaptureVideoPreviewLayer *)preview{
    if (!_preview) {
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    return _preview;
}
@end
