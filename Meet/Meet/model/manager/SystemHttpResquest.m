//
//  SystemHttpResquest.m
//  ImmediateDelivery
//
//  Created by Anita Lee on 15/7/14.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "SystemHttpResquest.h"
#import "ShareValue.h"

@implementation SystemHttpResquest

@end
@implementation GetCheckCodeRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
@end
@implementation ForgetPasswordRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
@end
@implementation LoginRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
@end
@implementation RegisterRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
@end
@implementation UploadVideoRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation SendGiftToVideoRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation CommentVideoRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetVideoReceivedGiftsListRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
@end
@implementation GetGiftsCommentsListRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
@end
@implementation GetVideoDetailsRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
@end
@implementation GetUserUploadedVideosListRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
@end
@implementation GetStoreReceivedGiftListRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
@end
@implementation SendGiftToStoreRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetStoreCommentsListRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
@end
@implementation CommentStoreRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation CollectStoreRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetStoreDetailsRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
@end
@implementation GetStoreListsRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _areaId=[ShareValue shareInstance].cityId;
    }
    return self;
}
@end
@implementation GetStoreCatagoryRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
@end
@implementation GetAllCitysRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
@end
@implementation PostFriendCircleRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetFriendCircleListRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation ModifyFriendCircleCoverRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetRankingListRequest

@end
@implementation GetRankingDetailsRequest

@end
@implementation GetNearByUserRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
        _lat=[ShareValue shareInstance].currentLocation.latitude;
        _lng=[ShareValue shareInstance].currentLocation.longitude;
    }
    return self;
}
@end
@implementation CommentFriendCircleRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetPersonalFriendCircleRequest
@end
@implementation GetFriendsListRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
//        _memberId=@"13";
        _lat=[ShareValue shareInstance].currentLocation.latitude;
        _lng=[ShareValue shareInstance].currentLocation.longitude;
    }
    return self;
}
@end
@implementation GetMyCreatedGroupsRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetMyJoinedGroupsRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetPersonalInfoRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
@end
@implementation ModifyUserPhotoRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetHomePageInfoRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _srcId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetHomePageGiftsRequest

@end
@implementation SendFriendRstRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation ModifyUserInfoRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetGroupTagsRequest

@end
@implementation GetBlackListRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation CancelBlackListRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation CreateGroupRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
        _lat=[ShareValue shareInstance].currentLocation.latitude;
        _lng=[ShareValue shareInstance].currentLocation.longitude;
    }
    return self;
}
@end
@implementation SearchUserRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}

@end
@implementation SearchGroupRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}

@end
@implementation ApplyGroupRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetFriendApplyMessageRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetGiftMessageRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation AddBlackListRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation RefuseGroupApplyRequest

@end
@implementation RefuseFriendApplyRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation AgreeGroupApplyRequest

@end
@implementation AgreeFriendApplyRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetMallCategoryRequest

@end
@implementation GetItemByIdRequest

@end
@implementation CreateGoldTradeRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation BuyItemByGoldRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetGoldInfoRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetGoldForEverydayRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetGoldByOnlineTimeRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation CreatePayOrderRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation ChangeCurrentLocationRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
        _lat=[ShareValue shareInstance].currentLocation.latitude;
        _lng=[ShareValue shareInstance].currentLocation.longitude;
    }
    return self;
}
@end
@implementation GetMyRankRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetCanSendGiftRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation SendGiftToPersonRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _giveId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetMyCollectedStoresRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _lat=[ShareValue shareInstance].currentLocation.latitude;
        _lng=[ShareValue shareInstance].currentLocation.longitude;
    }
    return self;
}
@end
@implementation GetMyVideosRequest
-(instancetype)init{
    self=[super init];
    if (self) {
//        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation DeleteMyVideoRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetNearByGroupRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation CreateWeChatPrePayRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _userId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation UploadHomePagePicsRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetPromotionRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GiveZanRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _srcId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetHomePageAlbumRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _srcId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetMyStoreDetailsRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation CreateMyStoreRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
        _lng=[ShareValue shareInstance].currentLocation.longitude;
        _lat=[ShareValue shareInstance].currentLocation.latitude;
    }
    return self;
}
@end
@implementation GetLastVisitUsersRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
        _lng=[ShareValue shareInstance].currentLocation.longitude;
        _lat=[ShareValue shareInstance].currentLocation.latitude;
    }
    return self;
}
@end
@implementation DeleteHomePageAlbumRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}

@end
@implementation FeedBackRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
        _meetid=[ShareValue shareInstance].userInfo.meetid;
        _mobile=[ShareValue shareInstance].userInfo.mobile;
    }
    return self;
}
@end
@implementation ModifyPasswordRequest
@synthesize newPwd=_newPwd;
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation GetMyFriendCircleRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _srcId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation DeleteCirclePostRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
    }
    return self;
}
@end
@implementation ReportUserRequest
-(instancetype)init{
    self=[super init];
    if (self) {
        _memberId=[ShareValue shareInstance].userInfo.id;
        _category=@"1";
    }
    return self;
}
@end