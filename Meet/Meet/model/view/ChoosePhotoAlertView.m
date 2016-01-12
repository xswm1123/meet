//
//  ChoosePhotoAlertView.m
//  USAgent
//
//  Created by Anita Lee on 15/11/4.
//  Copyright © 2015年 Anita Lee. All rights reserved.
//

#import "ChoosePhotoAlertView.h"
#import "ServerConfig.h"

@interface ChoosePhotoAlertView (){
      UIView *backView;
}

@end

@implementation ChoosePhotoAlertView
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
- (void)initialize
{
    if (!backView) {
        backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fadeOut)];
        [backView addGestureRecognizer:tap];
    }
    self.backgroundColor=NAVI_COLOR;
}
- (IBAction)takePhoto:(id)sender {
    [self.delegate choosePhotoAlertView:self didSelectedAtIndex:0];
    [self fadeOut];
}
- (IBAction)choosePhoto:(id)sender {
    [self.delegate choosePhotoAlertView:self didSelectedAtIndex:1];
    [self fadeOut];
}
#pragma mark - Private Methods
- (void)fadeIn:(UIView *)view {
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    backView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
        backView.alpha = 1;
    }];
}

- (void)fadeOut {
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
        backView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            [backView removeFromSuperview];
        }
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated {
    if ([aView viewWithTag:11000011]) {
        return;
    }
    backView.tag = 11000011;
    backView.frame = aView.frame;
    self.frame=CGRectMake(0, aView.frame.size.height-135, DEVCE_WITH, 135);
    [backView addSubview:self];
    [aView addSubview:backView];
    
    if (animated) {
        [self fadeIn:aView];
    }
}
- (void)showInView:(UIView *)aView animated:(BOOL)animated moreHeight:(CGFloat)height{
    if ([aView viewWithTag:11000011]) {
        return;
    }
    backView.tag = 11000011;
    backView.frame = aView.frame;
    self.frame=CGRectMake(0, aView.frame.size.height-135 + 34, DEVCE_WITH, 135);
    [backView addSubview:self];
    [aView addSubview:backView];
    
    if (animated) {
        [self fadeIn:aView];
    }
}
#pragma mark - TouchTouchTouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // dismiss self
    [self fadeOut];
}
@end
