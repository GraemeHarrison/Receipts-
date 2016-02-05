//
//  ReceiptTableViewCell.h
//  Receipts++
//
//  Created by Graeme Harrison on 2016-02-04.
//  Copyright © 2016 Graeme Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *noteLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;

@end
