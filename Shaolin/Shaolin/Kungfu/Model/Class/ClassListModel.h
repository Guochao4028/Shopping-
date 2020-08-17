//
//  ClassListModel.h
//  Shaolin
//
//  Created by ws on 2020/5/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassListModel : NSObject


@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * classId;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * level;
@property (nonatomic, copy) NSString * weight;
@property (nonatomic, copy) NSString * user_num;
@property (nonatomic, copy) NSString * level_name;
@property (nonatomic, copy) NSString * desc2;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * old_price;




//"id": 53,课程id <number>
//"name": "罗汉拳",课程名称 <string>
//"cover": "https://static.oss.cdn.oss.gaoshier.cn/image/bfc3bc7a-0037-43ca-85f8-4d8cac760226.png",课程封面图 <string>
//"level": 1,课程级别 <number>
//"weight": "10",时长 <string>
//"user_num": 0,购买人数 <number>
//"level_name": "一段",课程名称 <string>
//"desc2": "不知道",简介 <string>
//"price": "10.00",价格 <string>
//"old_price": "0.00"... <string>

@end

NS_ASSUME_NONNULL_END
