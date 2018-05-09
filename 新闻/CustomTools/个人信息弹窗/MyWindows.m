//
//  MyWindows.m
//  新闻
//
//  Created by chenjinzhi on 2018/4/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyWindows.h"

@implementation MyWindows{
    UITextField*                m_textField;
    Windows_Type                m_type;
    UIView*                     m_centerView;
    CGFloat                     m_centerView_maxY;
    
    //选项
    NSMutableArray*             m_lable_array;
    NSMutableArray*             m_btn_array;
    NSInteger                   m_index;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = RGBA(0, 0, 0, 0.6);
    m_lable_array   = [NSMutableArray array];
    m_btn_array     = [NSMutableArray array];
    m_centerView_maxY = 0.0f;
}

-(void)setType:(Windows_Type)type{
    m_type = type;
    switch (type) {
        case Type_TextField:{
            [self initTextField];
            break;
        }
        case Type_Choose:{
            [self initChoose];
            break;
        }
        default:
            break;
    }
    
}

-(void)initTextField{
    UIView* center_view = [UIView new];
    center_view.backgroundColor = RGBA(255, 255, 255, 1);
    m_centerView = center_view;
    [self addSubview:center_view];
    [center_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kWidth(45));
        make.right.equalTo(self).with.offset(-kWidth(45));
        make.centerY.equalTo(self);
        make.height.mas_offset(kWidth(178));
    }];
    
    UILabel* title      = [UILabel new];
    title.text          = self.title;
    title.textColor     = RGBA(122, 125, 125, 1);
    title.textAlignment = NSTextAlignmentCenter;
    title.font          = kFONT(14);
    [center_view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(center_view);
        make.height.mas_offset(kWidth(56));
    }];
    
    UITextField* textFiled  = [UITextField new];
    textFiled.textAlignment = NSTextAlignmentLeft;
    textFiled.textColor     = RGBA(34, 39, 39, 1);
    textFiled.placeholder   = @"请输入";
    textFiled.font          = kFONT(16);
    textFiled.returnKeyType = UIReturnKeyDone;
    m_textField = textFiled;
    [center_view addSubview:textFiled];
    [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom);
        make.left.equalTo(center_view.mas_left).with.offset(kWidth(24));
        make.right.equalTo(center_view.mas_right).with.offset(-kWidth(24));
        make.height.mas_offset(kWidth(44));
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = RGBA(242, 242, 242, 1);
    [center_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(center_view).with.offset(kWidth(14));
        make.right.equalTo(center_view).with.offset(-kWidth(14));
        make.top.equalTo(textFiled.mas_bottom);
        make.height.mas_offset(kWidth(1));
    }];
    
    UIButton* cancel_btn = [UIButton new];
    [cancel_btn setBackgroundColor:RGBA(242, 242, 242, 1)];
    [cancel_btn setTitle:@"取消" forState:UIControlStateNormal];
    [cancel_btn setTitleColor:RGBA(167, 169, 169, 1) forState:UIControlStateNormal];
    [cancel_btn.layer setCornerRadius:3.0f];
    [cancel_btn addTarget:self action:@selector(cancel_action) forControlEvents:UIControlEventTouchUpInside];
    [center_view addSubview:cancel_btn];
    [cancel_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(center_view.mas_left).with.offset(kWidth(25));
        make.bottom.equalTo(center_view.mas_bottom).with.offset(-kWidth(20));
        make.height.mas_offset(kWidth(36));
        make.width.mas_offset(kWidth(100));
    }];
    
    UIButton* sure_btn = [UIButton new];
    [sure_btn setBackgroundColor:RGBA(248, 205, 4, 1)];
    [sure_btn setTitle:@"确定" forState:UIControlStateNormal];
    [sure_btn setTitleColor:RGBA(34, 39, 39, 1) forState:UIControlStateNormal];
    [sure_btn addTarget:self action:@selector(sure_action) forControlEvents:UIControlEventTouchUpInside];
    [sure_btn.layer setCornerRadius:3.0f];
    [center_view addSubview:sure_btn];
    [sure_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(center_view.mas_right).with.offset(-kWidth(25));
        make.bottom.equalTo(center_view.mas_bottom).with.offset(-kWidth(20));
        make.height.mas_offset(kWidth(36));
        make.width.mas_offset(kWidth(100));
    }];
}

-(void)initChoose{
    UIView* center_view = [UIView new];
    center_view.backgroundColor = RGBA(255, 255, 255, 1);
    m_centerView = center_view;
    [self addSubview:center_view];
    [center_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kWidth(45));
        make.right.equalTo(self).with.offset(-kWidth(45));
        make.centerY.equalTo(self);
        make.height.mas_offset(kWidth(178-44)+self.array_choose.count*kWidth(44));
    }];
    
    UILabel* title      = [UILabel new];
    title.text          = self.title;
    title.textColor     = RGBA(122, 125, 125, 1);
    title.textAlignment = NSTextAlignmentCenter;
    title.font          = kFONT(14);
    [center_view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(center_view);
        make.height.mas_offset(kWidth(56));
    }];
    
    UIView* line_tmp = [UIView new];
    line_tmp.backgroundColor = RGBA(242, 242, 242, 1);
    [center_view addSubview:line_tmp];
    [line_tmp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(center_view).with.offset(kWidth(14));
        make.right.equalTo(center_view).with.offset(-kWidth(14));
        make.top.equalTo(title.mas_bottom);
        make.height.mas_offset(kWidth(1));
    }];
    
    UIView* top_tmp = line_tmp;
    for (NSString* str in self.array_choose) {
        UILabel* choose_name = [UILabel new];
        choose_name.text            = str;
        choose_name.textColor       = RGBA(34, 39, 39, 1);
        choose_name.textAlignment   = NSTextAlignmentLeft;
        choose_name.font            = kFONT(16);
        [m_lable_array addObject:choose_name];
        [center_view addSubview:choose_name];
        [choose_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(center_view).with.offset(kWidth(24));
            make.top.equalTo(top_tmp.mas_bottom).with.offset(kWidth(13));
            make.height.mas_offset(kWidth(16));
            make.width.mas_offset([LabelHelper GetLabelWidth:kFONT(16) AndText:str]);
        }];
        
        UIButton* point_btn = [UIButton new];
        [point_btn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        [point_btn.layer setCornerRadius:kWidth(16)/2];
        [point_btn addTarget:self action:@selector(chooseBtn_action:) forControlEvents:UIControlEventTouchUpInside];
        [m_btn_array addObject:point_btn];
        [center_view addSubview:point_btn];
        [point_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(top_tmp.mas_bottom).with.offset(kWidth(14));
            make.right.equalTo(center_view).with.offset(-kWidth(24));
            make.width.and.height.mas_offset(kWidth(16));
        }];
        
        UIView* line_item = [UIView new];
        line_item.backgroundColor = RGBA(242, 242, 242, 1);
        [center_view addSubview:line_item];
        [line_item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(center_view).with.offset(kWidth(14));
            make.right.equalTo(center_view).with.offset(-kWidth(14));
            make.top.equalTo(choose_name.mas_bottom).with.offset(kWidth(15));
            make.height.mas_offset(kWidth(1));
        }];
        
        top_tmp = line_item;
    }
    if([[Login_info share].userInfo_model.sex integerValue] == 1){
        [self setIndex:0];
    }
    else{
        [self setIndex:1];
    }
    
    
    UIButton* cancel_btn = [UIButton new];
    [cancel_btn setBackgroundColor:RGBA(242, 242, 242, 1)];
    [cancel_btn setTitle:@"取消" forState:UIControlStateNormal];
    [cancel_btn setTitleColor:RGBA(167, 169, 169, 1) forState:UIControlStateNormal];
    [cancel_btn.layer setCornerRadius:3.0f];
    [cancel_btn addTarget:self action:@selector(cancel_action) forControlEvents:UIControlEventTouchUpInside];
    [center_view addSubview:cancel_btn];
    [cancel_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(center_view.mas_left).with.offset(kWidth(25));
        make.bottom.equalTo(center_view.mas_bottom).with.offset(-kWidth(20));
        make.height.mas_offset(kWidth(36));
        make.width.mas_offset(kWidth(100));
    }];
    
    UIButton* sure_btn = [UIButton new];
    [sure_btn setBackgroundColor:RGBA(248, 205, 4, 1)];
    [sure_btn setTitle:@"确定" forState:UIControlStateNormal];
    [sure_btn setTitleColor:RGBA(34, 39, 39, 1) forState:UIControlStateNormal];
    [sure_btn addTarget:self action:@selector(sure_action) forControlEvents:UIControlEventTouchUpInside];
    [sure_btn.layer setCornerRadius:3.0f];
    [center_view addSubview:sure_btn];
    [sure_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(center_view.mas_right).with.offset(-kWidth(25));
        make.bottom.equalTo(center_view.mas_bottom).with.offset(-kWidth(20));
        make.height.mas_offset(kWidth(36));
        make.width.mas_offset(kWidth(100));
    }];
}

-(void)setIndex:(NSInteger)index{
    for (int i = 0; i<self.array_choose.count; i++) {
        UILabel* lable_item         = m_lable_array[i];
        UIButton*btn_item           = m_btn_array[i];
        if(index == i){
            lable_item.textColor    = RGBA(248, 205, 4, 1);
            [btn_item setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        }
        else{
            lable_item.textColor    = RGBA(34, 39, 39, 1);
            [btn_item setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        }
    }
}

-(void)setCenterViewFrame:(CGFloat)height{
    if(m_centerView_maxY == 0){
        m_centerView_maxY = CGRectGetMaxY(m_centerView.frame);
    }
    // 修改下边距约束
    CGFloat centerView_maxY = SCREEN_HEIGHT-m_centerView_maxY;
    CGFloat height_offset = height - centerView_maxY;
    if(height == 0){
        [m_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    else{
        [m_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(-height_offset);
        }];
    }
    
    // 更新约束
    [UIView animateWithDuration:0.25f animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - 点击事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

#pragma mark - 按钮方法
-(void)cancel_action{
    [self removeFromSuperview];
}

-(void)sure_action{
    if(m_type == Type_TextField){
        if(m_textField.text.length <= 0){
            [MyMBProgressHUD ShowMessage:@"不能为空" ToView:self AndTime:1.0f];
            return;
        }
        [self.delegate returnString:m_textField.text];
    }
    else if(m_type == Type_Choose){
        UILabel* item = m_lable_array[m_index];
        [self.delegate returnString:item.text];
    }
    
    [self removeFromSuperview];
}

-(void)chooseBtn_action:(UIButton*)btn{
    for (int i=0; i<m_btn_array.count; i++) {
        UIButton* item = m_btn_array[i];
        if(item == btn){
            m_index = i;
            [self setIndex:m_index];
            return;
        }
    }
}

@end
