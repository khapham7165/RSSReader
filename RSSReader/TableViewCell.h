//
//  TableViewCell.h
//  RSSReader
//
//  Created by Kha Pham on 9/24/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *IMG;

@end

NS_ASSUME_NONNULL_END
