//
//  MePostManagerModel.h
//  Shaolin
//
//  Created by edz on 2020/4/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MePostManagerModel : NSObject
@property(nonatomic,copy) NSString *author;
@property(nonatomic,copy) NSString *click;

@property(nonatomic,copy) NSString *collection;
@property(nonatomic,copy) NSString *content;

@property(nonatomic,copy) NSString *coverurl;
@property(nonatomic,copy) NSString *useraccount;

@property(nonatomic,copy) NSString *createtype;
@property(nonatomic,copy) NSString *forward;

@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *kind;

@property(nonatomic,copy) NSString *praise;
@property(nonatomic,copy) NSString *state; //2:审核中 4:已拒绝 5:已下架 6:发布成功
@property(nonatomic,copy) NSString *headurl;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *abstracts;

//@property(nonatomic,copy) NSString *returnTime;
@property(nonatomic,copy) NSString *releaseTime;


@property(nonatomic,copy) NSString *fieldId;
@property(nonatomic,strong) NSArray *coverUrlList;


@property (nonatomic, strong) NSString *cellIdentifier;
/** cell的高度*/
@property (nonatomic, assign) CGFloat cellHeight;
@end


