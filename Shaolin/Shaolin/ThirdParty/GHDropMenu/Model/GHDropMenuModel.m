//
//  GHDropMenuModel.m
//  GHDropMenuDemo
//
//  Created by zhaozhiwei on 2019/1/4.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "GHDropMenuModel.h"
#import "NSArray+Bounds.h"
#import "NSString+Arc4random.h"

#import "LevelModel.h"

@implementation GHDropMenuModel

- (NSArray *)creaFilterDropMenuData {
    
    
    //    /** 构造右侧弹出筛选菜单第一行数据 */
    
    NSArray *duanArray = [[ModelTool shareInstance] select:[LevelModel class] tableName:@"level" where:@"levelType = 1"];
    
    NSMutableArray *duanRow = [NSMutableArray array];
    
    for (LevelModel *model in duanArray) {
        GHDropMenuModel *dropMenuModel = [[GHDropMenuModel alloc]init];
        dropMenuModel.tagName = model.name;
        dropMenuModel.model = model;
        dropMenuModel.isMultiple = YES;
        dropMenuModel.levelType = @"1";
        dropMenuModel.optionSeletedColor = kMainYellow;
        [duanRow addObject:dropMenuModel];
    }
    
    //    for (NSInteger index = 0 ; index < duanArray.count; index++) {
    //        GHDropMenuModel *dropMenuModel = [[GHDropMenuModel alloc]init];
    //
    //        NSDictionary *dic = [duanArray objectAtIndex:index];
    //
    //        LevelModel *model = [LevelModel mj_objectWithKeyValues:dic];
    //
    //        model.levelId = dic[@"levelId"];
    //
    //        dropMenuModel.tagName = model.name;
    //        dropMenuModel.model = model;
    //        dropMenuModel.isMultiple = YES;
    //        dropMenuModel.levelType = @"1";
    //        dropMenuModel.optionSeletedColor = [UIColor colorForHex:@"BE0000"];
    //        [duanRow addObject:dropMenuModel];
    //    }
    
    
    
    NSArray *pinArray = [[ModelTool shareInstance] select:[LevelModel class] tableName:@"level" where:@"levelType = 3"];
    NSMutableArray *pinRow = [NSMutableArray array];
    
    for (LevelModel *model in pinArray) {
        GHDropMenuModel *dropMenuModel = [[GHDropMenuModel alloc]init];
        dropMenuModel.tagName = model.name;
        dropMenuModel.model = model;
        dropMenuModel.isMultiple = YES;
        dropMenuModel.levelType = @"3";
        dropMenuModel.optionSeletedColor = [UIColor colorForHex:@"BE0000"];
        [pinRow addObject:dropMenuModel];
    }
    
    
    //    for (NSInteger index = 0 ; index < pinArray.count; index++) {
    //        GHDropMenuModel *dropMenuModel = [[GHDropMenuModel alloc]init];
    //
    //        NSDictionary *dic = [pinArray objectAtIndex:index];
    //
    //        LevelModel *model = [LevelModel mj_objectWithKeyValues:dic];
    //        model.levelId = dic[@"levelId"];
    //
    //        dropMenuModel.tagName = model.name;
    //        dropMenuModel.model = model;
    //        dropMenuModel.isMultiple = YES;
    //        dropMenuModel.levelType = @"3";
    //        dropMenuModel.optionSeletedColor = [UIColor colorForHex:@"BE0000"];
    //        [pinRow addObject:dropMenuModel];
    //    }
    
    NSArray *pinjieArray = [[ModelTool shareInstance] select:[LevelModel class] tableName:@"level" where:@"levelType = 2"];
    NSMutableArray *pinjieRow = [NSMutableArray array];
    
    
    for (LevelModel *model in pinjieArray) {
        GHDropMenuModel *dropMenuModel = [[GHDropMenuModel alloc]init];
        dropMenuModel.isMultiple = YES;
        dropMenuModel.tagName = model.name;
        dropMenuModel.model = model;
        dropMenuModel.levelType = @"2";
        dropMenuModel.optionSeletedColor = [UIColor colorForHex:@"BE0000"];
        //               dropMenuModel.tagName = [qwe by_ObjectAtIndex:index];
        
        [pinjieRow addObject:dropMenuModel];
    }
    
    
    //    for (NSInteger index = 0 ; index < pinjieArray.count; index++) {
    //        GHDropMenuModel *dropMenuModel = [[GHDropMenuModel alloc]init];
    //        NSDictionary *dic = [pinjieArray objectAtIndex:index];
    //
    //        LevelModel *model = [LevelModel mj_objectWithKeyValues:dic];
    //        model.levelId = dic[@"levelId"];
    //        dropMenuModel.isMultiple = YES;
    //        dropMenuModel.tagName = model.name;
    //        dropMenuModel.model = model;
    //         dropMenuModel.levelType = @"2";
    //        dropMenuModel.optionSeletedColor = [UIColor colorForHex:@"BE0000"];
    //        //               dropMenuModel.tagName = [qwe by_ObjectAtIndex:index];
    //
    //        [pinjieRow addObject:dropMenuModel];
    //    }
    
    NSArray *statusArray = @[SLLocalizedString(@"未开始"), SLLocalizedString(@"进行中"), SLLocalizedString(@"已结束")];
    NSMutableArray *statusRow = [NSMutableArray array];
    for (NSInteger index = 0 ; index < statusArray.count; index++) {
        GHDropMenuModel *dropMenuModel = [[GHDropMenuModel alloc]init];
        
        dropMenuModel.tagName = [statusArray by_ObjectAtIndex:index];
        dropMenuModel.isMultiple = YES;
        dropMenuModel.levelType = @"4";
        dropMenuModel.optionSeletedColor = [UIColor colorForHex:@"BE0000"];
        [statusRow addObject:dropMenuModel];
    }
    
    //    /** 构造右侧弹出筛选菜单第二行数据 */
    
    //    /** 设置构造右侧弹出筛选菜单每行的标题 */
    NSArray *sectionHeaderTitles = @[SLLocalizedString(@"段"),SLLocalizedString(@"品"),SLLocalizedString(@"品阶"),SLLocalizedString(@"活动状态")];
    NSMutableArray *sections = [NSMutableArray array];
    //
    for (NSInteger index = 0; index < sectionHeaderTitles.count; index++) {
        GHDropMenuModel *dropMenuModel = [[GHDropMenuModel alloc]init];
        dropMenuModel.sectionHeaderTitle = sectionHeaderTitles[index];
        dropMenuModel.optionSeletedColor = [UIColor colorForHex:@"BE0000"];
        dropMenuModel.filterCellType = GHDropMenuFilterCellTypeTag;
        
        if (index == 0) {
            dropMenuModel.sectionSeleted = YES;
            dropMenuModel.isMultiple = YES;
            dropMenuModel.dataArray = duanRow;
        }
        
        if (index == 1) {
            dropMenuModel.sectionSeleted = YES;
            dropMenuModel.isMultiple = YES;
            dropMenuModel.dataArray = pinRow;
        }
        
        if (index == 2) {
            dropMenuModel.sectionSeleted = NO;
            
            [[ModelTool shareInstance] setIsScreeningSpread:dropMenuModel.sectionSeleted];
            
            dropMenuModel.isMultiple = YES;
            dropMenuModel.dataArray = pinjieRow;
        }
        
        if (index == 3) {
            dropMenuModel.sectionSeleted = YES;
            dropMenuModel.isMultiple = YES;
            dropMenuModel.isSectionSeletedHidden = YES;
            dropMenuModel.dataArray = statusRow;
            
        }
        
        [sections addObject:dropMenuModel];
    }
    NSMutableArray *titlesArray = [NSMutableArray array];
    
    /** 菜单标题 */
    GHDropMenuModel *dropMenuModel = [[GHDropMenuModel alloc]init];
    NSNumber *typeNum = @(GHDropMenuTypeFilter);
    dropMenuModel.dropMenuType = typeNum.integerValue;
    dropMenuModel.sectionCount = 3.01f;
    dropMenuModel.menuWidth = [UIScreen mainScreen].bounds.size.width * 0.9;
    
    dropMenuModel.sections = sections;
    
    dropMenuModel.sectionCount = 3.01f;
    
    dropMenuModel.identifier = 0 ;//index;
    [titlesArray addObject:dropMenuModel];
    
    
    NSString *temp = NSTemporaryDirectory();
    NSString *filePath = [temp stringByAppendingPathComponent:@"temp.temp"];
    
    [NSKeyedArchiver archiveRootObject:titlesArray  toFile:filePath];
    
    
    
    
    return titlesArray;
}



#pragma mark - 归档,解档
// 归档
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder{
    // c语言特点：函数的参数如果是基本数据类型，基本是需要函数内部修改他的值
       // 申明一个变量，便于内部将内部参数数量返回给count
       unsigned int count = 0;
       // C语言函数带有copy字样会在堆内存开辟一块空间 此区域ARC不管  需要手动释放！！
       Ivar *ivars = class_copyIvarList([self class], &count);
       for (int i = 0; i < count; i++) {
           // 拿到ivar
           Ivar ivar = ivars[i];
           const char *name = ivar_getName(ivar);
           
           NSString *key = [NSString stringWithUTF8String:name];
           
           [aCoder encodeObject:[self valueForKey:key] forKey:key];
       }
       free(ivars);
}

// 解档
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder{
    if (self = [super init]) {
        
        unsigned int count = 0;
        
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            // 拿到ivar
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            
            // 解档
            id value = [aDecoder decodeObjectForKey:key];
            // kvc 赋值
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return  self;
}









@end
