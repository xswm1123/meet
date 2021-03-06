//
//  RCDChatViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDChatViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDChatViewController.h"
#import "RCDDiscussGroupSettingViewController.h"
#import "RCDRoomSettingViewController.h"
#import "RCDPrivateSettingViewController.h"
#import "RCDGroupDetailViewController.h"
#import "RCDRCIMDataSource.h"
#import "RCDHttpTool.h"
#import "RealTimeLocationViewController.h"
#import "RealTimeLocationStartCell.h"
#import "RealTimeLocationStatusView.h"
#import "RealTimeLocationEndCell.h"
#import "BaseViewController.h"
#import "PersonalHomePageViewController.h"

@interface RCDChatViewController () <UIActionSheetDelegate, RCRealTimeLocationObserver, RealTimeLocationStatusViewDelegate, UIAlertViewDelegate, RCMessageCellDelegate>
@property (nonatomic, weak)id<RCRealTimeLocationProxy> realTimeLocation;
@property (nonatomic, strong)RealTimeLocationStatusView *realTimeLocationStatusView;
@property (nonatomic,strong) NSMutableArray * customerEmojs;
@property (nonatomic,strong) UIScrollView * emojScrollView;
@end

@implementation RCDChatViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    //data
    [IQKeyboardManager sharedManager].enable=NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar=NO;
    self.conversationType = self.conversation.conversationType;
    self.targetId = self.conversation.targetId;
    self.userName = self.conversation.conversationTitle;
    self.title = self.conversation.conversationTitle;
    
    self.unReadMessage = self.conversation.unreadMessageCount;
    self.enableNewComingMessageIcon=YES;//开启消息提醒
    self.enableUnreadMessageIcon=YES;
    
    self.enableSaveNewPhotoToLocalSystem = YES;

//    if (self.conversationType != ConversationType_CHATROOM) {
//      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
//          initWithImage:[UIImage imageNamed:@"Setting"]
//                  style:UIBarButtonItemStylePlain
//                 target:self
//                 action:@selector(rightBarButtonItemClicked:)];
//    } else {
//        self.navigationItem.rightBarButtonItem = nil;
//    }

/*******************实时地理位置共享***************/
    [self registerClass:[RealTimeLocationStartCell class] forCellWithReuseIdentifier:RCRealTimeLocationStartMessageTypeIdentifier];
    [self registerClass:[RealTimeLocationEndCell class] forCellWithReuseIdentifier:RCRealTimeLocationEndMessageTypeIdentifier];
    
    __weak typeof(&*self) weakSelf = self;
    [[RCRealTimeLocationManager sharedManager] getRealTimeLocationProxy:self.conversationType targetId:self.targetId success:^(id<RCRealTimeLocationProxy> realTimeLocation) {
        weakSelf.realTimeLocation = realTimeLocation;
        [weakSelf.realTimeLocation addRealTimeLocationObserver:self];
        [weakSelf updateRealTimeLocationStatus];
    } error:^(RCRealTimeLocationErrorCode status) {
        NSLog(@"get location share failre with code %d", (int)status);
    }];

/******************实时地理位置共享**************/
    
    
    [self notifyUpdateUnreadMessageCount];
    
    //如果是单聊，不显示发送方昵称
    if (self.conversationType == ConversationType_PRIVATE) {
        self.displayUserNameInCell = NO;
    }
    
/***********如何自定义面板功能***********************
 自定义面板功能首先要继承RCConversationViewController，如现在所在的这个文件。
 然后在viewDidLoad函数的super函数之后去编辑按钮：
 插入到指定位置的方法如下：
 [self.pluginBoardView insertItemWithImage:imagePic
                                     title:title
                                   atIndex:0
                                       tag:101];
 或添加到最后的：
 [self.pluginBoardView insertItemWithImage:imagePic
                                     title:title
                                       tag:101];
 删除指定位置的方法：
 [self.pluginBoardView removeItemAtIndex:0];
 删除指定标签的方法：
 [self.pluginBoardView removeItemWithTag:101];
 删除所有：
 [self.pluginBoardView removeAllItems];
 更换现有扩展项的图标和标题:
 [self.pluginBoardView updateItemAtIndex:0 image:newImage title:newTitle];
 或者根据tag来更换
 [self.pluginBoardView updateItemWithTag:101 image:newImage title:newTitle];
 以上所有的接口都在RCPluginBoardView.h可以查到。
 
 当编辑完扩展功能后，下一步就是要实现对扩展功能事件的处理，放开被注掉的函数
 pluginBoardView:clickedItemWithTag:
 在super之后加上自己的处理。
 
 */
  
  //默认输入类型为语音
  //self.defaultInputType = RCChatSessionInputBarInputExtention;

    
/***********如何在会话界面插入提醒消息***********************

    RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:@"请不要轻易给陌生人汇钱！" extra:nil];
    BOOL saveToDB = NO;  //是否保存到数据库中
    RCMessage *savedMsg ;
    if (saveToDB) {
        savedMsg = [[RCIMClient sharedRCIMClient] insertMessage:self.conversationType targetId:self.targetId senderUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId sendStatus:SentStatus_SENT content:warningMsg];
    } else {
        savedMsg =[[RCMessage alloc] initWithType:self.conversationType targetId:self.targetId direction:MessageDirection_SEND messageId:-1 content:warningMsg];//注意messageId要设置为－1
    }
    [self appendAndDisplayMessage:savedMsg];
*/
    [self.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"biaoq.png"]
                                        title:@"表情"
                                          tag:666];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)leftBarButtonItemPressed:(id)sender {
    if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_OUTGOING ||
        [self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_CONNECTED) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出当前界面位置共享会终止，确定要退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        [alertView show];
    } else {
        [self popupChatViewController];
    }
    
}

- (void)popupChatViewController {
    [super leftBarButtonItemPressed:nil];
    [self.realTimeLocation removeRealTimeLocationObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  此处使用自定义设置，开发者可以根据需求自己实现
 *  不添加rightBarButtonItemClicked事件，则使用默认实现。
 */
- (void)rightBarButtonItemClicked:(id)sender {
  if (self.conversationType == ConversationType_PRIVATE) {

    RCDPrivateSettingViewController *settingVC =
        [[RCDPrivateSettingViewController alloc] init];
    settingVC.conversationType = self.conversationType;
    settingVC.targetId = self.targetId;
//    settingVC.conversationTitle = self.userName;
//    //设置讨论组标题时，改变当前聊天界面的标题
//    settingVC.setDiscussTitleCompletion = ^(NSString *discussTitle) {
//      self.title = discussTitle;
//    };
    //清除聊天记录之后reload data
    __weak RCDChatViewController *weakSelf = self;
    settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
      if (isSuccess) {
        [weakSelf.conversationDataRepository removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
          [weakSelf.conversationMessageCollectionView reloadData];
        });
      }
    };

    [self.navigationController pushViewController:settingVC animated:YES];

  } else if (self.conversationType == ConversationType_DISCUSSION) {

    RCDDiscussGroupSettingViewController *settingVC =
        [[RCDDiscussGroupSettingViewController alloc] init];
    settingVC.conversationType = self.conversationType;
    settingVC.targetId = self.targetId;
    settingVC.conversationTitle = self.userName;
    //设置讨论组标题时，改变当前聊天界面的标题
    settingVC.setDiscussTitleCompletion = ^(NSString *discussTitle) {
      self.title = discussTitle;
    };
    //清除聊天记录之后reload data
    __weak RCDChatViewController *weakSelf = self;
    settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
      if (isSuccess) {
        [weakSelf.conversationDataRepository removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
          [weakSelf.conversationMessageCollectionView reloadData];
        });
      }
    };

    [self.navigationController pushViewController:settingVC animated:YES];
  }

  //聊天室设置
  else if (self.conversationType == ConversationType_CHATROOM) {
    RCDRoomSettingViewController *settingVC =
        [[RCDRoomSettingViewController alloc] init];
    settingVC.conversationType = self.conversationType;
    settingVC.targetId = self.targetId;
    [self.navigationController pushViewController:settingVC animated:YES];
  }

  //群组设置
  else if (self.conversationType == ConversationType_GROUP) {
      UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Chat" bundle:nil];
      RCDGroupDetailViewController *detail=[secondStroyBoard instantiateViewControllerWithIdentifier:@"RCDGroupDetailViewController"];
      NSMutableArray *groups=RCDHTTPTOOL.allGroups ;
      __weak RCDChatViewController *weakSelf = self;
      detail.clearHistoryCompletion = ^(BOOL isSuccess) {
          if (isSuccess) {
              [weakSelf.conversationDataRepository removeAllObjects];
              dispatch_async(dispatch_get_main_queue(), ^{
                  [weakSelf.conversationMessageCollectionView reloadData];
              });
          }
      };
      if (groups) {
          for (RCDGroupInfo *group in groups) {
              if ([group.groupId isEqualToString: self.targetId]) {
                  detail.groupInfo=group;
                  [self.navigationController pushViewController:detail animated:NO];
                  return;
              }
          }
      }
  }
  //客服设置
  else if (self.conversationType == ConversationType_CUSTOMERSERVICE) {
    RCDSettingBaseViewController *settingVC = [[RCDSettingBaseViewController alloc] init];
    settingVC.conversationType = self.conversationType;
    settingVC.targetId = self.targetId;
    //清除聊天记录之后reload data
    __weak RCDChatViewController *weakSelf = self;
    settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
      if (isSuccess) {
        [weakSelf.conversationDataRepository removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
          [weakSelf.conversationMessageCollectionView reloadData];
        });
      }
    };
    [self.navigationController pushViewController:settingVC animated:YES];
  }
}

/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param imageMessageContent 图片消息内容
 */
- (void)presentImagePreviewController:(RCMessageModel *)model;
{
  RCImagePreviewController *_imagePreviewVC =
      [[RCImagePreviewController alloc] init];
  _imagePreviewVC.messageModel = model;
  _imagePreviewVC.title = @"图片预览";

  UINavigationController *nav = [[UINavigationController alloc]
      initWithRootViewController:_imagePreviewVC];

  [self presentViewController:nav animated:YES completion:nil];
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view {
    [super didLongTouchMessageCell:model inView:view];
    NSLog(@"%s", __FUNCTION__);
}


/**
 *  更新左上角未读消息数
 */
- (void)notifyUpdateUnreadMessageCount {
  __weak typeof(&*self) __weakself = self;
  int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
    @(ConversationType_PRIVATE),
    @(ConversationType_DISCUSSION),
    @(ConversationType_APPSERVICE),
    @(ConversationType_PUBLICSERVICE),
    @(ConversationType_GROUP)
  ]];
  dispatch_async(dispatch_get_main_queue(), ^{
      NSString *backString = nil;
    if (count > 0 && count < 1000) {
      backString = [NSString stringWithFormat:@"返回(%d)", count];
    } else if (count >= 1000) {
      backString = @"返回(...)";
    } else {
      backString = @"返回";
    }
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 6, 67, 23);
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigator_btn_back"]];
    backImg.frame = CGRectMake(-10, 0, 22, 22);
    [backBtn addSubview:backImg];
    UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 65, 22)];
    backText.text = backString;//NSLocalizedStringFromTable(@"Back", @"RongCloudKit", nil);
    backText.font = [UIFont systemFontOfSize:15];
    [backText setBackgroundColor:[UIColor clearColor]];
    [backText setTextColor:iconRed];
    [backBtn addSubview:backText];
    [backBtn addTarget:__weakself action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [__weakself.navigationItem setLeftBarButtonItem:leftButton];
  });
}

- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage
{
    //保存图片
    UIImage *image = newImage;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

- (void)setRealTimeLocation:(id<RCRealTimeLocationProxy>)realTimeLocation {
    _realTimeLocation = realTimeLocation;
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    switch (tag) {
            case PLUGIN_BOARD_ITEM_LOCATION_TAG: {
                if (self.realTimeLocation) {
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送位置", @"位置实时共享", nil];
                    [actionSheet showInView:self.view];
                } else {
                    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
                }
                
            } break;
            case 666:
            /**
             *  发送自定义表情图片
             */
            if ([ShareValue shareInstance].isDownloadMOMO||[ShareValue shareInstance].isDownloadQQ) {
                [self showCustomerEmojView];
            }else{
                [MBProgressHUD showError:@"您还没有下载表情哦~" toView:self.view];
            }
            break;
        default:
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            break;
    }
}
#pragma 自定义表情图片的处理
-(void)showCustomerEmojView{
    self.customerEmojs=[NSMutableArray array];
    CGFloat CustomerEmojWidth = self.pluginBoardView.frame.size.height/3-10;
    NSInteger num =(DEVCE_WITH-30)/(CustomerEmojWidth+10);
    self.emojScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(-15,-15, self.pluginBoardView.frame.size.width, self.pluginBoardView.frame.size.height)];
    self.emojScrollView.backgroundColor=[UIColor whiteColor];
    NSLog(@"frame:%f,%f",self.pluginBoardView.frame.size.width, self.pluginBoardView.frame.size.height);
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString * destination =[cachPath stringByAppendingString:@"/Emoj/qq"];
    if ([ShareValue shareInstance].isDownloadQQ) {
        destination =[cachPath stringByAppendingString:@"/Emoj/qq"];
    }
    if ([ShareValue shareInstance].isDownloadMOMO) {
        destination =[cachPath stringByAppendingString:@"/Emoj/mo"];
    }
    NSArray *tempFiles = [[NSFileManager defaultManager] subpathsAtPath:destination];
    for (int i=0; i<tempFiles.count; i++) {
        NSString *p=tempFiles[i];
        if ([p hasSuffix:@"png"]) {
            NSString *path = [destination stringByAppendingPathComponent:p];
            UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10+(5+CustomerEmojWidth)*(i%num), 10+(10+CustomerEmojWidth)*(i/num), CustomerEmojWidth, CustomerEmojWidth)];
            UIImage * image =[UIImage imageWithContentsOfFile:path];
            NSLog(@"p:%@",path);
            imageView.image=image;
            imageView.tag=i;
            imageView.userInteractionEnabled=YES;
            [self.customerEmojs addObject:imageView];
            [self.emojScrollView addSubview:imageView];
            self.emojScrollView.contentSize=CGSizeMake(DEVCE_WITH, (10+CustomerEmojWidth)*(i/num+1));
            //添加手势
            UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendCustomerEmoj:)];
            [imageView addGestureRecognizer:tap];
        }
    }
    [self.pluginBoardView addSubview:self.emojScrollView];
}
-(void)sendCustomerEmoj:(UIGestureRecognizer*)gesture{
    NSString * pushContent =[NSString stringWithFormat:@"%@发来了一个自定义表情",[ShareValue shareInstance].userInfo.nickname];
    UIView * view =gesture.view;
    
    UIImageView * imageView=[self.customerEmojs objectAtIndex:view.tag];

    RCImageMessage * imageMessage=[RCImageMessage messageWithImage:imageView.image];
    [self sendImageMessage:imageMessage pushContent:pushContent];
    self.customerEmojs=nil;
    [self.emojScrollView removeFromSuperview];
    [self.chatSessionInputBarControl.delegate didTouchEmojiButton:nil];
}
- (RealTimeLocationStatusView *)realTimeLocationStatusView {
    if (!_realTimeLocationStatusView) {
        _realTimeLocationStatusView = [[RealTimeLocationStatusView alloc] initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 0)];
        _realTimeLocationStatusView.delegate = self;
        [self.view addSubview:_realTimeLocationStatusView];
    }
    return _realTimeLocationStatusView;
}
#pragma mark - RealTimeLocationStatusViewDelegate
- (void)onJoin {
    [self showRealTimeLocationViewController];
}
- (RCRealTimeLocationStatus)getStatus {
    return [self.realTimeLocation getStatus];
}

- (void)onShowRealTimeLocationView {
    [self showRealTimeLocationViewController];
}

#pragma mark override
/**
 *  重写方法实现自定义消息的显示
 *
 *  @param collectionView collectionView
 *  @param indexPath      indexPath
 *
 *  @return RCMessageTemplateCell
 */
- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView
                             cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    
    if (!self.displayUserNameInCell) {
        if (model.messageDirection == MessageDirection_RECEIVE) {
            model.isDisplayNickname = NO;
        }
    }
    RCMessageContent *messageContent = model.content;
    RCMessageBaseCell *cell = nil;
    if ([messageContent isMemberOfClass:[RCRealTimeLocationStartMessage class]]) {
        RealTimeLocationStartCell *__cell = [collectionView
                                 dequeueReusableCellWithReuseIdentifier:RCRealTimeLocationStartMessageTypeIdentifier
                                 forIndexPath:indexPath];
        [__cell setDataModel:model];
        [__cell setDelegate:self];
        //__cell.locationDelegate=self;
        cell = __cell;
        return cell;
    } else if ([messageContent isMemberOfClass:[RCRealTimeLocationEndMessage class]]) {
        RealTimeLocationEndCell *__cell = [collectionView
                                          dequeueReusableCellWithReuseIdentifier:RCRealTimeLocationEndMessageTypeIdentifier
                                          forIndexPath:indexPath];
        [__cell setDataModel:model];
        cell = __cell;
        return cell;
    } else  {
        return [super rcConversationCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
}

#pragma mark override
- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
    if ([model.content isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
        [self showRealTimeLocationViewController];
    }
}

#pragma mark override
/**
 *  重写方法实现自定义消息的显示的高度
 *
 *  @param collectionView       collectionView
 *  @param collectionViewLayout collectionViewLayout
 *  @param indexPath            indexPath
 *
 *  @return 显示的高度
 */
- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView
                                layout:(UICollectionViewLayout *)collectionViewLayout
                sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    if ([messageContent isMemberOfClass:[RCRealTimeLocationStartMessage class]]) {
        if (model.isDisplayMessageTime) {
            return CGSizeMake(collectionView.frame.size.width, 66);
        }
        return CGSizeMake(collectionView.frame.size.width, 66);
    } else {
        return [super rcConversationCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
}

#pragma mark override
- (void)resendMessage:(RCMessageContent *)messageContent{
    if ([messageContent isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
        [self showRealTimeLocationViewController];
    } else {
        [super resendMessage:messageContent];
    }
}
#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [super pluginBoardView:self.pluginBoardView clickedItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
        }
        break;
        case 1:
        {
            [self showRealTimeLocationViewController];
        }
        break;
    }
}

#pragma mark - RCRealTimeLocationObserver
- (void)onRealTimeLocationStatusChange:(RCRealTimeLocationStatus)status {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

- (void)onReceiveLocation:(CLLocation *)location fromUserId:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

- (void)onParticipantsJoin:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你加入了地理位置共享"];
    } else {
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
            if (userInfo.name.length) {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@加入地理位置共享", userInfo.name]];
            } else {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"user<%@>加入地理位置共享", userId]];
            }
        }];
    }
}

- (void)onParticipantsQuit:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你退出地理位置共享"];
    } else {
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
            if (userInfo.name.length) {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@退出地理位置共享", userInfo.name]];
            } else {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"user<%@>退出地理位置共享", userId]];
            }
        }];
    }
}

- (void)onRealTimeLocationStartFailed:(long)messageId {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < self.conversationDataRepository.count; i++) {
            RCMessageModel *model =
            [self.conversationDataRepository objectAtIndex:i];
            if (model.messageId == messageId) {
                model.sentStatus = SentStatus_FAILED;
            }
        }
        NSArray *visibleItem = [self.conversationMessageCollectionView indexPathsForVisibleItems];
        for (int i = 0; i < visibleItem.count; i++) {
            NSIndexPath *indexPath = visibleItem[i];
            RCMessageModel *model =
            [self.conversationDataRepository objectAtIndex:indexPath.row];
            if (model.messageId == messageId) {
                [self.conversationMessageCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }
   });
}

- (void)notifyParticipantChange:(NSString *)text {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.realTimeLocationStatusView updateText:text];
        [weakSelf performSelector:@selector(updateRealTimeLocationStatus) withObject:nil afterDelay:0.5];
    });
}


- (void)onFailUpdateLocation:(NSString *)description {
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.realTimeLocation quitRealTimeLocation];
        [self popupChatViewController];
    }
}

- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message
{
    return message;
}

/*******************实时地理位置共享***************/
- (void)showRealTimeLocationViewController{
    RealTimeLocationViewController *lsvc = [[RealTimeLocationViewController alloc] init];
    lsvc.realTimeLocationProxy = self.realTimeLocation;
    if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_INCOMING) {
        [self.realTimeLocation joinRealTimeLocation];
    }else if([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_IDLE){
        [self.realTimeLocation startRealTimeLocation];
    }
    [self.navigationController presentViewController:lsvc animated:YES completion:^{
        
    }];
}
- (void)updateRealTimeLocationStatus {
    if (self.realTimeLocation) {
        [self.realTimeLocationStatusView updateRealTimeLocationStatus];
        __weak typeof(&*self) weakSelf = self;
        NSArray *participants = nil;
        switch ([self.realTimeLocation getStatus]) {
                case RC_REAL_TIME_LOCATION_STATUS_OUTGOING:
                [self.realTimeLocationStatusView updateText:@"您正在共享地理位置"];
                break;
                case RC_REAL_TIME_LOCATION_STATUS_CONNECTED:
                case RC_REAL_TIME_LOCATION_STATUS_INCOMING:
                participants = [self.realTimeLocation getParticipants];
                if (participants.count == 1) {
                    NSString *userId = participants[0];
                    [weakSelf.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"user<%@>正在共享地理位置", userId]];
                    [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
                        if (userInfo.name.length) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"%@正在共享地理位置", userInfo.name]];
                            });
                        }
                    }];
                } else {
                    if(participants.count<1)
                       [self.realTimeLocationStatusView removeFromSuperview];
                    else
                        [self.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"%d人正在共享地理位置", (int)participants.count]];
                }
                break;
            default:
                break;
        }
    }
}
/**
 *  点击头像代理
 */
- (void)didTapCellPortrait:(NSString *)userId{
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalHomePageViewController * vc=[sb instantiateViewControllerWithIdentifier:@"homePage"];
    vc.memberId=userId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
