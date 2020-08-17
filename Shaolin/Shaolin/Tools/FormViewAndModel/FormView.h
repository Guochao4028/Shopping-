//
//  FormView.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FormViewModel, SimpleModel;
@interface FormView : UIView
@property (nonatomic, strong) NSArray <FormViewModel *> *datas;

/*! 表单内frame改变后会调用该block*/
@property (nonatomic, copy) void(^formViewSizeChangeBlock)(void);
/*! 表单内数据修改后会调用该block*/
@property (nonatomic, copy) void(^formViewDataChangeBlock)(FormViewModel *model, SimpleModel *simpleModel);

@property (nonatomic, strong) UIColor *secondBackColor;
@property (nonatomic, strong) UIFont *labtlFont;

- (instancetype)initWithDatas:(NSArray <FormViewModel *> *)datas;
- (FormViewModel *)getFormViewModel:(NSString *)identifier;
- (FormViewModel *)getFormViewModelBySimpleModel:(NSString *)identifier;
- (SimpleModel *)getSimpleModelByFormModel:(FormViewModel *)formModel identifier:(NSString *)identifier;

- (void)reloadSubviewByFormModel:(FormViewModel *)formModel;
/*! 设置datas后需要调用该方法重新生成表单*/
- (void)reloadView;
/*! 如果datas有修改，可以调用该方法刷新*/
- (void)reloadViewForChange;

/*! 检查所有必填项是否都以填写完毕, return YES为全部填写*/
- (BOOL) checkoutForcedInput;

/*! 获取表单数据*/
- (NSDictionary *)getParams;
@end



NS_ASSUME_NONNULL_END
