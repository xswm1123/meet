//
//  SystemAPI.m
//  ImmediateDelivery
//
//  Created by Anita Lee on 15/7/14.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "SystemAPI.h"
#import "ServerConfig.h"


@implementation SystemAPI
+(void)GetCheckCodeResquest:(GetCheckCodeRequest *)request success:(void (^)(GetCheckCodeResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI postHttpRequest:request apiPath:GetCheckCode Success:^(X_BaseHttpResponse *response) {
        success((GetCheckCodeResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetCheckCodeResponse class]];
}
+(void)ForgetPasswordRequest:(ForgetPasswordRequest *)request success:(void (^)(ForgetPasswordResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI postHttpRequest:request apiPath:ForgetPassword Success:^(X_BaseHttpResponse *response) {
        success((ForgetPasswordResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ForgetPasswordResponse class]];
}
+(void)LoginRequest:(LoginRequest *)request success:(void (^)(LoginResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI postHttpRequest:request apiPath:Login Success:^(X_BaseHttpResponse *response) {
        success((LoginResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[LoginResponse class]];
}
+(void)RegisterRequest:(RegisterRequest *)request success:(void (^)(RegisterResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI postHttpRequest:request apiPath:Register Success:^(X_BaseHttpResponse *response) {
        success((RegisterResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[RegisterResponse class]];
}
+(void)UploadVideoRequest:(UploadVideoRequest *)request success:(void (^)(UploadVideoResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI postHttpRequest:request apiPath:UploadVideo Success:^(X_BaseHttpResponse *response) {
        success((UploadVideoResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[UploadVideoResponse class]];
}
+(void)SendGiftToVideoRequest:(SendGiftToVideoRequest *)request success:(void (^)(SendGiftToVideoResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI postHttpRequest:request apiPath:SendGiftToVideo Success:^(X_BaseHttpResponse *response) {
        success((SendGiftToVideoResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[SendGiftToVideoResponse class]];
}
+(void)CommentVideoRequest:(CommentVideoRequest *)request success:(void (^)(CommentVideoResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI postHttpRequest:request apiPath:CommentVideo Success:^(X_BaseHttpResponse *response) {
        success((CommentVideoResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[CommentVideoResponse class]];
}
+(void)GetVideoReceivedGiftsListRequest:(GetVideoReceivedGiftsListRequest *)request success:(void (^)(GetVideoReceivedGiftsListResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetVideoReceivedGiftList Success:^(X_BaseHttpResponse *response) {
        success((GetVideoReceivedGiftsListResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetVideoReceivedGiftsListResponse class]];
}
+(void)GetGiftsCommentsListRequest:(GetGiftsCommentsListRequest *)request success:(void (^)(GetGiftsCommentsListResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetVideoComments Success:^(X_BaseHttpResponse *response) {
        success((GetGiftsCommentsListResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetGiftsCommentsListResponse class]];
}
+(void)GetVideoDetailsRequest:(GetVideoDetailsRequest *)request success:(void (^)(GetVideoDetailsResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetVideoDetails Success:^(X_BaseHttpResponse *response) {
        success((GetVideoDetailsResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetVideoDetailsResponse class]];
}
+(void)GetUserUploadedVideosListRequest:(GetUserUploadedVideosListRequest *)request success:(void (^)(GetUserUploadedVideosListResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetVideoList Success:^(X_BaseHttpResponse *response) {
        success((GetUserUploadedVideosListResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetUserUploadedVideosListResponse class]];
}
+(void)GetStoreReceivedGiftListRequest:(GetStoreReceivedGiftListRequest *)request success:(void (^)(GetStoreReceivedGiftListResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetGiftToStores Success:^(X_BaseHttpResponse *response) {
        success((GetStoreReceivedGiftListResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetStoreReceivedGiftListResponse class]];
}
+(void)SendGiftToStoreRequest:(SendGiftToStoreRequest *)request success:(void (^)(SendGiftToStoreResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI postHttpRequest:request apiPath:SendGiftToStore Success:^(X_BaseHttpResponse *response) {
        success((SendGiftToStoreResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[SendGiftToStoreResponse class]];

}
+(void)GetStoreCommentsListRequest:(GetStoreCommentsListRequest *)request success:(void (^)(GetStoreCommentsListResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetStoreCommentList Success:^(X_BaseHttpResponse *response) {
        success((GetStoreCommentsListResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetStoreCommentsListResponse class]];
}
+(void)CommentStoreRequest:(CommentStoreRequest *)request success:(void (^)(CommentStoreResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI postHttpRequest:request apiPath:CommentStore Success:^(X_BaseHttpResponse *response) {
        success((CommentStoreResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[CommentStoreResponse class]];
}
+(void)CollectStoreRequest:(CollectStoreRequest *)request success:(void (^)(CollectStoreResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI postHttpRequest:request apiPath:CollectStore Success:^(X_BaseHttpResponse *response) {
        success((CollectStoreResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[CollectStoreResponse class]];
}
+(void)GetStoreDetailsRequest:(GetStoreDetailsRequest *)request success:(void (^)(GetStoreDetailsResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetStoreDetails Success:^(X_BaseHttpResponse *response) {
        success((GetStoreDetailsResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetStoreDetailsResponse class]];
}
+(void)GetStoreListsRequest:(GetStoreListsRequest *)request success:(void (^)(GetStoreListsResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetStoresList Success:^(X_BaseHttpResponse *response) {
        success((GetStoreListsResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetStoreListsResponse class]];
}
+(void)GetStoreCatagoryRequest:(GetStoreCatagoryRequest *)request success:(void (^)(GetStoreCatagoryResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetStoreCatagory Success:^(X_BaseHttpResponse *response) {
        success((GetStoreCatagoryResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetStoreCatagoryResponse class]];
}
+(void)GetAllCitysRequest:(GetAllCitysRequest *)request success:(void(^)(GetAllCitysResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetAllCitys Success:^(X_BaseHttpResponse *response) {
        success((GetAllCitysResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetAllCitysResponse class]];
}
+(void)PostFriendCircleRequest:(PostFriendCircleRequest *)request success:(void(^)(PostFriendCircleResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:PostFirendCircle Success:^(X_BaseHttpResponse *response) {
        success((PostFriendCircleResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[PostFriendCircleResponse class]];
}
+(void)GetFriendCircleListRequest:(GetFriendCircleListRequest *)request success:(void(^)(GetFriendCircleListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetFriendCircleLsit Success:^(X_BaseHttpResponse *response) {
        success((GetFriendCircleListResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetFriendCircleListResponse class]];
}
+(void)ModifyFriendCircleCoverRequest:(ModifyFriendCircleCoverRequest *)request success:(void(^)(ModifyFriendCircleCoverResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:ModifyFriendCircleCover Success:^(X_BaseHttpResponse *response) {
        success((ModifyFriendCircleCoverResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ModifyFriendCircleCoverResponse class]];
}
+(void)GetRankingListRequest:(GetRankingListRequest *)request success:(void(^)(GetRankingListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetRankingList Success:^(X_BaseHttpResponse *response) {
        success((GetRankingListResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetRankingListResponse class]];
}
+(void)GetRankingDetailsRequest:(GetRankingDetailsRequest *)request success:(void(^)(GetRankingDetailsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetRaningDetails Success:^(X_BaseHttpResponse *response) {
        success((GetRankingDetailsResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetRankingDetailsResponse class]];
}
+(void)GetNearByUserRequest:(GetNearByUserRequest *)request success:(void(^)(GetNearByUserResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetNearByUser Success:^(X_BaseHttpResponse *response) {
        success((GetNearByUserResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetNearByUserResponse class]];
}
+(void)CommentFriendCircleRequest:(CommentFriendCircleRequest *)request success:(void(^)(CommentFriendCircleResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:CommentFriendCircle Success:^(X_BaseHttpResponse *response) {
        success((CommentFriendCircleResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[CommentFriendCircleResponse class]];
}
+(void)GetPersonalFriendCircleRequest:(GetPersonalFriendCircleRequest *)request success:(void(^)(GetPersonalFriendCircleResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetPersonalFriendCircle Success:^(X_BaseHttpResponse *response) {
        success((GetPersonalFriendCircleResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetPersonalFriendCircleResponse class]];
}
+(void)GetFriendsListRequest:(GetFriendsListRequest *)request success:(void(^)(GetFriendsListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetFriendsList Success:^(X_BaseHttpResponse *response) {
        success((GetFriendsListResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetFriendsListResponse class]];
}
+(void)GetMyJoinedGroupsRequest:(GetMyJoinedGroupsRequest *)request success:(void(^)(GetMyJoinedGroupsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetMyJoinedGroups Success:^(X_BaseHttpResponse *response) {
        success((GetMyJoinedGroupsResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetMyJoinedGroupsResponse class]];
}
+(void)GetMyCreatedGroupsRequest:(GetMyCreatedGroupsRequest *)request success:(void(^)(GetMyCreatedGroupsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetMyCreatedGroups Success:^(X_BaseHttpResponse *response) {
        success((GetMyCreatedGroupsResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetMyCreatedGroupsResponse class]];
}
+(void)GetPersonalInfoRequest:(GetPersonalInfoRequest *)request success:(void(^)(GetPersonalInfoResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetPersonalInfo Success:^(X_BaseHttpResponse *response) {
        success((GetPersonalInfoResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetPersonalInfoResponse class]];
}
+(void)ModifyUserPhotoRequest:(ModifyUserPhotoRequest *)request success:(void(^)(ModifyUserPhotoResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:ModifyUserPhoto Success:^(X_BaseHttpResponse *response) {
        success((ModifyUserPhotoResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ModifyUserPhotoResponse class]];
}
+(void)GetHomePageInfoRequest:(GetHomePageInfoRequest *)request success:(void(^)(GetHomePageInfoResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetHomePageInfo Success:^(X_BaseHttpResponse *response) {
        success((GetHomePageInfoResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetHomePageInfoResponse class]];
}
+(void)GetHomePageGiftsRequest:(GetHomePageGiftsRequest *)request success:(void(^)(GetHomePageGiftsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetHomePageGifts Success:^(X_BaseHttpResponse *response) {
        success((GetHomePageGiftsResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetHomePageGiftsResponse class]];
}
+(void)SendFriendRstRequest:(SendFriendRstRequest *)request success:(void(^)(SendFriendRstResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:SendFriendRst Success:^(X_BaseHttpResponse *response) {
        success((SendFriendRstResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[SendFriendRstResponse class]];
}
+(void)ModifyUserInfoRequest:(ModifyUserInfoRequest *)request success:(void(^)(ModifyUserInfoResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:ModifyUserInfo Success:^(X_BaseHttpResponse *response) {
        success((ModifyUserInfoResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ModifyUserInfoResponse class]];
}
+(void)GetGroupTagsRequest:(GetGroupTagsRequest *)request success:(void(^)(GetGroupTagsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetGroupTags Success:^(X_BaseHttpResponse *response) {
        success((GetGroupTagsResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetGroupTagsResponse class]];
}
+(void)GetBlackListRequest:(GetBlackListRequest *)request success:(void(^)(GetBlackListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetBlackList Success:^(X_BaseHttpResponse *response) {
        success((GetBlackListResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetBlackListResponse class]];
}
+(void)CancelBlackListRequest:(CancelBlackListRequest *)request success:(void(^)(CancelBlackListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:CancelBlackList Success:^(X_BaseHttpResponse *response) {
        success((CancelBlackListResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[CancelBlackListResponse class]];
}
+(void)CreateGroupRequest:(CreateGroupRequest *)request success:(void(^)(CreateGroupResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:CreateGroup Success:^(X_BaseHttpResponse *response) {
        success((CreateGroupResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[CreateGroupResponse class]];
}
+(void)SearchUserRequest:(SearchUserRequest *)request success:(void(^)(SearchUserResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:SearchUser Success:^(X_BaseHttpResponse *response) {
        success((SearchUserResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[SearchUserResponse class]];
}
+(void)SearchGroupRequest:(SearchGroupRequest *)request success:(void(^)(SearchGroupResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:SearchGroup Success:^(X_BaseHttpResponse *response) {
        success((SearchGroupResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[SearchGroupResponse class]];
}
+(void)ApplyGroupRequest:(ApplyGroupRequest *)request success:(void(^)(ApplyGroupResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:ApplyGroup Success:^(X_BaseHttpResponse *response) {
        success((ApplyGroupResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ApplyGroupResponse class]];
}
+(void)GetFriendApplyMessageRequest:(GetFriendApplyMessageRequest *)request success:(void(^)(GetFriendApplyMessageResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetFriendApplyMessage Success:^(X_BaseHttpResponse *response) {
        success((GetFriendApplyMessageResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetFriendApplyMessageResponse class]];
}
+(void)AddBlackListRequest:(AddBlackListRequest *)request success:(void(^)(AddBlackListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:AddBlackList Success:^(X_BaseHttpResponse *response) {
        success((AddBlackListResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[AddBlackListResponse class]];
}
+(void)RefuseGroupApplyRequest:(RefuseGroupApplyRequest *)request success:(void(^)(RefuseGroupApplyResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:RefuseGroupApply Success:^(X_BaseHttpResponse *response) {
        success((RefuseGroupApplyResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[RefuseGroupApplyResponse class]];
}
+(void)RefuseFriendApplyRequest:(RefuseFriendApplyRequest *)request success:(void(^)(RefuseFriendApplyResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:RefuseFriendApply Success:^(X_BaseHttpResponse *response) {
        success((RefuseFriendApplyResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[RefuseFriendApplyResponse class]];
}
+(void)AgreeGroupApplyRequest:(AgreeGroupApplyRequest *)request success:(void(^)(AgreeGroupApplyResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:AgreeGroupApply Success:^(X_BaseHttpResponse *response) {
        success((AgreeGroupApplyResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[AgreeGroupApplyResponse class]];
}
+(void)AgreeFriendApplyRequest:(AgreeFriendApplyRequest *)request success:(void(^)(AgreeFriendApplyResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:AgreeFriendApply Success:^(X_BaseHttpResponse *response) {
        success((AgreeFriendApplyResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[AgreeFriendApplyResponse class]];
}
+(void)GetGiftMessageRequest:(GetGiftMessageRequest *)request success:(void(^)(GetGiftMessageResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetGiftMessage Success:^(X_BaseHttpResponse *response) {
        success((GetGiftMessageResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetGiftMessageResponse class]];
}
+(void)GetMallCategoryRequest:(GetMallCategoryRequest *)request success:(void(^)(GetMallCategoryResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetMallCategory Success:^(X_BaseHttpResponse *response) {
        success((GetMallCategoryResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetMallCategoryResponse class]];
}
+(void)GetItemByIdRequest:(GetItemByIdRequest *)request success:(void(^)(GetItemByIdResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetItemById Success:^(X_BaseHttpResponse *response) {
        success((GetItemByIdResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetItemByIdResponse class]];
}
+(void)CreateGoldTradeRequest:(CreateGoldTradeRequest *)request success:(void(^)(CreateGoldTradeResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:CreateGoldTrade Success:^(X_BaseHttpResponse *response) {
        success((CreateGoldTradeResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[CreateGoldTradeResponse class]];

}
+(void)BuyItemByGoldRequest:(BuyItemByGoldRequest *)request success:(void(^)(BuyItemByGoldResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:BuyItemByGold Success:^(X_BaseHttpResponse *response) {
        success((BuyItemByGoldResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[BuyItemByGoldResponse class]];
}
+(void)GetGoldInfoRequest:(GetGoldInfoRequest *)request success:(void(^)(GetGoldInfoResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetGoldInfo Success:^(X_BaseHttpResponse *response) {
        success((GetGoldInfoResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetGoldInfoResponse class]];
}
+(void)GetGoldForEverydayRequest:(GetGoldForEverydayRequest *)request success:(void(^)(GetGoldForEverydayResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:GetGoldForEveryday Success:^(X_BaseHttpResponse *response) {
        success((GetGoldForEverydayResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetGoldForEverydayResponse class]];
}
+(void)GetGoldByOnlineTimeRequest:(GetGoldByOnlineTimeRequest *)request success:(void(^)(GetGoldByOnlineTimeResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:GetGoldByOnlineTime Success:^(X_BaseHttpResponse *response) {
        success((GetGoldByOnlineTimeResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetGoldByOnlineTimeResponse class]];
}
+(void)CreatePayOrderRequest:(CreatePayOrderRequest *)request success:(void(^)(CreatePayOrderResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:CreatePayOrder Success:^(X_BaseHttpResponse *response) {
        success((CreatePayOrderResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[CreatePayOrderResponse class]];
}
+(void)ChangeCurrentLocationRequest:(ChangeCurrentLocationRequest *)request success:(void(^)(ChangeCurrentLocationResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:ChangeCurrentLocation Success:^(X_BaseHttpResponse *response) {
        success((ChangeCurrentLocationResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ChangeCurrentLocationResponse class]];
}
+(void)GetMyRankRequest:(GetMyRankRequest *)request success:(void(^)(GetMyRankResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetMyRank Success:^(X_BaseHttpResponse *response) {
        success((GetMyRankResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetMyRankResponse class]];
}
+(void)GetCanSendGiftRequest:(GetCanSendGiftRequest *)request success:(void(^)(GetCanSendGiftResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetCanSendGift Success:^(X_BaseHttpResponse *response) {
        success((GetCanSendGiftResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetCanSendGiftResponse class]];
}
+(void)SendGiftToPersonRequest:(SendGiftToPersonRequest *)request success:(void(^)(SendGiftToPersonResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:SendGiftToPerson Success:^(X_BaseHttpResponse *response) {
        success((SendGiftToPersonResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[SendGiftToPersonResponse class]];
}
+(void)GetMyCollectedStoresRequest:(GetMyCollectedStoresRequest *)request success:(void(^)(GetMyCollectedStoresResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetMyCollectedStores Success:^(X_BaseHttpResponse *response) {
        success((GetMyCollectedStoresResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetMyCollectedStoresResponse class]];
}
+(void)GetMyVideosRequest:(GetMyVideosRequest *)request success:(void(^)(GetMyVideosResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetMyVideos Success:^(X_BaseHttpResponse *response) {
        success((GetMyVideosResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetMyVideosResponse class]];
}
+(void)DeleteMyVideoRequest:(DeleteMyVideoRequest *)request success:(void(^)(DeleteMyVideoResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:DeleteMyVideo Success:^(X_BaseHttpResponse *response) {
        success((DeleteMyVideoResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[DeleteMyVideoResponse class]];
}
+(void)GetNearByGroupRequest:(GetNearByGroupRequest *)request success:(void(^)(GetNearByGroupResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetNearByGroup Success:^(X_BaseHttpResponse *response) {
        success((GetNearByGroupResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetNearByGroupResponse class]];
}
+(void)CreateWeChatPrePayRequest:(CreateWeChatPrePayRequest *)request success:(void(^)(CreateWeChatPrePayResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:CreateWeChatPrePay Success:^(X_BaseHttpResponse *response) {
        success((CreateWeChatPrePayResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[CreateWeChatPrePayResponse class]];
}
+(void)UploadHomePagePicsRequest:(UploadHomePagePicsRequest *)request success:(void(^)(UploadHomePagePicsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:UploadHomePagePics Success:^(X_BaseHttpResponse *response) {
        success((UploadHomePagePicsResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[UploadHomePagePicsResponse class]];
}
+(void)GetPromotionRequest:(GetPromotionRequest *)request success:(void(^)(GetPromotionResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetPromotion Success:^(id data) {
        success(data);
    } fail:^(BOOL NotReachable, NSString *descript) {
        fail(NotReachable,descript);
    }];
}
+(void)GiveZanRequest:(GiveZanRequest *)request success:(void(^)(GiveZanResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GiveZan Success:^(X_BaseHttpResponse *response) {
        success((GiveZanResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GiveZanResponse class]];
}
+(void)GetHomePageAlbumRequest:(GetHomePageAlbumRequest *)request success:(void(^)(GetHomePageAlbumResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetHomePageAlbum Success:^(X_BaseHttpResponse *response) {
        success((GetHomePageAlbumResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetHomePageAlbumResponse class]];
}
+(void)GetMyStoreDetailsRequest:(GetMyStoreDetailsRequest *)request success:(void(^)(GetMyStoreDetailsResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetMyStoreDetails Success:^(X_BaseHttpResponse *response) {
        success((GetMyStoreDetailsResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetMyStoreDetailsResponse class]];
}
+(void)CreateMyStoreRequest:(CreateMyStoreRequest *)request success:(void(^)(CreateMyStoreResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:CreateMyStore Success:^(X_BaseHttpResponse *response) {
        success((CreateMyStoreResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[CreateMyStoreResponse class]];
}
+(void)GetLastVisitUsersRequest:(GetLastVisitUsersRequest *)request success:(void(^)(GetLastVisitUsersResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetLastVisitUsers Success:^(X_BaseHttpResponse *response) {
        success((GetLastVisitUsersResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetLastVisitUsersResponse class]];
}
+(void)DeleteHomePageAlbumRequest:(DeleteHomePageAlbumRequest *)request success:(void(^)(DeleteHomePageAlbumResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:DeleteHomePageAlbum Success:^(X_BaseHttpResponse *response) {
        success((DeleteHomePageAlbumResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[DeleteHomePageAlbumResponse class]];
}
+(void)FeedBackRequest:(FeedBackRequest *)request success:(void(^)(FeedBackResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:FeedBack Success:^(X_BaseHttpResponse *response) {
        success((FeedBackResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[FeedBackResponse class]];
}
+(void)ModifyPasswordRequest:(ModifyPasswordRequest *)request success:(void(^)(ModifyPasswordResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:ModifyPassword Success:^(X_BaseHttpResponse *response) {
        success((ModifyPasswordResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ModifyPasswordResponse class]];
}
+(void)GetMyFriendCircleRequest:(GetMyFriendCircleRequest *)request success:(void(^)(GetMyFriendCircleResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetMyFriendCircle Success:^(X_BaseHttpResponse *response) {
        success((GetMyFriendCircleResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetMyFriendCircleResponse class]];
}
+(void)DeleteCirclePostRequest:(DeleteCirclePostRequest *)request success:(void(^)(DeleteCirclePostResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:DeleteCirclePost Success:^(X_BaseHttpResponse *response) {
        success((DeleteCirclePostResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[DeleteCirclePostResponse class]];
}
+(void)ReportUserRequest:(ReportUserRequest *)request success:(void(^)(ReportUserResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:ReportUser Success:^(X_BaseHttpResponse *response) {
        success((ReportUserResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ReportUserResponse class]];
}
+(void)GetNearlyVisitCountRequest:(GetNearlyVisitCountRequest *)request success:(void(^)(id data))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetNearlyVisitCount Success:^(id data) {
        success(data);
    } fail:^(BOOL NotReachable, NSString *descript) {
         fail(NotReachable,descript);
    }];
}
+(void)UpdateGetuiCidRequest:(UpdateGetuiCidRequest *)request success:(void(^)(UpdateGetuiCidResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:UpdateGetuiCid Success:^(X_BaseHttpResponse *response) {
        success((UpdateGetuiCidResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[UpdateGetuiCidResponse class]];
}
+(void)GetIndexCategoryRequest:(GetIndexCategoryRequest *)request success:(void(^)(GetIndexCategoryResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetIndexCategory Success:^(X_BaseHttpResponse *response) {
        success((GetIndexCategoryResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetIndexCategoryResponse class]];
}
+(void)GetIndexVideoListRequest:(GetIndexVideoListRequest *)request success:(void(^)(GetIndexVideoListResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetIndexVideoList Success:^(X_BaseHttpResponse *response) {
        success((GetIndexVideoListResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetIndexVideoListResponse class]];
}
+(void)IAPPurchaseRequest:(IAPPurchaseRequest *)request success:(void(^)(IAPPurchaseResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:IAPPurchase Success:^(X_BaseHttpResponse *response) {
        success((IAPPurchaseResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[IAPPurchaseResponse class]];
}
+(void)DeleteCircleCommentRequest:(DeleteCircleCommentRequest *)request success:(void(^)(DeleteCircleCommentResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:DeleteCircleComment Success:^(X_BaseHttpResponse *response) {
        success((DeleteCircleCommentResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[DeleteCircleCommentResponse class]];
}
+(void)IsLoginReqeust:(IsLoginReqeust *)request success:(void(^)(id data)) success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:Islogin Success:^(id data) {
        success(data);
    } fail:^(BOOL NotReachable, NSString *descript) {
        fail(NotReachable,descript);
    }];
}
+(void)RegisterExternRequest:(RegisterExternRequest *)request success:(void(^)(RegisterExternResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:RegisterExtern Success:^(X_BaseHttpResponse *response) {
        success((RegisterExternResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[RegisterExternResponse class]];
}
+(void)BlindMobileRequest:(BlindMobileRequest *)request success:(void(^)(BlindMobileResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:BlindMobile Success:^(X_BaseHttpResponse *response) {
        success((BlindMobileResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[BlindMobileResponse class]];
}
+(void)BlindExternRequest:(BlindExternRequest *)request success:(void(^)(BlindExternResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:BlindExtern Success:^(X_BaseHttpResponse *response) {
        success((BlindExternResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[BlindExternResponse class]];
}
+(void)GetDatingDataRequest:(GetDatingDataRequest *)request success:(void(^)(GetDatingDataResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetDatingData Success:^(X_BaseHttpResponse *response) {
        success((GetDatingDataResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetDatingDataResponse class]];
}
+(void)PublishDatingRequest:(PublishDatingRequest *)request success:(void(^)(PublishDatingResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:PublishDating Success:^(X_BaseHttpResponse *response) {
        success((PublishDatingResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[PublishDatingResponse class]];
}
+(void)ShareCallBackRequest:(ShareCallBackRequest *)request success:(void(^)(ShareCallBackResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI postHttpRequest:request apiPath:ShareCallBack Success:^(X_BaseHttpResponse *response) {
        success((ShareCallBackResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ShareCallBackResponse class]];
}
+(void)GetVIPTypesRequest:(GetVIPTypesRequest *)request success:(void(^)(GetVIPTypesResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [X_BaseAPI getHttpRequest:request apiPath:GetVIPTpyes Success:^(X_BaseHttpResponse *response) {
        success((GetVIPTypesResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetVIPTypesResponse class]];
}
@end
