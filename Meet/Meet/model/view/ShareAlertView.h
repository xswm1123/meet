//
//  ShareAlertView.h
//  Meet
//
//  Created by Anita Lee on 15/9/15.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareAlertView;
@protocol ShareAlertViewDelegate <NSObject>

-(void)shareAlertView:(ShareAlertView*)alertView didSelectedAtButtonIndex:(NSInteger)buttonIndex;

@end
@interface ShareAlertView : UIView
@property (nonatomic,strong) NSString * mark;
@property (nonatomic,weak)id<ShareAlertViewDelegate> delegate;
@end
