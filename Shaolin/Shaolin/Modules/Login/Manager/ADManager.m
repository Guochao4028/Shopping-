//
//  ADManager.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ADManager.h"
#import "XHLaunchAd.h"
#import "LoginManager.h"

#import "WengenBannerModel.h"
#import "NSData+LGFHash.h"

//#define ADManagerTest
static NSArray *testImageArray = nil;

@interface ADManager()<XHLaunchAdDelegate>
@property (nonatomic, strong)XHLaunchImageAdConfiguration *imageAdconfiguration;
@end

@implementation ADManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ADManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)clearDiskCache {
    [XHLaunchAd clearDiskCache];
}

+ (float)getDiskCacheSize{
    return [XHLaunchAd diskCacheSize];
}

+ (void)showAD {
//    1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
//    2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将不显示
//    3.数据获取成功,配置广告数据后,自动结束等待,显示广告
//    注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
    [XHLaunchAd setWaitDataDuration:3];
    ADManager *manager = [ADManager sharedInstance];
    __weak typeof(manager) weakManager = manager;
    [manager downloadAD:^(id responseObject) {
        if (!responseObject) responseObject = [weakManager getCacheADData];
//        if ([ModelTool checkResponseObject:responseObject]){
//            NSDictionary *dict = [responseObject objectForKey:DATAS];
        NSDictionary *dict = responseObject;

            WengenBannerModel *model = [WengenBannerModel mj_objectWithKeyValues:dict];
//            //如果本地没有缓存该图片，则在本地缓存中查找一个缓存广告显示
//            if (model && ![XHLaunchAd checkImageInCacheWithURL:[NSURL URLWithString:model.imgUrl]]){
//                NSLog(@"ADManager 本地没有存储该广告图片");
//                NSLog(@"ADManager 本地存储该广告图片%@", model.imgUrl);
//                [[XHLaunchAdDownloader sharedDownloader] downLoadImageAndCacheWithURLArray:@[
//                    [NSURL URLWithString:model.imgUrl],
//                ] completed:^(NSArray * _Nonnull completedArray) {
//                    NSLog(@"ADManager 图片存储完毕，本地存储这条新的广告数据");
//                    [weakManager saveADData:responseObject];
//                }];
//                if ([weakManager getCacheCount]){
//                    NSLog(@"ADManager 使用本地存储的广告数据");
//                    dict = [weakManager getCacheADData];
//                    dict = [dict objectForKey:DATAS];
//                    model = [WengenBannerModel mj_objectWithKeyValues:dict];
//                }
//            } else if (!model){
//                NSLog(@"ADManager 服务器返回了null");
//                if ([weakManager getCacheCount]){
//                    NSLog(@"ADManager 使用本地存储的广告数据");
//                    dict = [weakManager getCacheADData];
//                    dict = [dict objectForKey:DATAS];
//                    model = [WengenBannerModel mj_objectWithKeyValues:dict];
//                } else {
//                    NSLog(@"ADManager 本地没有储存广告数据，广告展示失败");
//                }
//            }
            if (model){
                BOOL checkCache = [XHLaunchAd checkImageInCacheWithURL:[NSURL URLWithString:model.imgUrl]];
                NSLog(@"ADManager 本地是否已经缓存该图片:%d, 只有缓存了图片才会显示广告页", checkCache);
                NSLog(@"ADManager 图片URL:%@", model.imgUrl);
                BOOL isLogin = [[SLAppInfoModel sharedInstance] accessToken].length;
                NSLog(@"ADManager 用户登录状态:%d, 只有登录了才会显示广告页", isLogin);
                if (!checkCache){
                    [[XHLaunchAdDownloader sharedDownloader] downLoadImageAndCacheWithURLArray:@[
                        [NSURL URLWithString:model.imgUrl],
                    ] completed:^(NSArray * _Nonnull completedArray) {
                        NSLog(@"ADManager 图片存储完毕，本地存储这条新的广告数据");
                    }];
                    [XHLaunchAd removeAndAnimated:NO];
                }
                if (checkCache && isLogin){
                    [weakManager showADView:model];
                }
            }
//        }
    }];
}

- (void)showADView:(WengenBannerModel *)model{
    //2.自定义配置初始化
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    self.imageAdconfiguration.imageNameOrURLString = model.imgUrl;
    //广告点击是传到delegate中的model
    self.imageAdconfiguration.openModel = model;
    
    //显示图片开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:self.imageAdconfiguration delegate:self];
}

- (UIView *)customSkipView {
    XHLaunchAdButton *skipButton = [[XHLaunchAdButton alloc] initWithSkipType:self.imageAdconfiguration.skipButtonType];
    [skipButton setTitleWithSkipType:self.imageAdconfiguration.skipButtonType duration:self.imageAdconfiguration.duration];
    [skipButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    return skipButton;
}

- (void)skipAction
{
    [XHLaunchAd removeAndAnimated:YES];
}

#pragma mark - requestData
- (void)downloadAD:(void (^)(id responseObject))success{
//    [[LoginManager sharedInstance] getOpenScreenAppAD:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        if (success) success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        if (success) success(nil);
//    }];
//
    [[LoginManager sharedInstance]getOpenScreenAppADSuccess:^(NSDictionary * _Nullable resultDic) {
        if (success) success(resultDic);
    } failure:^(NSString * _Nullable errorReason) {
        if (success) success(nil);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
}

#pragma mark - Cache policy
- (NSUInteger)getCacheCount{
    NSString *from = [self adManagerCachePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subpaths = [fileManager subpathsAtPath:from];
    NSLog(@"ADManager 本地已有广告数据:%ld条", subpaths.count);
    return subpaths.count;
}

//从缓存列表中抓取一条数据
- (NSDictionary *)getCacheADData{
    if (![self getCacheCount]) return nil;
    NSString *from = [self adManagerCachePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subpaths = [fileManager subpathsAtPath:from];
    
    NSLog(@"从本地随机获取一条广告数据");
    NSUInteger idx = arc4random()%subpaths.count;
    NSString *path = [NSString stringWithFormat:@"%@/%@", from, subpaths[idx]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"ADManager 从本地获取了一条广告数据");
        return dict;
    } else {
        [fileManager removeItemAtPath:path error:nil];
        NSLog(@"ADManager 文件损坏，清除文件，文件路径为:%@", path);
        return nil;
    }
}

- (void)saveADData:(NSDictionary *)dict{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *md5 = [data lgf_Md5String];
    NSString *cachePath = [self adManagerCachePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@", cachePath, md5];
    if (data) {
        BOOL result = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
        if (!result) XHLaunchAdLog(@"ADManager cache file error for dict: %@", dict);
    }
    NSLog(@"ADManager 本地存储了一条广告数据");
}

- (NSString *)adManagerCachePath{
    NSString *path =[NSHomeDirectory() stringByAppendingPathComponent:@"Library/XHLaunchAdCache/Model"];
    [self checkDirectory:path];
    return path;
}

- (void)checkDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}
- (void)createBaseDirectoryAtPath:(NSString *)path {
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        XHLaunchAdLog(@"ADManager create cache directory failed, error = %@", error);
    } else {
        [self addDoNotBackupAttribute:path];
    }
}

- (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        XHLaunchAdLog(@"ADManager error to set do not backup attribute, error = %@", error);
    }
}
#pragma mark - delegate
- (void)xhLaunchAd:(XHLaunchAd *)launchAd imageDownLoadFinish:(UIImage *)image imageData:(NSData *)imageData {

    NSLog(@"ADManager 图片下载完成/或本地图片读取完成回调");
}

/**
 *  代理方法-倒计时回调
 *
 *  @param launchAd XHLaunchAd
 *  @param duration 倒计时时间
 */
- (void)xhLaunchAd:(XHLaunchAd *)launchAd customSkipView:(UIView *)customSkipView duration:(NSInteger)duration {
    if (duration == 0) return;
    XHLaunchAdButton *button = (XHLaunchAdButton *)customSkipView;//此处转换为你之前的类型
    [button setTitleWithSkipType:self.imageAdconfiguration.skipButtonType duration:duration];
}

/**
 *  广告点击事件 回调
 *  return  YES移除广告,NO不移除
 */
- (BOOL)xhLaunchAd:(XHLaunchAd *)launchAd clickAtOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    if (![openModel isKindOfClass:[WengenBannerModel class]]) return NO;
    WengenBannerModel *model = openModel;
    if ([model.type isEqualToString:@"1"]) NSLog(@"ADManager 点击外链");
    if ([model.type isEqualToString:@"2"]) NSLog(@"ADManager 点击内链");
    [[SLAppInfoModel sharedInstance] bannerEventResponseWithBannerModel:model];
    return YES;
}

#pragma mark - getter
- (XHLaunchImageAdConfiguration *)imageAdconfiguration{
    if (!_imageAdconfiguration){
        _imageAdconfiguration = [XHLaunchImageAdConfiguration new];
        //广告停留时间
        _imageAdconfiguration.duration = 3;//3、2、1，共三秒
        //广告frame
        _imageAdconfiguration.frame = [UIScreen mainScreen].bounds;//CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-150);
        //网络图片缓存机制(只对网络图片有效)
        _imageAdconfiguration.imageOption = XHLaunchAdImageCacheInBackground;//后台缓存本次不显示,缓存OK后下次再显示(建议使用这种方式.)XHLaunchAdImageRefreshCached
        //图片填充模式
        _imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleToFill;//UIViewContentModeScaleAspectFill
        //广告显示完成动画
        _imageAdconfiguration.showFinishAnimate = ShowFinishAnimateFadein;
        //跳过按钮类型
        _imageAdconfiguration.skipButtonType = SkipTypeTimeText;//SkipTypeText;//SkipTypeTimeText;
        //后台返回时,是否显示广告
        _imageAdconfiguration.showEnterForeground = NO;
        
        CGFloat y = XH_FULLSCREEN ? 44 : 20;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 60, 25)];
        label.text = SLLocalizedString(@"广告");
        label.textColor = [UIColor whiteColor];
        label.font = kRegular(10);
        
        _imageAdconfiguration.subViews = @[label];
        _imageAdconfiguration.customSkipView = [self customSkipView];
    }
    return _imageAdconfiguration;
}
@end
