//
//  ViewController.m
//  TextInput
//
//  Created by Michael on 3/21/15.
//  Copyright (c) 2015 Bokun Xu. All rights reserved.
//

#import "XYZInputViewController.h"

@interface XYZInputViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *quoteField;
@property (weak, nonatomic) IBOutlet UITextField *authorField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation XYZInputViewController

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    ITPInputViewControler *inputVC = segue.destinationViewController;
//    
//    inputVC.completionHandler = ^(NSString *text) {
//        if (text != nil) {
//            self.model.secretAnswer = text;
//        }
//        [self dismissViewControllerAnimated:YES completion:nil];
//    };
//}

- (void)viewWillAppear:(BOOL)animated{
    //[super viewWillAppear:<#animated#>];
    [self.quoteField becomeFirstResponder];
    self.saveButton.enabled = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    // Print the text to the console window
    NSLog(@"%@", textField.text);
    
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *changedString = [textField.text stringByReplacingCharactersInRange: range withString: string];
    
    if(textField ==self.quoteField){
        [self validateSaveButtonForText1: changedString ForText2:self.authorField.text];
    }
    else {
        [self validateSaveButtonForText1:changedString ForText2:self.quoteField.text];
    }
    
    // Do no actually replace the text Field's text!
    // Return YES and let UIKit do it
    return YES;
}

- (void) validateSaveButtonForText1: (NSString *) text1 ForText2: (NSString *) text2 {
    self.saveButton.enabled = ([text1 length] > 0) && ([text2 length] > 0);
}

- (IBAction)cancelButtonTapped:(id)sender {
    if (self.completionHandler) {
        self.completionHandler(nil, nil);
    }
}


- (IBAction)saveButtonTapped:(id)sender {
    if (self.completionHandler) {
        self.completionHandler(self.quoteField.text, self.authorField.text);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
