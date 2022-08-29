# jct
uint8 NORMAL=0
uint8 LEFT_BRANCHING=1
uint8 RIGHT_BRANCHING=2
uint8 LEFT_MERGING=3
uint8 RIGHT_MERGING=4
uint8 COMPOSITION=5

# lanetype
uint8 STRAIGHT=0
uint8 LEFT_TURN=1
uint8 RIGHT_TURN=2

# lanecfgfg
uint8 PASS=0
uint8 FAIL=1

# Ver 1.00
int32 lnid #lane ID
int32 did  #Dtlane ID 
int32 blid #before
int32 flid #forward lane ID
int32 bnid
int32 fnid #大概同上
int32 jct
int32 blid2
int32 blid3
int32 blid4
int32 flid2
int32 flid3
int32 flid4
int32 clossid
float64 span # 该段车道线的长度
int32 lcnt #同向车道数
int32 lno   #同向车道的编号

# Ver 1.20
int32 lanetype #车道类型 0执行 1 左转 2右转
int32 limitvel #限速
int32 refvel #推荐速度
int32 roadsecid #路段ID
int32 lanecfgfg #是否可以变道
int32 linkwaid
