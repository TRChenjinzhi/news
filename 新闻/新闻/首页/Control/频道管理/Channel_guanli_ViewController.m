//
//  Channel_guanli_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Channel_guanli_ViewController.h"
#import "IndexOfNews.h"
#import "button_del_view.h"
#import "ChannelName.h"

@interface Channel_guanli_ViewController ()

@end

@implementation Channel_guanli_ViewController{
    NSMutableArray*        My_channel_array;
    NSMutableArray*        My_moreChannel_array;
    UIScrollView*          m_channel_scrollview;
    UIScrollView*          m_MoreChannel_scrollview;
    
    UIView*                 m_more_view;
    
    ChannelName*               selected_name;
    
    CGPoint startPoint;
    CGPoint originPoint;
    CGPoint startCenter;
    BOOL isContain;
    NSInteger start_index;
    
    BOOL isEdit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    My_channel_array = [NSMutableArray array];
    My_moreChannel_array = [NSMutableArray array];
    [self initView];
    
    NSLog(@"------index:%ld",[IndexOfNews share].index);
    NSLog(@"------count:%ld",[IndexOfNews share].channel_array.count);
    NSInteger nameIndex = [IndexOfNews share].index;
    selected_name = [IndexOfNews share].channel_array[nameIndex]; //记录当前频道的名称
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //保存频道信息
    [[AppConfig sharedInstance] saveChannel:[IndexOfNews share].channel_array];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"channel_guanli-SCNaviTabBar" object:nil];
    NSInteger index = 0;
    for (int i=0; i<My_channel_array.count; i++) {
        button_del_view* item = My_channel_array[i];
        if(item.isSelectedBtn){
            index = i;
            break;
        }
    }
    [IndexOfNews share].index = index;
    NSLog(@"-viewWillDisappear--index:%ld",[IndexOfNews share].index);
    
    [self.delegate initNavi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
    
    UIButton* back = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-20, StaTusHight+24, 16, 16)];
    [back setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    NSString* str1 = @"我的频道";
    UIFont* font1 = [UIFont boldSystemFontOfSize:20];
    CGFloat width = [LabelHelper GetLabelWidth:font1 AndText:str1];
    CGFloat hight = [LabelHelper GetLabelHight:font1 AndText:str1 AndWidth:width];
    UILabel* lable1 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(back.frame)+30, width, hight)];
    lable1.text = str1;
    lable1.font = font1;
    lable1.textColor = RGBA(34, 39, 39, 1);
    lable1.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:lable1];
    
    NSString* str2 = @"长按可拖动排序";
    UIFont* font2 = [UIFont boldSystemFontOfSize:12];
    CGFloat width2 = [LabelHelper GetLabelWidth:font2 AndText:str2];
    CGFloat hight2 = [LabelHelper GetLabelHight:font2 AndText:str2 AndWidth:width2];
    UILabel* lable2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lable1.frame)+13, CGRectGetMaxY(back.frame)+39, width2, hight2)];
    lable2.text = str2;
    lable2.font = font2;
    lable2.textColor = RGBA(122, 125, 125, 1);
    lable2.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:lable2];
    
    UIButton* edit_bt = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-50, CGRectGetMaxY(back.frame)+39, 50, hight2)];
    [edit_bt setTitle:@"编辑" forState:UIControlStateNormal];
    [edit_bt setTitleColor:RGBA(248, 205, 4, 1) forState:UIControlStateNormal];
    [edit_bt.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [edit_bt.titleLabel setTextAlignment:NSTextAlignmentRight];
    [edit_bt addTarget:self action:@selector(editButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:edit_bt];
    
    //我的频道 列表
    m_channel_scrollview = [[UIScrollView alloc] init];
    m_channel_scrollview.frame = CGRectMake(20, CGRectGetMaxY(lable1.frame)+20, SCREEN_WIDTH-20-20, 208);
    m_channel_scrollview.bounces = NO;
    m_channel_scrollview.showsVerticalScrollIndicator = NO;
    m_channel_scrollview.showsHorizontalScrollIndicator = NO;

    [self.view addSubview:m_channel_scrollview];
    
    button_del_view* lastOne = nil;
    for(int i=0;i<[IndexOfNews share].channel_array.count;i++){
        button_del_view* item = [self button_del_create:i];
        [My_channel_array addObject:item];
        [m_channel_scrollview addSubview:item];
        lastOne = item;
    }
    m_channel_scrollview.frame = CGRectMake(20, CGRectGetMaxY(lable1.frame)+20, SCREEN_WIDTH-20-20, CGRectGetMaxY(lastOne.frame));
    m_channel_scrollview.contentSize = CGSizeMake(SCREEN_WIDTH-20-20, CGRectGetMaxY(lastOne.frame));
    
    //
    m_more_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_channel_scrollview.frame)+40, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(m_channel_scrollview.frame)-40)];
    [self.view addSubview:m_more_view];
    
    NSString* str4 = @"更多频道";
    UIFont* font4 = [UIFont boldSystemFontOfSize:20];
    CGFloat width4 = [LabelHelper GetLabelWidth:font4 AndText:str4];
    CGFloat hight4 = [LabelHelper GetLabelHight:font4 AndText:str4 AndWidth:width4];
    UILabel* lable4 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, width4, hight4)];
    lable4.text = str4;
    lable4.font = font4;
    lable4.textColor = RGBA(34, 39, 39, 1);
    lable4.textAlignment = NSTextAlignmentLeft;
    [m_more_view addSubview:lable4];
    
    NSString* str3 = @"点击添加频道";
    UIFont* font3 = [UIFont boldSystemFontOfSize:12];
    CGFloat width3 = [LabelHelper GetLabelWidth:font3 AndText:str3];
    CGFloat hight3 = [LabelHelper GetLabelHight:font3 AndText:str3 AndWidth:width3];
    UILabel* lable3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lable4.frame)+13, CGRectGetMinY(lable4.frame)+9, width3, hight3)];
    lable3.text = str3;
    lable3.font = font3;
    lable3.textColor = RGBA(122, 125, 125, 1);
    lable3.textAlignment = NSTextAlignmentLeft;
    [m_more_view addSubview:lable3];
    
    //更多频道列表
    m_MoreChannel_scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lable4.frame)+20, SCREEN_WIDTH-20-20, SCREEN_HEIGHT-CGRectGetMaxY(lable4.frame)-20)];
    m_MoreChannel_scrollview.bounces = NO;
    m_MoreChannel_scrollview.showsVerticalScrollIndicator = NO;
    m_MoreChannel_scrollview.showsHorizontalScrollIndicator = NO;
    [m_more_view addSubview:m_MoreChannel_scrollview];
    UIButton* last_bt = nil;
    for(int i=0;i<[IndexOfNews share].channel_more_array.count;i++){
        UIButton* item = [self button_create:i];
        [My_moreChannel_array addObject:item];
        [m_MoreChannel_scrollview addSubview:item];
        last_bt = item;
    }
    [m_MoreChannel_scrollview setContentSize:CGSizeMake(SCREEN_WIDTH-20-20, CGRectGetMaxY(last_bt.frame)+10)];
}

-(button_del_view*)button_del_create:(NSInteger)i{
    CGFloat item_space = 7;
    CGFloat item_width = (SCREEN_WIDTH - 20-20-3*item_space) / 4;
    CGFloat item_hight = 49.0f;
    CGFloat line_space = kWidth(5);
    NSInteger number_line = 0;
    
    number_line = i/4;
    NSInteger count = i%4;
    button_del_view* item = [[button_del_view alloc] initWithFrame:CGRectMake(count*(item_width+item_space),
                                                                              number_line*(item_hight+line_space),
                                                                              item_width, item_hight)];
    ChannelName* channel_name = [IndexOfNews share].channel_array[i];
    [item.normal_button setTitle:channel_name.title forState:UIControlStateNormal];
    if(i == [IndexOfNews share].index){
        item.isCurrentSelected = YES;
    }else{
        item.isCurrentSelected = NO;
    }
    item.isEdit = NO;
    
    if(i != 0){ //第一个 推荐不可删除移动
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressButton:)];
        [item addGestureRecognizer:longPress];
    }
    [item.normal_button addTarget:self action:@selector(button_click:) forControlEvents:UIControlEventTouchUpInside];
    [item.del_button addTarget:self action:@selector(edit_click:) forControlEvents:UIControlEventTouchUpInside];
    
    return item;
}

-(UIButton*)button_create:(NSInteger)i{
    CGFloat item_space = 7;
    CGFloat item_width = (SCREEN_WIDTH - 20-20-3*item_space) / 4;
    CGFloat item_hight = 49.0f;
    CGFloat line_space = kWidth(5);
    NSInteger number_line = 0;
    
    number_line = i/4;
    NSInteger count = i%4;
    UIButton* item = [[UIButton alloc] initWithFrame:CGRectMake(count*(item_width+item_space),
                                                                10+number_line*(item_hight+line_space),
                                                                item_width, 40)];
    ChannelName* channel_name = [IndexOfNews share].channel_more_array[i];
    [item setTitle:channel_name.title forState:UIControlStateNormal];
    [item setTitleColor:RGBA(78, 82, 82, 1) forState:UIControlStateNormal];
    [item.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    [item.layer setBorderWidth:1];
    [item.layer setBorderColor:RGBA(244, 245, 245, 1).CGColor];
    [item.layer setCornerRadius:4.0f];
    [item addTarget:self action:@selector(more_button_click:) forControlEvents:UIControlEventTouchUpInside];
    
    return item;
}

-(CGRect)button_frame:(NSInteger)i{
    CGFloat item_space = 7;
    CGFloat item_width = (SCREEN_WIDTH - 20-20-3*item_space) / 4;
    CGFloat item_hight = 49.0f;
    CGFloat line_space = kWidth(5);
    NSInteger number_line = 0;
    number_line = i/4;
    NSInteger count = i%4;
    
    return CGRectMake(count*(item_width+item_space),
               10+number_line*(item_hight+line_space),
               item_width, 40);
}

-(CGRect)button_del_frame:(NSInteger)i{
    CGFloat item_space = 7;
    CGFloat item_width = (SCREEN_WIDTH - 20-20-3*item_space) / 4;
    CGFloat item_hight = 49.0f;
    CGFloat line_space = kWidth(5);
    NSInteger number_line = 0;
    number_line = i/4;
    NSInteger count = i%4;
    
    return CGRectMake(count*(item_width+item_space),
                      number_line*(item_hight+line_space),
                      item_width, item_hight);
}

#pragma mark 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editButton:(UIButton*)sender{
    isEdit = NO;
    if([sender.titleLabel.text isEqualToString:@"编辑"]){
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        isEdit = YES;
    }else{
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        isEdit = NO;
    }
    
//    for (button_del_view* item in My_channel_array) {
//        item.isEdit = isEdit;
//    }
    for (int i=0; i<My_channel_array.count; i++) {
        button_del_view* item = My_channel_array[i];
        if(i != 0){ //第一个 推荐不可删除
            item.isEdit = isEdit;
        }
        if(i == (int)[IndexOfNews share].index){
            item.isCurrentSelected = YES;
        }else{
            item.isCurrentSelected = NO;
        }
    }
}

-(void)edit_click:(UIButton*)sender{
    button_del_view* btn = nil;
    //去除
    for (button_del_view* item in My_channel_array) {
        if(item.del_button == sender){
            [My_channel_array removeObject:item];
            btn = item;
            [btn removeFromSuperview];
            break;
        }
    }
    
    ChannelName* channel_Name = nil;
    for (ChannelName* item in [IndexOfNews share].channel_array) {
        if([item.title isEqualToString:btn.normal_button.titleLabel.text]){
            NSMutableArray* array = [NSMutableArray arrayWithArray:[IndexOfNews share].channel_array];
            [array removeObject:item];
            channel_Name = item;
            [IndexOfNews share].channel_array = array;
            break;
        }
    }
    
    //重新排列
    [UIView animateWithDuration:0.5f animations:^{
        if ([IndexOfNews share].index >= My_channel_array.count) {
            [IndexOfNews share].index = My_channel_array.count -1;
            NSLog(@"重新赋值：index:%ld",[IndexOfNews share].index);
        }
        for (int i=0; i<My_channel_array.count; i++) {
            button_del_view* item = My_channel_array[i];
            item.m_frame = [self button_del_frame:i];
            if(i != 0){
                item.isEdit = isEdit;
            }
            if([IndexOfNews share].index == i){
                item.isCurrentSelected = YES;
            }else{
                item.isCurrentSelected = NO;
            }
        }
    }];
    
    //添加
    NSMutableArray* array = [NSMutableArray arrayWithArray:[IndexOfNews share].channel_more_array];
    if(!channel_Name.isNewChannel){//如果是新添加频道，就直接彻底删除
        [array addObject:channel_Name];
        [IndexOfNews share].channel_more_array = array;
        
        UIButton* button = [self button_create:[IndexOfNews share].channel_more_array.count-1];
        [My_moreChannel_array addObject:button];
        [m_MoreChannel_scrollview addSubview:button];
        m_MoreChannel_scrollview.contentSize = CGSizeMake(SCREEN_WIDTH-20-20, CGRectGetMaxY(button.frame));
    }
    
    //重新计算scrollview
    [self scrollviewSetFrame];
}
-(void)button_click:(UIButton*)sender{
    NSNumber* number_index = nil;
    for (int i=0;i<My_channel_array.count;i++) {
        button_del_view* item = My_channel_array[i];
        if(item.normal_button == sender){
            number_index = [NSNumber numberWithInteger:i];
            item.isSelectedBtn = YES;
        }else{
            item.isSelectedBtn = NO;
        }
    }
    //保存频道信息
    [[AppConfig sharedInstance] saveChannel:[IndexOfNews share].channel_array];
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"channel_guanli-SCNaviTabBar" object:nil];
    NSInteger index = 0;
    for (int i=0; i<My_channel_array.count; i++) {
        button_del_view* item = My_channel_array[i];
        if(item.isSelectedBtn){
            index = i;
            break;
        }
    }
    [IndexOfNews share].index = index;
//    NSLog(@"-viewWillDisappear--index:%ld",[IndexOfNews share].index);
    
    [self.delegate initNavi];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate naviSelectedIndex:[number_index integerValue]];
}

-(void)more_button_click:(UIButton*)sender{
    
    [sender removeFromSuperview];
    
    //去除
    for (UIButton* item in My_moreChannel_array) {
        if(item == sender){
            [My_moreChannel_array removeObject:item];
            break;
        }
    }
    
    ChannelName* channel_Name = nil;
    for (ChannelName* item in [IndexOfNews share].channel_more_array) {
        if([item.title isEqualToString:sender.titleLabel.text]){
            NSMutableArray* array = [NSMutableArray arrayWithArray:[IndexOfNews share].channel_more_array];
            [array removeObject:item];
            channel_Name = item;
            [IndexOfNews share].channel_more_array = array;
            break;
        }
    }
    
    //重新排列
    [UIView animateWithDuration:0.5f animations:^{
        for (int i=0; i<My_moreChannel_array.count; i++) {
            UIButton* item = My_moreChannel_array[i];
            item.frame = [self button_frame:i];
        }
    }];
    
    //添加
    NSMutableArray* array = [NSMutableArray arrayWithArray:[IndexOfNews share].channel_array];
    [array addObject:channel_Name];
    [IndexOfNews share].channel_array = array;
    
    button_del_view* button_del = [self button_del_create:[IndexOfNews share].channel_array.count-1];
    button_del.isEdit = isEdit;
    [My_channel_array addObject:button_del];
    [m_channel_scrollview addSubview:button_del];
    m_channel_scrollview.contentSize = CGSizeMake(SCREEN_WIDTH-20-20, CGRectGetMaxY(button_del.frame));
    
    //重新计算scrollview
    [self scrollviewSetFrame];
}

-(void)scrollviewSetFrame{
    //我的频道
    NSInteger My_count = [IndexOfNews share].channel_array.count;
    NSInteger my_lineNumber = 0;
    if(My_count%4 != 0){
        my_lineNumber = My_count/4 + 1;
    }else{
        my_lineNumber = My_count/4;
    }
    m_channel_scrollview.frame = CGRectMake(20, m_channel_scrollview.frame.origin.y, SCREEN_WIDTH-20-20, my_lineNumber*(49.0f+kWidth(5)));
    m_channel_scrollview.contentSize = CGSizeMake(SCREEN_WIDTH-20-20, my_lineNumber*(49.0f+kWidth(5)));
    
    //更多频道
    NSInteger more_count = [IndexOfNews share].channel_more_array.count;
    NSInteger more_lineNumber = 0;
    if(more_count%4 != 0){
        more_lineNumber = more_count/4 + 1;
    }else{
        more_lineNumber = more_count/4;
    }
    m_more_view.frame = CGRectMake(0, CGRectGetMaxY(m_channel_scrollview.frame)+40, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(m_channel_scrollview.frame)-40);
    m_MoreChannel_scrollview.frame = CGRectMake(20, m_MoreChannel_scrollview.frame.origin.y, SCREEN_WIDTH-20-20, more_lineNumber*(49.0f+kWidth(5)));
    m_MoreChannel_scrollview.contentSize = CGSizeMake(SCREEN_WIDTH-20-20, more_lineNumber*(49.0f+kWidth(5)));
    
    
    [self.view layoutIfNeeded];
}

#pragma mark 移动
-(void)longPressButton:(UILongPressGestureRecognizer*)sender{
    CGFloat time = 0.5f;
    button_del_view* item = (button_del_view*)sender.view;
    if(sender.state == UIGestureRecognizerStateBegan){
        startPoint = [sender locationInView:sender.view];
        originPoint = item.center;
        startCenter = item.center;
        start_index = [self indexInArrayWithButton:item];
        [UIView animateWithDuration:time animations:^{
            item.transform = CGAffineTransformMakeScale(1.1, 1.1);
            item.alpha = 0.7;
        }];
    }
    
    if(sender.state == UIGestureRecognizerStateChanged){
        CGPoint newPoint = [sender locationInView:sender.view];
        //移动该控件
        item.center = CGPointMake(item.center.x + newPoint.x-startPoint.x, item.center.y + newPoint.y-startPoint.y);
        NSInteger index = [self indexInArraywithPoint:item.center withButton:item];
        if(index < 0){
            isContain = NO;
        }else{
            isContain = YES;
            
            CGPoint temp = CGPointZero;
            button_del_view *button = My_channel_array[index];
            temp = button.center;
            //                button.center = originPoint;
            originPoint = temp;
            
            NSMutableArray* sorted_array = [NSMutableArray arrayWithArray:My_channel_array];
            [sorted_array removeObject:item];
            [sorted_array insertObject:item atIndex:index];
//            for (int i=0;i<My_channel_array.count;i++) {
//                button_del_view* current_item = My_channel_array[i];
//            }
            
            [UIView animateWithDuration:time animations:^{
                
                if(index > start_index){ //前 --》 后
                    CGPoint tmp = CGPointZero;
                    for (int i=0; i<sorted_array.count; i++) {
                        button_del_view* current_item = My_channel_array[i];
                        button_del_view* item_center = sorted_array[i];
                        
                        if(current_item != item_center){
                            if(item_center != item){
                                if(current_item != item){
                                    CGPoint point_tmp = item_center.center;
                                    item_center.center = tmp;
                                    tmp  = point_tmp;
//                                    NSLog(@"item_center:%f--%f",current_item.normal_button.center.x,item_center.normal_button.center.x);
                                }else{
                                    tmp = CGPointMake(item_center.center.x, item_center.center.y);
                                    item_center.center = startCenter;
//                                    NSLog(@"item_center:%f--startCenter:%f",tmp.x,startCenter.x);
                                }
                            }else{
//                                originPoint = current_item.center;
                                originPoint = CGPointMake(tmp.x, tmp.y);
//                                NSLog(@"origin:%f--current_item:%f",originPoint.x,tmp.x);
                            }
//                            NSLog(@"current:%@--%@",current_item.normal_button.titleLabel.text,item_center.normal_button.titleLabel.text);
                        }
                    }
                    startCenter = originPoint;
                }
                else{ //后 --》 前
                    for (int i=0; i<My_channel_array.count; i++) {
                        button_del_view* current_item = My_channel_array[i];
                        button_del_view* item_center = sorted_array[i];
                        if(current_item != item_center){
                            if(current_item != item){
                                if(item_center != item){
                                    item_center.center = current_item.center;
                                }else{
                                    originPoint = current_item.center;
                                }
                            }else{
                                item_center.center = startCenter;
                            }
                        }
                    }
                    startCenter = originPoint;
                }
            }];
            //频道 顺序调整
            
            NSMutableArray* array_tmp = [NSMutableArray arrayWithArray:[IndexOfNews share].channel_array];
//            ChannelName* tmp = array_tmp[index];
            ChannelName* tmp_ori = array_tmp[start_index];
            [array_tmp removeObject:tmp_ori];
            [array_tmp insertObject:tmp_ori atIndex:index];
//            [array_tmp replaceObjectAtIndex:index withObject:tmp_ori];
//            [array_tmp replaceObjectAtIndex:start_index withObject:tmp];
            [IndexOfNews share].channel_array = array_tmp;
            My_channel_array = sorted_array;
            //在退出这个界面时 保存数据
            
            start_index = index;
            
        }
    }
    
    if(sender.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:time animations:^{
            item.transform = CGAffineTransformIdentity;
            item.alpha = 1.0;
            if (!isContain)
            {
                item.center = originPoint;
            }
       }];
    }
}

-(NSInteger)indexInArraywithPoint:(CGPoint)center withButton:(button_del_view*)btn{
    for(int i=0;i<My_channel_array.count;i++){
        button_del_view* item = My_channel_array[i];
        if(item != btn){
            if(CGRectContainsPoint(item.frame, center)){
                if(i == 0){
                    return -1;
                }
                return i;
            }
        }
        
    }
    
    return -1;
}

-(NSInteger)indexInArrayWithButton:(button_del_view*)btn{
    for(int i=0;i<My_channel_array.count;i++){
        button_del_view* item = My_channel_array[i];
        if(item == btn){
            return i;
        }
    }
    
    return -1;
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
