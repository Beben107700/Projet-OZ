local
  
   
   P1 = [a b c d [d f b]]
   P2 = [e f [a b3 c] g a3]
   P3 = [a b]
   P4 = [c d e f g a b [a] b]
   P5 =  [c b a]
  
   Partition = [a a b g a stretch(factor:0.5 [b c5])]
   
in
    %This is a music :)
  % [partition([a b c stretch(factor:2.0 P1)])]
  % [partition([a b c duration(duration:10.0 P1)])]
  % [partition([a b c drone(note:e amount:4)])]
  % [partition([transpose(semitones:5 P5)])]
   
  
end