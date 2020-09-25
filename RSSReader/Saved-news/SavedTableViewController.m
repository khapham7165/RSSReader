//
//  SavedTableViewController.m
//  RSSReader
//
//  Created by Kha Pham on 9/25/20.
//

#import "SavedTableViewController.h"
#import "AppDelegate.h"
#import "TableViewCell.h"

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
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
    //fetch to test
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RSS"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    results = [context executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching RSS objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    else{
        
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
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SavedCell" forIndexPath:indexPath];
    
    //get date from result array------------------------------------------------
    NSMutableString *resultstring = [NSMutableString stringWithFormat:@"%@", [results objectAtIndex:indexPath.row]];
    NSRange searchFromRange = [resultstring rangeOfString:@"date = \""];
    NSRange searchToRange = [resultstring rangeOfString:@"\";\n    imgurl"];
    cell.dateLabel.text = [NSMutableString stringWithFormat:@"%@", [resultstring substringWithRange:NSMakeRange(searchFromRange.location+searchFromRange.length, searchToRange.location-searchFromRange.location-searchFromRange.length)]];
    
    //get title
    searchFromRange = [resultstring rangeOfString:@"title = \""];
    searchToRange = [resultstring rangeOfString:@"\";\n    url"];
    cell.titleLabel.text = [NSMutableString stringWithFormat:@"%@", [resultstring substringWithRange:NSMakeRange(searchFromRange.location+searchFromRange.length, searchToRange.location-searchFromRange.location-searchFromRange.length)]];
    
    //get imgurl (some will not have imgurl
    if ([resultstring rangeOfString:@"imgurl = nil"].location == NSNotFound) {
        searchFromRange = [resultstring rangeOfString:@"imgurl = \""];
        searchToRange = [resultstring rangeOfString:@"\";\n    title"];
        cell.IMG.image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[[NSURL alloc]initWithString:[NSMutableString stringWithFormat:@"%@", [resultstring substringWithRange:NSMakeRange(searchFromRange.location+searchFromRange.length, searchToRange.location-searchFromRange.location-searchFromRange.length)]]]]];
    }
        
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
