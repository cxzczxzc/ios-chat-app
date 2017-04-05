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
#define myColor [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
@interface ChatViewController : JSQMessagesViewController
{
    NSMutableArray *messages;
    JSQMessagesBubbleImage *outgoingBubbleImageData;
    JSQMessagesBubbleImage *incomingBubbleImageData;
    JSQMessagesBubbleImageFactory *bubbleFactory ;
}
@property(strong,nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImageFactory *bubbleFactory;
@end
