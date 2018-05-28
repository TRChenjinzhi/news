//
//  SectionHeader_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SectionHeader_ViewController.h"

@interface SectionHeader_ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SectionHeader_ViewController{
    UITableView*            m_section_tableView;
    UIView*                 m_section_View;
    
    UIView*                 m_reply_View;
    NSArray*                m_ReadingWithOther_model;//相关阅读model数组
    BOOL                    isFirst;
    NSInteger               count;
}

-(UIView *)m_ReadingWithOther_view{
    if(!_m_ReadingWithOther_view){
        _m_ReadingWithOther_view = [[UIView alloc]init];
    }
    return _m_ReadingWithOther_view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    [self initSectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSectionView{
    
    [self initReading];
    [self initReply];
    [self GetDataWithReadingOther];
}
//相关阅读,热门评论
-(void)initReading{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52+10+52)];//+10+52:是包含了热门评论的标签
    view.backgroundColor = [UIColor whiteColor];
    self.m_ReadingWithOther_view = view;
    
    // 顶部标签
    UIView* lable_view = [[UIView alloc] init];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(kWidth(28), 25, 150, 18)];
    label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:18];
    label.text = @"相关阅读";
    label.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    [lable_view addSubview:label];
    
    UIView* yellow = [[UIView alloc] initWithFrame:CGRectMake(16, 24, 4, 20)];
    yellow.backgroundColor = RGBA(255, 129, 3, 1);
    [lable_view addSubview:yellow];
    
    [view addSubview:lable_view];
    
    [self.view addSubview:self.m_ReadingWithOther_view];
    
}
//热门评论的标题
-(void)initReply{
    UIView* reply_view = [[UIView alloc] initWithFrame:CGRectMake(0, self.m_ReadingWithOther_view.frame.size.height-62, SCREEN_WIDTH, 62)];
    reply_view.backgroundColor = [UIColor whiteColor];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [reply_view addSubview:line];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(28, 25, 150, 18)];
    label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:18];
    label.text = @"热门评论";
    label.textColor = [UIColor colorWithRed:122/255.0 green:125/255.0 blue:125/255.0 alpha:1/1.0];
    [reply_view addSubview:label];
    
    UIView* yellow = [[UIView alloc] initWithFrame:CGRectMake(16, 24, 4, 20)];
    yellow.backgroundColor = RGBA(255, 129, 3, 1);
    [reply_view addSubview:yellow];
    
    [self.m_ReadingWithOther_view addSubview:reply_view];
    m_reply_View = reply_view;
    
}

//添加tableView
-(void)setTableView{
    if(m_section_tableView == nil){
        m_section_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 52, SCREEN_WIDTH, 1)];
        m_section_tableView.delegate = self;
        m_section_tableView.dataSource = self;
        m_section_tableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
        [m_section_tableView reloadData];
        [self.m_ReadingWithOther_view addSubview:m_section_tableView];
    }
}

//改变热门评论 的位置，改变新闻详细页面 headerView 的高度
-(void)ChangeFrame:(CGFloat)hight{
    if(isFirst){
        return;
    }
    if(count == m_ReadingWithOther_model.count){
        isFirst = YES;
        return;
    }else{
        count++;
    }
    
    
    self.m_ReadingWithOther_view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.m_ReadingWithOther_view.frame.size.height+hight);
    
    m_section_tableView.frame = CGRectMake(0, 52, SCREEN_WIDTH, m_section_tableView.frame.size.height+hight);
    
    m_reply_View.frame = CGRectMake(0, self.m_ReadingWithOther_view.frame.size.height-62, SCREEN_WIDTH, 62);
    
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.m_ReadingWithOther_view.frame.size.height+hight);
//    NSLog(@"view view:%.2f",self.m_ReadingWithOther_view.frame.size.height);
    NSLog(@"view frame:%.2f",self.view.frame.size.height);
//    [self.view layoutIfNeeded];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"sectionHight" object:self];//通知变更headerView高度
    [self.delegate initSectionFrame:self.m_ReadingWithOther_view.frame.size.height];
}

#pragma mark - tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return m_ReadingWithOther_model.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        ThemeManager *defaultManager = [ThemeManager sharedInstance];
        CJZdataModel *Model = m_ReadingWithOther_model[indexPath.row];
        //    CJZdataModel *Model = self.totalArray[indexPath.row];
        
        NSString *ID = [NoImageCell idForRow:Model];
        if([ID isEqualToString:@"NoImg"]){
            NoImageCell* cell = [NoImageCell cellWithTableView:tableView];
            if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
                cell.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
                cell.title.textColor = [defaultManager GetTitleColor];
            }else{
                cell.backgroundColor = [UIColor whiteColor];
                cell.title.textColor = [UIColor blackColor];
            }
            cell.model = Model;
            cell.IsReading = Model.isRreading;
            return cell;
        }
        else if([ID isEqualToString:@"OneImg"]){
            OneImageCell* cell = [OneImageCell cellWithTableView:tableView];
            if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
                cell.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
                cell.title.textColor = [defaultManager GetTitleColor];
            }else{
                cell.backgroundColor = [defaultManager GetBackgroundColor];
                cell.title.textColor = [defaultManager GetTitleColor];
            }
            cell.model = Model;
            cell.IsReading = Model.isRreading;
            return cell;
        }
        else{
            //ThreeImage
            ThreeImageCell* cell = [ThreeImageCell cellWithTableView:tableView];
            if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
                cell.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
                cell.title.textColor = [defaultManager GetTitleColor];
            }else{
                cell.backgroundColor = [defaultManager GetBackgroundColor];
                cell.title.textColor = [defaultManager GetTitleColor];
            }
            cell.model = Model;
            cell.IsReading = Model.isRreading;
            return cell;
        }
        
        return nil;
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        CJZdataModel *newsModel = m_ReadingWithOther_model[indexPath.row];
        
        CGFloat rowHeight = [NoImageCell heightForRow:newsModel];
        [self ChangeFrame:rowHeight];
        return rowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CJZdataModel *data = m_ReadingWithOther_model[indexPath.row];
    data.isRreading = YES;//标题变灰
    //一个cell刷新
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//    [self.delegate initSectionFrame];
    [tableView reloadData];
//    DetailWeb_ViewController* vc = [[DetailWeb_ViewController alloc] init];
//    vc.CJZ_model = data;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"相关阅读点击" object:data];
    [self.delegate showNews:data];

}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark - API
-(void)GetDataWithReadingOther{
    //http://younews.3gshow.cn/api/getRelateNews?json={"user_id":"YangYiTestNumber1713841009","news_id":120,"channel":1}
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/api/getRelateNews"]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share] GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"origin_channel",self.channel_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"news_id",self.model.ID]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"channel",self.model.channel]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%ld",@"client_type",IOS]];//设备类型 1:android 2；ios
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    IMP_BLOCK_SELF(SectionHeader_ViewController);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error || data == nil){
                NSLog(@"GetDataWithReadingOther网络获取失败");
                //发送失败消息
                //                [block_self.tableView.footer endRefreshing];
                return ;
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSArray* array_news = dict[@"list"];
            NSMutableArray *dataarray = [CJZdataModel jsonArrayToModelArray:array_news];
            for (CJZdataModel* model in dataarray) {
                if([model.ID isEqualToString:self.model.ID]){
                    [dataarray removeObject:model];
                    break;
                }
            }
            m_ReadingWithOther_model = dataarray;
            [block_self setTableView];
        });
    }];
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
