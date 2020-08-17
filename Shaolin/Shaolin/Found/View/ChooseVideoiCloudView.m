//
//  ChooseVideoiCloudView.m
//  Shaolin
//
//  Created by ws on 2020/7/16.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ChooseVideoiCloudView.h"

@implementation ChooseVideoiCloudView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)downloadBtnHandle:(UIButton *)sender {
    if (self.downloadBlock) {
        self.downloadBlock();
    }
}

@end
