//
//  KfCertificateCell.h
//  Shaolin
//
//  Created by ws on 2020/5/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CertificateModel;
@interface KfCertificateCell : UITableViewCell

@property (nonatomic, copy) void(^ detailHandle)(void);
@property (nonatomic, copy) void(^ receiveHandle)(NSInteger status);
@property (nonatomic, strong) CertificateModel * cellModel;

@end

NS_ASSUME_NONNULL_END
