//
//  UIPlaceHolderTextView.h
//  Meet
//
//  Created by Anita Lee on 15/8/3.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView<UITextViewDelegate>
{
    
    NSString *placeholder;
    
    UIColor *placeholderColor;
    
    
    
@private
    
    UILabel *placeHolderLabel;
    
}
@property(nonatomic, strong) UILabel *placeHolderLabel;

@property(nonatomic, strong) NSString *placeholder;

@property(nonatomic, strong) UIColor *placeholderColor;



-(void)textChanged:(NSNotification*)notification;
@end
