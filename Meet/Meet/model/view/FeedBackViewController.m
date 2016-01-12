//
//  FeedBackViewController.m
//  Meet
//
//  Created by Anita Lee on 15/9/13.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()<UIActionSheetDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *tv_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_type;
@property (weak, nonatomic) IBOutlet UILabel *lb_icon;
@property (nonatomic,strong) NSArray * types;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lb_icon.font=[UIFont fontWithName:iconFont size:18];
    self.lb_icon.text=@"\U0000e637";
    self.types=@[@"咨询",@"投诉",@"建议"];
    self.lb_type.text=[self.types objectAtIndex:0];
    self.tv_content.delegate=self;
    self.tv_content.layer.cornerRadius=3;
    self.tv_content.layer.borderColor=iconYellow.CGColor;
    self.tv_content.layer.borderWidth=1;
    self.tv_content.clipsToBounds=YES;
    self.tv_content.placeholder=@"请输入您宝贵的意见...一经采纳，我们将赠送金币及VIP以示奖励！";
}
- (IBAction)chooseFeedType:(id)sender {
    UIActionSheet * as=[[UIActionSheet alloc]initWithTitle:@"请选择反馈类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"咨询",@"投诉",@"建议", nil];
    [as showInView:self.view.window];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex!=self.types.count) {
        self.lb_type.text=[self.types objectAtIndex:buttonIndex];
    }
}
- (IBAction)submmitAction:(id)sender {
    if (self.tv_content.text.length==0) {
        [MBProgressHUD showError:@"请输入反馈内容" toView:self.view];
        return;
    }
    FeedBackRequest * request =[[FeedBackRequest alloc]init];
    request.type=self.lb_type.text;
    request.content=self.tv_content.text;
    [SystemAPI FeedBackRequest:request success:^(FeedBackResponse *response) {
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
