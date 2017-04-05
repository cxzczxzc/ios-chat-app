//
//  ChatViewController.h
//  Sheridan United
//
//  Created by Xcode User on 2017-03-31.
//  Copyright © 2017 Sheridan College. All rights reserved.
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
    JSQMessagesBubbleImage *outgoingBubbleImageData;
    JSQMessagesBubbleImage *incomingBubbleImageData;
    JSQMessagesBubbleImageFactory *bubbleFactory ;
    FIRDatabaseReference *ref;
}
@property(strong,nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImageFactory *bubbleFactory;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end
