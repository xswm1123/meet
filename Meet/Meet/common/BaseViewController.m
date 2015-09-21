//
//  BaseViewController.m
//  ImmediateDelivery
//
//  Created by Anita Lee on 15/7/1.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "BaseViewController.h"
#import "RootViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=NAVI_COLOR;
    // Do any additional setup after loading the view.
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma UITextField_Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updatePersonalInfo];
    [(RootViewController*)self.tabBarController notifyUpdateUnreadMessageCount];
}
//更新个人信息
-(void)updatePersonalInfo{
    GetPersonalInfoRequest * request =[[GetPersonalInfoRequest alloc]init];
    request.memberId=[ShareValue shareInstance].userInfo.id;
    [SystemAPI GetPersonalInfoRequest:request
                              success:^(GetPersonalInfoResponse *response) {
                                  LMUserInfo * user=[[LMUserInfo alloc]initWithDictionary:response.data];
                                  [ShareValue shareInstance].userInfo=user;
                              } fail:^(BOOL notReachable, NSString *desciption) {
                                  NSLog(@"更新个人信息失败!");
                              }];
}
@end
