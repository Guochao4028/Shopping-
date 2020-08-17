//
//  NewActivityViewController.m
//  Shaolin
//
//  Created by edz on 2020/4/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "NewActivityViewController.h"

#import "ActivityManager.h"
#import "AllSearchViewController.h"
@interface NewActivityViewController ()
@property(nonatomic,strong) NSMutableArray *dataArr;
@property(nonatomic,strong) NSMutableArray *nameArr;
@end

@implementation NewActivityViewController
-(NSMutableArray *)nameArr {
    if (!_nameArr) {
        _nameArr = [NSMutableArray array];
    }
    return _nameArr;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setupSearchView];  // 上方的搜索框的
    
     [self buildData];
    
}

- (void)buildData {
   
    //初始化数据，配置默认已订阅和为订阅的标题数组
        [[ActivityManager sharedInstance]getHomeSegmentFieldldSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"code"] integerValue]==200) {
               
                NSArray *arr =[[responseObject objectForKey:@"data"] objectForKey:@"data"];
                [self.dataArr addObjectsFromArray:arr];

                NSMutableArray *arrTitle = [NSMutableArray array];
                for (NSDictionary *dic in self.dataArr) {
                        [arrTitle addObject:[dic objectForKey:@"name"]];
                }
               
             
                
            }else
            {
                  
            }
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
        }];
  
}
#pragma mark - 搜索框
-(void)setupSearchView
{
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    view.userInteractionEnabled = YES;
    view.layer.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = SLChange(15);
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(56));
         make.right.mas_equalTo(SLChange(-56));
        make.top.mas_equalTo(StatueBar_Height+SLChange(7));
        make.height.mas_equalTo(SLChange(30));
    }];
    
    UIButton *searchBtn = [[UIButton alloc]init];
    [view addSubview:searchBtn];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:(UIControlStateNormal)];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.size.mas_equalTo(SLChange(12.5));
           make.left.mas_equalTo(SLChange(16));
           make.centerY.mas_equalTo(view);
       }];
    
    UILabel *searchLabel = [[UILabel alloc]init];
    [view addSubview:searchLabel];
    searchLabel.numberOfLines = 1;
    searchLabel.font = kRegular(12);
    searchLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    searchLabel.text = SLLocalizedString(@"搜索");
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(searchBtn.mas_right).offset(SLChange(14));
        make.right.mas_equalTo(view.mas_right).offset(-SLChange(43));
         make.centerY.mas_equalTo(view);
        make.height.mas_equalTo(SLChange(16.5));
    }];
    
   
    
    UIView *bottomLineView = [[UIView alloc] init];
       [self.view addSubview:bottomLineView];
      
    bottomLineView.backgroundColor =[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
//    bottomLineView.backgroundColor = [UIColor redColor];
       [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.right.mas_equalTo(0);
          
           make.bottom.mas_equalTo(-Height_TabBar-1);
           make.height.mas_equalTo(SLChange(1));
       }];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushSearchView:)];
          [view addGestureRecognizer:tapGes];
}
-(void)pushSearchView:(UITapGestureRecognizer *)tagGes
{
    
    AllSearchViewController *searVC = [[AllSearchViewController alloc]init];
     searVC.tabbarStr = @"Activity";
     searVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
