//
//  ShareSettingView.h
//  新闻
//
//  Created by chenjinzhi on 2018/1/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "collectvModel.h"

@interface ShareSettingView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)collectvModel* model;


@end
