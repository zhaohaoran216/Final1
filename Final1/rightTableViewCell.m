//
//  rightTableViewCell.m
//  Final1
//
//  Created by 张悦心 on 15/7/8.
//  Copyright (c) 2015年 ZHR. All rights reserved.
//

#import "rightTableViewCell.h"
#import "Header.h"
#import "DetailViewController.h"
#import <UIImageView+WebCache.h>

@implementation rightTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
       self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
       self.frame = CGRectMake(0, 0, kRightCellWidth, 90);
    if(self){
         UIImageView *pic = [[UIImageView alloc]initWithFrame:CGRectMake(13, 11, 50, 50)];
        pic.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:pic];
        _pic = pic;
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pic.frame)+8, CGRectGetMinY(pic.frame), kWindowWidth-85, 13)];
        [self.contentView addSubview:nameLabel];
        _nameLabel = nameLabel;
        
        UILabel *saleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pic.frame)+8, CGRectGetMinY(pic.frame)+23, kWindowWidth-85, 10)];
        [self.contentView addSubview:saleLabel];
        _saleLabel = saleLabel;
        
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pic.frame)+8, CGRectGetMinY(pic.frame)+40, kWindowWidth-300, 9)];
        [self.contentView addSubview:priceLabel];
        _priceLabel = priceLabel;
        
        UILabel *num = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width)*0.78, 60, 30, 30)];
        num.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:num];
        _num = num;
        
        UIButton *leftBtn = [[UIButton alloc]init];
        leftBtn.frame = (CGRectMake((self.frame.size.width)*0.65, 60, 25, 25));
        leftBtn.layer.masksToBounds = YES;
        leftBtn.layer.cornerRadius = 13;
        [leftBtn setTitle:@"-" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        //点击左边
        [leftBtn addTarget:self action:@selector(leftBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        leftBtn.layer.borderWidth = 1;
        leftBtn.layer.borderColor = [[UIColor orangeColor]CGColor];
        [self.contentView addSubview:leftBtn];
        leftBtn.hidden = YES;
        _leftBtn = leftBtn;
        
        UIButton *rightBtn = [[UIButton alloc]init];
        rightBtn.frame = (CGRectMake((self.frame.size.width)*0.85, 60, 25, 25));
        rightBtn.layer.masksToBounds = YES;
        rightBtn.layer.cornerRadius = 13;
        [rightBtn setTitle:@"+" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        rightBtn.layer.borderWidth = 1;
        rightBtn.layer.borderColor = [[UIColor orangeColor]CGColor];
        [self.contentView addSubview:rightBtn];
        _rightBtn = rightBtn;
        
        NSMutableDictionary * chooseDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"",@"name",@"",@"gid",@"",@"price",@"",@"quantity", nil];
        _chooseDic = chooseDic;
        
    }
    return  self;
}

- (void)setData:(NSMutableDictionary *)data{
    NSString *temp = [[NSString alloc]init];
    int *intTemp = [data[@"num"]intValue];
    _intTemp = intTemp;

    
    _data = data;
    
    temp = [NSString stringWithFormat:@"%@",data[@"num"]];
    _num.text = temp;
    
    _nameLabel.text = [data objectForKey:@"name"];
    _nameLabel.font = [UIFont boldSystemFontOfSize:14];
    
//    temp = [NSString stringWithFormat:@"%@",data[@"sales"]];
//    _saleLabel.text = temp;
//    _saleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    temp = [NSString stringWithFormat:@"%@",data[@"price"]];
    _priceLabel.text = temp;
    _priceLabel.font = [UIFont boldSystemFontOfSize:14];
    
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"image"]]];
    [_pic sd_setImageWithURL:imageUrl];
    
    //控制是否显示－号
    if ([_num.text   isEqual: @"0"]) {
        _leftBtn.hidden = YES;
    }
    else
        _leftBtn.hidden = NO;
}

-(void)rightBtnSelect:(id)sender{
    //两个按钮之间的数量
    _leftBtn.hidden = NO;
    int temp = [_num.text intValue];
    if(temp == 0){
        [_zL addObject:@"1"];
    }
    _index = _zL.count;
    temp++;
    _num.text =[NSString stringWithFormat:@"%d",temp];
    //存放到本地数组中（刷新后不改变）
    [_data setValue:_num.text forKey:@"num"];
    
    
    //总价label
    float totalTemp = [_bottomPriceLabel.text floatValue];
    totalTemp += [[_data objectForKey:@"price"]floatValue];
    _bottomPriceLabel.text = [NSString stringWithFormat:@"%.1lf",totalTemp];
    
    //跟赵磊交互
    [_chooseDic setObject:_data[@"id"] forKey:@"gid"];
    [_chooseDic setObject:_data[@"name"] forKey:@"name"];
    [_chooseDic setObject:_data[@"num"] forKey:@"quantity"];
    [_chooseDic setObject:_data[@"price"] forKey:@"price"];
//    NSLog(@"%lu",(unsigned long)_zL.count);
//    NSLog(@"%@",_chooseDic);
    [_zL replaceObjectAtIndex:_index-1 withObject:_chooseDic];
    //NSLog(@"%@",_zL[_index-1]);
}

- (void)leftBtnSelect:(id)sender{
    int temp = [_num.text intValue];
    _index = _zL.count;
    if(temp == 1){
        _leftBtn.hidden = YES;
        [_zL removeLastObject];
        _index = _zL.count;
    }
    temp--;
    _num.text =[NSString stringWithFormat:@"%d",temp];
    [_data setObject:_num.text forKey:@"num"];
    
    float totalTemp = [_bottomPriceLabel.text floatValue];
    totalTemp -= [[_data objectForKey:@"price"]floatValue];
    _bottomPriceLabel.text = [NSString stringWithFormat:@"%.1lf",totalTemp];
    
    [_chooseDic setObject:_data[@"num"] forKey:@"quantity"];
//    NSLog(@"%@",_chooseDic);
//     NSLog(@"%lu",(unsigned long)_zL.count);
//     NSLog(@"%@",_zL[_index-1]);
}

- (void)setBottomPriceLabel:(UILabel *)bottomPriceLabel{
    _bottomPriceLabel = bottomPriceLabel;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
