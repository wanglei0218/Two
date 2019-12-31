//
//  USERHomeData.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/7/2.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERHomeDataHandel.h"
#import "USERHomeModel.h"

static USERHomeDataHandel *_defaulthandle = nil;

@interface USERHomeDataHandel ()
@property(nonatomic,strong)FMDatabase *fMDB;

@end


@implementation USERHomeDataHandel

+(USERHomeDataHandel *)sharedHomeDataHandel;{
    
    if (_defaulthandle == nil) {
        _defaulthandle = [[USERHomeDataHandel alloc] init];
        
    }
    return _defaulthandle;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_defaulthandle == nil) {
        _defaulthandle = [super allocWithZone:zone];
    }
    return _defaulthandle;
}


-(FMDatabase *)fMDB{
    if (!_fMDB) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"home.sqlite"];
        
        _fMDB = [FMDatabase databaseWithPath:path];
        [self initTable];
    }
    return _fMDB;
}


// 初始化数据表
-(void)initTable{
    
    [_fMDB open];
    
    [_fMDB executeUpdate:@"CREATE TABLE home (id INTEGER PRIMARY KEY AUTOINCREMENT,wupingming TEXT,didian TEXT,shijian TEXT,tedian TEXT,lianxifangshi TEXT,userid TEXT)"];
    
    [_fMDB close];
}

-(void)addOneData:(USERHomeModel *)user
{
    [self.fMDB open];
    
    [self.fMDB executeUpdateWithFormat:@"insert into home (wupingming,didian,shijian,tedian,lianxifangshi,userid) values(%@,%@,%@,%@,%@,%ld)",user.wupingming,user.didian,user.shijian,user.tedian,user.lianxifangshi,user.userid];
    
    [self.fMDB close];
    
}

-(void)deleteDataByID:(int)delID{
    
    [self.fMDB open];
    
    [self.fMDB executeUpdateWithFormat:@"DELETE FROM home WHERE id = %d",delID];
    
    [self.fMDB close];
}

-(NSArray *)getAllDatas{
    
    [self.fMDB open];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    FMResultSet *result = [self.fMDB executeQuery:@"SELECT * FROM home"];
    while ([result next])
    {
        USERHomeModel *model = [[USERHomeModel alloc] init];
        [arr addObject:model];
        
        model.goodsId = [result intForColumnIndex:0];
        model.wupingming = [result stringForColumnIndex:1];
        model.didian = [result stringForColumnIndex:2];
        model.shijian = [result stringForColumnIndex:3];
        model.tedian = [result stringForColumnIndex:4];
        model.lianxifangshi = [result stringForColumnIndex:5];
        model.userid = [result intForColumnIndex:6];
        
    }
    [self.fMDB close];
    
    return [arr copy];
}

-(void)deleteTable{
    [self.fMDB open];
    //如果表格存在 则销毁
    BOOL result1 = [self.fMDB executeUpdate:@"drop table if exists home"];
    
    if (result1 ) {
//        NSLog(@"--------------------删除表1成功");
    } else {
//        NSLog(@"--------------------删除表1失败");
    }
    [self.fMDB close];
}

@end
