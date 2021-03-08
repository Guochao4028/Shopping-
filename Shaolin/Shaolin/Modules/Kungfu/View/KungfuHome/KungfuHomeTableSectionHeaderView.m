//
//  KungfuHomeTableSectionHeaderView.m
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuHomeTableSectionHeaderView.h"

@interface KungfuHomeTableSectionHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;
@property (weak, nonatomic) IBOutlet UIButton *tapBtn;


@end

@implementation KungfuHomeTableSectionHeaderView


- (IBAction)sectionBtnHandle:(UIButton *)sender {
    if (self.sectionViewHandle) {
        self.sectionViewHandle();
    }
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    
    self.titleLabel.text = titleString;
}

- (void)setArrowHidden:(BOOL)arrowHidden {
    _arrowHidden = arrowHidden;
    
    self.arrowIcon.hidden = arrowHidden;
    
    self.pointImgv.hidden = arrowHidden;
    self.lineImgv.hidden = arrowHidden;
}

@end
