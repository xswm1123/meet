//
//  LanuchAdsManager.m
//  Meet
//
//  Created by Anita Lee on 15/9/20.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "LanuchAdsManager.h"

@interface LanuchAdsManager()

@end
static LanuchAdsManager * _manager;
@implementation LanuchAdsManager
- (void)showAdAtPath:(NSString *)path onView:(UIView *)container timeInterval:(NSTimeInterval)interval detailParameters:(NSDictionary *)param
{
 
    [self.detailParam removeAllObjects];
    [self.detailParam addEntriesFromDictionary:param];
    [self showImageOnView:container forTime:interval];
}

+ (instancetype)defaultMonitor
{
    @synchronized (self) {
        if (!_manager) {
            _manager = [[LanuchAdsManager alloc] init];
        }
        return _manager;
    }
}

- (void)showImageOnView:(UIView *)container forTime:(NSTimeInterval)time
{
    self.count=time;
    CGRect f = [UIScreen mainScreen].bounds;
    UIView *v = [[UIView alloc] initWithFrame:f];
    v.backgroundColor = [UIColor whiteColor];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:f];
    iv.image = [UIImage imageNamed:@"advert.jpg"];
    self.conn = nil;
    [self.imgData setLength:0];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;
    [v addSubview:iv];
    
    [container addSubview:v];
    [container bringSubviewToFront:v];
    
    UIButton *showDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showDetailBtn setTitle:@"跳过>>" forState:UIControlStateNormal];
    [showDetailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [showDetailBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    showDetailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    showDetailBtn.frame = CGRectMake(f.size.width - 70, 30, 60, 30);
    showDetailBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    showDetailBtn.layer.borderWidth = 1.0f;
    showDetailBtn.layer.cornerRadius = 3.0f;
    [showDetailBtn addTarget:self action:@selector(showAdDetail:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:showDetailBtn];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(f.size.width - 120, 30, 30, 30)];
    self.label.backgroundColor = [UIColor lightGrayColor];
    self.label.text =[NSString stringWithFormat:@"%.f秒",time];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:13];
    self.label.textColor=[UIColor whiteColor];
    self.label.clipsToBounds=YES;
    self.label.layer.cornerRadius=15;
    [v addSubview:self.label];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTitle) userInfo:nil repeats:YES];
    
    [container addSubview:v];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        v.userInteractionEnabled = NO;
        [UIView animateWithDuration:.25
                         animations:^{
                             v.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             [v removeFromSuperview];
                         }];
    });
}
-(void)changeTitle{
    self.count--;
    self.label.text=[NSString stringWithFormat:@"%d秒",self.count];
//    if (self.count==0) {
//        [self showAdDetail:nil];
//    }
}
-(void)showAdDetail:(id)sender
{
    UIView *sup = [(UIButton *)sender superview];
    sup.userInteractionEnabled = NO;
    [UIView animateWithDuration:.25
                     animations:^{
                         sup.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [sup removeFromSuperview];
                       
                     }];
    
}

@end
