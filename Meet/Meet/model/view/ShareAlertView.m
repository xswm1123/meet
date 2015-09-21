//
//  ShareAlertView.m
//  Meet
//
//  Created by Anita Lee on 15/9/15.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "ShareAlertView.h"
#import "ServerConfig.h"
@interface ShareAlertView()
@property (weak, nonatomic) IBOutlet UILabel *lb_iconWechat;
@property (weak, nonatomic) IBOutlet UILabel *lb_iconSina;
@property (weak, nonatomic) IBOutlet UILabel *lb_iconQQ;
@property (weak, nonatomic) IBOutlet UILabel *lb_iconCircle;

@end

@implementation ShareAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)setMark:(NSString *)mark{
    _mark=mark;
    self.lb_iconWechat.font=[UIFont fontWithName:iconFont size:40];
    self.lb_iconWechat.textColor=iconGreen;
    self.lb_iconWechat.text=@"\U0000e62c";
    
    self.lb_iconSina.font=[UIFont fontWithName:iconFont size:40];
    self.lb_iconSina.textColor=iconOrange;
    self.lb_iconSina.text=@"\U0000e62f";
    
    self.lb_iconQQ.font=[UIFont fontWithName:iconFont size:40];
    self.lb_iconQQ.textColor=iconBlue;
    self.lb_iconQQ.text=@"\U0000e62e";
    
    self.lb_iconCircle.font=[UIFont fontWithName:iconFont size:40];
    self.lb_iconCircle.textColor=iconGreen;
    self.lb_iconCircle.text=@"\U0000e60d";
}

- (void)initialize
{
    self.backgroundColor=cellColor;
}
- (IBAction)shareToWeChat:(id)sender {
    [self.delegate shareAlertView:self didSelectedAtButtonIndex:0];
}
- (IBAction)shareToSina:(id)sender {
    [self.delegate shareAlertView:self didSelectedAtButtonIndex:1];
}
- (IBAction)shareToQQ:(id)sender {
    [self.delegate shareAlertView:self didSelectedAtButtonIndex:2];
}
- (IBAction)shareToFriendCircle:(id)sender {
    [self.delegate shareAlertView:self didSelectedAtButtonIndex:3];
}


@end
