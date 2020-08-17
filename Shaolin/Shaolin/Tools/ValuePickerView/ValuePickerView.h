//
//  ValuePickerView.h
//  Shaolin
//
//  Created by edz on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ValuePickerView : UIView
/**Picker的标题*/
@property (nonatomic, copy) NSString * pickerTitle;

/**滚轮上显示的数据(必填,会根据数据多少自动设置弹层的高度)*/
@property (nonatomic, strong) NSArray * dataSource;

/**设置默认选项,格式:选项文字/id (先设置dataArr,不设置默认选择第0个)*/
@property (nonatomic, strong) NSString * defaultStr;

/**回调选择的状态字符串(stateStr格式:state/row)*/
@property (nonatomic, copy) void (^valueDidSelect)(NSString * value);

/**显示时间弹层*/
- (void)show;

-(void)selectedRowInComponent:(NSInteger)rowNumber;

@property (nonatomic ,strong) UIButton * finishBtn;      //取消按钮
@property (nonatomic ,strong) UIButton * cancelBtn;      //取消按钮

@end

NS_ASSUME_NONNULL_END
