//
//  Mine_userInfo_ViewController.m
//  新闻
//
//  Created by chenjinzhi on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Mine_userInfo_ViewController.h"
#import "Mine_userInfo_view.h"
#import "AFNetworking.h"
#import "AFURLConnectionOperation.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

typedef enum : NSUInteger {
    Type_userInfo_name,
    Type_userInfo_sex,
    Type_userInfo_masterCode
} Type_userInfo;

@interface Mine_userInfo_ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,MyWindos_protocol>

@end

@implementation Mine_userInfo_ViewController{
    UIView*     m_navibar_view;
    UIImage*    m_selected_image;
    Mine_userInfo_model*    m_userInfo_model;
    
    Mine_userInfo_view*     m_img;
    Mine_userInfo_view*     m_name;
    Mine_userInfo_view*     m_sex;
    Mine_userInfo_view*     m_shifu;
    UIView*                 m_shifuInfo_view;
    UITapGestureRecognizer* tap_shifu;
    
    UIImageView*    m_test_img;
    UIImagePickerController *ipc;
    
    MyWindows*              m_windows;
    NSInteger               m_type_index;//1.昵称 2.性别 3.邀请码
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavibar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /* 增加监听（当键盘出现或改变时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformDialog:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initNavibar{
    UIView* navibar_view = [[UIView alloc] initWithFrame:CGRectMake(0, StaTusHight, SCREEN_WIDTH, 56)];
    
    UIButton* back_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [back_button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [back_button setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navibar_view addSubview:back_button];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80/2, 18, 80, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"个人信息";
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

-(void)setUserInfo_model:(Mine_userInfo_model *)userInfo_model{
    m_userInfo_model = userInfo_model;
    Mine_userInfo_view* img_view = [[Mine_userInfo_view alloc] initWithFrame:CGRectMake(0, StaTusHight+56, SCREEN_WIDTH, 60)];
    img_view.title = @"头像";
    img_view.icon = userInfo_model.icon;
    img_view.isImg = YES;
    UITapGestureRecognizer* tap_img = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(img_action)];
    [img_view addGestureRecognizer:tap_img];
    m_img = img_view;
    
    Mine_userInfo_view* name_view = [[Mine_userInfo_view alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(img_view.frame), SCREEN_WIDTH, 60)];
    name_view.title = @"昵称";
    name_view.name = userInfo_model.name;
    name_view.isImg = NO;
    UITapGestureRecognizer* tap_name = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(name_action)];
    [name_view addGestureRecognizer:tap_name];
    m_name = name_view;
    
    Mine_userInfo_view* sex_view = [[Mine_userInfo_view alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(name_view.frame), SCREEN_WIDTH, 60)];
    sex_view.title = @"性别";
    sex_view.name = userInfo_model.sex;
    sex_view.isImg = NO;
    UITapGestureRecognizer* tap_sex = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sex_action)];
    [sex_view addGestureRecognizer:tap_sex];
    m_sex = sex_view;
    
    Mine_userInfo_view* shifu_view = [[Mine_userInfo_view alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sex_view.frame), SCREEN_WIDTH, 60)];
    shifu_view.title = @"我的师傅";
    NSString* masterCode = [Login_info share].userInfo_model.mastercode;
    
    
    NSString* master_text = [Login_info share].userInfo_model.master_name;
    if(master_text.length > 6){
        master_text = [NSString stringWithFormat:@"%@..%@",[master_text substringToIndex:2],[master_text substringFromIndex:master_text.length-2]];
    }
    CGFloat text_width = [LabelHelper GetLabelWidth:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:16] AndText:master_text];
    UILabel* master_label = [[UILabel alloc] initWithFrame:CGRectMake(10+24, 60/2-24/2, text_width, 24)];
    master_label.text = master_text;
    master_label.textColor = [[ThemeManager sharedInstance] MineUserInfoCellNameColor];
    master_label.textAlignment = NSTextAlignmentRight;
    master_label.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:16];
    
    UIImageView* masterIcon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(master_label.frame)-24-10, 19, 24, 24)];
    [masterIcon sd_setImageWithURL:[NSURL URLWithString:[Login_info share].userInfo_model.master_avatar]];
    [masterIcon.layer setCornerRadius:24/2];
    [masterIcon.layer setMasksToBounds:YES];
    
    UIView* shifu_info_view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-text_width-10-24, 0, text_width+10+24, 60)];
    [shifu_info_view addSubview:master_label];
    [shifu_info_view addSubview:masterIcon];
    
    m_shifuInfo_view = shifu_info_view;
    if(masterCode.length > 0){
        shifu_view.m_view_shifu = m_shifuInfo_view;
    }else{
        shifu_view.name = @"点击输入邀请码";
        shifu_view.isImg = NO;
        tap_shifu = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addShifu)];
        [shifu_view addGestureRecognizer:tap_shifu];
    }
    m_shifu = shifu_view;
    
    
//    m_sex = sex_view;
    
    
    UIButton* outLogin_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-240/2, CGRectGetMaxY(shifu_view.frame)+30, 240, 40)];
    [outLogin_button setTitle:@"注销登录" forState:UIControlStateNormal];
    [outLogin_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [outLogin_button.titleLabel setFont:[UIFont fontWithName:@"SourceHanSansCN-Regular" size:16]];
    outLogin_button.backgroundColor = [UIColor colorWithRed:248/255.0 green:205/255.0 blue:4/255.0 alpha:1/1.0];
    [outLogin_button.layer setCornerRadius:10.0f];
    [self.view addSubview:outLogin_button];
    self.outLogin = outLogin_button;
    
    
//    NSLog(@"img Y-->%f",img_view.frame.origin.y);
//    NSLog(@"name Y-->%f",name_view.frame.origin.y);
//    NSLog(@"sex Y-->%f",sex_view.frame.origin.y);
    
    [self.view addSubview:img_view];
    [self.view addSubview:name_view];
    [self.view addSubview:sex_view];
    [self.view addSubview:shifu_view];
}

-(void)img_action{
    //从手机相册中选择上传图片
    [self getImageFromIpc];
}
-(void)name_action{
    [self xiugai_name];
}
-(void)sex_action{
    [self xiugai_sex];
}
- (void)getImageFromIpc
{
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相簿)
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 照相机
    // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 4.设置代理
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    ipc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    // 5.modal出这个控制器
//    [self presentViewController:ipc animated:YES completion:nil];
//    [self.navigationController pushViewController:ipc animated:YES];
    [self.navigationController presentViewController:ipc animated:YES completion:nil];
}
#pragma mark 调用系统相册及拍照功能实现方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 设置图片
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    
    //压缩图片
    image = [self imageWithImageSimple:image scaledToSize:CGSizeMake(48, 48)];
    m_selected_image = image;
    
    //提示等待
    [self postUpload_icon];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
#pragma mark - 头像上传
- (void)postUpload_icon
{
    NSString *args = @"json=";
    NSString* argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share]GetUserInfo].user_id]];
    NSString* sex = [m_userInfo_model.sex isEqualToString:@"男"]?@"1":@"0";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"name",m_userInfo_model.name]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"sex",sex]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    NSString* url = [NSString stringWithFormat:@"http://younews.3gshow.cn/member/UpdateMember?%@",args];
    AFHTTPRequestOperationManager *AFH_manager = [AFHTTPRequestOperationManager manager];
    // AFHTTPResponseSerializer就是正常的HTTP请求响应结果:NSData
    // 当请求的返回数据不是JSON,XML,PList,UIImage之外,使用AFHTTPResponseSerializer
    // 例如返回一个html,text...
    //
    // 实际上就是AFN没有对响应数据做任何处理的情况
    AFH_manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // formData是遵守了AFMultipartFormData的对象
    [AFH_manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 将本地的文件上传至服务器
//        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        [formData appendPartWithFileData:UIImagePNGRepresentation(m_selected_image) name:@"avatar" fileName:@"avatar.png" mimeType:@"image/png"];
//        [formData appendPartWithFileURL:fileURL name:@"avatar" error:NULL];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //{"code":200,"msg":"succ","list":{"user_id":"f25ec3a25a3e60f0a41cbb7d8f6ff6e5","avatar":"http://ad-manager.b0.upaiyun.com/avatar/f25ec3a25a3e60f0a41cbb7d8f6ff6e5.jpg","name":"3823_5529821","sex":"0"}}
        
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        
        //保存
        m_userInfo_model.icon = dic[@"list"][@"avatar"];
        [Login_info share].userInfo_model.avatar = dic[@"list"][@"avatar"];
        
        
        [self xiugai_userInfo];

        //保存用户头像
        [[AppConfig sharedInstance]saveUserIcon:m_selected_image];

        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:@"修改成功"];
            //修改头像
            m_img.icon = m_userInfo_model.icon;
        });
        NSLog(@"完成 %@", result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误 %@", error.localizedDescription);
        [MBProgressHUD showSuccess:@"修改失败"];
    }];
}


-(void)xiugai_name{
    m_type_index = Type_userInfo_name;
    m_windows = [[MyWindows alloc] initWithFrame:[UIScreen mainScreen].bounds];
    m_windows.title = @"编辑昵称";
    m_windows.delegate = self;
    m_windows.type  = Type_TextField;
    [[UIApplication sharedApplication].keyWindow addSubview:m_windows];
}

-(void)xiugai_sex{
    m_type_index = Type_userInfo_sex;
    m_windows = [[MyWindows alloc] initWithFrame:[UIScreen mainScreen].bounds];
    m_windows.title = @"选择性别";
    m_windows.array_choose = @[@"男",@"女"];
    m_windows.delegate = self;
    m_windows.type  = Type_Choose;
    [[UIApplication sharedApplication].keyWindow addSubview:m_windows];
}

-(void)xiugai_userInfo{
    //修改本地用户信息
    NSMutableDictionary* dic_userInfo_all = [[NSMutableDictionary alloc]initWithDictionary:[[AppConfig sharedInstance] GetUserInfo]];
    NSMutableDictionary* dic_userInfo = [[NSMutableDictionary alloc]initWithDictionary:dic_userInfo_all[@"userinfo"]];
    [dic_userInfo setValue:m_userInfo_model.icon forKey:@"avatar"];
    [dic_userInfo setValue:m_userInfo_model.name forKey:@"name"];
    [dic_userInfo setValue:m_userInfo_model.sex forKey:@"sex"];
    
    [dic_userInfo_all setValue:dic_userInfo forKey:@"userinfo"];
    [Login_info share].userInfo_model.name = m_userInfo_model.name;
    [Login_info share].userInfo_model.sex = m_userInfo_model.sex;
    [Login_info share].userInfo_model.avatar = m_userInfo_model.icon;
    [Login_info dicToModel:dic_userInfo_all];
}

-(void)upDateUserInfo{
    // 1.创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://younews.3gshow.cn/member/UpdateMember"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *args = @"json=";
    NSString *argument = @"{";
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",@"user_id",[[Login_info share]GetUserInfo].user_id]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"name",m_userInfo_model.name]];
    argument = [argument stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",@"sex",m_userInfo_model.sex]];
    argument = [argument stringByAppendingString:@"}"];
    argument = [MyEntrypt MakeEntryption:argument];
    args = [args stringByAppendingString:[NSString stringWithFormat:@"%@",argument]];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(error){
                NSLog(@"网络获取失败");
                //发送失败消息
                [MyMBProgressHUD ShowMessage:@"网络错误" ToView:self.view AndTime:1.0f];
                return ;
            }
            
            NSLog(@"GetNetData_package从服务器获取到数据");
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSNumber* code = dict[@"code"];
            if([code longValue] != 200){
                [MyMBProgressHUD ShowMessage:@"修改失败" ToView:self.view AndTime:1.0f];
                return;
            }
            [MyMBProgressHUD ShowMessage:@"修改成功" ToView:self.view AndTime:1.0f];
        });
        
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

//拜师
-(void)addShifu{
    m_type_index = Type_userInfo_masterCode;
    m_windows = [[MyWindows alloc] initWithFrame:[UIScreen mainScreen].bounds];
    m_windows.title = @"输入邀请码";
    m_windows.delegate = self;
    m_windows.type  = Type_TextField;
    [[UIApplication sharedApplication].keyWindow addSubview:m_windows];
//    UIAlertController* Alert_ctr = [UIAlertController alertControllerWithTitle:@"我的师傅" message:@"输入邀请码" preferredStyle:UIAlertControllerStyleAlert];
//
//    [Alert_ctr addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"输入邀请码";
//    }];
//
//    [Alert_ctr addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //获取第1个输入框；
//        UITextField *userNameTextField = Alert_ctr.textFields.firstObject;
//
//        [InternetHelp BaiShi_API:userNameTextField.text Sucess:^(NSDictionary *dic) {
//            NSDictionary* dic_tmp = dic[@"list"];
//            [Login_info share].userInfo_model.mastercode = dic_tmp[@"master_code"];
//            [Login_info share].userInfo_model.master_name = dic_tmp[@"master_name"];
//            [Login_info share].userInfo_model.master_avatar = dic_tmp[@"master_avatar"];
//
//            [MyMBProgressHUD ShowMessage:@"拜师成功" ToView:self.view AndTime:1];
//
//            m_shifu.m_view_shifu = m_shifuInfo_view;
//            tap_shifu.enabled = NO;
//
//        } Fail:^(NSDictionary *dic) {
//            if(dic == nil){
//                [MyMBProgressHUD ShowMessage:@"网络错误" ToView:self.view AndTime:1];
//            }else{
//                NSString* msg = dic[@"msg"];
//                [MyMBProgressHUD ShowMessage:msg ToView:self.view AndTime:1];
//            }
//        }];
//    }]];
//
//    [Alert_ctr addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
//    }]];
//
//    [self presentViewController:Alert_ctr animated:true completion:nil];
}

#pragma mark - 协议
-(void)returnString:(NSString *)str{
    switch (m_type_index) {
        case Type_userInfo_name:{
            m_userInfo_model.name = str;
            m_name.name = m_userInfo_model.name;
            [self xiugai_userInfo];
            [self upDateUserInfo];
            break;
        }
        case Type_userInfo_sex:{
            if([str isEqualToString:@"男"]){
                m_userInfo_model.sex = @"1";
                m_sex.name = @"男";
            }
            else{
                m_userInfo_model.sex = @"0";
                m_sex.name = @"女";
            }
            [self xiugai_userInfo];
            [self upDateUserInfo];
            break;
        }
        case Type_userInfo_masterCode:{
            [InternetHelp BaiShi_API:str Sucess:^(NSDictionary *dic) {
                NSDictionary* dic_tmp = dic[@"list"];
                [Login_info share].userInfo_model.mastercode = dic_tmp[@"master_code"];
                [Login_info share].userInfo_model.master_name = dic_tmp[@"master_name"];
                [Login_info share].userInfo_model.master_avatar = dic_tmp[@"master_avatar"];
                
                [MyMBProgressHUD ShowMessage:@"邀请成功" ToView:self.view AndTime:1];
                
                m_shifu.m_view_shifu = m_shifuInfo_view;
                tap_shifu.enabled = NO;
                
            } Fail:^(NSDictionary *dic) {
                if(dic == nil){
                    [MyMBProgressHUD ShowMessage:@"网络错误" ToView:self.view AndTime:1];
                }else{
                    NSString* msg = dic[@"msg"];
                    [MyMBProgressHUD ShowMessage:msg ToView:self.view AndTime:1];
                }
            }];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 通知
//移动UIView(随着键盘移动)
-(void)transformDialog:(NSNotification *)aNSNotification
{
    NSLog(@"Mine_userInfo_VCL移动");
    //键盘最后的frame
    CGRect keyboardFrame = [aNSNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    NSLog(@"Mine_userInfo_VCL看看这个变化的Y值:%f",height);

    [m_windows setCenterViewFrame:height];
}

-(void)keyboardWillHide:(NSNotification *)aNSNotification{
    [m_windows setCenterViewFrame:0];
}


#pragma mark - 按钮方法
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
