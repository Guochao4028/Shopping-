//
//  AfterSalesDetailsViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AfterSalesDetailsViewController.h"

#import "OrderDetailsModel.h"

#import "WengenNavgationView.h"

#import "OrderFillFooterView.h"

#import "AfterSalesDetailTableCell.h"

#import "AfterSalesTuiKuanTableViewCell.h"

#import "AfterSalesApplyReasonTableCell.h"

#import "HomeManager.h"

#import "SMAlert.h"

#import "GoodsStoreInfoModel.h"

#import "OrderHomePageViewController.h"

@interface AfterSalesDetailsViewController ()<WengenNavgationViewDelegate, UITableViewDelegate, UITableViewDataSource, AfterSalesApplyReasonTableCellDelegate,TZImagePickerControllerDelegate>

@property(nonatomic, strong)WengenNavgationView *navgationView;

@property(nonatomic, strong)OrderFillFooterView *footerView;

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSMutableArray *potoArray;

@property(nonatomic, strong)GoodsStoreInfoModel *storeInfoModel;



@end

@implementation AfterSalesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)initData{
        
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];

    [[DataManager shareInstance] getStoreInfo:@{@"id":self.model.club_id} Callback:^(NSObject *object) {
        self.storeInfoModel = (GoodsStoreInfoModel *)object;
        
        if (NotNilAndNull(self.storeInfoModel)) {
            [self.tableView reloadData];
        }
        
        [hud hideAnimated:YES];
    }];
//    [DataManager shareInstance]
    
//
//    [[DataManager shareInstance]getOrderInfo:@{@"order_id":self.model.order_car_sn} Callback:^(NSObject *object) {
//
//           if([object isKindOfClass:[NSArray class]] == YES){
//               NSArray *array = (NSArray *)object;
//
//               if ([array count] > 0) {
//                   self.model = array[0];
//                   [self.tableView reloadData];
//               }
//
//           }
//       }];
}


#pragma mark - methods

-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.navgationView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
}


#pragma mark - action
-(void)comittAction{
    
    [SMAlert setConfirmBtBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    
    if (self.type == AfterSalesDetailsTuiQianType) {
        title.text = SLLocalizedString(@"确定要提交退款申请吗？");
    }else{
        title.text = SLLocalizedString(@"确定要提交退货退款申请吗？");
    }
    
    
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
         
         [param setValue:self.model.order_no forKey:@"order_id"];
         
         [param setValue:self.potoArray forKey:@"img_data"];
         
         if (self.type == AfterSalesDetailsTuiQianType) {
             [param setValue:@"1" forKey:@"type"];
         }else{
             [param setValue:@"2" forKey:@"type"];
         }
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
         AfterSalesApplyReasonTableCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.afterType = self.type;

         [param setValue:cell.reason forKey:@"content"];
         [param setValue:cell.goods_status forKey:@"goods_status"];

         [[DataManager shareInstance]addRefund:param Callback:^(Message *message) {
             if (message.isSuccess) {
                 [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"提交成功，请等待审核") view:self.view afterDelay:TipSeconds];
                 NSArray *viewControllers = [self.navigationController viewControllers];
                 OrderHomePageViewController *vc;
                 for (int i = 0; i < viewControllers.count; i++) {
                     if ([viewControllers[i] isKindOfClass:[OrderHomePageViewController class]] == YES) {
                         vc = viewControllers[i];
                     }
                 }
                 
                 vc.index = 5;
                 
                 [self.navigationController popToViewController:vc animated:YES];
             }else{
                 [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
             }
         }];
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
    
}

#pragma mark - WengenNavgationViewDelegate
-(void)tapBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorForHex:@"FAFAFA"];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 0;
    
    switch (indexPath.section) {
        case 0:{
            //商品信息
            tableViewH = 185;
        }
            break;
        case 1:{
            //申请原因
//            if ([self.potoArray count] == 0) {
//                tableViewH = 238 + 85;
//            }else if ([self.potoArray count] <= 4 && [self.potoArray count] < 8){
//                tableViewH = 238 + 85 *2;
//            }else{
//                tableViewH = 238 + 85 *3;
//            }
            
            if ([self.potoArray count] == 0) {
                   tableViewH = 238 + 85;
               }else if ([self.potoArray count] < 4){
                   tableViewH = 238 + 85;
               }else if([self.potoArray count] >= 4 &&[self.potoArray count] < 8){
                   tableViewH = 238 + 85 *2 +10;
               }else{
                  tableViewH = 238 + 85 *3+(10*2);
               }
            
        }
            break;
        case 2:{
            //退款方式
            tableViewH = 202;
        }
            break;
        default:
            break;
    }
    return tableViewH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
//    cell = [[UITableViewCell alloc]init];
    switch (indexPath.section) {
        case 0:{
            //商品信息
            AfterSalesDetailTableCell *detailTableCell = [tableView dequeueReusableCellWithIdentifier:@"AfterSalesDetailTableCell"];
            [detailTableCell setModel:self.model];
            cell = detailTableCell;
        }
            break;
        case 1:{
            //申请原因
            AfterSalesApplyReasonTableCell *applyReasonTableCell = [tableView dequeueReusableCellWithIdentifier:@"AfterSalesApplyReasonTableCell"];
            applyReasonTableCell.afterType = self.type;
            [applyReasonTableCell setDelegate:self];
            [applyReasonTableCell setPotoArray:self.potoArray];
            [applyReasonTableCell setModel:self.model];
            
            [applyReasonTableCell setBlock:^(BOOL isTap) {
                [self.footerView setIsTap:YES];
            }];
            
            cell = applyReasonTableCell;
            
        }
            break;
        case 2:{
            //退款方式
            
            AfterSalesTuiKuanTableViewCell *tuikuanCell = [tableView dequeueReusableCellWithIdentifier:@"AfterSalesTuiKuanTableViewCell"];
            [tuikuanCell setModel:self.model];
            [tuikuanCell setStoreInfoModel:self.storeInfoModel];
            cell = tuikuanCell;
        }
            break;
        default:
            cell = [[UITableViewCell alloc]init];
            break;
    }
    
    
    return cell;
}

#pragma mark - AfterSalesApplyReasonTableCellDelegate
-(void)applyReasonTableCell:(AfterSalesApplyReasonTableCell *)cell tapSelectPoto:(BOOL)istap{
    NSLog(@"%s", __func__);
    
//    PhotoPickerViewController *photoPickerVC = [[PhotoPickerViewController alloc]init];
//    [self.navigationController pushViewController:photoPickerVC animated:YES];
     NSInteger photoNum ;
    if (self.potoArray.count == 0) {
        photoNum = 9;
    }else {
        photoNum = 9 -self.potoArray.count;
    }
    if (self.potoArray.count > 8) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"最多只能选择9张图片") view:[UIApplication sharedApplication].keyWindow afterDelay:TipSeconds];
        return;
    }
    
    TZImagePickerController  *imagePicker=  [[TZImagePickerController alloc]initWithMaxImagesCount:photoNum delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingVideo = NO;
    [imagePicker setBarItemTextColor:[UIColor blackColor]];
    [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        NSLog(@"%@",photos);
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"正在上传图片")];
        // 创建队列组，可以使多个网络请求异步执行，执行完之后再进行操作
        dispatch_group_t group = dispatch_group_create();
        //创建全局队列
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

        dispatch_group_async(group, queue, ^{
       
        for (int i = 0; i<photos.count; i++) {
          
        //创建dispatch_semaphore_t对象
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        UIImage *image = photos[i];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
//           
//        [[HomeManager sharedInstance] postSubmitPhotoWithFileData:imageData isVedio:NO Success:^(NSURLSessionDataTask *task, id responseObject) {
//                NSDictionary *dic = responseObject;
//                if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//                            
//                    [self.potoArray addObject:[dic objectForKey:DATAS]];
//                    [self.tableView reloadData];
//                               
//                } else {
//                    [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"msg"] view:[UIApplication sharedApplication].keyWindow afterDelay:TipSeconds];
//                }
//                dispatch_semaphore_signal(semaphore);
//
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                    NSLog(@"%@",error.debugDescription);
//                    [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:[UIApplication sharedApplication].keyWindow afterDelay:TipSeconds];
//                dispatch_semaphore_signal(semaphore);
//
//            }];
            
            
            
            [[HomeManager  sharedInstance]postSubmitPhotoWithFileData:imageData isVedio:NO Success:^(NSDictionary * _Nullable resultDic) {
                       } failure:^(NSString * _Nullable errorReason) {
                       } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
                        
                         NSDictionary *dic = responseObject;
                         if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                                     
                             [self.potoArray addObject:[dic objectForKey:DATAS]];
                             [self.tableView reloadData];
                                        
                         } else {
                             [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"msg"] view:[UIApplication sharedApplication].keyWindow afterDelay:TipSeconds];
                         }
                         dispatch_semaphore_signal(semaphore);
                           
                       }];
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    });
        // 当所有队列执行完成之后
        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           dispatch_async(dispatch_get_main_queue(), ^{
               [hud hideAnimated:YES];
               if ([self.potoArray  count] > 0) {
                   [self.footerView setIsTap:YES];
               }
               
            });
        });
      
    }];
     imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}


-(void)applyReasonTableCell:(AfterSalesApplyReasonTableCell *)cell tapDeleteLocation:(NSInteger)location{
    [self.potoArray removeObjectAtIndex:location];
    [self.tableView reloadData];
}


#pragma mark - getter / setter

-(WengenNavgationView *)navgationView{
    
    if (_navgationView == nil) {
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
        _navgationView = [[WengenNavgationView alloc]initWithFrame:CGRectMake(0, barHeight, ScreenWidth, 44)];
        [_navgationView setTitleStr:SLLocalizedString(@"售后")];
        [_navgationView setDelegate:self];
    }
    return _navgationView;

}


-(UITableView *)tableView{
    
    if (_tableView == nil) {
        
        CGFloat height = ScreenHeight - 49 - kBottomSafeHeight - 44 ;
        CGFloat y = CGRectGetMaxY(self.navgationView.frame);
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, height)style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AfterSalesDetailTableCell class])bundle:nil] forCellReuseIdentifier:@"AfterSalesDetailTableCell"];
        
         [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AfterSalesTuiKuanTableViewCell class])bundle:nil] forCellReuseIdentifier:@"AfterSalesTuiKuanTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AfterSalesApplyReasonTableCell class])bundle:nil] forCellReuseIdentifier:@"AfterSalesApplyReasonTableCell"];
        
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; 
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = NO;
        //将触摸事件添加到当前view
        [_tableView addGestureRecognizer:tapGestureRecognizer];
    }
    return _tableView;

}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


-(OrderFillFooterView *)footerView{
    
    if (_footerView == nil) {
        
        CGFloat y = ScreenHeight - 49 - kBottomSafeHeight;
        
        _footerView = [[OrderFillFooterView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, 49)];
        [_footerView setButtonStr:SLLocalizedString(@"提交退货")];
        
        [_footerView setIsTap:NO];
        
        [_footerView comittTarget:self action:@selector(comittAction)];
    }
    return _footerView;

}

-(void)setModel:(OrderDetailsModel *)model{
    _model = model;
    [self.footerView setGoodsAmountTotal:[NSString stringWithFormat:@"￥%@", model.money]];
}

-(NSMutableArray *)potoArray{
    
    if (_potoArray == nil) {
        _potoArray = [NSMutableArray array];
    }
    return _potoArray;

}


@end
