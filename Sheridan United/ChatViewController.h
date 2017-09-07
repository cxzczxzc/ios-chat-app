//
//  ChatViewController.h
//  Sheridan United
//

#import <UIKit/UIKit.h>
#import "JSQMessagesViewController/JSQMessagesViewController.h"
#import "JSQMessagesViewController/JSQMessage.h"
#import "JSQMessagesBubbleImage.h"
#import "JSQMessagesBubbleImageFactory.h"
#import <MobileCoreServices/MobileCoreServices.h>
@import FirebaseDatabase;
@interface ChatViewController : JSQMessagesViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSMutableArray *messages;
    NSMutableDictionary *avatarDictionary;
    JSQMessagesBubbleImage *outgoingBubbleImageData;
    JSQMessagesBubbleImage *incomingBubbleImageData;
    JSQMessagesBubbleImageFactory *bubbleFactory ;
    FIRDatabaseReference *ref;
}
@property(strong,nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImageFactory *bubbleFactory;
@property (retain, nonatomic) FIRDatabaseReference *ref;
@property (retain, nonatomic) NSMutableDictionary *avatarDictionary;
@end
