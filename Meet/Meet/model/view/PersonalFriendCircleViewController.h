//
//  PersonalFriendCircleViewController.h
//  Meet
//
//  Created by Anita Lee on 15/9/17.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonalFriendCircleViewController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) NSString * memberId;

@end
