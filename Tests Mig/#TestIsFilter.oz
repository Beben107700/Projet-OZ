local
   fun {IsSamples Part}
      if {List.is Part} then
	 if {Float.is Part.1} then
	    true
	 else
	    false
	 end
      else
	 false % ATTEntion il faut gérer quand liste est vide
      end
   end

   fun {IsPartition Part}
      if {List.is Part} then
	 if {IsExtChord Part.1} orelse {IsExtNote Part.1}orelse  {IsNote Part.1}orelse {IsChord Part.1} orelse{IsTrans Part.1} then
	    true
	 else
	    false
	 end
      else
	 false
      end
   end

   fun {IsWave Part}
      {String.is Part.1}
   end

   fun {IsMerge Part}
      case Part
      of merge(1:Liste) then
	 case Liste.1
	 of P#M then
	    {Float.is P}
	 else
	    false
	 end
      else false
      end
      
      
   end

   fun{IsNote X}
      if{Tuple.is X}then true
      elseif {Atom.is X}then true
      else false
      end
   end

   fun{IsExtNote X}
      if{Record.is X} then
	 case X
	 of note(name:A octave:B sharp:C duration:D instrument:E) then true
	 [] silence(duration:D) then true
	 else false
	 end
      else
	 false
      end  
   end
   fun{IsChord X} %ATTENTION SI IL RECOIT UNE PARTITION IL ENVOIE TRUE
      case X
      of H|T then
	 if {IsNote H} then
	    true
	 else
	    false
	 end
      else false
      end
   end
   fun{IsExtChord X} 
      case X %C'est ok selon l'enonce
      of H|T then
	 if {IsExtNote H} then
	    true
	 else
	    false
	 end
      else false
      end
   end
   fun{IsTrans X}
      if{Record.is X}then
	 case X
	 of duration(seconds:S B) then true %%ATTANTION On ne verifie pas si B est une partition
	 [] stretch(factor:S B) then true
	 [] drone(note:S amount:B)then true
	 [] transpose(semitones:S B)then true
	 else false
	 end
      else false
      end
   end

   fun{IsFilter Filter}
      case Filter of nil then true
      [] repeat(amout:I M) then true
      [] loop(duration:D M) then true
      [] clip(low:S1 high:S2 M) then true
      [] echo(delay:D1 decay:D2 M) then true
      [] fade(start:D1 out:D2 M) then true
      [] cut(start:D1 finish:D2 M) then true
      [] reverse(M) then true
      else
	 false
	 
      end
      
   end


   S =[1.0 0.34 0.87]
   P1 =[[note(name:a octave:4 sharp:true duration:1.0 instrument:none) note(namec:a octave:4 sharp:false duration:1.0 instrument:none) ]]
   P2 = [drone(note:a amount:2)]
   W = wave("hjbj")
   F = repeat(amout:1 4)

   Music1 = [1.0 0.34 0.87]
   Music2 = [1.0 0.34 0.87]
   M = merge([0.5#Music1 0.2#Music2])

in
   {Browse 'Wave 3'}
   {Browse {IsWave S}}
   {Browse {IsWave P2}}
   {Browse {IsWave W}}
   {Browse {IsWave M}}
   {Browse {IsWave F}}
   {Browse 'Samples 1'}
   {Browse {IsSamples S}}
   {Browse {IsSamples P2}}
   {Browse {IsSamples W}}
   {Browse {IsSamples M}}
   {Browse {IsSamples F}}
   {Browse 'Partitio 2n'}
   {Browse {IsPartition S}}
   {Browse {IsPartition P2}}
   {Browse {IsPartition W}}
   {Browse {IsPartition M}}
   {Browse {IsPartition F}}
   {Browse 'Merge 4'}
   {Browse {IsMerge S}}
   {Browse {IsMerge P2}}
   {Browse {IsMerge W}}
   {Browse {IsMerge M}}
   {Browse {IsMerge F}}
   {Browse 'Filter 5'}
   {Browse {IsFilter S}}
   {Browse {IsFilter P2}}
   {Browse {IsFilter W}}
   {Browse {IsFilter M}}
   {Browse {IsFilter F}}
   

end