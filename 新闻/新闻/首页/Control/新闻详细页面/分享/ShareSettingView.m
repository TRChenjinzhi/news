//
//  ShareSettingView.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShareSettingView.h"
#import "ShareSetting_view.h"
#import "collectionCell.h"
#import "OnlyTitel_CollectionViewCell.h"

@implementation ShareSettingView{
    collectvModel* m_model;
    UIButton*       m_cancel_button;
    
    NSNumber*       m_report_type;
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
    
    //底栏
    UIButton* cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height-40, SCREEN_WIDTH, 40)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[[ThemeManager sharedInstance] GetDialogTextColor] forState:UIControlStateNormal];
    [cancel.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:16]];
    [cancel addTarget:self action:@selector(CancelAction:) forControlEvents:UIControlEventTouchUpInside];
    cancel.backgroundColor = [[ThemeManager sharedInstance] GetDialogViewColor];
    m_cancel_button = cancel;
    
    [self addSubview:cancel];
}

-(void)setModel:(collectvModel *)model{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = model.itemInstance;
    layout.minimumLineSpacing = model.lineInstance;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = model.size;
    
    if([model.type isEqualToString:@"举报"]){
        [m_cancel_button setTitle:@"确定" forState:UIControlStateNormal];
    }
    if([model.type isEqualToString:@"字体"]){
    }
    
    m_model = model;
    
    UICollectionView* collt = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height-40) collectionViewLayout:layout];
    collt.delegate = self;
    collt.dataSource = self;
    collt.bounces = NO;
    collt.scrollsToTop = NO;
    collt.showsVerticalScrollIndicator = NO;
    collt.showsHorizontalScrollIndicator = NO;
    collt.backgroundColor = [[ThemeManager sharedInstance]GetBackgroundColor];
    
    [collt registerClass:[collectionCell class] forCellWithReuseIdentifier:@"colltcell"];
    [collt registerClass:[OnlyTitel_CollectionViewCell class] forCellWithReuseIdentifier:@"OnlyTitel_CollectionViewCell"];
    
    [self addSubview:collt];
    
}

-(void)CancelAction:(UIButton*)sender{
    NSLog(@"取消");

    //发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"取消" object:nil];
    if([m_model.type isEqualToString:@"举报"]){
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"举报" object:m_report_type];
        [self.delegate reportToSever:m_report_type];
    }
}

#pragma mark - collect代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return m_model.name_array.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSArray* nameArray = m_model.name_array;
    if(!m_model.IsOnlyTitle){
        collectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colltcell" forIndexPath:indexPath];
        NSArray* imgArray = m_model.imgs_array;
        [cell.imgView setImage:[UIImage imageNamed:imgArray[indexPath.row]]];
        cell.label.text = nameArray[indexPath.row];
        cell.label.textColor =  [[ThemeManager sharedInstance] GetDialogTextColor];
        cell.label.textAlignment = NSTextAlignmentCenter;
        cell.label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:12];
        cell.backgroundColor = [[ThemeManager sharedInstance] GetBackgroundColor];
        
        return cell;
    }else{
        OnlyTitel_CollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OnlyTitel_CollectionViewCell" forIndexPath:indexPath];
        if(!cell){
            cell = [[OnlyTitel_CollectionViewCell alloc] init];
        }
        //当只有title没有图片时
        if([m_model.type isEqualToString:@"字体"]){
            [cell.m_title setText:m_model.name_array[indexPath.row]];
            [cell.m_title setTextColor:[UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0] ];
            [cell.m_title setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:18]];
            NSNumber* number = m_model.array_Selected[indexPath.row];
            if([number integerValue] == 0){
                cell.isSelected = NO;
            }else{
                cell.isSelected = YES;
            }
        }
        if([m_model.type isEqualToString:@"举报"]){
            [cell.m_title setText:m_model.name_array[indexPath.row]];
            [cell.m_title setTextColor: [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1/1.0]];
            [cell.m_title setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
            NSNumber* number = m_model.array_Selected[indexPath.row];
            if([number integerValue] == 0){
                cell.isSelected = NO;
            }else{
                cell.isSelected = YES;
            }
        }
        
        return cell;
    }
    
    
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return m_model.edge;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了cell");
    //当只有title没有图片时
    if([m_model.type isEqualToString:@"字体"]){
        NSMutableArray* arrya_tmp = [NSMutableArray arrayWithArray:m_model.array_Selected];
        [arrya_tmp replaceObjectsInRange:NSMakeRange(0, arrya_tmp.count-1) withObjectsFromArray:@[@NO,@NO,@NO]];//全部变No
        [arrya_tmp replaceObjectAtIndex:indexPath.row withObject:@YES];
        m_model.array_Selected = arrya_tmp;
        [collectionView reloadData];
        NSNumber* number = [NSNumber numberWithInteger:indexPath.row];
        [[AppConfig sharedInstance] saveFontSize:indexPath.row];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"字体改变" object:number];
        [self.delegate shareSetting_changeFont:number];
    }else if([m_model.type isEqualToString:@"举报"]){
        NSMutableArray* arrya_tmp = [NSMutableArray arrayWithArray:m_model.array_Selected];
        [arrya_tmp replaceObjectsInRange:NSMakeRange(0, arrya_tmp.count-1) withObjectsFromArray:@[@NO,@NO,@NO,@NO,@NO,@NO]];//全部变No
        [arrya_tmp replaceObjectAtIndex:indexPath.row withObject:@YES];
        m_model.array_Selected = arrya_tmp;
        m_report_type = [NSNumber numberWithInteger:indexPath.row+1];
        [collectionView reloadData];
    }else{
        NSString* name = m_model.name_array[indexPath.row];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"分享点击事件" object:name];
        [self.delegate shareByName:name];
    }
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    NSInteger itemToItem = (SCREEN_WIDTH-m_model.edge.left-m_model.edge.right-m_model.size.width*m_model.itemsOfLine)/m_model.itemsOfLine;
    return itemToItem;
}



@end
