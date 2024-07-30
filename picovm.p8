pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

--- ceee vvvw  wwpp pppp
r,y=rnd,12800z=12936q=0x1001w=poke2
x={{3.1,4,0x33b8},{2.4,1,0xfcc},{4,0,0x3c10}}
function g()memcpy(y,z,136)w(y+64,q)w(y+132,q)x[2][3]^^=12
for i=1,#x do
v=x[i]while(v[2]<32)do
d=r({0,1,1,2})if(d>0)w(y+flr(v[2])*2,d==1and v[3]or 0)
v[2]+=v[1]end v[2]-=32 end
y,z=z,y
end
w(12544,384)w(12548,33538)g()music()o=5
::_::if(stat(54)~=o)g()o=stat(54)
flip()goto _