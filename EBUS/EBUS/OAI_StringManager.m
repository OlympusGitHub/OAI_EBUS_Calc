//
//  OAI_StringManager.m
//  EUS Calculator
//
//  Created by Steve Suranie on 1/9/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_StringManager.h"

@implementation OAI_StringManager

@synthesize notesArray;


+(OAI_StringManager *)sharedStringManager {
    
    static OAI_StringManager* sharedStringManager;
    
    @synchronized(self) {
        
        if (!sharedStringManager)
            
            sharedStringManager = [[OAI_StringManager alloc] init];
        
        return sharedStringManager;
        
    }
    
}

-(id)init {
    
    if (self = [super init]) {
        
    }
    
    return self;
    
}




@end
