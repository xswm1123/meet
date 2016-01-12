//
//  AboutViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "AboutViewController.h"
#import "RCDChatViewController.h"
@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lb_currentVersion;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *key = (NSString *)kCFBundleVersionKey;
    //加载程序中的info.plist
    NSString *currentVersionCode = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    self.lb_currentVersion.text=[NSString stringWithFormat:@"V%@",currentVersionCode];
}
- (IBAction)contactService:(id)sender {
    RCConversationModel * model=[[RCConversationModel alloc]init:
                                 RC_CONVERSATION_MODEL_TYPE_NORMAL exntend:nil];
    model.conversationType=ConversationType_PRIVATE;
    model.targetId=@"1";
    model.conversationTitle=@"相遇小秘书";
    model.senderUserId=[ShareValue shareInstance].userInfo.id;
    model.senderUserName=[ShareValue shareInstance].userInfo.nickname;
    RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
    _conversationVC.conversationType = ConversationType_PRIVATE;
    _conversationVC.targetId = @"1";
    _conversationVC.userName = @"相遇小秘书";
    _conversationVC.title = @"相遇小秘书";
    _conversationVC.conversation = model;
    _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
    _conversationVC.enableUnreadMessageIcon=YES;
    [self.navigationController pushViewController:_conversationVC animated:YES];
}
- (IBAction)showImplementation:(id)sender {
    [self performSegueWithIdentifier:@"implementation" sender:nil];
}
- (IBAction)feedBack:(id)sender {
    [self performSegueWithIdentifier:@"feedBack" sender:nil];
}

@end
