local
   fun {SampledFilter Filtre}
	    case Filtre of nil then nil
	    [] repeat(amout:I M) then 'repeat'
	    [] loop(duration:D M) then 'loop'
	    [] clip(low:S1 high:S2 M) then 'clip'
	    [] echo(delay:D1 decay:D2 M) then 'echo'
	    [] fade(start:D1 out:D2 M) then 'fade'
	    [] cut(start:D1 finish:D2 M) then 'cut'
	    [] reverse(M) then 'reverse'
	    else 'tu es mauvais Jack'
	    end
   end
   M=2
   F1 = repeat(amout:2 M)
   F2 = loop(duration:1 M)
   F3 = clip(low:1 high:1 M)
   F4 = echo(delay:1 decay:1 M)
   F5 = fade(start:1 out:1 M)
   F5 = fade(start:1 out:1 M)
   F6 =  cut(start:1 finish:1 M)
   F7=  reverse(M)
   F6 =  cut(start:1 finish:1 M)
   F7=  reverse(M)
   in
   {Browse {SampledFilter F1}}
   {Browse {SampledFilter F2}}
   {Browse {SampledFilter F3}}
   {Browse {SampledFilter F4}}
   {Browse {SampledFilter F5}}
   {Browse {SampledFilter F6}}
   {Browse {SampledFilter F7}}
   end