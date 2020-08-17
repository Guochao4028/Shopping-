//
//  ContentEditFooterView.m
//  KCWC
//
//  Created by Eleven on 2018/2/8.
//  Copyright © 2018年 HAWK. All rights reserved.
//

#import "ContentEditFooterView.h"
#import "ERichTextEditorView.h"

static CGFloat const kFooterH = 47;

@implementation ContentEditFooterView
{
    UIView *_footerView;
    ERichTextEditorView *_editorView;
}

- (instancetype)initWithFrame:(CGRect)frame editView:(ERichTextEditorView *)editView {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HexColorInt32_t(f8f8f8);
        _editorView = editView;
        [self setupSubviws];
    }
    return self;
}

- (void)setupSubviws {
    _footerView = ({
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kFooterH)];
        [self addSubview:footerView];
        
        NSArray *icons = @[@"icon_picture", @"icon_Aa", @"icon_cexiao", @""];
        CGFloat width = SCREEN_WIDTH / icons.count;
        for (NSInteger i = 0; i < icons.count; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 0, width, kFooterH)];
            [button setImage:EImageNamed(icons[i]) forState:UIControlStateNormal];
            button.tag = 200 + i;
            [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:button];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = HexColorInt32_t(e0e0e0);
        [footerView addSubview:line];
        
        footerView;
    });
    
    ERichTextToolBar *toolBar = [[ERichTextToolBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 47) editView:_editorView];
    toolBar.hidden = YES;
    _toolBar = toolBar;
    [self addSubview:toolBar];
}

- (void)click:(UIButton *)button {
    switch (button.tag - 200) {
        case 0:
            BLOCK_SAFE_RUN(self.pictureBlock);
            break;
        case 1:
        {
            if (self.height == 47) {
                self.height += 47;
                self.y -= 47;
                _toolBar.hidden = NO;
            } else {
                _toolBar.hidden = YES;
                self.height -= 47;
                self.y += 47;
                
            }
            _footerView.y = self.height- kFooterH;
        }
            break;
       
        case 2:
            [_editorView undo];
            BLOCK_SAFE_RUN(self.cancelBlock);
            break;
//        case 3:
//            BLOCK_SAFE_RUN(self.tagBlock);
//            break;
        default:
            break;
    }
}

@end
