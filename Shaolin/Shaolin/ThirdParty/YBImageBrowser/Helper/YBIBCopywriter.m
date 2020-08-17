//
//  YBIBCopywriter.m
//  YBImageBrowserDemo
//
//  Created by 波儿菜 on 2018/9/13.
//  Copyright © 2018年 波儿菜. All rights reserved.
//

#import "YBIBCopywriter.h"

@implementation YBIBCopywriter

#pragma mark - life cycle

+ (instancetype)sharedCopywriter {
    static YBIBCopywriter *copywriter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        copywriter = [YBIBCopywriter new];
    });
    return copywriter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _type = YBIBCopywriterTypeSimplifiedChinese;
        NSArray *appleLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        if (appleLanguages && appleLanguages.count > 0) {
            NSString *languages = appleLanguages[0];
            if (![languages hasPrefix:@"zh-Hans"]) {
                _type = YBIBCopywriterTypeEnglish;
            }
        }
        
        [self initCopy];
    }
    return self;
}

#pragma mark - private

- (void)initCopy {
    BOOL en = self.type == YBIBCopywriterTypeEnglish;
    
    self.videoIsInvalid = en ? @"Video is invalid" : SLLocalizedString(@"视频无效");
    self.videoError = en ? @"Video error" : SLLocalizedString(@"视频错误");
    self.unableToSave = en ? @"Unable to save" : SLLocalizedString(@"无法保存");
    self.imageIsInvalid = en ? @"Image is invalid" : SLLocalizedString(@"图片无效");
    self.downloadFailed = en ? @"Download failed" : SLLocalizedString(@"加载图片失败");
    self.getPhotoAlbumAuthorizationFailed = en ? @"Failed to get album authorization" : SLLocalizedString(@"获取相册权限失败");
    self.saveToPhotoAlbumSuccess = en ? @"Save successful" : SLLocalizedString(@"已保存到系统相册");
    self.saveToPhotoAlbumFailed = en ? @"Save failed" : SLLocalizedString(@"保存失败");
    self.saveToPhotoAlbum = en ? @"Save" : SLLocalizedString(@"保存到相册");
    self.cancel = en ? @"Cancel" : SLLocalizedString(@"取消");
}

#pragma mark - public

- (void)setType:(YBIBCopywriterType)type {
    _type = type;
    [self initCopy];
}

@end
