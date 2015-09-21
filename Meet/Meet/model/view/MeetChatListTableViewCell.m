//
//  MeetChatListTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/7/28.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "MeetChatListTableViewCell.h"
#import "ServerConfig.h"

@implementation MeetChatListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=[UIColor colorWithRed:51/255.0 green:56/255.0 blue:77/255.0 alpha:1.0];
    self.iconNmae.font=[UIFont fontWithName:iconFont size:18];
    self.iconNmae.text=@"\U0000e639";
    self.photo.layer.cornerRadius=5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
