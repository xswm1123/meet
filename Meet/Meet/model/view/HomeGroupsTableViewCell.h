//
//  HomeGroupsTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/8/25.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeGroupsTableViewCell;
@protocol JoinGroupDelegate <NSObject>

-(void)joinGroup:(HomeGroupsTableViewCell*)cell;

@end

@interface HomeGroupsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *groupPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_count;
@property (weak, nonatomic) IBOutlet UILabel *lb_desc;
@property (nonatomic,strong) NSString * photoUrl;
@property (nonatomic,strong) NSString * groupId;
@property (nonatomic,weak) id<JoinGroupDelegate> delegate;
@end
