//
//  MPCustomTableViewCell.m
//  MeusPensamentos
//
//  Created by Lame Black Bunny on 29/05/14.
//  Copyright (c) 2014 Lame Black Bunny. All rights reserved.
//

#import "MPCustomTableViewCell.h"

@implementation MPCustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
