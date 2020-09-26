//
//  SavedTableViewController.m
//  RSSReader
//
//  Created by Kha Pham on 9/25/20.
//

#import "SavedTableViewController.h"
#import "AppDelegate.h"
#import "TableViewCell.h"
#import "SaveNewsViewController.h"

@interface SavedTableViewController (){

    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
    NSArray *results;
    
}
@end

@implementation SavedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 110;
    
    //get data from core data through appdelegate function
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    results = [appDelegate fetchArrayFromCoreData:@"RSS"]; //data goes to result
    
    //delete all button handler
    if(results.count == 0)
    {
        //if no data in core set disable button delete all
        [_DeleteAllBtn setEnabled:NO];
        [_DeleteAllBtn setAlpha:0.5];
    } else {
        //else enable
        [_DeleteAllBtn setEnabled:YES];
        [_DeleteAllBtn setAlpha:1];
        
    }
}

-(void)viewDidAppear{
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return results.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SavedCell" forIndexPath:indexPath];
    
    //set things from function in delegate------------------------------------------------
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //set date
    cell.dateLabel.text = [NSMutableString stringWithFormat:@"%@",[appDelegate getStringFromString:[NSMutableString stringWithFormat:@"%@", [results objectAtIndex:indexPath.row]] :@"date = \"" :@"\";\n    imgurl"]];
    
    //set title
    cell.titleLabel.text = [NSMutableString stringWithFormat:@"%@",[appDelegate getStringFromString:[NSMutableString stringWithFormat:@"%@", [results objectAtIndex:indexPath.row]] :@"title = \"" :@"\";\n    url"]];
    
    //set imgurl (some will not have imgurl
    if ([[NSMutableString stringWithFormat:@"%@", [results objectAtIndex:indexPath.row]] rangeOfString:@"imgurl = nil"].location == NSNotFound) {
        cell.IMG.image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[[NSURL alloc]initWithString:[NSMutableString stringWithFormat:@"%@",[appDelegate getStringFromString:[NSMutableString stringWithFormat:@"%@", [results objectAtIndex:indexPath.row]] :@"imgurl = \"" :@"\";\n    title"]]]]];
    }
    //-------------------------------------------------------------------------------------
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowSaveSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        //get url string
        NSString *string = [NSMutableString stringWithFormat:@"%@",[appDelegate getStringFromString:[NSMutableString stringWithFormat:@"%@", [results objectAtIndex:indexPath.row]] :@" url = \"" :@"\";\n})"]];
        
        //set url for next view
        [[segue destinationViewController] setUrl:string];
    }
}


#pragma mark - Buttons setting

- (IBAction)deleteAllNewsBtnTap:(id)sender {
    //alert when delete all button tapped
    UIAlertController *saveAlert = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Are you sure about that?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveOK = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        //use funtion wrote in appdelegate
        self->appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [self->appDelegate deleteAllEntities:@"RSS"];
        
        //reload when done deleting
        [self viewDidLoad];
        [self.tableView reloadData];
    }];
    
    UIAlertAction *saveCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        
    }];
    
    [saveAlert addAction:saveCancel];
    [saveAlert addAction:saveOK];
    
    //show alert
    [self presentViewController:saveAlert animated:YES completion:nil];
    
}

- (IBAction)ReloadBtnTap:(id)sender {
    //reload all when reload button tapped
    [self viewDidLoad];
    [self.tableView reloadData];
}
@end
