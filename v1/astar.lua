----A startѰ·�㷨   
local  A_start= class("A_start")
local node = require("src/model/node")   
local cost_stargiht =1 ; --ֱ���ƶ�����   
local cost_diag=1.414; --�Խ����ƶ�����   
  
local MapY = 59 --��ͼy�������ֵ   
local MapX = 89 --��ͼx�������ֵ   
     
local _open = {}; --������� 
local _close = {}; --�Կ����   

--����ĳ��Ĺ�ֵ���������Զ���ʵ��   
local function  calculateH(point,endPoint)   
    print(endPoint.x , point.x)   
    ----����������ľ���   
    local x = math.floor(endPoint.x - point.x)  --��ȡ�õ�x���յ�x�ľ���   
    local y = math.floor(endPoint.y - point.y)  --��ȡ�õ�y���յ�y�ľ���   
    local dis =math.abs(x)+math.abs(y)   
    --local dis = math.sqrt(math.pow(x,2)+math.pow(y,2))       
    return dis   
end   
  
---�ж�ĳ���Ƿ���close����   
local function isClose(point)   
    for key, var in ipairs(_close) do  
        if(var.x == point.x and var.y == point.y )then   
           return true  
        end   
    end   
       
    return false  
end   

---�ж�ĳ���Ƿ���open����   
local function isOpen(point)   
    for key, var in ipairs(_open) do  
        if(var.x == point.x and var.y == point.y )then   
           return true  
        end   
    end   
       
    return false  
end   
  
---Ѱ·ס�߼���startPoint��ʼ�㣬endPointΪ�յ㣬mapΪ��ͼ   
function A_start.findPath(startPoint, endPoint, map)   
	_open = {}; --��ʼ��   
  
	_close = {}; --��ʼ��   
       
	--��ʼ��   
	local point = node.create(startPoint.x,startPoint.y,map)   
	point.g = 0     
	point.h = calculateH(point,endPoint)   
	point.f = point.g + point.h   
      
	--��ǰ�ڵ㲻�����յ�   
	while(not(point.x == endPoint.x and point.y == endPoint.y))do     
        ----��ȡ�����������ĵ�   
        local around={}   
        if(point.y > 0)then --��   
            table.insert(around,node.create(point.x,point.y-1,map))   
        end   
        if(point.y < MapY)then --��   
            table.insert(around,node.create(point.x,point.y+1,map))   
        end   
        if(point.x > 0)then --��   
            table.insert(around,node.create(point.x-1,point.y,map))   
        end   
        if(point.x < MapX)then --��   
            table.insert(around,node.create(point.x+1,point.y,map))   
        end   
                
        --�����Χ��   
        for key, var in pairs(around) do  
               
            --����������߻�����close�����Դ˵�   
            if(isClose(var) or (not var.moveable))then   
                 --print("���Ըõ�" .. var.x .. "  " .. var.y)             
            else  
                 --����˵�Ĵ���   
                 local g = cost_stargiht+ point.g    -- Gֵ��ͬ����һ����Gֵ + ����һ��������ĳɱ�             
                 local h = calculateH(var,endPoint)   
                 local f = g + h   
                  --�õ㲻��open�б���   
                 if(not isOpen(var))then   
                    var.g = g;   
                    var.h = h;   
                    var.f = f   
                    var.father = point --ָ�򸸽ڵ�   
                    table.insert(_open,var) -- ��ӵ�open��   
                     
                    --�����open������f�Ƚ�   
                 else  
                      for key1, var1 in ipairs(_open) do  
                           if(var1.x == var.x and var1.y == var.y)then    
                               --if(var1.f>f)then---�����汾��// ���Gֵ����Fֵ   
                              if(var1.g>g)then   
                                   var1.f = f   
                                   var1.g = g   
                                   var1.h = h   
                                   var1.parent = point    
                               end   
                               break  
                           end   
                      end   
                  end   
             end   
         end   
           
        ----��ǰ�ڵ�����һ����ӵ�����close��   
        table.insert(_close,point)   
        --openΪ�գ������ʧ��   
        if(table.getn(_open)== 0)then   
           return 0 ---����ʧ�ܷ���0   
        end   
  
        ---��open��ȥ����С��f��,����open���Ƴ�   
        local max=99999   
        local myKey   
        for key2, var2 in ipairs(_open) do  
            if(var2.f<max)then   
                max = var2.f   
                myKey = key2   
            end   
        end   
        --��_open���Ƴ���ȡ����Сf�ĵ���Ϊ��ʼ��   
        point = table.remove(_open,myKey)      
               
   end   
   return point.father; -- ����·��   
end   
return A_start  
