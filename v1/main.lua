--�����ƶ�������cocos2d ����   
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
--�յ�   
local endItem = { x = 20,y = 49}   
--A_startѰ·������Ѱ·����   
local result = require("src/util/A_start").findPath(startItem,endItem,map)   
---·�����ҵ�   
if(result ~= 0)then   
    var.path = {} --path{}������   
    table.insert(var.path,1,coordinate.getPoint(map,endItem)) -- �����յ�   
    --λ������   
    --������Ҫ���ǲ��ҵ���·�������ǵ���node�����father������·���͵ÿ�����ÿһ������   
    --father���Զ�ָ����һ����㣬���Կ��Ի��ݳ�·��   
    while(result.x)do  
        local item = {x =result.x, y=result.y}   --������item����������·��   
        --coordinate.getPoint()��ת��Ϊcocos2d�����꣬���ھ����ƶ�                 
        table.insert(var.path ,  1 , coordinate.getPoint(map,item))   
        result=result.father   
    end    
    --�ڵ��ƶ���������cocos2d-x �Ľ���ƶ�������Ĳ�Ӱ��   
    Noderun("",var)    
--·�� û�ҵ�   
else  
    print("����ʧ��")   
end  
