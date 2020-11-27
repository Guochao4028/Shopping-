//
//  KungfuHomeCompilationSubCell.h
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KungfuHomeCompilationSubCell : UITableViewCell

@property (nonatomic, strong) ClassListModel * cellModel;
@property (weak, nonatomic) IBOutlet UIView *bottomCellLine;

@end

NS_ASSUME_NONNULL_END
