//
//  ChatViewController.m
//  Sheridan United
//

//this class is used to display the chat interface
// it can be used to send text, photo and video messages
//it is updated in real time with Firebase, nothing is stored locally
#import "ChatViewController.h"
#import "JSQMessagesViewController/JSQMessagesViewController.h"
#import "JSQMessageData.h"
#import "JSQMessagesViewController/JSQMessage.h"
#import "JSQMessagesBubbleImageFactory.h"
#import "JSQMessageAvatarImageDataSource.h"
#import "JSQPhotoMediaItem.h"
#import "JSQVideoMediaItem.h"
#import "JSQMessagesAvatarImageFactory.h"
#import <MobileCoreServices/MobileCoreServices.h>
@import  AVKit;
@import AVFoundation;
@import FirebaseDatabase;
@import FirebaseStorage;
@import FirebaseAuth;
@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize messages,avatarDictionary,outgoingBubbleImageData,incomingBubbleImageData,bubbleFactory,ref;
//instantiating incoming and outgoing chat bubbles, current user and the array that will store messages
- (void)viewDidLoad {
    [super viewDidLoad];
    self.avatarDictionary=[NSMutableDictionary dictionary];
    self.bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor: [UIColor lightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor: [UIColor greenColor]];
    FIRUser *currentUser= [[FIRAuth auth]currentUser];
    self.senderId=currentUser.uid;
    self.senderDisplayName = @"Mowgli";
    self.messages = [NSMutableArray new];
    NSLog(@"user id %@", currentUser.photoURL);
    //connection to Firebase DB created, ref is the root which will provide DB access
    self.ref=[[FIRDatabase database] reference ];
    [self observeMessages];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// this method is used to set up the avatar for the user in the chat view
// it is the small round picture right beside the chat bubble
-(void)setupAvatar:(NSString *)url messageId: (NSString*) m
{
    if(url)
    {
        //getting image from a url
        //the url contains the current users profile picture
        // it is then converted to NSData object which can be used
        //to instantiate the image
        //JSQ methods are called to get it to display
        NSURL *fileUrl= [NSURL URLWithString:url];
        NSData *data =[NSData dataWithContentsOfURL:fileUrl];
        UIImage *image=[UIImage imageWithData:data];
        JSQMessagesAvatarImage *userImg=[JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:30];
        [avatarDictionary setValue:userImg forKey:m];
    }
    //in case the current user does not have a profile picture,  generic profile picture is attached to the profile
    else{
        UIImage *img=[UIImage imageNamed:@"profilebackground.png"];
        JSQMessagesAvatarImage *u=[JSQMessagesAvatarImageFactory avatarImageWithImage:img diameter:30];
        [avatarDictionary setValue:u forKey:m];
    }
    [self.collectionView reloadData];
}
// this method retrieves data from Firebase and displays it in the chat
// ---------------------------------IMPORTANT METHOD---------------------------------//
-(void)observeUsers:(NSString*) id
{
    //looks for the child 'users', id represents the messageId
    //each message that goes through firebase has a sender ID and
    //this code finds the data based on that
    
    [[[self.ref child:@"users"] child: id] observeEventType:FIRDataEventTypeValue withBlock:
     ^(FIRDataSnapshot *snapshot)
     {
         NSDictionary *dict = snapshot.value;
         NSString *avatarURL=[dict objectForKey:@"profileUrl"];
         self.senderDisplayName=[dict objectForKey:@"displayName"];
         NSLog(@"dictionary contents %@",avatarURL);
         [self setupAvatar:avatarURL messageId:id];
         
     }];
}
// ---------------------------------IMPORTANT METHOD---------------------------------//
//used to get messages from firebase
-(void)observeMessages
{
    //looks for 'messages child' which has all the messages stored in it
    //the snapshot retrieved from the method below returns a dictionary of all the messages and related data
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
         [self observeUsers : senderId];
         //checking the type of message in the code below
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
             JSQVideoMediaItem *parsedVideo = [[JSQVideoMediaItem alloc] initWithFileURL:[NSURL URLWithString:fileUrl] isReadyToPlay:YES];
             if ([js.senderId isEqualToString:self.senderId]) {
                 //[parsedVideo appliesMediaViewMaskAsOutgoing];
                 [parsedVideo setAppliesMediaViewMaskAsOutgoing:NO];
             }
             
             else
             {
                 [parsedVideo setAppliesMediaViewMaskAsOutgoing:NO];
             }
             
             js = [[JSQMessage alloc] initWithSenderId:self.senderId senderDisplayName:self.senderDisplayName date:[NSDate date] media:parsedVideo];
         }
         
         [self.messages addObject: js];
         [self finishSendingMessageAnimated:YES];
         
         
     }];
}
//when the user presses send, this method gets fired
//it pushed the message to firebase as well as local repo
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
//accessory button provides the interface for sending media
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
//looking at the message to see if its incoming or outgoing and formatting it accordingly
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    
    if (![message.senderId isEqualToString:self.senderId]) {
        return self.incomingBubbleImageData;
        
    }
    return self.outgoingBubbleImageData;
    
}
//method used to set avatar
-(id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message =[self.messages objectAtIndex:indexPath.item];
    return [avatarDictionary objectForKey:message.senderId];
}
//this method is used to feed message data to collection view, i.e., display chat bubbles in the UI

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
//UPLOAD PIC SENT BY USER TO DB
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
//UPLOAD VIDEO SENT BY USER TO DB
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
