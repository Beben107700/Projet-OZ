local 
   % See project statement for API details.
   [Project] = {Link ['Project2018.ozf']}
   Time = {Link ['x-oz://boot/Time']}.1.getReferenceTime

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%

%%J'ai 3 litres de lait

   fun{IsTransfo X}
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
      of duration(seconds:S B) then %appel a la fct duration
      [] stretch(factor:S B) then %appel a la fct stretch
      [] drone(note:S amount:B)then %appel a drone
      []transpose(semitones:S B)then %appel a transpose
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
	 else false
	 end
	 
      else
	 false
      end
      
   end

   fun{IsChord X} %ATTENTION SI IL RECOIT UNE PARTITION IL ENVOIE TRUE
      case X %C'est ok selon l'énoncé
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

   fun{IsExtChord X} then
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

   fun{Stretch Fact Part}
      
   end
   

%----------------------END ZONE DES TRANSFORMATIONS-------------------
   
   % Translate a note to the extended notation.
   fun {NoteToExtended Note}
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
      local C in
	 C = {NewCell nil}
	 for X in Chord do
	    if {IsExtNote X} then
	       C:= X|@C
	    else
	       C := {NoteToExtended X}|@C
	    end
	    
	 end
      end
   end
   
   
   
   
   
end

fun {PartitionToTimedList Partition}
      %NB: Partition est une liste [a1 a2 a3 a4]
      %ai représente soit une note|chord|extendednote|extendedchord|transformation
   
   local Tlist in 
      Tlist = {NewCell nil} %liste
      for N in Partition do
	 if {IsNote N} then Tlist := {List.append @Tlist {NoteToExtended N} $ }
	 elseif {IsExtNote N} then Tlist := {List.append @Tlist N $}
	 elseif {IsChord N} then Tlist := {List.append @Tlist {ChordToExtended N} $ }
	 elseif {IsExtChord N } then Tlist := {List.append @Tlist N }
	 elseif {IsTrans N }then {Transform N}
	    
	 else
	    skip %%%Si le type de N n'est pas reconnu
	 end %end du if
      end %end du for
      @Tlist
   end%end du local
   
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      fun {Mix P2T Music}
      % TODO
	 {Project.readFile 'wave/animaux/cow.wav'}
      end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      Music = {Project.load 'joy.dj.oz'}
      Start

   % Uncomment next line to insert your tests.
   % \insert 'tests.oz'
   % !!! Remove this before submitting.
   in
      Start = {Time}

   % Uncomment next line to run your tests.
   % {Test Mix PartitionToTimedList}

   % Add variables to this list to avoid "local variable used only once"
   % warnings.
      {ForAll [NoteToExtended Music] Wait}
      
   % Calls your code, prints the result and outputs the result to `out.wav`.
   % You don't need to modify this.
      {Browse {Project.run Mix PartitionToTimedList Music 'out.wav'}}
      
   % Shows the total time to run your code.
      {Browse {IntToFloat {Time}-Start} / 1000.0}
   end