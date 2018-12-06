local
  
   Music1 = [partition([a b c d [d f b]])]
   Music2 = [partition([e f [a b3 c] g a3])]
   Music3 = [partition([a b])]
   Music4 = [partition([c d e f g a b [a d]])]
   
   P1 = [a b c d [d f b]]
   P2 = [e f [a b3 c] g a3]
   P4 = [c d e f g a b [a] b]
   P5 =  [c b a]

   Rev =  reverse(Music4) %
   Rep =  repeat(amount:3 Music3) %OK  
   Loo =  loop(duration:5.0 Music3) %OK
   Cli = clip(low:0.3 high:0.7 Music2) %ok
   Ech = echo(delay:2.1 decay:1.5 Music4) %NE MARCHE PAS
   Cut = cut(start:5.0 finish:11.0 Music4)% Ne coupe pas le début
   Fad=  fade(start:3.0 out:5.0 Music4) %OK

   Str = partition([ c c stretch(factor:2.0 P1)])
   Dur = partition([ c c duration(duration:10.0 P1)])
   Dro = partition([ c c drone(note:e amount:4)])
   Tra = partition([c c transpose(semitones:5 P5)])
  
in
   Rev =  reverse(Music4) %
   Rep =  repeat(amount:3 Music3) %OK  
   Loo =  loop(duration:5.0 Music3) %OK
   Cli = clip(low:0.3 high:0.7 Music2) %ok
   Ech = echo(delay:2.1 decay:1.5 Music4) %NE MARCHE PAS
   Cut = cut(start:5.0 finish:11.0 Music4)% Ne coupe pas le début
   Fad=  fade(start:3.0 out:5.0 Music4) %OK

   Str = partition([ c c stretch(factor:2.0 P1)])
   Dur = partition([ c c duration(duration:10.0 P1)])
   Dro = partition([ c c drone(note:e amount:4)])
   Tra = partition([c c transpose(semitones:5 P5)])
  
in
   [Rev Rep Loo Cli Ech Cut Fad Str Dur Dro Tra ]
  
in
   
   
  
end