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

@interface Header_ViewController ()<UIScrollViewDelegate,WKUIDelegate,WKNavigationDelegate>


@property (nonatomic)CGFloat webviewHight;
@property (nonatomic)NSInteger Reading_ViewHight;



@property (nonatomic,strong)UIView* lable_view;

@property (nonatomic,strong)UIView* reply_view;


@end

@implementation Header_ViewController{
    NSInteger FontSize;
    BOOL      isSetFont;
    UIView*     m_ReadingWithOther_view;//相关阅读区域
    NSArray*    m_ReadingWithOther_model;//相关阅读model数组
    UITableView*    m_tableView;
//    NSMutableArray* _mUrlArray;
    
    CGSize      m_size;
    BOOL        m_isFirst;
    NSString*   text_all;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    [self initWebview];
    [self initFootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initWebview{
    //创建WKWebview配置对象
    WKWebViewConfiguration*config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize =10;
    config.preferences.javaScriptEnabled =YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically =NO;
    
    NSMutableString *javascript = [NSMutableString string];
    
//    [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
//    [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
//    [self addJavascript:javascript];
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKWebView* webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
    [webView.configuration.userContentController addUserScript:noneSelectScript];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
//    webView.opaque = NO;
    webView.scrollView.delegate = self;
    webView.scrollView.bounces = NO;
//    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    self.webview = webView;
    [self.webview.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionInitial context:nil];
    [self.webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)initFootView{
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    self.footView.backgroundColor = [UIColor whiteColor]; //加载过程中为白色，加载完成后问灰色
    [self.view addSubview:self.footView];
}

-(void)setFontState:(NSInteger)fontState{
    FontSize = fontState;
    isSetFont = YES;
}

-(void)setFont:(NSInteger)font{
    FontSize = font;
    isSetFont = YES;
    [self setWebView_Font:self.webview AndType:FontSize];

//    m_size = [self getWebviewSize];

    [self.delegate setHeaderFrame];
}

#pragma mark - contentSize代理
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"contentSize"]){
        
        CGSize size = [self.webview sizeThatFits:CGSizeZero];
        self.webview.frame = CGRectMake(0, 0, size.width, size.height);
        self.footView.frame = CGRectMake(0, self.webview.frame.size.height, SCREEN_WIDTH, self.footView.frame.size.height);

        self.view.frame = CGRectMake(0, 0, size.width, size.height+self.footView.frame.size.height);

//            m_size = self.view.frame.size;
            [self.delegate setHeaderFrame];
    }
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webview.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }
}

#pragma mark - webview代理
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
//    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';"completionHandler:nil];
    
    [self getImageUrlByJS:webView];
    
    //获取段落内容
    //获取所有的html
    NSString *allHtml = @"document.documentElement.innerHTML";
    
    //    //获取网页title
    //    NSString *htmlTitle = @"document.title";
    //    //获取网页的一个值
    //    NSString *htmlNum = @"document.getElementById('figure').innerText";
    
    //获取到得网页内容
//    NSString *text_all = [[NSString alloc]init];
    [self.webview evaluateJavaScript:allHtml completionHandler:^(id Result, NSError * error) {
        //        NSLog(@"js___Result==%@",Result);
        //        NSLog(@"js___Error -> %@", error);
        NSString* allHtmlInfo = (NSString*)Result;
        TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:[allHtmlInfo dataUsingEncoding:NSUTF8StringEncoding]];
        // 根据标签进行筛选 获取所有标签是<p>的代码块
        NSArray *elements  = [xpathParser searchWithXPathQuery:@"//p"];
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
        [self.delegate webViewDidLoad:text_all];
    }];
    
    
    if(!isSetFont){
        [self setWebView_Font:webView AndType:[[AppConfig sharedInstance] GetFontSize]];
    }else{
        [self setWebView_Font:webView AndType:FontSize];
    }
    
//    m_size = [self getWebviewSize];
    
    //通知
    [self.delegate webViewDidLoad:text_all];
    [self.delegate setHeaderFrame];
    m_isFirst = YES; //代表新闻加载完毕
    
    [webView.scrollView removeObserver:self forKeyPath:@"contentSize"];//加载完后删除监听，防止加载完成后，继续监听，使网页闪现
//    [webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self.delegate webViewLoadFailed];
}

-(CGSize)getSize{
    return m_size;
}

/*
 *通过js获取htlm中图片url
 */
-(void)getImageUrlByJS:(WKWebView *)wkWebView
{
    
    //查看大图代码
    //js方法遍历图片添加点击事件返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgUrlStr='';\
    for(var i=0;i<objs.length;i++){\
    if(i==0){\
    if(objs[i].alt==''){\
    imgUrlStr=objs[i].src;\
    }\
    }else{\
    if(objs[i].alt==''){\
    imgUrlStr+='#'+objs[i].src;\
    }\
    }\
    objs[i].onclick=function(){\
    if(this.alt==''){\
    document.location=\"myweb:imageClick:\"+this.src;\
    }\
    };\
    };\
    return imgUrlStr;\
    };";
    
    //用js获取全部图片
    [wkWebView evaluateJavaScript:jsGetImages completionHandler:^(id Result, NSError * error) {
        NSLog(@"js___Result==%@",Result);
        NSLog(@"js___Error -> %@", error);
    }];
    
    
    NSString *js2=@"getImages()";
    
    __block NSArray *array=[NSArray array];
    [wkWebView evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {
//        NSLog(@"js2__Result==%@",Result);
//        NSLog(@"js2__Error -> %@", error);
        
        NSString *resurlt=[NSString stringWithFormat:@"%@",Result];
        
        if([resurlt hasPrefix:@"#"])
        {
            resurlt=[resurlt substringFromIndex:1];
        }
//        NSLog(@"result===%@",resurlt);
        array=[resurlt componentsSeparatedByString:@"#"];
//        NSLog(@"array====%@",array);
//        [self setMethod:array];
        _mUrlArray = [NSMutableArray arrayWithArray:array];
    }];
    
}

//- (void)setMethod:(NSArray *)imgUrlArray
//{
//    objc_setAssociatedObject(self, &imgUrlArrayKey, imgUrlArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

//-(CGSize)getWebviewSize{

//    [self.webview evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id Result, NSError * error) {
//        NSNumber* number = (NSNumber*)Result;
//        _webviewHight = [number floatValue];
//        NSLog(@"CGFloatwebViewHeight:%f",_webviewHight); //这个高度准确
//        CGSize size = CGSizeZero;
//        size = CGSizeMake(SCREEN_WIDTH, _webviewHight);
//        self.webview.frame = CGRectMake(0, 0, size.width, size.height);
//        self.footView.frame = CGRectMake(0, size.height, SCREEN_WIDTH, self.footView.frame.size.height);
//        self.view.frame = CGRectMake(0, 0, size.width, size.height+self.footView.frame.size.height);
//        return self.view.frame.size;
//    }];
////    CGFloat webViewHeight =[[self.webview stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
////    return self.view.frame.size;
//}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    //预览图片
    for (int i=0;i<_mUrlArray.count;i++) {
        NSString* url = _mUrlArray[i];
        NSString* str = @"myweb:imageClick:";
        str = [NSString stringWithFormat:@"%@%@",str,url];
        //        NSLog(@"---图片点击方法:%@",request.URL.scheme);
        //        NSLog(@"---request.URL:%@",request.URL);
        
        NSString* url_now = navigationAction.request.URL.absoluteString;
        if ([url_now isEqualToString:str]) {
            [self.delegate showWebImages:_mUrlArray AndIndex:i];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    //点击广告时
    if(navigationAction.navigationType == UIWebViewNavigationTypeLinkClicked){
        NSLog(@"UIWebViewNavigationTypeLinkClicked-----------");
        if(!m_isFirst){ //第一次进入为UIWebViewNavigationTypeOther 类型，之后广告点击 也是UIWebViewNavigationTypeOther类型
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
        [self.delegate showGuangGao:navigationAction.request];
        // 如果返回NO，代表不允许加载这个请求
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
    
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

-(void)setWebView_Font:(WKWebView*)webView AndType:(NSInteger)type{
//    NSString *jsString = @"";
//    NSString* str = [NSString stringWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",5.0,@"red"];
//    NSString* str1 = [NSString stringWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",10.0,@"red"];
//    NSString* str2 = [NSString stringWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",15.0,@"red"];
    switch (type) {
        case Font_Big:
            //字体大小
            [self.webview evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'" completionHandler:nil];
//            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'"];
//            jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",20.,@"red"];
//            [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'"];
            break;
        case Font_Normal:
            //字体大小
            [self.webview evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'" completionHandler:nil];
//            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
//            jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",18.0,@"red"];
//            [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
            break;
        case Font_small:
            //字体大小
            [self.webview evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'" completionHandler:nil];
//            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'"];
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
            [self.webview evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'" completionHandler:nil];
//            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
            break;
        case Font_Normal:
            //字体颜色
            [self.webview evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'red'" completionHandler:nil];
//            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'red'"];
//            [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'red'"];
            break;
        case Font_small:
            //字体颜色
            [self.webview evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'" completionHandler:nil];
//            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
            break;
            
        default:
            break;
    }
}

-(void)setWebView_backgroundColor:(UIWebView*)webView AndType:(NSInteger)type{
    switch (type) {
        case Font_Big:
            //背景颜色
//            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
//            [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
            break;
        case Font_Normal:
            //背景颜色
//            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
            break;
        case Font_small:
            //背景颜色
//            [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
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
