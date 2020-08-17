//
//  KungfuManager.m
//  Shaolin
//
//  Created by edz on 2020/4/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuManager.h"
#import "NetworkingHandler.h"

#import "EnrollmentModel.h"
#import "EnrollmentListModel.h"
#import "LevelModel.h"
#import "HotClassModel.h"
#import "CertificateModel.h"
#import "ScoreListModel.h"
#import "ScoreDetailModel.h"
#import "ClassListModel.h"
#import "InstitutionModel.h"
#import "ExaminationNoticeModel.h"
#import "ApplyListModel.h"

#import <AFNetworking.h>
#import "DefinedHost.h"

#import "DegreeNationalDataModel.h"

@interface KungfuManager()

@property(strong, nonatomic)AFHTTPSessionManager *manager;

@end

@implementation KungfuManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static KungfuManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
-(void)postHotCitySuccess:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure {
     NSString *url = [NSString stringWithFormat:@"%@%@",Found,KungFu_HotCity];
     [[NetworkingHandler sharedInstance] POSTHandle:url head:nil parameters:nil progress:nil success:success failure:failure];
}

-(void)classificationSuccess:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure {
     NSString *url = [NSString stringWithFormat:@"%@%@",Found,Activity_Classification];
     [[NetworkingHandler sharedInstance] POSTHandle:url head:nil parameters:nil progress:nil success:success failure:failure];
}

/*
* 分类查询适配活动 || 段 品阶 品查询适配活动
*/
- (void)activityList:(NSDictionary *)params Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure {
        NSString *url = [NSString stringWithFormat:@"%@%@",Found,Activity_ActivityList];
        [[NetworkingHandler sharedInstance] POSTHandle:url head:nil parameters:params progress:nil success:success failure:failure];
}


/// 活动分类
-(void)getClassification:(NSDictionary *)param callback:(NSArrayCallBack)call{
 
    [self.manager POST:MKURL(Found, Activity_Classification) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([ModelTool checkResponseObject:dic]) {
            
            NSArray *arr = [dic objectForKey:DATAS][DATAS];
            NSArray *dataList = [EnrollmentModel mj_objectArrayWithKeyValuesArray:arr];
            if (call) call(dataList);
        } else {
            if (call) call(nil);
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
    
}

/// 分类查询适配活动 || 段 品阶 品查询适配活动
-(void)getActivityList:(NSDictionary *)param callback:(NSArrayCallBack)call{
    [self.manager POST:MKURL(Found, Activity_ActivityList) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([ModelTool checkResponseObject:dic]) {
            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:DATAS];
            NSArray *dataList = [EnrollmentListModel mj_objectArrayWithKeyValuesArray:arr];
            
            NSInteger currentNum =[param[@"currentNum"] integerValue];
            NSInteger total = [dic[DATAS][@"total"] integerValue];
            if (currentNum >= total) {
                if (call) call(nil);
            }else{
                if (call) call(dataList);
            }
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

///段 、品、品阶
-(void)getLevelList:(NSDictionary *)param callbacl:(NSDictionaryCallBack)call{
    [self.manager POST:MKURL(Found, Activity_LEVEL_LEVELLIST) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
           if ([ModelTool checkResponseObject:dic]) {
               
               NSLog(@"dic %@",dic);
               NSDictionary *dataDic = dic[DATAS];
               NSArray *duanArray = dataDic[@"duan"];
               NSArray *fradeArray = dataDic[@"frade"];
               NSArray *pinArray = dataDic[@"pin"];
               
               NSArray *duanModelArray = [LevelModel mj_objectArrayWithKeyValuesArray:duanArray];
               NSArray *fradeModelArray = [LevelModel mj_objectArrayWithKeyValuesArray:fradeArray];
               NSArray *pinModelArray = [LevelModel mj_objectArrayWithKeyValuesArray:pinArray];
               
               NSMutableDictionary *allDic = [NSMutableDictionary dictionary];
               [allDic setValue:duanModelArray forKey:@"duan"];
               [allDic setValue:fradeModelArray forKey:@"frade"];
               [allDic setValue:pinModelArray forKey:@"pin"];
               
               for (LevelModel *model in duanModelArray) {
                   model.levelType = @"1";
                   [[ModelTool shareInstance]insert:model tableName:@"level"];
               }
               
               for (LevelModel *model in fradeModelArray) {
                   model.levelType = @"2";
                   [[ModelTool shareInstance]insert:model tableName:@"level"];
               }
               
               for (LevelModel *model in pinModelArray) {
                    model.levelType = @"3";
                   [[ModelTool shareInstance]insert:model tableName:@"level"];
               }
               
               if (call) call(allDic);
           } else {
               if (call) call (nil);
           }
       }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
           NSLog(@"error : %@", error);
           if (call) call(nil);
       }];
}

///检查筛查所适用报名的段位
-(void)activityCheckedLevel:(NSDictionary *)param callbacl:(NSObjectCallBack)call{
    
    NSString *url = [NSString stringWithFormat:@"%@?activityCode=%@", ADD(ACTIVITY_LEVEL_ACTIVITYCHECKEDLEVEL), param[@"activityCode"]];
    
    [self.manager POST:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([ModelTool checkResponseObject:dic]){
            
            NSDictionary *dataDic = [[dic objectForKey:DATAS] objectForKey:DATAS];
            
            EnrollmentListModel *model = [EnrollmentListModel mj_objectWithKeyValues:dataDic];
            if (call) call(model);
           
        }else{
            Message *message = [[Message alloc]init];
            message.isSuccess = NO;
            message.reason = dic[MSG];
            if (call) call(message);
        }
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (call) call(nil);
    }];
}

-(void)getHotClassListAndCallback:(NSArrayCallBack)call {
    [self.manager POST:MKURL(Found, KungFu_HotClass) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([ModelTool checkResponseObject:dic]) {
            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:LIST];
            NSArray *dataList = [HotClassModel mj_objectArrayWithKeyValuesArray:arr];
            if (call) call(dataList);
        } else {
            if (call) call(nil);
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}


-(void)getHotActivityListAndCallback:(NSArrayCallBack)call {
    
    [self.manager POST:MKURL(Found, KungFu_HotActivity) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([ModelTool checkResponseObject:dic]) {
            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:DATAS];
            NSArray *dataList = [EnrollmentListModel mj_objectArrayWithKeyValuesArray:arr];
            if (call) call(dataList);
        } else {
            if (call) call(nil);
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

- (void)getLevelAchievementsAndCallback:(NSDictionaryCallBack)call {
    [self.manager GET:MKURL(Found, KungFu_Achievements) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary * dataDic = [dic objectForKey:DATAS];
        call(dataDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

-(void)getCertificateAndCallback:(NSArrayCallBack)call {
    
    [self.manager GET:MKURL(Found, KungFu_Certificate) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray * dataList = [[dic objectForKey:DATAS] objectForKey:DATAS];
        NSArray * modelArray = [CertificateModel mj_objectArrayWithKeyValuesArray:dataList];
        
        if (call) call(modelArray);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

-(void)getApplicationCertificate:(NSDictionary *)param callback:(MessageCallBack)call {
    
    NSString *url = MKURL(Found, KungFu_ApplicationCertificate);
    [[NetworkingHandler sharedInstance] POSTHandle:url head:nil parameters:param progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        NSDictionary * dic = responseObject;
        
        Message *message = [[Message alloc] init];
        
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:dic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = dic[MSG];

        if (call) call(message);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

-(void)getScoreList:(NSDictionary *)params callback:(NSArrayCallBack)call {
    [self.manager GET:MKURL(Found, KungFu_ScoreList) parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([ModelTool checkResponseObject:dic]) {
            NSArray * dataList = [[dic objectForKey:DATAS] objectForKey:@"data"];
            NSArray * modelArray = [ScoreListModel mj_objectArrayWithKeyValuesArray:dataList];   
            if (call) call(modelArray);
        } else {
            if (call) call(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

//成绩详情查询
-(void)getScoreDetailWithParams:(NSDictionary *)params callbacl:(NSObjectCallBack)call {
    [self.manager GET:MKURL(Found, KungFu_ScoreDetail) parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([ModelTool checkResponseObject:dic]) {
            NSDictionary * dataDic = [dic objectForKey:DATAS];
            ScoreDetailModel *model = [ScoreDetailModel mj_objectWithKeyValues:dataDic];
            if (call) call(model);
        } else {
            if (call) call(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

-(void)getClassWithDic:(NSDictionary *)dic ListAndCallback:(NSArrayCallBack)call {
    [self.manager POST:MKURL(Found, KungFu_ClassList) parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
           
           
           if ([ModelTool checkResponseObject:dic]) {
               NSArray *arr = [[dic objectForKey:DATAS] objectForKey:LIST];
               NSArray *dataList = [ClassListModel mj_objectArrayWithKeyValuesArray:arr];
               if (call) call(dataList);
           } else {
               if (call) call(nil);
           }
       }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
           NSLog(@"error : %@", error);
           if (call) call(nil);
       }];
}

-(void)getInstitutionListWithDic:(NSDictionary *)dic ListAndCallback:(NSArrayCallBack)call {
    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, KungFu_InstitutionList) head:nil parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        if ([ModelTool checkResponseObject:responseObject]) {
            NSArray *arr = [[responseObject objectForKey:DATAS] objectForKey:DATAS];
            NSArray *dataList = [InstitutionModel mj_objectArrayWithKeyValuesArray:arr];
            NSInteger currentTotal = [dic[@"currentTotal"] integerValue];
            NSInteger total = [responseObject[DATAS][@"total"] integerValue];
            if (currentTotal>=total) {
                if (call) call(nil);
            }else{
                if (call) call(dataList);
            }
            
        } else {
            if (call) call(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

-(void)applicationsSaveWithDic:(NSDictionary *)dic callback:(MessageCallBack)call {
    
    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, KungFu_ApplicationsSave) head:nil parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary * dic;
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES) {
            dic = responseObject;
        }else{
           dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:dic]){
            isSuccess = YES;
            message.extensionDic = dic[DATAS][DATAS];
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = dic[MSG];

        if (call) call(message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

-(void)getMyapplicationsAndCallback:(NSArrayCallBack)call {
    
    [self.manager GET:MKURL(Found, KungFu_MyApplications) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([ModelTool checkResponseObject:dic]) {
            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:DATAS];
            NSArray *dataList = [ApplyListModel mj_objectArrayWithKeyValuesArray:arr];
            if (call) call(dataList);
        } else {
            if (call) call(nil);
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

-(void)getApplicationsDetailWithDic:(NSDictionary *)dic AndCallback:(NSDictionaryCallBack)call {
    
    [self.manager GET:MKURL(Found, KungFu_applicationsDetail) parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([ModelTool checkResponseObject:dic]) {
            NSDictionary *result = [dic objectForKey:DATAS];

            if (call) call(result);
        } else {
            if (call) call(nil);
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}


-(void)getSearchApplicationsListWithDic:(NSDictionary *)dic callback:(NSArrayCallBack)call {
    
    [self.manager GET:MKURL(Found, KungFu_applicationsSearch) parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([ModelTool checkResponseObject:dic]) {
            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:DATAS];
            NSArray *dataList = [ApplyListModel mj_objectArrayWithKeyValuesArray:arr];
            if (call) call(dataList);
        } else {
            if (call) call(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];

}

-(void)getExaminationNoticeListWithDic:(NSDictionary *)dic callback:(NSDictionaryCallBack)call {
    [self.manager GET:MKURL(Found, KungFu_examinationNotice) parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (call) call(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

-(void)getStartExaminationAndCallback:(NSDictionaryCallBack)call {
    [self.manager GET:MKURL(Found, KungFu_Examination) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (call) call(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

-(void)getSubmitExaminationWithDic:(NSDictionary *)dic callback:(NSDictionaryCallBack)call {
    [self.manager POST:MKURL(Found, KungFu_ExaminationSubmit) parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
    

        if (call) call(dic);
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}


-(void)getSaveExaminationWithDic:(NSDictionary *)dic callback:(MessageCallBack)call {
    
    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, KungFu_ExaminationSave) head:nil parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            
        if (call) call(nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

-(void)setCourseReadHistory:(NSDictionary *)dict callback:(NSDictionaryCallBack)call {
    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, KungFu_SetCourseReadHistory) head:nil parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if (call) call(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

-(void)getClassDetailWithDic:(NSDictionary *)dic callback:(NSDictionaryCallBack)call {
    [self.manager POST:MKURL(Found, KungFu_ClassDetail) parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([ModelTool checkResponseObject:dic]) {
            NSDictionary * result = [dic objectForKey:DATAS];
            if (call) call(result);
        } else {
            if (call) call(dic);
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

-(void)getClassCollectWithDic:(NSDictionary *)dic callback:(MessageCallBack)call {
    [self.manager POST:MKURL(Found, KungFu_ClassCollect) parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:dic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = dic[MSG];

        if (call) call(message);
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

- (void)postClassCancelCollectWithDic:(NSDictionary *)dic callback:(MessageCallBack)call{
    
}

-(void)mechanismSignUpWithDic:(NSDictionary *)dic callback:(MessageCallBack)call {
    
    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, KungFu_MECHANISM_MECHANISMSIGNUP) head:nil parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary * dic;
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES) {
            dic = responseObject;
        }else{
           dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:dic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = dic[MSG];

        if (call) call(message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}

///考试凭证
-(void)checkProof:(NSDictionary *)param callback:(NSDictionaryCallBack)call{
    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, URL_GET_USER_PAY_CHECKPROOF) head:nil parameters:param progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        NSDictionary * dic;
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES) {
            dic = responseObject;
        }else{
           dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if ([ModelTool checkResponseObject:dic]){
            NSDictionary *dataDic = dic[DATAS][DATAS];
            
           if (call) call(dataDic);
        } else {
           if (call) call(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"error : %@", error);
        call(nil);
    }];
}


-(void)getUserInfoWithOrderCode:(NSString *)orderCode callback:(NSDictionaryCallBack)call {
    
    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, KungFu_OrderDetailUserInfo) head:nil parameters:@{@"orderCode":orderCode} progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        NSDictionary * dic;
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES) {
            dic = responseObject;
        }else{
           dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if ([ModelTool checkResponseObject:dic]){
            NSDictionary *dataDic = dic[DATAS];
            
           if (call) call(dataDic);
        } else {
           if (call) call(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"error : %@", error);
        call(nil);
    }];
}

-(void)getVideoAuthWithVideoId:(NSString *)videoId callback:(NSDictionaryCallBack)call
{
    [self.manager GET:MKURL(Found, KungFu_VideoAuth) parameters:@{@"vodid":videoId} headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([ModelTool checkResponseObject:dic]){
            NSDictionary *dataDic = dic[DATAS];
            
           if (call) call(dataDic[DATAS]);
        } else {
           if (call) call(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        if (call) call(nil);
    }];
}


///获取 学历数组
-(void)getEducationDataCallback:(NSArrayCallBack)call{
    
    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, COMMON_EDUCATIONDATA) head:nil parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        NSDictionary * dic;
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES) {
            dic = responseObject;
        }else{
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if ([ModelTool checkResponseObject:dic]){
            NSDictionary *dataDic = dic[DATAS];
            
            NSArray *dataArray = [DegreeNationalDataModel mj_objectArrayWithKeyValuesArray: dataDic[DATAS]];
            
            if (call) call(dataArray);
        } else {
            if (call) call(nil);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"error : %@", error);
        call(nil);
    }];
    
}

///获取 民族数组
-(void)getNationDataCallback:(NSArrayCallBack)call{
    
    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, COMMON_NATIONDATA) head:nil parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        NSDictionary * dic;
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES) {
            dic = responseObject;
        }else{
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if ([ModelTool checkResponseObject:dic]){
            NSDictionary *dataDic = dic[DATAS];
            
            NSArray *dataArray = [DegreeNationalDataModel mj_objectArrayWithKeyValuesArray: dataDic[DATAS]];
            
            if (call) call(dataArray);
        } else {
            if (call) call(nil);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"error : %@", error);
        call(nil);
    }];
    
    
}


-(void)updateToken{
    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
    
    if (appInfoModel != nil && appInfoModel.access_token != nil) {
        [_manager.requestSerializer setValue:appInfoModel.access_token forHTTPHeaderField:@"token"];
    } else {
        [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
    }
    
    [_manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"cellphoneType"];
    [_manager.requestSerializer setValue:BUILD_STR forHTTPHeaderField:@"version"];
    [_manager.requestSerializer setValue:VERSION_STR forHTTPHeaderField:@"versionName"];
    [_manager.requestSerializer setValue:[SLAppInfoModel sharedInstance].deviceString forHTTPHeaderField:@"device-type"];
    
    NSString * systemStr = [NSString stringWithFormat:@"%.2f",SYSTEM_VERSION];
    [_manager.requestSerializer setValue:systemStr forHTTPHeaderField:@"SystemVersionCode"];
}


#pragma mark - gettet / setter
-(AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        //获取请求对象
        _manager= [AFHTTPSessionManager manager];
        // 设置请求格式
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置返回格式
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 返回数据解析类型
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//
//        [_manager.requestSerializer setValue:@"multipart/form-data;" forHTTPHeaderField:@"Content-Type"];
        
        _manager.requestSerializer.timeoutInterval = 60;
    }
    [self updateToken];
    [SLRequest refreshToken];
    return _manager;
}



@end
