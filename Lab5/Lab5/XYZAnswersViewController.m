//
//  XYZAnswersViewController.m
//  TableView
//
//  Created by Michael on 3/21/15.
//  Copyright (c) 2015 Bokun Xu. All rights reserved.
//

#import "XYZAnswersViewController.h"
#import "QuotesModel.h"
#import "XYZInputViewController.h"

@interface XYZAnswersViewController ()
@property (strong, nonatomic) QuotesModel *model;

@end

@implementation XYZAnswersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.model = [[QuotesModel alloc] init];
    self.model = [QuotesModel sharedModel];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.model numberOfQuotes];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AnswerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    NSDictionary *quoteAtIndex = [self.model quoteAtIndex:indexPath.row];
    NSString *quote = quoteAtIndex[@"quote"];
    NSString *author = quoteAtIndex[@"author"];
    
    
    cell.textLabel.text = quote;
    cell.detailTextLabel.text = author;
    //cell.textLabel.text = [self.model quoteAtIndex:indexPath.row];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete from the model
        [self.model removeQuoteAtIndex:indexPath.row];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    XYZInputViewController *inputVC = segue.destinationViewController;
    
    inputVC.completionHandler = ^(NSString *text1, NSString *text2) {
        if (text1 != nil) {
            
//            NSDictionary *newDict = @{
//                                          @"quote" : text1,
//                                          @"author" : text2
//                                          };
            [self.model insertQuote:text1 author:text2 atIndex:0];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    };
}

@end
