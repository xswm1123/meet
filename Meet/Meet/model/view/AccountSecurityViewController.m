//
//  AccountSecurityViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "AccountSecurityViewController.h"
#import "GesturePasswordController.h"
#import "ForgetPasswordViewController.h"

@interface AccountSecurityViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lb_phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *tf_oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *tf_newPasswor;
@property (weak, nonatomic) IBOutlet UISwitch *GestureSwitch;
@property (weak, nonatomic) IBOutlet BaseView *gestureBG;
@property (weak, nonatomic) IBOutlet UILabel *lb_iconArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToBtn;
//第三方登录相关
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *blindTap;
@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *QQBtn;

@end

@implementation AccountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lb_iconArrow.font=[UIFont fontWithName:iconFont size:18];
    self.lb_iconArrow.text=@"\U0000e639";
    self.GestureSwitch.on=[ShareValue shareInstance].isUsedGesturePassword;
    [self switchIsOn];
}
-(void)initView{
    //第三方登录
    
    NSString  * aliIcon=@"\U0000e62c";
    NSString * aliStr=@"\U0000e62c";
    UIColor * weColor;
    if ([ShareValue shareInstance].userInfo.weixinOpenid.length>0) {
        weColor=iconGreen;
        self.weChatBtn.enabled=NO;
    }else{
        weColor=[UIColor grayColor];
        self.weChatBtn.enabled=YES;
    }
    NSMutableAttributedString * ali=[[NSMutableAttributedString alloc]initWithString:aliStr];
    [ali addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:36],NSForegroundColorAttributeName:weColor} range:NSMakeRange(0, aliIcon.length)];
    [self.weChatBtn setAttributedTitle:ali forState:UIControlStateNormal];
    
    NSString  * weIcon=@"\U0000e62e";
    NSString * weStr=@"\U0000e62e";
    UIColor * QQColor;
    if ([ShareValue shareInstance].userInfo.qqOpenid.length>0) {
        QQColor=iconBlue;
        self.QQBtn.enabled=NO;
    }else{
        QQColor=[UIColor grayColor];
        self.QQBtn.enabled=YES;
    }
    NSMutableAttributedString * we=[[NSMutableAttributedString alloc]initWithString:weStr];
    [we addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:32],NSForegroundColorAttributeName:QQColor} range:NSMakeRange(0, weIcon.length)];
    [self.QQBtn setAttributedTitle:we forState:UIControlStateNormal];
    //绑定手机相关
    if ([ShareValue shareInstance].userInfo.mobile.length>0) {
        [self.lb_phoneNumber removeGestureRecognizer:self.blindTap];
        self.lb_phoneNumber.text=[ShareValue shareInstance].userInfo.mobile;
    }else{
        self.lb_phoneNumber.text=@"点击去绑定手机";
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initView];
}
- (IBAction)switchValueChanged:(id)sender {
    [self switchIsOn];
}
-(void)switchIsOn{
    if ([self.GestureSwitch isOn]) {
        self.gestureBG.hidden=NO;
        self.distanceToBtn.constant=59;
        [self updateViewConstraints];
        [ShareValue shareInstance].isUsedGesturePassword=YES;
    }else{
        self.gestureBG.hidden=YES;
        self.distanceToBtn.constant=9;
        [self updateViewConstraints];
        [ShareValue shareInstance].isUsedGesturePassword=NO;
    }
}
- (IBAction)saveAction:(id)sender {
    if (self.tf_newPasswor.text.length==0) {
        [MBProgressHUD showError:@"请输入新密码" toView:self.view];
        return;
    }
    if (self.tf_oldPassword.text.length==0) {
        [MBProgressHUD showError:@"请输入旧密码" toView:self.view];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ModifyPasswordRequest * request =[[ModifyPasswordRequest alloc]init];
    request.oldPwd=[NSString stringWithFormat:@"%@",self.tf_oldPassword.text];
    request.newPwd=[NSString stringWithFormat:@"%@",self.tf_newPasswor.text];
    [SystemAPI ModifyPasswordRequest:request success:^(ModifyPasswordResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.message toView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}
- (IBAction)showGesturePasswordView:(id)sender {
    GesturePasswordController * vc=[[GesturePasswordController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)blindAction:(id)sender {
    UIStoryboard * sb =[UIStoryboard storyboardWithName:@"Login" bundle:nil];
    ForgetPasswordViewController * vc =[sb instantiateViewControllerWithIdentifier:@"ForgetPasswordViewController"];
    vc.blind=@"绑定手机";
    [self.navigationController pushViewController:vc animated:YES];
}
//绑定微信
- (IBAction)blindWeChat:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [self blindExternWithOpenId:snsAccount.usid AndLoginType:@"2"];
            LMUserInfo* user =[ShareValue shareInstance].userInfo;
            user.weixinOpenid=snsAccount.usid;
            [ShareValue shareInstance].userInfo=user;
        }
        
    });

}
//绑定QQ
- (IBAction)blindQQ:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [self blindExternWithOpenId:snsAccount.usid AndLoginType:@"1"];
            LMUserInfo* user =[ShareValue shareInstance].userInfo;
            user.qqOpenid=snsAccount.usid;
            [ShareValue shareInstance].userInfo=user;
        }});

}
-(void)blindExternWithOpenId:(NSString * )openId AndLoginType:(NSString*)type{
    BlindExternRequest * request =[[BlindExternRequest alloc]init];
    request.openid=openId;
    request.loginType=type;
    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    [SystemAPI BlindExternRequest:request success:^(BlindExternResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [MBProgressHUD showMessag:response.message toView:self.view];
        [self initView];
    } fail:^(BOOL notReachable, NSString *desciption) {
         [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}
@end
