//
//  FoundAddView.h
//  Shaolin
//
//  Created by edz on 2020/3/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FoundAddView : UIView
- (void)showView;
@property (nonatomic,copy) void (^ChooseBlock)(NSInteger i);
@end
