//
//  ForgetPasswordViewController.m
//  Meet
//
//  Created by Anita Lee on 15/7/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tf_phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *tf_checkCode;
@property (weak, nonatomic) IBOutlet UITextField *tf_setPassword;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *summitBtn;

@property(nonatomic,strong) NSTimer * timer;
@end
static NSUInteger count=60;

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}
-(void)initView{
    self.summitBtn.layer.shadowOffset=CGSizeMake(0, 2);
    self.summitBtn.layer.shadowColor=TempleColor.CGColor;
    self.summitBtn.layer.shadowRadius=0;
    self.summitBtn.layer.shadowOpacity=0.6;
}
- (IBAction)submmitAction:(id)sender {
    if ([self isReadyToSubmmit]) {
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        ForgetPasswordRequest * request=[[ForgetPasswordRequest alloc]init];
        request.mobile=self.tf_phoneNumber.text;
        request.code=self.tf_checkCode.text;
        request.password=self.tf_setPassword.text;
        [SystemAPI ForgetPasswordRequest:request success:^(ForgetPasswordResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            [MBProgressHUD showSuccess:response.message toView:ShareAppDelegate.window];
            [self.navigationController popViewControllerAnimated:YES];
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            [MBProgressHUD showError:desciption toView:self.view.window];
        }];
    }
}
- (IBAction)getCheckCodeAction:(id)sender {
    count=60;
    if ([self isRightNumber]) {
        GetCheckCodeRequest * request=[[GetCheckCodeRequest alloc]init];
        request.mobile=self.tf_phoneNumber.text;
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        [SystemAPI GetCheckCodeResquest:request success:^(GetCheckCodeResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            [MBProgressHUD showSuccess:response.message toView:self.view.window];
            self.getCodeBtn.enabled=NO;
            self.getCodeBtn.titleLabel.text=[NSString stringWithFormat:@"获取中(%ld)",(unsigned long)count];
            self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTitle) userInfo:nil repeats:YES];
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            [MBProgressHUD showError:desciption toView:self.view.window];
            [self.timer invalidate];
            self.getCodeBtn.enabled=YES;
            self.getCodeBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
            self.getCodeBtn.titleLabel.text=@"获取验证码";
        }];
    }
}
-(void)changeTitle{
    self.getCodeBtn.titleLabel.text=[NSString stringWithFormat:@"获取中(%ld)",(unsigned long)count];
    count--;
    if (count==0) {
        [self.timer invalidate];
        self.getCodeBtn.enabled=YES;
        self.getCodeBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
        self.getCodeBtn.titleLabel.text=@"获取验证码";
    }
}

-(BOOL)isRightNumber{
    if (self.tf_phoneNumber.text.length==0) {
        [MBProgressHUD showError:@"请输入手机号码！" toView:self.view];
        return NO;
    }
    if (self.tf_phoneNumber.text.length!=11) {
        [MBProgressHUD showError:@"请输入正确的手机号码!" toView:self.view];
        return NO;
    }
    return YES;
}
-(BOOL)isReadyToSubmmit{
    if (self.tf_checkCode.text.length==0) {
        [MBProgressHUD showError:@"请输入验证码！" toView:self.view];
        return NO;
    }
    if (self.tf_setPassword.text.length==0) {
        [MBProgressHUD showError:@"请输入密码！" toView:self.view];
        return NO;
    }
    
    return YES&&[self isRightNumber];
}

@end
