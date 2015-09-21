//
//  AddFriendViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *textView;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.placeholder=@"请输入验证信息";
    self.textView.delegate=self;
}
- (IBAction)sendAction:(id)sender {
    if ([self isReadyToSned]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        SendFriendRstRequest * request =[[SendFriendRstRequest alloc]init];
        request.friendId=self.memberId;
        request.content=self.textView.text;
        [SystemAPI SendFriendRstRequest:request success:^(SendFriendRstResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:response.message toView:self.view];
            self.textView.text=@"";
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];
    }
}

-(BOOL)isReadyToSned{
    if (self.textView.text.length==0) {
        [MBProgressHUD showError:@"请输入验证消息" toView:self.view.window];
        return YES;
    }
    return YES;
}
#pragma textView代理，用于收起键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
