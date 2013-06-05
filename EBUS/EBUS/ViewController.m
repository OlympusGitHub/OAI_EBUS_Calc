//
//  ViewController.m
//  EBUS
//
//  Created by Steve Suranie on 12/28/12.
//  Copyright (c) 2012 Olympus. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*************************************
     INIT MANAGERS
     *************************************/
    colorManager = [[OAI_ColorManager alloc] init];
    mailManager = [[OAI_MailManager alloc] init];
    pdfManager = [[OAI_PDFManager alloc] init];
    accountManager = [[OAI_Account alloc] init];
    fileManager = [[OAI_FileManager alloc] init];
    
    //set up a decimal number handler
    myDecimalHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                      scale:2
           raiseOnExactness:NO
            raiseOnOverflow:NO
           raiseOnUnderflow:NO
        raiseOnDivideByZero:NO
    ];
    
    coverLetter = @"<div><p>Thank you for your time and interest in Olympus' products and solutions. At Olympus, we appreciate the opportunity to partner with our customers to provide the most advanced and efficient care to your patients.  We look forward to doing business with you. Below are the results of the EBUS Downstream Revenue Calculator.</p></div>";
    
    //notification center init
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"theMessenger"object:nil];
    
    /*************************************
     TOP BAR
     *************************************/
    
    UIView* topBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 40.0)];
    topBar.backgroundColor = [UIColor blackColor];
    
    //shadow
    topBar.layer.masksToBounds = NO;
    topBar.layer.shadowOffset = CGSizeMake(0, 5);
    topBar.layer.shadowRadius = 5;
    topBar.layer.shadowOpacity = 0.75;
    
    //set olympus logo
    UIImageView* OALogoTopBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OA_logo_black_topbar.png"]];
    
    //position the logo
    CGRect topBarLogoFrame = OALogoTopBar.frame;
    topBarLogoFrame.origin.x = 15.0;
    topBarLogoFrame.origin.y = 8.0;
    OALogoTopBar.frame = topBarLogoFrame;
    
    //add the logo
    [topBar addSubview:OALogoTopBar];
    
    //add the toggle account data button
    UIImage* imgAccount = [UIImage imageNamed:@"btnAccount.png"];
    UIButton* btnAccount = [[UIButton alloc] initWithFrame:CGRectMake(OALogoTopBar.frame.origin.x+OALogoTopBar.frame.size.width + 20.0, 4.0, imgAccount.size.width, imgAccount.size.height)];
    [btnAccount setImage:imgAccount forState:UIControlStateNormal];
    [btnAccount addTarget:self action:@selector(toggleAccount:) forControlEvents:UIControlEventTouchUpInside];
    [btnAccount setBackgroundColor:[UIColor clearColor]];
    [topBar addSubview:btnAccount];
        
    //set the app title
    CGSize titleSize = [@"EBUS Break Even Calculator" sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0]];
    UILabel* appTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - titleSize.width)-20.0, 5.0, titleSize.width+10.0, titleSize.height)];
    appTitle.text = @"EBUS Break Even Calculator";
    appTitle.textColor = [UIColor whiteColor];
    appTitle.backgroundColor = [UIColor clearColor];
    appTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size: 18.0];
    [topBar addSubview:appTitle];
    
    [self.view addSubview:topBar];
    
    /************************************
     WRAPPER
     ************************************/
    
    //set up a wrapper to hold our basic items
    objectWrapper = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-topBar.frame.size.height)];
    
    
    /*************************************
     TITLE IMAGE
     *************************************/
    
    NSString* strTitle = @"EBUS Break Even Calculator";
    titleSize = [strTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];
    UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-(titleSize.width/2), 170.0, titleSize.width, titleSize.height)];
    lblTitle.text = strTitle;
    lblTitle.textColor = [colorManager setColor:8.0 :16.0 :123.0];
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    lblTitle.backgroundColor = [UIColor clearColor];
    [objectWrapper addSubview:lblTitle];
    
    UIImage* imgTitle = [UIImage imageNamed:@"OAI_endoscopeinlung.png"];
    UIImageView* imgTitleView = [[UIImageView alloc] initWithImage:imgTitle];
    //reposition
    CGRect imgTitleFrame = imgTitleView.frame;
    imgTitleFrame.origin.x = (self.view.frame.size.width/2)-(imgTitle.size.width/2);
    imgTitleFrame.origin.y = 200.0;
    imgTitleView.frame = imgTitleFrame;
    [objectWrapper addSubview:imgTitleView];
	
    /*************************************
     NAV BUTTONS
     *************************************/
    
    btnSummaryImg = [UIImage imageNamed:@"btnSummary.png"];
    
    UIButton* btnSummary = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSummary setImage:btnSummaryImg forState:UIControlStateNormal];
    [btnSummary addTarget:self action:@selector(showView:) forControlEvents:UIControlEventTouchUpInside];
    //reset the button frame
    CGRect btnSummaryFrame = btnSummary.frame;
    btnSummaryFrame.origin.x = (self.view.frame.size.width/2)-(btnSummaryImg.size.width+5.0);
    btnSummaryFrame.origin.y = (imgTitleView.frame.origin.y + imgTitleView.frame.size.height) + 20.0;
    btnSummaryFrame.size.width = btnSummaryImg.size.width;
    btnSummaryFrame.size.height = btnSummaryImg.size.height;
    btnSummary.frame = btnSummaryFrame;
    btnSummary.tag = 10;
    
    btnCalculatorImg = [UIImage imageNamed:@"btnCalculator.png"];
    
    UIButton* btnCalculator = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCalculator setImage:btnCalculatorImg forState:UIControlStateNormal];
    [btnCalculator addTarget:self action:@selector(showView:) forControlEvents:UIControlEventTouchUpInside];
    //reset the button frame
    CGRect btnCalculatorFrame = btnCalculator.frame;
    btnCalculatorFrame.origin.x = (self.view.frame.size.width/2)+5.0;
    btnCalculatorFrame.origin.y = (imgTitleView.frame.origin.y + imgTitleView.frame.size.height) + 20.0;
    btnCalculatorFrame.size.width = btnCalculatorImg.size.width;
    btnCalculatorFrame.size.height = btnCalculatorImg.size.height;
    btnCalculator.frame = btnCalculatorFrame;
    btnCalculator.tag = 11;
    
    
    [objectWrapper addSubview:btnSummary];
    [objectWrapper addSubview:btnCalculator];
    objectWrapper.tag = 101;
    
    [self.view addSubview:objectWrapper];
    
    /*************************************
     SUMAMRY SCREEN
     *************************************/
    
    vSummaryScreen = [[UIView alloc] initWithFrame:CGRectMake(0.0-self.view.frame.size.width, topBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - topBar.frame.size.height)];
    vSummaryScreen.tag = 102;
    
    NSString* summaryTitle = @"EBUS Break Even Calculator Summary";
    CGSize summaryTitleSize = [summaryTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];
    
    OAI_Label* lblSummaryTitle = [[OAI_Label alloc] initWithFrame:CGRectMake((vSummaryScreen.frame.size.width/2)-(summaryTitleSize.width/2), 30.0, summaryTitleSize.width, summaryTitleSize.height)];
    lblSummaryTitle.text = summaryTitle;
    lblSummaryTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    [vSummaryScreen addSubview:lblSummaryTitle];
    
    UIWebView* webSummary = [[UIWebView alloc] initWithFrame:CGRectMake(20.0, 70.0, self.view.frame.size.width-40.0, 600.0)];
    webSummary.delegate = self;
    webSummary.tag = 420;
    [webSummary loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"summary" ofType:@"html"]isDirectory:NO]]];
    [vSummaryScreen addSubview:webSummary];
    
    //add button to take us to the calculator
    btnSwitchToCalc = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSwitchToCalc setImage:btnCalculatorImg forState:UIControlStateNormal];
    [btnSwitchToCalc addTarget:self action:@selector(showView:) forControlEvents:UIControlEventTouchUpInside];
    //reset the button frame
    CGRect btnSwitchFrame = btnSwitchToCalc.frame;
    btnSwitchFrame.origin.x = (self.view.frame.size.width/2)-(btnCalculatorImg.size.width/2);
    btnSwitchFrame.origin.y = 780.0;
    btnSwitchFrame.size.width = btnCalculatorImg.size.width;
    btnSwitchFrame.size.height = btnCalculatorImg.size.height;
    btnSwitchToCalc.frame = btnSwitchFrame;
    btnSwitchToCalc.tag = 11;
    [vSummaryScreen addSubview:btnSwitchToCalc];
    
    [self.view addSubview:vSummaryScreen];
    
    /*************************************
     CALCULATOR SCREEN
     *************************************/
    
    vCalculatorScreen = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, topBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - topBar.frame.size.height)];
    vCalculatorScreen.tag = 103;
    
    NSString* calculatorTitle = @"EBUS Break Even Calculator";
    CGSize calculatorTitleSize = [calculatorTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];
    
    OAI_Label* lblCalculatorTitle = [[OAI_Label alloc] initWithFrame:CGRectMake((vCalculatorScreen.frame.size.width/2)-(calculatorTitleSize.width/2), 30.0, calculatorTitleSize.width, calculatorTitleSize.height)];
    lblCalculatorTitle.text = calculatorTitle;
    lblCalculatorTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    
    [vCalculatorScreen addSubview:lblCalculatorTitle];
    
    //instructions
    NSString* strCalculatorInstructions = @"To begin, enter the required information in the yellow input section below. The placeholder values are conservative assumptions calculated by Olympus based on the results of the Medical University of South Carolina (MUSC) EBUS downstream revenue study. If you have detailed information as it relates to your particular facility, simply delete the assumed value and replace with your specific data. Your facility-specific, break-even results are then calculated and displayed in the blue section. The \"notes, assumptions & references\" section summarizes the downstream revenue calculation details.";
    CGSize strCalculatorInstructionsSize = [calculatorTitle sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
    
    OAI_Label* lblCalculatorInstructions = [[OAI_Label alloc] initWithFrame:CGRectMake(20.0, 60.0, vCalculatorScreen.frame.size.width-40.0, strCalculatorInstructionsSize.height *10)];
    lblCalculatorInstructions.text = strCalculatorInstructions;
    lblCalculatorInstructions.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblCalculatorInstructions.font = [UIFont fontWithName:@"Helvetica" size: 18.0];
    lblCalculatorInstructions.numberOfLines = 0;
    lblCalculatorInstructions.lineBreakMode = NSLineBreakByWordWrapping;
    [vCalculatorScreen addSubview:lblCalculatorInstructions];
    
    /**********************************
     INPUT SECTION
     **********************************/
    //label
    OAI_Label* lblInputSection = [[OAI_Label alloc] initWithFrame:CGRectMake(20.0, lblCalculatorInstructions.frame.origin.y + lblCalculatorInstructions.frame.size.height, vCalculatorScreen.frame.size.width, 30.0)];
    lblInputSection.text = @"Input:";
    lblInputSection.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblInputSection.font = [UIFont fontWithName:@"Helvetica-Bold" size: 18.0];
    [vCalculatorScreen addSubview:lblInputSection];
    
    //wrapper
    UIView* vCalcInputs = [[UIView alloc] initWithFrame:CGRectMake(20.0, lblInputSection.frame.origin.y + lblInputSection.frame.size.height, vCalculatorScreen.frame.size.width-40, 200.0)];
    vCalcInputs.backgroundColor = [colorManager setColor:252.0 :252.0 :212.0];
    vCalcInputs.layer.borderWidth = 1.0;
    vCalcInputs.layer.borderColor = [colorManager setColor:209 :199 :42].CGColor;
    
    //quote
    NSString* strEBUSQuote = @"Total Cost of EBUS Equipment from Quote:";
    CGSize EBUSQuoteSize = [strEBUSQuote sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
    
    OAI_Label* lblEBUSQuote = [[OAI_Label alloc] initWithFrame:CGRectMake(10.0, 10.0, EBUSQuoteSize.width, 30.0)];
    lblEBUSQuote.text = strEBUSQuote;
    lblEBUSQuote.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblEBUSQuote.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    
    txtEBUSQuote = [[OAI_TextField alloc] initWithFrame:CGRectMake(vCalcInputs.frame.size.width - 250, 10.0, 200.0, 30.0)];
    txtEBUSQuote.delegate = self;
    txtEBUSQuote.textAlignment = NSTextAlignmentRight;
    txtEBUSQuote.tag = 300;
    
    UIButton* btnEBUSHelp = [UIButton buttonWithType:UIButtonTypeInfoDark];
    //reset the frame
    CGRect ebusBtnFrame = btnEBUSHelp.frame;
    ebusBtnFrame.origin.x = txtEBUSQuote.frame.origin.x + txtEBUSQuote.frame.size.width + 10.0;
    ebusBtnFrame.origin.y = txtEBUSQuote.frame.origin.y;
    ebusBtnFrame.size.width = 30.0;
    ebusBtnFrame.size.height = 30.0;
    btnEBUSHelp.frame = ebusBtnFrame;
    //action
    [btnEBUSHelp addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    btnEBUSHelp.tag = 501;
    
    [vCalcInputs addSubview:lblEBUSQuote];
    [vCalcInputs addSubview:txtEBUSQuote];
    [vCalcInputs addSubview:btnEBUSHelp];
    
    //downstream revenue
    NSString* strDownstreamRev = @"Amount of Downstream Revenue Generated per Patient:";
    CGSize downstreamRevSize = [strDownstreamRev sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
    
    OAI_Label* lblDownstreamRev = [[OAI_Label alloc] initWithFrame:CGRectMake(10.0, 60.0, downstreamRevSize.width, 30.0)];
    lblDownstreamRev.text = strDownstreamRev;
    lblDownstreamRev.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblDownstreamRev.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    
    txtDownstreamRev = [[OAI_TextField alloc] initWithFrame:CGRectMake(vCalcInputs.frame.size.width - 250, 60.0, 200.0, 30.0)];
    txtDownstreamRev.textAlignment = NSTextAlignmentRight;
    txtDownstreamRev.delegate = self;
    txtDownstreamRev.tag = 301;
    
    UIButton* btnRevenueHelp = [UIButton buttonWithType:UIButtonTypeInfoDark];
    //reset the frame
    CGRect revenueBtnFrame = btnRevenueHelp.frame;
    revenueBtnFrame.origin.x = txtDownstreamRev.frame.origin.x + txtDownstreamRev.frame.size.width + 10.0;
    revenueBtnFrame.origin.y = txtDownstreamRev.frame.origin.y;
    revenueBtnFrame.size.width = 30.0;
    revenueBtnFrame.size.height = 30.0;
    btnRevenueHelp.frame = revenueBtnFrame;
    //action
    [btnRevenueHelp addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    btnRevenueHelp.tag = 502;
    
    [vCalcInputs addSubview:btnRevenueHelp];
    [vCalcInputs addSubview:lblDownstreamRev];
    [vCalcInputs addSubview:txtDownstreamRev];
    
    //net profit
    NSString* strNetProfit = @"Percent of Net Profit Margin Generated from Downstream Procedures:";
    CGSize netProfitSize = [strNetProfit sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
    
    OAI_Label* lblNetProfit = [[OAI_Label alloc] initWithFrame:CGRectMake(10.0, 100.0, netProfitSize.width-150.0, 60.0)];
    lblNetProfit.text = strNetProfit;
    lblNetProfit.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblNetProfit.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    lblNetProfit.text = @"Percent of Net Profit Margin Generated from Downstream Procedures:";
    lblNetProfit.numberOfLines = 0;
    lblNetProfit.lineBreakMode = NSLineBreakByWordWrapping;
    
    txtNetProfit = [[OAI_TextField alloc] initWithFrame:CGRectMake(vCalcInputs.frame.size.width - 250, 110.0, 200.0, 30.0)];
    txtNetProfit.text = @"30%";
    txtNetProfit.textAlignment = NSTextAlignmentRight;
    txtNetProfit.delegate = self;
    txtNetProfit.tag = 302;
    
    UIButton* btnNetProfitHelp = [UIButton buttonWithType:UIButtonTypeInfoDark];
    //reset the frame
    CGRect netProfitBtnFrame = btnNetProfitHelp.frame;
    netProfitBtnFrame.origin.x = txtNetProfit.frame.origin.x + txtNetProfit.frame.size.width + 10.0;
    netProfitBtnFrame.origin.y = txtNetProfit.frame.origin.y;
    netProfitBtnFrame.size.width = 30.0;
    netProfitBtnFrame.size.height = 30.0;
    btnNetProfitHelp.frame = netProfitBtnFrame;
    //action
    [btnNetProfitHelp addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    btnNetProfitHelp.tag = 503;
    
    [vCalcInputs addSubview:btnNetProfitHelp];
    [vCalcInputs addSubview:lblNetProfit];
    [vCalcInputs addSubview:txtNetProfit];
    
    //set up initial down stream revenue
    float netProfit = roundf(9874*.3);
    txtDownstreamRev.text = [NSString stringWithFormat:@"$%.02f", netProfit];
    
    [vCalculatorScreen addSubview:vCalcInputs];
    
    /**********************************
     BREAK EVEN SECTION
     **********************************/
    
    //label
    OAI_Label* lblBreakEvenSection = [[OAI_Label alloc] initWithFrame:CGRectMake(20.0, vCalcInputs.frame.origin.y + vCalcInputs.frame.size.height + 40.0, vCalculatorScreen.frame.size.width, 30.0)];
    lblBreakEvenSection.text = @"Results:";
    lblBreakEvenSection.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblBreakEvenSection.font = [UIFont fontWithName:@"Helvetica-Bold" size: 18.0];
    [vCalculatorScreen addSubview:lblInputSection];
    
    //wrapper
    UIView* vResults = [[UIView alloc] initWithFrame:CGRectMake(20.0, lblBreakEvenSection.frame.origin.y + lblBreakEvenSection.frame.size.height, vCalculatorScreen.frame.size.width-40, 100.0)];
    vResults.backgroundColor = [colorManager setColor:186.0 :209.0 :254.0];
    vResults.layer.borderWidth = 1.0;
    vResults.layer.borderColor = [colorManager setColor:19.0 :43.0 :40.0].CGColor;
    
    //
    NSString* strProcedureCount = @"Number of Procedures Required to Break Even (on capital cost):";
    CGSize procedureCountSize = [strProcedureCount sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
    
    OAI_Label* lblProcedureCount = [[OAI_Label alloc] initWithFrame:CGRectMake(10.0, 10.0, procedureCountSize.width, 30.0)];
    lblProcedureCount.text = strProcedureCount;
    lblProcedureCount.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblProcedureCount.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    lblProcedureCount.numberOfLines = 0;
    lblProcedureCount.lineBreakMode = NSLineBreakByWordWrapping;
    [vResults addSubview:lblProcedureCount];
    
    lblProcedureResult = [[OAI_Label alloc] initWithFrame:CGRectMake(vResults.frame.size.width-150.0, 10.0, 130.0, 30.0)];
    lblProcedureResult.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblProcedureResult.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    [vResults addSubview:lblProcedureResult];
    
    NSString* strWeekCount = @"Weekly Procedure Volume Necessary to Break Even:";
    CGSize weekCountSize = [strWeekCount sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
    
    OAI_Label* lblWeekCount = [[OAI_Label alloc] initWithFrame:CGRectMake(10.0, 60.0, weekCountSize.width, 30.0)];
    lblWeekCount.text = strWeekCount;
    lblWeekCount.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblWeekCount.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    lblWeekCount.numberOfLines = 0;
    lblWeekCount.lineBreakMode = NSLineBreakByWordWrapping;
    [vResults addSubview:lblWeekCount];
    
    lblWeekResult = [[OAI_Label alloc] initWithFrame:CGRectMake(vResults.frame.size.width-150.0, 60.0, 130.0, 30.0)];
    lblWeekResult.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblWeekResult.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    [vResults addSubview:lblWeekResult];
    
    //add email button
    UIImage* imgEmail = [UIImage imageNamed:@"btnEmail.png"];
    CGSize imgEmailSize = imgEmail.size;
    
    UIButton *btnEmail = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEmail setImage:imgEmail forState:UIControlStateNormal];
    [btnEmail setImage:imgEmail forState:UIControlStateHighlighted];
    
    CGRect btnEmailFrame = btnEmail.frame;
    btnEmailFrame.origin.x = (self.view.frame.size.width - imgEmailSize.width)-20.0;
    btnEmailFrame.origin.y = vResults.frame.origin.y + vResults.frame.size.height + 10.0;
    btnEmailFrame.size.width = imgEmailSize.width;
    btnEmailFrame.size.height = imgEmailSize.height;
    btnEmail.frame = btnEmailFrame;
    
    [btnEmail addTarget:self action:@selector(showEmailOptions:) forControlEvents:UIControlEventTouchUpInside];
    btnEmail.tag = 601;
    [vCalculatorScreen addSubview:btnEmail];
    
    OAI_Label* lblEmail = [[OAI_Label alloc] initWithFrame:CGRectMake(btnEmail.frame.origin.x+20.0, (btnEmail.frame.origin.y+btnEmail.frame.size.height)+5.0, 100.0, 30.0)];
    lblEmail.text = @"Email Results";
    lblEmail.textColor = [colorManager setColor:8 :16 :123];
    lblEmail.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    lblEmail.backgroundColor = [UIColor clearColor];
    lblEmail.textAlignment = NSTextAlignmentRight;
    [vCalculatorScreen addSubview:lblEmail];
    
    [vCalculatorScreen addSubview:lblBreakEvenSection];
    [vCalculatorScreen addSubview:vResults];
    
    /**********************************
     NOTES
     **********************************/
    
    //add the assumptions disclosure button
    UIButton* btnNotes = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    CGRect btnNotesFrame = btnNotes.frame;
    btnNotesFrame.origin.x = 20.0;
    btnNotesFrame.origin.y = self.view.frame.size.height-180;
    btnNotes.frame = btnNotesFrame;
    [btnNotes addTarget:self action:@selector(showNotes:) forControlEvents:UIControlEventTouchUpInside];
    [vCalculatorScreen addSubview:btnNotes];
    
    //tap gesture
    UITapGestureRecognizer *notesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNotes:)];
    
    //make a  tap gesture enabled label, the user can click to display the notes
    OAI_Label* lblNotes = [[OAI_Label alloc] initWithFrame:CGRectMake(btnNotes.frame.origin.x + btnNotes.frame.size.width + 10.0, btnNotes.frame.origin.y, self.view.frame.size.width-40.0, 30.0)];
    lblNotes.text = @"Notes, Assumptions and References";
    lblNotes.textColor = [colorManager setColor:8 :16 :123];
    lblNotes.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    lblNotes.backgroundColor = [UIColor clearColor];
    lblNotes.userInteractionEnabled = YES;
    //add the gesture
    [lblNotes addGestureRecognizer:notesTap];
    [vCalculatorScreen addSubview:lblNotes];
    
    webNotesSheet = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0.0, 600.0, 1000.0)];
    [webNotesSheet.layer setShadowColor:[UIColor blackColor].CGColor];
    [webNotesSheet.layer setShadowOpacity:0.8];
    [webNotesSheet.layer setShadowRadius:3.0];
    [webNotesSheet.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    webNotesSheet.backgroundColor = [UIColor whiteColor];
    webNotesSheet.alpha = .9;
    
    OAI_Label* lblWebNotesSheet = [[OAI_Label alloc] initWithFrame:CGRectMake(20.0, 20.0, webNotesSheet.frame.size.width-40.0, 30.0)];
    lblWebNotesSheet.text = @"Notes, Assumptions and References";
    lblWebNotesSheet.textColor = [colorManager setColor:8 :16 :123];
    lblWebNotesSheet.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    lblWebNotesSheet.backgroundColor = [UIColor clearColor];
    [webNotesSheet addSubview:lblWebNotesSheet];
    
    webNotes = [[UIWebView alloc] initWithFrame:CGRectMake(20.0, 70.0, webNotesSheet.frame.size.width-40.0, webNotesSheet.frame.size.height-240.0)];
    webNotes.backgroundColor = [UIColor whiteColor];
    [webNotes loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"notes" ofType:@"html"]isDirectory:NO]]];
    webNotes.tag = 422;
    webNotes.layer.borderWidth = 1.0;
    [webNotesSheet addSubview:webNotes];
    
    UIImage* imgCloseWinNormal = [UIImage imageNamed:@"btnCloseNormal.png"];
    UIImage* imgCloseWinHightlight = [UIImage imageNamed:@"btnCloseHighlight.png"];
    CGSize btnImgSize = imgCloseWinNormal.size;
    
    UIButton* btnCloseSheet = [[UIButton alloc] initWithFrame:CGRectMake((webNotesSheet.frame.size.width/2)-(btnImgSize.width/2), webNotes.frame.origin.y + webNotes.frame.size.height + 10, btnImgSize.width, btnImgSize.height)];
    [btnCloseSheet setImage:imgCloseWinNormal forState:UIControlStateNormal];
    [btnCloseSheet setImage:imgCloseWinHightlight forState:UIControlStateHighlighted];
    [btnCloseSheet addTarget:self action:@selector(closeNotes:) forControlEvents:UIControlEventTouchUpInside];
    [webNotesSheet addSubview:btnCloseSheet];
    
    [vCalculatorScreen addSubview:webNotesSheet];
    
    //calculate initial results
    [self calculateResults:@"Annual and weekly procedures"];
    
    //add calculator screen
    [self.view addSubview:vCalculatorScreen];
    
    /*************************************
     EMAIL OPTIONS SCREEN
     *************************************/
    
    vMailOptions = [[UIView alloc] initWithFrame:CGRectMake(0.0, -550.0, self.view.frame.size.width, 280.0)];
    vMailOptions.backgroundColor = [UIColor whiteColor];
    [vMailOptions.layer setShadowColor:[UIColor blackColor].CGColor];
    [vMailOptions.layer setShadowOpacity:0.8];
    [vMailOptions.layer setShadowRadius:3.0];
    [vMailOptions.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    //title bar
    UIView* vLblBG = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, vMailOptions.frame.size.width, 40.0)];
    vLblBG.backgroundColor = [colorManager setColor:8 :16 :123];
    
    NSString* strEmailOptionsTitle=  @"Email Options";
    CGSize emailOptionsTitleSize = [strEmailOptionsTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];
    
    OAI_Label* lblEmailOptions = [[OAI_Label alloc] initWithFrame:CGRectMake((vMailOptions.frame.size.width/2)-(emailOptionsTitleSize.width/2), 10.0, emailOptionsTitleSize.width, 30.0)];
    lblEmailOptions.text = strEmailOptionsTitle;
    lblEmailOptions.textColor = [UIColor whiteColor];
    lblEmailOptions.backgroundColor = [UIColor clearColor];
    lblEmailOptions.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    [vLblBG addSubview:lblEmailOptions];
    
    [vMailOptions addSubview:vLblBG];
    
    /*
    //add the labels
    NSString* strCoverLetterOption=  @"Include Cover Letter";
    CGSize coverLetterOptionSize = [strCoverLetterOption sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];
    
    OAI_Label* lblCoverLetterOption = [[OAI_Label alloc] initWithFrame:CGRectMake((vMailOptions.frame.size.width/2)-(coverLetterOptionSize.width/2), lblEmailOptions.frame.origin.y + lblEmailOptions.frame.size.height + 30.0, coverLetterOptionSize.width, 60.0)];
    lblCoverLetterOption.text = strCoverLetterOption;
    lblCoverLetterOption.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblCoverLetterOption.backgroundColor = [UIColor clearColor];
    [vMailOptions addSubview:lblCoverLetterOption];
    
    
    
    //cover letter options
    scCoverLetterOptions = [[UISegmentedControl alloc] initWithItems:segmentedControlItems];
    //reset
    CGRect scCoverLetterFrame = scCoverLetterOptions.frame;
    scCoverLetterFrame.origin.x = ((vMailOptions.frame.size.width/2)-(scCoverLetterFrame.size.width/2));
    scCoverLetterFrame.origin.y = lblCoverLetterOption.frame.origin.y + lblCoverLetterOption.frame.size.height;
    scCoverLetterOptions.frame = scCoverLetterFrame;
    scCoverLetterOptions.selectedSegmentIndex = 0;
    
    [vMailOptions addSubview:scCoverLetterOptions];
    
    
    NSString* strPDFOption=  @"Send As PDF";
    CGSize PDFOptionSize = [strPDFOption sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];
    
    OAI_Label* lblPDFOption = [[OAI_Label alloc] initWithFrame:CGRectMake((vMailOptions.frame.size.width/2)-(PDFOptionSize.width/2), lblEmailOptions.frame.origin.y + lblEmailOptions.frame.size.height + 30.0, PDFOptionSize.width, 60.0)];
    lblPDFOption.text = strPDFOption;
    lblPDFOption.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    lblPDFOption.backgroundColor = [UIColor clearColor];
    [vMailOptions addSubview:lblPDFOption];
     
    
    //our sc butttons
    NSArray* segmentedControlItems = [[NSArray alloc] initWithObjects:@"Yes", @"No", nil];
    
    //pdf  options
    scPDFOptions = [[UISegmentedControl alloc] initWithItems:segmentedControlItems];
    //reset
    CGRect scPDFOptionsFrame = scPDFOptions.frame;
    scPDFOptionsFrame.origin.x = ((vMailOptions.frame.size.width/2)-(scPDFOptionsFrame.size.width/2));
    scPDFOptionsFrame.origin.y = lblEmailOptions.frame.origin.y + lblEmailOptions.frame.size.height;
    scPDFOptions.frame = scPDFOptionsFrame;
    scPDFOptions.selectedSegmentIndex = 0;
    
    [vMailOptions addSubview:scPDFOptions];
     */
    
    //signature
    NSString* strName=  @"Add Your Name";
    
    txtName = [[UITextField alloc] initWithFrame:CGRectMake((vMailOptions.frame.size.width/2)-250.0, lblEmailOptions.frame.origin.y + lblEmailOptions.frame.size.height + 20.0, 500.0, 40.0)];
    txtName.textColor = [colorManager setColor:66.0:66.0:66.];
    txtName.backgroundColor = [UIColor whiteColor];
    txtName.borderStyle = UITextBorderStyleRoundedRect;
    txtName.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    txtName.placeholder = strName;
    txtName.delegate = self;
    txtName.tag = 701;
    [vMailOptions addSubview:txtName];
    
    //signature
    NSString* strFacility = @"Company/Facility Name";
    
    txtFacility = [[UITextField alloc] initWithFrame:CGRectMake((vMailOptions.frame.size.width/2)-250.0, txtName.frame.origin.y + txtName.frame.size.height + 20.0, 500.0, 40.0)];
    txtFacility.textColor = [colorManager setColor:66.0:66.0:66.];
    txtFacility.backgroundColor = [UIColor whiteColor];
    txtFacility.borderStyle = UITextBorderStyleRoundedRect;
    txtFacility.placeholder = strFacility;
    txtFacility.tag = 702;
    txtFacility.delegate = self;
    txtFacility.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    [vMailOptions addSubview:txtFacility];
    
    //buttons
    //submit images
    UIImage* imgSubmitNormal = [UIImage imageNamed:@"btnSubmitNormal.png"];
    UIImage* imgSubmitHighlight = [UIImage imageNamed:@"btnSubmitHighlight.png"];
    
    //get the image sizes
    CGSize imgSubmitNormalSize = imgSubmitNormal.size;
    
    UIButton* btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSubmit setImage:imgSubmitNormal forState:UIControlStateNormal];
    [btnSubmit setImage:imgSubmitHighlight forState:UIControlStateHighlighted];
    
    //reset the button frame
    CGRect btnSubmitFrame = btnSubmit.frame;
    btnSubmitFrame.origin.x = (vMailOptions.frame.size.width/2)-(imgSubmitNormalSize.width+5);
    btnSubmitFrame.origin.y = (txtFacility.frame.origin.y + txtFacility.frame.size.height) + 30.0;
    btnSubmitFrame.size.width = imgSubmitNormalSize.width;
    btnSubmitFrame.size.height = imgSubmitNormalSize.height;
    btnSubmit.frame = btnSubmitFrame;
    
    //add the action
    [btnSubmit addTarget:self action:@selector(saveEmailOptions:) forControlEvents:UIControlEventTouchUpInside];
    //a tag so we can identify it
    btnSubmit.tag = 101;
    [vMailOptions addSubview:btnSubmit];
    
    //submit images
    UIImage* imgCancelNormal = [UIImage imageNamed:@"btnCancelNormal.png"];
    UIImage* imgCancelHighlight = [UIImage imageNamed:@"btnCancelHighlight.png"];
    
    UIButton* btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setImage:imgCancelNormal forState:UIControlStateNormal];
    [btnCancel setImage:imgCancelHighlight forState:UIControlStateHighlighted];
    
    //reset the button frame
    CGRect btnCancelFrame = btnCancel.frame;
    btnCancelFrame.origin.x = (vMailOptions.frame.size.width/2);
    btnCancelFrame.origin.y = (txtFacility.frame.origin.y + txtFacility.frame.size.height) + 30.0;
    btnCancelFrame.size.width = imgSubmitNormalSize.width;
    btnCancelFrame.size.height = imgSubmitNormalSize.height;
    btnCancel.frame = btnCancelFrame;
    
    //add the action
    [btnCancel addTarget:self action:@selector(closeEmailOptions) forControlEvents:UIControlEventTouchUpInside];
    //a tag so we can identify it
    btnCancel.tag = 102;
    [vMailOptions addSubview:btnCancel];
    
    UIView* vMailBand = [[UIView alloc] initWithFrame:CGRectMake(0.0, vMailOptions.frame.size.height-20.0, vMailOptions.frame.size.width, 20.0)];
    vMailBand.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"mailBand.png"]];
    [vMailOptions addSubview:vMailBand];
    
    [self.view addSubview:vMailOptions];
    
    /*************************************
     ALERT SCREEN
     *************************************/
    alertManager = [[OAI_AlertScreen alloc] init];
    
    //set alert view
    CGRect alertFrame = alertManager.frame;
    alertFrame.origin.x = (self.view.frame.size.width/2)-250.0;
    alertFrame.origin.y = 250.0;
    alertFrame.size.width = 500.0;
    alertFrame.size.height = 400.0;
    alertManager.frame = alertFrame;
    
    alertManager.backgroundColor = [UIColor whiteColor];
    alertManager.alpha = 0.0;
    
    [self.view addSubview:alertManager];
    
    /*************************************
     SPLASH SCREEN
     *************************************/
    
    //check to see if we need to display the splash screen
    needsSplash = YES;
    
    if (needsSplash) {
        CGRect myBounds = self.view.bounds;
        appSplashScreen = [[OAI_SplashScreen alloc] initWithFrame:CGRectMake(myBounds.origin.x, myBounds.origin.y, myBounds.size.width, myBounds.size.height)];
        [self.view addSubview:appSplashScreen];
        [appSplashScreen runSplashScreenAnimation];
    }
    
    /***********************************
     ACCOUNT SCREEN
     ***********************************/
    CGRect accountFrame = CGRectMake(100.0, -350.0, 300.0, 350.0);
    accountManager.frame = accountFrame;
    [accountManager buildAccountObjects];
    [self.view addSubview:accountManager];
    [self.view bringSubviewToFront:topBar];
    
}

#pragma mark - Notification Center

- (void) receiveNotification:(NSNotification* ) notification {
    
    if ([[notification name] isEqualToString:@"theMessenger"]) {
        
        NSString* theEvent = [[notification userInfo] objectForKey:@"Event"];
        
        if ([theEvent isEqualToString:@"Close Account Win"]) {
            
            [self.view endEditing:YES];
            
            UIView* vAccount = [[notification userInfo] objectForKey:@"Account View"];
            CGRect vAccountFrame = vAccount.frame;
            vAccountFrame.origin.y = -350.0;
            
            [self animateView:vAccount :vAccountFrame];
        }
        
    }
}

#pragma mark - Show Views
- (void) showView : (UIButton* ) buttonTouched {
    
    [self clearDeck];
    
    UIView* viewToShow;
    UIView* viewToHide;
    
    if (buttonTouched.tag == 10) {
        viewToShow = vSummaryScreen;
        viewToHide = vCalculatorScreen;
    } else {
        viewToShow = vCalculatorScreen;
        viewToHide = vSummaryScreen;
    }
    
    
    [self toggleViews:viewToShow:viewToHide];
    
}

#pragma mark - Toggle Views
- (void) toggleViews : (UIView*) viewToShow : (UIView*) viewToHide {
    
    CGRect viewToShowFrame = viewToShow.frame;
    CGRect viewToHideFrame = viewToHide.frame;
    
    if (viewToShow.tag == 102) {
        
        if (viewToShowFrame.origin.x < 0.0) {
            viewToShowFrame.origin.x = 0.0;
        }
        
        if (viewToHideFrame.origin.x == 0.0) {
            viewToHideFrame.origin.x = self.view.frame.size.width;
        }
        
    } else if (viewToShow.tag == 103) {
        
        if (viewToShowFrame.origin.x >= self.view.frame.size.width) {
            viewToShowFrame.origin.x = 0.0;
        }
        
        if (viewToHideFrame.origin.x == 0.0) {
            viewToHideFrame.origin.x = 0.0-viewToHideFrame.size.width;
        }
        
    }
    
    [self animateView:viewToHide :viewToHideFrame];
    [self animateView:viewToShow :viewToShowFrame];
    
}

- (void) toggleAccount : (UIButton*) btnAccount {
    
    BOOL isShowing = NO;
    
    //reset the frame
    CGRect vAccountFrame = accountManager.frame;
    if (vAccountFrame.origin.y < 0) {
        vAccountFrame.origin.y = 39.0;
        isShowing = YES;
        
    } else {
        vAccountFrame.origin.y = -350.0;
        isShowing = NO;
    }
    
    //if being displayed get the stored data and display it
    if (isShowing) {
        
        NSString* strAccountPlist = @"UserAccount.plist";
        
        NSDictionary* dictAccountData = [fileManager readPlist:strAccountPlist];
        
        //set strings to the data
        NSString* strUserName = [dictAccountData objectForKey:@"User Name"];
        NSString* strUserTitle = [dictAccountData objectForKey:@"User Title"];
        NSString* strUserEmail = [dictAccountData objectForKey:@"User Email"];
        NSString* strUserPhone = [dictAccountData objectForKey:@"User Phone"];
        
        //get the subviews
        NSArray* vAccountSubs = accountManager.subviews;
        
        //loop
        for(int i=0; i<vAccountSubs.count; i++) {
            
            //sniff for text fields
            if ([[vAccountSubs objectAtIndex:i] isMemberOfClass:[UITextField class]]) {
                
                //cast
                UITextField* thisTextField = (UITextField*)[vAccountSubs objectAtIndex:i];
                
                //set contents of text field
                if (thisTextField.tag == 601) {
                    thisTextField.text = strUserName;
                } else if (thisTextField.tag == 602) {
                    thisTextField.text = strUserTitle;
                } else if (thisTextField.tag == 603) {
                    thisTextField.text = strUserEmail;
                } else if (thisTextField.tag == 604) {
                    thisTextField.text = strUserPhone;
                }
                
            }
        }
        
    }
    
    [self animateView:accountManager :vAccountFrame];
}


- (void) clearDeck {
    
    //get all the subviews
    NSArray* mySubViews = self.view.subviews;
    
    //loop
    for(UIView* thisSubView in mySubViews) {
        
        //find the objectWrapper and set alpha to 0.0
        if (thisSubView.tag == 101) {
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
             
                             animations:^{
                                 thisSubView.alpha = 0.0;
                             }
             
                             completion:^ (BOOL finished) {
                             }
             ];
        }
    }
}

- (void) animateView : (UIView* ) thisView : (CGRect) thisFrame {
    
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         thisView.frame = thisFrame;
                     }
     
                     completion:^ (BOOL finished) {
                         
                         if (thisView.tag == 102) {
                             
                             NSArray* thisViewSubViews = thisView.subviews;
                             
                             for(int v=0; v<thisViewSubViews.count; v++) {
                                 
                                 if([[thisViewSubViews objectAtIndex:v] isMemberOfClass:[UITextView class]]) {
                                     
                                     UITextView* thisTextView = (UITextView*)[thisViewSubViews objectAtIndex:v];
                                     CGRect textViewFrame = thisTextView.frame;
                                     textViewFrame.size.height = textViewFrame.size.height + 1.0;
                                     thisTextView.frame = textViewFrame;
                                     
                                 }
                             }
                             
                         }
                     }
     ];
    
}

#pragma mark - Show Info
- (void) showInfo : (UIButton*) infoButton {
    
    //set up the info text
    NSString* infoText;
    
    //set up the close action
    alertManager.closeAction = @"Do Nothing";
    
    //set up the message and title
    if (infoButton.tag == 501) {
        alertManager.titleBarText = @"Cost of EBUS Equipment";
        infoText = @"Insert cost of EBUS capital equipment only.  Use the amount stated on the quote.";
    } else if (infoButton.tag == 502) {
        alertManager.titleBarText = @"Downstream Revenue Per Patient";
        infoText = @"The MUSC study concluded that $9,874  downstream revenue was generated per EBUS patient.  $2,962 is 30% in order to account for the cost of providing care for these patients assuming a 30% overall operating net profit margin. Adjust this amount based on facility data.";
    } else if (infoButton.tag == 503) {
        alertManager.titleBarText = @"Net Profit Margin";
        infoText = @"The recommended default value is 30%.\n\nThis is the percent of the total downstream revenue calculated by MUSC that will be accounted for in this break even equation.\n\nAdjust this percentage up or down based on the estimated net profit margin the hospital expects to generate per patient compared to the $9,874 of downstream revenue per patient calculated by MUSC.";
    }
    
    
    [alertManager showAlert:infoText];
    
}

#pragma mark - Show Notes
- (void) showNotes : (UIGestureRecognizer*) theTap {
    
    webNotesFrame = webNotesSheet.frame;
    webNotesFrame.origin.x = self.view.frame.size.width-600.0;
    
    //check to see if the email screen is visible
    if (vMailOptions.frame.origin.y > 0) {
        [self closeEmailOptions];
    }
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         webNotesSheet.frame = webNotesFrame;
                     }
     
                     completion:^ (BOOL finished) {
                     }
     ];
    
}

- (void) closeNotes : (UIButton*) btnClose {
    
    webNotesFrame = webNotesSheet.frame;
    webNotesFrame.origin.x = self.view.frame.size.width;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         webNotesSheet.frame = webNotesFrame;
                     }
     
                     completion:^ (BOOL finished) {
                     }
     ];
    
}

#pragma mark - Calculator

- (void) calculateResults : (NSString* ) strCalcWhat {
    
    //set up our error ivars
    BOOL hasError = NO;
    NSMutableString* strErrMsg = [[NSMutableString alloc] init];
    
    //check to see what calculations we are making
    if ([strCalcWhat isEqualToString:@"Net Profit Margin"]) {
        
        //validate text field
        if (txtNetProfit.text.length == 0 || [txtNetProfit.text isEqualToString:NULL]) {
            hasError = YES;
            [strErrMsg appendString:@"You must enter a number for the \nNet Profit Margin entry.\n\n"];
        }
        
        if (hasError) {
            
            alertManager.closeAction = @"Do Nothing";
            alertManager.titleBarText = @"Warning: Results Error!";
            [alertManager showAlert:strErrMsg];
            
        } else {
            
            //get the value entered for the net profit
            NSString* strNetProfit = txtNetProfit.text;
            
            //strip the % symbol
            NSString * strNetProfitCleaned = [strNetProfit stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [strNetProfit length])];
            
            //convert to a number
            float netProfitPercentage = [strNetProfitCleaned floatValue]/100;
            
            //dump into an array to send to our NSDecimal convertor
            NSArray* arrDownStreamMultipliers = [[NSArray alloc] initWithObjects:@"9874", [NSString stringWithFormat:@"%f", netProfitPercentage], nil];
            
            //convert to a NSDecimal
            NSDecimalNumber* decDownstreamRevnue = [self convertToNSDecimalNumber:arrDownStreamMultipliers];
            
            //convert to currency string & display
            txtDownstreamRev.text = [self convertToCurrencyString:decDownstreamRevnue];
            
            [self calculateResults:@"Annual and Weekly Procedures"];
            
        }
    
    } else {
        
        if (txtEBUSQuote.text.length == 0 || [txtEBUSQuote.text isEqualToString:NULL]) {
            hasError = YES;
            [strErrMsg appendString:@"You must enter a number for the EBUS quote entry.\n\n"];
        }
        
        if (txtDownstreamRev.text.length == 0 || [txtDownstreamRev.text isEqualToString:NULL]) {
            hasError = YES;
            [strErrMsg appendString:@"You must enter a number for the \nDownstream Revenue entry.\n\n"];
        }

        if (hasError) {
            
            alertManager.closeAction = @"Do Nothing";
            alertManager.titleBarText = @"Warning: Results Error!";
            [alertManager showAlert:strErrMsg];
            
        } else {
            
            //now that we have the downstream revenue we can get the number of procedures required to break even (annual)
            
            //get the ebus quote
            NSString* strEBUSQuote = txtEBUSQuote.text;
            
            //strip any symbols from it
            NSString* strEBUSQuoteCleaned = [strEBUSQuote stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [strEBUSQuote length])];
            
            //convert to a decimal number
            NSArray* arrEBUSMultipliers = [[NSArray alloc] initWithObjects:strEBUSQuoteCleaned, @"1", nil];
            NSDecimalNumber* decEBUSQuote = [self convertToNSDecimalNumber:arrEBUSMultipliers];
            
            //get the downstream revenue number
            NSString* strDownstreamRevnue = txtDownstreamRev.text;
            
            //strip any symbols from it
            NSString* strDownstreamRevenueCleaned = [strDownstreamRevnue stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [strDownstreamRevnue length])];
            
            //convert to a decimal number
            NSArray* arrDownstreamMultipliers = [[NSArray alloc] initWithObjects:strDownstreamRevenueCleaned, @"1", nil];
            NSDecimalNumber* decDownstreamRevenue = [self convertToNSDecimalNumber:arrDownstreamMultipliers];
            
            //divide quote/by revenue to get annual number of procedures
            float annualProcedures = [decEBUSQuote floatValue]/[decDownstreamRevenue floatValue];
            
            //display the annual procedures
            lblProcedureResult.text = [NSString stringWithFormat:@"%.2f", annualProcedures];
            
            //and how many procedures a week needed
            float weeklyProcedures = annualProcedures/52;
            
            lblWeekResult.text = [NSString stringWithFormat:@"%.2f", weeklyProcedures];
        }
                
    }
       
}

- (NSDecimalNumber*) convertToNSDecimalNumber : (NSArray*) itemsToMultiply {
    
    //get items from array
    NSString* percentage = [itemsToMultiply objectAtIndex:1];
    NSString* valueToGetPercentageFrom = [itemsToMultiply objectAtIndex:0];
    
    //convert strings to NSDecimal
    NSDecimalNumber* decPercentage = [[NSDecimalNumber alloc] initWithString:percentage];
    NSDecimalNumber* decValueToGetFrom = [[NSDecimalNumber alloc] initWithString: valueToGetPercentageFrom];
    
    //get our results
    NSDecimalNumber* decAnswer = [decValueToGetFrom decimalNumberByMultiplyingBy:decPercentage
        withBehavior:myDecimalHandler];
    
    return decAnswer;

}

- (NSString*) convertToCurrencyString : (NSDecimalNumber*) numberToConvert {
    
    //convert to string
    NSString* currencyString = [NSNumberFormatter localizedStringFromNumber:numberToConvert numberStyle:NSNumberFormatterCurrencyStyle];
    
    return currencyString;
    
}

- (NSString*) stripDollarSign : (NSString*) stringToStrip {
    
    //check to see if the number is already formatted correctly
    NSRange dollarSignCheck = [stringToStrip rangeOfString:@"$"];
    //only strip it if it has the $
    if (dollarSignCheck.location != NSNotFound) {
        
        NSString* cleanedString = [stringToStrip substringWithRange:NSMakeRange(1, stringToStrip.length-1)];
        return cleanedString;
    }
    
    return 0;
    
}

#pragma mark - Email Data
- (void) showEmailOptions : (UIButton*) btnEmail {
    
    //check to see if the user has set up account info
    NSString* strAccountPlist = @"UserAccount.plist";
    NSDictionary* dictUserAccount = [fileManager readPlist:strAccountPlist];
    
    NSString* strUserName;
    
    //if account has data get user name
    if (dictUserAccount) {
        strUserName = [dictUserAccount objectForKey:@"User Name"];
    }
    
    //if the user has stored his name
    if (strUserName.length > 0) {
        
        //get the vMailOptions sub views
        NSArray* arrMailOptionSubs = vMailOptions.subviews;
        
        //loop
        for(int i=0; i<arrMailOptionSubs.count; i++) {
            
            //make sure it is a text field
            if([[arrMailOptionSubs objectAtIndex:i] isMemberOfClass:[UITextField class]]) {
                
                //cast
                UITextField* thisTextField = (UITextField*)[arrMailOptionSubs objectAtIndex:i];
                
                //check tag
                if (thisTextField.tag == 701) {
                    
                    thisTextField.text = strUserName;
                }
            }
        }
    }
    
    CGRect vMailOptionsFrame = vMailOptions.frame;
    vMailOptionsFrame.origin.y = 40.0;
    
    //show mail options page
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         vMailOptions.frame = vMailOptionsFrame;
                     }
     
                     completion:^ (BOOL finished) {
                     }
     ];
    
}

- (void) saveEmailOptions : (UIButton*) btnSubmit {
    
    if (scPDFOptions.selectedSegmentIndex == 0) {
        isPDF = YES;
    } else {
        isPDF = NO;
    }
    
    userMessage = txtEmailMessage.text;
    userName = txtName.text;
    clientFacility = txtFacility.text;
    
    //get results
    [self emailResults];
    
}

- (void) emailResults {
    
    //init results dict
    NSMutableDictionary* dictResults = [[NSMutableDictionary alloc] init];
    
    isEmailValid = YES;
    NSMutableString* errMsg = [[NSMutableString alloc] init];
    
    //validate results
    if ([lblProcedureResult.text intValue] == 0 || [lblWeekResult.text floatValue] == 0.0) {
        isEmailValid = NO;
        [errMsg appendString:@"There was a problem with your results, please check your entries in the input section and make sure there is a value entered for each one.\n\n"];
    }
    
    
    if ([clientFacility isEqualToString:@""] || clientFacility == nil || clientFacility.length == 0) {
        isEmailValid = NO;
        [errMsg appendString:@"You must enter a facility name in the email set up screen."];
    }
    
    if (!isEmailValid) {
        alertManager.closeAction = @"Do Nothing";
        alertManager.titleBarText = @"Mail Error!";
        
        [alertManager showAlert:errMsg];
        
    } else {
        
        //get all the information entered and calculated
        NSString* procedureCount = [NSString stringWithFormat:@"Number of Procedures Required To Break Even (On Capital Cost):<br /><b>%@</b>", lblProcedureResult.text];
        NSString* weekCount = [NSString stringWithFormat:@"Weekly Procedure Volume Necessary To Break Even:<br /><b>%@</b>", lblWeekResult.text];
        
        NSString* equipmentQuote = [NSString stringWithFormat:@"Total Cost of EBUS Equipment From Quote:<br /><b>%@</b>", txtEBUSQuote.text];
        NSString* downstreamRevenue = [NSString stringWithFormat:@"Amount of Downstream Revenue  Generated Per Patient:<br /><b>%@</b>", txtDownstreamRev.text];
        NSString* netProfit = [NSString stringWithFormat:@"Percent Of Net Profit Generated From Downstream Procedures:<br /><b>%@</b>", txtNetProfit.text];
        
        //add data to dictResults
        [dictResults setObject:lblProcedureResult.text forKey:@"Procedure Count"];
        [dictResults setObject:lblWeekResult.text forKey:@"Week Count"];
        [dictResults setObject:txtEBUSQuote.text forKey:@"Equipment Quote"];
        [dictResults setObject:txtDownstreamRev.text forKey:@"Downstream Revenue"];
        [dictResults setObject:txtNetProfit.text forKey:@"Net Profit"];
        
        NSMutableString* emailBody = [[NSMutableString alloc] init];
        
        [emailBody appendString:[NSString stringWithFormat:@"<p style=\"font-weight: 900; font-size: 20px; margin: 0 0 20px 0; color:#08107B\">EBUS Break Even Results For %@</p><div style=\"color: #666; font-size: 18px; font-weight: 200; font-family: Helvetica, Arial, sans-serif\"", clientFacility]];
        
        [emailBody appendString:[NSString stringWithFormat:@"<p>Investing in Olympus technology is an important decision. Investing smarter in today's economy is a necessary one. That's why we've developed the Olympus EBUS Break Even Calculator. EBUS can be a compelling business proposition and major addition to your existing portfolio. In an effort to assist our current and prospective customers with their own analyses, Olympus has developed a flexible EBUS Break Even Calculator. Please keep in mind the following Olympus points when performing your analysis:</p><ul><li>The EU-ME1 is Olympus' most versatile processor</li><li>Olympus quality is backed by 510K FDA regulations</li><li>Flexible financial options are available and can be tailored to meet your needs</li><li>Olympus University offers accredited training courses</li><li>Olympus offers 24/7 technical support</li><li>Our customers can utilize web portals for repair history and equipment information</li><li>Our broad Field Support Team is available to serve your needs</ul></p></p>This calculator illustrates how EBUS can help to improve the planning and budgeting process as well as generate a prospective return based on specific investment, cost and revenue assumptions.  All relevant information to your current business situation has been included. Remember, this tool is designed to be flexible and to take into account your unique situation in terms of procedure volume, revenue, costs and the value of Olympus services that you plan to utilize going forward.</p><p>Thank you for your time and interest in Olympus' products and solutions. At Olympus, we appreciate the opportunity to partner with our customers to provide the most advanced and efficient care to your patients.  We look forward to doing business with you.</p><p>Best Regards,</p><p>%@</p><p>Olympus Endoscopy Account Manager</p>", userName]];
        
        //add the calculations
        [emailBody appendString:[NSString stringWithFormat:@"<div style=\"margin: 0 0 20px 0; padding: 20px 5px 5px 5px; border: 1px solid #666; background:#FCFCD4;\"><p>%@</p>", equipmentQuote]];
        [emailBody appendString:[NSString stringWithFormat:@"<p>%@</p>", downstreamRevenue]];
        [emailBody appendString:[NSString stringWithFormat:@"<p>%@</p></div>", netProfit]];
        [emailBody appendString:[NSString stringWithFormat:@"<div style=\"margin: 0 0 20px 0; padding: 20px 5px 5px 5px; border: 1px solid #666; background:#BAD1FE;\"><p>%@</p>", procedureCount]];
        [emailBody appendString:[NSString stringWithFormat:@"<p>%@</p></div>", weekCount]];
        [emailBody appendString:[NSString stringWithFormat:@"</div>"]];
        
        //check to see if we are attaching a PDF
        pdfTitle = [NSString stringWithFormat:@"ebusBreakEvenResults_%@.pdf", clientFacility];
        pdfManager.strTableTitle = clientFacility;
        [pdfManager makePDF:pdfTitle:dictResults];
        
        //check to make sure the app can send email
        if ([MFMailComposeViewController canSendMail]) {
            
            //init a mail view controller
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            
            
            NSArray* bccRecipients = [[NSArray alloc] initWithObjects:@"steve.suranie@olympus.com", nil];
            [mailViewController setBccRecipients:bccRecipients];
            
            //set delegate
            mailViewController.mailComposeDelegate = self;
            
            [mailViewController setSubject:[NSString stringWithFormat:@"EBUS Break Even Results For %@", clientFacility]];
            
            [mailViewController setMessageBody:emailBody isHTML:YES];
            
            if (isPDF) {
                
                //get path to pdf file
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                NSString* pdfFilePath = [documentsDirectory stringByAppendingPathComponent:pdfTitle];
                
                //convert pdf file to NSData
                NSData* pdfData = [NSData dataWithContentsOfFile:pdfFilePath];
                
                //attach the pdf file
                [mailViewController addAttachmentData:pdfData mimeType:@"application/pdf" fileName:pdfTitle];
                
            }
            
            //close the window
            [self closeEmailOptions];
            
            [self presentViewController:mailViewController animated:YES completion:NULL];
            
        } else {
            
            NSLog(@"Device is unable to send email in its current state.");
            
        }
        
    }
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    switch (result){
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email was sent");
            break;
            
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed");
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
            
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
            
        default:
            NSLog(@"Mail not sent");
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void) closeEmailOptions {
    
    [self.view endEditing:YES];
    
    CGRect vMailOptionsFrame = vMailOptions.frame;
    vMailOptionsFrame.origin.y = -550.0;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
     
                     animations:^{
                         vMailOptions.frame = vMailOptionsFrame;
                     }
     
                     completion:^ (BOOL finished) {
                     }
     ];
    
}

#pragma mark - TextField Methods

- (void)textFieldDidEndEditing:(OAI_TextField *)textField {
    
    
    
    [textField resignFirstResponder];
    
    BOOL isValid; 
    
    //net profit (percentage)
    if (textField.tag == 302) {
    
        //get first character and see if it is a number or $
        BOOL isPercentSymbol = NO;
        NSString* strPercentage;
        
        // Create the predicate
        NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"SELF endswith %@", @"%"];
        isPercentSymbol = [myPredicate evaluateWithObject:textField.text];
        
        
        //check to see if the entry is numeric
        if (!isPercentSymbol) {
            NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
            NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:textField.text];
            
            isValid = [alphaNums isSupersetOfSet:inStringSet];
            
            if (!isValid) {
                strPercentage = @"0.0%";
            } else {
                strPercentage = [NSString stringWithFormat:@"%@%%", textField.text];
            }
            
            textField.text = strPercentage;
        }
        
        [self calculateResults:@"Net Profit Margin"];
    
    } else if (textField.tag == 300 || textField.tag == 301) {
        
        //check to see if the user put in decimal points, strip string of point and following items
        NSString* strWorkingString;
        if([textField.text rangeOfString:@"."].location != NSNotFound) {
            strWorkingString = [textField.text substringWithRange:NSMakeRange(0, [textField.text rangeOfString:@"."].location)];
        } else {
            strWorkingString = textField.text;
        }
        
        //invoke NSScanner to clean the string of any other non-numeric characters ($, %, etc.)
        NSScanner* scanner = [NSScanner scannerWithString:strWorkingString];
        NSCharacterSet* numbers = [NSCharacterSet
                                   characterSetWithCharactersInString:@"0123456789"];
        NSMutableString* strippedString = [NSMutableString stringWithCapacity:strWorkingString.length];
        
        while ([scanner isAtEnd] == NO) {
            NSString* buffer;
            if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
                [strippedString appendString:buffer];
                
            } else {
                [scanner setScanLocation:([scanner scanLocation] + 1)];
            }
        }
        
        //convert str to decimal
        NSDecimalNumber* decCurrency = [[NSDecimalNumber alloc] initWithString:strippedString];
        
        //convert string to currency
        textField.text = [self convertToCurrencyString:decCurrency];
        
        [self calculateResults:@"EBUS Quote"];
    
    }

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Web View Delegate Methods
- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    
    //get the web view frame
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
    
    //if it is the summary web view determine its bottom position and reset button to calc on that position
    if (aWebView.tag == 420) {
        
        summaryWebViewHeight =  aWebView.frame.origin.x + aWebView.frame.size.height;
        
        CGRect btnSwitchFrame = btnSwitchToCalc.frame;
        btnSwitchFrame.origin.x = (self.view.frame.size.width/2)-(btnCalculatorImg.size.width/2);
        btnSwitchFrame.origin.y = summaryWebViewHeight + 70.0;
        btnSwitchFrame.size.width = btnCalculatorImg.size.width;
        btnSwitchFrame.size.height = btnCalculatorImg.size.height;
        btnSwitchToCalc.frame = btnSwitchFrame;
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

