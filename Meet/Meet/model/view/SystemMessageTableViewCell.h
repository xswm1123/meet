//
//  SystemMessageTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/9/3.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SystemMessageTableViewCell;
@protocol SystemMessageCellDelegate <NSObject>

-(void)agreeWithCell:(SystemMessageTableViewCell*)cell;
-(void)refuseWithCell:(SystemMessageTableViewCell*)cell;
-(void)addBlackListWithCell:(SystemMessageTableViewCell*)cell;

@end

@interface SystemMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UILabel *lb_desc;
@property (nonatomic,strong) NSString * photoUrl;
@property (nonatomic,strong) NSDictionary * infoDic;
@property (nonatomic,weak) id<SystemMessageCellDelegate> delegate;
@end
