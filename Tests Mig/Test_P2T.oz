local
   Pi=3.1415
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
      case X %C'est ok selon l'énoncé
      of H|T then
	 if {IsExtNote H} then
	    true
	 else
	    false
	 end
      else false
      end
   end

%---------------------ZONE DES TRANSFORMATIONS ----------------------

   fun{Transform X}
      case X
      of duration(seconds:S B) then {Duration S B}%appel a la fct duration
      [] stretch(factor:S B) then {Stretch S B}%appel a la fct stretch
      [] drone(note:S amount:B)then {Drone S B}%appel a drone
      [] transpose(semitones:S B)then {Transpose S B}%appel a transpose
      else false
      end
   end

   fun{Stretch Fact Part}   
      local StretchExt in
	 fun {StretchExt Fact EPart}
	    case EPart of nil then nil
	    [] H|T then if {IsExtNote H} then
			   case H of
			      note(name:A duration:B octave:C sharp:D instrument:E) then
			      note(name:H.name duration:Fact*H.duration octave:H.octave sharp:H.sharp instrument:H.instrument)|{StretchExt Fact T}
			   []silence(duration:A) then
			      silence(duration:Fact*A)|{StretchExt Fact T}
			   end	   
			else % H est une liste de note donc on peut lui appliquer stretch
			   {Stretch Fact H}|{Stretch Fact T}          %{List.append {Stretch Fact H} {Stretch Fact T} $ }
			end
	    end%fin case
	 end%fin fct
	 {StretchExt Fact {PartitionToTimedList Part}}
      end%fin du local
   end   

   fun {GetDuration List}
      local Accumulateur in
	 fun{Accumulateur Acc Reste}
	    case Reste
	    of nil then Acc
	    [] H|T then {Accumulateur H.duration+Acc T}
	    end      end %local
	 {Accumulateur 0.0 {PartitionToTimedList List}}
      end
   end

   fun {Duration Sec Part}
      local Fact in
	 Fact = Sec / {GetDuration Part} %doit rendre un float!
	 {Stretch Fact Part}
      end
   end
   fun{Drone Note Amount}
      local Recurs  ExtN in
	 if {IsNote Note} then ExtN = {NoteToExtended Note}
	 else ExtN =  Note end
	 
	 fun {Recurs N}
	    if N =< Amount then
	       ExtN|{Recurs N+1}
	    else %n == amount
	       nil
	    end
	 end %fct
	 {Recurs 1}
      end%local
   end

   fun{Transpose Semiton Part} %Souci si j'ai un silence dans ma part.
      local Recurs in
	 fun{Recurs Reste}
	    case Reste 
	    of H|T then
	       case H
	       of silence(duration:A) then silence(duration:A)|{Recurs T}
	       else {GetNote {GetNumber H}+Semiton}|{Recurs T}
	       end
	    []nil then nil
	    end%Case
	 end%fct
	 {Recurs {PartitionToTimedList Part}}
      end%local
   end%fct

   fun {GetNumber ExtNote}
      case ExtNote.name of 'c' then 
	 if ExtNote.sharp then 2+ 12*(ExtNote.octave-1) % do#
	 else 1 + 12*(ExtNote.octave -1 ) %do
	 end
      [] 'd' then
	 if ExtNote.sharp then 4+ 12*(ExtNote.octave-1)  %re#
	 else  3+ 12*(ExtNote.octave -1 ) %re
	 end
      [] 'e' then
	 5  +12*(ExtNote.octave -1 )%mi (mi # c'est fa)
      [] 'f' then
	 if ExtNote.sharp then 7+ 12*(ExtNote.octave-1)  % fa#
	 else 6 + 12*(ExtNote.octave -1 ) %fa
	 end
      [] 'g' then
	 if ExtNote.sharp then 9+ 12*(ExtNote.octave-1)  % sol#
	 else  8 + 12*(ExtNote.octave -1 ) %sol
	 end
      [] 'a' then
	 if ExtNote.sharp then 11+ 12*(ExtNote.octave-1)  %la#
	 else  10+ 12*(ExtNote.octave -1 ) %la
	 end
      [] 'b' then
	 12 + 12*(ExtNote.octave -1 ) %si
      end
   end

   fun {GetNote I}
      local Tab Oct N IsSharp in
	 fun{IsSharp U}
	    case U
	    of 2 then true
	    [] 4 then true
	    []7 then true
	    []9 then true
	    []11 then true
	    else false
	    end
	 end
	 N = I mod 12 %numéro de la note entre 0 et 11
      %Dièse = N mod 2 % 1 si #
	 Tab = migEtben(0:b 1:c 2:c 3:d 4:d 5:e 6:f 7:f 8:g 9:g 10:a 11:a)
	 Oct = (I div 12)+1
	 note(name:Tab.N duration:1.0 octave:Oct sharp:{IsSharp N} instrument:none)
      end
   end

%----------------------END ZONE DES TRANSFORMATIONS-------------------

   % Translate a note to the extended notation.
   fun{NoteToExtended Note}
      case Note
      of Name#Octave then
	 note(name:Name octave:Octave sharp:true duration:1.0 instrument:none)
      [] Atom then
	 case {AtomToString Atom}
	 of [115 105 108 101 110 99 101] then silence(duration:1.0)
	 [] [_] then
	    note(name:Atom octave:4 sharp:false duration:1.0 instrument:none)
	 [] [N O] then
	    note(name:{StringToAtom [N]}
		 octave:{StringToInt [O]}
		 sharp:false
		 duration:1.0
		 instrument: none)
	 end
      else     Note
	 
      end
   end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun {ChordToExtended Chord}
      case Chord
      of nil then nil
      [] H|T then
	 if {IsExtNote H} then
	    H|{ChordToExtended T}
	 else
	    {NoteToExtended H}|{ChordToExtended T}
	 end
	 
      end
   end

   fun {PartitionToTimedList Partition}
      %NB: Partition est une liste [a1 a2 a3 a4]
      %ai représente soit une note|chord|extendednote|extendedchord|transformation
      local ExtendedPart in

	 fun{ExtendedPart Part}
	    case Part
	    of nil then nil
	    []H|T then
	       if {IsExtChord H} then
		  H|{ExtendedPart T}
	       elseif {IsChord H} then
		  {ChordToExtended H}|{ExtendedPart T}
	       elseif {IsExtNote H} then
		  H|{ExtendedPart T}
	       elseif {IsNote H} then
		  {NoteToExtended H}|{ExtendedPart T}
	       else
		  {Append {Transform H} {ExtendedPart T}}
	       end    
	    end	
	 end
	 {ExtendedPart Partition}
      end
   end

   Partition1 = [b2 b#6 c4 [a#3 b7 c] d#5 stretch([b] factor:1.5)]
in
   %{Browse {PartitionToTimedList Partition1}}
   {Browse {PartitionToTimedList [b2 b#6 stretch([b] factor:1.5)]}}
end
