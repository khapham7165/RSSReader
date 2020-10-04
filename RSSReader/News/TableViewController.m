//
//  TableViewController.m
//  RSSReader
//
//  Created by Kha Pham on 9/23/20.
//

#import "TableViewController.h"
#import "DetailViewController.h"
#import "TableViewCell.h"
#import "AppDelegate.h"

@interface TableViewController (){
    //"things"
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *pubDate;
    NSMutableString *desc;
    NSMutableString *imgsrc;
    NSString *element;
    
    AppDelegate *appDelegate;
    NSArray *results;
    NSManagedObjectContext *context;
}

@end

@implementation TableViewController

@dynamic tableView;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 110;
    
    self->appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self->context = self->appDelegate.persistentContainer.viewContext;
    
    feeds = [[NSMutableArray alloc] init];
    
    //Convert url string to url
    NSURL *url = [NSURL URLWithString:self.rssurl];
    NSLog(@"rssurl: %@ \n", url);
    results = [appDelegate fetchArrayFromCoreData:@"SavedRSS"];
    
    if(results.count > 0){
    //set fav icon
        for(unsigned int i = 0; i < [results count]; i++){
            NSManagedObject *item = (NSManagedObject *)[results objectAtIndex:i];
            //NSLog(@"self url: %@\ncompare : %@", self.url, [item valueForKey:@"url"]);
            if([[item valueForKey:@"url"] isEqualToString: _rssurl]){
                [_favBtn setImage:[UIImage systemImageNamed:@"star.fill"]];
                break;
            }
        }
    } else{
        [_favBtn setImage:[UIImage systemImageNamed:@"star"]];
    }
    
    //parsing
    parser = [[NSXMLParser alloc]initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return feeds.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.titleLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.dateLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
    //NSLog(@"imgsrc: %@", [[feeds objectAtIndex:indexPath.row] objectForKey:@"imgsrc"]);
    if([[[feeds objectAtIndex:indexPath.row] objectForKey:@"imgsrc"]  isEqual: nil]){}
        //cell.IMG.image = [UIImage imageNamed:@"no-img"];
    else
        cell.IMG.image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[[NSURL alloc]initWithString:[[feeds objectAtIndex:indexPath.row] objectForKey:@"imgsrc"]]]];
    return cell;
    
}


#pragma mark - Parsing

-(void)parser:(NSXMLParser *)parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary<NSString *,NSString *> *)attributeDict{
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) { //init "things"
        item = [[NSMutableDictionary alloc] init];
        title = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
        pubDate = [[NSMutableString alloc] init];
        desc = [[NSMutableString alloc] init];
        imgsrc = [[NSMutableString alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"item"]){ //if an item save "things" into item
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:pubDate forKey:@"pubDate"];
        [item setObject:desc forKey:@"description"];
        if ([desc rangeOfString:@"img src=\""].location != NSNotFound) {
            NSRange searchFromRange = [desc rangeOfString:@"img src=\""];
            NSRange searchToRange = [desc rangeOfString:@"\" "];
            [imgsrc appendString:[desc substringWithRange:NSMakeRange(searchFromRange.location+searchFromRange.length, searchToRange.location-searchFromRange.location-searchFromRange.length)]];
        }
        [item setObject:imgsrc forKey:@"imgsrc"];
        
        //copy item into feeds
        [feeds addObject: [item copy]];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //put char into "things"
    if([element isEqualToString:@"title"])
        [title appendString:string];
    else if ([element isEqualToString:@"pubDate"])
        [pubDate appendString:string];
    else if ([element isEqualToString:@"link"])
        [link appendString:string];
    else if ([element isEqualToString:@"description"]){
        [desc appendString:string];
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showWebSegue"]) {
        //copy data into show web view to save if neccessary
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *string = [feeds[indexPath.row] objectForKey:@"link"];
        [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        [[segue destinationViewController] setUrl:string];
        string = [feeds[indexPath.row] objectForKey:@"pubDate"];
        [[segue destinationViewController] setDate:string];
        string = [feeds[indexPath.row] objectForKey:@"imgsrc"];
        [[segue destinationViewController] setImgurl:string];
        string = [feeds[indexPath.row] objectForKey:@"title"];
        [[segue destinationViewController] setTitle:string];
    }
}

//fav button tapped
- (IBAction)favBtnTap:(id)sender {
    //create allert
    //input: name of rss
    //allert for saving
    UIAlertController *favAlert = [UIAlertController alertControllerWithTitle:@"Add RSS to my list!" message:@"Do you want to add this RSS to your list?" preferredStyle:UIAlertControllerStyleAlert];
    
    [favAlert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"RSS Name";
    }];
    
    UIAlertAction *saveOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        NSArray *textfields = favAlert.textFields;
        UITextField *namefield = textfields[0];
        
        if(self->_favBtn.image == [UIImage systemImageNamed:@"star"]){
            
            // Create a new object
            NSManagedObject *newrss = [NSEntityDescription insertNewObjectForEntityForName:@"SavedRSS" inManagedObjectContext:self->context];
            [newrss setValue:self->_rssurl forKey:@"url"];
            [newrss setValue:namefield.text forKey: @"name"];
            // Save the object into core data
            [self->appDelegate saveContext];
            
            //change star to star fill - saved
            [self->_favBtn setImage:[UIImage systemImageNamed:@"star.fill"]];
            NSLog(@"%@ saved!", namefield.text);
        }
        else{
            NSLog(@"not a star");
        }
    }];
    
    UIAlertAction *saveCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        
    }];
    
    [favAlert addAction:saveCancel];
    [favAlert addAction:saveOK];
    
    //allert for unsaving
    
    UIAlertController *removefavAlert = [UIAlertController alertControllerWithTitle:@"Remove RSS from my list!" message:@"Do you want remove this RSS from your list?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *unsaveOK = [UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        NSManagedObject *delItem;
        
        //find index for deleting
        int delIndex = -1;
        for(unsigned int i = 0; i < self->results.count; i++){
            NSManagedObject *item = (NSManagedObject *)[self->results objectAtIndex:i];
            //NSLog(@"self url: %@\ncompare : %@", self.url, [item valueForKey:@"url"]);
            if([[item valueForKey:@"url"] isEqualToString: self->_rssurl]){
                delIndex = i;
                break;
            }
        }
        if(delIndex == -1){
            NSLog(@"Del error");
            [self->_favBtn setImage:[UIImage systemImageNamed:@"star"]];
        }
        else{
            delItem = (NSManagedObject *)[self->results objectAtIndex:delIndex];
            [self->context deleteObject:delItem];
            
            NSError *deleteError = nil;
            
            if (![delItem.managedObjectContext save:&deleteError]) {
                NSLog(@"Unable to delete managed object context.");
                NSLog(@"%@, %@", deleteError, deleteError.localizedDescription);
            }
            
            //set icon back to star - unsave yet!
            [self->_favBtn setImage:[UIImage systemImageNamed:@"star"]];
            
            NSLog(@"RSS deleted");
        }
    }];
    
    [removefavAlert addAction:saveCancel];
    [removefavAlert addAction:unsaveOK];
    
    //show allert
    if(_favBtn.image == [UIImage systemImageNamed:@"star"]){
        [self presentViewController:favAlert animated:YES completion:nil];
    }else{
        self->results =[self->appDelegate fetchArrayFromCoreData:@"SavedRSS"];
        [self presentViewController:removefavAlert animated:YES completion:nil];
    }
    
}
@end
