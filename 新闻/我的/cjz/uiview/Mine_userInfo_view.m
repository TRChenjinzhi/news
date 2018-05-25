//
//  Mine_userInfo_view.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_userInfo_view.h"

@implementation Mine_userInfo_view{
    UILabel*    m_title;
    UILabel*    m_name;
    UIImageView*    m_touxiang_img;
    UIImageView*    m_jiantou;
    UIView*         m_view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = [[ThemeManager sharedInstance] MineUserInfoBackgroundColor];
    UIView* MainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(16, 23, 32, 16)];
    title.textColor = [[ThemeManager sharedInstance] MineUserInfoCellTitleColor];
    title.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:16];
    [MainView addSubview:title];
    m_title = title;
    
    UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame)+10,
                                                              60/2-24/2,
                                                              SCREEN_WIDTH-CGRectGetMaxX(title.frame)-10-16-16,
                                                              24)];
    name.textColor = [[ThemeManager sharedInstance] MineUserInfoCellNameColor];
    name.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:16];
    name.textAlignment = NSTextAlignmentRight;
    [MainView addSubview:name];
    m_name = name;
    
    UIImageView* touxiang_img = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-16-4-24, 19, 24, 24)];
    [touxiang_img setImage:[UIImage imageNamed:@"ic_list_next"]];
    [touxiang_img.layer setCornerRadius:24/2];
    [touxiang_img setContentMode:UIViewContentModeScaleAspectFill];
    touxiang_img.clipsToBounds = YES;
    [MainView addSubview:touxiang_img];
    m_touxiang_img = touxiang_img;
    
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-16, 22, 16, 16)];
    [img setImage:[UIImage imageNamed:@"ic_list_next"]];
    [img.layer setCornerRadius:16/2];
    [MainView addSubview:img];
    m_jiantou = img;
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(16, self.frame.size.height-1, SCREEN_WIDTH-16-16, 1)];
    line.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1/1.0];
    [MainView addSubview:line];
    
    self.click_view = MainView;
    [self addSubview:MainView];
}

-(void)setName:(NSString *)name{
    m_name.text = name;
}

-(void)setTitle:(NSString *)title{
    CGFloat width = [LabelHelper GetLabelWidth:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:16] AndText:title];
    CGRect frame = m_title.frame;
    m_title.frame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
    m_title.text = title;
}

-(void)setIcon:(NSString *)icon{
    if([icon isEqualToString:@""]){
        [m_touxiang_img setImage:[UIImage imageNamed:@"user_default"]];
    }else{
        UIImage* img = [[AppConfig sharedInstance]getUserIcon];
        if(img){
            [m_touxiang_img setImage:img];
        }else{
            [m_touxiang_img sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:nil options:SDWebImageRefreshCached];
        }
        
    }
}

-(void)setIsImg:(BOOL)isImg{
    if(isImg){
        [m_name removeFromSuperview];
    }else{
        [m_touxiang_img removeFromSuperview];
    }
}

-(void)setIsNext:(BOOL)isNext{
    if(!isNext){
        m_name.frame = CGRectMake(CGRectGetMaxX(m_title.frame)+10,
                                   60/2-24/2,
                                   SCREEN_WIDTH-CGRectGetMaxX(m_title.frame)-10-16,
                                   24);
    }
}

-(void)setM_view_shifu:(UIView *)m_view_shifu{
    [m_touxiang_img removeFromSuperview];
    [m_name removeFromSuperview];
    [m_jiantou removeFromSuperview];
    
    m_view = m_view_shifu;
    m_view.frame = CGRectMake(SCREEN_WIDTH-16-m_view.frame.size.width,
                                    0,
                                    m_view.frame.size.width,
                                    m_view.frame.size.height);
    [self addSubview:m_view];
}

@end
