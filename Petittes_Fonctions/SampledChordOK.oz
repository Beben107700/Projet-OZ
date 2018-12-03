declare SampledChord Pi N1 N2 N3
Pi = 3.14
fun {SampledChord ExtChord}
	 local Frequences Recursive Samp SumSinus F in
	    Samp = {Float.toInt 44100.0*1.0}%ExtChord.duration}
	    fun {Frequences EChord}      % renvoie une liste avec les frequence de chaque note de l'accord
	       case EChord of nil then nil
	       [] S|T then
		  {Pow 2.0 {Int.toFloat 18}/12.0}|{Frequences T} %{Int.toFloat {GetNumber S}-{GetNumber {NoteToExtended a4}}}/12.0}|{Frequences T}
	       end
	    end

	    F = {Frequences ExtChord}
	    fun {SumSinus Freq M} % un Ai d'un accord
	       case Freq of nil then 0.0
	       [] S|T then
		  0.5*{Sin 2.0*Pi*S*{Int.toFloat M}}/44100.0+{SumSinus T M}
	       end
	    end
	    fun {Recursive N}% creer la tableau d'echantillions	 
	       if N < Samp-1 then 
		  {SumSinus F N}/{Int.toFloat {List.length F}}|{Recursive N+1}
	       else
		  {SumSinus F N+1}/{Int.toFloat {List.length F}}
	       end
	    end
	    {Recursive 0}
	 end 
      end
N1 = note(name:b ocatve:3 sharp:false duration:1 instrument:none)
N2 = note(name:a ocatve:3 sharp:false duration:1 instrument:none)
N3 = note(name:c ocatve:3 sharp:false duration:1 instrument:none)
{Browse {SampledChord [N1 N2 N3]}}