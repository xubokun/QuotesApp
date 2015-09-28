//
//  ViewController.m
//  Lab3
//
//  Created by Michael on 2/25/15.
//  Copyright (c) 2015 Bokun Xu. All rights reserved.
//

#import "ViewController.h"
#import "QuotesModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property (strong, nonatomic) QuotesModel *model;

@property (readonly) SystemSoundID soundFileID;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //_model = [[QuotesModel alloc] init];
    self.model = [QuotesModel sharedModel];
    
    //quoteAtIndex:, removeQuoteAtIndex:,
    //insertQuote:atIndex, and insertQuote:author:atIndex
    
//    NSString *soundFilePath = [[NSBundle mainBundle]
//                               pathForResource:@"TaDa" ofType:@"wav"];
//    
//    NSURL *soundURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSString *path = [NSString stringWithFormat:@"%@/tone.mp3",
                      [[NSBundle mainBundle] resourcePath]];
    NSURL *soundURL = [NSURL fileURLWithPath:path];

    // Create audio player object and initialize with URL to sound
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:soundURL error:&error];
    
    [self.audioPlayer prepareToPlay];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_soundFileID);
    
    NSLog(@"Number of quotes: %ld", [self.model numberOfQuotes]);
    [self.model insertQuote:@"If you can not do great things, do small things in a great way." author:@"Napoleon Hill" atIndex:0];
    NSLog(@"Inserting quote. The number of quotes should increase by 1");
    NSLog(@"Number of quotes: %ld", [self.model numberOfQuotes]);
    [self.model removeQuoteAtIndex:0];
    NSLog(@"Removing quote. The number of quotes should decrease by 1");
    NSLog(@"Number of quotes: %ld", [self.model numberOfQuotes]);
    NSDictionary *quoteAtIndex = [self.model quoteAtIndex:0];
    NSString *quote = quoteAtIndex[@"quote"];
    NSString *author = quoteAtIndex[@"author"];
    NSLog(@"Quote at index 0: %@ - %@", quote, author);

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapRecognized:)];
    doubleTap.numberOfTapsRequired = 2;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapRecognized:)];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeGestureRecognized:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeGestureRecognized:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:doubleTap];
    [self.view addGestureRecognizer:singleTap];
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    
    // Only recognize single taps if they're not the first of two
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
}

- (void) singleTapRecognized: (UITapGestureRecognizer *) recognizer {
    NSDictionary *randomQuote = [self.model randomQuote];
    NSString *quote = randomQuote[@"quote"];
    NSString *author = randomQuote[@"author"];
    
    self.quoteLabel.alpha = 0;
    self.authorLabel.alpha = 0;
    self.quoteLabel.text = quote;
    self.authorLabel.text = author;
    
    if (self.quoteLabel.textColor == UIColor.blackColor) {
        self.quoteLabel.textColor = [UIColor colorWithRed:(153.0f/255.0f) green:0.0 blue:0.0 alpha:1.0];
    } else {
        self.quoteLabel.textColor = UIColor.blackColor;
    }
    
    if (self.authorLabel.textColor == UIColor.blackColor) {
        self.authorLabel.textColor = [UIColor colorWithRed:(153.0f/255.0f) green:0.0 blue:0.0 alpha:1.0];
    } else {
        self.authorLabel.textColor = UIColor.blackColor;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        //Fade in the answer
        self.quoteLabel.alpha = 1;
    }];
    
    [UIView animateWithDuration:1.0 animations:^{
        //Fade in the answer
        self.authorLabel.alpha = 1;
    }];

    //NSLog(@"%@", randomQuote);
    NSLog(@"single tap detected");
    // Play sound file
    //AudioServicesPlayAlertSound(self.soundFileID);
    [self.audioPlayer play];

}

- (void) doubleTapRecognized: (UITapGestureRecognizer *) recognizer {
   
    NSDictionary *currentQuote = [self.model currentQuote];
    NSString *quote = currentQuote[@"quote"];
    NSString *author = currentQuote[@"author"];
    
    [self.model insertFavorite:quote author:author atIndex:0];
    
    NSLog(@"double tap detected");
    //AudioServicesPlayAlertSound(self.soundFileID);
    [self.audioPlayer play];
}

- (void) leftSwipeGestureRecognized: (UISwipeGestureRecognizer *) recognizer {
    NSDictionary *prevQuote = [self.model prevQuote];
    NSString *quote = prevQuote[@"quote"];
    NSString *author = prevQuote[@"author"];
    
    self.quoteLabel.alpha = 0;
    self.authorLabel.alpha = 0;
    self.quoteLabel.text = quote;
    self.authorLabel.text = author;
    
    if (self.quoteLabel.textColor == UIColor.blackColor) {
        self.quoteLabel.textColor = [UIColor colorWithRed:(153.0f/255.0f) green:0.0 blue:0.0 alpha:1.0];
    } else {
        self.quoteLabel.textColor = UIColor.blackColor;
    }
    
    if (self.authorLabel.textColor == UIColor.blackColor) {
        self.authorLabel.textColor = [UIColor colorWithRed:(153.0f/255.0f) green:0.0 blue:0.0 alpha:1.0];
    } else {
        self.authorLabel.textColor = UIColor.blackColor;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        //Fade in the answer
        self.quoteLabel.alpha = 1;
    }];
    
    [UIView animateWithDuration:1.0 animations:^{
        //Fade in the answer
        self.authorLabel.alpha = 1;
    }];

    NSLog(@"left swipe detected");
    // Play sound file
    //AudioServicesPlayAlertSound(self.soundFileID);
    [self.audioPlayer play];

}

- (void) rightSwipeGestureRecognized: (UISwipeGestureRecognizer *) recognizer {
    NSDictionary *nextQuote = [self.model nextQuote];
    NSString *quote = nextQuote[@"quote"];
    NSString *author = nextQuote[@"author"];
    
    self.quoteLabel.alpha = 0;
    self.authorLabel.alpha = 0;
    self.quoteLabel.text = quote;
    self.authorLabel.text = author;
    
    if (self.quoteLabel.textColor == UIColor.blackColor) {
        self.quoteLabel.textColor = [UIColor colorWithRed:(153.0f/255.0f) green:0.0 blue:0.0 alpha:1.0];
    } else {
        self.quoteLabel.textColor = UIColor.blackColor;
    }
    
    if (self.authorLabel.textColor == UIColor.blackColor) {
        self.authorLabel.textColor = [UIColor colorWithRed:(153.0f/255.0f) green:0.0 blue:0.0 alpha:1.0];
    } else {
        self.authorLabel.textColor = UIColor.blackColor;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        //Fade in the answer
        self.quoteLabel.alpha = 1;
    }];
    
    [UIView animateWithDuration:1.0 animations:^{
        //Fade in the answer
        self.authorLabel.alpha = 1;
    }];

    NSLog(@"right swipe detected");
    // Play sound file
    //AudioServicesPlayAlertSound(self.soundFileID);
    [self.audioPlayer play];

}


- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        NSDictionary *randomQuote = [self.model randomQuote];
        NSString *quote = randomQuote[@"quote"];
        NSString *author = randomQuote[@"author"];
        
        self.quoteLabel.alpha = 0;
        self.authorLabel.alpha = 0;
        self.quoteLabel.text = quote;
        self.authorLabel.text = author;
        
        if (self.quoteLabel.textColor == UIColor.blackColor) {
            self.quoteLabel.textColor = [UIColor colorWithRed:(153.0f/255.0f) green:0.0 blue:0.0 alpha:1.0];
        } else {
            self.quoteLabel.textColor = UIColor.blackColor;
        }
        
        if (self.authorLabel.textColor == UIColor.blackColor) {
            self.authorLabel.textColor = [UIColor colorWithRed:(153.0f/255.0f) green:0.0 blue:0.0 alpha:1.0];
        } else {
            self.authorLabel.textColor = UIColor.blackColor;
        }
        
        [UIView animateWithDuration:1.0 animations:^{
            //Fade in the answer
            self.quoteLabel.alpha = 1;
        }];
        
        [UIView animateWithDuration:1.0 animations:^{
            //Fade in the answer
            self.authorLabel.alpha = 1;
        }];
        

        NSLog(@"You shook me!");
        // Play sound file
        //AudioServicesPlayAlertSound(self.soundFileID);
        [self.audioPlayer play];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
