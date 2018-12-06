local
  
   
   P1= [a b c d [d f b]]
   P2= [e f [a b3 c] g a3]
   P3= [a b]
   P4= [c d e f g a b [a d]]
  
   Partition = [a a b g a stretch(factor:0.5 [b c5])]
   
in
    %This is a music :)
   [partition([a b c stretch(factor:2.0 P1)])]
  % [partition([a b c duration(factor:1.0 P1)])]
  % [partition([a b c drone(factor:1.0 P1)])]
  % [partition([a b c transpose(factor:1.0 P1)])]
   
  
end