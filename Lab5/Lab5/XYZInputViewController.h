//
//  ViewController.h
//  TextInput
//
//  Created by Michael on 3/21/15.
//  Copyright (c) 2015 Bokun Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XYZInputCompletionHandler)(NSString *quoteText, NSString *authorText);

@interface XYZInputViewController : UIViewController

@property (copy, nonatomic) XYZInputCompletionHandler completionHandler;


@end

