//
//  ChatViewController.m
//  Sheridan United
//
//  Created by Xcode User on 2017-03-31.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import "ChatViewController.h"
#import "JSQMessagesViewController/JSQMessagesViewController.h"
#import "JSQMessageData.h"
#import "JSQMessagesViewController/JSQMessage.h"
#import "JSQMessagesBubbleImageFactory.h"
#import "JSQMessageAvatarImageDataSource.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize messages,outgoingBubbleImageData,incomingBubbleImageData,bubbleFactory;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor: [UIColor colorWithRed:163 green:73 blue:164 alpha:1]      ];

   // self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[myColor];
    self.senderId=@"1";
    self.senderDisplayName = @"Mowgli";
    self.messages = [NSMutableArray new];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
  //creating a message object that contains info of one message
    JSQMessage *js=[[JSQMessage alloc] initWithSenderId:senderId
                                      senderDisplayName:senderDisplayName
                                                   date:date
                                                   text:text ];
    // adding the message object to the array
    [self.messages addObject:js];
    //refresh the collectionView to tell it that message has been sent
    [self.collectionView reloadData];
    NSLog(@"%@",messages);
    
}

-(void)didPressAccessoryButton:(UIButton *)sender
{
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //[super collectionView];
    NSLog(@"Msg count: %lu",messages.count);
    
    return messages.count;
    
}
-(id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //messages are retrived from the array which will be parsed to display
    return messages[indexPath.item];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell  *cell= (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath] ;
    return cell;
}
/*-(id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesBubbleImageFactory *bubble = [[JSQMessagesBubbleImageFactory alloc] init];
    
    return [bubble outgoingMessagesBubbleImageWithColor: myColor];
}*/
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    return self.outgoingBubbleImageData;
      //  JSQMessage *message = [messages objectAtIndex:indexPath.item];
  //return  [bubbleFactory outgoingMessagesBubbleImageWithColor:myColor];
    //bubbleFactory outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor: myColor];
}
//this method is used to feed message data to collection view, i.e., display chat bubbles in the UI
-(id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return nil;
}
@end
