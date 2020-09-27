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
    NSManagedObject *item;
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
    
    item = (NSManagedObject *)[results objectAtIndex:indexPath.row];
    
    //set date
    
    cell.dateLabel.text = [item valueForKey:@"date"];
    //set title
    cell.titleLabel.text = [item valueForKey:@"title"];
    
    //set imgurl (some will not have imgurl
    cell.IMG.image = [UIImage imageWithData:[item valueForKey:@"imgdata"]];
    
    //-------------------------------------------------------------------------------------
    
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowSaveSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        //set item for next view
        [[segue destinationViewController] setIndexPath:indexPath];
        item = (NSManagedObject *)[results objectAtIndex:indexPath.row];
        [[segue destinationViewController] setTitle:[item valueForKey:@"title"]];
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
