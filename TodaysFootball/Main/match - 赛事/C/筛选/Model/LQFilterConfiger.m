//
//  LQFilterConfiger.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/26.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQFilterConfiger.h"
#import "LQLeagueObj.h"

@implementation LQFilterConfiger

-(NSArray *)selectedOptions
{
    if (!_selectedOptions) {
        _selectedOptions = @[];
    }
    return _selectedOptions;
}


- (id)copyWithZone:(nullable NSZone *)zone
{
    LQFilterConfiger *copy = [[[self class] allocWithZone:zone] init];
    copy.selectedOptions = self.selectedOptions.copy;
    copy.showOptions = self.showOptions.copy;
    copy.page = self.page;
    return copy;
}

-(NSString *)pram
{
    if(self.selectedOptions.count <= 0){
        return @"";
    }
    NSArray *select = [self.selectedOptions valueForKeyPath:@"leagueId"];
    return [NSString stringWithFormat:@"?leagueIds=%@", [select componentsJoinedByString:@","]];
}


#pragma mark  === opration
-(void)check
{
    NSMutableArray *selectedOptions = self.selectedOptions.mutableCopy;

    for (LQLeagueObj *obj in self.selectedOptions) {
        BOOL contains = NO;
        for (LQLeagueObj *showObj in self.showOptions) {
            if ([obj isEqual:showObj]) {
                contains = YES;
                continue;
            }
        }
        if (!contains) {
            [selectedOptions removeObject:obj];
        }
    }
    self.selectedOptions = selectedOptions.copy;
}

-(BOOL)isSelectedObject:(LQLeagueObj *)object
{
    for (LQLeagueObj *obj in self.selectedOptions) {
        if ([obj isEqual:object]) {
            return YES;
        }
    }
    return NO;
}

-(void)selectedObject:(LQLeagueObj *)object
{
    if (!object) {
        return;
    }
    
    LQLeagueObj *selected = nil;
    for (LQLeagueObj *obj in self.selectedOptions) {
        if ([obj isEqual:object]) {
            selected = obj;
            break;
        }
    }
    
    if (selected) {
        [self removeObject:selected];
    }else{
        [self addObject:object];
    }
}

-(void)addObject:(LQLeagueObj *)object
{
    NSMutableArray *arr = self.selectedOptions.mutableCopy;
    [arr addObject:object];
    self.selectedOptions = arr.copy;
}

-(void)removeObject:(LQLeagueObj *)object
{
    if ([self.selectedOptions containsObject:object]) {
        NSMutableArray *arr = self.selectedOptions.mutableCopy;
        [arr removeObject:object];
        self.selectedOptions = arr.copy;
    }
}

@end
