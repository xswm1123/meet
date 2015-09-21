//
//  BlackListCellTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/9/1.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BlackListCellTableViewCell;
@protocol BlackListCellDelegate <NSObject>

-(void)cancelBlackList:(BlackListCellTableViewCell*)cell;

@end

@interface BlackListCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (nonatomic,strong) NSString * photoUrl;
@property (nonatomic,strong) NSString * memberId;
@property (nonatomic,weak) id<BlackListCellDelegate> delegate;
@end
