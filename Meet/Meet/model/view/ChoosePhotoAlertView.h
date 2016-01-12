//
//  ChoosePhotoAlertView.h
//  USAgent
//
//  Created by Anita Lee on 15/11/4.
//  Copyright © 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChoosePhotoAlertView;
@protocol ChoosePhotoAlertViewDelegate <NSObject>

-(void)choosePhotoAlertView:(ChoosePhotoAlertView*)alertView didSelectedAtIndex:(NSInteger)index;

@end

@interface ChoosePhotoAlertView : UIView
@property (nonatomic,weak) id<ChoosePhotoAlertViewDelegate> delegate;
@property (nonatomic,assign) NSInteger tag;
/**
 *  动画进入
 */
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)showInView:(UIView *)aView animated:(BOOL)animated moreHeight:(CGFloat)height;
@end
