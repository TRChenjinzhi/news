//
//  showImages_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/3/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "showImages_ViewController.h"

@interface showImages_ViewController ()<UIScrollViewDelegate>

@end

@implementation showImages_ViewController{
    NSMutableArray*     m_images_array;
    UILabel*            tips;
    NSInteger           m_image_index;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.view.backgroundColor = [UIColor blackColor];
    [self initView];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setImage_array:(NSArray *)image_array{
    [self checkImageUrl:image_array];
}

-(void)initView{
    UIScrollView* scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-60-24-10-20)];
    scrollview.bounces = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.pagingEnabled = YES;
    scrollview.delegate = self;
    [scrollview setContentOffset:CGPointMake(self.index*SCREEN_WIDTH, 0)];
    [self.view addSubview:scrollview];
    
    for (int i=0; i<m_images_array.count; i++) {
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60-24-10-20)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        [img sd_setImageWithURL:[NSURL URLWithString:m_images_array[i]]];
        [scrollview addSubview:img];
    }
    
    scrollview.contentSize = CGSizeMake(m_images_array.count * SCREEN_WIDTH, 0);
    
    tips = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(scrollview.frame)+20, 100, 24)];
    tips.text = [NSString stringWithFormat:@"%ld/%ld",self.index+1,m_images_array.count];
    tips.textColor = [UIColor whiteColor];
    tips.textAlignment = NSTextAlignmentLeft;
    tips.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:tips];
    
    UIButton* save_btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16-50, SCREEN_HEIGHT-10-24, 50, 24)];
    save_btn.backgroundColor = [UIColor blackColor];
    [save_btn setTitle:@"保存" forState:UIControlStateNormal];
    [save_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [save_btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [save_btn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [save_btn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save_btn];
    
}

//png jpeg
-(void)checkImageUrl:(NSArray*)array{
    m_images_array = [NSMutableArray array];
    for (NSString* url in array) {
        if([url containsString:@".png"] ||
           [url containsString:@".jpg"] ||
           [url containsString:@".jpeg"] ||
           [url containsString:@".gif"]){
            
            [m_images_array addObject:url];
        }
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveImage{
    NSURL *url = [NSURL URLWithString: m_images_array[m_image_index]];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *img;
    if ([manager diskImageExistsForURL:url])
    {
        img =  [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
    }
    else
    {
        //从网络下载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        img = [UIImage imageWithData:data];
    }
    // 保存图片到相册中
    UIImageWriteToSavedPhotosAlbum(img,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error){
        [MBProgressHUD showError:@"保存失败"];
    }else{
        [MBProgressHUD showSuccess:@"保存成功"];
    }
//    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

#pragma mark scroll协议
-(void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat offerWidth = [scrollView mj_offsetX];
    m_image_index = offerWidth/SCREEN_WIDTH;
    tips.text = [NSString stringWithFormat:@"%ld/%ld",m_image_index+1,m_images_array.count];
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
