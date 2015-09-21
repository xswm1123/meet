//
//  RegisterViewController.m
//  Meet
//
//  Created by Anita Lee on 15/7/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "RegisterViewController.h"
#import "FieldProfileViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *tf_checkCode;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *tf_setPassword;
@property (weak, nonatomic) IBOutlet UITextField *tf_recommanderID;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *submmitBtn;

@property(nonatomic,strong) NSTimer * timer;
@end
static NSUInteger count=60;

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
}
-(void)initView{
    self.submmitBtn.layer.shadowOffset=CGSizeMake(0, 2);
    self.submmitBtn.layer.shadowColor=TempleColor.CGColor;
    self.submmitBtn.layer.shadowRadius=0;
    self.submmitBtn.layer.shadowOpacity=0.6;
}
- (IBAction)GetCheckCodeAction:(id)sender {
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
    UIImage * image=[self.agreeBtn backgroundImageForState:UIControlStateNormal];
    if (image==[UIImage imageNamed:@"unselected.png"]) {
        [MBProgressHUD showError:@"请先同意注册条款！" toView:self.view];
        return NO;
    }
    
    return YES&&[self isRightNumber];
}
- (IBAction)agreeAction:(id)sender {
    UIImage * image=[self.agreeBtn backgroundImageForState:UIControlStateNormal];
    if (image==[UIImage imageNamed:@"selected.png"]) {
        [self.agreeBtn setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    }else{
        [self.agreeBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    }
}
- (IBAction)submmitAction:(id)sender {
    if ([self isReadyToSubmmit]) {
          [self performSegueWithIdentifier:@"fieldProfile" sender:nil];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"fieldProfile"]) {
        FieldProfileViewController* vc=segue.destinationViewController;
        vc.phoneNmuber=self.tf_phoneNumber.text;
        vc.code=self.tf_checkCode.text;
        vc.password=self.tf_setPassword.text;
        vc.recommanderID=self.tf_recommanderID.text;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    NSCharacterSet *cs;
    if(textField == self.tf_recommanderID)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            [MBProgressHUD showError:@"请输入数字!" toView:self.view.window];
            return NO;
        }
    }
    return YES;
}

@end
