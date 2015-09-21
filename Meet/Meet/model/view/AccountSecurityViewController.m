//
//  AccountSecurityViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "AccountSecurityViewController.h"
#import "GesturePasswordController.h"

@interface AccountSecurityViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lb_phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *tf_oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *tf_newPasswor;
@property (weak, nonatomic) IBOutlet UISwitch *GestureSwitch;
@property (weak, nonatomic) IBOutlet BaseView *gestureBG;
@property (weak, nonatomic) IBOutlet UILabel *lb_iconArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToBtn;

@end

@implementation AccountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lb_phoneNumber.text=[ShareValue shareInstance].userInfo.mobile;
    self.lb_iconArrow.font=[UIFont fontWithName:iconFont size:18];
    self.lb_iconArrow.text=@"\U0000e639";
    self.GestureSwitch.on=[ShareValue shareInstance].isUsedGesturePassword;
    [self switchIsOn];
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

@end
