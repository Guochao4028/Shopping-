//
//  KfReceiveCerView.h
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CertificateModel;
@interface KfReceiveCerView : UIView

@property (nonatomic, copy) void(^ closeHandle)(void);
@property (nonatomic, copy) void(^ chooseHandle)(NSDictionary *params);

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (nonatomic, strong) CertificateModel *model;
//@property (nonatomic, copy) void(^ inputBlock)(NSString * name, NSString * phone, NSString * address);

- (void)resignFirstResponder;
@end

NS_ASSUME_NONNULL_END
