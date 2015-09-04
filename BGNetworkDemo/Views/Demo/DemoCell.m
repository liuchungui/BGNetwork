//
//  DemoCell.m
//  DemoNetwork
//
//  Created by user on 15/5/13.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "DemoCell.h"
#import "DemoModel.h"

@interface DemoCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end
@implementation DemoCell

- (void)awakeFromNib{
    [super awakeFromNib];
//    self.lineColor = [UIColor redColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)fillCellWithObject:(id)object{
    DemoModel *model = (DemoModel *)object;
    _nameLabel.text = model.name;
    _ageLabel.text = [NSString stringWithFormat:@"年龄:%zd", model.age];
    switch (model.sex) {
        case 1:
            _sexLabel.text = @"男";
            break;
        case 2:
            _sexLabel.text = @"女";
            break;
        case 0:
            _sexLabel.text = @"未知";
            break;
    }
}

@end
