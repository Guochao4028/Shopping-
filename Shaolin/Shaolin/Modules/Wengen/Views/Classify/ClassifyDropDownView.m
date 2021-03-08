//
//  ClassifyDropDownView.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 分类 -> 弹出菜单

#import "ClassifyDropDownView.h"

#import "LGFOCTool.h"

#import "ClassifyDropDownTableCell.h"

#import "WengenEnterModel.h"

static NSString *const kClassifyDropDownTableCellIdentifier = @"ClassifyDropDownTableCell";

@interface ClassifyDropDownView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UIImageView *dropDownBGImageView;


@property(nonatomic, strong)UITableView *contentTabelView;

@end

@implementation ClassifyDropDownView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.dropDownBGImageView];
    
    [self.dropDownBGImageView addSubview:self.contentTabelView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissView];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = KTextGray_FA;
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 40;
   
    return tableViewH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassifyDropDownTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kClassifyDropDownTableCellIdentifier];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for (WengenEnterModel *item in self.dataArray) {
        item.isSelected = NO;
    }
    
    WengenEnterModel *model = self.dataArray[indexPath.row];
    model.isSelected = YES;
    
    if (self.selectedBlock) {
        NSLog(@"self.selectedBlock");
        self.selectedBlock(model);
    }
    
    [self dismissView];
}

- (void)dismissView
{
   
    __weak typeof(self)weakSelf =self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        
        if (self.selectedBlock) {
            self.selectedBlock(nil);
        }
        [weakSelf removeFromSuperview];
        [self removeFromSuperview];
    }];
}



#pragma mark - setter / getter

- (UIImageView *)dropDownBGImageView{
    if (_dropDownBGImageView == nil) {
        //状态栏高度
        CGFloat barHeight ;
        /** 判断版本
         获取状态栏高度
         */
        if (@available(iOS 13.0, *)) {
            barHeight = [[[[[UIApplication sharedApplication] keyWindow] windowScene] statusBarManager] statusBarFrame].size.height;
        } else {
            barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        }
        _dropDownBGImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, barHeight+60, ScreenWidth, 300)];
//        [_dropDownBGImageView setImage:[UIImage imageNamed:@"dropDown"]];
//        _dropDownBGImageView.layer.masksToBounds = YES;
//        _dropDownBGImageView.contentMode =  UIViewContentModeScaleToFill;
        
        [_dropDownBGImageView setUserInteractionEnabled:YES];
    }
    return _dropDownBGImageView;
}

- (UITableView *)contentTabelView{
    if (_contentTabelView == nil) {
        _contentTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, ScreenWidth, 170-30)];
        
        [_contentTabelView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassifyDropDownTableCell class])bundle:nil] forCellReuseIdentifier:kClassifyDropDownTableCellIdentifier];
        
        [_contentTabelView setDelegate:self];
        [_contentTabelView setDataSource:self];
        [_contentTabelView setBackgroundColor:[UIColor whiteColor]];
        
        _contentTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _contentTabelView;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
//    if (dataArray.count < 3) {
//        self.contentTabelView.lgf_height = dataArray.count *40;
//        self.dropDownBGImageView.lgf_height = dataArray.count *40;
//        NSLog(@"%lu", dataArray.count *40);
//    }
    
    if ([dataArray count] < 9) {
        self.contentTabelView.mj_h = [dataArray count] * 40;
    }else{
        self.contentTabelView.mj_h = 9 * 40;
    }
    
    
    
    
    
    [self.contentTabelView reloadData];
    
}


- (void)setStarPoint:(CGPoint)starPoint{
    _starPoint = starPoint;
    [self.dropDownBGImageView setX:1];
    [self.dropDownBGImageView setY:starPoint.y];
}




@end
