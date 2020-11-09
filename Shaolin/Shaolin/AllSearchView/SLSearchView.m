//
//  SLSearchView.m
//  Shaolin
//
//  Created by edz on 2020/3/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLSearchView.h"

#import "SearchHistoryModel.h"

@interface SLSearchView()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) UIView *searchHistoryView;
@property (nonatomic, strong) UIView *hotSearchView;

@end

@implementation SLSearchView
- (instancetype)initWithFrame:(CGRect)frame hotArray:(NSMutableArray *)hotArr historyArray:(NSMutableArray *)historyArr
{
    if (self = [super initWithFrame:frame]) {
        self.historyArray = historyArr;
        self.hotArray = hotArr;
        [self addSubview:self.searchHistoryView];
        [self addSubview:self.hotSearchView];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearHistory:) name:@"ClearHistory" object:nil];
       
    }
    return self;
}

- (void)clearHistory:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    
       [self.searchHistoryView removeFromSuperview];
       self.searchHistoryView = [self setNoHistoryView];
       [_historyArray removeAllObjects];
//       [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
    
    NSString *tabbarStr = userInfo[@"tabbarStr"];
    BOOL isRite = [userInfo[@"isRite"] boolValue];
    
    SearchHistoryType type;
    if ([tabbarStr isEqualToString:@"Activity"]) {
        if (isRite) {
            type = SearchHistoryRiteClassroomType;
        }else{
            type = SearchHistoryRiteCharityType;
        }
    }else if([tabbarStr isEqualToString:@"Found"]){
        type = SearchHistoryArticleType;
    }else{
        type = 0;
    }
    
    NSString *userId = [SLAppInfoModel sharedInstance].id;
    [[ModelTool shareInstance]deleteTableName:@"searchHistory" where:[NSString stringWithFormat:@"userId = '%@' AND type = '%ld' ", userId, type]];
    
    
    
       [self addSubview:self.searchHistoryView];
       CGRect frame = _hotSearchView.frame;
       frame.origin.y = CGRectGetHeight(_searchHistoryView.frame);
       _hotSearchView.frame = frame;
}


- (UIView *)hotSearchView
{
    if (!_hotSearchView) {
        if (self.hotArray.count == 0) {
             self.hotSearchView = [self setViewWithOriginY:CGRectGetHeight(_searchHistoryView.frame) title:@"" textArr:self.hotArray];
        }else {
              self.hotSearchView = [self setViewWithOriginY:CGRectGetHeight(_searchHistoryView.frame) title:SLLocalizedString(@"热词搜索") textArr:self.hotArray];
        }
            
        
      
    }
    return _hotSearchView;
}


- (UIView *)searchHistoryView
{
    if (!_searchHistoryView) {
        if (_historyArray.count > 0) {
            self.searchHistoryView = [self setViewWithOriginY:0 title:SLLocalizedString(@"搜索历史") textArr:self.historyArray];
        } else {
            self.searchHistoryView = [self setNoHistoryView];
        }
    }
    return _searchHistoryView;
}



- (UIView *)setViewWithOriginY:(CGFloat)riginY title:(NSString *)title textArr:(NSMutableArray *)textArr
{
    UIView *view = [[UIView alloc] init];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(15), SLChange(11), SLChange(16))];
    if (textArr.count == 0) {
         image.image = [UIImage imageNamed:@""];
    }else {
         image.image = [UIImage imageNamed:@"rot_search"];
    }
   
    
   
    [view addSubview:image];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(SLChange(35), SLChange(15), kWidth - SLChange(95), SLChange(16))];
    titleL.text = title;
    titleL.font = kMediumFont(16);
    
    titleL.textColor = [UIColor hexColor:@"333333"];
    titleL.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleL];
    
    if ([title isEqualToString:SLLocalizedString(@"搜索历史")]) {
        image.frame = CGRectMake(11, SLChange(15), 17, 17);
         image.image = [UIImage imageNamed:@"history_search"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kWidth - 45, SLChange(10), 28, 30);
        [btn setImage:[UIImage imageNamed:@"sort_recycle"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearnSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    CGFloat y = SLChange(15) + SLChange(40);
    CGFloat letfWidth = SLChange(15);
    for (int i = 0; i < textArr.count; i++) {
        NSString *text;
        
        if ([title isEqualToString:SLLocalizedString(@"搜索历史")]) {
            text = [self subModelTextString:textArr[i] len:6];
        }else{
            text = [self subTextString:textArr[i] len:6];
        }
        
        
        CGFloat width = [self getWidthWithStr:text] + SLChange(35);
        if (letfWidth + width + SLChange(15) > kWidth) {
            if (y >= SLChange(130) && [title isEqualToString:SLLocalizedString(@"搜索历史")]) {
                [self removeTestDataWithTextArr:textArr index:i];
                break;
            }
            y += SLChange(40);
            letfWidth = SLChange(15);
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(letfWidth, y, width, SLChange(35))];
        label.userInteractionEnabled = YES;
        label.font = [UIFont systemFontOfSize:15];
        label.text = text;
        label.backgroundColor = RGBA(243, 243, 243, 1);
        label.layer.cornerRadius = SLChange(35)/2;
        label.layer.borderWidth = 1;
        label.layer.borderColor = RGBA(243, 243, 243, 1).CGColor;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorForHex:@"333333"];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [view addSubview:label];
        letfWidth += width + SLChange(10);
    }
    view.frame = CGRectMake(0, riginY, kWidth, y + SLChange(40));
    return view;
}

-(NSString*)subTextString:(NSString*)str len:(NSInteger)len{
    if(str.length<=len)return str;
    int count=0;
    NSMutableString *sb = [NSMutableString string];

    for (int i=0; i<str.length; i++) {
        NSRange range = NSMakeRange(i, 1) ;
        NSString *aStr = [str substringWithRange:range];
        count += [aStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>1?2:1;
        [sb appendString:aStr];
        if(count >= len*2) {
            return (i==str.length-1)?[sb copy]:[NSString stringWithFormat:@"%@...",[sb copy]];

        }
    }
    return str;
}

-(NSString*)subModelTextString:(SearchHistoryModel*)model len:(NSInteger)len{
    NSString *searchContent = model.searchContent;
    if (searchContent.length<=len) return searchContent;
    int count=0;
    NSMutableString *sb = [NSMutableString string];
    for (int i=0; i<searchContent.length; i++) {
        NSRange range = NSMakeRange(i, 1) ;
        NSString *aStr = [searchContent substringWithRange:range];
        count += [aStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>1?2:1;
        [sb appendString:aStr];
        if(count >= len*2) {
            return (i==searchContent.length-1)?[sb copy]:[NSString stringWithFormat:@"%@...",[sb copy]];

        }
    }
    return searchContent;
}

- (UIView *)setNoHistoryView
{
    UIView *historyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, SLChange(80))];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(11, SLChange(15), 17, 17)];
    image.image = [UIImage imageNamed:@"history_search"];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(SLChange(35), SLChange(15), kWidth - SLChange(50), SLChange(16))];
    titleL.text = SLLocalizedString(@"搜索历史");
    titleL.font = kMediumFont(16);
    titleL.textColor = [UIColor hexColor:@"333333"];
    titleL.textAlignment = NSTextAlignmentLeft;
    
    UILabel *notextL = [[UILabel alloc] initWithFrame:CGRectMake(SLChange(35), CGRectGetMaxY(titleL.frame) + SLChange(20), SLChange(100), SLChange(20))];
    notextL.text = SLLocalizedString(@"无搜索历史");
    notextL.font = [UIFont systemFontOfSize:15];
    notextL.textColor = RGBA(113, 113, 113, 1);
    notextL.textAlignment = NSTextAlignmentLeft;
    [historyView addSubview:image];
    [historyView addSubview:titleL];
    [historyView addSubview:notextL];
    return historyView;
}
- (BOOL)isValidateName:(NSString *)name{
      NSUInteger character = 0;
      for(int i=0; i< [name length];i++){
           int a = [name characterAtIndex:i];
           if( a >= 0x4e00 && a <= 0x9fff) { //判断是否为中文
              character +=2;
            } else {
               character +=1;
            }
      }

      if (character >=6 && character <=12) {
            return YES;
      } else {
              return NO;
      }

}

- (void)tagDidCLick:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    if (self.tapAction) {
        self.tapAction(label.text);
    }
}
-(NSUInteger)textLength: (NSString *) text{

    NSUInteger asciiLength = 0;

    for (NSUInteger i = 0; i < text.length; i++) {


        unichar uc = [text characterAtIndex: i];

        asciiLength += isascii(uc) ? 1 : 2;
    }

    NSUInteger unicodeLength = asciiLength;

    return unicodeLength;

}
- (NSInteger)getToInt:(NSString*)strtemp

{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}
- (CGFloat)getWidthWithStr:(NSString *)text
{
//    BOOL isWidth = [self isValidateName:text];
//    NSLog(@"%d",isWidth);
    NSLog(@"%ld",[self textLength:text]);
    CGFloat width = [text boundingRectWithSize:CGSizeMake(kWidth, SLChange(40)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.width;
//    NSLog(@"%f",width);
    if (width > 73.6) {
        width = 83;
        return width;
    }else {
        return width;
    }
    
}


- (void)clearnSearchHistory:(UIButton *)sender
{
    if (self.ClearHistoryBlock) {
        self.ClearHistoryBlock();
    }
   
}

- (void)removeTestDataWithTextArr:(NSMutableArray *)testArr index:(int)index
{
//    NSRange range = {index, testArr.count - index - 1};
//    [testArr removeObjectsInRange:range];
//    [NSKeyedArchiver archiveRootObject:testArr toFile:KHistorySearchPath];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
