local
   Tune = [b b c5 d5 d5 c5 b a g g a b]
   End1 = [stretch(factor:1.5 [b]) stretch(factor:0.5 [a]) stretch(factor:2.0 [a])]
   End2 = [stretch(factor:1.5 [a]) stretch(factor:0.5 [g]) stretch(factor:2.0 [g])]
   Interlude = [a a b g a stretch(factor:0.5 [b c5])
                    b g a stretch(factor:0.5 [b c5])
		b a g a stretch(factor:2.0 [d]) ]
   
   
   Music1 = [partition([a stretch(factor:1.0 [a b])])]
   Music2 = [partition([a stretch(factor:1.0 [c d])])]
   Music3 = [partition([a stretch(factor:1.0 [e f])])]
   % This is not a music.
   Partition = [a a b g a stretch(factor:0.5 [b c5])]
in
   % This is a music :)
   %[partition([a stretch(factor:1.0 [a b])])]
   
   [partition(Partition)  merge([0.5#Music1 0.2#Music2 0.3#Music3])]
end