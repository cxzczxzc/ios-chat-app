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
#import "JSQPhotoMediaItem.h"
#import "JSQVideoMediaItem.h"
#import <MobileCoreServices/MobileCoreServices.h>
@import  AVKit;
@import AVFoundation;
@import FirebaseDatabase;
@import FirebaseStorage;
@import FirebaseAuth;
@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize messages,outgoingBubbleImageData,incomingBubbleImageData,bubbleFactory,ref;
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor: [UIColor lightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor: [UIColor greenColor]];
    FIRUser *currentUser= [[FIRAuth auth]currentUser];
    self.senderId=currentUser.uid;
    self.senderDisplayName = @"Mowgli";
    self.messages = [NSMutableArray new];
    NSLog(@"user id %@", currentUser.uid);
    //connection to Firebase DB created, ref is the root which will provide DB access
    self.ref=[[FIRDatabase database] reference ];
    [self observeMessages];
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
-(void)observeMessages
{
    [[self.ref child:@"messages" ] observeEventType:FIRDataEventTypeChildAdded withBlock:
          ^(FIRDataSnapshot *snapshot)
         {
             NSDictionary *dict = snapshot.value;
             NSString *media= [dict objectForKey:@"mediaType"];
             NSString *senderId = [dict objectForKey:@"senderID"];
             NSString *senderName = [dict objectForKey:@"senderDisplayName"];
             NSString *text = [dict objectForKey:@"text"];
             NSURL *fileUrl =[dict objectForKey:@"fileUrl"];
             JSQMessage *js ;
             if([media isEqualToString:@"TEXT"] )
             {
             js=[[JSQMessage alloc] initWithSenderId:senderId
                                               senderDisplayName:senderName
                                                            date:[NSDate date]
                                                           text:text ];
             
                
            }
             else if([media isEqualToString:@"Photo"])
             {
                 NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString*)fileUrl]];
                 UIImage *pic=[UIImage imageWithData:data];
                 JSQPhotoMediaItem *parsedImage = [[JSQPhotoMediaItem alloc] initWithImage:pic];
                 js=[[JSQMessage alloc] initWithSenderId:self.senderId
                                             senderDisplayName:self.senderDisplayName
                                                          date:[NSDate date]
                                                         media:parsedImage] ;
             }
             else
             {
                 JSQVideoMediaItem *parsedVideo = [[JSQVideoMediaItem alloc] initWithFileURL:fileUrl isReadyToPlay:YES];
                 js = [[JSQMessage alloc] initWithSenderId:self.senderId senderDisplayName:self.senderDisplayName date:[NSDate date] media:parsedVideo];
                 
                 
                 
             }
             

              [self.messages addObject: js];
             [self finishSendingMessageAnimated:YES];


         }];
     
    
//
    

}
-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    FIRDatabaseReference *newMessage=  [[self.ref child:@"messages"] childByAutoId];
    NSMutableDictionary *messageData = [[NSMutableDictionary alloc] init];
    [messageData setValue:text forKey:@"text"];
    [messageData setValue:senderId forKey:@"senderID"];
    [messageData setValue:senderDisplayName forKey:@"senderDisplayName"];
    [messageData setValue:@"TEXT" forKey:@"mediaType"];
    [newMessage setValue:messageData];
}

-(void)didPressAccessoryButton:(UIButton *)sender
{
    printf("Accessory button pressed");
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Media Message" message:@"Please select a media" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    UIAlertAction *pickPhoto = [UIAlertAction
                             actionWithTitle:@"Photo Library"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action)
                             {
                                 [self getMediaFrom:[[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage,nil]];
                             }];
    UIAlertAction *pickVideo = [UIAlertAction
                             actionWithTitle:@"Video Library"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action)
                             {
                                 [self getMediaFrom:[[NSArray alloc] initWithObjects: (NSString *)kUTTypeMovie,nil]];
                             }];
    
    [sheet addAction:cancel];
    [sheet addAction:pickPhoto];
    [sheet addAction:pickVideo];
   [self presentViewController:sheet animated:YES completion:nil];
}
-(void) getMediaFrom : (NSArray *)type
{
    
    UIImagePickerController *mediaPicker =[[UIImagePickerController alloc] init];
    mediaPicker.delegate=self;
    mediaPicker.mediaTypes= type;
    [self presentViewController:mediaPicker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if([info[UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)(kUTTypeImage)])
    {
        //if media type is image
        UIImage *chosenImage = (UIImage *)info[UIImagePickerControllerOriginalImage];
        [self sendImageToDatabase:chosenImage];
        //image
    }
    else
    {
        // if media type is video
        NSURL *chosenVideo = (NSURL *)info[UIImagePickerControllerMediaURL ];
        [self sendVideoToDatabase:chosenVideo];
        //video
    }
    
    
    [self finishSendingMessageAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
//method to play video in chat
-(void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    [super collectionView: collectionView didTapMessageBubbleAtIndexPath:indexPath];
    JSQMessage *message =self.messages[indexPath.item];
    JSQVideoMediaItem *mediaItem= (JSQVideoMediaItem *)message.media;
    if(message.isMediaMessage)
    {
        if(mediaItem!=nil){
            AVPlayer *player =[AVPlayer playerWithURL: mediaItem.fileURL];
            AVPlayerViewController *playerVC= [[AVPlayerViewController alloc] init];
            playerVC.player=player;
            [self presentViewController:playerVC animated:YES completion:nil];
        }
    }
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
    return self.incomingBubbleImageData;

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
-(void)sendImageToDatabase:(UIImage*)pic
{
    FIRStorageReference *storage = [[FIRStorage storage]referenceForURL:@"gs://sheridan-united.appspot.com/"];
     NSTimeInterval interval = [[[NSDate alloc]init ]timeIntervalSinceReferenceDate];
    NSString *username=(NSString *)[[FIRAuth auth] currentUser];
    NSString *filepath= [NSString stringWithFormat: @"%@/%f", username,interval];
    FIRStorageReference *child=[storage child: filepath];
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc]init] ;
    metadata.contentType=@"image/jpg";
    NSData *imageData = UIImageJPEGRepresentation(pic, 0.8);
    [child putData:imageData metadata:metadata completion:^(FIRStorageMetadata *metadata, NSError *error)
     {
         if (!error)
         {
             NSString *fileUrl=metadata.downloadURLs[0].absoluteString;
             NSLog(@"gadarrrr %@", metadata.downloadURLs[0].absoluteString);
             NSMutableDictionary *messageData = [[NSMutableDictionary alloc] init];
             [messageData setValue:fileUrl forKey:@"fileUrl"];
             [messageData setValue:self.senderId forKey:@"senderID"];
             [messageData setValue:self.senderDisplayName forKey:@"senderDisplayName"];
             [messageData setValue:@"Photo" forKey:@"mediaType"];
             //[messageData setValue:fileUrl forKey:@"text"];
             FIRDatabaseReference *newMessage =  [[self.ref child:@"messages"] childByAutoId];
             [newMessage setValue:messageData];
             //profileImageURL = metadata.downloadURL.absoluteString;
             //[self saveValuesForUser: currentUser];
         }
         else if (error)
         {
             NSLog(@"Failed to save image message %@",error.description);
         }
     }];


}
-(void)sendVideoToDatabase:(NSURL*)vdo
{
    FIRStorageReference *storage = [[FIRStorage storage]referenceForURL:@"gs://sheridan-united.appspot.com/"];
    NSTimeInterval interval = [[[NSDate alloc]init ]timeIntervalSinceReferenceDate];
    NSString *username=(NSString *)[[FIRAuth auth] currentUser];
    NSString *filepath= [NSString stringWithFormat: @"%@/%f", username,interval];
    FIRStorageReference *child=[storage child: filepath];
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc]init] ;
    metadata.contentType=@"video/mp4";
    NSData *videoData = [NSData dataWithContentsOfURL:vdo];
    [child putData:videoData metadata:metadata completion:^(FIRStorageMetadata *metadata, NSError *error)
     {
         if (!error)
         {
             NSString *fileUrl=metadata.downloadURLs[0].absoluteString;
             NSLog(@"gadarrrr %@", metadata.downloadURLs[0].absoluteString);
             NSMutableDictionary *messageData = [[NSMutableDictionary alloc] init];
             [messageData setValue:fileUrl forKey:@"fileUrl"];
             [messageData setValue:self.senderId forKey:@"senderID"];
             [messageData setValue:self.senderDisplayName forKey:@"senderDisplayName"];
             [messageData setValue:@"Video" forKey:@"mediaType"];
             FIRDatabaseReference *newMessage =  [[self.ref child:@"messages"] childByAutoId];
             [newMessage setValue:messageData];
         }
         else if (error)
         {
             NSLog(@"Failed to save video message %@", error.description);
         }
     }];
  
}
@end
