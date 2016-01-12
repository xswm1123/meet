//
//  FieldProfileViewController.h
//  Meet
//
//  Created by Anita Lee on 15/7/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "BaseViewController.h"

@interface FieldProfileViewController : BaseViewController
@property(nonatomic,strong) NSString * phoneNmuber;
@property(nonatomic,strong) NSString * code;
@property (nonatomic,strong) NSString* password;
@property(nonatomic,strong) NSString * recommanderID;
@property(nonatomic,strong) LMUserInfo * user;
@property(nonatomic,strong) NSString * loginType;
@end
