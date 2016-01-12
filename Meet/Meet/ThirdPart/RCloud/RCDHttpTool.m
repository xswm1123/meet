//
//  RCDHttpTool.m
//  RCloudMessage
//
//  Created by Liv on 15/4/15.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDHttpTool.h"
#import "AFHttpTool.h"
#import "RCDGroupInfo.h"
#import "RCDUserInfo.h"
#import "RCDRCIMDataSource.h"
#import "RCDataBaseManager.h"
#import "BaseViewController.h"

@implementation RCDHttpTool

+ (RCDHttpTool*)shareInstance
{
    static RCDHttpTool* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        instance.allGroups = [NSMutableArray new];
    });
    return instance;
}

-(void) isMyFriendWithUserInfo:(RCDUserInfo *)userInfo
                  completion:(void(^)(BOOL isFriend)) completion
{
    [self getFriends:^(NSMutableArray *result) {
        for (RCDUserInfo *user in result) {
            if ([user.userId isEqualToString:userInfo.userId] && completion && [@"1" isEqualToString:user.status]) {
                if (completion) {
                    completion(YES);
                }
                return ;
            }
        }
        if(completion){
            completion(NO);
        }
    }];
}
//根据id获取单个群组
-(void) getGroupByID:(NSString *) groupID
   successCompletion:(void (^)(RCGroup *group)) completion
{
    RCGroup *groupInfo=[[RCDataBaseManager shareInstance] getGroupByGroupId:groupID];
    if(groupInfo==nil)
    {
    [AFHttpTool getAllGroupsSuccess:^(id response) {
        NSArray *allGroups = response[@"result"];
        if (allGroups) {
            for (NSDictionary *dic in allGroups) {
                RCGroup *group = [[RCGroup alloc] init];
                group.groupId = [dic objectForKey:@"id"];
                group.groupName = [dic objectForKey:@"name"];
                group.portraitUri = (NSNull *)[dic objectForKey:@"portrait"] == [NSNull null] ? nil: [dic objectForKey:@"portrait"];
                if ([group.groupId isEqualToString:groupID] && completion) {
                    completion(group);
                }
            }

        }
        
    } failure:^(NSError* err){
        
    }];
    }else{
        if (completion) {
            completion(groupInfo);
        }

    }
}
-(void) getUserInfoByUserID:(NSString *) userID
                         completion:(void (^)(RCUserInfo *user)) completion
{
    RCUserInfo *userInfo=[[RCDataBaseManager shareInstance] getUserByUserId:userID];
    if (userInfo==nil) {
        GetPersonalInfoRequest  * request   =[[ GetPersonalInfoRequest alloc]init];
        request.memberId=userID;
        [SystemAPI GetPersonalInfoRequest:request success:^(GetPersonalInfoResponse *response) {
            RCUserInfo *user = [RCUserInfo new];
            NSDictionary * dic  = response.data;
            NSNumber *idNum = [dic objectForKey:@"id"];
            user.userId = [NSString stringWithFormat:@"%d",idNum.intValue];
            user.portraitUri = [dic objectForKey:@"avatar"];
            user.name = [dic objectForKey:@"nickname"];
            [[RCDataBaseManager shareInstance] insertUserToDB:user];
            NSLog(@"insertUserToDB");
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(user);
                });
            }
            
        } fail:^(BOOL notReachable, NSString *desciption) {
            NSLog(@"getUserInfoByUserID error");
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil);
                });
            }
            
        }];

    
    }else
    {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(userInfo);
            });
        }

    }
}


- (void)getAllGroupsWithCompletion:(void (^)(NSMutableArray* result))completion
{
    GetMyCreatedGroupsRequest * request =[[GetMyCreatedGroupsRequest alloc]init];
    
    [SystemAPI GetMyCreatedGroupsRequest:request success:^(GetMyCreatedGroupsResponse *response) {
       
        NSDictionary * dics=[(NSArray*)response.data objectAtIndex:0];
        //        NSArray * regDataArray =[dics objectForKey:@"memberList"];
        
        NSArray *allGroups = [dics objectForKey:@"groupList"];
        NSMutableArray *tempArr = [NSMutableArray new];
        
        if (allGroups) {
            [[RCDataBaseManager shareInstance] clearGroupsData];
            for (NSDictionary *dic in allGroups) {
                RCDGroupInfo *group = [[RCDGroupInfo alloc] init];
                group.groupId =[NSString stringWithFormat:@"%@", [dic objectForKey:@"groupId"]];
                group.groupName = [dic objectForKey:@"name"];
                group.portraitUri = [dic objectForKey:@"picUrl"];
                //                if (group.portraitUri) {
                //                    group.portraitUri=@"";
                //                }
                //                group.creatorId = [dic objectForKey:@"create_user_id"];
                group.introduce = [dic objectForKey:@"description"];
                //                if (group.introduce) {
                //                    group.introduce=@"";
                //                }
                group.number = [NSString stringWithFormat:@"%@",[dic objectForKey:@"memberCount"]];
                group.maxNumber = [NSString stringWithFormat:@"%@",[dic objectForKey:@"maxCount"]];
                //                group.creatorTime = [dic objectForKey:@"creat_datetime"];
                [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                [tempArr addObject:group];
                //[_allGroups addObject:group];
            }
            if (completion) {
                [_allGroups removeAllObjects];
                [_allGroups addObjectsFromArray:tempArr];
                
                completion(tempArr);
            }

            //获取加入状态
//            [self getMyGroupsWithBlock:^(NSMutableArray *result) {
//                for (RCDGroupInfo *group in result) {
//                    for (RCDGroupInfo *groupInfo in tempArr) {
//                        if ([group.groupId isEqualToString:groupInfo.groupId]) {
//                            groupInfo.isJoin = YES;
//                            [[RCDataBaseManager shareInstance] insertGroupToDB:groupInfo];
//                        }
//                        
//                    }
//                }
//        }];
}
        
    } fail:^(BOOL notReachable, NSString *desciption) {
        NSMutableArray *cacheGroups=[[NSMutableArray alloc]initWithArray:[[RCDataBaseManager shareInstance] getAllGroup]];
        completion(cacheGroups);

    }];
    
}


-(void) getMyGroupsWithBlock:(void(^)(NSMutableArray* result)) block
{
    
    GetMyJoinedGroupsRequest * request =[[GetMyJoinedGroupsRequest alloc]init];
 
    [SystemAPI GetMyJoinedGroupsRequest:request success:^(GetMyJoinedGroupsResponse *response) {
        NSArray * listArr=(NSArray*)response.data;
        for (NSDictionary * dics in listArr) {
            NSArray *allGroups = [dics objectForKey:@"groupList"];
            NSMutableArray *tempArr = [NSMutableArray new];
            if (allGroups) {
                [[RCDataBaseManager shareInstance] clearGroupsData];
                for (NSDictionary *dic in allGroups) {
                    RCDGroupInfo *group = [[RCDGroupInfo alloc] init];
                    group.groupId =[NSString stringWithFormat:@"%@", [dic objectForKey:@"groupId"]];
                    group.groupName = [dic objectForKey:@"name"];
                    group.portraitUri = [dic objectForKey:@"picUrl"];
                    group.isJoin=YES;
                    //                if (group.portraitUri) {
                    //                    group.portraitUri=@"";
                    //                }
                    //                group.creatorId = [dic objectForKey:@"create_user_id"];
                    group.introduce = [dic objectForKey:@"description"];
                    //                if (group.introduce) {
                    //                    group.introduce=@"";
                    //                }
                    group.number = [NSString stringWithFormat:@"%@",[dic objectForKey:@"memberCount"]];
                    group.maxNumber = [NSString stringWithFormat:@"%@",[dic objectForKey:@"maxCount"]];
                    //                group.creatorTime = [dic objectForKey:@"creat_datetime"];
                    [tempArr addObject:group];
                    [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                    [_allGroups addObject:group];
                }
                block(tempArr);
                
            }

        }
       
     
    } fail:^(BOOL notReachable, NSString *desciption) {
       
    }];

}

- (void)joinGroup:(int)groupID complete:(void (^)(BOOL))joinResult
{
    [AFHttpTool joinGroupByID:groupID success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
        if (joinResult) {
            if ([code isEqualToString:@"200"]) {
                [[RCIMClient sharedRCIMClient]joinGroup:[NSString stringWithFormat:@"%d",groupID] groupName:@"" success:^{
                    for (RCDGroupInfo *group in _allGroups) {
                        if ([group.groupId isEqualToString:[NSString stringWithFormat:@"%d",groupID]]) {
                            group.isJoin=YES;
                            [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        joinResult(YES);
                    });

                } error:^(RCErrorCode status) {
                    joinResult(NO);
                }];
                
            }else{
                joinResult(NO);
            }
            
        }
    } failure:^(id response) {
        if (joinResult) {
            joinResult(NO);
        }
    }];
}

- (void)quitGroup:(int)groupID complete:(void (^)(BOOL))result
{
    [AFHttpTool quitGroupByID:groupID success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
        
        if (result) {
            if ([code isEqualToString:@"200"]) {
                [[RCIMClient sharedRCIMClient] quitGroup:[NSString stringWithFormat:@"%d",groupID] success:^{
                    result(YES);
                    for (RCDGroupInfo *group in _allGroups) {
                        if ([group.groupId isEqualToString:[NSString stringWithFormat:@"%d",groupID]]) {
                            group.isJoin=NO;
                            [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                        }
                    }
                } error:^(RCErrorCode status) {
                    result(NO);
                }];
            }else{
                result(NO);
            }
            
        }
    } failure:^(id response) {
        if (result) {
            result(NO);
        }
    }];
}

- (void)updateGroupById:(int)groupID withGroupName:(NSString*)groupName andintroduce:(NSString*)introduce complete:(void (^)(BOOL))result

{
    __block typeof(id) weakGroupId = [NSString stringWithFormat:@"%d", groupID];
    [AFHttpTool updateGroupByID:groupID withGroupName:groupName andGroupIntroduce:introduce success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
        
        if (result) {
            if ([code isEqualToString:@"200"]) {
                
                for (RCDGroupInfo *group in _allGroups) {
                    if ([group.groupId isEqualToString:weakGroupId]) {
                        group.groupName=groupName;
                        group.introduce=introduce;
                    }
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    result(YES);
                });
                
            }else{
                result(NO);
            }
            
        }
    } failure:^(id response) {
        if (result) {
            result(NO);
        }
    }];
}

- (void)getFriends:(void (^)(NSMutableArray*))friendList
{
    NSMutableArray* list = [NSMutableArray new];
    GetFriendsListRequest * request =[[GetFriendsListRequest alloc]init];
    request.lat=[ShareValue shareInstance].currentLocation.latitude;
    request.lng=[ShareValue shareInstance].currentLocation.longitude;
    [SystemAPI GetFriendsListRequest:request success:^(GetFriendsListResponse *response) {
        [_allFriends removeAllObjects];
        NSDictionary * dics=[(NSArray*)response.data objectAtIndex:0];
        NSArray * regDataArray =[dics objectForKey:@"memberList"];
        [[RCDataBaseManager shareInstance] clearFriendsData];
        for(int i = 0;i < regDataArray.count;i++){
            NSDictionary *dic = [regDataArray objectAtIndex:i];
//            if([[dic objectForKey:@"status"] intValue] != 1)
//                continue;
            
            RCDUserInfo*userInfo = [RCDUserInfo new];
            NSNumber *idNum = [dic objectForKey:@"memberId"];
            userInfo.userId = [NSString stringWithFormat:@"%d",idNum.intValue];
            userInfo.portraitUri = [dic objectForKey:@"avatar"];
            userInfo.name = [dic objectForKey:@"nickname"];
//            userInfo.email = [dic objectForKey:@"email"];
//            userInfo.status = [dic objectForKey:@"status"];
            [list addObject:userInfo];
            [_allFriends addObject:userInfo];
            RCUserInfo *user = [RCUserInfo new];
            user.userId = [NSString stringWithFormat:@"%d",idNum.intValue];
            user.portraitUri = [dic objectForKey:@"avatar"];
            user.name = [dic objectForKey:@"nickname"];
            [[RCDataBaseManager shareInstance] insertUserToDB:user];
            [[RCDataBaseManager shareInstance] insertFriendToDB:user];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            friendList(list);
        });
    } fail:^(BOOL notReachable, NSString *desciption) {
        if (friendList) {
            NSMutableArray *cacheList=[[NSMutableArray alloc]initWithArray:[[RCDataBaseManager shareInstance] getAllFriends]];
            friendList(cacheList);
        }
    }];

}

- (void)searchFriendListByEmail:(NSString*)email complete:(void (^)(NSMutableArray*))friendList
{
    NSMutableArray* list = [NSMutableArray new];
    [AFHttpTool searchFriendListByEmail:email success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
        
        if (friendList) {
            if ([code isEqualToString:@"200"]) {
                
                id result = response[@"result"];
                if([result respondsToSelector:@selector(intValue)]) return ;
                if([result respondsToSelector:@selector(objectForKey:)])
                {
                    RCDUserInfo*userInfo = [RCDUserInfo new];
                    NSNumber *idNum = [result objectForKey:@"id"];
                    userInfo.userId = [NSString stringWithFormat:@"%d",idNum.intValue];
                    userInfo.portraitUri = [result objectForKey:@"portrait"];
                    userInfo.name = [result objectForKey:@"username"];
                    [list addObject:userInfo];
                    
                }
                else
                {
                    NSArray * regDataArray = response[@"result"];
                    
                    for(int i = 0;i < regDataArray.count;i++){
                        
                        NSDictionary *dic = [regDataArray objectAtIndex:i];
                        RCDUserInfo*userInfo = [RCDUserInfo new];
                        NSNumber *idNum = [dic objectForKey:@"id"];
                        userInfo.userId = [NSString stringWithFormat:@"%d",idNum.intValue];
                        userInfo.portraitUri = [dic objectForKey:@"portrait"];
                        userInfo.name = [dic objectForKey:@"username"];
                        [list addObject:userInfo];
                    }

                }
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    friendList(list);
                });
                
            }else{
                friendList(list);
            }
            
        }
    } failure:^(id response) {
        if (friendList) {
            friendList(list);
        }
    }];
}

- (void)searchFriendListByName:(NSString*)name complete:(void (^)(NSMutableArray*))friendList
{
    NSMutableArray* list = [NSMutableArray new];
    [AFHttpTool searchFriendListByName:name success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
        
        if (friendList) {
            if ([code isEqualToString:@"200"]) {
                
                NSArray * regDataArray = response[@"result"];
                for(int i = 0;i < regDataArray.count;i++){
                    
                    NSDictionary *dic = [regDataArray objectAtIndex:i];
                    RCDUserInfo*userInfo = [RCDUserInfo new];
                    NSNumber *idNum = [dic objectForKey:@"id"];
                    userInfo.userId = [NSString stringWithFormat:@"%d",idNum.intValue];
                    userInfo.portraitUri = [dic objectForKey:@"portrait"];
                    userInfo.name = [dic objectForKey:@"username"];
                    [list addObject:userInfo];
                }
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    friendList(list);
                });
                
            }else{
                friendList(list);
            }
            
        }
    } failure:^(id response) {
        if (friendList) {
            friendList(list);
        }
    }];
}
- (void)requestFriend:(NSString*)userId complete:(void (^)(BOOL))result
{
    [AFHttpTool requestFriend:userId success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
        
        if (result) {
            if ([code isEqualToString:@"200"]) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    result(YES);
                });
                
            }else{
                result(NO);
            }
            
        }
    } failure:^(id response) {
        if (result) {
            result(NO);
        }
    }];
}
- (void)processRequestFriend:(NSString*)userId withIsAccess:(BOOL)isAccess complete:(void (^)(BOOL))result
{
    [AFHttpTool processRequestFriend:userId withIsAccess:isAccess success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
        
        if (result) {
            if ([code isEqualToString:@"200"]) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    result(YES);
                });
                
            }else{
                result(NO);
            }
        }
    } failure:^(id response) {
        if (result) {
            result(NO);
        }
    }];
}

- (void)deleteFriend:(NSString*)userId complete:(void (^)(BOOL))result
{
    [AFHttpTool deleteFriend:userId success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
        
        if (result) {
            if ([code isEqualToString:@"200"]) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    result(YES);
                });
                [[RCDataBaseManager shareInstance]deleteFriendFromDB:userId];
                
            }else{
                result(NO);
            }
            
        }
    } failure:^(id response) {
        if (result) {
            result(NO);
        }
    }];
}

@end
