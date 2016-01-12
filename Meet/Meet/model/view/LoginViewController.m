//
//  LoginViewController.m
//  Meet
//
//  Created by Anita Lee on 15/7/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//
#ifdef __OBJC__
#import "LoginViewController.h"
#import "GesturePasswordController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDRCIMDataSource.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIImageView+WebCache.h"
#import "UIColor+RCColor.h"
#import "RCDCommonDefine.h"
#import "RCDHttpTool.h"
#import "AFHttpTool.h"
#import "RCDataBaseManager.h"
#import "APService.h"
#import "FieldProfileViewController.h"
//xxtea加密
#include "XXTEA.h"
#endif
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *fieldBGView;
@property (weak, nonatomic) IBOutlet UILabel *accountFont;
@property (weak, nonatomic) IBOutlet UITextField *tf_account;
@property (weak, nonatomic) IBOutlet UILabel *passwordFont;
@property (weak, nonatomic) IBOutlet UITextField *tf_password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToTop;
@property (weak, nonatomic) IBOutlet UIView *inputBg;
//第三方
@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *QQBtn;

@end
static NSString * loginType;
@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
-(void)initView{
    self.fieldBGView.layer.cornerRadius=5;
    self.loginBtn.layer.shadowOffset=CGSizeMake(0, 2);
    self.loginBtn.layer.shadowColor=TempleColor.CGColor;
    self.loginBtn.layer.shadowRadius=0;
    self.loginBtn.layer.shadowOpacity=0.6;
    
    self.accountFont.font=[UIFont fontWithName:iconFont size:24];
    self.accountFont.text=@"\U0000e61c";
    self.accountFont.textColor=[UtilTools colorWithHexString:@"#9b9b9b"];
    self.passwordFont.font=[UIFont fontWithName:iconFont size:24];
    self.passwordFont.text=@"\U0000e61d";
    self.passwordFont.textColor=[UtilTools colorWithHexString:@"#9b9b9b"];
    //第三方登录
    self.weChatBtn.layer.cornerRadius=8;
    self.weChatBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    self.weChatBtn.layer.borderWidth=2;
    NSString  * aliIcon=@"\U0000e62c";
    NSString * aliStr=@"\U0000e62c微信登录";
    NSMutableAttributedString * ali=[[NSMutableAttributedString alloc]initWithString:aliStr];
    [ali addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:36],NSForegroundColorAttributeName:iconGreen} range:NSMakeRange(0, aliIcon.length)];
    [ali addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:17],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(aliIcon.length, aliStr.length-aliIcon.length)];
    [self.weChatBtn setAttributedTitle:ali forState:UIControlStateNormal];
    
    self.QQBtn.layer.cornerRadius=8;
    self.QQBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    self.QQBtn.layer.borderWidth=2;
    NSString  * weIcon=@"\U0000e62e";
    NSString * weStr=@"\U0000e62eQQ登录";
    NSMutableAttributedString * we=[[NSMutableAttributedString alloc]initWithString:weStr];
    [we addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:36],NSForegroundColorAttributeName:iconBlue} range:NSMakeRange(0, weIcon.length)];
    [we addAttributes:@{NSFontAttributeName:[UIFont fontWithName:iconFont size:16],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(weIcon.length, weStr.length-weIcon.length)];
    [self.QQBtn setAttributedTitle:we forState:UIControlStateNormal];
    //为了审核！
    if (![WXApi isWXAppInstalled]) {
        self.QQBtn.hidden=YES;
        self.weChatBtn.hidden=YES;
    }
}
- (IBAction)forgetPassword:(id)sender {
    [self performSegueWithIdentifier:@"forgetPassword" sender:nil];
}

- (IBAction)loginACtion:(id)sender {
    if ([self isReadyToSubmmit]) {
        LoginRequest * request=[[LoginRequest alloc]init];
        request.account=self.tf_account.text;
        request.password=self.tf_password.text;
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        [SystemAPI LoginRequest:request success:^(LoginResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            LMUserInfo * user=[[LMUserInfo alloc]initWithDictionary:response.data];
            [ShareValue shareInstance].userInfo=user;
            RCUserInfo * info=[[RCUserInfo alloc]initWithUserId:[response.data objectForKey:@"id"] name:[response.data objectForKey:@"mobile"] portrait:[response.data objectForKey:@"avatar"]];
            //token
            NSString * token =user.token;
            //jiemi
            //xxTea 加密
            NSString * key =@"yckjyxgs!@#$%321";
            const   char * charKey =[key cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
           
            const char * charPraUrl =[token cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
            char * parResult =decrypt(charPraUrl, charKey);
            NSString * enPraUrl=[NSString stringWithCString:parResult encoding:NSStringEncodingConversionAllowLossy];
            
            NSArray * arr =[enPraUrl componentsSeparatedByString:@"|"];
            NSString * session=[arr firstObject];
            NSString * timeStamp =[arr lastObject];
            NSInteger server =timeStamp.integerValue/1000;
            NSDate * now=[NSDate new];
            NSDateFormatter  * frm =[[NSDateFormatter alloc]init];
            [frm setDateFormat:@"yyMMddHHmmss"];
            NSString * clientDate=[frm stringFromDate:now];
            NSInteger client =clientDate.integerValue;
            NSInteger timeDiff =server-client;
            [ShareValue shareInstance].session=session;
            [ShareValue shareInstance].timeDiff=[NSNumber numberWithInteger:timeDiff];
            
            [ShareValue shareInstance].RCUser=info;
            [ShareValue shareInstance].password=self.tf_password.text;
             [APService setTags:nil alias:[ShareValue shareInstance].userInfo.mobile callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            [self loginInRCM];
            [self showIndexVC];
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            [MBProgressHUD showError:desciption toView:self.view.window];
        }];

    }
}
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
-(void)loginInRCM{
    [[RCIM sharedRCIM] connectWithToken:[ShareValue shareInstance].userInfo.rongToken
                                success:^(NSString *userId) {
                                    [[RCIM sharedRCIM]
                                     refreshUserInfoCache:[ShareValue shareInstance].RCUser
                                     withUserId:[ShareValue shareInstance].RCUser.userId];
                                    //登陆demoserver成功之后才能调demo 的接口
                                    [RCDDataSource syncGroups];
                                    [RCDDataSource syncFriendList:^(NSMutableArray * result) {
                                        
                                    }];
                                    
                                    [[RCIMClient sharedRCIMClient] getBlacklist:^(NSArray *blockUserIds) {
                                        for (NSString *userID in blockUserIds) {
                                            
                                            // 暂不取用户信息，界面展示的时候在获取
                                            RCUserInfo*userInfo = [[RCUserInfo alloc]init];
                                            userInfo.userId = userID;
                                            userInfo.portraitUri = nil;
                                            userInfo.name = nil;
                                            [[RCDataBaseManager shareInstance] insertBlackListToDB:userInfo];
                                        }
                                        
                                    } error:^(RCErrorCode status) {
                                        NSLog(@"同步黑名单失败，status = %ld",(long)status);
                                    }];
                                    //设置当前的用户信息
                                    
                                    //同步群组
                                    //调用connectWithToken时数据库会同步打开，不用再等到block返回之后再访问数据库，因此不需要这里刷新
                                    //这里仅保证之前已经成功登陆过，如果第一次登陆必须等block 返回之后才操作数据
                                }
                                  error:^(RCConnectErrorCode status) {
                                    
                                  }
                         tokenIncorrect:^{
                             
                                                     }];
}
-(void)showIndexVC{
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self presentViewController:sb.instantiateInitialViewController animated:YES completion:^{
        
    }];
}
- (IBAction)showRegisterView:(id)sender {
     [self performSegueWithIdentifier:@"register" sender:nil];
}
-(BOOL)isReadyToSubmmit{
    if (self.tf_account.text.length==0) {
        [MBProgressHUD showError:@"请输入相遇账号！" toView:self.view.window];
        return NO;
    }
    if (self.tf_password.text.length==0) {
        [MBProgressHUD showError:@"请输入密码！" toView:self.view.window];
        return NO;
    }
    return YES;
}
/**
 *  微信登录
 *
 *  @param sender
 */
- (IBAction)loginWithWeChat:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            IsLoginReqeust * request =[[IsLoginReqeust alloc]init];
            request.openid=snsAccount.usid;
            request.loginType=@"2";
            [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
            [SystemAPI IsLoginReqeust:request success:^(id data) {
                NSDictionary * dic =[(NSDictionary*)data objectForKey:@"data"];
                LMUserInfo * user=[[LMUserInfo alloc]initWithDictionary:dic];
                [ShareValue shareInstance].userInfo=user;
                RCUserInfo * info=[[RCUserInfo alloc]initWithUserId:[dic objectForKey:@"id"] name:[dic objectForKey:@"mobile"] portrait:[dic objectForKey:@"avatar"]];
                [ShareValue shareInstance].RCUser=info;
                [self loginInRCM];
                [self showIndexVC];
                [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            } fail:^(BOOL notReachable, NSString *desciption) {
                [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
                LMUserInfo * user =[[LMUserInfo alloc]init];
                user.nickname=snsAccount.userName;
                user.avatar=snsAccount.iconURL;
                user.id=snsAccount.usid;
                [ShareValue shareInstance].userInfo=user;
                loginType=@"2";
                [self showFieldView];
            }];
        }
        
    });

}
/**
 *  QQ登录
 *
 *  @param sender
 */
- (IBAction)loginWithQQ:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            IsLoginReqeust * request =[[IsLoginReqeust alloc]init];
            request.openid=snsAccount.usid;
            request.loginType=@"1";
            [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
            [SystemAPI IsLoginReqeust:request success:^(id data) {
                NSDictionary * dic =[(NSDictionary*)data objectForKey:@"data"];
                LMUserInfo * user=[[LMUserInfo alloc]initWithDictionary:dic];
                [ShareValue shareInstance].userInfo=user;
                RCUserInfo * info=[[RCUserInfo alloc]initWithUserId:[dic objectForKey:@"id"] name:[dic objectForKey:@"mobile"] portrait:[dic objectForKey:@"avatar"]];
                [ShareValue shareInstance].RCUser=info;
                [self loginInRCM];
                [self showIndexVC];
                [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
            } fail:^(BOOL notReachable, NSString *desciption) {
                [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
                LMUserInfo * user =[[LMUserInfo alloc]init];
                user.nickname=snsAccount.userName;
                user.avatar=snsAccount.iconURL;
                user.id=snsAccount.usid;
                [ShareValue shareInstance].userInfo=user;
                loginType=@"1";
                [self showFieldView];
            }];
            
        }});
}
/**
 *  跳转到填写资料注册
 */
-(void)showFieldView{
    UIStoryboard * sb =[ UIStoryboard storyboardWithName:@"Login" bundle:nil];
    FieldProfileViewController * vc =[sb instantiateViewControllerWithIdentifier:@"FieldProfileViewController"];
    vc.user=[ShareValue shareInstance].userInfo;
    vc.loginType=loginType;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
