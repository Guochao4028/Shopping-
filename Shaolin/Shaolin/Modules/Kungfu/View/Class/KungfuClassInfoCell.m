//
//  KungfuClassInfoCell.m
//  Shaolin
//
//  Created by ws on 2020/5/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuClassInfoCell.h"
#import "ClassDetailModel.h"
#import "YYText.h"

@interface KungfuClassInfoCell()

@property (nonatomic, strong) YYLabel   * contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

- (IBAction)tapMoreAction:(UIButton *)sender;

@property (nonatomic , copy) NSString * contentString;

@end

@implementation KungfuClassInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contentView addSubview:self.contentLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [YYLabel new];
        _contentLabel.frame = CGRectMake(16, 70, [UIScreen mainScreen].bounds.size.width - 32, 45);
        _contentLabel.numberOfLines = 2;
        _contentLabel.textColor = KTextGray_999;
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return _contentLabel;
}

- (void)setModel:(ClassDetailModel *)model{
    _model = model;
//    NSString *timeStr = [ModelTool calculatedTimeWith:CalculatedTimeTypeDonotSecond secondStr:model.weight];
    
    
    NSInteger time = [model.weight integerValue];
    NSInteger minute = time/60;
    NSInteger seconds = time%60;
    
    if (seconds > 30) {
        minute += 1;
    }
    
    if (minute == 0) {
        minute = 1;
    }
    
    NSString *timeStr = [NSString stringWithFormat:SLLocalizedString(@"%ld 分钟"), minute];
    
    self.timeLabel.text = model ? timeStr : @"";
    self.recommendLabel.text = model ? model.desc : @"";
    self.levelLabel.text = model ? model.level_name : @"";
    //    NSString * contentStr = [self removeTheHtmlFromString:NotNilAndNull(model.intro)?model.intro:@""];
//    self.contentLabel.attributedText = [self converattrStringWith:model.intro];
    
    self.contentLabel.text = [self filterHTML:model.intro];
    //    self.contentLabel.text = @" scanner = [NSScanner scannerWit scanner = [NSScanner scannerWit scanner = [NSScanner scannerWit scanner = [NSScanner scannerWit scanner = [NSScanner scannerWit scanner = [NSScanner scannerWit scanner = [NSScanner scannerWit";
}

//- (NSAttributedString *)converattrStringWith:(NSString *)string {
//
//    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
//    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
//    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
//    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
//    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
//    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
//
//    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//
//    return attrStr;
//}
- (NSString *)filterHTML:(NSString *)html{
    NSDictionary *dic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSData *data = [html dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *attriStr = [[NSAttributedString alloc] initWithData:data options:dic documentAttributes:nil error:nil];
    NSString *str = attriStr.string;
    //str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return str;
    
}

- (void)addSeeMoreButtonWithContentStr:(NSString *)str {
    UIFont *font16 = [UIFont systemFontOfSize:14];
    self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : font16,NSForegroundColorAttributeName:KTextGray_999}];
    
    NSString *moreString = SLLocalizedString(@" 更多");
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"... %@", moreString]];
    NSRange expandRange = [text.string rangeOfString:moreString];
    
    [text addAttribute:NSForegroundColorAttributeName value:KTextGray_999 range:expandRange];
    [text addAttribute:NSForegroundColorAttributeName value:KTextGray_999 range:NSMakeRange(0, expandRange.location)];
    
    //添加点击事件
    YYTextHighlight *hi = [YYTextHighlight new];
    [text yy_setTextHighlight:hi range:[text.string rangeOfString:moreString]];
    
    
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击展开
        NSLog(@"查看更多按钮");
        if (self.moreHandle) {
            self.moreHandle();
        }
    };
    
    text.yy_font = font16;
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.yy_font alignment:YYTextVerticalAlignmentTop];
    
    self.contentLabel.truncationToken = truncationToken;
}



- (IBAction)tapMoreAction:(UIButton *)sender {
    NSLog(@"查看更多按钮");
    if (self.moreHandle) {
        self.moreHandle();
    }
}
@end
