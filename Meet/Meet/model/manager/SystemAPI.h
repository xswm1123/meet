//
//  SystemAPI.h
//  ImmediateDelivery
//
//  Created by Anita Lee on 15/7/14.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "X_BaseAPI.h"
#import "SystemHttpResquest.h"
#import "SystemHttpResponse.h"

@interface SystemAPI : NSObject
+(void)GetCheckCodeResquest:(GetCheckCodeRequest *)request success:(void(^)(GetCheckCodeResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)ForgetPasswordRequest:(ForgetPasswordRequest *)request success:(void(^)(ForgetPasswordResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)LoginRequest:(LoginRequest *)request success:(void(^)(LoginResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)RegisterRequest:(RegisterRequest *)request success:(void(^)(RegisterResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)UploadVideoRequest:(UploadVideoRequest *)request success:(void(^)(UploadVideoResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)SendGiftToVideoRequest:(SendGiftToVideoRequest *)request success:(void(^)(SendGiftToVideoResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)CommentVideoRequest:(CommentVideoRequest *)request success:(void(^)(CommentVideoResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetVideoReceivedGiftsListRequest:(GetVideoReceivedGiftsListRequest *)request success:(void(^)(GetVideoReceivedGiftsListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetGiftsCommentsListRequest:(GetGiftsCommentsListRequest *)request success:(void(^)(GetGiftsCommentsListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetVideoDetailsRequest:(GetVideoDetailsRequest *)request success:(void(^)(GetVideoDetailsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetUserUploadedVideosListRequest:(GetUserUploadedVideosListRequest *)request success:(void(^)(GetUserUploadedVideosListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetStoreReceivedGiftListRequest:(GetStoreReceivedGiftListRequest *)request success:(void(^)(GetStoreReceivedGiftListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)SendGiftToStoreRequest:(SendGiftToStoreRequest *)request success:(void(^)(SendGiftToStoreResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetStoreCommentsListRequest:(GetStoreCommentsListRequest *)request success:(void(^)(GetStoreCommentsListResponse*response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)CommentStoreRequest:(CommentStoreRequest *)request success:(void(^)(CommentStoreResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)CollectStoreRequest:(CollectStoreRequest *)request success:(void(^)(CollectStoreResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetStoreDetailsRequest:(GetStoreDetailsRequest *)request success:(void(^)(GetStoreDetailsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetStoreListsRequest:(GetStoreListsRequest *)request success:(void(^)(GetStoreListsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetStoreCatagoryRequest:(GetStoreCatagoryRequest *)request success:(void(^)(GetStoreCatagoryResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetAllCitysRequest:(GetAllCitysRequest *)request success:(void(^)(GetAllCitysResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)PostFriendCircleRequest:(PostFriendCircleRequest *)request success:(void(^)(PostFriendCircleResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetFriendCircleListRequest:(GetFriendCircleListRequest *)request success:(void(^)(GetFriendCircleListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)ModifyFriendCircleCoverRequest:(ModifyFriendCircleCoverRequest *)request success:(void(^)(ModifyFriendCircleCoverResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetRankingListRequest:(GetRankingListRequest *)request success:(void(^)(GetRankingListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetRankingDetailsRequest:(GetRankingDetailsRequest *)request success:(void(^)(GetRankingDetailsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetNearByUserRequest:(GetNearByUserRequest *)request success:(void(^)(GetNearByUserResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)CommentFriendCircleRequest:(CommentFriendCircleRequest *)request success:(void(^)(CommentFriendCircleResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetPersonalFriendCircleRequest:(GetPersonalFriendCircleRequest *)request success:(void(^)(GetPersonalFriendCircleResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetFriendsListRequest:(GetFriendsListRequest *)request success:(void(^)(GetFriendsListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetMyJoinedGroupsRequest:(GetMyJoinedGroupsRequest *)request success:(void(^)(GetMyJoinedGroupsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetMyCreatedGroupsRequest:(GetMyCreatedGroupsRequest *)request success:(void(^)(GetMyCreatedGroupsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetPersonalInfoRequest:(GetPersonalInfoRequest *)request success:(void(^)(GetPersonalInfoResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)ModifyUserPhotoRequest:(ModifyUserPhotoRequest *)request success:(void(^)(ModifyUserPhotoResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetHomePageInfoRequest:(GetHomePageInfoRequest *)request success:(void(^)(GetHomePageInfoResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetHomePageGiftsRequest:(GetHomePageGiftsRequest *)request success:(void(^)(GetHomePageGiftsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)SendFriendRstRequest:(SendFriendRstRequest *)request success:(void(^)(SendFriendRstResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)ModifyUserInfoRequest:(ModifyUserInfoRequest *)request success:(void(^)(ModifyUserInfoResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetGroupTagsRequest:(GetGroupTagsRequest *)request success:(void(^)(GetGroupTagsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetBlackListRequest:(GetBlackListRequest *)request success:(void(^)(GetBlackListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)CancelBlackListRequest:(CancelBlackListRequest *)request success:(void(^)(CancelBlackListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)CreateGroupRequest:(CreateGroupRequest *)request success:(void(^)(CreateGroupResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)SearchUserRequest:(SearchUserRequest *)request success:(void(^)(SearchUserResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)SearchGroupRequest:(SearchGroupRequest *)request success:(void(^)(SearchGroupResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)ApplyGroupRequest:(ApplyGroupRequest *)request success:(void(^)(ApplyGroupResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetFriendApplyMessageRequest:(GetFriendApplyMessageRequest *)request success:(void(^)(GetFriendApplyMessageResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)AddBlackListRequest:(AddBlackListRequest *)request success:(void(^)(AddBlackListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)RefuseGroupApplyRequest:(RefuseGroupApplyRequest *)request success:(void(^)(RefuseGroupApplyResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)RefuseFriendApplyRequest:(RefuseFriendApplyRequest *)request success:(void(^)(RefuseFriendApplyResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)AgreeGroupApplyRequest:(AgreeGroupApplyRequest *)request success:(void(^)(AgreeGroupApplyResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)AgreeFriendApplyRequest:(AgreeFriendApplyRequest *)request success:(void(^)(AgreeFriendApplyResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetGiftMessageRequest:(GetGiftMessageRequest *)request success:(void(^)(GetGiftMessageResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetMallCategoryRequest:(GetMallCategoryRequest *)request success:(void(^)(GetMallCategoryResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetItemByIdRequest:(GetItemByIdRequest *)request success:(void(^)(GetItemByIdResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)CreateGoldTradeRequest:(CreateGoldTradeRequest *)request success:(void(^)(CreateGoldTradeResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)BuyItemByGoldRequest:(BuyItemByGoldRequest *)request success:(void(^)(BuyItemByGoldResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetGoldInfoRequest:(GetGoldInfoRequest *)request success:(void(^)(GetGoldInfoResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetGoldForEverydayRequest:(GetGoldForEverydayRequest *)request success:(void(^)(GetGoldForEverydayResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetGoldByOnlineTimeRequest:(GetGoldByOnlineTimeRequest *)request success:(void(^)(GetGoldByOnlineTimeResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)CreatePayOrderRequest:(CreatePayOrderRequest *)request success:(void(^)(CreatePayOrderResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)ChangeCurrentLocationRequest:(ChangeCurrentLocationRequest *)request success:(void(^)(ChangeCurrentLocationResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetMyRankRequest:(GetMyRankRequest *)request success:(void(^)(GetMyRankResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetCanSendGiftRequest:(GetCanSendGiftRequest *)request success:(void(^)(GetCanSendGiftResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)SendGiftToPersonRequest:(SendGiftToPersonRequest *)request success:(void(^)(SendGiftToPersonResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetMyCollectedStoresRequest:(GetMyCollectedStoresRequest *)request success:(void(^)(GetMyCollectedStoresResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetMyVideosRequest:(GetMyVideosRequest *)request success:(void(^)(GetMyVideosResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)DeleteMyVideoRequest:(DeleteMyVideoRequest *)request success:(void(^)(DeleteMyVideoResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetNearByGroupRequest:(GetNearByGroupRequest *)request success:(void(^)(GetNearByGroupResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)CreateWeChatPrePayRequest:(CreateWeChatPrePayRequest *)request success:(void(^)(CreateWeChatPrePayResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)UploadHomePagePicsRequest:(UploadHomePagePicsRequest *)request success:(void(^)(UploadHomePagePicsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetPromotionRequest:(GetPromotionRequest *)request success:(void(^)(GetPromotionResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GiveZanRequest:(GiveZanRequest *)request success:(void(^)(GiveZanResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetHomePageAlbumRequest:(GetHomePageAlbumRequest *)request success:(void(^)(GetHomePageAlbumResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetMyStoreDetailsRequest:(GetMyStoreDetailsRequest *)request success:(void(^)(GetMyStoreDetailsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)CreateMyStoreRequest:(CreateMyStoreRequest *)request success:(void(^)(CreateMyStoreResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetLastVisitUsersRequest:(GetLastVisitUsersRequest *)request success:(void(^)(GetLastVisitUsersResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)DeleteHomePageAlbumRequest:(DeleteHomePageAlbumRequest *)request success:(void(^)(DeleteHomePageAlbumResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)FeedBackRequest:(FeedBackRequest *)request success:(void(^)(FeedBackResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)ModifyPasswordRequest:(ModifyPasswordRequest *)request success:(void(^)(ModifyPasswordResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)GetMyFriendCircleRequest:(GetMyFriendCircleRequest *)request success:(void(^)(GetMyFriendCircleResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)DeleteCirclePostRequest:(DeleteCirclePostRequest *)request success:(void(^)(DeleteCirclePostResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
+(void)ReportUserRequest:(ReportUserRequest *)request success:(void(^)(ReportUserResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
@end
