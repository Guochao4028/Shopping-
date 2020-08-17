//
//  VersionUpdateModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VersionUpdateModel : NSObject
/*!版本号*/
@property (nonatomic, copy) NSString *versionNum;
/*!发包内容*/
@property (nonatomic, copy) NSString *publishContent;

/*!发包链接*/
@property (nonatomic, copy) NSString *releaseUrl;

/*!true表示当前版本与最新版本一致 false则取state进行逻辑判断*/
@property (nonatomic) BOOL flag;

/*!更新状态 1 无操作(不弹窗，不更新) 2 弹框 不强制更新 3 强制 弹框更新*/
@property (nonatomic, copy) NSString *state;

/*!逻辑版本(线上版本)*/
@property (nonatomic, copy) NSString *logicalVersion;
@end

NS_ASSUME_NONNULL_END
