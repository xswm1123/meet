//
//  LoginViewController.m
//  Meet
//
//  Created by Anita Lee on 15/7/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

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

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *fieldBGView;
@property (weak, nonatomic) IBOutlet UILabel *accountFont;
@property (weak, nonatomic) IBOutlet UITextField *tf_account;
@property (weak, nonatomic) IBOutlet UILabel *passwordFont;
@property (weak, nonatomic) IBOutlet UITextField *tf_password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToTop;
@property (weak, nonatomic) IBOutlet UIView *inputBg;

@end

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
            [ShareValue shareInstance].RCUser=info;
            [ShareValue shareInstance].password=self.tf_password.text;
            [self loginInRCM];
            [self showIndexVC];
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            [MBProgressHUD showError:desciption toView:self.view.window];
        }];

    }
    
    
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
#pragma 监听键盘
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardAppear:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame;
    CGFloat distance=0;
    CGFloat yLocation=0;
    
    if (keyboardFrame.origin.y<self.inputBg.frame.origin.y+self.inputBg.frame.size.height) {
        distance=self.inputBg.frame.origin.y+self.inputBg.frame.size.height-keyboardFrame.origin.y;
     }
    frame=CGRectMake(0, yLocation, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.distanceToTop.constant=50-distance-40;
        [self updateViewConstraints];
    } completion:^(BOOL bl){
    }];
       
}
- (void)keyboardDisappear:(NSNotification *)notification
{
    CGRect frame = self.view.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height - self.bottomLayoutGuide.length;
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.distanceToTop.constant=50;
        [self updateViewConstraints];
    } completion:nil];
}

@end
