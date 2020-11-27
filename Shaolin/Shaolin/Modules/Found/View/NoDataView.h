//
//  NoDataView.h
//  Shaolin
//
//  Created by edz on 2020/4/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface NoDataView : UIView
@property (nonatomic,copy) void (^RefreshBlock)();
@end


