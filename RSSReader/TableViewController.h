//
//  TableViewController.h
//  RSSReader
//
//  Created by Kha Pham on 9/23/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewController : UITableViewController <NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSString* rssurl;



@end

NS_ASSUME_NONNULL_END
