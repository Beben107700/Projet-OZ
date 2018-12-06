% Ode To Joy
local
   T1 = [si mi fa sol mi silence si mi fa sol mi silence*3
	 si mi fa sol*2 fa re sol*2 fa re si*2 si*2 si si la si do*2 do*2 silence
	   do si la do*2 re*2 silence*2 la sol fa*2 si*2 sol*2 mi*4


   % This is not a music.
in
   % This is a music :)
   %[partition([a stretch(factor:1.0 [a b])])]
   
   [repeat(amount:3 [partition(T1)]) repeat(amount:2 [partition(T2)]) repeat(amount:2 [partition(T3)]) loop(duration:6.0 [partition(Chords)])]
end