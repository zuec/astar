----����ڵ���   
local  node= class("node")   
--�����ڵ�,x,y��map��item   
function node.create(x,y,map)   
   local myNode={}   
   -- �ڵ���tmx��λ��   
   myNode.x = x;   
   myNode.y = y;   
   ---A start����   
   myNode.g = 0;  --��ǰ�ڵ㵽��ʼ��Ĵ���   
   myNode.h = 0;  --��ǰ����յ�Ĺ���   
   myNode.f = 0;  --f=g+h   
   myNode.moveable = tiled.getMoveable(map,cc.p(x,y))  --�ýڵ��Ƿ������   
      
   myNode.father={} -- ��¼���ڵ�,��������·��     
   return myNode   
end

return node
