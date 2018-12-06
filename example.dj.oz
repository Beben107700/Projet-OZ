% Ode To Joy
local
   T1 = [c5 d5 f5]
   T2 = [stretch(factor:0.7 [c5 d5 f5])]
   T3 = [stretch(factor:0.3 [c5 d5 f5])]
   Chords = [[stretch(factor:0.4 [c5 d5 f5])]]


   % This is not a music.
in
   % This is a music :)
   %[partition([a stretch(factor:1.0 [a b])])]
   
   [repeat(amount:3 [partition(T1)]) repeat(amount:2 [partition(T2)]) repeat(amount:2 [partition(T3)]) loop(duration:6.0 [partition(Chords)])]
end