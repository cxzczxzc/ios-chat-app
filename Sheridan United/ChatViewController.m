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
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor: [UIColor lightGrayColor]];

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
    //[self.collectionView reloadData];
    [self finishSendingMessageAnimated:YES];

    NSLog(@"%@",messages);
    
}

-(void)didPressAccessoryButton:(UIButton *)sender
{
    // opening the interface for selecting the image
    printf("Accessory button pressed");
    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [super collectionView];
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
    //creating one cell at a time which will be a container for the message
    JSQMessagesCollectionViewCell  *cell= (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath] ;
    return cell;
}
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    return self.outgoingBubbleImageData;

}
//this method is used to feed message data to collection view, i.e., display chat bubbles in the UI
-(id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return nil;
}
- (void)finishSendingMessageAnimated:(BOOL)animated {
    
    UITextView *textView = self.inputToolbar.contentView.textView;
    textView.text = nil;
    [textView.undoManager removeAllActions];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:textView];
    [self.collectionView reloadData];
    
    if (self.automaticallyScrollsToMostRecentMessage) {
        [self scrollToBottomAnimated:animated];
    }
}
@end
