//
//  SaveRSSTableViewCell.h
//  RSSReader
//
//  Created by Kha Pham on 10/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaveRSSTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *url;

@end

NS_ASSUME_NONNULL_END
