//
//  SavedRSSTableViewController.m
//  RSSReader
//
//  Created by Kha Pham on 10/4/20.
//

#import "SavedRSSTableViewController.h"
#import "AppDelegate.h"
#import "SaveRSSTableViewCell.h"
#import "TableViewController.h"

@interface SavedRSSTableViewController (){
    NSArray *results;
    NSManagedObjectContext *context;
    AppDelegate *appDelegate;
    
}

@end

@implementation SavedRSSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    results = [appDelegate fetchArrayFromCoreData:@"SavedRSS"];
    
    if(results.count == 0)
    {
        //if no data in core set disable button delete all
        [_delAllBtn setEnabled:NO];
        [_delAllBtn setAlpha:0.5];
    } else {
        //else enable
        [_delAllBtn setEnabled:YES];
        [_delAllBtn setAlpha:1];
        
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return results.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SaveRSSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SavedCell" forIndexPath:indexPath];
    NSManagedObject *item;
    item = (NSManagedObject *)[results objectAtIndex:indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"%@", [item valueForKey:@"name"]];
    cell.url.text = [NSString stringWithFormat: @"URL: %@", [NSString stringWithFormat:@"%@",[item valueForKey:@"url"]]];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showRSS"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *item;
        item = (NSManagedObject *)[results objectAtIndex:indexPath.row];
        NSString *url = [item valueForKey:@"url"];
        [[segue destinationViewController] setRssurl:url];
    }
}

- (IBAction)reloadBtnTap:(id)sender {
    //reload
    [self viewDidLoad];
    [self.tableView reloadData];
}
- (IBAction)delAllBtnTap:(id)sender {
    
    UIAlertController *saveAlert = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Are you sure about that?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveOK = [UIAlertAction actionWithTitle:@"Yup!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        //use funtion wrote in appdelegate
        self->appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [self->appDelegate deleteAllEntities:@"SavedRSS"];
        
        //reload when done deleting
        [self viewDidLoad];
        [self.tableView reloadData];
    }];
    
    UIAlertAction *saveCancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        
    }];
    
    [saveAlert addAction:saveCancel];
    [saveAlert addAction:saveOK];
    
    //show alert
    [self presentViewController:saveAlert animated:YES completion:nil];
}
@end
