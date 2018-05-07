//
//  Video_detail_tuijianTableViewCell.m
//  新闻
//
//  Created by chenjinzhi on 2018/4/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Video_detail_tuijianTableViewCell.h"

@implementation Video_detail_tuijianTableViewCell{
    UIImageView*        m_imgV;
    UILabel*            m_title;
    UILabel*            m_resouce;
    UILabel*            m_playedCount;
}

+(instancetype)CellFormTable:(UITableView *)tableView{
    static NSString *ID = @"Video_detail_tuijianTableViewCell";
    Video_detail_tuijianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[Video_detail_tuijianTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

+(CGFloat)cellForHeight{
    return kWidth(104);
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initUI];
    }
    return self;
}

-(void)initUI{
    m_imgV = [UIImageView new];
    [self addSubview:m_imgV];
    [m_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).with.offset(kWidth(16));
        make.height.mas_equalTo(kWidth(72));
        make.width.mas_equalTo(kWidth(108));
    }];
    
    UIImageView* play_imgV = [UIImageView new];
    [play_imgV setImage:[UIImage imageNamed:@"ic_play"]];
    [m_imgV addSubview:play_imgV];
    [play_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(m_imgV);
        make.height.width.mas_equalTo(kWidth(30));
    }];
    
    m_title = [UILabel new];
    m_title.textColor = RGBA(34, 39, 39, 1);
    m_title.textAlignment = NSTextAlignmentLeft;
    m_title.font = kFONT(16);
    m_title.numberOfLines = 2;
    m_title.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:m_title];
    [m_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(kWidth(21));
        make.left.equalTo(m_imgV.mas_right).with.offset(kWidth(8));
        make.right.equalTo(self.mas_right).with.offset(-kWidth(16));
        make.height.mas_lessThanOrEqualTo(kWidth(40));
    }];
    
    m_playedCount = [UILabel new];
    m_playedCount.textColor = RGBA(122, 125, 125, 1);
    m_playedCount.textAlignment = NSTextAlignmentLeft;
    m_playedCount.font = kFONT(13);
    m_playedCount.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:m_playedCount];
    [m_playedCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-kWidth(20));
        make.right.equalTo(self.mas_right).with.offset(kWidth(16));
        make.height.mas_equalTo(kWidth(13));
        make.width.mas_greaterThanOrEqualTo(kWidth(100));
    }];
    
    m_resouce = [UILabel new];
    m_resouce.textColor = RGBA(122, 125, 125, 1);
    m_resouce.textAlignment = NSTextAlignmentLeft;
    m_resouce.font = kFONT(13);
    m_resouce.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:m_resouce];
    [m_resouce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-kWidth(20));
        make.left.equalTo(m_imgV.mas_right).with.offset(kWidth(8));
        make.height.mas_equalTo(kWidth(16));
        make.width.mas_greaterThanOrEqualTo(kWidth(100));
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = RGBA(242, 242, 242, 1);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kWidth(16));
        make.right.equalTo(self).with.offset(-kWidth(16));
        make.bottom.equalTo(self);
        make.height.mas_equalTo(kWidth(1));
    }];
}

-(void)setModel:(video_info_model *)model{
    if([NullNilHelper dx_isNullOrNilWithObject:model.avatar]){
        NSLog(@"--------avatar空----------");
    }
    
    [m_imgV sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    m_resouce.text = model.source;
    
    m_title.text = model.title;
    if(model.isReading){
        m_title.textColor = RGBA(167, 169, 169, 1);
    }else{
        m_title.textColor = RGBA(34, 39, 39, 1);
    }
    
    NSInteger count = [model.play_count integerValue];
    if(count >= 100000000){
        m_playedCount.text = [NSString stringWithFormat:@"%.1f亿次播放",count/100000000.0f];
    }
    else if(count >= 10000){
        m_playedCount.text = [NSString stringWithFormat:@"%.1f万次播放",count/10000.0f];
    }else{
        m_playedCount.text = [NSString stringWithFormat:@"%ld次播放",count];
    }
}

@end
