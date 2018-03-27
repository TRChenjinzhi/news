//
//  Agreement_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/2/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Agreement_ViewController.h"
#import "LabelHelper.h"


@interface Agreement_ViewController ()

@end

@implementation Agreement_ViewController{
    UIView*         m_navibar_view;
    NSArray*        m_array_content;
    UIScrollView*   m_scrollview;
    UIWebView*      m_webview;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavi];
//    [self initView];//本地的方式
    [self initWebview];//使用网络
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initNavi{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [back_button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_button];
    
    //    UIButton* edit_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-56-14, 21, 56, 14)];
    //    [edit_button setTitle:@"编辑" forState:UIControlStateNormal];
    //    [edit_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [edit_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:14]];
    //    [edit_button addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    //    [navibar_view addSubview:edit_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-150/2, 18, 150, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"隐私及版权说明";
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
    [navibar_view addSubview:title];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 56-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    [navibar_view addSubview:line];
    
    [self.view addSubview:navibar_view];
    m_navibar_view = navibar_view;
}

-(void)initWebview{
    UIWebView* webview = [[UIWebView alloc] init];
    m_webview = webview;
    if(!_isTask){
        webview.frame = CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame), SCREEN_WIDTH,
                                   SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame));
    }else{
        webview.frame = CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame), SCREEN_WIDTH,
                                   SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame)-30);
    }
    
    webview.scrollView.bounces = NO;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://toutiao.3gshow.cn/protocol.html"]];
//    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://toutiao.3gshow.cn/io.php?id=587779"]];
    [webview loadRequest:request];
    
    [self.view addSubview:webview];
}



-(void)initView{
    UIScrollView* Main_scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(m_navibar_view.frame),
                                                                                  SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(m_navibar_view.frame))];
    Main_scrollview.bounces = NO;
    m_scrollview = Main_scrollview;
    
    CGFloat hight = 10;
    CGFloat lineInstance = 20;
    CGFloat fontSize = 10;
    
    [self getData];
    for (NSString* str in m_array_content) {
        CGFloat textHight = [LabelHelper GetLabelHight:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:fontSize]
                                               AndText:str
                                              AndWidth:SCREEN_WIDTH-10];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(5, hight, SCREEN_WIDTH-10, textHight)];
        label.text = str;
        label.textColor = [UIColor colorWithRed:34/255.0 green:39/255.0 blue:39/255.0 alpha:1/1.0];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:fontSize];
        
        NSDictionary *dic = @{NSKernAttributeName:@1.f};//字间距
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];//行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        [label setAttributedText:attributedString];
        [label sizeToFit];
        
        [Main_scrollview addSubview:label];
        
        hight = hight + label.frame.size.height + lineInstance;
    }
    
    Main_scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, hight);
    
    [self.view addSubview:Main_scrollview];
    
}

-(void)getData{
    m_array_content = @[@"考拉头条用户服务协议",
                        @"首部及导言",
                        @"本协议为您（用户）与考拉头条开发管理者及其相关合作方之间所订立的具有法律效力的合同，请您仔细阅读。",
                        @"第一条 声明",
                        @"1.1、考拉头条郑重提醒用户注意本协议中免除考拉头条责任和限制用户权利的条款，请用户仔细阅读，自主考虑风险。无民事行为能力人和限制行为能力人应在监护人的陪同下阅读本协议。",
                        @"1.2、您下载、安装或使用考拉头条软件，即表示您同意遵守本用户服务协议（下称\"本协议\"）的全部条款。如您不同意遵守本条款，则请勿下载、复制、使用本软件或者点击确认接受本协议条款。",
                        @"1.3、本协议可由考拉头条根据实际情况进行更新，更新后的协议条款一经公布即替代原条款内容并生效，请您注意本协议的更新通知，通知方式详见第2.1条，除此之外恕不另行通知。 如您不同意本协议的修改更新条款，您可以选择停止使用考拉头条软件及其提供的所有服务；如您继续使用考拉头条软件或其提供的服务即被视为您同意本协议的更新条款。",
                        @"1.4、您须为具有法定的相应权利能力和行为能力的自然人，能够独立承担法律责任。您下载、安装或使用考拉头条APP软件或其提供的服务时，即视为您确认自己具备主体资格，能够独立承担法律责任。 若因您不具备主体资格，而导致的一切后果，由您及您的监护人自行承担。",
                        @"第二条 协议内容",
                        @"2.1、您理解并同意考拉头条通过以下途径发布的有关产品说明、产品使用规则、产品金币规则、用户规则等所有规则，规则一经发布即生效并成为本协议不可分割的一部分，受本协议约束，并对您产生法律效力：",
                        @"2.1.1、考拉头条软件内部通知",
                        @"2.1.2、考拉头条官方网站或官方微博、官方微信通知",
                        @"2.2、您理解并同意考拉头条通过上述途径公布的金币累积和使用规则，同时，我们在此特别强调用户在使用本服务前需要注册一个“考拉头条”帐号。“考拉头条”帐号应当使用手机号码绑定注册， 请用户使用尚未与“考拉头条”帐号绑定的手机号码以及未被考拉头条根据本协议封禁的手机号码注册“考拉头条”帐号。考拉头条可以根据用户需求或产品需要对帐号注册和绑定的方式进行变更，而无须事先通知用户。",
                        @"2.3、如果注册申请者有被考拉头条封禁的先例或涉嫌虚假注册及滥用他人名义注册，及其他不能得到许可的理由，考拉头条将拒绝其注册申请。",
                        @"2.4、考拉头条金币不等同于现金，没有任何实际价值，金币累积不视为您拥有对考拉头条及其开发管理者拥有民事债权或其他任何权利。",
                        @"2.5、考拉头条金币的累积和使用应遵守考拉头条制定的相应规则，违规行为将根据相关规则进行处理。",
                        @"第三条 免责条款",
                        @"3.1、考拉头条为您提供的任何广告宣传信息，您应谨慎判断确定相关广告或信息。除非另有明确的书面说明，各商家在考拉头条软件发布的广告、信息、内容、材料均不构成考拉头条对任何线上或线下交易行为的推荐或担保， 法律法规另有规定的除外。",
                        @"3.2、以下情况，考拉头条不承担任何法律责任：",
                        @"3.2.1、第三方未经允许的使用您的账户或更改您的账户、有关数据。",
                        @"3.2.2、违规使用考拉头条软件导致的任何损失或责任。",
                        @"3.2.3、 因不可抗力、信息网络正常的设备维护、信息网络连接故障、电脑、通讯或其他系统的故障、电力故障、劳动争议、司法行政机关的命令或第三方的不作为 及其他考拉头条无法控制的原因造成的不能服务或延迟服务、丢失数据信息、记录等造成的损失或责任。",
                        @"3.2.4、任何非因考拉头条的原因而引起的与服务有关的其它损失。",
                        @"3.3、在遵守相关法律法规前提下，根据合作广告主的要求，考拉头条有权决定用户在“考拉头条”软件界面上看到的广告内容。",
                        @"第四条 金币获取与使用规则",
                        @"4.1、用户需从官方渠道下载安装考拉头条官方提供的“考拉头条”软件（APP），并在该软件内部通过阅读，参与任务以及活动等操作获取金币收益。",
                        @"4.2、用户在“考拉头条”软件内获取的金币收益只可在本软件内进行商品兑换消费或提现、充值。",
                        @"4.3、用户可以在“考拉头条”软件中查看自己累计的金币收益情况。",
                        @"4.4、因网络延迟原因，用户在“考拉头条”软件中看到的累计金币收益可能与考拉头条服务器端存在统计差异，实际金币收益以服务器端记录为准。",
                        @"4.5、用户在“考拉头条”软件中获取的金币收益不能在用户间相互转让，不能使用包括人民币在内的任何法定货币购买，不具有在“考拉头条”软件以外的环境中进行交易结算的功能。",
                        @"4.6、用户在使用“考拉头条”时作出特定行为将会获得的金币金额由考拉头条自主决定，考拉头条可视实际情况更改各项行为将会产生的金币收益值。",
                        @"4.7、用户使用获得的金币收益能够兑换的商品及服务的种类与兑换价格由考拉头条自主决定。",
                        @"4.8、如果用户的累计金币收益金额出现错误，用户可以自出现错误之日起30天以内向考拉头条提出更正要求，考拉头条如果确定该用户的要求为正当合理，应在用户提出要求之日起90天以内更正错误。",
                        @"4.9、长期不运行“考拉头条”软件的用户（非活跃用户）所获得金币收益自动被清零。长期不运行指100天内没有运行“考拉头条”软件，或没有完成一次在“考拉头条”软件中金币获取操作。",
                        @"第五条 服务的变更、中断、终止",
                        @"5.1、考拉头条有权在有正当合法的理由时中止、终止向您提供部分或全部服务，暂时冻结或永久冻结（注销）您的收益金额或账户，无须承担额外的责任。",
                        @"5.2、您的账户被注销（永久冻结）后，考拉头条没有义务为您保留或向您披露您账户中的任何信息，也没有义务向您或第三方转发任何您未曾阅读或发送过的信息。",
                        @"5.3、您与考拉头条的合同关系终止后，考拉头条仍享有下列权利：",
                        @"5.3.1、继续保存您的注册信息及您使用考拉头条及其服务期间的所有信息。",
                        @"5.3.2、您在使用考拉头条及其服务期间存在违法行为或违反本协议规则的行为的，考拉头条仍可依据本协议规定向您主张相关权利。",
                        @"5.4、考拉头条在接到他人投诉、后台数据显示或依据其他合理规则判定您存在违规行为的，有权依本协议规定采取相应措施。对于包括不限于以下用户行为，考拉头条视之为用户作弊行为， 有权拒绝相关用户的收益兑换或提现订单，有权核减或删除相关用户的部分或所有收益，有权终止对相关用户的一切服务；同时对相关作弊行为保留追究法律责任的权力。",
                        @"5.4.1、擅自反编译修改“考拉头条”软件程序制造虚假收益数据；",
                        @"5.4.2、采取非法手段入侵或攻击考拉头条服务器制造虚假收益数据；",
                        @"5.4.3、利用手机设备库存资源采取刷机刷量等方式邀请虚假用户，制造虚假收益数据；",
                        @"5.4.4、在没有充分告知其他潜在用户的情况下使得该潜在用户虽然安装了“考拉头条”软件但没有正常使用行为或使用行为极少，产生异常收益数据。",
                        @"5.5、因设备维修或更换、故障和通信中断等技术原因而中断业务，考拉头条可视情况事前或事后通知用户。",
                        @"5.6、考拉头条临时中断业务时将在考拉头条官方网站或考拉头条软件内界面中公告。",
                        @"5.7、如果因考拉头条临时业务中断而导致用户的金币收益数据丢失，考拉头条会给予丢失数据的用户相应的收益补偿，具体补偿数量由考拉头条根据实际情况决定。 但因不可抗力导致的业务中断发生时，考拉头条不给予用户补偿。",
                        @"5.8、当考拉头条用户发生如下情况时，考拉头条有权单方终止本协议，取消用户继续使用考拉头条产品及服务的资格：",
                        @"5.8.1、用户死亡或被宣告失踪、宣告死亡；",
                        @"5.8.2、盗用他人的个人信息或手机；",
                        @"5.8.3、注册用户时提供虚假信息；",
                        @"5.8.4、以非法手段（包括且不限于黑客攻击等）来积累或使用金币收益；",
                        @"5.8.5、妨碍其他用户的正常使用；",
                        @"5.8.6、伪称是考拉头条的工作人员或管理人员；",
                        @"5.8.7、擅自强行更改考拉头条的计算机系统，或威胁侵入系统；",
                        @"5.8.8、擅自传播谣言，用各种手段来毁损考拉头条的名誉与妨碍考拉头条的正常营业；",
                        @"5.8.9、利用考拉头条的产品及服务宣传垃圾广告或骚扰信息；",
                        @"5.8.10、其他违反本协议的行为及违法行为。",
                        @"5.8.11、用户如因上述第5.8.1条原因而被取消用户资格，用户法定财产继承人可在用户资格被取消之日起10日内向考拉头条提出书面申请， 将该用户剩余金币收益转移至自己所有的考拉头条帐号下，否则考拉头条有权删除该用户剩余的金币收益。",
                        @"5.8.12、用户如因上述第5.8.2条到第5.8.10条的原因而被取消用户资格，考拉头条有权立即删除该用户的全部金币收益，同时保留追究其法律及其他责任的权利。",
                        @"第六条 法律适用",
                        @"6.1、本协议的订立、执行和解释及争议的解决均应适用在中华人民共和国大陆地区现行有效法律、法规、规章等。 如发生本协议条款与适用法律、法规、规章相抵触，则这些条款将完全按法律、法规、 规章规定重新解释，但其它有效条款继续有效。",
                        @"6.2、本协议履行过程中，因您使用考拉头条及其服务产生争议应由考拉头条与您沟通并协商处理。协商不成时，您同意以考拉头条开发管理者住所地人民法院为管辖法院。",
                        @"第七条 知识产权保护",
                        @"7.1、考拉头条的商标、广告业务以及所提供的有关广告内容的知识产权都归属于北京百米传媒广告有限公司或广告主。用户从考拉头条获得的信息内容未经许可不能擅自复制、发布与出版。",
                        @"第八条 其他",
                        @"8.1、本协议的任何条款无论因何种原因无效或不具可执行性，其余条款仍有效，对双方具有约束力",
                        @"8.2、本协议的版权由北京百米传媒广告有限公司享有，在法律法规允许的范围内北京百米传媒广告有限公司保留解释和修改的权利。",
                        @"8.3、本协议从2018年2月1日起适用。"];
}


#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
