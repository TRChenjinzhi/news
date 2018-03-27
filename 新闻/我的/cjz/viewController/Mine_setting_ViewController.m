//
//  Mine_setting_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_setting_ViewController.h"
#import "Mine_setting_TableViewController.h"
#import "Mine_setting_model.h"
#import "collectvModel.h"
#import "ShareSettingView.h"
#import "ShareSetting_view.h"
#import "Mine_AboutMe_ViewController.h"
#import "Agreement_ViewController.h"
#import "SVProgressHUD.h"

@interface Mine_setting_ViewController ()

@end

@implementation Mine_setting_ViewController{
    UIView*                             m_navibar_view;
    
    NSArray*                            m_array_model;
    Mine_setting_TableViewController*   m_setting_TVC;
    
    ShareSetting_view*                  m_shareSetting;
    NSString*                           m_path;
    BOOL                                m_clear_ok;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavi];
    [self initTableView];
    [self MyGCD];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemClick:) name:@"设置点击" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FontChanged:) name:@"字体改变" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavi{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [back_button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_button];
    
//    UIButton* edit_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-56-14, 21, 56, 14)];
//    [edit_button setTitle:@"编辑" forState:UIControlStateNormal];
//    [edit_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [edit_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
//    [edit_button addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
//    [navibar_view addSubview:edit_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-150/2, 18, 150, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"系统设置";
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    [navibar_view addSubview:title];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 56-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [navibar_view addSubview:line];
    
    [self.view addSubview:navibar_view];
    m_navibar_view = navibar_view;
}

-(void)initTableView{
    
    Mine_setting_TableViewController* setting_TVC = [[Mine_setting_TableViewController alloc] init];
    setting_TVC.tableView.frame = CGRectMake(0,
                                             CGRectGetMaxY(m_navibar_view.frame),
                                             SCREEN_WIDTH,
                                             SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame));

    [self getData];
    setting_TVC.array_model = m_array_model;
    m_setting_TVC = setting_TVC;
    
    [self.view addSubview:setting_TVC.tableView];
}

-(void)MyGCD{
    //1.创建一个其他队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //2.创建NSBlockOperation对象
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
        NSString* str = [self SizeOfCash];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            Mine_setting_model* model = m_array_model[1];
            model.subTitle = str;
            NSMutableArray* tmp = [NSMutableArray arrayWithArray:m_array_model];
            [tmp replaceObjectAtIndex:1 withObject:model];
            m_array_model = tmp;
            m_setting_TVC.array_model = m_array_model;
            [m_setting_TVC.tableView reloadData];
            m_clear_ok = YES;//表示可以清除缓存了
        });
    }];
    
    //3.添加多个Block
//    for (NSInteger i = 0; i < 5; i++) {
//        [operation addExecutionBlock:^{
//            NSLog(@"第%ld次：%@", i, [NSThread currentThread]);
//        }];
//    }
    
    //4.队列添加任务
    [queue addOperation:operation];

}

//计算缓存大小
-(NSString*)SizeOfCash{
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"CustomFile"];
    m_path = filePath;
    //fileSize是封装在Category中的。
    unsigned long long size = [self fileSize:filePath];
    
    size += [SDImageCache sharedImageCache].getSize;   //CustomFile + SDWebImage 缓存
    
    //设置文件大小格式
    NSString* sizeText = nil;
    if (size >= pow(10, 9)) {
        sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
    }else if (size >= pow(10, 6)) {
        sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
    }else if (size >= pow(10, 3)) {
        sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
    }else {
        sizeText = [NSString stringWithFormat:@"%zdB", size];
    }
    return sizeText;
}

- (unsigned long long)fileSize:(NSString*)path
{
    // 总大小
    unsigned long long size = 0;
//    NSString *sizeText = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    BOOL exist = [manager fileExistsAtPath:path isDirectory:&isDir];
    
    // 判断路径是否存在
    if (!exist) return size;
    if (isDir) { // 是文件夹
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:path];
        for (NSString *subPath in enumerator) {
            NSString *fullPath = [path stringByAppendingPathComponent:subPath];
            size += [manager attributesOfItemAtPath:fullPath error:nil].fileSize;
            
        }
    }else{ // 是文件
        size += [manager attributesOfItemAtPath:path error:nil].fileSize;
    }
    return size;
}

- (void)clearCacheClick
{
    [SVProgressHUD showWithStatus:@"正在清除缓存···"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSFileManager *mgr = [NSFileManager defaultManager];
            [mgr removeItemAtPath:m_path error:nil];
            [mgr createDirectoryAtPath:m_path withIntermediateDirectories:YES attributes:nil error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                
                //初始化tabelview
                [self getData];
                m_setting_TVC.array_model = m_array_model;
                [m_setting_TVC.tableView reloadData];
                // 设置文字
                [self MyGCD];
            });
        });
    }];
}


#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取数据
-(void)getData{
    NSMutableArray* array_tmp = [[NSMutableArray alloc] initWithCapacity:6];
    NSArray* title = @[@"字体大小",@"清除缓存",@"隐私及版权说明",@"关于我们"];
    NSMutableArray* subTitle = [[NSMutableArray alloc] initWithObjects:@"字体大小",@"正在计算",@"",@"", nil];//为空时，则显示 箭头 图案
    NSInteger fontSize = [[AppConfig sharedInstance] GetFontSize];
    if(fontSize == 0){
        [subTitle replaceObjectAtIndex:0 withObject:@"小"];
    }
    if(fontSize == 1){
        [subTitle replaceObjectAtIndex:0 withObject:@"中"];
    }
    if(fontSize == 2){
        [subTitle replaceObjectAtIndex:0 withObject:@"大"];
    }
    
    for(int i=0;i<title.count;i++) {
        Mine_setting_model* model = [[Mine_setting_model alloc]init];
        model.title = title[i];
        model.subTitle = subTitle[i];
        
        [array_tmp addObject:model];
    }
    m_array_model = array_tmp;
}

#pragma mark - 广播 方法
-(void)itemClick:(NSNotification*)noti{
    NSString* title = noti.object;
    if([title isEqualToString:@"字体大小"]){
        collectvModel* model = [[collectvModel alloc] init];
        model.name_array = @[@"小",@"中",@"大"];
        model.itemInstance = (SCREEN_WIDTH-42-32-72*3)/2;
        model.itemsOfLine = 3;
        model.lineInstance = 0;
        model.size = CGSizeMake(72, 40);
        model.edge = UIEdgeInsetsMake(30, 42, 30, 32);//分别为上、左、下、右
        model.IsOnlyTitle = YES;
        model.type = @"字体";
        model.IsOnlyOneSected = YES;
        NSInteger index = [[AppConfig sharedInstance] GetFontSize];

        NSMutableArray* array_tmp = [NSMutableArray arrayWithObjects:@NO,@NO,@NO, nil];
        [array_tmp replaceObjectAtIndex:index withObject:@YES];
        model.array_Selected = array_tmp;
        
        
        ShareSettingView* view = [[ShareSettingView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT+140, SCREEN_WIDTH, 140)];
        view.model = model;
        view.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
//        m_fenxiang_shareSettingView = view;
        
        ShareSetting_view* share_setting = [ShareSetting_view GetDialogView:view.frame withCusomView:view];
        m_shareSetting = share_setting;
        [m_shareSetting Show];
    }
    
    if([title isEqualToString:@"清除缓存"]){
        if(m_clear_ok){
            [self clearCacheClick];
        }
    }
    
    if([title isEqualToString:@"给我们好评"]){
    }
    
    if([title isEqualToString:@"隐私及版权说明"]){
        Agreement_ViewController* vc = [[Agreement_ViewController alloc] init];
        vc.isTask = false;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if([title isEqualToString:@"关于我们"]){
        Mine_AboutMe_ViewController* vc = [[Mine_AboutMe_ViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)FontChanged:(NSNotification*)noti{
    [self getData];
    m_setting_TVC.array_model = m_array_model;
    [m_setting_TVC.tableView reloadData];
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
