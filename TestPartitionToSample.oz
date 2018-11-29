declare SampledPartition N1 Pi SampleNote

N1 = note(name:a ocatve:3 sharp:false duration:1 instrument:none)
Pi = 3.14

      fun {SampledNote ExtNote}
	 local  F A H  Samp Recursive in
	    H = 18 % on fixe le La comme 0 (référence)
	    F = {Pow 2 h/12}
	    Samp = 44100*1      %ExtNote.duration
	    fun {Recursive N}
	       if N =< Samp-1 then
		  0.5*{Sin 2*Pi*F*N/44100}|{Recursive N+1}
	       else
		  nil
	       end
	    end
	    A = {Recursive 0}
	    A
	 end
      end
      
 