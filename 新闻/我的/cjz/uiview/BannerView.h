//
//  BannerView.h
//  橙子快报
//
//  Created by chenjinzhi on 2018/5/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerViewDelegate <NSObject>

-(void)BannerViewSelectedAt:(NSInteger)index;

@end

@interface BannerView : UIView

@property (strong, nonatomic) NSArray *imageUrls;
@property (strong, nonatomic) NSMutableArray* array_imgs;

@property (nonatomic) CGFloat intervalTime;

@property (weak, nonatomic) id delegate;

-(instancetype)initWithFrame:(CGRect)frame ImageUrls:(NSArray *)imageUrls IntervalTime:(CGFloat)intervalTime;

///滑动视图
@property (strong, nonatomic) UIScrollView *scrollView;
///指示器
@property (strong, nonatomic) UIPageControl *pageControl;

@property (nonatomic) NSInteger currentPage;

@property (strong, nonatomic) NSTimer *timer;


@end
