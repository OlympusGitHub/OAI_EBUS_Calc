//
//  OAI_MailManager.m
//  IntegrationSiteReport
//
//  Created by Steve Suranie on 12/10/12.
//  Copyright (c) 2012 Olympus. All rights reserved.
//

#import "OAI_MailManager.h"

@implementation OAI_MailManager

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)displayComposerSheet {
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Hello from Site Integration Report App!"];
    
    // Set up the recipients.
    NSArray *toRecipients = [NSArray arrayWithObjects:@"steve.suranie@olympus.com",
                             nil];
    
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"steve.suranie@olympus.com",
                             nil];
    
    [picker setToRecipients:toRecipients];
    [picker setCcRecipients:ccRecipients];
    
    // Fill out the email body text.
    NSString *emailBody = @"It is raining in sunny California!";
    [picker setMessageBody:emailBody isHTML:NO];
    
    // Present the mail composition interface.
    //[self presentModalViewController:picker animated:YES];
    
}
    
    
    

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
