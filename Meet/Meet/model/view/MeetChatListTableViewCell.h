//
//  MeetChatListTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/7/28.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetChatListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *iconNmae;

@end
