//
//  OAI_StringManager.h
//  EUS Calculator
//
//  Created by Steve Suranie on 1/9/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAI_StringManager : NSObject {
    
}


@property (nonatomic, retain) NSMutableDictionary* dictNotes;

+(OAI_StringManager* )sharedStringManager;



@end
