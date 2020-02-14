- [Python 实现阴阳谜题（Yin Yang Puzzle） - 知乎](https://zhuanlan.zhihu.com/p/43207643)
function producer(c::Channel)
   put!(c, "start")
   for n=1:4
       put!(c, 2n)
   end
   put!(c, "stop")
end;

chnl = Channel(producer);
