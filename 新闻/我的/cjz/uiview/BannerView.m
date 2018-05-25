//
//  BannerView.m
//  橙子快报
//
//  Created by chenjinzhi on 2018/5/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BannerView.h"

#define scrollTime  0.5

@interface BannerView ()<UIScrollViewDelegate>

@end


@implementation BannerView{
    BOOL            isRight; //是否往右边滚动
}

-(instancetype)initWithFrame:(CGRect)frame ImageUrls:(NSArray *)imageUrls IntervalTime:(CGFloat)intervalTime{
    self = [self initWithFrame:frame];
    if (self) {
        self.imageUrls = [NSArray arrayWithArray:imageUrls];
        self.intervalTime = intervalTime;
        self.currentPage = 0;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    isRight = YES;
    self.currentPage = 0;
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self setupImageView];
    [self setupTimer];
}

-(NSMutableArray *)array_imgs{
    if(_array_imgs == nil){
        _array_imgs = [NSMutableArray array];
    }
    return _array_imgs;
}

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.imageUrls.count, CGRectGetHeight(self.scrollView.frame));
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.decelerationRate = 1.0;
        _scrollView.backgroundColor = [UIColor blackColor];
    }
    return _scrollView;
}

-(UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.frame.size.width/2-50, self.frame.size.height-15, 100, 10)];
        _pageControl.numberOfPages = self.imageUrls.count;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return _pageControl;
}

-(void)setupImageView{
    
    for (int i = 0 ;i<self.imageUrls.count;i++) {
        NSURL* url = self.imageUrls[i];
        UIImageView* imgV  = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        imgV.tag = i;
        [imgV sd_setImageWithURL:url];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
        imgV.userInteractionEnabled = YES;
        [imgV addGestureRecognizer:tap];
        [self.array_imgs addObject:tap];
        [self.scrollView addSubview:imgV];
    }
    
    self.pageControl.currentPage = self.currentPage;
}

-(void)setupTimer{
    self.timer = [NSTimer timerWithTimeInterval:self.intervalTime target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}


-(void)timerTick{

    ///此处设置动画的时间一定要小于滑动的时间
    [UIView animateWithDuration:scrollTime animations:^{
        ///动画发生的滑动
        if(self.currentPage < 0){
            self.currentPage = 0;
        }
        else if(self.currentPage + 1 > self.imageUrls.count){
            self.currentPage = self.imageUrls.count - 1;
        }
        if(isRight){
            self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame)*(self.currentPage+1), 0);
        }
        else{
            self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame)*(self.currentPage-1), 0);
        }
        
    } completion:^(BOOL finished) {
        [self AutorScroll:self.scrollView];
    }];
    
}

#pragma mark - 用户点击

-(void)imageViewTap:(UITapGestureRecognizer*)tap{
    NSLog(@"tap at :%ld",self.currentPage);
    [self.delegate BannerViewSelectedAt:self.currentPage];
}

#pragma mark - scrollView滑动事件

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    ///有用户手动拖动，则停止定时器
    [self.timer invalidate];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    ///用户滑动停止，重新启动定时器
    [self setupTimer];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self AutorScroll:scrollView];
}


-(void)AutorScroll:(UIScrollView*)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    if (index ==0) {
        //向左滑动
        isRight = YES;
        self.currentPage--;
    }else if(index == self.imageUrls.count-1){
        ///向右滑动
        isRight = NO;
        self.currentPage++;
    }
    else{
        if(isRight){
            self.currentPage++;
            //            self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        }
        else{
            self.currentPage--;
            //            self.scrollView.contentOffset = CGPointMake(-CGRectGetWidth(self.scrollView.frame), 0);
        }
    }
    if(self.currentPage < 0){
        self.currentPage = 0;
    }
    else if(self.currentPage + 1 > self.imageUrls.count){
        self.currentPage = self.imageUrls.count - 1;
    }
    
    self.pageControl.currentPage = self.currentPage;
}


@end
