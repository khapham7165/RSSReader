//
//  SavedTableViewController.h
//  RSSReader
//
//  Created by Kha Pham on 9/25/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SavedTableViewController : UITableViewController
- (IBAction)deleteAllNewsBtnTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *DeleteAllBtn;

@end

NS_ASSUME_NONNULL_END
