%AUTEURS - Projet 2018-2019 Informatique
%BEN DELCOIGNE 3877 1700 
%MIGUEL LETOR 4941 1700
%Still by DRe
local
   T1 = [c5 d5 f5]
   T2 = [stretch(factor:0.7 [c5 d5 f5])]
   T3 = [stretch(factor:0.3 [c5 d5 f5])]
   Chord1 = [[stretch(factor:0.4 [c5 d5 f5])]]
   Chord2 = [[stretch(factor:0.4 [b4 d5 f5])]]
   Chord3 = [[stretch(factor:0.4 [b4 d5 e5])]]
   L= [repeat(amount:7 [partition(Chord1)]) repeat(amount:4 [partition(Chord2)]) repeat(amount:5 [partition(Chord3)])]


   % This is not a music.
in
   % This is a music :)
   %[partition([a stretch(factor:1.0 [a b])])]
   
   [repeat(amount:2 [partition(T1)]) repeat(amount:2 [partition(T2)]) repeat(amount:2 [partition(T3)]) loop(duration:20.0 L)]
end
