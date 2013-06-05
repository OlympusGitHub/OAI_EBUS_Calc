//
//  ViewController.h
//  EBUS
//
//  Created by Steve Suranie on 12/28/12.
//  Copyright (c) 2012 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_SplashScreen.h"
#import "OAI_AlertScreen.h"
#import "OAI_ColorManager.h"
#import "OAI_FileManager.h"
#import "OAI_Label.h"
#import "OAI_TextField.h"
#import "OAI_MailManager.h"
#import "OAI_PDFManager.h"
#import "OAI_Account.h"

@interface ViewController : UIViewController <UIWebViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate>{
    
    BOOL needsSplash;
    
    OAI_ColorManager* colorManager;
    OAI_FileManager* fileManager;
    OAI_MailManager* mailManager;
    OAI_SplashScreen* appSplashScreen;
    OAI_AlertScreen* alertManager;
    OAI_PDFManager* pdfManager;
    OAI_Account* accountManager;
    
    NSString* coverLetter;
    
    UIView* objectWrapper;
    UIView* vSummaryScreen;
    UIView* vCalculatorScreen;
    
    float summaryWebViewHeight;
    float calculatorHeight;
    
    UIButton* btnSwitchToCalc;
    UIImage* btnSummaryImg;
    UIImage* btnCalculatorImg;
    
    OAI_TextField* txtDownstreamRev;
    OAI_TextField* txtNetProfit;
    OAI_TextField* txtEBUSQuote;
    OAI_Label* lblProcedureResult;
    OAI_Label* lblWeekResult;
    
    UIWebView* webNotes;
    CGRect webNotesFrame;
    UIView* webNotesSheet;
    
    UIView* vMailOptions;
    UISegmentedControl* scPDFOptions;
    UISegmentedControl* scCoverLetterOptions;
    UITextView* txtEmailMessage;
    UITextField* txtName;
    UITextField* txtFacility;
    BOOL hasCoverLetter;
    BOOL isPDF;
    NSString* userMessage;
    NSString* userName;
    NSString* clientFacility;
    
    NSString* pdfTitle;
    
    NSDecimalNumberHandler* myDecimalHandler;
    
    BOOL isEmailValid;
    
    NSString* strPreviousText; 
    
    
}

- (void) showView : (UIButton* ) buttonTouched;

- (void) toggleViews : (UIView*) viewToShow : (UIView*) viewToHide;

- (void) toggleAccount : (UIButton*) btnAccount;

- (void) clearDeck;

- (void) animateView : (UIView* ) thisView : (CGRect) thisFrame;

- (void) showInfo : (UIButton*) infoButton;

- (void) calculateResults : (NSString* ) strCalcWhat;

- (void) showNotes : (UIGestureRecognizer*) theTap;

- (void) closeNotes : (UIButton*) btnClose;

- (void) showEmailOptions : (UIButton*) btnEmail;

- (void) saveEmailOptions : (UIButton*) btnSubmit;

- (void) closeEmailOptions;

- (NSDecimalNumber*) convertToNSDecimalNumber : (NSArray*) itemsToMultiply;

- (NSString*) convertToCurrencyString : (NSDecimalNumber*) numberToConvert;

- (NSString*) stripDollarSign : (NSString*) stringToStrip;


@end
