//
//  FoundModel.h
//  Shaolin
//
//  Created by edz on 2020/3/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,FoundShowType) {
    FoundStick,
    FoundAdvertising,
    FoundSinglePhoto,
    FoundMorePhoto,
    FoundLongSinglePhoto
};

@interface FoundModel : NSObject
@property (nonatomic,assign) FoundShowType showType;
@property(nonatomic,copy) NSString *abstracts;
@property(nonatomic,copy) NSString *author;
@property(nonatomic,copy) NSString *classif;


@property(nonatomic,copy) NSString *collection;
@property(nonatomic,copy) NSString *collections;
@property(nonatomic,copy) NSString *clicks;
@property(nonatomic,copy) NSString *createTime;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *fieldId;
@property(nonatomic,copy) NSString *forwards;
@property(nonatomic,copy) NSString *kind;

@property(nonatomic,copy) NSString *praises;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *coverurl;

@property(nonatomic,copy) NSString *releaseTime;
@property(nonatomic,copy) NSString *id;
@property(nonatomic,strong) NSArray *coverurlList;

@property(nonatomic,copy) NSString *createtype;
@property(nonatomic,copy) NSString *useraccount;
@property(nonatomic,copy) NSString *state;
@property(nonatomic,copy) NSString *returnTime;
@property (nonatomic, strong) NSString *cellIdentifier;
/** cell的高度*/
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, copy) NSString *videoTimeStr;
///检查返回数据
+(BOOL) checkResponseObject:(NSDictionary *)responseObject;

- (NSString *)getVideoTimeByUrlString:(NSString*)urlString;
@end


