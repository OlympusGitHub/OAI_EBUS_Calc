//
//  OAI_StringManager.m
//  EUS Calculator
//
//  Created by Steve Suranie on 1/9/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_StringManager.h"

@implementation OAI_StringManager

@synthesize dictNotes;


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
        
        dictNotes = [[NSMutableDictionary alloc] init];
        
        NSArray* notesBulletList = [[NSArray alloc] initWithObjects:@"The data is based on an Olympus-sponsored study completed by the Medical University of South Carolina (MUSC). The data was compiled during the 2008 - 2009 calendar year.  Revenue generated is based on billing for 200 consecutive EBUS patients during this period of time.", @"The downstream revenue is only applied to EBUS-TBNA procedures. Radial EBUS procedures are not included in the downstream break-even analysis.", @"The MUSC results for total dollar amount of downstream revenue generated per patient  was an average of $9.874.00.", @"Consultative physician fees are not included in the per patient average downstream revenue.",  @"The MUSC study concluded that $9,874 upstream & downstream revenue was generated per patient.  The calculations on the \"Input\" tab only account for 1/3 of this total ($2,962).  This is intended to account for the cost of care, assuming a 30% overall net operating cost profit margin. Please note the $9,874 cost per patient comes from dividing the technical charges of $1,974,911 by the N of 200 = $9,874.56.", @"The MUSC study indicated the following hospital departments contributed to the downstream revenue as a direct result of the EBUS procedure.", nil];
        
        NSMutableArray* notesTable = [[NSMutableArray alloc] init];
        
        [notesTable addObject:[[NSArray alloc] initWithObjects:@"Department earning revenue:", @"Percent of EBUS patient population that visited the department", nil]];
        [notesTable addObject:[[NSArray alloc] initWithObjects:@"Radiology*", @"48.0%", nil]];
        [notesTable addObject:[[NSArray alloc] initWithObjects:@"Chemotherapy**", @"15.5%", nil]];
        [notesTable addObject:[[NSArray alloc] initWithObjects:@"Hospital/Administration", @"20.5%", nil]];
        [notesTable addObject:[[NSArray alloc] initWithObjects:@"Surgery", @"9.0%", nil]];
        [notesTable addObject:[[NSArray alloc] initWithObjects:@"Radiation Therapy", @"13.0%", nil]];
        [notesTable addObject:[[NSArray alloc] initWithObjects:@"Other Procedures", @"36.0%", nil]];
        
        NSArray* notesFooters = [[NSArray alloc] initWithObjects:@"* Includes CT, MRI Brain, Bone scan, X-ray, etc.", @"** When applicable, revenue includes more than one visit", @"*** Includes CT guided biopsy, EUS, PFT's, Second bronchoscopy, etc.", nil];
        
        [dictNotes setObject:notesBulletList forKey:@"Notes Bullet List"];
        [dictNotes setObject:notesTable forKey:@"Notes Table"];
        [dictNotes setObject:notesFooters forKey:@"Notes Footers"];
        
    }
    
    return self;
    
}




@end
