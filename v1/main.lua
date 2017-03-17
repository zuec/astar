--精灵移动方法，cocos2d 方法   
local function Noderun(var,node)   
    if(node.moveNum< table.getn(node.path))then   
        node.moveNum = node.moveNum +1 ;                  
        node.layer:getChildByTag(100):runAction(cc.Sequence:create(   
            cc.MoveTo:create(Soldier.speed,node.path[node.moveNum]),cc.CallFunc:create(Noderun,node)))                                   
    else      
        node.moveNum = 0;   
    end   
end        
    
local startItem = { x = 5,y = 57}      
--终点   
local endItem = { x = 20,y = 49}   
--A_start寻路，调用寻路方法   
local result = require("src/util/A_start").findPath(startItem,endItem,map)   
---路径查找到   
if(result ~= 0)then   
    var.path = {} --path{}先清零   
    table.insert(var.path,1,coordinate.getPoint(map,endItem)) -- 插入终点   
    --位置数组   
    --这里重要，是查找到的路径，还记的在node定义的father变量吗，路径就得靠它，每一个结点的   
    --father属性都指向下一个结点，所以可以回溯出路径   
    while(result.x)do  
        local item = {x =result.x, y=result.y}   --把所有item连起来解释路径   
        --coordinate.getPoint()是转换为cocos2d的坐标，用于精灵移动                 
        table.insert(var.path ,  1 , coordinate.getPoint(map,item))   
        result=result.father   
    end    
    --节点移动，这里是cocos2d-x 的结点移动，不会的不影响   
    Noderun("",var)    
--路径 没找到   
else  
    print("查找失败")   
end  
