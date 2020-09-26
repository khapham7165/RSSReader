//
//  TableViewController.m
//  RSSReader
//
//  Created by Kha Pham on 9/23/20.
//

#import "TableViewController.h"
#import "DetailViewController.h"
#import "TableViewCell.h"

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
    
    feeds = [[NSMutableArray alloc] init];
    
    //Convert url string to url
    NSURL *url = [NSURL URLWithString:self.rssurl];
    NSLog(@"rssurl: %@ \n", url);
    
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
    if([[[feeds objectAtIndex:indexPath.row] objectForKey:@"imgsrc"]  isEqual: @""]){}
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
        [[segue destinationViewController] setUrl:string];
        string = [feeds[indexPath.row] objectForKey:@"pubDate"];
        [[segue destinationViewController] setDate:string];
        string = [feeds[indexPath.row] objectForKey:@"imgsrc"];
        [[segue destinationViewController] setImgurl:string];
        string = [feeds[indexPath.row] objectForKey:@"title"];
        [[segue destinationViewController] setTitle:string];
    }
}
@end
