declare IsTrans Transform IsNote IsExtNote IsChord IsExtChord Stretch NoteToExtended ChordToExtended PartitionToTimedList Mix Drone
   % See project statement for API details.
 %  [Project] = {Link ['Project2018.ozf']}
  % Time = {Link ['x-oz://boot/Time']}.1.getReferenceTime

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%bien le bonsoir
%%%%

%%J'ai 3 litres de lait

fun{IsTrans X}
   if{Record.is X}then
      case X
      of duration(seconds:S B) then true %%ATTANTION On ne verifie pas si B est une partition
      [] stretch(factor:S B) then true
      [] drone(note:S amount:B)then true
      []transpose(semitones:S B)then true
      else false
      end
   else false
   end
end

fun{Transform X}
   case X
   of duration(seconds:S B) then {Duration S B}%appel a la fct duration
   [] stretch(factor:S B) then {Stretch B S}%appel a la fct stretch
   [] drone(note:S amount:B)then {Drone S B}%appel a drone
   [] transpose(semitones:S B)then true%appel a transpose
   else false
   end
end

{Browse {Drone a 5}}
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
      else false
      end
   else
      false
   end
   
end

fun{IsChord X} %ATTENTION SI IL RECOIT UNE PARTITION IL ENVOIE TRUE
   case X %C'est ok selon l'�nonc�
   of H|T then
      if {IsNote H} then
	 true
      elseif {IsExtNote H} then
	 true
      else
	 false
      end
   else false
   end
end

fun{IsExtChord X} 
   case X %C'est ok selon l'�nonc�
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

fun{Stretch Fact Part}   
   local StretchExt ExtPart in
      ExtPart = {PartitionToTimedList Part}

      
      fun {StretchExt Fact EPart}
	 case EPart of nil then nil
	 [] H|T then if {IsExtNote H} then
			note(name:H.name duration:Fact*H.duration octave:H.octave sharp:H.sharp instrument:H.instrument)|{StretchExt Fact T}	
		     elseif {IsExtChord H} then % H est une liste de note donc on peut lui appliquer stretch
			{Stretch Fact H}|{Stretch Fact T}
		     else
			{Stretch Fact T} % ni note ni chord => transormation, on passe � l'element suivant
		     end%fin du if
	 end%fin case
      end%fin fct

      
      {StretchExt Fact ExtPart}
   end%fin du local
end   


		      
		      
		      
     

fun {Duration Sec Part}
   local Fact in
      Fact = Sec/{GetDuration Part}
      {Stretch Fact Part}
   end
end

fun {GetDuration Part}
   local GetDur in
      fun {GetDur EPart}
	 case EPart of nil then nil
	 [] H|T then
	    if {IsExtNote H} then
	       H.duration + {GetDur T}
	    elseif {IsExtChord H} then
	       {GetDur H}+{GetDur T}
	    else % ni note ni chord => transformation,on passe � l'�l�ment suivant
	       {GetDur T}
	    end
	 end
      end
      {GetDur {PartitionToTimedList Part}}
   end
end
fun{Drone Note Amount}
	local Recurs  ExtN in
		if {IsNote Note} then ExtN = {NoteToExtended Note}
		else ExtN = Note end	
		fun {Recurs N}
			if N < Amount then
				Note|{Recurs N+1}
			else %n == amount
				Note|nil
			end
		end %fct
		{Recurs 1}
	end%local
end
	 


%----------------------END ZONE DES TRANSFORMATIONS-------------------

   % Translate a note to the extended notation.
fun{NoteToExtended Note}
   case Note
   of Name#Octave then
      note(name:Name octave:Octave sharp:true duration:1.0 instrument:none)
   [] Atom then
      case {AtomToString Atom}
      of [_] then
	 note(name:Atom octave:4 sharp:false duration:1.0 instrument:none)
      [] [N O] then
	 note(name:{StringToAtom [N]}
	      octave:{StringToInt [O]}
	      sharp:false
	      duration:1.0
	      instrument: none)
      end
   else
      Note
      
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fun {ChordToExtended Chord}
      %Chord est une MOTHERFUKING LISTE H|T
      %On doit renvoyer une MOTHERFUCKING LISTE qui comprend des EXTENDED NOTE
   case Chord
   of nil then nil
   [] H|T then
      {NoteToExtended H}|{ChordToExtended T}
   else
      nil
   end
   
   
end






fun {PartitionToTimedList Partition}
      %NB: Partition est une liste [a1 a2 a3 a4]
      %ai repr�sente soit une note|chord|extendednote|extendedchord|transformation
   local ExtendedPart in
      fun {ExtendedPart Part}
	 case Part of nil then nil
	 [] H|T then
	    if {IsNote H} then {NoteToExtended H}|{ExtendedPart T}
	    elseif {IsExtNote H} then H|{ExtendedPart T}
	    elseif {IsChord H} then {ChordToExtended H}|{ExtendedPart T}
	    elseif {IsExtChord H} then  H|{ExtendedPart T}
	    elseif {IsTrans H} then {List.append {Transform H} {ExtendedPart T} $} %on utilise append car en fin de Transform il y a un nil qu'on ne veut pas
	    else
	       {ExtendedPart T}
	    end%fin du if
	 else
	    nil %WALLAY si c'est rien
	 end%fin du case
      end%fin du local
      {ExtendedPart Partition}
   end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fun {Mix P2T Music}
      % TODO
   %{Project.readFile 'wave/animaux/cow.wav'}
   true
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     % Music = {Project.load 'joy.dj.oz'}
    %  Start

   % Uncomment next line to insert your tests.
   % \insert 'tests.oz'
   % !!! Remove this before submitting.

   %BEN DELCOIGNE A COMMENTE LA LIGNE SUIVANTE
      %Start = {Time}

   % Uncomment next line to run your tests.
   % {Test Mix PartitionToTimedList}

   % Add variables to this list to avoid "local variable used only once"
   % warnings.

      %BEN DELCOIGNE A COMMENTE LA LIGNE SUIVANTE
     % {ForAll [NoteToExtended Music] Wait}

   % Calls your code, prints the result and outputs the result to `out.wav`.
   % You don't need to modify this.

      %BEN DELCOIGNE A COMMENTE LA LIGNE SUIVANTE
      %{Browse {Project.run Mix PartitionToTimedList Music 'out.wav'}}

   % Shows the total time to run your code.
   %{Browse {IntToFloat {Time}-Start} / 1000.0}



