//
//  Header_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Header_ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "showImages_ViewController.h"

#define Font_Big 2
#define Font_Normal 1
#define Font_small 0
#define Font_init 100

@interface Header_ViewController ()<UIScrollViewDelegate,UIWebViewDelegate>


@property (nonatomic)NSInteger webviewHight;
@property (nonatomic)NSInteger Reading_ViewHight;

@property (nonatomic,strong)UIView* footView;

@property (nonatomic,strong)UIView* lable_view;

@property (nonatomic,strong)UIView* reply_view;


@end

@implementation Header_ViewController{
    NSInteger FontSize;
    BOOL      isSetFont;
    UIView*     m_ReadingWithOther_view;//相关阅读区域
    NSArray*    m_ReadingWithOther_model;//相关阅读model数组
    UITableView*    m_tableView;
    NSMutableArray* _mUrlArray;
    
    CGSize      m_size;
    BOOL        m_isFirst;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    [self initWebview];
    [self initFootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initWebview{
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    webView.delegate = self;
//    webView.opaque = NO;
    webView.scrollView.delegate = self;
    webView.scrollView.bounces = NO;
//    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    self.webview = webView;
    [self.webview.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionInitial context:nil];
}

-(void)initFootView{
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.footView.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:self.footView];
}

-(void)setFontState:(NSInteger)fontState{
    FontSize = fontState;
    isSetFont = YES;
}

#pragma mark - contentSize代理
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"contentSize"]){
        
        CGSize size = [self.webview sizeThatFits:CGSizeZero];
//        NSLog(@"contentSize webview size contentsize-->%f",size.height);
        self.webview.frame = CGRectMake(0, 0, size.width, size.height);
        //    self.view.frame = CGRectMake(0, 0, size.width, size.height+10+_ViewHight+10);
        self.footView.frame = CGRectMake(0, self.webview.frame.size.height, SCREEN_WIDTH, self.footView.frame.size.height);
//        self.lable_view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 52);
//        self.reply_view.frame = CGRectMake(0, CGRectGetMaxY(m_ReadingWithOther_view.frame)+10, SCREEN_WIDTH, 52);
        
        self.view.frame = CGRectMake(0, 0, size.width, size.height+self.footView.frame.size.height);
//        NSLog(@"view hight-->%f",size.height);
            m_size = self.view.frame.size;
            [self.delegate setHeaderFrame];
//        }
    }
}

#pragma mark - webview代理
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //获取段落内容
    //获取所有的html
    NSString *allHtml = @"document.documentElement.innerHTML";
    
//    //获取网页title
//    NSString *htmlTitle = @"document.title";
//    //获取网页的一个值
//    NSString *htmlNum = @"document.getElementById('figure').innerText";
    
    //获取到得网页内容
    NSString *allHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:allHtml];
//    NSLog(@"allHtmlInfo:%@",allHtmlInfo);
    
    TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:[allHtmlInfo dataUsingEncoding:NSUTF8StringEncoding]];
    // 根据标签进行筛选 获取所有标签是<p>的代码块
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//p"];
    NSString *text_all = [[NSString alloc]init];
    //开始整理数据
    for (TFHppleElement *elsement in elements) {
        if ([elsement content] != nil) {
            
            if (![[elsement objectForKey:@"style"]isEqualToString:@"text-align"]) {//筛选属性是里有style 并且值是text-align的标签
                
                //打印出该节点的所有内容  包括标签
//                NSLog(@"%@",elsement.raw);
                //打印出该节点的所有内容   不包括标签
//                NSLog(@"%@",elsement.text);
                text_all = [NSString stringWithFormat:@"%@%@\n",text_all,elsement.text];
            }
        }
    }
    
    
    //这里是js，主要目的实现对url的获取
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    
    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    
    _mUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    
    //添加图片可点击JS
    [webView stringByEvaluatingJavaScriptFromString:@"function registerImageClickAction(){\
     var imgs=document.getElementsByTagName('img');\
     var length=imgs.length;\
     for(var i=0;i<length;i++){\
     img=imgs[i];\
     img.onclick=function(){\
     window.location.href='image-preview:'+this.src}\
     }\
     }"];
    [webView stringByEvaluatingJavaScriptFromString:@"registerImageClickAction();"];

    

    if(!isSetFont){
        [self setWebView_Font:webView AndType:[[AppConfig sharedInstance]GetFontSize]];
    }else{
        [self setWebView_Font:webView AndType:FontSize];
    }
    
    CGSize size = CGSizeZero;
//    CGSize size = [webView sizeThatFits:CGSizeZero];
//    NSLog(@"webview size-->%f",size.height);//这个高度 有时不太准确
//    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
//    NSLog(@"documentSize = {%f}", documentHeight);
    CGFloat webViewHeight =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    NSLog(@"CGFloatwebViewHeight:%f",webViewHeight); //这个高度准确
    size = CGSizeMake(SCREEN_WIDTH, webViewHeight);
    self.webview.frame = CGRectMake(0, 0, size.width, size.height);
//    self.view.frame = CGRectMake(0, 0, size.width, size.height+10+_ViewHight+10);
    self.footView.frame = CGRectMake(0, size.height, SCREEN_WIDTH, self.footView.frame.size.height);
//    self.lable_view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 52);
//    self.reply_view.frame = CGRectMake(0, size.height+10+_Reading_ViewHight+10, SCREEN_WIDTH, 52);
    
    self.view.frame = CGRectMake(0, 0, size.width, size.height+self.footView.frame.size.height);
//    NSLog(@"webview hight-->%f",self.view.frame.size.height);
    
//    NSString* html =[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
//    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    m_size = self.view.frame.size;
    //通知
    [self.delegate webViewDidLoad:text_all];
    [self.delegate setHeaderFrame];
    m_isFirst = YES; //代表新闻加载完毕
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"webViewDidLoad" object:self];
}

-(CGSize)getSize{
    return m_size;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //预览图片
    for (int i=0;i<_mUrlArray.count;i++) {
        NSString* url = _mUrlArray[i];
        NSString* str = @"image-preview:";
        str = [NSString stringWithFormat:@"%@%@",str,url];
//        NSLog(@"---图片点击方法:%@",request.URL.scheme);
//        NSLog(@"---request.URL:%@",request.URL);
        
        NSString* url_now = request.URL.absoluteString;
        if ([url_now isEqualToString:str]) {
            [self.delegate showWebImages:_mUrlArray AndIndex:i];
            return NO;
        }
    }
    
    //点击广告时
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        NSLog(@"UIWebViewNavigationTypeLinkClicked-----------");
        if(!m_isFirst){ //第一次进入为UIWebViewNavigationTypeOther 类型，之后广告点击 也是UIWebViewNavigationTypeOther类型
            return YES;
        }
        [self.delegate showGuangGao:request];
        // 如果返回NO，代表不允许加载这个请求
        return NO;
    }
    
    return YES;
    
}

-(void)setWebView_Font:(UIWebView*)webView AndType:(NSInteger)type{
//    NSString *jsString = @"";
//    NSString* str = [NSString stringWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",5.0,@"red"];
//    NSString* str1 = [NSString stringWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",10.0,@"red"];
//    NSString* str2 = [NSString stringWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",15.0,@"red"];
    switch (type) {
        case Font_Big:
            //字体大小
            
            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'"];
//            jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",20.,@"red"];
//            [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'"];
            break;
        case Font_Normal:
            //字体大小
            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
//            jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",18.0,@"red"];
//            [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
            break;
        case Font_small:
            //字体大小
            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'"];
//            jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",16.0,@"red"];
//            [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'"];
            break;
            
        default:
            break;
    }
//    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
    
//    [webView stringByEvaluatingJavaScriptFromString:jsString];
}

-(void)setWebView_FontColor:(UIWebView*)webView AndType:(NSInteger)type{
    switch (type) {
        case Font_Big:
            //字体颜色
            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
            break;
        case Font_Normal:
            //字体颜色
            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'red'"];
            [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'red'"];
            break;
        case Font_small:
            //字体颜色
            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
            break;
            
        default:
            break;
    }
}

-(void)setWebView_backgroundColor:(UIWebView*)webView AndType:(NSInteger)type{
    switch (type) {
        case Font_Big:
            //背景颜色
            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
            [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
            break;
        case Font_Normal:
            //背景颜色
            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
            break;
        case Font_small:
            //背景颜色
            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
            break;
            
        default:
            break;
    }
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
