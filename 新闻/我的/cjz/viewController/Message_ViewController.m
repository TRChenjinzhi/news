//
//  Message_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Message_ViewController.h"
#import "Mine_message_TableViewController.h"
#import "Mine_message_model.h"

@interface Message_ViewController ()

@end

@implementation Message_ViewController{
    UIView* emptyMessage_View;
    UIView* m_viewForTableView;
    Mine_message_TableViewController* m_message_tableviewCtr;
    UIView* m_navibar_view;
    NSInteger m_naviHight;
    UIButton* m_clearButton;
    NSInteger m_page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [[ThemeManager sharedInstance] MineMessageBackgroundColor];
    [self initNavibar];
    [self getMessageData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavibar{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    m_naviHight = 56;
    
    //title
    UILabel* title_label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80/2, 18, 90, 20)];
    title_label.text = @"消息中心";
    title_label.font = [UIFont boldSystemFontOfSize:18];
    title_label.textColor =[UIColor blackColor];
    [navibar_view addSubview:title_label];
    
    //清空按钮
    UIButton* clear_buuton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-28, 20, 28, 14)];
    [clear_buuton setTitle:@"清空" forState:UIControlStateNormal];
    [clear_buuton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clear_buuton.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    [clear_buuton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:clear_buuton];
    m_clearButton = clear_buuton;
    
    //返回按钮
    UIButton* back_buuton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [back_buuton setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_buuton setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_buuton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_buuton];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 56-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [navibar_view addSubview:line];
    
    
    m_navibar_view = navibar_view;
    [self.view addSubview:m_navibar_view];
}

-(void)InitView{
    
    //空消息
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            StaTusHight+m_naviHight,
                                                            SCREEN_WIDTH,
                                                            SCREEN_HEIGHT-m_naviHight-StaTusHight)];
    UIImageView* emptyView = [[UIImageView alloc] initWithFrame:CGRectMake(135,
                                                                           181,
                                                                           90,
                                                                           90)];
    [emptyView setImage:[UIImage imageNamed:@"ic_empty_message"]];
    
    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(147, CGRectGetMaxY(emptyView.frame)+16, 67, 12)];
    lable.text = @"还没有消息~";
    lable.textColor = [[ThemeManager sharedInstance] MineMessageEmptyTextColor];
    lable.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:12];
    
    [view addSubview:emptyView];
    [view addSubview:lable];
    
    emptyMessage_View = view;
    
    
    //有消息
    UIView* viewForTableView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                        CGRectGetMaxY(m_navibar_view.frame),
                                                                        SCREEN_WIDTH,
                                                                        SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame))];
    m_viewForTableView  = viewForTableView;
    Mine_message_TableViewController* message_tableviewCtr = [[Mine_message_TableViewController alloc] init];
//    GYHHeadeRefreshController* header = [GYHHeadeRefreshController headerWithRefreshingBlock:^{
//        m_page = 0;
//        [self getMessageData:m_page];
//    }];
//    //头部刷新视图设置
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
//    message_tableviewCtr.tableView.header = header;
//    [header beginRefreshing];
//    message_tableviewCtr.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self getMessageData:m_page];
//    }];
    message_tableviewCtr.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    m_message_tableviewCtr = message_tableviewCtr;
//    [viewForTableView addSubview:message_tableviewCtr.tableView];
  
}

-(void)setMessageVC_state:(BOOL)HaveData{
    if(!HaveData){
        //空消息
        [m_viewForTableView removeFromSuperview];
        [self InitView];
        [self.view addSubview:emptyMessage_View];
    }else{
        //有消息
        [emptyMessage_View removeFromSuperview];
        [self InitView];
        m_message_tableviewCtr.array_model = self.message_arrayModel;
        m_message_tableviewCtr.view.frame = CGRectMake(0,
                                                       0,
                                                       SCREEN_WIDTH,
                                                       SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame));
        [m_viewForTableView addSubview:m_message_tableviewCtr.tableView];
        [self.view addSubview:m_viewForTableView];
        [m_message_tableviewCtr.tableView reloadData];
    }
}

#pragma mark - 按钮方法
-(void)clearAction{
    NSLog(@"清空");
    if(self.message_arrayModel.count == 0){
        return;
    }
    [m_viewForTableView removeFromSuperview];
    [self InitView];
    [self.view addSubview:emptyMessage_View];
}
-(void)backAction{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - API
-(void)getMessageData{
    //http://39.104.13.61/api/getMesRecord?json={"user_id":"814B08C64ADD12284CA82BA39384B177","page":"0","size":"10"}
    NSString* time = [[AppConfig sharedInstance] getMessageDate];
    if(time == nil){
        time = @"0";
    }
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getMesRecord"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share]GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"time",time]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(Message_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(error){
                NSLog(@"网络获取失败");
                //发送失败消息
                [[AlertHelper Share] ShowMe:self And:2.0 And:@"网络失败"];
                return ;
            }
            
            NSLog(@"从服务器获取到数据");
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* code = dict[@"code"];
            if([code integerValue] != 200){
                return;
            }
            NSArray* array_model = [Mine_message_model dicToModelArray:dict];
            
            if(array_model.count == 0){
                [block_self setMessageVC_state:NO];
            }else{
                NSNumber* date = [[TimeHelper share] getCurrentTime_number];
                [[AppConfig sharedInstance] saveMessageDate:[NSString stringWithFormat:@"%ld",[date integerValue]]];
                block_self.message_arrayModel = array_model;
                [block_self setMessageVC_state:YES];
            }

        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
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
