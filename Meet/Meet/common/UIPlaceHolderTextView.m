//
//  UIPlaceHolderTextView.m
//  Meet
//
//  Created by Anita Lee on 15/8/3.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView

@synthesize placeHolderLabel;

@synthesize placeholder;

@synthesize placeholderColor;

- (void)dealloc

{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    placeHolderLabel = nil;
    
     placeholderColor = nil;
    
    placeholder = nil;
    
}
- (void)awakeFromNib

{
    
    [super awakeFromNib];
    
    [self setPlaceholder:@"请输入您的验证消息"];
    
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
}
- (id)initWithFrame:(CGRect)frame

{
    
    if( (self = [super initWithFrame:frame]) )
        
    {
        
        [self setPlaceholder:@"请输入您的验证消息"];
        
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    
    return self;
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setPlaceholder:@"请输入您的验证消息"];
        
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setPlaceholder:@"请输入您的验证消息"];
        
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
- (void)textChanged:(NSNotification *)notification

{
    
    if([[self placeholder] length] == 0)
        
    {
        
        return;
        
    }
    
    
    
    if([[self text] length] == 0)
        
    {
        
        [[self viewWithTag:999] setAlpha:1];
        
    }
    
    else
        
    {
        
        [[self viewWithTag:999] setAlpha:0];
        
    }
    
}



- (void)setText:(NSString *)text {
    
    [super setText:text];
    
    [self textChanged:nil];
    
}



- (void)drawRect:(CGRect)rect

{
    
    if( [[self placeholder] length] > 0 )
        
    {
        
        if ( placeHolderLabel == nil )
            
        {
            
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            placeHolderLabel.numberOfLines = 0;
            
            placeHolderLabel.font = self.font;
            
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            
            placeHolderLabel.textColor = self.placeholderColor;
            
            placeHolderLabel.alpha = 0;
            
            placeHolderLabel.tag = 999;
            
            [self addSubview:placeHolderLabel];
            
        }
        
        
        
        placeHolderLabel.text = self.placeholder;
        
        [placeHolderLabel sizeToFit];
        
        [self sendSubviewToBack:placeHolderLabel];
        
    }
    
    
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
        
    {
        
        [[self viewWithTag:999] setAlpha:1];
        
    }
    
    
    
    [super drawRect:rect];
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text

{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;  
    
}
@end
