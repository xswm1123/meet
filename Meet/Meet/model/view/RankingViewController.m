//
//  RankingViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "RankingViewController.h"
#import "RankingDetailsViewController.h"

@interface RankingViewController ()
/**
 *  全球排行榜
 */
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *globalImages;
/**
 *  魅力值排行榜
 */
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *meiliImages;
/**
 *  消费排行榜
 */
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *costImages;
/**
 *  财富排行榜
 */
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *wealthImages;


@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDatas];
}
-(void)loadDatas{
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    GetRankingListRequest * request=[[GetRankingListRequest alloc]init];
    [SystemAPI GetRankingListRequest:request success:^(GetRankingListResponse *response) {
        NSArray * goldList=[response.data objectForKey:@"goldList"];
        NSArray * meiliList=[response.data objectForKey:@"meiliList"];
        NSArray * payList=[response.data objectForKey:@"payList"];
        NSArray * totalList=[response.data objectForKey:@"totalList"];
        for (int i =0; i<totalList.count; i++) {
            NSString * url=[totalList objectAtIndex:i];
            UIImageView * imageView=[self.globalImages objectAtIndex:i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolder];
        }
        for (int i =0; i<goldList.count; i++) {
            NSString * url=[goldList objectAtIndex:i];
            UIImageView * imageView=[self.wealthImages objectAtIndex:i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolder];
        }
        for (int i =0; i<meiliList.count; i++) {
            NSString * url=[meiliList objectAtIndex:i];
            UIImageView * imageView=[self.meiliImages objectAtIndex:i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolder];
        }
        for (int i =0; i<payList.count; i++) {
            NSString * url=[payList objectAtIndex:i];
            UIImageView * imageView=[self.costImages objectAtIndex:i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolder];
        }
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        
    } fail:^(BOOL notReachable, NSString *desciption) {
    [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
    }];
}
- (IBAction)showGlobalRankDetails:(id)sender {
    [self performSegueWithIdentifier:@"global" sender:nil];
}
- (IBAction)showRankDetails:(id)sender {
    [self performSegueWithIdentifier:@"rankDetails" sender:sender];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"rankDetails"]) {
        UIButton * btn=sender;
        RankingDetailsViewController * vc=segue.destinationViewController;
        vc.index=btn.tag;
    }
}
@end
