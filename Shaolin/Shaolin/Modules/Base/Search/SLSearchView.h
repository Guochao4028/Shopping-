//
//  SLSearchView.h
//  Shaolin
//
//  Created by edz on 2020/3/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TapActionBlock)(NSString *str);
@interface SLSearchView : UIView
@property (nonatomic, copy) TapActionBlock tapAction;
@property (nonatomic,copy) void (^ClearHistoryBlock)(void);
@property(nonatomic,strong) NSString *typeStr;
- (instancetype)initWithFrame:(CGRect)frame hotArray:(NSMutableArray *)hotArr historyArray:(NSMutableArray *)historyArr;
@end


