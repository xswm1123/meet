//
//  ReportViewController.m
//  Meet
//
//  Created by Anita Lee on 15/9/19.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()<UIActionSheetDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *tv_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_type;
@property (weak, nonatomic) IBOutlet UILabel *lb_icon;
@property (nonatomic,strong) NSArray * types;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lb_icon.font=[UIFont fontWithName:iconFont size:18];
    self.lb_icon.text=@"\U0000e637";
    self.types=@[@"色情低俗",@"广告骚扰",@"政治敏感",@"谣言",@"欺诈骗钱",@"违法(暴力恐怖、违禁品等)"];
    self.lb_type.text=[self.types objectAtIndex:0];
    self.tv_content.delegate=self;
    self.tv_content.layer.cornerRadius=3;
    self.tv_content.layer.borderColor=iconYellow.CGColor;
    self.tv_content.layer.borderWidth=1;
    self.tv_content.clipsToBounds=YES;
    self.tv_content.placeholder=@"请输入您的举报内容...";
}
- (IBAction)chooseFeedType:(id)sender {
    UIActionSheet * as=[[UIActionSheet alloc]initWithTitle:@"请选择反馈类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"色情低俗",@"广告骚扰",@"政治敏感",@"谣言",@"欺诈骗钱",@"违法(暴力恐怖、违禁品等)", nil];
    [as showInView:self.view.window];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex!=self.types.count) {
        self.lb_type.text=[self.types objectAtIndex:buttonIndex];
    }
}
- (IBAction)submmitAction:(id)sender {
    if (self.tv_content.text.length==0) {
        [MBProgressHUD showError:@"请输入举报内容" toView:self.view];
        return;
    }
    ReportUserRequest * request =[[ReportUserRequest alloc]init];
    request.type=self.lb_type.text;
    request.content=self.tv_content.text;
    request.targetId=self.targetId;
    [SystemAPI ReportUserRequest:request success:^(ReportUserResponse *response) {
        [MBProgressHUD showSuccess:response.message toView:self.view];
        self.tv_content.text=@"";
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD showError:desciption toView:self.view];
    }];
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
