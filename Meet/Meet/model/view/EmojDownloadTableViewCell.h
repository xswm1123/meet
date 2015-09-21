//
//  EmojDownloadTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/8/4.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmojDownloadTableViewCell;
@protocol EmojDownloadDelegate <NSObject>

-(void)DownloadFilesWithCell:(EmojDownloadTableViewCell*)cell;

@end
@interface EmojDownloadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (nonatomic,strong) NSString * downLoadUrl;
@property (nonatomic,assign) id<EmojDownloadDelegate> delegate;
@end
