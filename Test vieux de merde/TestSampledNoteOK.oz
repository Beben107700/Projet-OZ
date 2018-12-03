declare SampledPartition N1 Pi SampleNote

N1 = note(name:a ocatve:3 sharp:false duration:1 instrument:none)
Pi = 3.14

fun {SampledNote ExtNote}
   local  F A H  Samp Recursive in
      H = 18.0 % on fixe le La comme 0 (reference)
      F = {Pow 2.0 H/12.0}
      Samp = {Float.toInt 44100.0*1.0}     %ExtNote.duration
      fun {Recursive N}
	 if N =< Samp-1 then
	    0.5*{Sin 2.0*Pi*F*{Int.toFloat N}/44100.0}|{Recursive N+1}
	 else
	    nil
	 end
      end
      A = {Recursive 0}
      A
   end
end
{Browse {SampledNote N1}}
